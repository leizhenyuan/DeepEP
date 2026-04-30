#include <sycl/sycl.hpp>
#include <Python.h>
#include <string>
#include <sstream>

// Python 绑定函数：返回 SYCL 设备信息
static PyObject* get_device_info(PyObject* self, PyObject* args) {
    try {
        sycl::queue q(sycl::default_selector_v);
        auto device = q.get_device();
        auto platform = device.get_platform();
        
        PyObject* info_dict = PyDict_New();
        
        std::string platform_name = platform.get_info<sycl::info::platform::name>();
        std::string device_name = device.get_info<sycl::info::device::name>();
        std::string vendor = device.get_info<sycl::info::device::vendor>();
        std::string driver_version = device.get_info<sycl::info::device::driver_version>();
        
        PyDict_SetItemString(info_dict, "platform", PyUnicode_FromString(platform_name.c_str()));
        PyDict_SetItemString(info_dict, "device", PyUnicode_FromString(device_name.c_str()));
        PyDict_SetItemString(info_dict, "vendor", PyUnicode_FromString(vendor.c_str()));
        PyDict_SetItemString(info_dict, "driver_version", PyUnicode_FromString(driver_version.c_str()));
        PyDict_SetItemString(info_dict, "max_compute_units", 
                           PyLong_FromLong(device.get_info<sycl::info::device::max_compute_units>()));
        PyDict_SetItemString(info_dict, "max_work_group_size", 
                           PyLong_FromLong(device.get_info<sycl::info::device::max_work_group_size>()));
        PyDict_SetItemString(info_dict, "global_mem_size_mb", 
                           PyLong_FromLong(device.get_info<sycl::info::device::global_mem_size>() / (1024 * 1024)));
        
        return info_dict;
    } catch (sycl::exception const& e) {
        PyErr_SetString(PyExc_RuntimeError, e.what());
        return nullptr;
    }
}

// Python 绑定函数：测试向量加法
static PyObject* test_vector_add(PyObject* self, PyObject* args) {
    int n = 1024;
    if (!PyArg_ParseTuple(args, "|i", &n)) {
        return nullptr;
    }
    
    try {
        sycl::queue q(sycl::default_selector_v);
        
        std::vector<float> a(n, 1.0f);
        std::vector<float> b(n, 2.0f);
        std::vector<float> c(n, 0.0f);
        
        {
            sycl::buffer<float> buf_a(a.data(), sycl::range<1>(n));
            sycl::buffer<float> buf_b(b.data(), sycl::range<1>(n));
            sycl::buffer<float> buf_c(c.data(), sycl::range<1>(n));
            
            q.submit([&](sycl::handler& h) {
                auto acc_a = buf_a.get_access<sycl::access::mode::read>(h);
                auto acc_b = buf_b.get_access<sycl::access::mode::read>(h);
                auto acc_c = buf_c.get_access<sycl::access::mode::write>(h);
                
                h.parallel_for(sycl::range<1>(n), [=](sycl::id<1> idx) {
                    acc_c[idx] = acc_a[idx] + acc_b[idx];
                });
            });
            
            q.wait();
        }
        
        // 验证结果
        for (int i = 0; i < n; ++i) {
            if (std::abs(c[i] - 3.0f) > 1e-5) {
                std::stringstream ss;
                ss << "Verification failed at index " << i << ": expected 3.0, got " << c[i];
                PyErr_SetString(PyExc_RuntimeError, ss.str().c_str());
                return nullptr;
            }
        }
        
        Py_RETURN_TRUE;
    } catch (sycl::exception const& e) {
        PyErr_SetString(PyExc_RuntimeError, e.what());
        return nullptr;
    }
}

// 模块方法定义
static PyMethodDef SyclMethods[] = {
    {"get_device_info", get_device_info, METH_NOARGS, "Get SYCL device information"},
    {"test_vector_add", test_vector_add, METH_VARARGS, "Test SYCL vector addition (optional size parameter)"},
    {nullptr, nullptr, 0, nullptr}
};

// 模块定义
static struct PyModuleDef sycl_module = {
    PyModuleDef_HEAD_INIT,
    "deep_ep_sycl",
    "DeepEP SYCL extension module",
    -1,
    SyclMethods
};

// 模块初始化函数
PyMODINIT_FUNC PyInit_deep_ep_sycl(void) {
    return PyModule_Create(&sycl_module);
}
