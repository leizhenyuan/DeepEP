import os
import subprocess
import setuptools
import importlib
import sys
import torch

from pathlib import Path
from torch.utils.cpp_extension import BuildExtension, CUDAExtension
from setuptools import Extension


# Wheel specific: the wheels only include the soname of the host library `libnvshmem_host.so.X`
def get_nvshmem_host_lib_name(base_dir):
    path = Path(base_dir).joinpath('lib')
    for file in path.rglob('libnvshmem_host.so.*'):
        return file.name
    raise ModuleNotFoundError('libnvshmem_host.so not found')


if __name__ == '__main__':
    disable_nvshmem = False
    nvshmem_dir = os.getenv('NVSHMEM_DIR', None)
    nvshmem_host_lib = 'libnvshmem_host.so'
    if nvshmem_dir is None:
        try:
            nvshmem_dir = importlib.util.find_spec("nvidia.nvshmem").submodule_search_locations[0]
            nvshmem_host_lib = get_nvshmem_host_lib_name(nvshmem_dir)
            import nvidia.nvshmem as nvshmem  # noqa: F401
        except (ModuleNotFoundError, AttributeError, IndexError):
            print(
                'Warning: `NVSHMEM_DIR` is not specified, and the NVSHMEM module is not installed. All internode and low-latency features are disabled\n'
            )
            disable_nvshmem = True
    else:
        disable_nvshmem = False

    if not disable_nvshmem:
        assert os.path.exists(nvshmem_dir), f'The specified NVSHMEM directory does not exist: {nvshmem_dir}'

    cxx_flags = ['-O3', '-Wno-deprecated-declarations', '-Wno-unused-variable', '-Wno-sign-compare', '-Wno-reorder', '-Wno-attributes']
    nvcc_flags = ['-O3', '-Xcompiler', '-O3']
    sources = ['csrc/deep_ep.cpp', 'csrc/kernels/runtime.cu', 'csrc/kernels/layout.cu', 'csrc/kernels/intranode.cu']
    include_dirs = ['csrc/']
    library_dirs = []
    nvcc_dlink = []
    extra_link_args = ['-lcuda']

    # NVSHMEM flags
    if disable_nvshmem:
        cxx_flags.append('-DDISABLE_NVSHMEM')
        nvcc_flags.append('-DDISABLE_NVSHMEM')
    else:
        sources.extend(['csrc/kernels/internode.cu', 'csrc/kernels/internode_ll.cu'])
        include_dirs.extend([f'{nvshmem_dir}/include'])
        library_dirs.extend([f'{nvshmem_dir}/lib'])
        nvcc_dlink.extend(['-dlink', f'-L{nvshmem_dir}/lib', '-lnvshmem_device'])
        extra_link_args.extend([f'-l:{nvshmem_host_lib}', '-l:libnvshmem_device.a', f'-Wl,-rpath,{nvshmem_dir}/lib'])

    if int(os.getenv('DISABLE_SM90_FEATURES', 0)):
        # Prefer A100
        os.environ['TORCH_CUDA_ARCH_LIST'] = os.getenv('TORCH_CUDA_ARCH_LIST', '8.0')

        # Disable some SM90 features: FP8, launch methods, and TMA
        cxx_flags.append('-DDISABLE_SM90_FEATURES')
        nvcc_flags.append('-DDISABLE_SM90_FEATURES')

        # Disable internode and low-latency kernels
        assert disable_nvshmem
    else:
        # Prefer H800 series
        os.environ['TORCH_CUDA_ARCH_LIST'] = os.getenv('TORCH_CUDA_ARCH_LIST', '9.0')

        # CUDA 12 flags
        nvcc_flags.extend(['-rdc=true', '--ptxas-options=--register-usage-level=10'])

    # Disable LD/ST tricks, as some CUDA version does not support `.L1::no_allocate`
    if os.environ['TORCH_CUDA_ARCH_LIST'].strip() != '9.0':
        assert int(os.getenv('DISABLE_AGGRESSIVE_PTX_INSTRS', 1)) == 1
        os.environ['DISABLE_AGGRESSIVE_PTX_INSTRS'] = '1'

    # Disable aggressive PTX instructions
    if int(os.getenv('DISABLE_AGGRESSIVE_PTX_INSTRS', '1')):
        cxx_flags.append('-DDISABLE_AGGRESSIVE_PTX_INSTRS')
        nvcc_flags.append('-DDISABLE_AGGRESSIVE_PTX_INSTRS')

    # Bits of `topk_idx.dtype`, choices are 32 and 64
    if "TOPK_IDX_BITS" in os.environ:
        topk_idx_bits = int(os.environ['TOPK_IDX_BITS'])
        cxx_flags.append(f'-DTOPK_IDX_BITS={topk_idx_bits}')
        nvcc_flags.append(f'-DTOPK_IDX_BITS={topk_idx_bits}')

    # Put them together
    extra_compile_args = {
        'cxx': cxx_flags,
        'nvcc': nvcc_flags,
    }
    if len(nvcc_dlink) > 0:
        extra_compile_args['nvcc_dlink'] = nvcc_dlink

    include_dirs.extend(torch.utils.cpp_extension.include_paths())
    # Summary
    print('Build summary:')
    print(f' > Sources: {sources}')
    print(f' > Includes: {include_dirs}')
    print(f' > Libraries: {library_dirs}')
    print(f' > Compilation flags: {extra_compile_args}')
    print(f' > Link flags: {extra_link_args}')
    print(f' > Arch list: {os.environ["TORCH_CUDA_ARCH_LIST"]}')
    print(f' > NVSHMEM path: {nvshmem_dir}')
    print()

    # Check backend selection
    use_xpu = int(os.getenv('USE_XPU', 0))
    use_cuda = int(os.getenv('USE_CUDA', 1))  # Default to 1 (enabled) for backward compatibility
    ext_modules = []

    # CUDA path: use CUDAExtension
    if use_cuda:
        print('CUDA build enabled')
        ext_modules.append(
            CUDAExtension(name='deep_ep_cpp',
                          include_dirs=include_dirs,
                          library_dirs=library_dirs,
                          sources=sources,
                          extra_compile_args=extra_compile_args,
                          extra_link_args=extra_link_args)
        )
        print()

    # XPU path: use Extension with SYCL compiler
    if use_xpu:
        print('XPU build enabled')
        sycl_compiler = os.getenv('SYCL_CXX', 'icpx')
        
        # Check if SYCL compiler exists
        try:
            subprocess.run([sycl_compiler, '--version'], check=True, capture_output=True)
            print(f' > SYCL compiler: {sycl_compiler}')
            
            sycl_compile_args = ['-fsycl', '-O3', '-DUSE_XPU', '-fsycl-default-sub-group-size=32']
            sycl_link_args = ['-fsycl', '-lze_loader', '-lmpi']
            
            # Add Intel GPU specific optimization flags
            # Both compile and link need the same target specification
            # Configurable AOT targets: set XPU_AOT_TARGETS env var (e.g. 'pvc', 'bmg', 'pvc,bmg')
            xpu_aot_targets = os.getenv('XPU_AOT_TARGETS', 'pvc')
            sycl_compile_args.extend(['-fsycl-targets=spir64_gen', '-Xs', f'-device {xpu_aot_targets}'])
            sycl_link_args.extend(['-fsycl-targets=spir64_gen', '-Xs', f'-device {xpu_aot_targets}'])
            print(f' > XPU AOT targets: {xpu_aot_targets}')
            
            # XPU sources: deep_ep.cpp and SYCL implementations
            xpu_sources = ['csrc/deep_ep.cpp', 'csrc/sycl/layout.cpp', 'csrc/sycl/intranode.cpp', 'csrc/sycl/runtime.cpp']
            
            # Add common compile flags (without CUDA-specific flags)
            xpu_cxx_flags = [flag for flag in cxx_flags if 'DISABLE_NVSHMEM' in flag or 'deprecated' in flag or 'unused' in flag or 'sign-compare' in flag or 'reorder' in flag or 'attributes' in flag]
            sycl_compile_args.extend(xpu_cxx_flags)
            
            import torch
            torch_lib_path = os.path.join(os.path.dirname(torch.__file__), 'lib')
            
            sycl_extension = Extension(
                name='deep_ep_cpp',
                sources=xpu_sources,
                include_dirs=include_dirs,
                library_dirs=[torch_lib_path],
                extra_compile_args=sycl_compile_args,
                extra_link_args=sycl_link_args,
                libraries=['torch_cpu', 'torch', 'torch_python', 'c10'],
                language='c++'
            )
            
            # Override compiler for this extension
            os.environ['CXX'] = sycl_compiler
            ext_modules.append(sycl_extension)
            print(f' > XPU sources: {xpu_sources}')
            print(' > XPU extension added: deep_ep_cpp')
        except (subprocess.CalledProcessError, FileNotFoundError):
            print(f'Warning: SYCL compiler {sycl_compiler} not found, skipping XPU extension')
        print()

    # noinspection PyBroadException
    try:
        cmd = ['git', 'rev-parse', '--short', 'HEAD']
        revision = '+' + subprocess.check_output(cmd).decode('ascii').rstrip()
    except Exception as _:
        revision = ''

    setuptools.setup(name='deep_ep',
                     version='1.2.1' + revision,
                     packages=setuptools.find_packages(include=['deep_ep']),
                     ext_modules=ext_modules,
                     cmdclass={'build_ext': BuildExtension})
