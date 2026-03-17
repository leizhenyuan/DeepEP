
; __CLANG_OFFLOAD_BUNDLE____START__ sycl-spir64_gen-unknown-unknown
; ModuleID = '/workspace2/zhenyuan/DeepEP/csrc/sycl/test_atomic_asm.cpp'
source_filename = "/workspace2/zhenyuan/DeepEP/csrc/sycl/test_atomic_asm.cpp"
target datalayout = "e-i64:64-v16:16-v24:32-v32:32-v48:64-v96:128-v192:256-v256:256-v512:512-v1024:1024-n8:16:32:64-G1"
target triple = "spir64_gen-unknown-unknown"

%"class.sycl::_V1::range" = type { %"class.sycl::_V1::detail::array" }
%"class.sycl::_V1::detail::array" = type { [1 x i64] }
%class.__generated_ = type { ptr addrspace(1) }
%class.__generated_.3 = type { ptr addrspace(1) }
%class.__generated_.5 = type { ptr addrspace(1) }

$_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES6_EUlNS0_2idILi1EEEE_EE = comdat any

$_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_EUlNS0_2idILi1EEEE_ = comdat any

$_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES6_EUlNS0_2idILi1EEEE_EE = comdat any

$_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_EUlNS0_2idILi1EEEE_ = comdat any

$_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EE = comdat any

$_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_EUlNS0_2idILi1EEEE_ = comdat any

@__spirv_BuiltInGlobalInvocationId = external dso_local local_unnamed_addr addrspace(1) constant <3 x i64>, align 32
@__spirv_BuiltInGlobalSize = external dso_local local_unnamed_addr addrspace(1) constant <3 x i64>, align 32

; Function Attrs: convergent mustprogress norecurse nounwind
define dso_local spir_func void @_Z22test_atomic_ref_systemPii(ptr addrspace(4) noundef %ptr, i32 noundef %value) local_unnamed_addr #0 !sycl_fixed_targets !6 {
entry:
  %0 = addrspacecast ptr addrspace(4) %ptr to ptr addrspace(1)
  %call3.i.i = tail call spir_func noundef i32 @_Z18__spirv_AtomicIAddPU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagEi(ptr addrspace(1) noundef %0, i32 noundef 0, i32 noundef 912, i32 noundef %value) #4
  ret void
}

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef i32 @_Z18__spirv_AtomicIAddPU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagEi(ptr addrspace(1) noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: convergent mustprogress norecurse nounwind
define dso_local spir_func void @_Z24test_atomic_fence_systemPii(ptr addrspace(4) noundef captures(none) %ptr, i32 noundef %value) local_unnamed_addr #0 !sycl_fixed_targets !6 {
entry:
  tail call spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef 0, i32 noundef 912) #4
  %0 = load i32, ptr addrspace(4) %ptr, align 4, !tbaa !7
  %add = add nsw i32 %0, %value
  store i32 %add, ptr addrspace(4) %ptr, align 4, !tbaa !7
  tail call spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef 0, i32 noundef 912) #4
  ret void
}

; Function Attrs: convergent nounwind
declare dso_local spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: convergent mustprogress norecurse nounwind
define dso_local spir_func void @_Z15test_fence_onlyv() local_unnamed_addr #0 !sycl_fixed_targets !6 {
entry:
  tail call spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef 0, i32 noundef 912) #4
  ret void
}

; Function Attrs: convergent mustprogress norecurse nounwind
define dso_local spir_func void @_Z23test_atomic_ref_acq_relPii(ptr addrspace(4) noundef %ptr, i32 noundef %value) local_unnamed_addr #0 !sycl_fixed_targets !6 {
entry:
  %0 = addrspacecast ptr addrspace(4) %ptr to ptr addrspace(1)
  %call3.i.i = tail call spir_func noundef i32 @_Z18__spirv_AtomicIAddPU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagEi(ptr addrspace(1) noundef %0, i32 noundef 0, i32 noundef 904, i32 noundef %value) #4
  ret void
}

; Function Attrs: convergent mustprogress norecurse nounwind
define dso_local spir_func void @_Z18test_fence_acq_relv() local_unnamed_addr #0 !sycl_fixed_targets !6 {
entry:
  tail call spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef 0, i32 noundef 904) #4
  ret void
}

; Function Attrs: convergent mustprogress norecurse nounwind
define dso_local spir_func void @_Z15test_atomic_casPii(ptr addrspace(4) noundef %ptr, i32 noundef %value) local_unnamed_addr #0 !sycl_fixed_targets !6 {
entry:
  %0 = addrspacecast ptr addrspace(4) %ptr to ptr addrspace(1)
  %call3.i.i = tail call spir_func noundef i32 @_Z18__spirv_AtomicLoadPU3AS1KiN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagE(ptr addrspace(1) noundef %0, i32 noundef 0, i32 noundef 912) #4
  br label %while.cond

while.cond:                                       ; preds = %while.cond, %entry
  %old_val.0 = phi i32 [ %call3.i.i, %entry ], [ %call4.i.i.i.i, %while.cond ]
  %add = add nsw i32 %old_val.0, %value
  %call4.i.i.i.i = tail call spir_func noundef i32 @_Z29__spirv_AtomicCompareExchangePU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagES5_ii(ptr addrspace(1) noundef %0, i32 noundef 0, i32 noundef 912, i32 noundef 912, i32 noundef %add, i32 noundef %old_val.0) #4
  %cmp.i.i.i.i = icmp eq i32 %call4.i.i.i.i, %old_val.0
  br i1 %cmp.i.i.i.i, label %while.end, label %while.cond

while.end:                                        ; preds = %while.cond
  ret void
}

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef i32 @_Z18__spirv_AtomicLoadPU3AS1KiN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagE(ptr addrspace(1) noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: convergent nounwind
declare dso_local spir_func noundef i32 @_Z29__spirv_AtomicCompareExchangePU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagES5_ii(ptr addrspace(1) noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #1

; Function Attrs: convergent mustprogress norecurse nounwind
define weak_odr dso_local spir_kernel void @_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES6_EUlNS0_2idILi1EEEE_EE(ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_UserRange, ptr noundef byval(%class.__generated_) align 8 %_arg_KernelFunc) local_unnamed_addr #2 comdat !kernel_arg_buffer_location !11 !sycl_fixed_targets !6 !sycl_kernel_omit_args !12 {
entry:
  %0 = load i64, ptr %_arg_UserRange, align 8
  %1 = getelementptr inbounds nuw { i64 }, ptr %_arg_KernelFunc, i64 0, i32 0
  %2 = load i64, ptr %1, align 8, !tbaa !13
  %3 = inttoptr i64 %2 to ptr addrspace(4)
  %4 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalInvocationId, align 32, !noalias !15
  %5 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalSize, align 32, !noalias !24
  %cmp6.not.i.not.i = icmp ult i64 %4, %0
  %6 = addrspacecast ptr addrspace(4) %3 to ptr addrspace(1)
  br label %for.cond.i

for.cond.i:                                       ; preds = %for.body.i, %entry
  %Gen.sroa.0.0.i = phi i64 [ %4, %entry ], [ %spec.select.i, %for.body.i ]
  %Gen.sroa.14.0.i = phi i1 [ %cmp6.not.i.not.i, %entry ], [ %cmp6.i.i, %for.body.i ]
  br i1 %Gen.sroa.14.0.i, label %for.body.i, label %_ZNK4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES6_EUlNS0_2idILi1EEEE_EclES4_.exit

for.body.i:                                       ; preds = %for.cond.i
  %cmp.i.i.i = icmp ult i64 %Gen.sroa.0.0.i, 2147483648
  tail call void @llvm.assume(i1 %cmp.i.i.i)
  %call3.i.i.i.i = tail call spir_func noundef i32 @_Z18__spirv_AtomicIAddPU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagEi(ptr addrspace(1) noundef %6, i32 noundef 0, i32 noundef 912, i32 noundef 1) #4
  %add.i.i = add i64 %Gen.sroa.0.0.i, %5
  %cmp6.i.i = icmp ult i64 %add.i.i, %0
  %spec.select.i = select i1 %cmp6.i.i, i64 %add.i.i, i64 %4
  br label %for.cond.i, !llvm.loop !29

_ZNK4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES6_EUlNS0_2idILi1EEEE_EclES4_.exit: ; preds = %for.cond.i
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #3

; Function Attrs: convergent mustprogress norecurse nounwind
define weak_odr dso_local spir_kernel void @_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_EUlNS0_2idILi1EEEE_(ptr addrspace(1) noundef align 4 %_arg_data) local_unnamed_addr #2 comdat !kernel_arg_buffer_location !31 !sycl_fixed_targets !6 !sycl_kernel_omit_args !32 {
entry:
  %0 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalInvocationId, align 32, !noalias !33
  %cmp.i.i = icmp ult i64 %0, 2147483648
  tail call void @llvm.assume(i1 %cmp.i.i)
  %call3.i.i.i = tail call spir_func noundef i32 @_Z18__spirv_AtomicIAddPU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagEi(ptr addrspace(1) noundef %_arg_data, i32 noundef 0, i32 noundef 912, i32 noundef 1) #4
  ret void
}

; Function Attrs: convergent mustprogress norecurse nounwind
define weak_odr dso_local spir_kernel void @_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES6_EUlNS0_2idILi1EEEE_EE(ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_UserRange, ptr noundef byval(%class.__generated_.3) align 8 %_arg_KernelFunc) local_unnamed_addr #2 comdat !kernel_arg_buffer_location !11 !sycl_fixed_targets !6 !sycl_kernel_omit_args !12 {
entry:
  %0 = load i64, ptr %_arg_UserRange, align 8
  %1 = getelementptr inbounds nuw { i64 }, ptr %_arg_KernelFunc, i64 0, i32 0
  %2 = load i64, ptr %1, align 8, !tbaa !13
  %3 = inttoptr i64 %2 to ptr addrspace(4)
  %4 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalInvocationId, align 32, !noalias !42
  %5 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalSize, align 32, !noalias !51
  %cmp6.not.i.not.i = icmp ult i64 %4, %0
  br label %for.cond.i

for.cond.i:                                       ; preds = %for.body.i, %entry
  %Gen.sroa.0.0.i = phi i64 [ %4, %entry ], [ %spec.select.i, %for.body.i ]
  %Gen.sroa.14.0.i = phi i1 [ %cmp6.not.i.not.i, %entry ], [ %cmp6.i.i, %for.body.i ]
  br i1 %Gen.sroa.14.0.i, label %for.body.i, label %_ZNK4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES6_EUlNS0_2idILi1EEEE_EclES4_.exit

for.body.i:                                       ; preds = %for.cond.i
  %cmp.i.i.i = icmp ult i64 %Gen.sroa.0.0.i, 2147483648
  tail call void @llvm.assume(i1 %cmp.i.i.i)
  tail call spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef 0, i32 noundef 912) #4
  %6 = load i32, ptr addrspace(4) %3, align 4, !tbaa !7
  %add.i.i = add nsw i32 %6, 1
  store i32 %add.i.i, ptr addrspace(4) %3, align 4, !tbaa !7
  tail call spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef 0, i32 noundef 912) #4
  %add.i7.i = add i64 %Gen.sroa.0.0.i, %5
  %cmp6.i.i = icmp ult i64 %add.i7.i, %0
  %spec.select.i = select i1 %cmp6.i.i, i64 %add.i7.i, i64 %4
  br label %for.cond.i, !llvm.loop !56

_ZNK4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES6_EUlNS0_2idILi1EEEE_EclES4_.exit: ; preds = %for.cond.i
  ret void
}

; Function Attrs: convergent mustprogress norecurse nounwind
define weak_odr dso_local spir_kernel void @_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_EUlNS0_2idILi1EEEE_(ptr addrspace(1) noundef align 4 %_arg_data) local_unnamed_addr #2 comdat !kernel_arg_buffer_location !31 !sycl_fixed_targets !6 !sycl_kernel_omit_args !32 {
entry:
  %0 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalInvocationId, align 32, !noalias !57
  %cmp.i.i = icmp ult i64 %0, 2147483648
  tail call void @llvm.assume(i1 %cmp.i.i)
  tail call spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef 0, i32 noundef 912) #4
  %1 = load i32, ptr addrspace(1) %_arg_data, align 4, !tbaa !7
  %add.i = add nsw i32 %1, 1
  store i32 %add.i, ptr addrspace(1) %_arg_data, align 4, !tbaa !7
  tail call spir_func void @_Z21__spirv_MemoryBarrierii(i32 noundef 0, i32 noundef 912) #4
  ret void
}

; Function Attrs: convergent mustprogress norecurse nounwind
define weak_odr dso_local spir_kernel void @_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EE(ptr noundef byval(%"class.sycl::_V1::range") align 8 %_arg_UserRange, ptr noundef byval(%class.__generated_.5) align 8 %_arg_KernelFunc) local_unnamed_addr #2 comdat !kernel_arg_buffer_location !11 !sycl_fixed_targets !6 !sycl_kernel_omit_args !12 {
entry:
  %0 = load i64, ptr %_arg_UserRange, align 8
  %1 = getelementptr inbounds nuw { i64 }, ptr %_arg_KernelFunc, i64 0, i32 0
  %2 = load i64, ptr %1, align 8, !tbaa !13
  %3 = inttoptr i64 %2 to ptr addrspace(4)
  %4 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalInvocationId, align 32, !noalias !66
  %5 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalSize, align 32, !noalias !75
  %cmp6.not.i.not.i = icmp ult i64 %4, %0
  %6 = addrspacecast ptr addrspace(4) %3 to ptr addrspace(1)
  br label %for.cond.i

for.cond.i:                                       ; preds = %_Z15test_atomic_casPii.exit.i, %entry
  %Gen.sroa.0.0.i = phi i64 [ %4, %entry ], [ %spec.select.i, %_Z15test_atomic_casPii.exit.i ]
  %Gen.sroa.14.0.i = phi i1 [ %cmp6.not.i.not.i, %entry ], [ %cmp6.i.i, %_Z15test_atomic_casPii.exit.i ]
  br i1 %Gen.sroa.14.0.i, label %for.body.i, label %_ZNK4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EclES4_.exit

for.body.i:                                       ; preds = %for.cond.i
  %cmp.i.i.i = icmp ult i64 %Gen.sroa.0.0.i, 2147483648
  tail call void @llvm.assume(i1 %cmp.i.i.i)
  %call3.i.i.i.i = tail call spir_func noundef i32 @_Z18__spirv_AtomicLoadPU3AS1KiN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagE(ptr addrspace(1) noundef %6, i32 noundef 0, i32 noundef 912) #4
  br label %while.cond.i.i

while.cond.i.i:                                   ; preds = %while.cond.i.i, %for.body.i
  %old_val.0.i.i = phi i32 [ %call3.i.i.i.i, %for.body.i ], [ %call4.i.i.i.i.i.i, %while.cond.i.i ]
  %add.i.i = add nsw i32 %old_val.0.i.i, 1
  %call4.i.i.i.i.i.i = tail call spir_func noundef i32 @_Z29__spirv_AtomicCompareExchangePU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagES5_ii(ptr addrspace(1) noundef %6, i32 noundef 0, i32 noundef 912, i32 noundef 912, i32 noundef %add.i.i, i32 noundef %old_val.0.i.i) #4
  %cmp.i.i.i.i.i.i = icmp eq i32 %call4.i.i.i.i.i.i, %old_val.0.i.i
  br i1 %cmp.i.i.i.i.i.i, label %_Z15test_atomic_casPii.exit.i, label %while.cond.i.i

_Z15test_atomic_casPii.exit.i:                    ; preds = %while.cond.i.i
  %add.i7.i = add i64 %Gen.sroa.0.0.i, %5
  %cmp6.i.i = icmp ult i64 %add.i7.i, %0
  %spec.select.i = select i1 %cmp6.i.i, i64 %add.i7.i, i64 %4
  br label %for.cond.i, !llvm.loop !80

_ZNK4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EclES4_.exit: ; preds = %for.cond.i
  ret void
}

; Function Attrs: convergent mustprogress norecurse nounwind
define weak_odr dso_local spir_kernel void @_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_EUlNS0_2idILi1EEEE_(ptr addrspace(1) noundef align 4 %_arg_data) local_unnamed_addr #2 comdat !kernel_arg_buffer_location !31 !sycl_fixed_targets !6 !sycl_kernel_omit_args !32 {
entry:
  %0 = load i64, ptr addrspace(1) @__spirv_BuiltInGlobalInvocationId, align 32, !noalias !81
  %cmp.i.i = icmp ult i64 %0, 2147483648
  tail call void @llvm.assume(i1 %cmp.i.i)
  %call3.i.i.i = tail call spir_func noundef i32 @_Z18__spirv_AtomicLoadPU3AS1KiN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagE(ptr addrspace(1) noundef %_arg_data, i32 noundef 0, i32 noundef 912) #4
  br label %while.cond.i

while.cond.i:                                     ; preds = %while.cond.i, %entry
  %old_val.0.i = phi i32 [ %call3.i.i.i, %entry ], [ %call4.i.i.i.i.i, %while.cond.i ]
  %add.i = add nsw i32 %old_val.0.i, 1
  %call4.i.i.i.i.i = tail call spir_func noundef i32 @_Z29__spirv_AtomicCompareExchangePU3AS1iN5__spv5Scope4FlagENS1_19MemorySemanticsMask4FlagES5_ii(ptr addrspace(1) noundef %_arg_data, i32 noundef 0, i32 noundef 912, i32 noundef 912, i32 noundef %add.i, i32 noundef %old_val.0.i) #4
  %cmp.i.i.i.i.i = icmp eq i32 %call4.i.i.i.i.i, %old_val.0.i
  br i1 %cmp.i.i.i.i.i, label %_Z15test_atomic_casPii.exit, label %while.cond.i

_Z15test_atomic_casPii.exit:                      ; preds = %while.cond.i
  ret void
}

declare dso_local spir_func i32 @_Z18__spirv_ocl_printfPU3AS2Kcz(ptr addrspace(2), ...)

attributes #0 = { convergent mustprogress norecurse nounwind "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "frame-pointer"="all" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "sycl-module-id"="/workspace2/zhenyuan/DeepEP/csrc/sycl/test_atomic_asm.cpp" "sycl-optlevel"="2" "unsafe-fp-math"="true" }
attributes #1 = { convergent nounwind "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "frame-pointer"="all" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "unsafe-fp-math"="true" }
attributes #2 = { convergent mustprogress norecurse nounwind "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "frame-pointer"="all" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "sycl-module-id"="/workspace2/zhenyuan/DeepEP/csrc/sycl/test_atomic_asm.cpp" "sycl-optlevel"="2" "uniform-work-group-size"="true" "unsafe-fp-math"="true" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #4 = { convergent nounwind }

!llvm.module.flags = !{!0, !1, !2}
!opencl.spir.version = !{!3}
!spirv.Source = !{!4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 1, !"sycl-device", i32 1}
!2 = !{i32 7, !"frame-pointer", i32 2}
!3 = !{i32 1, i32 2}
!4 = !{i32 4, i32 100000}
!5 = !{!"Intel(R) oneAPI DPC++/C++ Compiler 2025.3.0 (2025.x.0.YYYYMMDD)"}
!6 = !{}
!7 = !{!8, !8, i64 0}
!8 = !{!"int", !9, i64 0}
!9 = !{!"omnipotent char", !10, i64 0}
!10 = !{!"Simple C++ TBAA"}
!11 = !{i32 -1, i32 -1}
!12 = !{i1 false, i1 false}
!13 = !{!14, !14, i64 0}
!14 = !{!"pointer@_ZTSPi", !9, i64 0}
!15 = !{!16, !18, !20, !22}
!16 = distinct !{!16, !17, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv: %agg.result"}
!17 = distinct !{!17, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv"}
!18 = distinct !{!18, !19, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v: %agg.result"}
!19 = distinct !{!19, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v"}
!20 = distinct !{!20, !21, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv: %agg.result"}
!21 = distinct !{!21, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv"}
!22 = distinct !{!22, !23, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE: %agg.result"}
!23 = distinct !{!23, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE"}
!24 = !{!25, !27, !20, !22}
!25 = distinct !{!25, !26, !"_ZN7__spirv21InitSizesSTGlobalSizeILi1EN4sycl3_V15rangeILi1EEEE8initSizeEv: %agg.result"}
!26 = distinct !{!26, !"_ZN7__spirv21InitSizesSTGlobalSizeILi1EN4sycl3_V15rangeILi1EEEE8initSizeEv"}
!27 = distinct !{!27, !28, !"_ZN7__spirv14initGlobalSizeILi1EN4sycl3_V15rangeILi1EEEEET0_v: %agg.result"}
!28 = distinct !{!28, !"_ZN7__spirv14initGlobalSizeILi1EN4sycl3_V15rangeILi1EEEEET0_v"}
!29 = distinct !{!29, !30}
!30 = !{!"llvm.loop.mustprogress"}
!31 = !{i32 -1}
!32 = !{i1 false}
!33 = !{!34, !36, !38, !40}
!34 = distinct !{!34, !35, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv: %agg.result"}
!35 = distinct !{!35, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv"}
!36 = distinct !{!36, !37, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v: %agg.result"}
!37 = distinct !{!37, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v"}
!38 = distinct !{!38, !39, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv: %agg.result"}
!39 = distinct !{!39, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv"}
!40 = distinct !{!40, !41, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE: %agg.result"}
!41 = distinct !{!41, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE"}
!42 = !{!43, !45, !47, !49}
!43 = distinct !{!43, !44, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv: %agg.result"}
!44 = distinct !{!44, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv"}
!45 = distinct !{!45, !46, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v: %agg.result"}
!46 = distinct !{!46, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v"}
!47 = distinct !{!47, !48, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv: %agg.result"}
!48 = distinct !{!48, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv"}
!49 = distinct !{!49, !50, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE: %agg.result"}
!50 = distinct !{!50, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE"}
!51 = !{!52, !54, !47, !49}
!52 = distinct !{!52, !53, !"_ZN7__spirv21InitSizesSTGlobalSizeILi1EN4sycl3_V15rangeILi1EEEE8initSizeEv: %agg.result"}
!53 = distinct !{!53, !"_ZN7__spirv21InitSizesSTGlobalSizeILi1EN4sycl3_V15rangeILi1EEEE8initSizeEv"}
!54 = distinct !{!54, !55, !"_ZN7__spirv14initGlobalSizeILi1EN4sycl3_V15rangeILi1EEEEET0_v: %agg.result"}
!55 = distinct !{!55, !"_ZN7__spirv14initGlobalSizeILi1EN4sycl3_V15rangeILi1EEEEET0_v"}
!56 = distinct !{!56, !30}
!57 = !{!58, !60, !62, !64}
!58 = distinct !{!58, !59, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv: %agg.result"}
!59 = distinct !{!59, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv"}
!60 = distinct !{!60, !61, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v: %agg.result"}
!61 = distinct !{!61, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v"}
!62 = distinct !{!62, !63, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv: %agg.result"}
!63 = distinct !{!63, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv"}
!64 = distinct !{!64, !65, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE: %agg.result"}
!65 = distinct !{!65, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE"}
!66 = !{!67, !69, !71, !73}
!67 = distinct !{!67, !68, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv: %agg.result"}
!68 = distinct !{!68, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv"}
!69 = distinct !{!69, !70, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v: %agg.result"}
!70 = distinct !{!70, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v"}
!71 = distinct !{!71, !72, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv: %agg.result"}
!72 = distinct !{!72, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv"}
!73 = distinct !{!73, !74, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE: %agg.result"}
!74 = distinct !{!74, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE"}
!75 = !{!76, !78, !71, !73}
!76 = distinct !{!76, !77, !"_ZN7__spirv21InitSizesSTGlobalSizeILi1EN4sycl3_V15rangeILi1EEEE8initSizeEv: %agg.result"}
!77 = distinct !{!77, !"_ZN7__spirv21InitSizesSTGlobalSizeILi1EN4sycl3_V15rangeILi1EEEE8initSizeEv"}
!78 = distinct !{!78, !79, !"_ZN7__spirv14initGlobalSizeILi1EN4sycl3_V15rangeILi1EEEEET0_v: %agg.result"}
!79 = distinct !{!79, !"_ZN7__spirv14initGlobalSizeILi1EN4sycl3_V15rangeILi1EEEEET0_v"}
!80 = distinct !{!80, !30}
!81 = !{!82, !84, !86, !88}
!82 = distinct !{!82, !83, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv: %agg.result"}
!83 = distinct !{!83, !"_ZN7__spirv29InitSizesSTGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEE8initSizeEv"}
!84 = distinct !{!84, !85, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v: %agg.result"}
!85 = distinct !{!85, !"_ZN7__spirv22initGlobalInvocationIdILi1EN4sycl3_V12idILi1EEEEET0_v"}
!86 = distinct !{!86, !87, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv: %agg.result"}
!87 = distinct !{!87, !"_ZN4sycl3_V16detail7Builder7getItemILi1ELb1EEENSt9enable_ifIXT0_EKNS0_4itemIXT_EXT0_EEEE4typeEv"}
!88 = distinct !{!88, !89, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE: %agg.result"}
!89 = distinct !{!89, !"_ZN4sycl3_V16detail7Builder10getElementILi1ELb1EEEDTcl7getItemIXT_EXT0_EEEEPNS0_4itemIXT_EXT0_EEE"}

; __CLANG_OFFLOAD_BUNDLE____END__ sycl-spir64_gen-unknown-unknown

; __CLANG_OFFLOAD_BUNDLE____START__ host-x86_64-unknown-linux-gnu
; ModuleID = '/workspace2/zhenyuan/DeepEP/csrc/sycl/test_atomic_asm.cpp'
source_filename = "/workspace2/zhenyuan/DeepEP/csrc/sycl/test_atomic_asm.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%"class.std::basic_ostream" = type { ptr, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", ptr, i8, i8, ptr, ptr, ptr, ptr }
%"class.std::ios_base" = type { ptr, i64, i64, i32, i32, i32, ptr, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, ptr, %"class.std::locale" }
%"struct.std::ios_base::_Words" = type { ptr, i64 }
%"class.std::locale" = type { ptr }
%"struct.std::__atomic_base" = type { i32 }
%class._ZTSZ4mainEUlRN4sycl3_V17handlerEE1_ = type { ptr }
%"class.sycl::_V1::detail::type_erased_cgfo_ty" = type { ptr, ptr }
%class._ZTSZ4mainEUlRN4sycl3_V17handlerEE0_ = type { ptr }
%class._ZTSZ4mainEUlRN4sycl3_V17handlerEE_ = type { ptr }
%"class.sycl::_V1::device" = type { %"class.std::shared_ptr.7" }
%"class.std::shared_ptr.7" = type { %"class.std::__shared_ptr.8" }
%"class.std::__shared_ptr.8" = type { ptr, %"class.std::__shared_count" }
%"class.std::__shared_count" = type { ptr }
%"class.sycl::_V1::context" = type { %"class.std::shared_ptr.32" }
%"class.std::shared_ptr.32" = type { %"class.std::__shared_ptr.33" }
%"class.std::__shared_ptr.33" = type { ptr, %"class.std::__shared_count" }
%"class.sycl::_V1::detail::string" = type { ptr }
%"class.std::function" = type { %"class.std::_Function_base", ptr }
%"class.std::_Function_base" = type { %"union.std::_Any_data", ptr }
%"union.std::_Any_data" = type { %"union.std::_Nocopy_types" }
%"union.std::_Nocopy_types" = type { { i64, i64 } }
%"class.std::function.23" = type { %"class.std::_Function_base", ptr }
%"class.sycl::_V1::queue" = type { %"class.std::shared_ptr" }
%"class.std::shared_ptr" = type { %"class.std::__shared_ptr" }
%"class.std::__shared_ptr" = type { ptr, %"class.std::__shared_count" }
%"class.sycl::_V1::property_list" = type { %"class.sycl::_V1::detail::PropertyListBase" }
%"class.sycl::_V1::detail::PropertyListBase" = type { %"class.std::bitset", %"class.std::vector" }
%"class.std::bitset" = type { %"struct.std::_Base_bitset" }
%"struct.std::_Base_bitset" = type { i64 }
%"class.std::vector" = type { %"struct.std::_Vector_base" }
%"struct.std::_Vector_base" = type { %"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::PropertyWithDataBase>, std::allocator<std::shared_ptr<sycl::_V1::detail::PropertyWithDataBase>>>::_Vector_impl" }
%"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::PropertyWithDataBase>, std::allocator<std::shared_ptr<sycl::_V1::detail::PropertyWithDataBase>>>::_Vector_impl" = type { %"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::PropertyWithDataBase>, std::allocator<std::shared_ptr<sycl::_V1::detail::PropertyWithDataBase>>>::_Vector_impl_data" }
%"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::PropertyWithDataBase>, std::allocator<std::shared_ptr<sycl::_V1::detail::PropertyWithDataBase>>>::_Vector_impl_data" = type { ptr, ptr, ptr }
%"class.std::__cxx11::basic_string" = type { %"struct.std::__cxx11::basic_string<char>::_Alloc_hider", i64, %union.anon }
%"struct.std::__cxx11::basic_string<char>::_Alloc_hider" = type { ptr }
%union.anon = type { i64, [8 x i8] }
%"struct.sycl::_V1::detail::code_location" = type { ptr, ptr, i64, i64 }
%"class.sycl::_V1::event" = type { %"class.std::shared_ptr.11" }
%"class.std::shared_ptr.11" = type { %"class.std::__shared_ptr.12" }
%"class.std::__shared_ptr.12" = type { ptr, %"class.std::__shared_count" }
%"class.std::_Sp_counted_base" = type { ptr, i32, i32 }
%"class.std::__shared_ptr.21" = type { ptr, %"class.std::__shared_count" }
%"class.std::shared_ptr.20" = type { %"class.std::__shared_ptr.21" }
%"class.std::ctype" = type <{ %"class.std::locale::facet.base", [4 x i8], ptr, i8, [7 x i8], ptr, ptr, ptr, i8, [256 x i8], [256 x i8], i8, [6 x i8] }>
%"class.std::locale::facet.base" = type <{ ptr, i32 }>
%"class.std::__exception_ptr::exception_ptr" = type { ptr }
%"class.sycl::_V1::exception_list" = type { %"class.std::vector.26" }
%"class.std::vector.26" = type { %"struct.std::_Vector_base.27" }
%"struct.std::_Vector_base.27" = type { %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl" }
%"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl" = type { %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data" }
%"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data" = type { ptr, ptr, ptr }
%"class.sycl::_V1::detail::tls_code_loc_t" = type { i8 }
%"class.sycl::_V1::detail::SubmissionInfo" = type { %"class.std::shared_ptr.35" }
%"class.std::shared_ptr.35" = type { %"class.std::__shared_ptr.36" }
%"class.std::__shared_ptr.36" = type { ptr, %"class.std::__shared_count" }
%"class.std::vector.79" = type { %"struct.std::_Vector_base.80" }
%"struct.std::_Vector_base.80" = type { %"struct.std::_Vector_base<sycl::_V1::detail::kernel_param_desc_t, std::allocator<sycl::_V1::detail::kernel_param_desc_t>>::_Vector_impl" }
%"struct.std::_Vector_base<sycl::_V1::detail::kernel_param_desc_t, std::allocator<sycl::_V1::detail::kernel_param_desc_t>>::_Vector_impl" = type { %"struct.std::_Vector_base<sycl::_V1::detail::kernel_param_desc_t, std::allocator<sycl::_V1::detail::kernel_param_desc_t>>::_Vector_impl_data" }
%"struct.std::_Vector_base<sycl::_V1::detail::kernel_param_desc_t, std::allocator<sycl::_V1::detail::kernel_param_desc_t>>::_Vector_impl_data" = type { ptr, ptr, ptr }
%"class.sycl::_V1::range.69" = type { %"class.sycl::_V1::detail::array.70" }
%"class.sycl::_V1::detail::array.70" = type { [3 x i64] }
%"class.sycl::_V1::range" = type { %"class.sycl::_V1::detail::array" }
%"class.sycl::_V1::detail::array" = type { [1 x i64] }
%"class.std::tuple.61" = type { %"struct.std::_Tuple_impl.62" }
%"struct.std::_Tuple_impl.62" = type { %"struct.std::_Tuple_impl.63", %"struct.std::_Head_base.65" }
%"struct.std::_Tuple_impl.63" = type { %"struct.std::_Head_base.64" }
%"struct.std::_Head_base.64" = type { i8 }
%"struct.std::_Head_base.65" = type { %"class.sycl::_V1::range" }
%"class.sycl::_V1::detail::HostKernel" = type { %"class.sycl::_V1::detail::HostKernelBase", %"class.sycl::_V1::detail::RoundedRangeKernel" }
%"class.sycl::_V1::detail::HostKernelBase" = type { ptr }
%"class.sycl::_V1::detail::RoundedRangeKernel" = type { %"class.sycl::_V1::range", %class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_EUlNS0_2idILi1EEEE_ }
%class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_EUlNS0_2idILi1EEEE_ = type { ptr }
%"class.sycl::_V1::handler" = type { %"class.std::shared_ptr.38", %"class.std::shared_ptr", %"class.std::vector.41", %"class.std::vector.46", %"class.sycl::_V1::detail::string", %"class.std::shared_ptr.51", ptr, ptr, i64, %"class.std::vector.54", %"class.std::unique_ptr", %"struct.sycl::_V1::detail::code_location", i8, %"class.sycl::_V1::event" }
%"class.std::shared_ptr.38" = type { %"class.std::__shared_ptr.39" }
%"class.std::__shared_ptr.39" = type { ptr, %"class.std::__shared_count" }
%"class.std::vector.41" = type { %"struct.std::_Vector_base.42" }
%"struct.std::_Vector_base.42" = type { %"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::LocalAccessorImplHost>, std::allocator<std::shared_ptr<sycl::_V1::detail::LocalAccessorImplHost>>>::_Vector_impl" }
%"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::LocalAccessorImplHost>, std::allocator<std::shared_ptr<sycl::_V1::detail::LocalAccessorImplHost>>>::_Vector_impl" = type { %"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::LocalAccessorImplHost>, std::allocator<std::shared_ptr<sycl::_V1::detail::LocalAccessorImplHost>>>::_Vector_impl_data" }
%"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::LocalAccessorImplHost>, std::allocator<std::shared_ptr<sycl::_V1::detail::LocalAccessorImplHost>>>::_Vector_impl_data" = type { ptr, ptr, ptr }
%"class.std::vector.46" = type { %"struct.std::_Vector_base.47" }
%"struct.std::_Vector_base.47" = type { %"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::stream_impl>, std::allocator<std::shared_ptr<sycl::_V1::detail::stream_impl>>>::_Vector_impl" }
%"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::stream_impl>, std::allocator<std::shared_ptr<sycl::_V1::detail::stream_impl>>>::_Vector_impl" = type { %"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::stream_impl>, std::allocator<std::shared_ptr<sycl::_V1::detail::stream_impl>>>::_Vector_impl_data" }
%"struct.std::_Vector_base<std::shared_ptr<sycl::_V1::detail::stream_impl>, std::allocator<std::shared_ptr<sycl::_V1::detail::stream_impl>>>::_Vector_impl_data" = type { ptr, ptr, ptr }
%"class.std::shared_ptr.51" = type { %"class.std::__shared_ptr.52" }
%"class.std::__shared_ptr.52" = type { ptr, %"class.std::__shared_count" }
%"class.std::vector.54" = type { %"struct.std::_Vector_base.55" }
%"struct.std::_Vector_base.55" = type { %"struct.std::_Vector_base<unsigned char, std::allocator<unsigned char>>::_Vector_impl" }
%"struct.std::_Vector_base<unsigned char, std::allocator<unsigned char>>::_Vector_impl" = type { %"struct.std::_Vector_base<unsigned char, std::allocator<unsigned char>>::_Vector_impl_data" }
%"struct.std::_Vector_base<unsigned char, std::allocator<unsigned char>>::_Vector_impl_data" = type { ptr, ptr, ptr }
%"class.std::unique_ptr" = type { %"struct.std::__uniq_ptr_data" }
%"struct.std::__uniq_ptr_data" = type { %"class.std::__uniq_ptr_impl" }
%"class.std::__uniq_ptr_impl" = type { %"class.std::tuple" }
%"class.std::tuple" = type { %"struct.std::_Tuple_impl" }
%"struct.std::_Tuple_impl" = type { %"struct.std::_Head_base.60" }
%"struct.std::_Head_base.60" = type { ptr }
%"struct.sycl::_V1::detail::kernel_param_desc_t" = type { i32, i32, i32 }
%"class.sycl::_V1::detail::HostKernel.95" = type { %"class.sycl::_V1::detail::HostKernelBase", %class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_EUlNS0_2idILi1EEEE_ }
%"class.std::tuple.66" = type { %"struct.std::_Tuple_impl.67" }
%"struct.std::_Tuple_impl.67" = type { %"struct.std::_Tuple_impl.63", %"struct.std::_Head_base.68" }
%"struct.std::_Head_base.68" = type { %"struct.std::array" }
%"struct.std::array" = type { [3 x i64] }
%"class.sycl::_V1::detail::HostKernel.107" = type { %"class.sycl::_V1::detail::HostKernelBase", %"class.sycl::_V1::detail::RoundedRangeKernel.98" }
%"class.sycl::_V1::detail::RoundedRangeKernel.98" = type { %"class.sycl::_V1::range", %class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_EUlNS0_2idILi1EEEE_ }
%class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_EUlNS0_2idILi1EEEE_ = type { ptr }
%"class.sycl::_V1::detail::HostKernel.118" = type { %"class.sycl::_V1::detail::HostKernelBase", %class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_EUlNS0_2idILi1EEEE_ }
%"class.sycl::_V1::detail::HostKernel.130" = type { %"class.sycl::_V1::detail::HostKernelBase", %"class.sycl::_V1::detail::RoundedRangeKernel.121" }
%"class.sycl::_V1::detail::RoundedRangeKernel.121" = type { %"class.sycl::_V1::range", %class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_EUlNS0_2idILi1EEEE_ }
%class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_EUlNS0_2idILi1EEEE_ = type { ptr }
%"class.sycl::_V1::detail::HostKernel.141" = type { %"class.sycl::_V1::detail::HostKernelBase", %class._ZTSZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_EUlNS0_2idILi1EEEE_ }

$_ZN4sycl3_V16detail16PropertyListBaseD2Ev = comdat any

$_ZN4sycl3_V16deviceD2Ev = comdat any

$_ZN4sycl3_V15eventD2Ev = comdat any

$_ZN4sycl3_V15queueD2Ev = comdat any

$__clang_call_terminate = comdat any

$_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv = comdat any

$_ZN4sycl3_V16detail19defaultAsyncHandlerENS0_14exception_listE = comdat any

$_ZNSt17_Function_handlerIFiRKN4sycl3_V16deviceEEPS5_E9_M_invokeERKSt9_Any_dataS4_ = comdat any

$_ZNSt17_Function_handlerIFiRKN4sycl3_V16deviceEEPS5_E10_M_managerERSt9_Any_dataRKS8_St18_Manager_operation = comdat any

$_ZNSt17_Function_handlerIFvN4sycl3_V114exception_listEEPS3_E9_M_invokeERKSt9_Any_dataOS2_ = comdat any

$_ZNSt17_Function_handlerIFvN4sycl3_V114exception_listEEPS3_E10_M_managerERSt9_Any_dataRKS6_St18_Manager_operation = comdat any

$_ZN4sycl3_V114exception_listD2Ev = comdat any

$_ZN4sycl3_V17contextD2Ev = comdat any

$_ZN4sycl3_V15queue17submit_with_eventILb0ENS0_3ext6oneapi12experimental10propertiesINS5_6detail20properties_type_listIJEEEEEEENS0_5eventET0_RKNS0_6detail19type_erased_cgfo_tyEPS1_RKNSD_13code_locationE = comdat any

$_ZN4sycl3_V16detail14SubmissionInfoD2Ev = comdat any

$_ZN4sycl3_V17handler15getRoundedRangeILi1EEESt5tupleIJNS0_5rangeIXT_EEEbEES5_ = comdat any

$_ZN4sycl3_V16detail15checkValueRangeILi1ENS0_5rangeILi1EEEEENSt9enable_ifIXoosr3stdE9is_same_vIT0_NS3_IXT_EEEEsr3stdE9is_same_vIS6_NS0_2idIXT_EEEEEvE4typeERKS6_ = comdat any

$_ZN4sycl3_V16detail14HostKernelBaseD2Ev = comdat any

$_ZTIPFiRKN4sycl3_V16deviceEE = comdat any

$_ZTSPFiRKN4sycl3_V16deviceEE = comdat any

$_ZTIFiRKN4sycl3_V16deviceEE = comdat any

$_ZTSFiRKN4sycl3_V16deviceEE = comdat any

$_ZTIPFvN4sycl3_V114exception_listEE = comdat any

$_ZTSPFvN4sycl3_V114exception_listEE = comdat any

$_ZTIFvN4sycl3_V114exception_listEE = comdat any

$_ZTSFvN4sycl3_V114exception_listEE = comdat any

$_ZTIN4sycl3_V16detail14HostKernelBaseE = comdat any

$_ZTSN4sycl3_V16detail14HostKernelBaseE = comdat any

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external hidden global i8
@_ZTIN4sycl3_V19exceptionE = external dso_local constant ptr
@_ZSt4cout = external dso_local global %"class.std::basic_ostream", align 8
@.str = private unnamed_addr constant [13 x i8] c"Running on: \00", align 1
@.str.1 = private unnamed_addr constant [20 x i8] c"test_atomic_asm.cpp\00", align 1
@.str.2 = private unnamed_addr constant [5 x i8] c"main\00", align 1
@.str.3 = private unnamed_addr constant [22 x i8] c"Test 1 (atomic_ref): \00", align 1
@.str.4 = private unnamed_addr constant [24 x i8] c"Test 2 (atomic_fence): \00", align 1
@.str.5 = private unnamed_addr constant [28 x i8] c" (expected race condition!)\00", align 1
@.str.6 = private unnamed_addr constant [15 x i8] c"Test 3 (CAS): \00", align 1
@_ZSt4cerr = external dso_local global %"class.std::basic_ostream", align 8
@.str.7 = private unnamed_addr constant [17 x i8] c"SYCL exception: \00", align 1
@__libc_single_threaded = external dso_local local_unnamed_addr global i8, align 1
@_ZTIPFiRKN4sycl3_V16deviceEE = linkonce_odr dso_local constant { ptr, ptr, i32, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv119__pointer_type_infoE, i64 2), ptr @_ZTSPFiRKN4sycl3_V16deviceEE, i32 0, ptr @_ZTIFiRKN4sycl3_V16deviceEE }, comdat, align 8
@_ZTVN10__cxxabiv119__pointer_type_infoE = external dso_local global [0 x ptr]
@_ZTSPFiRKN4sycl3_V16deviceEE = linkonce_odr dso_local constant [25 x i8] c"PFiRKN4sycl3_V16deviceEE\00", comdat, align 1
@_ZTIFiRKN4sycl3_V16deviceEE = linkonce_odr dso_local constant { ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv120__function_type_infoE, i64 2), ptr @_ZTSFiRKN4sycl3_V16deviceEE }, comdat, align 8
@_ZTVN10__cxxabiv120__function_type_infoE = external dso_local global [0 x ptr]
@_ZTSFiRKN4sycl3_V16deviceEE = linkonce_odr dso_local constant [24 x i8] c"FiRKN4sycl3_V16deviceEE\00", comdat, align 1
@.str.8 = private unnamed_addr constant [41 x i8] c"Default async_handler caught exceptions:\00", align 1
@_ZTISt9exception = external dso_local constant ptr
@.str.9 = private unnamed_addr constant [3 x i8] c"\0A\09\00", align 1
@_ZTIPFvN4sycl3_V114exception_listEE = linkonce_odr dso_local constant { ptr, ptr, i32, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv119__pointer_type_infoE, i64 2), ptr @_ZTSPFvN4sycl3_V114exception_listEE, i32 0, ptr @_ZTIFvN4sycl3_V114exception_listEE }, comdat, align 8
@_ZTSPFvN4sycl3_V114exception_listEE = linkonce_odr dso_local constant [32 x i8] c"PFvN4sycl3_V114exception_listEE\00", comdat, align 1
@_ZTIFvN4sycl3_V114exception_listEE = linkonce_odr dso_local constant { ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv120__function_type_infoE, i64 2), ptr @_ZTSFvN4sycl3_V114exception_listEE }, comdat, align 8
@_ZTSFvN4sycl3_V114exception_listEE = linkonce_odr dso_local constant [31 x i8] c"FvN4sycl3_V114exception_listEE\00", comdat, align 1
@.str.10 = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.13 = private unnamed_addr constant [61 x i8] c"SyclObject.impl && \22every constructor should create an impl\22\00", align 1
@.str.14 = private unnamed_addr constant [103 x i8] c"/home/gta/intel/oneapi/compiler/2025.2.free_func/bin/compiler/../../include/sycl/detail/impl_utils.hpp\00", align 1
@__PRETTY_FUNCTION__._ZN4sycl3_V16detail14getSyclObjImplINS0_5queueEEERKDtsrT_4implERKS4_ = private unnamed_addr constant [89 x i8] c"const decltype(Obj::impl) &sycl::detail::getSyclObjImpl(const Obj &) [Obj = sycl::queue]\00", align 1
@.str.16 = private unnamed_addr constant [131 x i8] c"Attempt to set multiple actions for the command group. Command group must consist of a single kernel or explicit memory operation.\00", align 1
@.str.20 = private unnamed_addr constant [36 x i8] c"parallel_for range adjusted at dim \00", align 1
@.str.21 = private unnamed_addr constant [7 x i8] c" from \00", align 1
@.str.22 = private unnamed_addr constant [5 x i8] c" to \00", align 1
@.str.23 = private unnamed_addr constant [64 x i8] c"_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_EUlNS0_2idILi1EEEE_\00", align 1
@.str.24 = private unnamed_addr constant [104 x i8] c"Provided range is out of integer limits. Pass `-fno-sycl-id-queries-fit-in-int' to disable range check.\00", align 1
@_ZTVN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal unnamed_addr constant { [6 x ptr] } { [6 x ptr] [ptr null, ptr @_ZTIN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE6getPtrEv, ptr @_ZN4sycl3_V16detail14HostKernelBaseD2Ev, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EED0Ev, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE23InstantiateKernelOnHostEv] }, align 8
@_ZTIN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal constant { ptr, ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv120__si_class_type_infoE, i64 2), ptr @_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, ptr @_ZTIN4sycl3_V16detail14HostKernelBaseE }, align 8
@_ZTVN10__cxxabiv120__si_class_type_infoE = external dso_local global [0 x ptr]
@_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal constant [144 x i8] c"N4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE\00", align 1
@_ZTIN4sycl3_V16detail14HostKernelBaseE = linkonce_odr dso_local constant { ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv117__class_type_infoE, i64 2), ptr @_ZTSN4sycl3_V16detail14HostKernelBaseE }, comdat, align 8
@_ZTVN10__cxxabiv117__class_type_infoE = external dso_local global [0 x ptr]
@_ZTSN4sycl3_V16detail14HostKernelBaseE = linkonce_odr dso_local constant [35 x i8] c"N4sycl3_V16detail14HostKernelBaseE\00", comdat, align 1
@.str.27 = private unnamed_addr constant [122 x i8] c"_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES6_EUlNS0_2idILi1EEEE_EE\00", align 1
@_ZTVN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal unnamed_addr constant { [6 x ptr] } { [6 x ptr] [ptr null, ptr @_ZTIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE6getPtrEv, ptr @_ZN4sycl3_V16detail14HostKernelBaseD2Ev, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EED0Ev, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE23InstantiateKernelOnHostEv] }, align 8
@_ZTIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal constant { ptr, ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv120__si_class_type_infoE, i64 2), ptr @_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, ptr @_ZTIN4sycl3_V16detail14HostKernelBaseE }, align 8
@_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal constant [110 x i8] c"N4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE\00", align 1
@.str.30 = private unnamed_addr constant [65 x i8] c"_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_EUlNS0_2idILi1EEEE_\00", align 1
@_ZTVN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal unnamed_addr constant { [6 x ptr] } { [6 x ptr] [ptr null, ptr @_ZTIN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE6getPtrEv, ptr @_ZN4sycl3_V16detail14HostKernelBaseD2Ev, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EED0Ev, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE23InstantiateKernelOnHostEv] }, align 8
@_ZTIN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal constant { ptr, ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv120__si_class_type_infoE, i64 2), ptr @_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, ptr @_ZTIN4sycl3_V16detail14HostKernelBaseE }, align 8
@_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal constant [145 x i8] c"N4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE\00", align 1
@.str.31 = private unnamed_addr constant [123 x i8] c"_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES6_EUlNS0_2idILi1EEEE_EE\00", align 1
@_ZTVN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal unnamed_addr constant { [6 x ptr] } { [6 x ptr] [ptr null, ptr @_ZTIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE6getPtrEv, ptr @_ZN4sycl3_V16detail14HostKernelBaseD2Ev, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EED0Ev, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE23InstantiateKernelOnHostEv] }, align 8
@_ZTIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal constant { ptr, ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv120__si_class_type_infoE, i64 2), ptr @_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, ptr @_ZTIN4sycl3_V16detail14HostKernelBaseE }, align 8
@_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal constant [111 x i8] c"N4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE\00", align 1
@.str.32 = private unnamed_addr constant [65 x i8] c"_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_EUlNS0_2idILi1EEEE_\00", align 1
@_ZTVN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal unnamed_addr constant { [6 x ptr] } { [6 x ptr] [ptr null, ptr @_ZTIN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE6getPtrEv, ptr @_ZN4sycl3_V16detail14HostKernelBaseD2Ev, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EED0Ev, ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE23InstantiateKernelOnHostEv] }, align 8
@_ZTIN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal constant { ptr, ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv120__si_class_type_infoE, i64 2), ptr @_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, ptr @_ZTIN4sycl3_V16detail14HostKernelBaseE }, align 8
@_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE = internal constant [145 x i8] c"N4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE\00", align 1
@.str.33 = private unnamed_addr constant [123 x i8] c"_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EE\00", align 1
@_ZTVN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal unnamed_addr constant { [6 x ptr] } { [6 x ptr] [ptr null, ptr @_ZTIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE6getPtrEv, ptr @_ZN4sycl3_V16detail14HostKernelBaseD2Ev, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EED0Ev, ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE23InstantiateKernelOnHostEv] }, align 8
@_ZTIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal constant { ptr, ptr, ptr } { ptr getelementptr inbounds (ptr, ptr @_ZTVN10__cxxabiv120__si_class_type_infoE, i64 2), ptr @_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, ptr @_ZTIN4sycl3_V16detail14HostKernelBaseE }, align 8
@_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE = internal constant [111 x i8] c"N4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE\00", align 1
@llvm.global_ctors = appending global [1 x { i32, ptr, ptr }] [{ i32, ptr, ptr } { i32 65535, ptr @_GLOBAL__sub_I_test_atomic_asm.cpp, ptr null }]

; Function Attrs: nofree
declare dso_local void @_ZNSt8ios_base4InitC1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #0

; Function Attrs: nofree nounwind
declare dso_local void @_ZNSt8ios_base4InitD1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #1

; Function Attrs: nofree nounwind
declare dso_local i32 @__cxa_atexit(ptr, ptr, ptr) local_unnamed_addr #2

; Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(argmem: readwrite) uwtable
define dso_local void @_Z22test_atomic_ref_systemPii(ptr noundef captures(none) %ptr, i32 noundef %value) local_unnamed_addr #3 {
entry:
  %_M_i.i.i = getelementptr inbounds nuw %"struct.std::__atomic_base", ptr %ptr, i64 0, i32 0, !intel-tbaa !4
  %0 = atomicrmw add ptr %_M_i.i.i, i32 %value seq_cst, align 4
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr captures(none)) #4

; Function Attrs: mustprogress nofree norecurse nounwind willreturn uwtable
define dso_local void @_Z24test_atomic_fence_systemPii(ptr noundef captures(none) %ptr, i32 noundef %value) local_unnamed_addr #5 {
entry:
  fence seq_cst
  %0 = load i32, ptr %ptr, align 4, !tbaa !9
  %add = add nsw i32 %0, %value
  store i32 %add, ptr %ptr, align 4, !tbaa !9
  fence seq_cst
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind willreturn uwtable
define dso_local void @_Z15test_fence_onlyv() local_unnamed_addr #5 {
entry:
  fence seq_cst
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(argmem: readwrite) uwtable
define dso_local void @_Z23test_atomic_ref_acq_relPii(ptr noundef captures(none) %ptr, i32 noundef %value) local_unnamed_addr #3 {
entry:
  %_M_i.i16.i = getelementptr inbounds nuw %"struct.std::__atomic_base", ptr %ptr, i64 0, i32 0, !intel-tbaa !4
  %0 = atomicrmw add ptr %_M_i.i16.i, i32 %value acq_rel, align 4
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind willreturn uwtable
define dso_local void @_Z18test_fence_acq_relv() local_unnamed_addr #5 {
entry:
  fence acq_rel
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind memory(argmem: readwrite) uwtable
define dso_local void @_Z15test_atomic_casPii(ptr noundef captures(none) %ptr, i32 noundef %value) local_unnamed_addr #6 personality ptr @__gxx_personality_v0 {
entry:
  %_M_i.i.i = getelementptr inbounds nuw %"struct.std::__atomic_base", ptr %ptr, i64 0, i32 0, !intel-tbaa !4
  %0 = load atomic i32, ptr %_M_i.i.i seq_cst, align 4
  %add6 = add nsw i32 %0, %value
  %1 = cmpxchg weak ptr %_M_i.i.i, i32 %0, i32 %add6 seq_cst seq_cst, align 4
  %2 = extractvalue { i32, i1 } %1, 1
  br i1 %2, label %while.end, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit

_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit: ; preds = %entry, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit
  %3 = phi { i32, i1 } [ %5, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit ], [ %1, %entry ]
  %4 = extractvalue { i32, i1 } %3, 0
  %add = add nsw i32 %4, %value
  %5 = cmpxchg weak ptr %_M_i.i.i, i32 %4, i32 %add seq_cst seq_cst, align 4
  %6 = extractvalue { i32, i1 } %5, 1
  br i1 %6, label %while.end, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit, !llvm.loop !10

while.end:                                        ; preds = %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit, %entry
  ret void
}

; Function Attrs: mustprogress norecurse uwtable
define dso_local noundef range(i32 0, 2) i32 @main() local_unnamed_addr #7 personality ptr @__gxx_personality_v0 {
invoke.cont:
  %CGF.i301 = alloca %class._ZTSZ4mainEUlRN4sycl3_V17handlerEE1_, align 8
  %ref.tmp.i302 = alloca %"class.sycl::_V1::detail::type_erased_cgfo_ty", align 8
  %CGF.i261 = alloca %class._ZTSZ4mainEUlRN4sycl3_V17handlerEE0_, align 8
  %ref.tmp.i262 = alloca %"class.sycl::_V1::detail::type_erased_cgfo_ty", align 8
  %CGF.i = alloca %class._ZTSZ4mainEUlRN4sycl3_V17handlerEE_, align 8
  %ref.tmp.i219 = alloca %"class.sycl::_V1::detail::type_erased_cgfo_ty", align 8
  %ref.tmp.i146 = alloca %"class.sycl::_V1::device", align 8
  %ref.tmp1.i = alloca %"class.sycl::_V1::context", align 8
  %__dnew.i.i.i = alloca i64, align 8
  %ref.tmp.i134 = alloca %"class.sycl::_V1::detail::string", align 8
  %ref.tmp.i = alloca %"class.sycl::_V1::device", align 8
  %ref.tmp2.i = alloca %"class.std::function", align 8
  %ref.tmp3.i = alloca %"class.std::function.23", align 8
  %q = alloca %"class.sycl::_V1::queue", align 8
  %ref.tmp = alloca %"class.sycl::_V1::property_list", align 8
  %ref.tmp5 = alloca %"class.std::__cxx11::basic_string", align 8
  %ref.tmp6 = alloca %"class.sycl::_V1::device", align 8
  %data = alloca ptr, align 8
  %ref.tmp20 = alloca %"class.sycl::_V1::property_list", align 8
  %ref.tmp23 = alloca %"struct.sycl::_V1::detail::code_location", align 8
  %ref.tmp30 = alloca %"class.sycl::_V1::event", align 8
  %ref.tmp32 = alloca %"struct.sycl::_V1::detail::code_location", align 8
  %ref.tmp49 = alloca %"class.sycl::_V1::event", align 8
  %ref.tmp52 = alloca %"struct.sycl::_V1::detail::code_location", align 8
  %ref.tmp71 = alloca %"class.sycl::_V1::event", align 8
  %ref.tmp74 = alloca %"struct.sycl::_V1::detail::code_location", align 8
  %ref.tmp90 = alloca %"struct.sycl::_V1::detail::code_location", align 8
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %q) #37
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp) #37
  %MDataLessProps.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %ref.tmp, i64 0, i32 0, !intel-tbaa !12
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %MDataLessProps.i.i, i8 0, i64 32, i1 false)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp.i) #37
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp2.i) #37
  %_M_functor.i.i.i = getelementptr inbounds nuw %"class.std::_Function_base", ptr %ref.tmp2.i, i64 0, i32 0, !intel-tbaa !22
  %_M_manager.i.i.i = getelementptr inbounds nuw %"class.std::_Function_base", ptr %ref.tmp2.i, i64 0, i32 1, !intel-tbaa !25
  %_M_invoker.i.i = getelementptr inbounds nuw %"class.std::function", ptr %ref.tmp2.i, i64 0, i32 1, !intel-tbaa !26
  %0 = getelementptr inbounds nuw %"class.std::_Function_base", ptr %ref.tmp2.i, i64 0, i32 0, i32 0, i32 0, i32 1
  store i64 0, ptr %0, align 8
  store ptr @_ZN4sycl3_V114gpu_selector_vERKNS0_6deviceE, ptr %ref.tmp2.i, align 8, !tbaa !28
  store ptr @_ZNSt17_Function_handlerIFiRKN4sycl3_V16deviceEEPS5_E9_M_invokeERKSt9_Any_dataS4_, ptr %_M_invoker.i.i, align 8, !tbaa !26
  store ptr @_ZNSt17_Function_handlerIFiRKN4sycl3_V16deviceEEPS5_E10_M_managerERSt9_Any_dataRKS8_St18_Manager_operation, ptr %_M_manager.i.i.i, align 8, !tbaa !25
  invoke void @_ZN4sycl3_V16detail13select_deviceERKSt8functionIFiRKNS0_6deviceEEE(ptr dead_on_unwind nonnull writable sret(%"class.sycl::_V1::device") align 8 %ref.tmp.i, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp2.i)
          to label %invoke.cont.i unwind label %lpad.i

invoke.cont.i:                                    ; preds = %invoke.cont
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp3.i) #37
  %_M_functor.i.i10.i = getelementptr inbounds nuw %"class.std::_Function_base", ptr %ref.tmp3.i, i64 0, i32 0, !intel-tbaa !22
  %_M_manager.i.i11.i = getelementptr inbounds nuw %"class.std::_Function_base", ptr %ref.tmp3.i, i64 0, i32 1, !intel-tbaa !25
  %_M_invoker.i12.i = getelementptr inbounds nuw %"class.std::function.23", ptr %ref.tmp3.i, i64 0, i32 1, !intel-tbaa !29
  %1 = getelementptr inbounds nuw %"class.std::_Function_base", ptr %ref.tmp3.i, i64 0, i32 0, i32 0, i32 0, i32 1
  store i64 0, ptr %1, align 8
  store ptr @_ZN4sycl3_V16detail19defaultAsyncHandlerENS0_14exception_listE, ptr %ref.tmp3.i, align 8, !tbaa !31
  store ptr @_ZNSt17_Function_handlerIFvN4sycl3_V114exception_listEEPS3_E9_M_invokeERKSt9_Any_dataOS2_, ptr %_M_invoker.i12.i, align 8, !tbaa !29
  store ptr @_ZNSt17_Function_handlerIFvN4sycl3_V114exception_listEEPS3_E10_M_managerERSt9_Any_dataRKS6_St18_Manager_operation, ptr %_M_manager.i.i11.i, align 8, !tbaa !25
  invoke void @_ZN4sycl3_V15queueC2ERKNS0_6deviceERKSt8functionIFvNS0_14exception_listEEERKNS0_13property_listE(ptr noundef nonnull align 8 dereferenceable(16) %q, ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp.i, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp3.i, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp)
          to label %invoke.cont5.i unwind label %lpad4.i

invoke.cont5.i:                                   ; preds = %invoke.cont.i
  %2 = load ptr, ptr %_M_manager.i.i11.i, align 8, !tbaa !25
  %tobool.not.i.i = icmp eq ptr %2, null
  br i1 %tobool.not.i.i, label %_ZNSt14_Function_baseD2Ev.exit.i, label %if.then.i.i

if.then.i.i:                                      ; preds = %invoke.cont5.i
  %call.i.i = invoke noundef zeroext i1 %2(ptr noundef nonnull align 8 dereferenceable(16) %_M_functor.i.i10.i, ptr noundef nonnull align 8 dereferenceable(16) %_M_functor.i.i10.i, i32 noundef 3)
          to label %_ZNSt14_Function_baseD2Ev.exit.i unwind label %terminate.lpad.i.i

terminate.lpad.i.i:                               ; preds = %if.then.i.i
  %3 = landingpad { ptr, i32 }
          catch ptr null
  %4 = extractvalue { ptr, i32 } %3, 0
  call void @__clang_call_terminate(ptr %4) #38
  unreachable

_ZNSt14_Function_baseD2Ev.exit.i:                 ; preds = %if.then.i.i, %invoke.cont5.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp3.i) #37
  %_M_pi.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::device", ptr %ref.tmp.i, i64 0, i32 0, i32 0, i32 1
  %5 = load ptr, ptr %_M_pi.i.i.i.i, align 8, !tbaa !33
  %cmp.not.i.i.i.i = icmp eq ptr %5, null
  br i1 %cmp.not.i.i.i.i, label %_ZN4sycl3_V16deviceD2Ev.exit.i, label %if.then.i.i.i.i

if.then.i.i.i.i:                                  ; preds = %_ZNSt14_Function_baseD2Ev.exit.i
  %_M_use_count.i.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %5, i64 0, i32 1, !intel-tbaa !36
  %6 = load atomic i64, ptr %_M_use_count.i.i.i.i.i acquire, align 8
  %cmp.i.i.i.i.i = icmp eq i64 %6, 4294967297
  %7 = trunc i64 %6 to i32
  br i1 %cmp.i.i.i.i.i, label %if.then.i.i.i.i.i, label %if.end.i.i.i.i.i

if.then.i.i.i.i.i:                                ; preds = %if.then.i.i.i.i
  store i32 0, ptr %_M_use_count.i.i.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %5, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i.i.i = load ptr, ptr %5, align 8, !tbaa !39
  %vfn.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i, i64 2
  %8 = load ptr, ptr %vfn.i.i.i.i.i, align 8
  call void %8(ptr noundef nonnull align 8 dereferenceable(16) %5) #37
  %vtable3.i.i.i.i.i = load ptr, ptr %5, align 8, !tbaa !39
  %vfn4.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i.i, i64 3
  %9 = load ptr, ptr %vfn4.i.i.i.i.i, align 8
  call void %9(ptr noundef nonnull align 8 dereferenceable(16) %5) #37
  br label %_ZN4sycl3_V16deviceD2Ev.exit.i

if.end.i.i.i.i.i:                                 ; preds = %if.then.i.i.i.i
  %10 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i.i = icmp eq i8 %10, 0
  br i1 %tobool.i.not.i.i.i.i.i, label %if.else.i.i.i.i.i.i, label %if.then.i.i.i.i.i.i

if.then.i.i.i.i.i.i:                              ; preds = %if.end.i.i.i.i.i
  %add.i.i.i.i.i.i = add nsw i32 %7, -1
  store i32 %add.i.i.i.i.i.i, ptr %_M_use_count.i.i.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i.i

if.else.i.i.i.i.i.i:                              ; preds = %if.end.i.i.i.i.i
  %11 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i.i

invoke.cont.i.i.i.i.i:                            ; preds = %if.else.i.i.i.i.i.i, %if.then.i.i.i.i.i.i
  %retval.0.i.i.i.i.i.i = phi i32 [ %7, %if.then.i.i.i.i.i.i ], [ %11, %if.else.i.i.i.i.i.i ]
  %cmp6.i.i.i.i.i = icmp eq i32 %retval.0.i.i.i.i.i.i, 1
  br i1 %cmp6.i.i.i.i.i, label %if.then7.i.i.i.i.i, label %_ZN4sycl3_V16deviceD2Ev.exit.i, !prof !42

if.then7.i.i.i.i.i:                               ; preds = %invoke.cont.i.i.i.i.i
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %5) #37
  br label %_ZN4sycl3_V16deviceD2Ev.exit.i

_ZN4sycl3_V16deviceD2Ev.exit.i:                   ; preds = %if.then7.i.i.i.i.i, %invoke.cont.i.i.i.i.i, %if.then.i.i.i.i.i, %_ZNSt14_Function_baseD2Ev.exit.i
  %12 = load ptr, ptr %_M_manager.i.i.i, align 8, !tbaa !25
  %tobool.not.i15.i = icmp eq ptr %12, null
  br i1 %tobool.not.i15.i, label %invoke.cont2, label %if.then.i16.i

if.then.i16.i:                                    ; preds = %_ZN4sycl3_V16deviceD2Ev.exit.i
  %call.i18.i = invoke noundef zeroext i1 %12(ptr noundef nonnull align 8 dereferenceable(16) %_M_functor.i.i.i, ptr noundef nonnull align 8 dereferenceable(16) %_M_functor.i.i.i, i32 noundef 3)
          to label %invoke.cont2 unwind label %terminate.lpad.i19.i

terminate.lpad.i19.i:                             ; preds = %if.then.i16.i
  %13 = landingpad { ptr, i32 }
          catch ptr null
  %14 = extractvalue { ptr, i32 } %13, 0
  call void @__clang_call_terminate(ptr %14) #38
  unreachable

lpad.i:                                           ; preds = %invoke.cont
  %15 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup.i

lpad4.i:                                          ; preds = %invoke.cont.i
  %16 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  %17 = load ptr, ptr %_M_manager.i.i11.i, align 8, !tbaa !25
  %tobool.not.i22.i = icmp eq ptr %17, null
  br i1 %tobool.not.i22.i, label %_ZNSt14_Function_baseD2Ev.exit27.i, label %if.then.i23.i

if.then.i23.i:                                    ; preds = %lpad4.i
  %call.i25.i = invoke noundef zeroext i1 %17(ptr noundef nonnull align 8 dereferenceable(16) %_M_functor.i.i10.i, ptr noundef nonnull align 8 dereferenceable(16) %_M_functor.i.i10.i, i32 noundef 3)
          to label %_ZNSt14_Function_baseD2Ev.exit27.i unwind label %terminate.lpad.i26.i

terminate.lpad.i26.i:                             ; preds = %if.then.i23.i
  %18 = landingpad { ptr, i32 }
          catch ptr null
  %19 = extractvalue { ptr, i32 } %18, 0
  call void @__clang_call_terminate(ptr %19) #38
  unreachable

_ZNSt14_Function_baseD2Ev.exit27.i:               ; preds = %if.then.i23.i, %lpad4.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp3.i) #37
  call void @_ZN4sycl3_V16deviceD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp.i) #37
  br label %ehcleanup.i

ehcleanup.i:                                      ; preds = %_ZNSt14_Function_baseD2Ev.exit27.i, %lpad.i
  %.pn.i = phi { ptr, i32 } [ %16, %_ZNSt14_Function_baseD2Ev.exit27.i ], [ %15, %lpad.i ]
  %20 = load ptr, ptr %_M_manager.i.i.i, align 8, !tbaa !25
  %tobool.not.i29.i = icmp eq ptr %20, null
  br i1 %tobool.not.i29.i, label %_ZNSt14_Function_baseD2Ev.exit34.i, label %if.then.i30.i

if.then.i30.i:                                    ; preds = %ehcleanup.i
  %call.i32.i = invoke noundef zeroext i1 %20(ptr noundef nonnull align 8 dereferenceable(16) %_M_functor.i.i.i, ptr noundef nonnull align 8 dereferenceable(16) %_M_functor.i.i.i, i32 noundef 3)
          to label %_ZNSt14_Function_baseD2Ev.exit34.i unwind label %terminate.lpad.i33.i

terminate.lpad.i33.i:                             ; preds = %if.then.i30.i
  %21 = landingpad { ptr, i32 }
          catch ptr null
  %22 = extractvalue { ptr, i32 } %21, 0
  call void @__clang_call_terminate(ptr %22) #38
  unreachable

_ZNSt14_Function_baseD2Ev.exit34.i:               ; preds = %if.then.i30.i, %ehcleanup.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp2.i) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp.i) #37
  call void @_ZN4sycl3_V16detail16PropertyListBaseD2Ev(ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp) #37
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp) #37
  br label %ehcleanup97

invoke.cont2:                                     ; preds = %if.then.i16.i, %_ZN4sycl3_V16deviceD2Ev.exit.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp2.i) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp.i) #37
  %_M_start.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %ref.tmp, i64 0, i32 1
  %23 = load ptr, ptr %_M_start.i.i, align 8, !tbaa !43
  %_M_finish.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %ref.tmp, i64 0, i32 1, i32 0, i32 0, i32 0, i32 1
  %24 = load ptr, ptr %_M_finish.i.i, align 8, !tbaa !44
  %cmp.not3.i.i.i.i.i = icmp eq ptr %23, %24
  br i1 %cmp.not3.i.i.i.i.i, label %invoke.cont.i.i, label %for.body.i.i.i.i.i

for.body.i.i.i.i.i:                               ; preds = %invoke.cont2, %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i
  %__first.addr.04.i.i.i.i.i = phi ptr [ %incdec.ptr.i.i.i.i.i, %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i ], [ %23, %invoke.cont2 ]
  %_M_pi.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.std::__shared_ptr.21", ptr %__first.addr.04.i.i.i.i.i, i64 0, i32 1, i32 0, !intel-tbaa !45
  %25 = load ptr, ptr %_M_pi.i.i.i.i.i.i.i.i, align 8, !tbaa !33
  %cmp.not.i.i.i.i.i.i.i.i = icmp eq ptr %25, null
  br i1 %cmp.not.i.i.i.i.i.i.i.i, label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i:                          ; preds = %for.body.i.i.i.i.i
  %_M_use_count.i.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %25, i64 0, i32 1, !intel-tbaa !36
  %26 = load atomic i64, ptr %_M_use_count.i.i.i.i.i.i.i.i.i acquire, align 8
  %cmp.i.i.i.i.i.i.i.i.i = icmp eq i64 %26, 4294967297
  %27 = trunc i64 %26 to i32
  br i1 %cmp.i.i.i.i.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i.i, label %if.end.i.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i.i:                        ; preds = %if.then.i.i.i.i.i.i.i.i
  store i32 0, ptr %_M_use_count.i.i.i.i.i.i.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %25, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i.i.i.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i.i.i.i.i.i.i = load ptr, ptr %25, align 8, !tbaa !39
  %vfn.i.i.i.i.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i.i.i.i.i, i64 2
  %28 = load ptr, ptr %vfn.i.i.i.i.i.i.i.i.i, align 8
  call void %28(ptr noundef nonnull align 8 dereferenceable(16) %25) #37
  %vtable3.i.i.i.i.i.i.i.i.i = load ptr, ptr %25, align 8, !tbaa !39
  %vfn4.i.i.i.i.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i.i.i.i.i.i, i64 3
  %29 = load ptr, ptr %vfn4.i.i.i.i.i.i.i.i.i, align 8
  call void %29(ptr noundef nonnull align 8 dereferenceable(16) %25) #37
  br label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i

if.end.i.i.i.i.i.i.i.i.i:                         ; preds = %if.then.i.i.i.i.i.i.i.i
  %30 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i.i.i.i.i.i = icmp eq i8 %30, 0
  br i1 %tobool.i.not.i.i.i.i.i.i.i.i.i, label %if.else.i.i.i.i.i.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i.i.i:                      ; preds = %if.end.i.i.i.i.i.i.i.i.i
  %add.i.i.i.i.i.i.i.i.i.i = add nsw i32 %27, -1
  store i32 %add.i.i.i.i.i.i.i.i.i.i, ptr %_M_use_count.i.i.i.i.i.i.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i.i.i.i.i.i

if.else.i.i.i.i.i.i.i.i.i.i:                      ; preds = %if.end.i.i.i.i.i.i.i.i.i
  %31 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i.i.i.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i.i.i.i.i.i

invoke.cont.i.i.i.i.i.i.i.i.i:                    ; preds = %if.else.i.i.i.i.i.i.i.i.i.i, %if.then.i.i.i.i.i.i.i.i.i.i
  %retval.0.i.i.i.i.i.i.i.i.i.i = phi i32 [ %27, %if.then.i.i.i.i.i.i.i.i.i.i ], [ %31, %if.else.i.i.i.i.i.i.i.i.i.i ]
  %cmp6.i.i.i.i.i.i.i.i.i = icmp eq i32 %retval.0.i.i.i.i.i.i.i.i.i.i, 1
  br i1 %cmp6.i.i.i.i.i.i.i.i.i, label %if.then7.i.i.i.i.i.i.i.i.i, label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i, !prof !42

if.then7.i.i.i.i.i.i.i.i.i:                       ; preds = %invoke.cont.i.i.i.i.i.i.i.i.i
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %25) #37
  br label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i

_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i: ; preds = %if.then7.i.i.i.i.i.i.i.i.i, %invoke.cont.i.i.i.i.i.i.i.i.i, %if.then.i.i.i.i.i.i.i.i.i, %for.body.i.i.i.i.i
  %incdec.ptr.i.i.i.i.i = getelementptr inbounds nuw %"class.std::shared_ptr.20", ptr %__first.addr.04.i.i.i.i.i, i64 1
  %cmp.not.i.i.i.i.i = icmp eq ptr %incdec.ptr.i.i.i.i.i, %24
  br i1 %cmp.not.i.i.i.i.i, label %invoke.contthread-pre-split.i.i, label %for.body.i.i.i.i.i, !llvm.loop !48

invoke.contthread-pre-split.i.i:                  ; preds = %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i
  %.pr.i.i = load ptr, ptr %_M_start.i.i, align 8, !tbaa !43
  br label %invoke.cont.i.i

invoke.cont.i.i:                                  ; preds = %invoke.contthread-pre-split.i.i, %invoke.cont2
  %32 = phi ptr [ %.pr.i.i, %invoke.contthread-pre-split.i.i ], [ %23, %invoke.cont2 ]
  %tobool.not.i.i.i.i = icmp eq ptr %32, null
  br i1 %tobool.not.i.i.i.i, label %_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit, label %if.then.i.i.i.i131

if.then.i.i.i.i131:                               ; preds = %invoke.cont.i.i
  %_M_end_of_storage.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %ref.tmp, i64 0, i32 1, i32 0, i32 0, i32 0, i32 2
  %33 = load ptr, ptr %_M_end_of_storage.i.i.i, align 8, !tbaa !49
  %sub.ptr.lhs.cast.i.i.i = ptrtoint ptr %33 to i64
  %sub.ptr.rhs.cast.i.i.i = ptrtoint ptr %32 to i64
  %sub.ptr.sub.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i.i, %sub.ptr.rhs.cast.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %32, i64 noundef %sub.ptr.sub.i.i.i) #39
  br label %_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit

_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit:   ; preds = %invoke.cont.i.i, %if.then.i.i.i.i131
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp) #37
  %call1.i133 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef nonnull @.str, i64 noundef 12)
          to label %invoke.cont4 unwind label %lpad3

invoke.cont4:                                     ; preds = %_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp5) #37
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp6) #37
  invoke void @_ZNK4sycl3_V15queue10get_deviceEv(ptr dead_on_unwind nonnull writable sret(%"class.sycl::_V1::device") align 8 %ref.tmp6, ptr noundef nonnull align 8 dereferenceable(16) %q)
          to label %invoke.cont8 unwind label %lpad7

invoke.cont8:                                     ; preds = %invoke.cont4
  call void @llvm.experimental.noalias.scope.decl(metadata !50)
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %ref.tmp.i134) #37, !noalias !50
  invoke void @_ZNK4sycl3_V16device13get_info_implINS0_4info6device4nameEEENS0_6detail11ABINeutralTINS6_19is_device_info_descIT_E11return_typeEE4typeEv(ptr dead_on_unwind nonnull writable sret(%"class.sycl::_V1::detail::string") align 8 %ref.tmp.i134, ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp6)
          to label %.noexc unwind label %lpad9

.noexc:                                           ; preds = %invoke.cont8
  %str.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::string", ptr %ref.tmp.i134, i64 0, i32 0, !intel-tbaa !53
  %34 = load ptr, ptr %str.i.i.i, align 8, !tbaa !53, !noalias !50
  %tobool.not.i.i.i = icmp eq ptr %34, null
  %spec.select.i.i.i = select i1 %tobool.not.i.i.i, ptr @.str.10, ptr %34
  %_M_dataplus.i.i = getelementptr inbounds nuw %"class.std::__cxx11::basic_string", ptr %ref.tmp5, i64 0, i32 0
  %35 = getelementptr inbounds nuw %"class.std::__cxx11::basic_string", ptr %ref.tmp5, i64 0, i32 2, !intel-tbaa !56
  %arraydecay.i.i.i = getelementptr inbounds nuw [16 x i8], ptr %35, i64 0, i64 0
  store ptr %arraydecay.i.i.i, ptr %_M_dataplus.i.i, align 8, !tbaa !59, !alias.scope !50
  %call.i.i.i = call noundef i64 @strlen(ptr noundef nonnull dereferenceable(1) %spec.select.i.i.i) #37
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %__dnew.i.i.i) #37, !noalias !50
  store i64 %call.i.i.i, ptr %__dnew.i.i.i, align 8, !tbaa !60, !noalias !50
  %cmp.i.i.i = icmp ugt i64 %call.i.i.i, 15
  br i1 %cmp.i.i.i, label %if.then.i.i.i, label %if.end.i.i.i

if.then.i.i.i:                                    ; preds = %.noexc
  %call2.i10.i7.i = invoke noundef ptr @_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm(ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp5, ptr noundef nonnull align 8 dereferenceable(8) %__dnew.i.i.i, i64 noundef 0)
          to label %call2.i10.i.noexc.i unwind label %lpad3.i

call2.i10.i.noexc.i:                              ; preds = %if.then.i.i.i
  store ptr %call2.i10.i7.i, ptr %_M_dataplus.i.i, align 8, !tbaa !61, !alias.scope !50
  %36 = load i64, ptr %__dnew.i.i.i, align 8, !tbaa !60, !noalias !50
  store i64 %36, ptr %35, align 8, !tbaa !41, !alias.scope !50
  br label %if.end.i.i.i

if.end.i.i.i:                                     ; preds = %call2.i10.i.noexc.i, %.noexc
  %37 = phi ptr [ %call2.i10.i7.i, %call2.i10.i.noexc.i ], [ %arraydecay.i.i.i, %.noexc ]
  switch i64 %call.i.i.i, label %if.end.i.i.i.i.i.i [
    i64 1, label %if.then.i.i.i.i.i135
    i64 0, label %invoke.cont4.i
  ]

if.then.i.i.i.i.i135:                             ; preds = %if.end.i.i.i
  %38 = load i8, ptr %spec.select.i.i.i, align 1, !tbaa !41
  store i8 %38, ptr %37, align 1, !tbaa !41
  br label %invoke.cont4.i

if.end.i.i.i.i.i.i:                               ; preds = %if.end.i.i.i
  call void @llvm.memcpy.p0.p0.i64(ptr align 1 %37, ptr nonnull align 1 %spec.select.i.i.i, i64 %call.i.i.i, i1 false)
  br label %invoke.cont4.i

invoke.cont4.i:                                   ; preds = %if.end.i.i.i.i.i.i, %if.then.i.i.i.i.i135, %if.end.i.i.i
  %39 = load i64, ptr %__dnew.i.i.i, align 8, !tbaa !60, !noalias !50
  %_M_string_length.i.i.i.i.i = getelementptr inbounds nuw %"class.std::__cxx11::basic_string", ptr %ref.tmp5, i64 0, i32 1, !intel-tbaa !62
  store i64 %39, ptr %_M_string_length.i.i.i.i.i, align 8, !tbaa !62, !alias.scope !50
  %40 = load ptr, ptr %_M_dataplus.i.i, align 8, !tbaa !61, !alias.scope !50
  %arrayidx.i.i.i.i = getelementptr inbounds nuw i8, ptr %40, i64 %39
  store i8 0, ptr %arrayidx.i.i.i.i, align 1, !tbaa !41
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %__dnew.i.i.i) #37, !noalias !50
  %41 = load ptr, ptr %str.i.i.i, align 8, !tbaa !53, !noalias !50
  %isnull.i.i = icmp eq ptr %41, null
  br i1 %isnull.i.i, label %invoke.cont10, label %delete.notnull.i.i

delete.notnull.i.i:                               ; preds = %invoke.cont4.i
  call void @_ZdaPv(ptr noundef nonnull %41) #39
  br label %invoke.cont10

lpad3.i:                                          ; preds = %if.then.i.i.i
  %42 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  %43 = load ptr, ptr %str.i.i.i, align 8, !tbaa !53, !noalias !50
  %isnull.i9.i = icmp eq ptr %43, null
  br i1 %isnull.i9.i, label %_ZN4sycl3_V16detail6stringD2Ev.exit11.i, label %delete.notnull.i10.i

delete.notnull.i10.i:                             ; preds = %lpad3.i
  call void @_ZdaPv(ptr noundef nonnull %43) #39
  br label %_ZN4sycl3_V16detail6stringD2Ev.exit11.i

_ZN4sycl3_V16detail6stringD2Ev.exit11.i:          ; preds = %delete.notnull.i10.i, %lpad3.i
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %ref.tmp.i134) #37, !noalias !50
  br label %ehcleanup17

invoke.cont10:                                    ; preds = %delete.notnull.i.i, %invoke.cont4.i
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %ref.tmp.i134) #37, !noalias !50
  %44 = load ptr, ptr %_M_dataplus.i.i, align 8, !tbaa !61
  %45 = load i64, ptr %_M_string_length.i.i.i.i.i, align 8, !tbaa !62
  %call2.i137 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef %44, i64 noundef %45)
          to label %invoke.cont12 unwind label %lpad11

invoke.cont12:                                    ; preds = %invoke.cont10
  %vtable.i = load ptr, ptr %call2.i137, align 8, !tbaa !39
  %vbase.offset.ptr.i = getelementptr i64, ptr %vtable.i, i64 -3
  %vbase.offset.i = load i64, ptr %vbase.offset.ptr.i, align 8
  %add.ptr.i = getelementptr inbounds i8, ptr %call2.i137, i64 %vbase.offset.i
  %_M_ctype.i.i = getelementptr inbounds nuw %"class.std::basic_ios", ptr %add.ptr.i, i64 0, i32 5, !intel-tbaa !63
  %46 = load ptr, ptr %_M_ctype.i.i, align 8, !tbaa !63
  %tobool.not.i.i.i364 = icmp eq ptr %46, null
  br i1 %tobool.not.i.i.i364, label %if.then.i.i.i368, label %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i

if.then.i.i.i368:                                 ; preds = %invoke.cont12
  invoke void @_ZSt16__throw_bad_castv() #40
          to label %.noexc369 unwind label %lpad11

.noexc369:                                        ; preds = %if.then.i.i.i368
  unreachable

_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i: ; preds = %invoke.cont12
  %_M_widen_ok.i.i.i = getelementptr inbounds nuw %"class.std::ctype", ptr %46, i64 0, i32 8, !intel-tbaa !81
  %47 = load i8, ptr %_M_widen_ok.i.i.i, align 8, !tbaa !81
  %tobool.not.i3.i.i = icmp eq i8 %47, 0
  br i1 %tobool.not.i3.i.i, label %if.end.i.i.i366, label %if.then.i4.i.i

if.then.i4.i.i:                                   ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i
  %arrayidx.i.i.i = getelementptr inbounds nuw %"class.std::ctype", ptr %46, i64 0, i32 9, i64 10, !intel-tbaa !88
  %48 = load i8, ptr %arrayidx.i.i.i, align 1, !tbaa !88
  br label %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i

if.end.i.i.i366:                                  ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i
  invoke void @_ZNKSt5ctypeIcE13_M_widen_initEv(ptr noundef nonnull align 8 dereferenceable(570) %46)
          to label %.noexc370 unwind label %lpad11

.noexc370:                                        ; preds = %if.end.i.i.i366
  %vtable.i.i.i = load ptr, ptr %46, align 8, !tbaa !39
  %vfn.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i, i64 6
  %49 = load ptr, ptr %vfn.i.i.i, align 8
  %call.i.i.i367371 = invoke noundef signext i8 %49(ptr noundef nonnull align 8 dereferenceable(570) %46, i8 noundef signext 10)
          to label %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i unwind label %lpad11

_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i: ; preds = %.noexc370, %if.then.i4.i.i
  %retval.0.i.i.i = phi i8 [ %48, %if.then.i4.i.i ], [ %call.i.i.i367371, %.noexc370 ]
  %call1.i372 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo3putEc(ptr noundef nonnull align 8 dereferenceable(8) %call2.i137, i8 noundef signext %retval.0.i.i.i)
          to label %call1.i.noexc unwind label %lpad11

call1.i.noexc:                                    ; preds = %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i
  %call.i.i365373 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo5flushEv(ptr noundef nonnull align 8 dereferenceable(8) %call1.i372)
          to label %invoke.cont14 unwind label %lpad11

invoke.cont14:                                    ; preds = %call1.i.noexc
  %50 = load ptr, ptr %_M_dataplus.i.i, align 8, !tbaa !61
  %cmp.i.i.i139 = icmp eq ptr %50, %arraydecay.i.i.i
  br i1 %cmp.i.i.i139, label %_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE11_M_is_localEv.exit.thread.i.i, label %if.then.i.i140

_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE11_M_is_localEv.exit.thread.i.i: ; preds = %invoke.cont14
  %51 = load i64, ptr %_M_string_length.i.i.i.i.i, align 8, !tbaa !62
  %cmp3.i.i.i = icmp ult i64 %51, 16
  call void @llvm.assume(i1 %cmp3.i.i.i)
  br label %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit

if.then.i.i140:                                   ; preds = %invoke.cont14
  %52 = load i64, ptr %35, align 8, !tbaa !41
  %add.i.i.i = add i64 %52, 1
  call void @_ZdlPvm(ptr noundef %50, i64 noundef %add.i.i.i) #39
  br label %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit

_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit: ; preds = %_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE11_M_is_localEv.exit.thread.i.i, %if.then.i.i140
  %_M_pi.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::device", ptr %ref.tmp6, i64 0, i32 0, i32 0, i32 1
  %53 = load ptr, ptr %_M_pi.i.i.i, align 8, !tbaa !33
  %cmp.not.i.i.i = icmp eq ptr %53, null
  br i1 %cmp.not.i.i.i, label %invoke.cont22, label %if.then.i.i.i142

if.then.i.i.i142:                                 ; preds = %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit
  %_M_use_count.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %53, i64 0, i32 1, !intel-tbaa !36
  %54 = load atomic i64, ptr %_M_use_count.i.i.i.i acquire, align 8
  %cmp.i.i.i.i = icmp eq i64 %54, 4294967297
  %55 = trunc i64 %54 to i32
  br i1 %cmp.i.i.i.i, label %if.then.i.i.i.i144, label %if.end.i.i.i.i

if.then.i.i.i.i144:                               ; preds = %if.then.i.i.i142
  store i32 0, ptr %_M_use_count.i.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %53, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i.i = load ptr, ptr %53, align 8, !tbaa !39
  %vfn.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i, i64 2
  %56 = load ptr, ptr %vfn.i.i.i.i, align 8
  call void %56(ptr noundef nonnull align 8 dereferenceable(16) %53) #37
  %vtable3.i.i.i.i = load ptr, ptr %53, align 8, !tbaa !39
  %vfn4.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i, i64 3
  %57 = load ptr, ptr %vfn4.i.i.i.i, align 8
  call void %57(ptr noundef nonnull align 8 dereferenceable(16) %53) #37
  br label %invoke.cont22

if.end.i.i.i.i:                                   ; preds = %if.then.i.i.i142
  %58 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i = icmp eq i8 %58, 0
  br i1 %tobool.i.not.i.i.i.i, label %if.else.i.i.i.i.i, label %if.then.i.i.i.i.i143

if.then.i.i.i.i.i143:                             ; preds = %if.end.i.i.i.i
  %add.i.i.i.i.i = add nsw i32 %55, -1
  store i32 %add.i.i.i.i.i, ptr %_M_use_count.i.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i

if.else.i.i.i.i.i:                                ; preds = %if.end.i.i.i.i
  %59 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i

invoke.cont.i.i.i.i:                              ; preds = %if.else.i.i.i.i.i, %if.then.i.i.i.i.i143
  %retval.0.i.i.i.i.i = phi i32 [ %55, %if.then.i.i.i.i.i143 ], [ %59, %if.else.i.i.i.i.i ]
  %cmp6.i.i.i.i = icmp eq i32 %retval.0.i.i.i.i.i, 1
  br i1 %cmp6.i.i.i.i, label %if.then7.i.i.i.i, label %invoke.cont22, !prof !42

if.then7.i.i.i.i:                                 ; preds = %invoke.cont.i.i.i.i
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %53) #37
  br label %invoke.cont22

invoke.cont22:                                    ; preds = %if.then7.i.i.i.i, %invoke.cont.i.i.i.i, %if.then.i.i.i.i144, %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp6) #37
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp5) #37
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %data) #37
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp20) #37
  %MDataLessProps.i.i145 = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %ref.tmp20, i64 0, i32 0, !intel-tbaa !12
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %MDataLessProps.i.i145, i8 0, i64 32, i1 false)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp23) #37
  %MFileName.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp23, i64 0, i32 0, !intel-tbaa !89
  store ptr @.str.1, ptr %MFileName.i.i, align 8, !tbaa !89, !alias.scope !91
  %MFunctionName.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp23, i64 0, i32 1, !intel-tbaa !94
  store ptr @.str.2, ptr %MFunctionName.i.i, align 8, !tbaa !94, !alias.scope !91
  %MLineNo.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp23, i64 0, i32 2, !intel-tbaa !95
  store i64 61, ptr %MLineNo.i.i, align 8, !tbaa !95, !alias.scope !91
  %MColumnNo.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp23, i64 0, i32 3, !intel-tbaa !96
  store i64 21, ptr %MColumnNo.i.i, align 8, !tbaa !96, !alias.scope !91
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp.i146) #37
  invoke void @_ZNK4sycl3_V15queue10get_deviceEv(ptr dead_on_unwind nonnull writable sret(%"class.sycl::_V1::device") align 8 %ref.tmp.i146, ptr noundef nonnull align 8 dereferenceable(16) %q)
          to label %.noexc173 unwind label %lpad24

.noexc173:                                        ; preds = %invoke.cont22
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp1.i) #37
  invoke void @_ZNK4sycl3_V15queue11get_contextEv(ptr dead_on_unwind nonnull writable sret(%"class.sycl::_V1::context") align 8 %ref.tmp1.i, ptr noundef nonnull align 8 dereferenceable(16) %q)
          to label %invoke.cont.i150 unwind label %lpad.i147

invoke.cont.i150:                                 ; preds = %.noexc173
  %call.i9.i = invoke noundef ptr @_ZN4sycl3_V120aligned_alloc_sharedEmmRKNS0_6deviceERKNS0_7contextERKNS0_13property_listERKNS0_6detail13code_locationE(i64 noundef 4, i64 noundef 4096, ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp.i146, ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp1.i, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp20, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp23)
          to label %invoke.cont3.i unwind label %lpad2.i

invoke.cont3.i:                                   ; preds = %invoke.cont.i150
  %_M_pi.i.i.i.i152 = getelementptr inbounds nuw %"class.sycl::_V1::context", ptr %ref.tmp1.i, i64 0, i32 0, i32 0, i32 1
  %60 = load ptr, ptr %_M_pi.i.i.i.i152, align 8, !tbaa !33
  %cmp.not.i.i.i.i153 = icmp eq ptr %60, null
  br i1 %cmp.not.i.i.i.i153, label %_ZN4sycl3_V17contextD2Ev.exit.i, label %if.then.i.i.i.i154

if.then.i.i.i.i154:                               ; preds = %invoke.cont3.i
  %_M_use_count.i.i.i.i.i155 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %60, i64 0, i32 1, !intel-tbaa !36
  %61 = load atomic i64, ptr %_M_use_count.i.i.i.i.i155 acquire, align 8
  %cmp.i.i.i.i.i156 = icmp eq i64 %61, 4294967297
  %62 = trunc i64 %61 to i32
  br i1 %cmp.i.i.i.i.i156, label %if.then.i.i.i.i.i167, label %if.end.i.i.i.i.i157

if.then.i.i.i.i.i167:                             ; preds = %if.then.i.i.i.i154
  store i32 0, ptr %_M_use_count.i.i.i.i.i155, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i.i168 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %60, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i.i168, align 4, !tbaa !38
  %vtable.i.i.i.i.i169 = load ptr, ptr %60, align 8, !tbaa !39
  %vfn.i.i.i.i.i170 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i169, i64 2
  %63 = load ptr, ptr %vfn.i.i.i.i.i170, align 8
  call void %63(ptr noundef nonnull align 8 dereferenceable(16) %60) #37
  %vtable3.i.i.i.i.i171 = load ptr, ptr %60, align 8, !tbaa !39
  %vfn4.i.i.i.i.i172 = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i.i171, i64 3
  %64 = load ptr, ptr %vfn4.i.i.i.i.i172, align 8
  call void %64(ptr noundef nonnull align 8 dereferenceable(16) %60) #37
  br label %_ZN4sycl3_V17contextD2Ev.exit.i

if.end.i.i.i.i.i157:                              ; preds = %if.then.i.i.i.i154
  %65 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i.i158 = icmp eq i8 %65, 0
  br i1 %tobool.i.not.i.i.i.i.i158, label %if.else.i.i.i.i.i.i166, label %if.then.i.i.i.i.i.i159

if.then.i.i.i.i.i.i159:                           ; preds = %if.end.i.i.i.i.i157
  %add.i.i.i.i.i.i160 = add nsw i32 %62, -1
  store i32 %add.i.i.i.i.i.i160, ptr %_M_use_count.i.i.i.i.i155, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i.i161

if.else.i.i.i.i.i.i166:                           ; preds = %if.end.i.i.i.i.i157
  %66 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i.i155, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i.i161

invoke.cont.i.i.i.i.i161:                         ; preds = %if.else.i.i.i.i.i.i166, %if.then.i.i.i.i.i.i159
  %retval.0.i.i.i.i.i.i162 = phi i32 [ %62, %if.then.i.i.i.i.i.i159 ], [ %66, %if.else.i.i.i.i.i.i166 ]
  %cmp6.i.i.i.i.i163 = icmp eq i32 %retval.0.i.i.i.i.i.i162, 1
  br i1 %cmp6.i.i.i.i.i163, label %if.then7.i.i.i.i.i165, label %_ZN4sycl3_V17contextD2Ev.exit.i, !prof !42

if.then7.i.i.i.i.i165:                            ; preds = %invoke.cont.i.i.i.i.i161
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %60) #37
  br label %_ZN4sycl3_V17contextD2Ev.exit.i

_ZN4sycl3_V17contextD2Ev.exit.i:                  ; preds = %if.then7.i.i.i.i.i165, %invoke.cont.i.i.i.i.i161, %if.then.i.i.i.i.i167, %invoke.cont3.i
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp1.i) #37
  %_M_pi.i.i.i11.i = getelementptr inbounds nuw %"class.sycl::_V1::device", ptr %ref.tmp.i146, i64 0, i32 0, i32 0, i32 1
  %67 = load ptr, ptr %_M_pi.i.i.i11.i, align 8, !tbaa !33
  %cmp.not.i.i.i12.i = icmp eq ptr %67, null
  br i1 %cmp.not.i.i.i12.i, label %invoke.cont25, label %if.then.i.i.i13.i

if.then.i.i.i13.i:                                ; preds = %_ZN4sycl3_V17contextD2Ev.exit.i
  %_M_use_count.i.i.i.i14.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %67, i64 0, i32 1, !intel-tbaa !36
  %68 = load atomic i64, ptr %_M_use_count.i.i.i.i14.i acquire, align 8
  %cmp.i.i.i.i15.i = icmp eq i64 %68, 4294967297
  %69 = trunc i64 %68 to i32
  br i1 %cmp.i.i.i.i15.i, label %if.then.i.i.i.i25.i, label %if.end.i.i.i.i16.i

if.then.i.i.i.i25.i:                              ; preds = %if.then.i.i.i13.i
  store i32 0, ptr %_M_use_count.i.i.i.i14.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i26.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %67, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i26.i, align 4, !tbaa !38
  %vtable.i.i.i.i27.i = load ptr, ptr %67, align 8, !tbaa !39
  %vfn.i.i.i.i28.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i27.i, i64 2
  %70 = load ptr, ptr %vfn.i.i.i.i28.i, align 8
  call void %70(ptr noundef nonnull align 8 dereferenceable(16) %67) #37
  %vtable3.i.i.i.i29.i = load ptr, ptr %67, align 8, !tbaa !39
  %vfn4.i.i.i.i30.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i29.i, i64 3
  %71 = load ptr, ptr %vfn4.i.i.i.i30.i, align 8
  call void %71(ptr noundef nonnull align 8 dereferenceable(16) %67) #37
  br label %invoke.cont25

if.end.i.i.i.i16.i:                               ; preds = %if.then.i.i.i13.i
  %72 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i17.i = icmp eq i8 %72, 0
  br i1 %tobool.i.not.i.i.i.i17.i, label %if.else.i.i.i.i.i24.i, label %if.then.i.i.i.i.i18.i

if.then.i.i.i.i.i18.i:                            ; preds = %if.end.i.i.i.i16.i
  %add.i.i.i.i.i19.i = add nsw i32 %69, -1
  store i32 %add.i.i.i.i.i19.i, ptr %_M_use_count.i.i.i.i14.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i20.i

if.else.i.i.i.i.i24.i:                            ; preds = %if.end.i.i.i.i16.i
  %73 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i14.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i20.i

invoke.cont.i.i.i.i20.i:                          ; preds = %if.else.i.i.i.i.i24.i, %if.then.i.i.i.i.i18.i
  %retval.0.i.i.i.i.i21.i = phi i32 [ %69, %if.then.i.i.i.i.i18.i ], [ %73, %if.else.i.i.i.i.i24.i ]
  %cmp6.i.i.i.i22.i = icmp eq i32 %retval.0.i.i.i.i.i21.i, 1
  br i1 %cmp6.i.i.i.i22.i, label %if.then7.i.i.i.i23.i, label %invoke.cont25, !prof !42

if.then7.i.i.i.i23.i:                             ; preds = %invoke.cont.i.i.i.i20.i
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %67) #37
  br label %invoke.cont25

lpad.i147:                                        ; preds = %.noexc173
  %74 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup.i148

lpad2.i:                                          ; preds = %invoke.cont.i150
  %75 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  call void @_ZN4sycl3_V17contextD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp1.i) #37
  br label %ehcleanup.i148

ehcleanup.i148:                                   ; preds = %lpad2.i, %lpad.i147
  %.pn.i149 = phi { ptr, i32 } [ %75, %lpad2.i ], [ %74, %lpad.i147 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp1.i) #37
  call void @_ZN4sycl3_V16deviceD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp.i146) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp.i146) #37
  br label %lpad24.body

invoke.cont25:                                    ; preds = %if.then7.i.i.i.i23.i, %invoke.cont.i.i.i.i20.i, %if.then.i.i.i.i25.i, %_ZN4sycl3_V17contextD2Ev.exit.i
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp.i146) #37
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp23) #37
  %_M_start.i.i177 = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %ref.tmp20, i64 0, i32 1
  %76 = load ptr, ptr %_M_start.i.i177, align 8, !tbaa !43
  %_M_finish.i.i178 = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %ref.tmp20, i64 0, i32 1, i32 0, i32 0, i32 0, i32 1
  %77 = load ptr, ptr %_M_finish.i.i178, align 8, !tbaa !44
  %cmp.not3.i.i.i.i.i179 = icmp eq ptr %76, %77
  br i1 %cmp.not3.i.i.i.i.i179, label %invoke.cont.i.i199, label %for.body.i.i.i.i.i180

for.body.i.i.i.i.i180:                            ; preds = %invoke.cont25, %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i194
  %__first.addr.04.i.i.i.i.i181 = phi ptr [ %incdec.ptr.i.i.i.i.i195, %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i194 ], [ %76, %invoke.cont25 ]
  %_M_pi.i.i.i.i.i.i.i.i182 = getelementptr inbounds nuw %"class.std::__shared_ptr.21", ptr %__first.addr.04.i.i.i.i.i181, i64 0, i32 1, i32 0, !intel-tbaa !45
  %78 = load ptr, ptr %_M_pi.i.i.i.i.i.i.i.i182, align 8, !tbaa !33
  %cmp.not.i.i.i.i.i.i.i.i183 = icmp eq ptr %78, null
  br i1 %cmp.not.i.i.i.i.i.i.i.i183, label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i194, label %if.then.i.i.i.i.i.i.i.i184

if.then.i.i.i.i.i.i.i.i184:                       ; preds = %for.body.i.i.i.i.i180
  %_M_use_count.i.i.i.i.i.i.i.i.i185 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %78, i64 0, i32 1, !intel-tbaa !36
  %79 = load atomic i64, ptr %_M_use_count.i.i.i.i.i.i.i.i.i185 acquire, align 8
  %cmp.i.i.i.i.i.i.i.i.i186 = icmp eq i64 %79, 4294967297
  %80 = trunc i64 %79 to i32
  br i1 %cmp.i.i.i.i.i.i.i.i.i186, label %if.then.i.i.i.i.i.i.i.i.i208, label %if.end.i.i.i.i.i.i.i.i.i187

if.then.i.i.i.i.i.i.i.i.i208:                     ; preds = %if.then.i.i.i.i.i.i.i.i184
  store i32 0, ptr %_M_use_count.i.i.i.i.i.i.i.i.i185, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i.i.i.i.i.i209 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %78, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i.i.i.i.i.i209, align 4, !tbaa !38
  %vtable.i.i.i.i.i.i.i.i.i210 = load ptr, ptr %78, align 8, !tbaa !39
  %vfn.i.i.i.i.i.i.i.i.i211 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i.i.i.i.i210, i64 2
  %81 = load ptr, ptr %vfn.i.i.i.i.i.i.i.i.i211, align 8
  call void %81(ptr noundef nonnull align 8 dereferenceable(16) %78) #37
  %vtable3.i.i.i.i.i.i.i.i.i212 = load ptr, ptr %78, align 8, !tbaa !39
  %vfn4.i.i.i.i.i.i.i.i.i213 = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i.i.i.i.i.i212, i64 3
  %82 = load ptr, ptr %vfn4.i.i.i.i.i.i.i.i.i213, align 8
  call void %82(ptr noundef nonnull align 8 dereferenceable(16) %78) #37
  br label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i194

if.end.i.i.i.i.i.i.i.i.i187:                      ; preds = %if.then.i.i.i.i.i.i.i.i184
  %83 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i.i.i.i.i.i188 = icmp eq i8 %83, 0
  br i1 %tobool.i.not.i.i.i.i.i.i.i.i.i188, label %if.else.i.i.i.i.i.i.i.i.i.i207, label %if.then.i.i.i.i.i.i.i.i.i.i189

if.then.i.i.i.i.i.i.i.i.i.i189:                   ; preds = %if.end.i.i.i.i.i.i.i.i.i187
  %add.i.i.i.i.i.i.i.i.i.i190 = add nsw i32 %80, -1
  store i32 %add.i.i.i.i.i.i.i.i.i.i190, ptr %_M_use_count.i.i.i.i.i.i.i.i.i185, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i.i.i.i.i.i191

if.else.i.i.i.i.i.i.i.i.i.i207:                   ; preds = %if.end.i.i.i.i.i.i.i.i.i187
  %84 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i.i.i.i.i.i185, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i.i.i.i.i.i191

invoke.cont.i.i.i.i.i.i.i.i.i191:                 ; preds = %if.else.i.i.i.i.i.i.i.i.i.i207, %if.then.i.i.i.i.i.i.i.i.i.i189
  %retval.0.i.i.i.i.i.i.i.i.i.i192 = phi i32 [ %80, %if.then.i.i.i.i.i.i.i.i.i.i189 ], [ %84, %if.else.i.i.i.i.i.i.i.i.i.i207 ]
  %cmp6.i.i.i.i.i.i.i.i.i193 = icmp eq i32 %retval.0.i.i.i.i.i.i.i.i.i.i192, 1
  br i1 %cmp6.i.i.i.i.i.i.i.i.i193, label %if.then7.i.i.i.i.i.i.i.i.i206, label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i194, !prof !42

if.then7.i.i.i.i.i.i.i.i.i206:                    ; preds = %invoke.cont.i.i.i.i.i.i.i.i.i191
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %78) #37
  br label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i194

_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i194: ; preds = %if.then7.i.i.i.i.i.i.i.i.i206, %invoke.cont.i.i.i.i.i.i.i.i.i191, %if.then.i.i.i.i.i.i.i.i.i208, %for.body.i.i.i.i.i180
  %incdec.ptr.i.i.i.i.i195 = getelementptr inbounds nuw %"class.std::shared_ptr.20", ptr %__first.addr.04.i.i.i.i.i181, i64 1
  %cmp.not.i.i.i.i.i196 = icmp eq ptr %incdec.ptr.i.i.i.i.i195, %77
  br i1 %cmp.not.i.i.i.i.i196, label %invoke.contthread-pre-split.i.i197, label %for.body.i.i.i.i.i180, !llvm.loop !48

invoke.contthread-pre-split.i.i197:               ; preds = %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i.i194
  %.pr.i.i198 = load ptr, ptr %_M_start.i.i177, align 8, !tbaa !43
  br label %invoke.cont.i.i199

invoke.cont.i.i199:                               ; preds = %invoke.contthread-pre-split.i.i197, %invoke.cont25
  %85 = phi ptr [ %.pr.i.i198, %invoke.contthread-pre-split.i.i197 ], [ %76, %invoke.cont25 ]
  %tobool.not.i.i.i.i200 = icmp eq ptr %85, null
  br i1 %tobool.not.i.i.i.i200, label %_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit214, label %if.then.i.i.i.i201

if.then.i.i.i.i201:                               ; preds = %invoke.cont.i.i199
  %_M_end_of_storage.i.i.i202 = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %ref.tmp20, i64 0, i32 1, i32 0, i32 0, i32 0, i32 2
  %86 = load ptr, ptr %_M_end_of_storage.i.i.i202, align 8, !tbaa !49
  %sub.ptr.lhs.cast.i.i.i203 = ptrtoint ptr %86 to i64
  %sub.ptr.rhs.cast.i.i.i204 = ptrtoint ptr %85 to i64
  %sub.ptr.sub.i.i.i205 = sub i64 %sub.ptr.lhs.cast.i.i.i203, %sub.ptr.rhs.cast.i.i.i204
  call void @_ZdlPvm(ptr noundef nonnull %85, i64 noundef %sub.ptr.sub.i.i.i205) #39
  br label %_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit214

_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit214: ; preds = %invoke.cont.i.i199, %if.then.i.i.i.i201
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp20) #37
  store ptr %call.i9.i, ptr %data, align 8, !tbaa !97
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 4 dereferenceable(4096) %call.i9.i, i8 0, i64 4096, i1 false), !tbaa !9
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp30) #37
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp32) #37
  %MFileName.i.i215 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp32, i64 0, i32 0, !intel-tbaa !89
  store ptr @.str.1, ptr %MFileName.i.i215, align 8, !tbaa !89, !alias.scope !98
  %MFunctionName.i.i216 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp32, i64 0, i32 1, !intel-tbaa !94
  store ptr @.str.2, ptr %MFunctionName.i.i216, align 8, !tbaa !94, !alias.scope !98
  %MLineNo.i.i217 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp32, i64 0, i32 2, !intel-tbaa !95
  store i64 69, ptr %MLineNo.i.i217, align 8, !tbaa !95, !alias.scope !98
  %MColumnNo.i.i218 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp32, i64 0, i32 3, !intel-tbaa !96
  store i64 11, ptr %MColumnNo.i.i218, align 8, !tbaa !96, !alias.scope !98
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %CGF.i)
  %coerce.dive.i = getelementptr inbounds nuw %class._ZTSZ4mainEUlRN4sycl3_V17handlerEE_, ptr %CGF.i, i64 0, i32 0
  store ptr %data, ptr %coerce.dive.i, align 8, !noalias !101
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp.i219) #37, !noalias !101
  %object.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::type_erased_cgfo_ty", ptr %ref.tmp.i219, i64 0, i32 0, !intel-tbaa !104
  store ptr %CGF.i, ptr %object.i.i, align 8, !tbaa !104, !noalias !101
  %invoker_f.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::type_erased_cgfo_ty", ptr %ref.tmp.i219, i64 0, i32 1, !intel-tbaa !106
  store ptr @_ZN4sycl3_V16detail19type_erased_cgfo_ty7invokerIZ4mainEUlRNS0_7handlerEE_E4callEPKvS5_, ptr %invoker_f.i.i, align 8, !tbaa !106, !noalias !101
  invoke void @_ZN4sycl3_V15queue17submit_with_eventILb0ENS0_3ext6oneapi12experimental10propertiesINS5_6detail20properties_type_listIJEEEEEEENS0_5eventET0_RKNS0_6detail19type_erased_cgfo_tyEPS1_RKNSD_13code_locationE(ptr dead_on_unwind nonnull writable sret(%"class.sycl::_V1::event") align 8 %ref.tmp30, ptr noundef nonnull align 8 dereferenceable(16) %q, ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp.i219, ptr noundef null, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp32)
          to label %invoke.cont34 unwind label %lpad33

lpad3:                                            ; preds = %_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit
  %87 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup96

lpad7:                                            ; preds = %invoke.cont4
  %88 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup18

lpad9:                                            ; preds = %invoke.cont8
  %89 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup17

lpad11:                                           ; preds = %call1.i.noexc, %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i, %.noexc370, %if.end.i.i.i366, %if.then.i.i.i368, %invoke.cont10
  %90 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  %91 = load ptr, ptr %_M_dataplus.i.i, align 8, !tbaa !61
  %cmp.i.i.i223 = icmp eq ptr %91, %arraydecay.i.i.i
  br i1 %cmp.i.i.i223, label %_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE11_M_is_localEv.exit.thread.i.i227, label %if.then.i.i224

_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE11_M_is_localEv.exit.thread.i.i227: ; preds = %lpad11
  %92 = load i64, ptr %_M_string_length.i.i.i.i.i, align 8, !tbaa !62
  %cmp3.i.i.i229 = icmp ult i64 %92, 16
  call void @llvm.assume(i1 %cmp3.i.i.i229)
  br label %ehcleanup17

if.then.i.i224:                                   ; preds = %lpad11
  %93 = load i64, ptr %35, align 8, !tbaa !41
  %add.i.i.i225 = add i64 %93, 1
  call void @_ZdlPvm(ptr noundef %91, i64 noundef %add.i.i.i225) #39
  br label %ehcleanup17

ehcleanup17:                                      ; preds = %if.then.i.i224, %_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE11_M_is_localEv.exit.thread.i.i227, %lpad9, %_ZN4sycl3_V16detail6stringD2Ev.exit11.i
  %.pn116 = phi { ptr, i32 } [ %89, %lpad9 ], [ %42, %_ZN4sycl3_V16detail6stringD2Ev.exit11.i ], [ %90, %_ZNKSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE11_M_is_localEv.exit.thread.i.i227 ], [ %90, %if.then.i.i224 ]
  call void @_ZN4sycl3_V16deviceD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp6) #37
  br label %ehcleanup18

ehcleanup18:                                      ; preds = %ehcleanup17, %lpad7
  %.pn116.pn = phi { ptr, i32 } [ %.pn116, %ehcleanup17 ], [ %88, %lpad7 ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp6) #37
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp5) #37
  br label %ehcleanup96

lpad24:                                           ; preds = %invoke.cont22
  %94 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %lpad24.body

lpad24.body:                                      ; preds = %ehcleanup.i148, %lpad24
  %eh.lpad-body174 = phi { ptr, i32 } [ %94, %lpad24 ], [ %.pn.i149, %ehcleanup.i148 ]
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp23) #37
  call void @_ZN4sycl3_V16detail16PropertyListBaseD2Ev(ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp20) #37
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp20) #37
  br label %ehcleanup94

invoke.cont34:                                    ; preds = %_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit214
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp.i219) #37, !noalias !101
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %CGF.i)
  invoke void @_ZN4sycl3_V15event4waitEv(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp30)
          to label %invoke.cont36 unwind label %lpad35

invoke.cont36:                                    ; preds = %invoke.cont34
  %_M_pi.i.i.i232 = getelementptr inbounds nuw %"class.sycl::_V1::event", ptr %ref.tmp30, i64 0, i32 0, i32 0, i32 1
  %95 = load ptr, ptr %_M_pi.i.i.i232, align 8, !tbaa !33
  %cmp.not.i.i.i233 = icmp eq ptr %95, null
  br i1 %cmp.not.i.i.i233, label %_ZN4sycl3_V15eventD2Ev.exit, label %if.then.i.i.i234

if.then.i.i.i234:                                 ; preds = %invoke.cont36
  %_M_use_count.i.i.i.i235 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %95, i64 0, i32 1, !intel-tbaa !36
  %96 = load atomic i64, ptr %_M_use_count.i.i.i.i235 acquire, align 8
  %cmp.i.i.i.i236 = icmp eq i64 %96, 4294967297
  %97 = trunc i64 %96 to i32
  br i1 %cmp.i.i.i.i236, label %if.then.i.i.i.i246, label %if.end.i.i.i.i237

if.then.i.i.i.i246:                               ; preds = %if.then.i.i.i234
  store i32 0, ptr %_M_use_count.i.i.i.i235, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i247 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %95, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i247, align 4, !tbaa !38
  %vtable.i.i.i.i248 = load ptr, ptr %95, align 8, !tbaa !39
  %vfn.i.i.i.i249 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i248, i64 2
  %98 = load ptr, ptr %vfn.i.i.i.i249, align 8
  call void %98(ptr noundef nonnull align 8 dereferenceable(16) %95) #37
  %vtable3.i.i.i.i250 = load ptr, ptr %95, align 8, !tbaa !39
  %vfn4.i.i.i.i251 = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i250, i64 3
  %99 = load ptr, ptr %vfn4.i.i.i.i251, align 8
  call void %99(ptr noundef nonnull align 8 dereferenceable(16) %95) #37
  br label %_ZN4sycl3_V15eventD2Ev.exit

if.end.i.i.i.i237:                                ; preds = %if.then.i.i.i234
  %100 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i238 = icmp eq i8 %100, 0
  br i1 %tobool.i.not.i.i.i.i238, label %if.else.i.i.i.i.i245, label %if.then.i.i.i.i.i239

if.then.i.i.i.i.i239:                             ; preds = %if.end.i.i.i.i237
  %add.i.i.i.i.i240 = add nsw i32 %97, -1
  store i32 %add.i.i.i.i.i240, ptr %_M_use_count.i.i.i.i235, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i241

if.else.i.i.i.i.i245:                             ; preds = %if.end.i.i.i.i237
  %101 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i235, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i241

invoke.cont.i.i.i.i241:                           ; preds = %if.else.i.i.i.i.i245, %if.then.i.i.i.i.i239
  %retval.0.i.i.i.i.i242 = phi i32 [ %97, %if.then.i.i.i.i.i239 ], [ %101, %if.else.i.i.i.i.i245 ]
  %cmp6.i.i.i.i243 = icmp eq i32 %retval.0.i.i.i.i.i242, 1
  br i1 %cmp6.i.i.i.i243, label %if.then7.i.i.i.i244, label %_ZN4sycl3_V15eventD2Ev.exit, !prof !42

if.then7.i.i.i.i244:                              ; preds = %invoke.cont.i.i.i.i241
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %95) #37
  br label %_ZN4sycl3_V15eventD2Ev.exit

_ZN4sycl3_V15eventD2Ev.exit:                      ; preds = %invoke.cont36, %if.then.i.i.i.i246, %invoke.cont.i.i.i.i241, %if.then7.i.i.i.i244
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp32) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp30) #37
  %call1.i253 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef nonnull @.str.3, i64 noundef 21)
          to label %invoke.cont41 unwind label %lpad40

invoke.cont41:                                    ; preds = %_ZN4sycl3_V15eventD2Ev.exit
  %102 = load ptr, ptr %data, align 8, !tbaa !97
  %103 = load i32, ptr %102, align 4, !tbaa !9
  %call45 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i32 noundef %103)
          to label %invoke.cont44 unwind label %lpad40

invoke.cont44:                                    ; preds = %invoke.cont41
  %vtable.i374 = load ptr, ptr %call45, align 8, !tbaa !39
  %vbase.offset.ptr.i375 = getelementptr i64, ptr %vtable.i374, i64 -3
  %vbase.offset.i376 = load i64, ptr %vbase.offset.ptr.i375, align 8
  %add.ptr.i377 = getelementptr inbounds i8, ptr %call45, i64 %vbase.offset.i376
  %_M_ctype.i.i378 = getelementptr inbounds nuw %"class.std::basic_ios", ptr %add.ptr.i377, i64 0, i32 5, !intel-tbaa !63
  %104 = load ptr, ptr %_M_ctype.i.i378, align 8, !tbaa !63
  %tobool.not.i.i.i379 = icmp eq ptr %104, null
  br i1 %tobool.not.i.i.i379, label %if.then.i.i.i444.invoke, label %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i380

_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i380: ; preds = %invoke.cont44
  %_M_widen_ok.i.i.i381 = getelementptr inbounds nuw %"class.std::ctype", ptr %104, i64 0, i32 8, !intel-tbaa !81
  %105 = load i8, ptr %_M_widen_ok.i.i.i381, align 8, !tbaa !81
  %tobool.not.i3.i.i382 = icmp eq i8 %105, 0
  br i1 %tobool.not.i3.i.i382, label %if.end.i.i.i388, label %if.then.i4.i.i383

if.then.i4.i.i383:                                ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i380
  %arrayidx.i.i.i384 = getelementptr inbounds nuw %"class.std::ctype", ptr %104, i64 0, i32 9, i64 10, !intel-tbaa !88
  %106 = load i8, ptr %arrayidx.i.i.i384, align 1, !tbaa !88
  br label %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i385

if.end.i.i.i388:                                  ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i380
  invoke void @_ZNKSt5ctypeIcE13_M_widen_initEv(ptr noundef nonnull align 8 dereferenceable(570) %104)
          to label %.noexc394 unwind label %lpad40

.noexc394:                                        ; preds = %if.end.i.i.i388
  %vtable.i.i.i389 = load ptr, ptr %104, align 8, !tbaa !39
  %vfn.i.i.i390 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i389, i64 6
  %107 = load ptr, ptr %vfn.i.i.i390, align 8
  %call.i.i.i391395 = invoke noundef signext i8 %107(ptr noundef nonnull align 8 dereferenceable(570) %104, i8 noundef signext 10)
          to label %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i385 unwind label %lpad40

_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i385: ; preds = %.noexc394, %if.then.i4.i.i383
  %retval.0.i.i.i386 = phi i8 [ %106, %if.then.i4.i.i383 ], [ %call.i.i.i391395, %.noexc394 ]
  %call1.i397 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo3putEc(ptr noundef nonnull align 8 dereferenceable(8) %call45, i8 noundef signext %retval.0.i.i.i386)
          to label %call1.i.noexc396 unwind label %lpad40

call1.i.noexc396:                                 ; preds = %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i385
  %call.i.i387398 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo5flushEv(ptr noundef nonnull align 8 dereferenceable(8) %call1.i397)
          to label %invoke.cont46 unwind label %lpad40

invoke.cont46:                                    ; preds = %call1.i.noexc396
  %108 = load ptr, ptr %data, align 8, !tbaa !97
  store i32 0, ptr %108, align 4, !tbaa !9
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp49) #37
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp52) #37
  %MFileName.i.i257 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp52, i64 0, i32 0, !intel-tbaa !89
  store ptr @.str.1, ptr %MFileName.i.i257, align 8, !tbaa !89, !alias.scope !107
  %MFunctionName.i.i258 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp52, i64 0, i32 1, !intel-tbaa !94
  store ptr @.str.2, ptr %MFunctionName.i.i258, align 8, !tbaa !94, !alias.scope !107
  %MLineNo.i.i259 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp52, i64 0, i32 2, !intel-tbaa !95
  store i64 81, ptr %MLineNo.i.i259, align 8, !tbaa !95, !alias.scope !107
  %MColumnNo.i.i260 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp52, i64 0, i32 3, !intel-tbaa !96
  store i64 11, ptr %MColumnNo.i.i260, align 8, !tbaa !96, !alias.scope !107
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %CGF.i261)
  %coerce.dive.i263 = getelementptr inbounds nuw %class._ZTSZ4mainEUlRN4sycl3_V17handlerEE0_, ptr %CGF.i261, i64 0, i32 0
  store ptr %data, ptr %coerce.dive.i263, align 8, !noalias !110
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp.i262) #37, !noalias !110
  %object.i.i264 = getelementptr inbounds nuw %"class.sycl::_V1::detail::type_erased_cgfo_ty", ptr %ref.tmp.i262, i64 0, i32 0, !intel-tbaa !104
  store ptr %CGF.i261, ptr %object.i.i264, align 8, !tbaa !104, !noalias !110
  %invoker_f.i.i265 = getelementptr inbounds nuw %"class.sycl::_V1::detail::type_erased_cgfo_ty", ptr %ref.tmp.i262, i64 0, i32 1, !intel-tbaa !106
  store ptr @_ZN4sycl3_V16detail19type_erased_cgfo_ty7invokerIZ4mainEUlRNS0_7handlerEE0_E4callEPKvS5_, ptr %invoker_f.i.i265, align 8, !tbaa !106, !noalias !110
  invoke void @_ZN4sycl3_V15queue17submit_with_eventILb0ENS0_3ext6oneapi12experimental10propertiesINS5_6detail20properties_type_listIJEEEEEEENS0_5eventET0_RKNS0_6detail19type_erased_cgfo_tyEPS1_RKNSD_13code_locationE(ptr dead_on_unwind nonnull writable sret(%"class.sycl::_V1::event") align 8 %ref.tmp49, ptr noundef nonnull align 8 dereferenceable(16) %q, ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp.i262, ptr noundef null, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp52)
          to label %invoke.cont55 unwind label %lpad54

invoke.cont55:                                    ; preds = %invoke.cont46
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp.i262) #37, !noalias !110
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %CGF.i261)
  invoke void @_ZN4sycl3_V15event4waitEv(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp49)
          to label %invoke.cont57 unwind label %lpad56

invoke.cont57:                                    ; preds = %invoke.cont55
  %_M_pi.i.i.i268 = getelementptr inbounds nuw %"class.sycl::_V1::event", ptr %ref.tmp49, i64 0, i32 0, i32 0, i32 1
  %109 = load ptr, ptr %_M_pi.i.i.i268, align 8, !tbaa !33
  %cmp.not.i.i.i269 = icmp eq ptr %109, null
  br i1 %cmp.not.i.i.i269, label %_ZN4sycl3_V15eventD2Ev.exit288, label %if.then.i.i.i270

if.then.i.i.i270:                                 ; preds = %invoke.cont57
  %_M_use_count.i.i.i.i271 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %109, i64 0, i32 1, !intel-tbaa !36
  %110 = load atomic i64, ptr %_M_use_count.i.i.i.i271 acquire, align 8
  %cmp.i.i.i.i272 = icmp eq i64 %110, 4294967297
  %111 = trunc i64 %110 to i32
  br i1 %cmp.i.i.i.i272, label %if.then.i.i.i.i282, label %if.end.i.i.i.i273

if.then.i.i.i.i282:                               ; preds = %if.then.i.i.i270
  store i32 0, ptr %_M_use_count.i.i.i.i271, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i283 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %109, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i283, align 4, !tbaa !38
  %vtable.i.i.i.i284 = load ptr, ptr %109, align 8, !tbaa !39
  %vfn.i.i.i.i285 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i284, i64 2
  %112 = load ptr, ptr %vfn.i.i.i.i285, align 8
  call void %112(ptr noundef nonnull align 8 dereferenceable(16) %109) #37
  %vtable3.i.i.i.i286 = load ptr, ptr %109, align 8, !tbaa !39
  %vfn4.i.i.i.i287 = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i286, i64 3
  %113 = load ptr, ptr %vfn4.i.i.i.i287, align 8
  call void %113(ptr noundef nonnull align 8 dereferenceable(16) %109) #37
  br label %_ZN4sycl3_V15eventD2Ev.exit288

if.end.i.i.i.i273:                                ; preds = %if.then.i.i.i270
  %114 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i274 = icmp eq i8 %114, 0
  br i1 %tobool.i.not.i.i.i.i274, label %if.else.i.i.i.i.i281, label %if.then.i.i.i.i.i275

if.then.i.i.i.i.i275:                             ; preds = %if.end.i.i.i.i273
  %add.i.i.i.i.i276 = add nsw i32 %111, -1
  store i32 %add.i.i.i.i.i276, ptr %_M_use_count.i.i.i.i271, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i277

if.else.i.i.i.i.i281:                             ; preds = %if.end.i.i.i.i273
  %115 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i271, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i277

invoke.cont.i.i.i.i277:                           ; preds = %if.else.i.i.i.i.i281, %if.then.i.i.i.i.i275
  %retval.0.i.i.i.i.i278 = phi i32 [ %111, %if.then.i.i.i.i.i275 ], [ %115, %if.else.i.i.i.i.i281 ]
  %cmp6.i.i.i.i279 = icmp eq i32 %retval.0.i.i.i.i.i278, 1
  br i1 %cmp6.i.i.i.i279, label %if.then7.i.i.i.i280, label %_ZN4sycl3_V15eventD2Ev.exit288, !prof !42

if.then7.i.i.i.i280:                              ; preds = %invoke.cont.i.i.i.i277
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %109) #37
  br label %_ZN4sycl3_V15eventD2Ev.exit288

_ZN4sycl3_V15eventD2Ev.exit288:                   ; preds = %invoke.cont57, %if.then.i.i.i.i282, %invoke.cont.i.i.i.i277, %if.then7.i.i.i.i280
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp52) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp49) #37
  %call1.i290 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef nonnull @.str.4, i64 noundef 23)
          to label %invoke.cont61 unwind label %lpad40

invoke.cont61:                                    ; preds = %_ZN4sycl3_V15eventD2Ev.exit288
  %116 = load ptr, ptr %data, align 8, !tbaa !97
  %117 = load i32, ptr %116, align 4, !tbaa !9
  %call65 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i32 noundef %117)
          to label %invoke.cont64 unwind label %lpad40

invoke.cont64:                                    ; preds = %invoke.cont61
  %call1.i293 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) %call65, ptr noundef nonnull @.str.5, i64 noundef 27)
          to label %invoke.cont66 unwind label %lpad40

invoke.cont66:                                    ; preds = %invoke.cont64
  %vtable.i400 = load ptr, ptr %call65, align 8, !tbaa !39
  %vbase.offset.ptr.i401 = getelementptr i64, ptr %vtable.i400, i64 -3
  %vbase.offset.i402 = load i64, ptr %vbase.offset.ptr.i401, align 8
  %add.ptr.i403 = getelementptr inbounds i8, ptr %call65, i64 %vbase.offset.i402
  %_M_ctype.i.i404 = getelementptr inbounds nuw %"class.std::basic_ios", ptr %add.ptr.i403, i64 0, i32 5, !intel-tbaa !63
  %118 = load ptr, ptr %_M_ctype.i.i404, align 8, !tbaa !63
  %tobool.not.i.i.i405 = icmp eq ptr %118, null
  br i1 %tobool.not.i.i.i405, label %if.then.i.i.i444.invoke, label %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i406

_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i406: ; preds = %invoke.cont66
  %_M_widen_ok.i.i.i407 = getelementptr inbounds nuw %"class.std::ctype", ptr %118, i64 0, i32 8, !intel-tbaa !81
  %119 = load i8, ptr %_M_widen_ok.i.i.i407, align 8, !tbaa !81
  %tobool.not.i3.i.i408 = icmp eq i8 %119, 0
  br i1 %tobool.not.i3.i.i408, label %if.end.i.i.i414, label %if.then.i4.i.i409

if.then.i4.i.i409:                                ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i406
  %arrayidx.i.i.i410 = getelementptr inbounds nuw %"class.std::ctype", ptr %118, i64 0, i32 9, i64 10, !intel-tbaa !88
  %120 = load i8, ptr %arrayidx.i.i.i410, align 1, !tbaa !88
  br label %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i411

if.end.i.i.i414:                                  ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i406
  invoke void @_ZNKSt5ctypeIcE13_M_widen_initEv(ptr noundef nonnull align 8 dereferenceable(570) %118)
          to label %.noexc420 unwind label %lpad40

.noexc420:                                        ; preds = %if.end.i.i.i414
  %vtable.i.i.i415 = load ptr, ptr %118, align 8, !tbaa !39
  %vfn.i.i.i416 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i415, i64 6
  %121 = load ptr, ptr %vfn.i.i.i416, align 8
  %call.i.i.i417421 = invoke noundef signext i8 %121(ptr noundef nonnull align 8 dereferenceable(570) %118, i8 noundef signext 10)
          to label %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i411 unwind label %lpad40

_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i411: ; preds = %.noexc420, %if.then.i4.i.i409
  %retval.0.i.i.i412 = phi i8 [ %120, %if.then.i4.i.i409 ], [ %call.i.i.i417421, %.noexc420 ]
  %call1.i423 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo3putEc(ptr noundef nonnull align 8 dereferenceable(8) %call65, i8 noundef signext %retval.0.i.i.i412)
          to label %call1.i.noexc422 unwind label %lpad40

call1.i.noexc422:                                 ; preds = %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i411
  %call.i.i413424 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo5flushEv(ptr noundef nonnull align 8 dereferenceable(8) %call1.i423)
          to label %invoke.cont68 unwind label %lpad40

invoke.cont68:                                    ; preds = %call1.i.noexc422
  %122 = load ptr, ptr %data, align 8, !tbaa !97
  store i32 0, ptr %122, align 4, !tbaa !9
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp71) #37
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp74) #37
  %MFileName.i.i297 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp74, i64 0, i32 0, !intel-tbaa !89
  store ptr @.str.1, ptr %MFileName.i.i297, align 8, !tbaa !89, !alias.scope !113
  %MFunctionName.i.i298 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp74, i64 0, i32 1, !intel-tbaa !94
  store ptr @.str.2, ptr %MFunctionName.i.i298, align 8, !tbaa !94, !alias.scope !113
  %MLineNo.i.i299 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp74, i64 0, i32 2, !intel-tbaa !95
  store i64 92, ptr %MLineNo.i.i299, align 8, !tbaa !95, !alias.scope !113
  %MColumnNo.i.i300 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp74, i64 0, i32 3, !intel-tbaa !96
  store i64 11, ptr %MColumnNo.i.i300, align 8, !tbaa !96, !alias.scope !113
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %CGF.i301)
  %coerce.dive.i303 = getelementptr inbounds nuw %class._ZTSZ4mainEUlRN4sycl3_V17handlerEE1_, ptr %CGF.i301, i64 0, i32 0
  store ptr %data, ptr %coerce.dive.i303, align 8, !noalias !116
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %ref.tmp.i302) #37, !noalias !116
  %object.i.i304 = getelementptr inbounds nuw %"class.sycl::_V1::detail::type_erased_cgfo_ty", ptr %ref.tmp.i302, i64 0, i32 0, !intel-tbaa !104
  store ptr %CGF.i301, ptr %object.i.i304, align 8, !tbaa !104, !noalias !116
  %invoker_f.i.i305 = getelementptr inbounds nuw %"class.sycl::_V1::detail::type_erased_cgfo_ty", ptr %ref.tmp.i302, i64 0, i32 1, !intel-tbaa !106
  store ptr @_ZN4sycl3_V16detail19type_erased_cgfo_ty7invokerIZ4mainEUlRNS0_7handlerEE1_E4callEPKvS5_, ptr %invoker_f.i.i305, align 8, !tbaa !106, !noalias !116
  invoke void @_ZN4sycl3_V15queue17submit_with_eventILb0ENS0_3ext6oneapi12experimental10propertiesINS5_6detail20properties_type_listIJEEEEEEENS0_5eventET0_RKNS0_6detail19type_erased_cgfo_tyEPS1_RKNSD_13code_locationE(ptr dead_on_unwind nonnull writable sret(%"class.sycl::_V1::event") align 8 %ref.tmp71, ptr noundef nonnull align 8 dereferenceable(16) %q, ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp.i302, ptr noundef null, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp74)
          to label %invoke.cont77 unwind label %lpad76

invoke.cont77:                                    ; preds = %invoke.cont68
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp.i302) #37, !noalias !116
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %CGF.i301)
  invoke void @_ZN4sycl3_V15event4waitEv(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp71)
          to label %invoke.cont79 unwind label %lpad78

invoke.cont79:                                    ; preds = %invoke.cont77
  %_M_pi.i.i.i308 = getelementptr inbounds nuw %"class.sycl::_V1::event", ptr %ref.tmp71, i64 0, i32 0, i32 0, i32 1
  %123 = load ptr, ptr %_M_pi.i.i.i308, align 8, !tbaa !33
  %cmp.not.i.i.i309 = icmp eq ptr %123, null
  br i1 %cmp.not.i.i.i309, label %_ZN4sycl3_V15eventD2Ev.exit328, label %if.then.i.i.i310

if.then.i.i.i310:                                 ; preds = %invoke.cont79
  %_M_use_count.i.i.i.i311 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %123, i64 0, i32 1, !intel-tbaa !36
  %124 = load atomic i64, ptr %_M_use_count.i.i.i.i311 acquire, align 8
  %cmp.i.i.i.i312 = icmp eq i64 %124, 4294967297
  %125 = trunc i64 %124 to i32
  br i1 %cmp.i.i.i.i312, label %if.then.i.i.i.i322, label %if.end.i.i.i.i313

if.then.i.i.i.i322:                               ; preds = %if.then.i.i.i310
  store i32 0, ptr %_M_use_count.i.i.i.i311, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i323 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %123, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i323, align 4, !tbaa !38
  %vtable.i.i.i.i324 = load ptr, ptr %123, align 8, !tbaa !39
  %vfn.i.i.i.i325 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i324, i64 2
  %126 = load ptr, ptr %vfn.i.i.i.i325, align 8
  call void %126(ptr noundef nonnull align 8 dereferenceable(16) %123) #37
  %vtable3.i.i.i.i326 = load ptr, ptr %123, align 8, !tbaa !39
  %vfn4.i.i.i.i327 = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i326, i64 3
  %127 = load ptr, ptr %vfn4.i.i.i.i327, align 8
  call void %127(ptr noundef nonnull align 8 dereferenceable(16) %123) #37
  br label %_ZN4sycl3_V15eventD2Ev.exit328

if.end.i.i.i.i313:                                ; preds = %if.then.i.i.i310
  %128 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i314 = icmp eq i8 %128, 0
  br i1 %tobool.i.not.i.i.i.i314, label %if.else.i.i.i.i.i321, label %if.then.i.i.i.i.i315

if.then.i.i.i.i.i315:                             ; preds = %if.end.i.i.i.i313
  %add.i.i.i.i.i316 = add nsw i32 %125, -1
  store i32 %add.i.i.i.i.i316, ptr %_M_use_count.i.i.i.i311, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i317

if.else.i.i.i.i.i321:                             ; preds = %if.end.i.i.i.i313
  %129 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i311, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i317

invoke.cont.i.i.i.i317:                           ; preds = %if.else.i.i.i.i.i321, %if.then.i.i.i.i.i315
  %retval.0.i.i.i.i.i318 = phi i32 [ %125, %if.then.i.i.i.i.i315 ], [ %129, %if.else.i.i.i.i.i321 ]
  %cmp6.i.i.i.i319 = icmp eq i32 %retval.0.i.i.i.i.i318, 1
  br i1 %cmp6.i.i.i.i319, label %if.then7.i.i.i.i320, label %_ZN4sycl3_V15eventD2Ev.exit328, !prof !42

if.then7.i.i.i.i320:                              ; preds = %invoke.cont.i.i.i.i317
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %123) #37
  br label %_ZN4sycl3_V15eventD2Ev.exit328

_ZN4sycl3_V15eventD2Ev.exit328:                   ; preds = %invoke.cont79, %if.then.i.i.i.i322, %invoke.cont.i.i.i.i317, %if.then7.i.i.i.i320
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp74) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp71) #37
  %call1.i330 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef nonnull @.str.6, i64 noundef 14)
          to label %invoke.cont83 unwind label %lpad40

invoke.cont83:                                    ; preds = %_ZN4sycl3_V15eventD2Ev.exit328
  %130 = load ptr, ptr %data, align 8, !tbaa !97
  %131 = load i32, ptr %130, align 4, !tbaa !9
  %call87 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i32 noundef %131)
          to label %invoke.cont86 unwind label %lpad40

invoke.cont86:                                    ; preds = %invoke.cont83
  %vtable.i426 = load ptr, ptr %call87, align 8, !tbaa !39
  %vbase.offset.ptr.i427 = getelementptr i64, ptr %vtable.i426, i64 -3
  %vbase.offset.i428 = load i64, ptr %vbase.offset.ptr.i427, align 8
  %add.ptr.i429 = getelementptr inbounds i8, ptr %call87, i64 %vbase.offset.i428
  %_M_ctype.i.i430 = getelementptr inbounds nuw %"class.std::basic_ios", ptr %add.ptr.i429, i64 0, i32 5, !intel-tbaa !63
  %132 = load ptr, ptr %_M_ctype.i.i430, align 8, !tbaa !63
  %tobool.not.i.i.i431 = icmp eq ptr %132, null
  br i1 %tobool.not.i.i.i431, label %if.then.i.i.i444.invoke, label %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i432

if.then.i.i.i444.invoke:                          ; preds = %invoke.cont86, %invoke.cont66, %invoke.cont44
  invoke void @_ZSt16__throw_bad_castv() #40
          to label %if.then.i.i.i444.cont unwind label %lpad40

if.then.i.i.i444.cont:                            ; preds = %if.then.i.i.i444.invoke
  unreachable

_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i432: ; preds = %invoke.cont86
  %_M_widen_ok.i.i.i433 = getelementptr inbounds nuw %"class.std::ctype", ptr %132, i64 0, i32 8, !intel-tbaa !81
  %133 = load i8, ptr %_M_widen_ok.i.i.i433, align 8, !tbaa !81
  %tobool.not.i3.i.i434 = icmp eq i8 %133, 0
  br i1 %tobool.not.i3.i.i434, label %if.end.i.i.i440, label %if.then.i4.i.i435

if.then.i4.i.i435:                                ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i432
  %arrayidx.i.i.i436 = getelementptr inbounds nuw %"class.std::ctype", ptr %132, i64 0, i32 9, i64 10, !intel-tbaa !88
  %134 = load i8, ptr %arrayidx.i.i.i436, align 1, !tbaa !88
  br label %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i437

if.end.i.i.i440:                                  ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i432
  invoke void @_ZNKSt5ctypeIcE13_M_widen_initEv(ptr noundef nonnull align 8 dereferenceable(570) %132)
          to label %.noexc446 unwind label %lpad40

.noexc446:                                        ; preds = %if.end.i.i.i440
  %vtable.i.i.i441 = load ptr, ptr %132, align 8, !tbaa !39
  %vfn.i.i.i442 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i441, i64 6
  %135 = load ptr, ptr %vfn.i.i.i442, align 8
  %call.i.i.i443447 = invoke noundef signext i8 %135(ptr noundef nonnull align 8 dereferenceable(570) %132, i8 noundef signext 10)
          to label %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i437 unwind label %lpad40

_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i437: ; preds = %.noexc446, %if.then.i4.i.i435
  %retval.0.i.i.i438 = phi i8 [ %134, %if.then.i4.i.i435 ], [ %call.i.i.i443447, %.noexc446 ]
  %call1.i449 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo3putEc(ptr noundef nonnull align 8 dereferenceable(8) %call87, i8 noundef signext %retval.0.i.i.i438)
          to label %call1.i.noexc448 unwind label %lpad40

call1.i.noexc448:                                 ; preds = %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i437
  %call.i.i439450 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo5flushEv(ptr noundef nonnull align 8 dereferenceable(8) %call1.i449)
          to label %invoke.cont88 unwind label %lpad40

invoke.cont88:                                    ; preds = %call1.i.noexc448
  %136 = load ptr, ptr %data, align 8, !tbaa !97
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %ref.tmp90) #37
  %MFileName.i.i334 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp90, i64 0, i32 0, !intel-tbaa !89
  store ptr @.str.1, ptr %MFileName.i.i334, align 8, !tbaa !89, !alias.scope !119
  %MFunctionName.i.i335 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp90, i64 0, i32 1, !intel-tbaa !94
  store ptr @.str.2, ptr %MFunctionName.i.i335, align 8, !tbaa !94, !alias.scope !119
  %MLineNo.i.i336 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp90, i64 0, i32 2, !intel-tbaa !95
  store i64 100, ptr %MLineNo.i.i336, align 8, !tbaa !95, !alias.scope !119
  %MColumnNo.i.i337 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::code_location", ptr %ref.tmp90, i64 0, i32 3, !intel-tbaa !96
  store i64 9, ptr %MColumnNo.i.i337, align 8, !tbaa !96, !alias.scope !119
  invoke void @_ZN4sycl3_V14freeEPvRKNS0_5queueERKNS0_6detail13code_locationE(ptr noundef %136, ptr noundef nonnull align 8 dereferenceable(16) %q, ptr noundef nonnull align 8 dereferenceable(32) %ref.tmp90)
          to label %invoke.cont92 unwind label %lpad91

invoke.cont92:                                    ; preds = %invoke.cont88
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp90) #37
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %data) #37
  %_M_pi.i.i.i339 = getelementptr inbounds nuw %"class.sycl::_V1::queue", ptr %q, i64 0, i32 0, i32 0, i32 1
  %137 = load ptr, ptr %_M_pi.i.i.i339, align 8, !tbaa !33
  %cmp.not.i.i.i340 = icmp eq ptr %137, null
  br i1 %cmp.not.i.i.i340, label %_ZN4sycl3_V15queueD2Ev.exit, label %if.then.i.i.i341

if.then.i.i.i341:                                 ; preds = %invoke.cont92
  %_M_use_count.i.i.i.i342 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %137, i64 0, i32 1, !intel-tbaa !36
  %138 = load atomic i64, ptr %_M_use_count.i.i.i.i342 acquire, align 8
  %cmp.i.i.i.i343 = icmp eq i64 %138, 4294967297
  %139 = trunc i64 %138 to i32
  br i1 %cmp.i.i.i.i343, label %if.then.i.i.i.i353, label %if.end.i.i.i.i344

if.then.i.i.i.i353:                               ; preds = %if.then.i.i.i341
  store i32 0, ptr %_M_use_count.i.i.i.i342, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i354 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %137, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i354, align 4, !tbaa !38
  %vtable.i.i.i.i355 = load ptr, ptr %137, align 8, !tbaa !39
  %vfn.i.i.i.i356 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i355, i64 2
  %140 = load ptr, ptr %vfn.i.i.i.i356, align 8
  call void %140(ptr noundef nonnull align 8 dereferenceable(16) %137) #37
  %vtable3.i.i.i.i357 = load ptr, ptr %137, align 8, !tbaa !39
  %vfn4.i.i.i.i358 = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i357, i64 3
  %141 = load ptr, ptr %vfn4.i.i.i.i358, align 8
  call void %141(ptr noundef nonnull align 8 dereferenceable(16) %137) #37
  br label %_ZN4sycl3_V15queueD2Ev.exit

if.end.i.i.i.i344:                                ; preds = %if.then.i.i.i341
  %142 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i345 = icmp eq i8 %142, 0
  br i1 %tobool.i.not.i.i.i.i345, label %if.else.i.i.i.i.i352, label %if.then.i.i.i.i.i346

if.then.i.i.i.i.i346:                             ; preds = %if.end.i.i.i.i344
  %add.i.i.i.i.i347 = add nsw i32 %139, -1
  store i32 %add.i.i.i.i.i347, ptr %_M_use_count.i.i.i.i342, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i348

if.else.i.i.i.i.i352:                             ; preds = %if.end.i.i.i.i344
  %143 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i342, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i348

invoke.cont.i.i.i.i348:                           ; preds = %if.else.i.i.i.i.i352, %if.then.i.i.i.i.i346
  %retval.0.i.i.i.i.i349 = phi i32 [ %139, %if.then.i.i.i.i.i346 ], [ %143, %if.else.i.i.i.i.i352 ]
  %cmp6.i.i.i.i350 = icmp eq i32 %retval.0.i.i.i.i.i349, 1
  br i1 %cmp6.i.i.i.i350, label %if.then7.i.i.i.i351, label %_ZN4sycl3_V15queueD2Ev.exit, !prof !42

if.then7.i.i.i.i351:                              ; preds = %invoke.cont.i.i.i.i348
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %137) #37
  br label %_ZN4sycl3_V15queueD2Ev.exit

_ZN4sycl3_V15queueD2Ev.exit:                      ; preds = %invoke.cont92, %if.then.i.i.i.i353, %invoke.cont.i.i.i.i348, %if.then7.i.i.i.i351
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %q) #37
  br label %return

lpad33:                                           ; preds = %_ZN4sycl3_V16detail16PropertyListBaseD2Ev.exit214
  %144 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup38

lpad35:                                           ; preds = %invoke.cont34
  %145 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  call void @_ZN4sycl3_V15eventD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp30) #37
  br label %ehcleanup38

ehcleanup38:                                      ; preds = %lpad35, %lpad33
  %.pn121 = phi { ptr, i32 } [ %145, %lpad35 ], [ %144, %lpad33 ]
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp32) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp30) #37
  br label %ehcleanup94

lpad40:                                           ; preds = %if.then.i.i.i444.invoke, %call1.i.noexc448, %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i437, %.noexc446, %if.end.i.i.i440, %call1.i.noexc422, %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i411, %.noexc420, %if.end.i.i.i414, %call1.i.noexc396, %_ZNKSt9basic_iosIcSt11char_traitsIcEE5widenEc.exit.i385, %.noexc394, %if.end.i.i.i388, %_ZN4sycl3_V15eventD2Ev.exit328, %invoke.cont64, %_ZN4sycl3_V15eventD2Ev.exit288, %_ZN4sycl3_V15eventD2Ev.exit, %invoke.cont83, %invoke.cont61, %invoke.cont41
  %146 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup94

lpad54:                                           ; preds = %invoke.cont46
  %147 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup59

lpad56:                                           ; preds = %invoke.cont55
  %148 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  call void @_ZN4sycl3_V15eventD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp49) #37
  br label %ehcleanup59

ehcleanup59:                                      ; preds = %lpad56, %lpad54
  %.pn123 = phi { ptr, i32 } [ %148, %lpad56 ], [ %147, %lpad54 ]
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp52) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp49) #37
  br label %ehcleanup94

lpad76:                                           ; preds = %invoke.cont68
  %149 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  br label %ehcleanup81

lpad78:                                           ; preds = %invoke.cont77
  %150 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  call void @_ZN4sycl3_V15eventD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %ref.tmp71) #37
  br label %ehcleanup81

ehcleanup81:                                      ; preds = %lpad78, %lpad76
  %.pn125 = phi { ptr, i32 } [ %150, %lpad78 ], [ %149, %lpad76 ]
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp74) #37
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %ref.tmp71) #37
  br label %ehcleanup94

lpad91:                                           ; preds = %invoke.cont88
  %151 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTIN4sycl3_V19exceptionE
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %ref.tmp90) #37
  br label %ehcleanup94

ehcleanup94:                                      ; preds = %lpad91, %ehcleanup81, %ehcleanup59, %lpad40, %ehcleanup38, %lpad24.body
  %.pn127 = phi { ptr, i32 } [ %151, %lpad91 ], [ %146, %lpad40 ], [ %.pn125, %ehcleanup81 ], [ %.pn123, %ehcleanup59 ], [ %.pn121, %ehcleanup38 ], [ %eh.lpad-body174, %lpad24.body ]
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %data) #37
  br label %ehcleanup96

ehcleanup96:                                      ; preds = %ehcleanup94, %ehcleanup18, %lpad3
  %.pn127.pn = phi { ptr, i32 } [ %.pn127, %ehcleanup94 ], [ %.pn116.pn, %ehcleanup18 ], [ %87, %lpad3 ]
  call void @_ZN4sycl3_V15queueD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %q) #37
  br label %ehcleanup97

ehcleanup97:                                      ; preds = %ehcleanup96, %_ZNSt14_Function_baseD2Ev.exit34.i
  %.pn127.pn.pn = phi { ptr, i32 } [ %.pn127.pn, %ehcleanup96 ], [ %.pn.i, %_ZNSt14_Function_baseD2Ev.exit34.i ]
  %ehselector.slot.9 = extractvalue { ptr, i32 } %.pn127.pn.pn, 1
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %q) #37
  %152 = call i32 @llvm.eh.typeid.for.p0(ptr nonnull @_ZTIN4sycl3_V19exceptionE) #37
  %matches = icmp eq i32 %ehselector.slot.9, %152
  br i1 %matches, label %catch, label %eh.resume

catch:                                            ; preds = %ehcleanup97
  %exn.slot.9 = extractvalue { ptr, i32 } %.pn127.pn.pn, 0
  %153 = call ptr @__cxa_begin_catch(ptr %exn.slot.9) #37
  %call1.i360 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cerr, ptr noundef nonnull @.str.7, i64 noundef 16)
          to label %invoke.cont99 unwind label %lpad98

invoke.cont99:                                    ; preds = %catch
  %call101 = call noundef ptr @_ZNK4sycl3_V19exception4whatEv(ptr noundef nonnull align 8 dereferenceable(64) %153) #37
  %call103 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cerr, ptr noundef %call101)
          to label %invoke.cont102 unwind label %lpad98

invoke.cont102:                                   ; preds = %invoke.cont99
  %call.i362 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_(ptr noundef nonnull align 8 dereferenceable(8) %call103)
          to label %invoke.cont104 unwind label %lpad98

invoke.cont104:                                   ; preds = %invoke.cont102
  call void @__cxa_end_catch()
  br label %return

lpad98:                                           ; preds = %invoke.cont102, %catch, %invoke.cont99
  %154 = landingpad { ptr, i32 }
          cleanup
  invoke void @__cxa_end_catch()
          to label %eh.resume unwind label %terminate.lpad

return:                                           ; preds = %_ZN4sycl3_V15queueD2Ev.exit, %invoke.cont104
  %retval.0 = phi i32 [ 0, %_ZN4sycl3_V15queueD2Ev.exit ], [ 1, %invoke.cont104 ]
  ret i32 %retval.0

eh.resume:                                        ; preds = %lpad98, %ehcleanup97
  %lpad.val111.merged = phi { ptr, i32 } [ %.pn127.pn.pn, %ehcleanup97 ], [ %154, %lpad98 ]
  resume { ptr, i32 } %lpad.val111.merged

terminate.lpad:                                   ; preds = %lpad98
  %155 = landingpad { ptr, i32 }
          catch ptr null
  %156 = extractvalue { ptr, i32 } %155, 0
  call void @__clang_call_terminate(ptr %156) #38
  unreachable
}

declare dso_local noundef i32 @_ZN4sycl3_V114gpu_selector_vERKNS0_6deviceE(ptr noundef nonnull align 8 dereferenceable(16)) #8

declare dso_local i32 @__gxx_personality_v0(...)

; Function Attrs: inlinehint mustprogress nounwind uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V16detail16PropertyListBaseD2Ev(ptr noundef nonnull align 8 dereferenceable(32) %this) unnamed_addr #9 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %_M_start.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %this, i64 0, i32 1
  %0 = load ptr, ptr %_M_start.i, align 8, !tbaa !43
  %_M_finish.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %this, i64 0, i32 1, i32 0, i32 0, i32 0, i32 1
  %1 = load ptr, ptr %_M_finish.i, align 8, !tbaa !44
  %cmp.not3.i.i.i.i = icmp eq ptr %0, %1
  br i1 %cmp.not3.i.i.i.i, label %invoke.cont.i, label %for.body.i.i.i.i

for.body.i.i.i.i:                                 ; preds = %entry, %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i
  %__first.addr.04.i.i.i.i = phi ptr [ %incdec.ptr.i.i.i.i, %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i ], [ %0, %entry ]
  %_M_pi.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.std::__shared_ptr.21", ptr %__first.addr.04.i.i.i.i, i64 0, i32 1, i32 0, !intel-tbaa !45
  %2 = load ptr, ptr %_M_pi.i.i.i.i.i.i.i, align 8, !tbaa !33
  %cmp.not.i.i.i.i.i.i.i = icmp eq ptr %2, null
  br i1 %cmp.not.i.i.i.i.i.i.i, label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i, label %if.then.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i:                            ; preds = %for.body.i.i.i.i
  %_M_use_count.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %2, i64 0, i32 1, !intel-tbaa !36
  %3 = load atomic i64, ptr %_M_use_count.i.i.i.i.i.i.i.i acquire, align 8
  %cmp.i.i.i.i.i.i.i.i = icmp eq i64 %3, 4294967297
  %4 = trunc i64 %3 to i32
  br i1 %cmp.i.i.i.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i, label %if.end.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i:                          ; preds = %if.then.i.i.i.i.i.i.i
  store i32 0, ptr %_M_use_count.i.i.i.i.i.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %2, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i.i.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i.i.i.i.i.i = load ptr, ptr %2, align 8, !tbaa !39
  %vfn.i.i.i.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i.i.i.i, i64 2
  %5 = load ptr, ptr %vfn.i.i.i.i.i.i.i.i, align 8
  tail call void %5(ptr noundef nonnull align 8 dereferenceable(16) %2) #37
  %vtable3.i.i.i.i.i.i.i.i = load ptr, ptr %2, align 8, !tbaa !39
  %vfn4.i.i.i.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i.i.i.i.i, i64 3
  %6 = load ptr, ptr %vfn4.i.i.i.i.i.i.i.i, align 8
  tail call void %6(ptr noundef nonnull align 8 dereferenceable(16) %2) #37
  br label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i

if.end.i.i.i.i.i.i.i.i:                           ; preds = %if.then.i.i.i.i.i.i.i
  %7 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i.i.i.i.i = icmp eq i8 %7, 0
  br i1 %tobool.i.not.i.i.i.i.i.i.i.i, label %if.else.i.i.i.i.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i.i:                        ; preds = %if.end.i.i.i.i.i.i.i.i
  %add.i.i.i.i.i.i.i.i.i = add nsw i32 %4, -1
  store i32 %add.i.i.i.i.i.i.i.i.i, ptr %_M_use_count.i.i.i.i.i.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i.i.i.i.i

if.else.i.i.i.i.i.i.i.i.i:                        ; preds = %if.end.i.i.i.i.i.i.i.i
  %8 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i.i.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i.i.i.i.i

invoke.cont.i.i.i.i.i.i.i.i:                      ; preds = %if.else.i.i.i.i.i.i.i.i.i, %if.then.i.i.i.i.i.i.i.i.i
  %retval.0.i.i.i.i.i.i.i.i.i = phi i32 [ %4, %if.then.i.i.i.i.i.i.i.i.i ], [ %8, %if.else.i.i.i.i.i.i.i.i.i ]
  %cmp6.i.i.i.i.i.i.i.i = icmp eq i32 %retval.0.i.i.i.i.i.i.i.i.i, 1
  br i1 %cmp6.i.i.i.i.i.i.i.i, label %if.then7.i.i.i.i.i.i.i.i, label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i, !prof !42

if.then7.i.i.i.i.i.i.i.i:                         ; preds = %invoke.cont.i.i.i.i.i.i.i.i
  tail call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %2) #37
  br label %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i

_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i: ; preds = %if.then7.i.i.i.i.i.i.i.i, %invoke.cont.i.i.i.i.i.i.i.i, %if.then.i.i.i.i.i.i.i.i, %for.body.i.i.i.i
  %incdec.ptr.i.i.i.i = getelementptr inbounds nuw %"class.std::shared_ptr.20", ptr %__first.addr.04.i.i.i.i, i64 1
  %cmp.not.i.i.i.i = icmp eq ptr %incdec.ptr.i.i.i.i, %1
  br i1 %cmp.not.i.i.i.i, label %invoke.contthread-pre-split.i, label %for.body.i.i.i.i, !llvm.loop !48

invoke.contthread-pre-split.i:                    ; preds = %_ZSt8_DestroyISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEEEvPT_.exit.i.i.i.i
  %.pr.i = load ptr, ptr %_M_start.i, align 8, !tbaa !43
  br label %invoke.cont.i

invoke.cont.i:                                    ; preds = %invoke.contthread-pre-split.i, %entry
  %9 = phi ptr [ %.pr.i, %invoke.contthread-pre-split.i ], [ %0, %entry ]
  %tobool.not.i.i.i = icmp eq ptr %9, null
  br i1 %tobool.not.i.i.i, label %_ZNSt6vectorISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEESaIS5_EED2Ev.exit, label %if.then.i.i.i

if.then.i.i.i:                                    ; preds = %invoke.cont.i
  %_M_end_of_storage.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::PropertyListBase", ptr %this, i64 0, i32 1, i32 0, i32 0, i32 0, i32 2
  %10 = load ptr, ptr %_M_end_of_storage.i.i, align 8, !tbaa !49
  %sub.ptr.lhs.cast.i.i = ptrtoint ptr %10 to i64
  %sub.ptr.rhs.cast.i.i = ptrtoint ptr %9 to i64
  %sub.ptr.sub.i.i = sub i64 %sub.ptr.lhs.cast.i.i, %sub.ptr.rhs.cast.i.i
  tail call void @_ZdlPvm(ptr noundef nonnull %9, i64 noundef %sub.ptr.sub.i.i) #39
  br label %_ZNSt6vectorISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEESaIS5_EED2Ev.exit

_ZNSt6vectorISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEESaIS5_EED2Ev.exit: ; preds = %invoke.cont.i, %if.then.i.i.i
  ret void
}

; Function Attrs: inlinehint mustprogress uwtable
declare dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc(ptr noundef nonnull align 8 dereferenceable(8), ptr noundef) local_unnamed_addr #10

declare dso_local void @_ZNK4sycl3_V15queue10get_deviceEv(ptr dead_on_unwind writable sret(%"class.sycl::_V1::device") align 8, ptr noundef nonnull align 8 dereferenceable(16)) local_unnamed_addr #8

; Function Attrs: inlinehint mustprogress uwtable
declare dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_(ptr noundef nonnull align 8 dereferenceable(8)) local_unnamed_addr #10

; Function Attrs: inlinehint mustprogress nounwind uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V16deviceD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %this) unnamed_addr #9 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %_M_pi.i.i = getelementptr inbounds nuw %"class.sycl::_V1::device", ptr %this, i64 0, i32 0, i32 0, i32 1
  %0 = load ptr, ptr %_M_pi.i.i, align 8, !tbaa !33
  %cmp.not.i.i = icmp eq ptr %0, null
  br i1 %cmp.not.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail11device_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, label %if.then.i.i

if.then.i.i:                                      ; preds = %entry
  %_M_use_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 1, !intel-tbaa !36
  %1 = load atomic i64, ptr %_M_use_count.i.i.i acquire, align 8
  %cmp.i.i.i = icmp eq i64 %1, 4294967297
  %2 = trunc i64 %1 to i32
  br i1 %cmp.i.i.i, label %if.then.i.i.i, label %if.end.i.i.i

if.then.i.i.i:                                    ; preds = %if.then.i.i
  store i32 0, ptr %_M_use_count.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i, i64 2
  %3 = load ptr, ptr %vfn.i.i.i, align 8
  tail call void %3(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  %vtable3.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn4.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i, i64 3
  %4 = load ptr, ptr %vfn4.i.i.i, align 8
  tail call void %4(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail11device_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

if.end.i.i.i:                                     ; preds = %if.then.i.i
  %5 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i = icmp eq i8 %5, 0
  br i1 %tobool.i.not.i.i.i, label %if.else.i.i.i.i, label %if.then.i.i.i.i

if.then.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %add.i.i.i.i = add nsw i32 %2, -1
  store i32 %add.i.i.i.i, ptr %_M_use_count.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i

if.else.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %6 = atomicrmw volatile add ptr %_M_use_count.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i

invoke.cont.i.i.i:                                ; preds = %if.else.i.i.i.i, %if.then.i.i.i.i
  %retval.0.i.i.i.i = phi i32 [ %2, %if.then.i.i.i.i ], [ %6, %if.else.i.i.i.i ]
  %cmp6.i.i.i = icmp eq i32 %retval.0.i.i.i.i, 1
  br i1 %cmp6.i.i.i, label %if.then7.i.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail11device_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, !prof !42

if.then7.i.i.i:                                   ; preds = %invoke.cont.i.i.i
  tail call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail11device_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

_ZNSt12__shared_ptrIN4sycl3_V16detail11device_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit: ; preds = %entry, %if.then.i.i.i, %invoke.cont.i.i.i, %if.then7.i.i.i
  ret void
}

declare dso_local void @_ZN4sycl3_V15event4waitEv(ptr noundef nonnull align 8 dereferenceable(16)) local_unnamed_addr #8

; Function Attrs: inlinehint mustprogress nounwind uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V15eventD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %this) unnamed_addr #9 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %_M_pi.i.i = getelementptr inbounds nuw %"class.sycl::_V1::event", ptr %this, i64 0, i32 0, i32 0, i32 1
  %0 = load ptr, ptr %_M_pi.i.i, align 8, !tbaa !33
  %cmp.not.i.i = icmp eq ptr %0, null
  br i1 %cmp.not.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail10event_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, label %if.then.i.i

if.then.i.i:                                      ; preds = %entry
  %_M_use_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 1, !intel-tbaa !36
  %1 = load atomic i64, ptr %_M_use_count.i.i.i acquire, align 8
  %cmp.i.i.i = icmp eq i64 %1, 4294967297
  %2 = trunc i64 %1 to i32
  br i1 %cmp.i.i.i, label %if.then.i.i.i, label %if.end.i.i.i

if.then.i.i.i:                                    ; preds = %if.then.i.i
  store i32 0, ptr %_M_use_count.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i, i64 2
  %3 = load ptr, ptr %vfn.i.i.i, align 8
  tail call void %3(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  %vtable3.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn4.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i, i64 3
  %4 = load ptr, ptr %vfn4.i.i.i, align 8
  tail call void %4(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail10event_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

if.end.i.i.i:                                     ; preds = %if.then.i.i
  %5 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i = icmp eq i8 %5, 0
  br i1 %tobool.i.not.i.i.i, label %if.else.i.i.i.i, label %if.then.i.i.i.i

if.then.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %add.i.i.i.i = add nsw i32 %2, -1
  store i32 %add.i.i.i.i, ptr %_M_use_count.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i

if.else.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %6 = atomicrmw volatile add ptr %_M_use_count.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i

invoke.cont.i.i.i:                                ; preds = %if.else.i.i.i.i, %if.then.i.i.i.i
  %retval.0.i.i.i.i = phi i32 [ %2, %if.then.i.i.i.i ], [ %6, %if.else.i.i.i.i ]
  %cmp6.i.i.i = icmp eq i32 %retval.0.i.i.i.i, 1
  br i1 %cmp6.i.i.i, label %if.then7.i.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail10event_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, !prof !42

if.then7.i.i.i:                                   ; preds = %invoke.cont.i.i.i
  tail call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail10event_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

_ZNSt12__shared_ptrIN4sycl3_V16detail10event_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit: ; preds = %entry, %if.then.i.i.i, %invoke.cont.i.i.i, %if.then7.i.i.i
  ret void
}

; Function Attrs: nofree
declare dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8), i32 noundef) local_unnamed_addr #0

declare dso_local void @_ZN4sycl3_V14freeEPvRKNS0_5queueERKNS0_6detail13code_locationE(ptr noundef, ptr noundef nonnull align 8 dereferenceable(16), ptr noundef nonnull align 8 dereferenceable(32)) local_unnamed_addr #8

; Function Attrs: inlinehint mustprogress nounwind uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V15queueD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %this) unnamed_addr #9 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %_M_pi.i.i = getelementptr inbounds nuw %"class.sycl::_V1::queue", ptr %this, i64 0, i32 0, i32 0, i32 1
  %0 = load ptr, ptr %_M_pi.i.i, align 8, !tbaa !33
  %cmp.not.i.i = icmp eq ptr %0, null
  br i1 %cmp.not.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail10queue_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, label %if.then.i.i

if.then.i.i:                                      ; preds = %entry
  %_M_use_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 1, !intel-tbaa !36
  %1 = load atomic i64, ptr %_M_use_count.i.i.i acquire, align 8
  %cmp.i.i.i = icmp eq i64 %1, 4294967297
  %2 = trunc i64 %1 to i32
  br i1 %cmp.i.i.i, label %if.then.i.i.i, label %if.end.i.i.i

if.then.i.i.i:                                    ; preds = %if.then.i.i
  store i32 0, ptr %_M_use_count.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i, i64 2
  %3 = load ptr, ptr %vfn.i.i.i, align 8
  tail call void %3(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  %vtable3.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn4.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i, i64 3
  %4 = load ptr, ptr %vfn4.i.i.i, align 8
  tail call void %4(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail10queue_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

if.end.i.i.i:                                     ; preds = %if.then.i.i
  %5 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i = icmp eq i8 %5, 0
  br i1 %tobool.i.not.i.i.i, label %if.else.i.i.i.i, label %if.then.i.i.i.i

if.then.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %add.i.i.i.i = add nsw i32 %2, -1
  store i32 %add.i.i.i.i, ptr %_M_use_count.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i

if.else.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %6 = atomicrmw volatile add ptr %_M_use_count.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i

invoke.cont.i.i.i:                                ; preds = %if.else.i.i.i.i, %if.then.i.i.i.i
  %retval.0.i.i.i.i = phi i32 [ %2, %if.then.i.i.i.i ], [ %6, %if.else.i.i.i.i ]
  %cmp6.i.i.i = icmp eq i32 %retval.0.i.i.i.i, 1
  br i1 %cmp6.i.i.i, label %if.then7.i.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail10queue_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, !prof !42

if.then7.i.i.i:                                   ; preds = %invoke.cont.i.i.i
  tail call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail10queue_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

_ZNSt12__shared_ptrIN4sycl3_V16detail10queue_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit: ; preds = %entry, %if.then.i.i.i, %invoke.cont.i.i.i, %if.then7.i.i.i
  ret void
}

; Function Attrs: nofree nosync nounwind memory(none)
declare i32 @llvm.eh.typeid.for.p0(ptr) #11

; Function Attrs: nofree
declare dso_local ptr @__cxa_begin_catch(ptr) local_unnamed_addr #12

; Function Attrs: nounwind
declare dso_local noundef ptr @_ZNK4sycl3_V19exception4whatEv(ptr noundef nonnull align 8 dereferenceable(64)) unnamed_addr #13

; Function Attrs: nofree
declare dso_local void @__cxa_end_catch() local_unnamed_addr #12

; Function Attrs: noinline noreturn nounwind uwtable
define linkonce_odr hidden void @__clang_call_terminate(ptr noundef %0) local_unnamed_addr #14 comdat {
  %2 = tail call ptr @__cxa_begin_catch(ptr %0) #37
  tail call void @_ZSt9terminatev() #38
  unreachable
}

; Function Attrs: cold nofree noreturn nounwind
declare dso_local void @_ZSt9terminatev() local_unnamed_addr #15

; Function Attrs: mustprogress noinline nounwind uwtable
define linkonce_odr dso_local void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %this) local_unnamed_addr #16 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %vtable.i = load ptr, ptr %this, align 8, !tbaa !39
  %vfn.i = getelementptr inbounds nuw ptr, ptr %vtable.i, i64 2
  %0 = load ptr, ptr %vfn.i, align 8
  tail call void %0(ptr noundef nonnull align 8 dereferenceable(16) %this) #37
  %_M_weak_count.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %this, i64 0, i32 2, !intel-tbaa !38
  %1 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i = icmp eq i8 %1, 0
  br i1 %tobool.i.not.i, label %if.else.i.i, label %if.then.i.i

if.then.i.i:                                      ; preds = %entry
  %2 = load i32, ptr %_M_weak_count.i, align 4, !tbaa !38
  %add.i.i = add nsw i32 %2, -1
  store i32 %add.i.i, ptr %_M_weak_count.i, align 4, !tbaa !38
  br label %invoke.cont.i

if.else.i.i:                                      ; preds = %entry
  %3 = atomicrmw volatile add ptr %_M_weak_count.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i

invoke.cont.i:                                    ; preds = %if.else.i.i, %if.then.i.i
  %retval.0.i.i = phi i32 [ %2, %if.then.i.i ], [ %3, %if.else.i.i ]
  %cmp.i = icmp eq i32 %retval.0.i.i, 1
  br i1 %cmp.i, label %if.then.i, label %_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE19_M_release_last_useEv.exit

if.then.i:                                        ; preds = %invoke.cont.i
  %vtable2.i = load ptr, ptr %this, align 8, !tbaa !39
  %vfn3.i = getelementptr inbounds nuw ptr, ptr %vtable2.i, i64 3
  %4 = load ptr, ptr %vfn3.i, align 8
  tail call void %4(ptr noundef nonnull align 8 dereferenceable(16) %this) #37
  br label %_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE19_M_release_last_useEv.exit

_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE19_M_release_last_useEv.exit: ; preds = %invoke.cont.i, %if.then.i
  ret void
}

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdlPvm(ptr noundef, i64 noundef) local_unnamed_addr #17

; Function Attrs: nofree
declare dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8), ptr noundef, i64 noundef) local_unnamed_addr #0

; Function Attrs: nofree
declare dso_local void @_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate(ptr noundef nonnull align 8 dereferenceable(264), i32 noundef) local_unnamed_addr #0

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: read)
declare dso_local i64 @strlen(ptr noundef captures(none)) local_unnamed_addr #18

; Function Attrs: nofree
declare dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo3putEc(ptr noundef nonnull align 8 dereferenceable(8), i8 noundef signext) local_unnamed_addr #0

; Function Attrs: nofree
declare dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo5flushEv(ptr noundef nonnull align 8 dereferenceable(8)) local_unnamed_addr #0

; Function Attrs: nofree noreturn
declare dso_local void @_ZSt16__throw_bad_castv() local_unnamed_addr #19

; Function Attrs: nofree
declare dso_local void @_ZNKSt5ctypeIcE13_M_widen_initEv(ptr noundef nonnull align 8 dereferenceable(570)) local_unnamed_addr #0

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #20

declare dso_local void @_ZN4sycl3_V16detail13select_deviceERKSt8functionIFiRKNS0_6deviceEEE(ptr dead_on_unwind writable sret(%"class.sycl::_V1::device") align 8, ptr noundef nonnull align 8 dereferenceable(32)) local_unnamed_addr #8

; Function Attrs: inlinehint mustprogress uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V16detail19defaultAsyncHandlerENS0_14exception_listE(ptr noundef %Exceptions) #21 comdat personality ptr @__gxx_personality_v0 {
entry:
  %agg.tmp = alloca %"class.std::__exception_ptr::exception_ptr", align 8
  %call1.i = tail call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cerr, ptr noundef nonnull @.str.8, i64 noundef 40)
  %call1 = tail call ptr @_ZNK4sycl3_V114exception_list5beginEv(ptr noundef nonnull align 8 dereferenceable(24) %Exceptions)
  %call2 = tail call ptr @_ZNK4sycl3_V114exception_list3endEv(ptr noundef nonnull align 8 dereferenceable(24) %Exceptions)
  %cmp.i.not42 = icmp eq ptr %call1, %call2
  br i1 %cmp.i.not42, label %for.cond.cleanup, label %for.body.lr.ph

for.body.lr.ph:                                   ; preds = %entry
  %_M_exception_object.i25 = getelementptr inbounds nuw %"class.std::__exception_ptr::exception_ptr", ptr %agg.tmp, i64 0, i32 0
  br label %for.body

for.cond.cleanup:                                 ; preds = %try.cont, %entry
  %call.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cerr)
  call void @_ZSt9terminatev() #38
  unreachable

for.body:                                         ; preds = %for.body.lr.ph, %try.cont
  %__begin2.sroa.0.043 = phi ptr [ %call1, %for.body.lr.ph ], [ %incdec.ptr.i, %try.cont ]
  %0 = load ptr, ptr %__begin2.sroa.0.043, align 8, !tbaa !122
  %tobool.i.not = icmp eq ptr %0, null
  br i1 %tobool.i.not, label %try.cont, label %_ZNSt15__exception_ptr13exception_ptrC2ERKS0_.exit

_ZNSt15__exception_ptr13exception_ptrC2ERKS0_.exit: ; preds = %for.body
  store ptr %0, ptr %_M_exception_object.i25, align 8, !tbaa !122
  call void @_ZNSt15__exception_ptr13exception_ptr9_M_addrefEv(ptr noundef nonnull align 8 dereferenceable(8) %agg.tmp) #37
  invoke void @_ZSt17rethrow_exceptionNSt15__exception_ptr13exception_ptrE(ptr noundef nonnull %agg.tmp) #40
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %_ZNSt15__exception_ptr13exception_ptrC2ERKS0_.exit
  unreachable

lpad:                                             ; preds = %_ZNSt15__exception_ptr13exception_ptrC2ERKS0_.exit
  %1 = landingpad { ptr, i32 }
          cleanup
          catch ptr @_ZTISt9exception
  %2 = extractvalue { ptr, i32 } %1, 1
  %3 = load ptr, ptr %_M_exception_object.i25, align 8, !tbaa !122
  %tobool.not.i27 = icmp eq ptr %3, null
  br i1 %tobool.not.i27, label %_ZNSt15__exception_ptr13exception_ptrD2Ev.exit, label %if.then.i28

if.then.i28:                                      ; preds = %lpad
  call void @_ZNSt15__exception_ptr13exception_ptr10_M_releaseEv(ptr noundef nonnull align 8 dereferenceable(8) %agg.tmp) #37
  br label %_ZNSt15__exception_ptr13exception_ptrD2Ev.exit

_ZNSt15__exception_ptr13exception_ptrD2Ev.exit:   ; preds = %lpad, %if.then.i28
  %4 = call i32 @llvm.eh.typeid.for.p0(ptr nonnull @_ZTISt9exception) #37
  %matches = icmp eq i32 %2, %4
  br i1 %matches, label %catch, label %ehcleanup

catch:                                            ; preds = %_ZNSt15__exception_ptr13exception_ptrD2Ev.exit
  %5 = extractvalue { ptr, i32 } %1, 0
  %6 = call ptr @__cxa_begin_catch(ptr %5) #37
  %call1.i3031 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cerr, ptr noundef nonnull @.str.9, i64 noundef 2)
          to label %invoke.cont8 unwind label %lpad7

invoke.cont8:                                     ; preds = %catch
  %vtable = load ptr, ptr %6, align 8, !tbaa !39
  %vfn = getelementptr inbounds nuw ptr, ptr %vtable, i64 2
  %7 = load ptr, ptr %vfn, align 8
  %call10 = call noundef ptr %7(ptr noundef nonnull align 8 dereferenceable(8) %6) #37
  %tobool.not.i32 = icmp eq ptr %call10, null
  br i1 %tobool.not.i32, label %if.then.i35, label %if.else.i

if.then.i35:                                      ; preds = %invoke.cont8
  %vtable.i = load ptr, ptr @_ZSt4cerr, align 8, !tbaa !39
  %vbase.offset.ptr.i = getelementptr i64, ptr %vtable.i, i64 -3
  %vbase.offset.i = load i64, ptr %vbase.offset.ptr.i, align 8
  %add.ptr.i = getelementptr inbounds i8, ptr @_ZSt4cerr, i64 %vbase.offset.i
  %_M_streambuf_state.i.i.i = getelementptr inbounds nuw %"class.std::ios_base", ptr %add.ptr.i, i64 0, i32 5, !intel-tbaa !124
  %8 = load i32, ptr %_M_streambuf_state.i.i.i, align 8, !tbaa !124
  %or.i.i.i = or i32 %8, 1
  invoke void @_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate(ptr noundef nonnull align 8 dereferenceable(264) %add.ptr.i, i32 noundef %or.i.i.i)
          to label %invoke.cont11 unwind label %lpad7

if.else.i:                                        ; preds = %invoke.cont8
  %call.i.i33 = call noundef i64 @strlen(ptr noundef nonnull dereferenceable(1) %call10) #37
  %call1.i3436 = invoke noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cerr, ptr noundef nonnull %call10, i64 noundef %call.i.i33)
          to label %invoke.cont11 unwind label %lpad7

invoke.cont11:                                    ; preds = %if.then.i35, %if.else.i
  call void @__cxa_end_catch()
  br label %try.cont

try.cont:                                         ; preds = %for.body, %invoke.cont11
  %incdec.ptr.i = getelementptr inbounds nuw %"class.std::__exception_ptr::exception_ptr", ptr %__begin2.sroa.0.043, i64 1
  %cmp.i.not = icmp eq ptr %incdec.ptr.i, %call2
  br i1 %cmp.i.not, label %for.cond.cleanup, label %for.body

lpad7:                                            ; preds = %if.else.i, %if.then.i35, %catch
  %9 = landingpad { ptr, i32 }
          cleanup
  invoke void @__cxa_end_catch()
          to label %ehcleanup unwind label %terminate.lpad

ehcleanup:                                        ; preds = %_ZNSt15__exception_ptr13exception_ptrD2Ev.exit, %lpad7
  %lpad.val21.merged = phi { ptr, i32 } [ %9, %lpad7 ], [ %1, %_ZNSt15__exception_ptr13exception_ptrD2Ev.exit ]
  resume { ptr, i32 } %lpad.val21.merged

terminate.lpad:                                   ; preds = %lpad7
  %10 = landingpad { ptr, i32 }
          catch ptr null
  %11 = extractvalue { ptr, i32 } %10, 0
  call void @__clang_call_terminate(ptr %11) #38
  unreachable
}

declare dso_local void @_ZN4sycl3_V15queueC2ERKNS0_6deviceERKSt8functionIFvNS0_14exception_listEEERKNS0_13property_listE(ptr noundef nonnull align 8 dereferenceable(16), ptr noundef nonnull align 8 dereferenceable(16), ptr noundef nonnull align 8 dereferenceable(32), ptr noundef nonnull align 8 dereferenceable(32)) unnamed_addr #8

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr writeonly captures(none), i8, i64, i1 immarg) #22

; Function Attrs: mustprogress uwtable
define linkonce_odr dso_local noundef i32 @_ZNSt17_Function_handlerIFiRKN4sycl3_V16deviceEEPS5_E9_M_invokeERKSt9_Any_dataS4_(ptr noundef nonnull align 8 dereferenceable(16) %__functor, ptr noundef nonnull align 8 dereferenceable(16) %__args) #23 comdat align 2 {
entry:
  %arrayidx.i.i.i = getelementptr inbounds nuw [16 x i8], ptr %__functor, i64 0, i64 0
  %0 = load ptr, ptr %arrayidx.i.i.i, align 8, !tbaa !28
  %call.i.i = tail call noundef i32 %0(ptr noundef nonnull align 8 dereferenceable(16) %__args)
  ret i32 %call.i.i
}

; Function Attrs: mustprogress uwtable
define linkonce_odr dso_local noundef zeroext i1 @_ZNSt17_Function_handlerIFiRKN4sycl3_V16deviceEEPS5_E10_M_managerERSt9_Any_dataRKS8_St18_Manager_operation(ptr noundef nonnull align 8 dereferenceable(16) %__dest, ptr noundef nonnull align 8 dereferenceable(16) %__source, i32 noundef %__op) #23 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  switch i32 %__op, label %sw.epilog [
    i32 0, label %sw.bb
    i32 1, label %sw.bb1
    i32 2, label %sw.bb4.i
  ]

sw.bb:                                            ; preds = %entry
  %arrayidx.i.i = getelementptr inbounds nuw [16 x i8], ptr %__dest, i64 0, i64 0
  store ptr @_ZTIPFiRKN4sycl3_V16deviceEE, ptr %arrayidx.i.i, align 8, !tbaa !125
  br label %sw.epilog

sw.bb1:                                           ; preds = %entry
  %arrayidx.i.i.i = getelementptr inbounds nuw [16 x i8], ptr %__source, i64 0, i64 0
  %arrayidx.i.i9 = getelementptr inbounds nuw [16 x i8], ptr %__dest, i64 0, i64 0
  store ptr %arrayidx.i.i.i, ptr %arrayidx.i.i9, align 8, !tbaa !28
  br label %sw.epilog

sw.bb4.i:                                         ; preds = %entry
  %arrayidx.i.i.i12.i = getelementptr inbounds nuw [16 x i8], ptr %__source, i64 0, i64 0
  %arrayidx.i.i.i13.i = getelementptr inbounds nuw [16 x i8], ptr %__dest, i64 0, i64 0
  %0 = load ptr, ptr %arrayidx.i.i.i12.i, align 8, !tbaa !28
  store ptr %0, ptr %arrayidx.i.i.i13.i, align 8, !tbaa !28
  br label %sw.epilog

sw.epilog:                                        ; preds = %entry, %sw.bb4.i, %sw.bb1, %sw.bb
  ret i1 false
}

declare dso_local ptr @_ZNK4sycl3_V114exception_list5beginEv(ptr noundef nonnull align 8 dereferenceable(24)) local_unnamed_addr #8

declare dso_local ptr @_ZNK4sycl3_V114exception_list3endEv(ptr noundef nonnull align 8 dereferenceable(24)) local_unnamed_addr #8

; Function Attrs: noreturn
declare dso_local void @_ZSt17rethrow_exceptionNSt15__exception_ptr13exception_ptrE(ptr noundef) local_unnamed_addr #24

; Function Attrs: nounwind
declare dso_local void @_ZNSt15__exception_ptr13exception_ptr9_M_addrefEv(ptr noundef nonnull align 8 dereferenceable(8)) local_unnamed_addr #13

; Function Attrs: nounwind
declare dso_local void @_ZNSt15__exception_ptr13exception_ptr10_M_releaseEv(ptr noundef nonnull align 8 dereferenceable(8)) local_unnamed_addr #13

; Function Attrs: mustprogress uwtable
define linkonce_odr dso_local void @_ZNSt17_Function_handlerIFvN4sycl3_V114exception_listEEPS3_E9_M_invokeERKSt9_Any_dataOS2_(ptr noundef nonnull align 8 dereferenceable(16) %__functor, ptr noundef nonnull align 8 dereferenceable(24) %__args) #23 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %agg.tmp.i.i = alloca %"class.sycl::_V1::exception_list", align 16
  %arrayidx.i.i.i = getelementptr inbounds nuw [16 x i8], ptr %__functor, i64 0, i64 0
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %agg.tmp.i.i)
  %0 = load ptr, ptr %arrayidx.i.i.i, align 8, !tbaa !31
  %_M_start.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data", ptr %agg.tmp.i.i, i64 0, i32 0, !intel-tbaa !127
  %_M_start2.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data", ptr %__args, i64 0, i32 0, !intel-tbaa !127
  %1 = load <2 x ptr>, ptr %_M_start2.i.i.i.i.i.i.i, align 8, !tbaa !130
  store <2 x ptr> %1, ptr %_M_start.i.i.i.i.i.i.i, align 16, !tbaa !130
  %_M_end_of_storage.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data", ptr %agg.tmp.i.i, i64 0, i32 2, !intel-tbaa !131
  %_M_end_of_storage4.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data", ptr %__args, i64 0, i32 2, !intel-tbaa !131
  %2 = load ptr, ptr %_M_end_of_storage4.i.i.i.i.i.i.i, align 8, !tbaa !131
  store ptr %2, ptr %_M_end_of_storage.i.i.i.i.i.i.i, align 16, !tbaa !131
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %_M_start2.i.i.i.i.i.i.i, i8 0, i64 24, i1 false)
  invoke void %0(ptr noundef nonnull %agg.tmp.i.i)
          to label %invoke.cont.i.i unwind label %lpad.i.i

invoke.cont.i.i:                                  ; preds = %entry
  %_M_finish.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data", ptr %agg.tmp.i.i, i64 0, i32 1, !intel-tbaa !132
  %3 = load ptr, ptr %_M_start.i.i.i.i.i.i.i, align 16, !tbaa !127
  %4 = load ptr, ptr %_M_finish.i.i.i.i.i.i.i, align 8, !tbaa !132
  %cmp.not3.i.i.i.i.i.i.i = icmp eq ptr %3, %4
  br i1 %cmp.not3.i.i.i.i.i.i.i, label %invoke.cont.i.i.i.i, label %for.body.i.i.i.i.i.i.i

for.body.i.i.i.i.i.i.i:                           ; preds = %invoke.cont.i.i, %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i.i.i.i
  %__first.addr.04.i.i.i.i.i.i.i = phi ptr [ %incdec.ptr.i.i.i.i.i.i.i, %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i.i.i.i ], [ %3, %invoke.cont.i.i ]
  %5 = load ptr, ptr %__first.addr.04.i.i.i.i.i.i.i, align 8, !tbaa !122
  %tobool.not.i.i.i.i.i.i.i.i.i = icmp eq ptr %5, null
  br i1 %tobool.not.i.i.i.i.i.i.i.i.i, label %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i.i:                        ; preds = %for.body.i.i.i.i.i.i.i
  call void @_ZNSt15__exception_ptr13exception_ptr10_M_releaseEv(ptr noundef nonnull align 8 dereferenceable(8) %__first.addr.04.i.i.i.i.i.i.i) #37
  br label %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i.i.i.i

_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i.i.i.i: ; preds = %if.then.i.i.i.i.i.i.i.i.i, %for.body.i.i.i.i.i.i.i
  %incdec.ptr.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.std::__exception_ptr::exception_ptr", ptr %__first.addr.04.i.i.i.i.i.i.i, i64 1
  %cmp.not.i.i.i.i.i.i.i = icmp eq ptr %incdec.ptr.i.i.i.i.i.i.i, %4
  br i1 %cmp.not.i.i.i.i.i.i.i, label %invoke.contthread-pre-split.i.i.i.i, label %for.body.i.i.i.i.i.i.i, !llvm.loop !133

invoke.contthread-pre-split.i.i.i.i:              ; preds = %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i.i.i.i
  %.pr.i.i.i.i = load ptr, ptr %_M_start.i.i.i.i.i.i.i, align 16, !tbaa !127
  br label %invoke.cont.i.i.i.i

invoke.cont.i.i.i.i:                              ; preds = %invoke.contthread-pre-split.i.i.i.i, %invoke.cont.i.i
  %6 = phi ptr [ %.pr.i.i.i.i, %invoke.contthread-pre-split.i.i.i.i ], [ %3, %invoke.cont.i.i ]
  %tobool.not.i.i.i.i.i.i = icmp eq ptr %6, null
  br i1 %tobool.not.i.i.i.i.i.i, label %_ZSt10__invoke_rIvRPFvN4sycl3_V114exception_listEEJS2_EENSt9enable_ifIX16is_invocable_r_vIT_T0_DpT1_EES7_E4typeEOS8_DpOS9_.exit, label %if.then.i.i.i.i.i.i

if.then.i.i.i.i.i.i:                              ; preds = %invoke.cont.i.i.i.i
  %7 = load ptr, ptr %_M_end_of_storage.i.i.i.i.i.i.i, align 16, !tbaa !131
  %sub.ptr.lhs.cast.i.i.i.i.i = ptrtoint ptr %7 to i64
  %sub.ptr.rhs.cast.i.i.i.i.i = ptrtoint ptr %6 to i64
  %sub.ptr.sub.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i.i.i.i, %sub.ptr.rhs.cast.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %6, i64 noundef %sub.ptr.sub.i.i.i.i.i) #39
  br label %_ZSt10__invoke_rIvRPFvN4sycl3_V114exception_listEEJS2_EENSt9enable_ifIX16is_invocable_r_vIT_T0_DpT1_EES7_E4typeEOS8_DpOS9_.exit

lpad.i.i:                                         ; preds = %entry
  %8 = landingpad { ptr, i32 }
          cleanup
  call void @_ZN4sycl3_V114exception_listD2Ev(ptr noundef nonnull align 8 dereferenceable(24) %agg.tmp.i.i) #37
  resume { ptr, i32 } %8

_ZSt10__invoke_rIvRPFvN4sycl3_V114exception_listEEJS2_EENSt9enable_ifIX16is_invocable_r_vIT_T0_DpT1_EES7_E4typeEOS8_DpOS9_.exit: ; preds = %invoke.cont.i.i.i.i, %if.then.i.i.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %agg.tmp.i.i)
  ret void
}

; Function Attrs: mustprogress uwtable
define linkonce_odr dso_local noundef zeroext i1 @_ZNSt17_Function_handlerIFvN4sycl3_V114exception_listEEPS3_E10_M_managerERSt9_Any_dataRKS6_St18_Manager_operation(ptr noundef nonnull align 8 dereferenceable(16) %__dest, ptr noundef nonnull align 8 dereferenceable(16) %__source, i32 noundef %__op) #23 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  switch i32 %__op, label %sw.epilog [
    i32 0, label %sw.bb
    i32 1, label %sw.bb1
    i32 2, label %sw.bb4.i
  ]

sw.bb:                                            ; preds = %entry
  %arrayidx.i.i = getelementptr inbounds nuw [16 x i8], ptr %__dest, i64 0, i64 0
  store ptr @_ZTIPFvN4sycl3_V114exception_listEE, ptr %arrayidx.i.i, align 8, !tbaa !125
  br label %sw.epilog

sw.bb1:                                           ; preds = %entry
  %arrayidx.i.i.i = getelementptr inbounds nuw [16 x i8], ptr %__source, i64 0, i64 0
  %arrayidx.i.i9 = getelementptr inbounds nuw [16 x i8], ptr %__dest, i64 0, i64 0
  store ptr %arrayidx.i.i.i, ptr %arrayidx.i.i9, align 8, !tbaa !134
  br label %sw.epilog

sw.bb4.i:                                         ; preds = %entry
  %arrayidx.i.i.i12.i = getelementptr inbounds nuw [16 x i8], ptr %__source, i64 0, i64 0
  %arrayidx.i.i.i13.i = getelementptr inbounds nuw [16 x i8], ptr %__dest, i64 0, i64 0
  %0 = load ptr, ptr %arrayidx.i.i.i12.i, align 8, !tbaa !31
  store ptr %0, ptr %arrayidx.i.i.i13.i, align 8, !tbaa !31
  br label %sw.epilog

sw.epilog:                                        ; preds = %entry, %sw.bb4.i, %sw.bb1, %sw.bb
  ret i1 false
}

; Function Attrs: inlinehint mustprogress nounwind uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V114exception_listD2Ev(ptr noundef nonnull align 8 dereferenceable(24) %this) unnamed_addr #9 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %_M_start.i = getelementptr inbounds nuw %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data", ptr %this, i64 0, i32 0, !intel-tbaa !127
  %0 = load ptr, ptr %_M_start.i, align 8, !tbaa !127
  %_M_finish.i = getelementptr inbounds nuw %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data", ptr %this, i64 0, i32 1, !intel-tbaa !132
  %1 = load ptr, ptr %_M_finish.i, align 8, !tbaa !132
  %cmp.not3.i.i.i.i = icmp eq ptr %0, %1
  br i1 %cmp.not3.i.i.i.i, label %invoke.cont.i, label %for.body.i.i.i.i

for.body.i.i.i.i:                                 ; preds = %entry, %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i
  %__first.addr.04.i.i.i.i = phi ptr [ %incdec.ptr.i.i.i.i, %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i ], [ %0, %entry ]
  %2 = load ptr, ptr %__first.addr.04.i.i.i.i, align 8, !tbaa !122
  %tobool.not.i.i.i.i.i.i = icmp eq ptr %2, null
  br i1 %tobool.not.i.i.i.i.i.i, label %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i, label %if.then.i.i.i.i.i.i

if.then.i.i.i.i.i.i:                              ; preds = %for.body.i.i.i.i
  tail call void @_ZNSt15__exception_ptr13exception_ptr10_M_releaseEv(ptr noundef nonnull align 8 dereferenceable(8) %__first.addr.04.i.i.i.i) #37
  br label %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i

_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i: ; preds = %if.then.i.i.i.i.i.i, %for.body.i.i.i.i
  %incdec.ptr.i.i.i.i = getelementptr inbounds nuw %"class.std::__exception_ptr::exception_ptr", ptr %__first.addr.04.i.i.i.i, i64 1
  %cmp.not.i.i.i.i = icmp eq ptr %incdec.ptr.i.i.i.i, %1
  br i1 %cmp.not.i.i.i.i, label %invoke.contthread-pre-split.i, label %for.body.i.i.i.i, !llvm.loop !133

invoke.contthread-pre-split.i:                    ; preds = %_ZSt8_DestroyINSt15__exception_ptr13exception_ptrEEvPT_.exit.i.i.i.i
  %.pr.i = load ptr, ptr %_M_start.i, align 8, !tbaa !127
  br label %invoke.cont.i

invoke.cont.i:                                    ; preds = %invoke.contthread-pre-split.i, %entry
  %3 = phi ptr [ %.pr.i, %invoke.contthread-pre-split.i ], [ %0, %entry ]
  %tobool.not.i.i.i = icmp eq ptr %3, null
  br i1 %tobool.not.i.i.i, label %_ZNSt6vectorINSt15__exception_ptr13exception_ptrESaIS1_EED2Ev.exit, label %if.then.i.i.i

if.then.i.i.i:                                    ; preds = %invoke.cont.i
  %_M_end_of_storage.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base<std::__exception_ptr::exception_ptr, std::allocator<std::__exception_ptr::exception_ptr>>::_Vector_impl_data", ptr %this, i64 0, i32 2, !intel-tbaa !131
  %4 = load ptr, ptr %_M_end_of_storage.i.i, align 8, !tbaa !131
  %sub.ptr.lhs.cast.i.i = ptrtoint ptr %4 to i64
  %sub.ptr.rhs.cast.i.i = ptrtoint ptr %3 to i64
  %sub.ptr.sub.i.i = sub i64 %sub.ptr.lhs.cast.i.i, %sub.ptr.rhs.cast.i.i
  tail call void @_ZdlPvm(ptr noundef nonnull %3, i64 noundef %sub.ptr.sub.i.i) #39
  br label %_ZNSt6vectorINSt15__exception_ptr13exception_ptrESaIS1_EED2Ev.exit

_ZNSt6vectorINSt15__exception_ptr13exception_ptrESaIS1_EED2Ev.exit: ; preds = %invoke.cont.i, %if.then.i.i.i
  ret void
}

declare dso_local void @_ZNK4sycl3_V16device13get_info_implINS0_4info6device4nameEEENS0_6detail11ABINeutralTINS6_19is_device_info_descIT_E11return_typeEE4typeEv(ptr dead_on_unwind writable sret(%"class.sycl::_V1::detail::string") align 8, ptr noundef nonnull align 8 dereferenceable(16)) local_unnamed_addr #8

; Function Attrs: nofree
declare dso_local noundef ptr @_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm(ptr noundef nonnull align 8 dereferenceable(32), ptr noundef nonnull align 8 dereferenceable(8), i64 noundef) local_unnamed_addr #0

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdaPv(ptr noundef) local_unnamed_addr #17

declare dso_local void @_ZNK4sycl3_V15queue11get_contextEv(ptr dead_on_unwind writable sret(%"class.sycl::_V1::context") align 8, ptr noundef nonnull align 8 dereferenceable(16)) local_unnamed_addr #8

; Function Attrs: inlinehint mustprogress nounwind uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V17contextD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %this) unnamed_addr #9 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %_M_pi.i.i = getelementptr inbounds nuw %"class.sycl::_V1::context", ptr %this, i64 0, i32 0, i32 0, i32 1
  %0 = load ptr, ptr %_M_pi.i.i, align 8, !tbaa !33
  %cmp.not.i.i = icmp eq ptr %0, null
  br i1 %cmp.not.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail12context_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, label %if.then.i.i

if.then.i.i:                                      ; preds = %entry
  %_M_use_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 1, !intel-tbaa !36
  %1 = load atomic i64, ptr %_M_use_count.i.i.i acquire, align 8
  %cmp.i.i.i = icmp eq i64 %1, 4294967297
  %2 = trunc i64 %1 to i32
  br i1 %cmp.i.i.i, label %if.then.i.i.i, label %if.end.i.i.i

if.then.i.i.i:                                    ; preds = %if.then.i.i
  store i32 0, ptr %_M_use_count.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i, i64 2
  %3 = load ptr, ptr %vfn.i.i.i, align 8
  tail call void %3(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  %vtable3.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn4.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i, i64 3
  %4 = load ptr, ptr %vfn4.i.i.i, align 8
  tail call void %4(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail12context_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

if.end.i.i.i:                                     ; preds = %if.then.i.i
  %5 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i = icmp eq i8 %5, 0
  br i1 %tobool.i.not.i.i.i, label %if.else.i.i.i.i, label %if.then.i.i.i.i

if.then.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %add.i.i.i.i = add nsw i32 %2, -1
  store i32 %add.i.i.i.i, ptr %_M_use_count.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i

if.else.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %6 = atomicrmw volatile add ptr %_M_use_count.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i

invoke.cont.i.i.i:                                ; preds = %if.else.i.i.i.i, %if.then.i.i.i.i
  %retval.0.i.i.i.i = phi i32 [ %2, %if.then.i.i.i.i ], [ %6, %if.else.i.i.i.i ]
  %cmp6.i.i.i = icmp eq i32 %retval.0.i.i.i.i, 1
  br i1 %cmp6.i.i.i, label %if.then7.i.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail12context_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, !prof !42

if.then7.i.i.i:                                   ; preds = %invoke.cont.i.i.i
  tail call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail12context_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

_ZNSt12__shared_ptrIN4sycl3_V16detail12context_implELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit: ; preds = %entry, %if.then.i.i.i, %invoke.cont.i.i.i, %if.then7.i.i.i
  ret void
}

declare dso_local noundef ptr @_ZN4sycl3_V120aligned_alloc_sharedEmmRKNS0_6deviceERKNS0_7contextERKNS0_13property_listERKNS0_6detail13code_locationE(i64 noundef, i64 noundef, ptr noundef nonnull align 8 dereferenceable(16), ptr noundef nonnull align 8 dereferenceable(16), ptr noundef nonnull align 8 dereferenceable(32), ptr noundef nonnull align 8 dereferenceable(32)) local_unnamed_addr #8

; Function Attrs: mustprogress uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V15queue17submit_with_eventILb0ENS0_3ext6oneapi12experimental10propertiesINS5_6detail20properties_type_listIJEEEEEEENS0_5eventET0_RKNS0_6detail19type_erased_cgfo_tyEPS1_RKNSD_13code_locationE(ptr dead_on_unwind noalias writable sret(%"class.sycl::_V1::event") align 8 %agg.result, ptr noundef nonnull align 8 dereferenceable(16) %this, ptr noundef nonnull align 8 dereferenceable(16) %CGF, ptr noundef %SecondaryQueuePtr, ptr noundef nonnull align 8 dereferenceable(32) %CodeLoc) local_unnamed_addr #23 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %TlsCodeLocCapture = alloca %"class.sycl::_V1::detail::tls_code_loc_t", align 1
  %SI = alloca %"class.sycl::_V1::detail::SubmissionInfo", align 8
  call void @llvm.lifetime.start.p0(i64 1, ptr nonnull %TlsCodeLocCapture) #37
  call void @_ZN4sycl3_V16detail14tls_code_loc_tC1ERKNS1_13code_locationE(ptr noundef nonnull align 1 dereferenceable(1) %TlsCodeLocCapture, ptr noundef nonnull align 8 dereferenceable(32) %CodeLoc)
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %SI) #37
  invoke void @_ZN4sycl3_V16detail14SubmissionInfoC1Ev(ptr noundef nonnull align 8 dereferenceable(16) %SI)
          to label %invoke.cont unwind label %lpad

invoke.cont:                                      ; preds = %entry
  %tobool.not = icmp eq ptr %SecondaryQueuePtr, null
  br i1 %tobool.not, label %if.end, label %if.then

if.then:                                          ; preds = %invoke.cont
  %0 = load ptr, ptr %SecondaryQueuePtr, align 8, !tbaa !136
  %cmp.i.not.i = icmp eq ptr %0, null
  br i1 %cmp.i.not.i, label %cond.false.i, label %_ZN4sycl3_V16detail14getSyclObjImplINS0_5queueEEERKDtsrT_4implERKS4_.exit

cond.false.i:                                     ; preds = %if.then
  call void @__assert_fail(ptr noundef nonnull @.str.13, ptr noundef nonnull @.str.14, i32 noundef 33, ptr noundef nonnull @__PRETTY_FUNCTION__._ZN4sycl3_V16detail14getSyclObjImplINS0_5queueEEERKDtsrT_4implERKS4_) #38
  unreachable

_ZN4sycl3_V16detail14getSyclObjImplINS0_5queueEEERKDtsrT_4implERKS4_.exit: ; preds = %if.then
  %call6 = invoke noundef nonnull align 8 dereferenceable(16) ptr @_ZN4sycl3_V16detail14SubmissionInfo14SecondaryQueueEv(ptr noundef nonnull align 8 dereferenceable(16) %SI)
          to label %invoke.cont5 unwind label %lpad2

invoke.cont5:                                     ; preds = %_ZN4sycl3_V16detail14getSyclObjImplINS0_5queueEEERKDtsrT_4implERKS4_.exit
  %1 = load ptr, ptr %SecondaryQueuePtr, align 8, !tbaa !136
  %_M_ptr2.i.i = getelementptr inbounds nuw %"class.std::__shared_ptr", ptr %call6, i64 0, i32 0, !intel-tbaa !136
  store ptr %1, ptr %_M_ptr2.i.i, align 8, !tbaa !136
  %_M_pi.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::queue", ptr %SecondaryQueuePtr, i64 0, i32 0, i32 0, i32 1
  %2 = load ptr, ptr %_M_pi.i.i.i, align 8, !tbaa !33
  %_M_pi2.i.i.i = getelementptr inbounds nuw %"class.std::__shared_ptr", ptr %call6, i64 0, i32 1, i32 0, !intel-tbaa !139
  %3 = load ptr, ptr %_M_pi2.i.i.i, align 8, !tbaa !33
  %cmp.not.i.i.i = icmp eq ptr %2, %3
  br i1 %cmp.not.i.i.i, label %if.end, label %if.then.i.i.i

if.then.i.i.i:                                    ; preds = %invoke.cont5
  %cmp3.not.i.i.i = icmp eq ptr %2, null
  br i1 %cmp3.not.i.i.i, label %if.end.i.i.i, label %if.then4.i.i.i

if.then4.i.i.i:                                   ; preds = %if.then.i.i.i
  %_M_use_count.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %2, i64 0, i32 1, !intel-tbaa !36
  %4 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.i.not.i.i.i.i = icmp eq i8 %4, 0
  br i1 %tobool.i.i.not.i.i.i.i, label %if.else.i.i.i.i.i, label %if.then.i.i.i.i.i

if.then.i.i.i.i.i:                                ; preds = %if.then4.i.i.i
  %5 = load i32, ptr %_M_use_count.i.i.i.i, align 4, !tbaa !36
  %add.i.i.i.i.i = add nsw i32 %5, 1
  store i32 %add.i.i.i.i.i, ptr %_M_use_count.i.i.i.i, align 4, !tbaa !36
  br label %if.end.i.i.i

if.else.i.i.i.i.i:                                ; preds = %if.then4.i.i.i
  %6 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i, i32 1 acq_rel, align 4
  %.pr.pre.i.i.i = load ptr, ptr %_M_pi2.i.i.i, align 8, !tbaa !33
  br label %if.end.i.i.i

if.end.i.i.i:                                     ; preds = %if.else.i.i.i.i.i, %if.then.i.i.i.i.i, %if.then.i.i.i
  %7 = phi ptr [ %3, %if.then.i.i.i ], [ %.pr.pre.i.i.i, %if.else.i.i.i.i.i ], [ %3, %if.then.i.i.i.i.i ]
  %cmp6.not.i.i.i = icmp eq ptr %7, null
  br i1 %cmp6.not.i.i.i, label %if.end9.i.i.i, label %if.then7.i.i.i

if.then7.i.i.i:                                   ; preds = %if.end.i.i.i
  %_M_use_count.i16.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %7, i64 0, i32 1, !intel-tbaa !36
  %8 = load atomic i64, ptr %_M_use_count.i16.i.i.i acquire, align 8
  %cmp.i.i.i.i = icmp eq i64 %8, 4294967297
  %9 = trunc i64 %8 to i32
  br i1 %cmp.i.i.i.i, label %if.then.i.i.i.i, label %if.end.i.i.i.i

if.then.i.i.i.i:                                  ; preds = %if.then7.i.i.i
  store i32 0, ptr %_M_use_count.i16.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %7, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i.i = load ptr, ptr %7, align 8, !tbaa !39
  %vfn.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i, i64 2
  %10 = load ptr, ptr %vfn.i.i.i.i, align 8
  call void %10(ptr noundef nonnull align 8 dereferenceable(16) %7) #37
  %vtable3.i.i.i.i = load ptr, ptr %7, align 8, !tbaa !39
  %vfn4.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i, i64 3
  %11 = load ptr, ptr %vfn4.i.i.i.i, align 8
  call void %11(ptr noundef nonnull align 8 dereferenceable(16) %7) #37
  br label %if.end9.i.i.i

if.end.i.i.i.i:                                   ; preds = %if.then7.i.i.i
  %12 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i = icmp eq i8 %12, 0
  br i1 %tobool.i.not.i.i.i.i, label %if.else.i.i19.i.i.i, label %if.then.i.i17.i.i.i

if.then.i.i17.i.i.i:                              ; preds = %if.end.i.i.i.i
  %add.i.i18.i.i.i = add nsw i32 %9, -1
  store i32 %add.i.i18.i.i.i, ptr %_M_use_count.i16.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i

if.else.i.i19.i.i.i:                              ; preds = %if.end.i.i.i.i
  %13 = atomicrmw volatile add ptr %_M_use_count.i16.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i

invoke.cont.i.i.i.i:                              ; preds = %if.else.i.i19.i.i.i, %if.then.i.i17.i.i.i
  %retval.0.i.i.i.i.i = phi i32 [ %9, %if.then.i.i17.i.i.i ], [ %13, %if.else.i.i19.i.i.i ]
  %cmp6.i.i.i.i = icmp eq i32 %retval.0.i.i.i.i.i, 1
  br i1 %cmp6.i.i.i.i, label %if.then7.i.i.i.i, label %if.end9.i.i.i, !prof !42

if.then7.i.i.i.i:                                 ; preds = %invoke.cont.i.i.i.i
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %7) #37
  br label %if.end9.i.i.i

if.end9.i.i.i:                                    ; preds = %if.then7.i.i.i.i, %invoke.cont.i.i.i.i, %if.then.i.i.i.i, %if.end.i.i.i
  store ptr %2, ptr %_M_pi2.i.i.i, align 8, !tbaa !33
  br label %if.end

lpad:                                             ; preds = %entry
  %14 = landingpad { ptr, i32 }
          cleanup
  br label %ehcleanup

lpad2:                                            ; preds = %invoke.cont8, %if.end, %_ZN4sycl3_V16detail14getSyclObjImplINS0_5queueEEERKDtsrT_4implERKS4_.exit
  %15 = landingpad { ptr, i32 }
          cleanup
  call void @_ZN4sycl3_V16detail14SubmissionInfoD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %SI) #37
  br label %ehcleanup

if.end:                                           ; preds = %if.end9.i.i.i, %invoke.cont5, %invoke.cont
  %call9 = invoke noundef nonnull align 8 dereferenceable(32) ptr @_ZN4sycl3_V16detail14tls_code_loc_t5queryEv(ptr noundef nonnull align 1 dereferenceable(1) %TlsCodeLocCapture)
          to label %invoke.cont8 unwind label %lpad2

invoke.cont8:                                     ; preds = %if.end
  %MLocalScope.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::tls_code_loc_t", ptr %TlsCodeLocCapture, i64 0, i32 0, !intel-tbaa !140
  %16 = load i8, ptr %MLocalScope.i, align 1, !tbaa !140, !range !142, !noundef !143
  %loadedv.not.i = icmp eq i8 %16, 0
  invoke void @_ZN4sycl3_V15queue22submit_with_event_implERKNS0_6detail19type_erased_cgfo_tyERKNS2_14SubmissionInfoERKNS2_13code_locationEb(ptr dead_on_unwind writable sret(%"class.sycl::_V1::event") align 8 %agg.result, ptr noundef nonnull align 8 dereferenceable(16) %this, ptr noundef nonnull align 8 dereferenceable(16) %CGF, ptr noundef nonnull align 8 dereferenceable(16) %SI, ptr noundef nonnull align 8 dereferenceable(32) %call9, i1 noundef zeroext %loadedv.not.i)
          to label %invoke.cont12 unwind label %lpad2

invoke.cont12:                                    ; preds = %invoke.cont8
  %_M_pi.i.i.i20 = getelementptr inbounds nuw %"class.sycl::_V1::detail::SubmissionInfo", ptr %SI, i64 0, i32 0, i32 0, i32 1
  %17 = load ptr, ptr %_M_pi.i.i.i20, align 8, !tbaa !33
  %cmp.not.i.i.i21 = icmp eq ptr %17, null
  br i1 %cmp.not.i.i.i21, label %_ZN4sycl3_V16detail14SubmissionInfoD2Ev.exit, label %if.then.i.i.i22

if.then.i.i.i22:                                  ; preds = %invoke.cont12
  %_M_use_count.i.i.i.i23 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %17, i64 0, i32 1, !intel-tbaa !36
  %18 = load atomic i64, ptr %_M_use_count.i.i.i.i23 acquire, align 8
  %cmp.i.i.i.i24 = icmp eq i64 %18, 4294967297
  %19 = trunc i64 %18 to i32
  br i1 %cmp.i.i.i.i24, label %if.then.i.i.i.i34, label %if.end.i.i.i.i25

if.then.i.i.i.i34:                                ; preds = %if.then.i.i.i22
  store i32 0, ptr %_M_use_count.i.i.i.i23, align 8, !tbaa !36
  %_M_weak_count.i.i.i.i35 = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %17, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i.i35, align 4, !tbaa !38
  %vtable.i.i.i.i36 = load ptr, ptr %17, align 8, !tbaa !39
  %vfn.i.i.i.i37 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i36, i64 2
  %20 = load ptr, ptr %vfn.i.i.i.i37, align 8
  call void %20(ptr noundef nonnull align 8 dereferenceable(16) %17) #37
  %vtable3.i.i.i.i38 = load ptr, ptr %17, align 8, !tbaa !39
  %vfn4.i.i.i.i39 = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i.i38, i64 3
  %21 = load ptr, ptr %vfn4.i.i.i.i39, align 8
  call void %21(ptr noundef nonnull align 8 dereferenceable(16) %17) #37
  br label %_ZN4sycl3_V16detail14SubmissionInfoD2Ev.exit

if.end.i.i.i.i25:                                 ; preds = %if.then.i.i.i22
  %22 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i.i26 = icmp eq i8 %22, 0
  br i1 %tobool.i.not.i.i.i.i26, label %if.else.i.i.i.i.i33, label %if.then.i.i.i.i.i27

if.then.i.i.i.i.i27:                              ; preds = %if.end.i.i.i.i25
  %add.i.i.i.i.i28 = add nsw i32 %19, -1
  store i32 %add.i.i.i.i.i28, ptr %_M_use_count.i.i.i.i23, align 4, !tbaa !36
  br label %invoke.cont.i.i.i.i29

if.else.i.i.i.i.i33:                              ; preds = %if.end.i.i.i.i25
  %23 = atomicrmw volatile add ptr %_M_use_count.i.i.i.i23, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i.i29

invoke.cont.i.i.i.i29:                            ; preds = %if.else.i.i.i.i.i33, %if.then.i.i.i.i.i27
  %retval.0.i.i.i.i.i30 = phi i32 [ %19, %if.then.i.i.i.i.i27 ], [ %23, %if.else.i.i.i.i.i33 ]
  %cmp6.i.i.i.i31 = icmp eq i32 %retval.0.i.i.i.i.i30, 1
  br i1 %cmp6.i.i.i.i31, label %if.then7.i.i.i.i32, label %_ZN4sycl3_V16detail14SubmissionInfoD2Ev.exit, !prof !42

if.then7.i.i.i.i32:                               ; preds = %invoke.cont.i.i.i.i29
  call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %17) #37
  br label %_ZN4sycl3_V16detail14SubmissionInfoD2Ev.exit

_ZN4sycl3_V16detail14SubmissionInfoD2Ev.exit:     ; preds = %invoke.cont12, %if.then.i.i.i.i34, %invoke.cont.i.i.i.i29, %if.then7.i.i.i.i32
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %SI) #37
  call void @_ZN4sycl3_V16detail14tls_code_loc_tD1Ev(ptr noundef nonnull align 1 dereferenceable(1) %TlsCodeLocCapture) #37
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %TlsCodeLocCapture) #37
  ret void

ehcleanup:                                        ; preds = %lpad2, %lpad
  %.pn = phi { ptr, i32 } [ %15, %lpad2 ], [ %14, %lpad ]
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %SI) #37
  call void @_ZN4sycl3_V16detail14tls_code_loc_tD1Ev(ptr noundef nonnull align 1 dereferenceable(1) %TlsCodeLocCapture) #37
  call void @llvm.lifetime.end.p0(i64 1, ptr nonnull %TlsCodeLocCapture) #37
  resume { ptr, i32 } %.pn
}

declare dso_local void @_ZN4sycl3_V16detail14tls_code_loc_tC1ERKNS1_13code_locationE(ptr noundef nonnull align 1 dereferenceable(1), ptr noundef nonnull align 8 dereferenceable(32)) unnamed_addr #8

declare dso_local void @_ZN4sycl3_V16detail14SubmissionInfoC1Ev(ptr noundef nonnull align 8 dereferenceable(16)) unnamed_addr #8

declare dso_local noundef nonnull align 8 dereferenceable(16) ptr @_ZN4sycl3_V16detail14SubmissionInfo14SecondaryQueueEv(ptr noundef nonnull align 8 dereferenceable(16)) local_unnamed_addr #8

declare dso_local void @_ZN4sycl3_V15queue22submit_with_event_implERKNS0_6detail19type_erased_cgfo_tyERKNS2_14SubmissionInfoERKNS2_13code_locationEb(ptr dead_on_unwind writable sret(%"class.sycl::_V1::event") align 8, ptr noundef nonnull align 8 dereferenceable(16), ptr noundef nonnull align 8 dereferenceable(16), ptr noundef nonnull align 8 dereferenceable(16), ptr noundef nonnull align 8 dereferenceable(32), i1 noundef zeroext) local_unnamed_addr #8

declare dso_local noundef nonnull align 8 dereferenceable(32) ptr @_ZN4sycl3_V16detail14tls_code_loc_t5queryEv(ptr noundef nonnull align 1 dereferenceable(1)) local_unnamed_addr #8

; Function Attrs: inlinehint mustprogress nounwind uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V16detail14SubmissionInfoD2Ev(ptr noundef nonnull align 8 dereferenceable(16) %this) unnamed_addr #9 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %_M_pi.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::SubmissionInfo", ptr %this, i64 0, i32 0, i32 0, i32 1
  %0 = load ptr, ptr %_M_pi.i.i, align 8, !tbaa !33
  %cmp.not.i.i = icmp eq ptr %0, null
  br i1 %cmp.not.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail18SubmissionInfoImplELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, label %if.then.i.i

if.then.i.i:                                      ; preds = %entry
  %_M_use_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 1, !intel-tbaa !36
  %1 = load atomic i64, ptr %_M_use_count.i.i.i acquire, align 8
  %cmp.i.i.i = icmp eq i64 %1, 4294967297
  %2 = trunc i64 %1 to i32
  br i1 %cmp.i.i.i, label %if.then.i.i.i, label %if.end.i.i.i

if.then.i.i.i:                                    ; preds = %if.then.i.i
  store i32 0, ptr %_M_use_count.i.i.i, align 8, !tbaa !36
  %_M_weak_count.i.i.i = getelementptr inbounds nuw %"class.std::_Sp_counted_base", ptr %0, i64 0, i32 2, !intel-tbaa !38
  store i32 0, ptr %_M_weak_count.i.i.i, align 4, !tbaa !38
  %vtable.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i, i64 2
  %3 = load ptr, ptr %vfn.i.i.i, align 8
  tail call void %3(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  %vtable3.i.i.i = load ptr, ptr %0, align 8, !tbaa !39
  %vfn4.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable3.i.i.i, i64 3
  %4 = load ptr, ptr %vfn4.i.i.i, align 8
  tail call void %4(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail18SubmissionInfoImplELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

if.end.i.i.i:                                     ; preds = %if.then.i.i
  %5 = load i8, ptr @__libc_single_threaded, align 1, !tbaa !41
  %tobool.i.not.i.i.i = icmp eq i8 %5, 0
  br i1 %tobool.i.not.i.i.i, label %if.else.i.i.i.i, label %if.then.i.i.i.i

if.then.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %add.i.i.i.i = add nsw i32 %2, -1
  store i32 %add.i.i.i.i, ptr %_M_use_count.i.i.i, align 4, !tbaa !36
  br label %invoke.cont.i.i.i

if.else.i.i.i.i:                                  ; preds = %if.end.i.i.i
  %6 = atomicrmw volatile add ptr %_M_use_count.i.i.i, i32 -1 acq_rel, align 4
  br label %invoke.cont.i.i.i

invoke.cont.i.i.i:                                ; preds = %if.else.i.i.i.i, %if.then.i.i.i.i
  %retval.0.i.i.i.i = phi i32 [ %2, %if.then.i.i.i.i ], [ %6, %if.else.i.i.i.i ]
  %cmp6.i.i.i = icmp eq i32 %retval.0.i.i.i.i, 1
  br i1 %cmp6.i.i.i, label %if.then7.i.i.i, label %_ZNSt12__shared_ptrIN4sycl3_V16detail18SubmissionInfoImplELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit, !prof !42

if.then7.i.i.i:                                   ; preds = %invoke.cont.i.i.i
  tail call void @_ZNSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE24_M_release_last_use_coldEv(ptr noundef nonnull align 8 dereferenceable(16) %0) #37
  br label %_ZNSt12__shared_ptrIN4sycl3_V16detail18SubmissionInfoImplELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit

_ZNSt12__shared_ptrIN4sycl3_V16detail18SubmissionInfoImplELN9__gnu_cxx12_Lock_policyE2EED2Ev.exit: ; preds = %entry, %if.then.i.i.i, %invoke.cont.i.i.i, %if.then7.i.i.i
  ret void
}

; Function Attrs: nounwind
declare dso_local void @_ZN4sycl3_V16detail14tls_code_loc_tD1Ev(ptr noundef nonnull align 1 dereferenceable(1)) unnamed_addr #13

; Function Attrs: nofree noreturn nounwind
declare dso_local void @__assert_fail(ptr noundef, ptr noundef, i32 noundef, ptr noundef) local_unnamed_addr #25

; Function Attrs: mustprogress uwtable
define internal void @_ZN4sycl3_V16detail19type_erased_cgfo_ty7invokerIZ4mainEUlRNS0_7handlerEE_E4callEPKvS5_(ptr noundef readonly captures(none) %object, ptr noundef nonnull align 8 dereferenceable(216) %cgh) #23 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %ref.tmp5.i54.i.i.i.i = alloca %"class.std::vector.79", align 8
  %agg.tmp.i52.i.i.i.i = alloca %"class.sycl::_V1::range.69", align 8
  %ref.tmp5.i.i.i.i.i = alloca %"class.std::vector.79", align 8
  %agg.tmp.i.i.i.i.i = alloca %"class.sycl::_V1::range.69", align 8
  %UserRange.i.i.i.i = alloca %"class.sycl::_V1::range", align 8
  %0 = alloca %"class.std::tuple.61", align 8
  %object.val = load ptr, ptr %object, align 8, !tbaa !144
  %object.val.val = load ptr, ptr %object.val, align 8, !tbaa !97
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %UserRange.i.i.i.i)
  %coerce.dive1.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::range", ptr %UserRange.i.i.i.i, i64 0, i32 0, i32 0
  store i64 1024, ptr %coerce.dive1.i.i.i.i, align 8
  %call.i.i.i.i.i = tail call noundef i32 @_ZNK4sycl3_V17handler7getTypeEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %cmp.not.i.i.i.i.i = icmp eq i32 %call.i.i.i.i.i, 0
  br i1 %cmp.not.i.i.i.i.i, label %if.end.i.i.i.i, label %if.then.i.i.i.i.i

if.then.i.i.i.i.i:                                ; preds = %entry
  %exception.i.i.i.i.i = tail call ptr @__cxa_allocate_exception(i64 64) #37
  %call2.i.i.i.i.i = tail call { i32, ptr } @_ZN4sycl3_V115make_error_codeENS0_4errcE(i32 noundef 1) #37
  %1 = extractvalue { i32, ptr } %call2.i.i.i.i.i, 0
  %2 = extractvalue { i32, ptr } %call2.i.i.i.i.i, 1
  invoke void @_ZN4sycl3_V19exceptionC1ESt10error_codePKc(ptr noundef nonnull align 8 dereferenceable(64) %exception.i.i.i.i.i, i32 %1, ptr %2, ptr noundef nonnull @.str.16)
          to label %invoke.cont.i.i.i.i.i unwind label %lpad.i.i.i.i.i

invoke.cont.i.i.i.i.i:                            ; preds = %if.then.i.i.i.i.i
  tail call void @__cxa_throw(ptr nonnull %exception.i.i.i.i.i, ptr nonnull @_ZTIN4sycl3_V19exceptionE, ptr nonnull @_ZN4sycl3_V19exceptionD1Ev) #40
  unreachable

common.resume.i.i.i.i:                            ; preds = %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i, %lpad.i.i.i.i.i
  %common.resume.op.i.i.i.i = phi { ptr, i32 } [ %3, %lpad.i.i.i.i.i ], [ %26, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i ], [ %15, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i ]
  resume { ptr, i32 } %common.resume.op.i.i.i.i

lpad.i.i.i.i.i:                                   ; preds = %if.then.i.i.i.i.i
  %3 = landingpad { ptr, i32 }
          cleanup
  tail call void @__cxa_free_exception(ptr nonnull %exception.i.i.i.i.i) #37
  br label %common.resume.i.i.i.i

if.end.i.i.i.i:                                   ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %0) #37
  call void @_ZN4sycl3_V17handler15getRoundedRangeILi1EEESt5tupleIJNS0_5rangeIXT_EEEbEES5_(ptr dead_on_unwind nonnull writable sret(%"class.std::tuple.61") align 8 %0, ptr noundef nonnull align 8 dereferenceable(216) %cgh, i64 1024)
  %_M_head_impl.i.i.i.i44.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Head_base.64", ptr %0, i64 0, i32 0, !intel-tbaa !149
  %4 = load i8, ptr %_M_head_impl.i.i.i.i44.i.i.i.i, align 8, !tbaa !149, !range !142, !noundef !143
  %loadedv.not.i.i.i.i = icmp eq i8 %4, 0
  br i1 %loadedv.not.i.i.i.i, label %if.else.i.i.i.i, label %if.then10.i.i.i.i

if.then10.i.i.i.i:                                ; preds = %if.end.i.i.i.i
  %_M_head_impl.i.i.i.i.i.i.i.i = getelementptr inbounds nuw i64, ptr %0, i64 1
  %agg.tmp12.sroa.0.0.copyload.i.i.i.i = load i64, ptr %UserRange.i.i.i.i, align 8
  call void @_ZN4sycl3_V17handler30verifyUsedKernelBundleInternalENS0_6detail11string_viewE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr nonnull @.str.23)
  call void @_ZN4sycl3_V16detail15checkValueRangeILi1ENS0_5rangeILi1EEEEENSt9enable_ifIXoosr3stdE9is_same_vIT0_NS3_IXT_EEEEsr3stdE9is_same_vIS6_NS0_2idIXT_EEEEEvE4typeERKS6_(ptr noundef nonnull align 8 dereferenceable(8) %UserRange.i.i.i.i)
  %agg.tmp21.sroa.0.0.copyload.i.i.i.i = load i64, ptr %_M_head_impl.i.i.i.i.i.i.i.i, align 8, !tbaa !151
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %agg.tmp.i.i.i.i.i)
  %common_array.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i.i.i.i.i, i64 0, i32 0, !intel-tbaa !156
  %5 = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i.i.i.i.i, i64 0, i32 0, i64 1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %5, i8 0, i64 16, i1 false), !alias.scope !159
  store i64 %agg.tmp21.sroa.0.0.copyload.i.i.i.i, ptr %common_array.i.i.i.i.i.i.i.i, align 8, !tbaa !162, !alias.scope !159
  call void @_ZN4sycl3_V17handler26setNDRangeDescriptorPaddedENS0_5rangeILi3EEEbi(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef nonnull byval(%"class.sycl::_V1::range.69") align 8 %agg.tmp.i.i.i.i.i, i1 noundef zeroext false, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %agg.tmp.i.i.i.i.i)
  %call.i.i45.i.i.i.i = call noalias noundef nonnull dereferenceable(24) ptr @_Znwm(i64 noundef 24) #41, !noalias !163
  store ptr getelementptr inbounds inrange(-16, 32) ({ [6 x ptr] }, ptr @_ZTVN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, i64 0, i32 0, i64 2), ptr %call.i.i45.i.i.i.i, align 8, !tbaa !39, !noalias !163
  %MKernel.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel", ptr %call.i.i45.i.i.i.i, i64 0, i32 1, !intel-tbaa !166
  store i64 %agg.tmp12.sroa.0.0.copyload.i.i.i.i, ptr %MKernel.i.i.i.i.i.i.i, align 8, !noalias !163
  %Kernel.sroa.2.0.MKernel.sroa_idx.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel", ptr %call.i.i45.i.i.i.i, i64 0, i32 1, i32 1
  store ptr %object.val.val, ptr %Kernel.sroa.2.0.MKernel.sroa_idx.i.i.i.i.i.i.i, align 8, !noalias !163
  %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 10
  %6 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  store ptr %call.i.i45.i.i.i.i, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  %tobool.not.i.i.i.i.i.i.i.i = icmp eq ptr %6, null
  br i1 %tobool.not.i.i.i.i.i.i.i.i, label %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i, label %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i

_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i: ; preds = %if.then10.i.i.i.i
  %vtable.i.i.i.i.i.i.i.i.i = load ptr, ptr %6, align 8, !tbaa !39
  %vfn.i.i.i.i.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i.i.i.i.i, i64 2
  %7 = load ptr, ptr %vfn.i.i.i.i.i.i.i.i.i, align 8
  call void %7(ptr noundef nonnull align 8 dereferenceable(8) %6) #37
  br label %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i

_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i: ; preds = %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i, %if.then10.i.i.i.i
  call void @_ZN4sycl3_V17handler9clearArgsEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %8 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  %vtable.i.i.i.i.i = load ptr, ptr %8, align 8, !tbaa !39
  %9 = load ptr, ptr %vtable.i.i.i.i.i, align 8
  %call4.i.i.i.i.i = call noundef ptr %9(ptr noundef nonnull align 8 dereferenceable(8) %8)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  %_M_end_of_storage.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i.i.i.i.i, i64 0, i32 0, i32 0, i32 2
  %_M_finish.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i.i.i.i.i, i64 0, i32 0, i32 0, i32 1
  %call5.i.i.i.i13.i.i.i.i.i.i = call noalias noundef nonnull dereferenceable(24) ptr @_Znwm(i64 noundef 24) #41, !noalias !174
  %add.ptr21.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 2, !intel-tbaa !177
  store i64 34359738369, ptr %call5.i.i.i.i13.i.i.i.i.i.i, align 4
  %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i = getelementptr inbounds nuw i32, ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 2
  store i32 0, ptr %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i, align 4, !tbaa !9
  %10 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 1
  store i64 34359738369, ptr %10, align 4
  %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i.1 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 1, i32 2
  store i32 8, ptr %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i.1, align 4, !tbaa !9
  %11 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %10, i64 1
  store ptr %11, ptr %_M_finish.i.i.i.i.i.i.i.i, align 8
  store ptr %add.ptr21.i.i.i.i.i.i.i, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8
  store ptr %call5.i.i.i.i13.i.i.i.i.i.i, ptr %ref.tmp5.i.i.i.i.i, align 8
  invoke void @_ZN4sycl3_V17handler28extractArgsAndReqsFromLambdaEPcRKSt6vectorINS0_6detail19kernel_param_desc_tESaIS5_EEb(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef %call4.i.i.i.i.i, ptr noundef nonnull align 8 dereferenceable(24) %ref.tmp5.i.i.i.i.i, i1 noundef zeroext false)
          to label %invoke.cont7.i.i.i.i.i unwind label %lpad.i47.i.i.i.i

invoke.cont7.i.i.i.i.i:                           ; preds = %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i
  %12 = load ptr, ptr %ref.tmp5.i.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i17.i.i.i.i.i = icmp eq ptr %12, null
  br i1 %tobool.not.i.i.i17.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i:                          ; preds = %invoke.cont7.i.i.i.i.i
  %13 = load ptr, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i.i.i.i.i.i = ptrtoint ptr %13 to i64
  %sub.ptr.rhs.cast.i.i.i.i.i.i.i = ptrtoint ptr %12 to i64
  %sub.ptr.sub.i.i.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i.i.i.i.i.i, %sub.ptr.rhs.cast.i.i.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %12, i64 noundef %sub.ptr.sub.i.i.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i: ; preds = %if.then.i.i.i.i.i.i.i.i, %invoke.cont7.i.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  %call2.i.i.i.i.i.i.i = call noalias noundef nonnull dereferenceable(122) ptr @_Znam(i64 noundef 122) #41
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(121) %call2.i.i.i.i.i.i.i, ptr noundef nonnull align 1 dereferenceable(121) @.str.27, i64 121, i1 false)
  %arrayidx.i.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %call2.i.i.i.i.i.i.i, i64 121
  store i8 0, ptr %arrayidx.i.i.i.i.i.i.i, align 1, !tbaa !41
  %str.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 4, i32 0, !intel-tbaa !184
  %14 = load ptr, ptr %str.i.i.i.i.i.i.i.i, align 8, !tbaa !217
  store ptr %call2.i.i.i.i.i.i.i, ptr %str.i.i.i.i.i.i.i.i, align 8, !tbaa !217
  %isnull.i.i.i.i.i.i.i = icmp eq ptr %14, null
  br i1 %isnull.i.i.i.i.i.i.i, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_.exit, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_.exit.sink.split

lpad.i47.i.i.i.i:                                 ; preds = %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i
  %15 = landingpad { ptr, i32 }
          cleanup
  %16 = load ptr, ptr %ref.tmp5.i.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i20.i.i.i.i.i = icmp eq ptr %16, null
  br i1 %tobool.not.i.i.i20.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i, label %if.then.i.i.i21.i.i.i.i.i

if.then.i.i.i21.i.i.i.i.i:                        ; preds = %lpad.i47.i.i.i.i
  %17 = load ptr, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i23.i.i.i.i.i = ptrtoint ptr %17 to i64
  %sub.ptr.rhs.cast.i.i24.i.i.i.i.i = ptrtoint ptr %16 to i64
  %sub.ptr.sub.i.i25.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i23.i.i.i.i.i, %sub.ptr.rhs.cast.i.i24.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %16, i64 noundef %sub.ptr.sub.i.i25.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i: ; preds = %if.then.i.i.i21.i.i.i.i.i, %lpad.i47.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  br label %common.resume.i.i.i.i

if.else.i.i.i.i:                                  ; preds = %if.end.i.i.i.i
  call void @_ZN4sycl3_V17handler30verifyUsedKernelBundleInternalENS0_6detail11string_viewE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr nonnull @.str.23)
  call void @_ZN4sycl3_V16detail15checkValueRangeILi1ENS0_5rangeILi1EEEEENSt9enable_ifIXoosr3stdE9is_same_vIT0_NS3_IXT_EEEEsr3stdE9is_same_vIS6_NS0_2idIXT_EEEEEvE4typeERKS6_(ptr noundef nonnull align 8 dereferenceable(8) %UserRange.i.i.i.i)
  %agg.tmp30.sroa.0.0.copyload.i.i.i.i = load i64, ptr %UserRange.i.i.i.i, align 8
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %agg.tmp.i52.i.i.i.i)
  %common_array.i.i.i.i53.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i52.i.i.i.i, i64 0, i32 0, !intel-tbaa !156
  %18 = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i52.i.i.i.i, i64 0, i32 0, i64 1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %18, i8 0, i64 16, i1 false), !alias.scope !218
  store i64 %agg.tmp30.sroa.0.0.copyload.i.i.i.i, ptr %common_array.i.i.i.i53.i.i.i.i, align 8, !tbaa !162, !alias.scope !218
  call void @_ZN4sycl3_V17handler26setNDRangeDescriptorPaddedENS0_5rangeILi3EEEbi(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef nonnull byval(%"class.sycl::_V1::range.69") align 8 %agg.tmp.i52.i.i.i.i, i1 noundef zeroext false, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %agg.tmp.i52.i.i.i.i)
  %call.i.i55.i.i.i.i = call noalias noundef nonnull dereferenceable(16) ptr @_Znwm(i64 noundef 16) #41, !noalias !221
  store ptr getelementptr inbounds inrange(-16, 32) ({ [6 x ptr] }, ptr @_ZTVN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, i64 0, i32 0, i64 2), ptr %call.i.i55.i.i.i.i, align 8, !tbaa !39, !noalias !221
  %MKernel.i.i.i56.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.95", ptr %call.i.i55.i.i.i.i, i64 0, i32 1, !intel-tbaa !224
  store ptr %object.val.val, ptr %MKernel.i.i.i56.i.i.i.i, align 8, !tbaa !97, !noalias !221
  %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 10
  %19 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  store ptr %call.i.i55.i.i.i.i, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  %tobool.not.i.i.i.i60.i.i.i.i = icmp eq ptr %19, null
  br i1 %tobool.not.i.i.i.i60.i.i.i.i, label %invoke.cont.i64.i.i.i.i, label %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i

_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i: ; preds = %if.else.i.i.i.i
  %vtable.i.i.i.i.i62.i.i.i.i = load ptr, ptr %19, align 8, !tbaa !39
  %vfn.i.i.i.i.i63.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i62.i.i.i.i, i64 2
  %20 = load ptr, ptr %vfn.i.i.i.i.i63.i.i.i.i, align 8
  call void %20(ptr noundef nonnull align 8 dereferenceable(8) %19) #37
  br label %invoke.cont.i64.i.i.i.i

invoke.cont.i64.i.i.i.i:                          ; preds = %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i, %if.else.i.i.i.i
  call void @_ZN4sycl3_V17handler9clearArgsEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %21 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  %vtable.i65.i.i.i.i = load ptr, ptr %21, align 8, !tbaa !39
  %22 = load ptr, ptr %vtable.i65.i.i.i.i, align 8
  %call4.i66.i.i.i.i = call noundef ptr %22(ptr noundef nonnull align 8 dereferenceable(8) %21)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  call void @llvm.experimental.noalias.scope.decl(metadata !226)
  %_M_end_of_storage.i.i.i.i69.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i54.i.i.i.i, i64 0, i32 0, i32 0, i32 2
  %_M_finish.i.i.i.i70.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i54.i.i.i.i, i64 0, i32 0, i32 0, i32 1
  %call5.i.i.i.i13.i.i71.i.i.i.i = call noalias noundef nonnull dereferenceable(12) ptr @_Znwm(i64 noundef 12) #41, !noalias !226
  store ptr %call5.i.i.i.i13.i.i71.i.i.i.i, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180, !alias.scope !226
  %add.ptr21.i.i.i72.i.i.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i71.i.i.i.i, i64 1, !intel-tbaa !177
  store ptr %add.ptr21.i.i.i72.i.i.i.i, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183, !alias.scope !226
  store i64 34359738371, ptr %call5.i.i.i.i13.i.i71.i.i.i.i, align 4
  %ref.tmp.i.sroa.6.0..sroa_idx.i73.i.i.i.i = getelementptr inbounds nuw i32, ptr %call5.i.i.i.i13.i.i71.i.i.i.i, i64 2
  store i32 0, ptr %ref.tmp.i.sroa.6.0..sroa_idx.i73.i.i.i.i, align 4, !tbaa !9
  store ptr %add.ptr21.i.i.i72.i.i.i.i, ptr %_M_finish.i.i.i.i70.i.i.i.i, align 8, !tbaa !229
  invoke void @_ZN4sycl3_V17handler28extractArgsAndReqsFromLambdaEPcRKSt6vectorINS0_6detail19kernel_param_desc_tESaIS5_EEb(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef %call4.i66.i.i.i.i, ptr noundef nonnull align 8 dereferenceable(24) %ref.tmp5.i54.i.i.i.i, i1 noundef zeroext false)
          to label %invoke.cont7.i76.i.i.i.i unwind label %lpad.i75.i.i.i.i

invoke.cont7.i76.i.i.i.i:                         ; preds = %invoke.cont.i64.i.i.i.i
  %23 = load ptr, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i16.i.i.i.i.i = icmp eq ptr %23, null
  br i1 %tobool.not.i.i.i16.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i, label %if.then.i.i.i.i77.i.i.i.i

if.then.i.i.i.i77.i.i.i.i:                        ; preds = %invoke.cont7.i76.i.i.i.i
  %24 = load ptr, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i.i78.i.i.i.i = ptrtoint ptr %24 to i64
  %sub.ptr.rhs.cast.i.i.i79.i.i.i.i = ptrtoint ptr %23 to i64
  %sub.ptr.sub.i.i.i80.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i.i78.i.i.i.i, %sub.ptr.rhs.cast.i.i.i79.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %23, i64 noundef %sub.ptr.sub.i.i.i80.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i: ; preds = %if.then.i.i.i.i77.i.i.i.i, %invoke.cont7.i76.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  %call2.i.i.i82.i.i.i.i = call noalias noundef nonnull dereferenceable(64) ptr @_Znam(i64 noundef 64) #41
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(63) %call2.i.i.i82.i.i.i.i, ptr noundef nonnull align 1 dereferenceable(63) @.str.23, i64 63, i1 false)
  %arrayidx.i.i.i83.i.i.i.i = getelementptr inbounds nuw i8, ptr %call2.i.i.i82.i.i.i.i, i64 63
  store i8 0, ptr %arrayidx.i.i.i83.i.i.i.i, align 1, !tbaa !41
  %str.i.i.i.i84.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 4, i32 0, !intel-tbaa !184
  %25 = load ptr, ptr %str.i.i.i.i84.i.i.i.i, align 8, !tbaa !217
  store ptr %call2.i.i.i82.i.i.i.i, ptr %str.i.i.i.i84.i.i.i.i, align 8, !tbaa !217
  %isnull.i.i.i85.i.i.i.i = icmp eq ptr %25, null
  br i1 %isnull.i.i.i85.i.i.i.i, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_.exit, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_.exit.sink.split

lpad.i75.i.i.i.i:                                 ; preds = %invoke.cont.i64.i.i.i.i
  %26 = landingpad { ptr, i32 }
          cleanup
  %27 = load ptr, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i19.i.i.i.i.i = icmp eq ptr %27, null
  br i1 %tobool.not.i.i.i19.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i, label %if.then.i.i.i20.i.i.i.i.i

if.then.i.i.i20.i.i.i.i.i:                        ; preds = %lpad.i75.i.i.i.i
  %28 = load ptr, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i22.i.i.i.i.i = ptrtoint ptr %28 to i64
  %sub.ptr.rhs.cast.i.i23.i.i.i.i.i = ptrtoint ptr %27 to i64
  %sub.ptr.sub.i.i24.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i22.i.i.i.i.i, %sub.ptr.rhs.cast.i.i23.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %27, i64 noundef %sub.ptr.sub.i.i24.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i: ; preds = %if.then.i.i.i20.i.i.i.i.i, %lpad.i75.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  br label %common.resume.i.i.i.i

_ZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_.exit.sink.split: ; preds = %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i
  %.sink = phi ptr [ %14, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i ], [ %25, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i ]
  call void @_ZdaPv(ptr noundef nonnull %.sink) #39
  br label %_ZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_.exit

_ZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_.exit:   ; preds = %_ZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_.exit.sink.split, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i
  call void @_ZN4sycl3_V17handler7setTypeENS0_6detail6CGTypeE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %0) #37
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %UserRange.i.i.i.i)
  ret void
}

; Function Attrs: nofree
declare dso_local noalias ptr @__cxa_allocate_exception(i64) local_unnamed_addr #12

; Function Attrs: nounwind
declare dso_local { i32, ptr } @_ZN4sycl3_V115make_error_codeENS0_4errcE(i32 noundef) local_unnamed_addr #13

declare dso_local void @_ZN4sycl3_V19exceptionC1ESt10error_codePKc(ptr noundef nonnull align 8 dereferenceable(64), i32, ptr, ptr noundef) unnamed_addr #8

; Function Attrs: nofree
declare dso_local void @__cxa_free_exception(ptr) local_unnamed_addr #12

; Function Attrs: nounwind
declare dso_local void @_ZN4sycl3_V19exceptionD1Ev(ptr noundef nonnull align 8 dereferenceable(64)) unnamed_addr #13

; Function Attrs: cold noreturn
declare dso_local void @__cxa_throw(ptr, ptr, ptr) local_unnamed_addr #26

; Function Attrs: mustprogress uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V17handler15getRoundedRangeILi1EEESt5tupleIJNS0_5rangeIXT_EEEbEES5_(ptr dead_on_unwind noalias writable sret(%"class.std::tuple.61") align 8 %agg.result, ptr noundef nonnull align 8 dereferenceable(216) %this, i64 %UserRange.coerce) local_unnamed_addr #23 comdat align 2 personality ptr @__gxx_personality_v0 {
entry:
  %0 = alloca %"class.std::tuple.66", align 8
  %MinFactorX = alloca i64, align 8
  %GoodFactor = alloca i64, align 8
  %MinRangeX = alloca i64, align 8
  %call = tail call noundef zeroext i1 @_ZN4sycl3_V17handler20DisableRangeRoundingEv(ptr noundef nonnull align 8 dereferenceable(216) %this)
  br i1 %call, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %_M_head_impl.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Head_base.64", ptr %agg.result, i64 0, i32 0, !intel-tbaa !149
  store i8 0, ptr %_M_head_impl.i.i.i.i, align 8, !tbaa !149
  %_M_head_impl.i.i.i = getelementptr inbounds nuw i64, ptr %agg.result, i64 1
  store i64 0, ptr %_M_head_impl.i.i.i, align 8
  br label %cleanup51

if.end:                                           ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %MinFactorX) #37
  store i64 16, ptr %MinFactorX, align 8, !tbaa !60
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %GoodFactor) #37
  store i64 32, ptr %GoodFactor, align 8, !tbaa !60
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %MinRangeX) #37
  store i64 1024, ptr %MinRangeX, align 8, !tbaa !60
  call void @_ZN4sycl3_V17handler24GetRangeRoundingSettingsERmS2_S2_(ptr noundef nonnull align 8 dereferenceable(216) %this, ptr noundef nonnull align 8 dereferenceable(8) %MinFactorX, ptr noundef nonnull align 8 dereferenceable(8) %GoodFactor, ptr noundef nonnull align 8 dereferenceable(8) %MinRangeX)
  call void @llvm.lifetime.start.p0(i64 32, ptr nonnull %0) #37
  call void @_ZN4sycl3_V17handler19getMaxWorkGroups_v2Ev(ptr dead_on_unwind nonnull writable sret(%"class.std::tuple.66") align 8 %0, ptr noundef nonnull align 8 dereferenceable(216) %this)
  %_M_head_impl.i.i.i.i29.i = getelementptr inbounds nuw %"struct.std::_Head_base.64", ptr %0, i64 0, i32 0, !intel-tbaa !149
  %1 = load i8, ptr %_M_head_impl.i.i.i.i29.i, align 8, !tbaa !149, !range !142, !noundef !143
  %loadedv.not.i = icmp eq i8 %1, 0
  %arrayidx.i.i.i = getelementptr inbounds nuw i64, ptr %0, i64 1
  %2 = load i64, ptr %arrayidx.i.i.i, align 8
  %.sroa.speculated.i = call i64 @llvm.umin.i64(i64 %2, i64 2147483647)
  %3 = select i1 %loadedv.not.i, i64 2147483647, i64 %.sroa.speculated.i
  call void @llvm.lifetime.end.p0(i64 32, ptr nonnull %0) #37
  %4 = load i64, ptr %GoodFactor, align 8, !tbaa !60
  %mul = mul i64 %3, %4
  %cmp10.not = icmp ugt i64 %mul, 4294967295
  br i1 %cmp10.not, label %cond.false, label %cond.end

cond.false:                                       ; preds = %if.end
  %5 = urem i64 4294967295, %4
  %mul12 = xor i64 %5, 4294967295
  br label %cond.end

cond.end:                                         ; preds = %if.end, %cond.false
  %cond = phi i64 [ %mul12, %cond.false ], [ %mul, %if.end ]
  %6 = load i64, ptr %MinFactorX, align 8, !tbaa !60
  %rem = urem i64 %UserRange.coerce, %6
  %cmp17.not = icmp eq i64 %rem, 0
  %7 = load i64, ptr %MinRangeX, align 8
  %cmp19.not = icmp ult i64 %UserRange.coerce, %7
  %or.cond = select i1 %cmp17.not, i1 true, i1 %cmp19.not
  br i1 %or.cond, label %if.end24.thread, label %if.then20

if.then20:                                        ; preds = %cond.end
  %add = add i64 %4, %UserRange.coerce
  %add.fr = freeze i64 %add
  %sub = add i64 %add.fr, -1
  %8 = urem i64 %sub, %4
  %mul23 = sub nuw i64 %sub, %8
  %call.i = call noundef zeroext i1 @_ZN4sycl3_V17handler18RangeRoundingTraceEv(ptr noundef nonnull align 8 dereferenceable(216) %this)
  br i1 %call.i, label %if.then.i, label %if.end24

if.then.i:                                        ; preds = %if.then20
  %call1.i.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef nonnull @.str.20, i64 noundef 35)
  %call3.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i32 noundef 0)
  %call1.i16.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) %call3.i, ptr noundef nonnull @.str.21, i64 noundef 6)
  %call.i.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo9_M_insertImEERSoT_(ptr noundef nonnull align 8 dereferenceable(8) %call3.i, i64 noundef %UserRange.coerce)
  %call1.i19.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) %call.i.i, ptr noundef nonnull @.str.22, i64 noundef 4)
  %call.i20.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo9_M_insertImEERSoT_(ptr noundef nonnull align 8 dereferenceable(8) %call.i.i, i64 noundef %mul23)
  %vtable.i.i = load ptr, ptr %call.i20.i, align 8, !tbaa !39
  %vbase.offset.ptr.i.i = getelementptr i64, ptr %vtable.i.i, i64 -3
  %vbase.offset.i.i = load i64, ptr %vbase.offset.ptr.i.i, align 8
  %add.ptr.i.i = getelementptr inbounds i8, ptr %call.i20.i, i64 %vbase.offset.i.i
  %_M_ctype.i.i.i = getelementptr inbounds nuw %"class.std::basic_ios", ptr %add.ptr.i.i, i64 0, i32 5, !intel-tbaa !63
  %9 = load ptr, ptr %_M_ctype.i.i.i, align 8, !tbaa !63
  %tobool.not.i.i.i.i = icmp eq ptr %9, null
  br i1 %tobool.not.i.i.i.i, label %if.then.i.i.i.i, label %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i.i

if.then.i.i.i.i:                                  ; preds = %if.then.i
  call void @_ZSt16__throw_bad_castv() #40
  unreachable

_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i.i: ; preds = %if.then.i
  %_M_widen_ok.i.i.i.i = getelementptr inbounds nuw %"class.std::ctype", ptr %9, i64 0, i32 8, !intel-tbaa !81
  %10 = load i8, ptr %_M_widen_ok.i.i.i.i, align 8, !tbaa !81
  %tobool.not.i3.i.i.i = icmp eq i8 %10, 0
  br i1 %tobool.not.i3.i.i.i, label %if.end.i.i.i.i, label %if.then.i4.i.i.i

if.then.i4.i.i.i:                                 ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i.i
  %arrayidx.i.i.i.i = getelementptr inbounds nuw %"class.std::ctype", ptr %9, i64 0, i32 9, i64 10, !intel-tbaa !88
  %11 = load i8, ptr %arrayidx.i.i.i.i, align 1, !tbaa !88
  br label %if.end.thread.i

if.end.i.i.i.i:                                   ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i.i
  call void @_ZNKSt5ctypeIcE13_M_widen_initEv(ptr noundef nonnull align 8 dereferenceable(570) %9)
  %vtable.i.i.i.i = load ptr, ptr %9, align 8, !tbaa !39
  %vfn.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i, i64 6
  %12 = load ptr, ptr %vfn.i.i.i.i, align 8
  %call.i.i.i.i = call noundef signext i8 %12(ptr noundef nonnull align 8 dereferenceable(570) %9, i8 noundef signext 10)
  br label %if.end.thread.i

if.end.thread.i:                                  ; preds = %if.end.i.i.i.i, %if.then.i4.i.i.i
  %retval.0.i.i.i.i = phi i8 [ %11, %if.then.i4.i.i.i ], [ %call.i.i.i.i, %if.end.i.i.i.i ]
  %call1.i30.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo3putEc(ptr noundef nonnull align 8 dereferenceable(8) %call.i20.i, i8 noundef signext %retval.0.i.i.i.i)
  %call.i.i31.i = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo5flushEv(ptr noundef nonnull align 8 dereferenceable(8) %call1.i30.i)
  br label %if.end24

if.end24:                                         ; preds = %if.end.thread.i, %if.then20
  %cmp32 = icmp ugt i64 %mul23, %cond
  br i1 %cmp32, label %if.then33, label %cleanup

if.end24.thread:                                  ; preds = %cond.end
  %cmp32127 = icmp ugt i64 %UserRange.coerce, %cond
  br i1 %cmp32127, label %if.then33, label %cleanup

if.then33:                                        ; preds = %if.end24.thread, %if.end24
  %RoundedRange.sroa.0.0128 = phi i64 [ %UserRange.coerce, %if.end24.thread ], [ %mul23, %if.end24 ]
  %call.i70 = call noundef zeroext i1 @_ZN4sycl3_V17handler18RangeRoundingTraceEv(ptr noundef nonnull align 8 dereferenceable(216) %this)
  br i1 %call.i70, label %if.then.i75, label %cleanup

if.then.i75:                                      ; preds = %if.then33
  %call1.i.i76 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, ptr noundef nonnull @.str.20, i64 noundef 35)
  %call3.i77 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSolsEi(ptr noundef nonnull align 8 dereferenceable(8) @_ZSt4cout, i32 noundef 0)
  %call1.i16.i78 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) %call3.i77, ptr noundef nonnull @.str.21, i64 noundef 6)
  %call.i.i81 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo9_M_insertImEERSoT_(ptr noundef nonnull align 8 dereferenceable(8) %call3.i77, i64 noundef %RoundedRange.sroa.0.0128)
  %call1.i19.i82 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l(ptr noundef nonnull align 8 dereferenceable(8) %call.i.i81, ptr noundef nonnull @.str.22, i64 noundef 4)
  %call.i20.i83 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo9_M_insertImEERSoT_(ptr noundef nonnull align 8 dereferenceable(8) %call.i.i81, i64 noundef %cond)
  %vtable.i.i84 = load ptr, ptr %call.i20.i83, align 8, !tbaa !39
  %vbase.offset.ptr.i.i85 = getelementptr i64, ptr %vtable.i.i84, i64 -3
  %vbase.offset.i.i86 = load i64, ptr %vbase.offset.ptr.i.i85, align 8
  %add.ptr.i.i87 = getelementptr inbounds i8, ptr %call.i20.i83, i64 %vbase.offset.i.i86
  %_M_ctype.i.i.i88 = getelementptr inbounds nuw %"class.std::basic_ios", ptr %add.ptr.i.i87, i64 0, i32 5, !intel-tbaa !63
  %13 = load ptr, ptr %_M_ctype.i.i.i88, align 8, !tbaa !63
  %tobool.not.i.i.i.i89 = icmp eq ptr %13, null
  br i1 %tobool.not.i.i.i.i89, label %if.then.i.i.i.i103, label %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i.i90

if.then.i.i.i.i103:                               ; preds = %if.then.i75
  call void @_ZSt16__throw_bad_castv() #40
  unreachable

_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i.i90: ; preds = %if.then.i75
  %_M_widen_ok.i.i.i.i91 = getelementptr inbounds nuw %"class.std::ctype", ptr %13, i64 0, i32 8, !intel-tbaa !81
  %14 = load i8, ptr %_M_widen_ok.i.i.i.i91, align 8, !tbaa !81
  %tobool.not.i3.i.i.i92 = icmp eq i8 %14, 0
  br i1 %tobool.not.i3.i.i.i92, label %if.end.i.i.i.i99, label %if.then.i4.i.i.i93

if.then.i4.i.i.i93:                               ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i.i90
  %arrayidx.i.i.i.i94 = getelementptr inbounds nuw %"class.std::ctype", ptr %13, i64 0, i32 9, i64 10, !intel-tbaa !88
  %15 = load i8, ptr %arrayidx.i.i.i.i94, align 1, !tbaa !88
  br label %if.end.thread.i95

if.end.i.i.i.i99:                                 ; preds = %_ZSt13__check_facetISt5ctypeIcEERKT_PS3_.exit.i.i.i90
  call void @_ZNKSt5ctypeIcE13_M_widen_initEv(ptr noundef nonnull align 8 dereferenceable(570) %13)
  %vtable.i.i.i.i100 = load ptr, ptr %13, align 8, !tbaa !39
  %vfn.i.i.i.i101 = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i100, i64 6
  %16 = load ptr, ptr %vfn.i.i.i.i101, align 8
  %call.i.i.i.i102 = call noundef signext i8 %16(ptr noundef nonnull align 8 dereferenceable(570) %13, i8 noundef signext 10)
  br label %if.end.thread.i95

if.end.thread.i95:                                ; preds = %if.end.i.i.i.i99, %if.then.i4.i.i.i93
  %retval.0.i.i.i.i96 = phi i8 [ %15, %if.then.i4.i.i.i93 ], [ %call.i.i.i.i102, %if.end.i.i.i.i99 ]
  %call1.i30.i97 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo3putEc(ptr noundef nonnull align 8 dereferenceable(8) %call.i20.i83, i8 noundef signext %retval.0.i.i.i.i96)
  %call.i.i31.i98 = call noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo5flushEv(ptr noundef nonnull align 8 dereferenceable(8) %call1.i30.i97)
  br label %cleanup

cleanup:                                          ; preds = %if.then33, %if.end.thread.i95, %if.end24, %if.end24.thread
  %.sink = phi i8 [ 0, %if.end24.thread ], [ 1, %if.end24 ], [ 1, %if.end.thread.i95 ], [ 1, %if.then33 ]
  %RoundedRange.sroa.0.1125.sink = phi i64 [ 0, %if.end24.thread ], [ %mul23, %if.end24 ], [ %cond, %if.end.thread.i95 ], [ %cond, %if.then33 ]
  %_M_head_impl.i.i.i.i108 = getelementptr inbounds nuw %"struct.std::_Head_base.64", ptr %agg.result, i64 0, i32 0
  store i8 %.sink, ptr %_M_head_impl.i.i.i.i108, align 8, !tbaa !149
  %_M_head_impl.i.i.i109 = getelementptr inbounds nuw i64, ptr %agg.result, i64 1
  store i64 %RoundedRange.sroa.0.1125.sink, ptr %_M_head_impl.i.i.i109, align 8
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %MinRangeX) #37
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %GoodFactor) #37
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %MinFactorX) #37
  br label %cleanup51

cleanup51:                                        ; preds = %cleanup, %if.then
  ret void
}

declare dso_local void @_ZN4sycl3_V17handler30verifyUsedKernelBundleInternalENS0_6detail11string_viewE(ptr noundef nonnull align 8 dereferenceable(216), ptr) local_unnamed_addr #8

; Function Attrs: mustprogress uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V16detail15checkValueRangeILi1ENS0_5rangeILi1EEEEENSt9enable_ifIXoosr3stdE9is_same_vIT0_NS3_IXT_EEEEsr3stdE9is_same_vIS6_NS0_2idIXT_EEEEEvE4typeERKS6_(ptr noundef nonnull align 8 dereferenceable(8) %V) local_unnamed_addr #23 comdat personality ptr @__gxx_personality_v0 {
entry:
  %arrayidx.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::array", ptr %V, i64 0, i32 0, i64 0, !intel-tbaa !230
  %0 = load i64, ptr %arrayidx.i, align 8, !tbaa !230
  %cmp.i = icmp ugt i64 %0, 2147483647
  br i1 %cmp.i, label %if.then.i, label %for.cond2.1

if.then.i:                                        ; preds = %entry
  %exception.i = tail call ptr @__cxa_allocate_exception(i64 64) #37
  %call.i = tail call { i32, ptr } @_ZN4sycl3_V115make_error_codeENS0_4errcE(i32 noundef 4) #37
  %1 = extractvalue { i32, ptr } %call.i, 0
  %2 = extractvalue { i32, ptr } %call.i, 1
  invoke void @_ZN4sycl3_V19exceptionC1ESt10error_codePKc(ptr noundef nonnull align 8 dereferenceable(64) %exception.i, i32 %1, ptr %2, ptr noundef nonnull @.str.24)
          to label %invoke.cont.i unwind label %lpad.i

invoke.cont.i:                                    ; preds = %if.then.i
  tail call void @__cxa_throw(ptr nonnull %exception.i, ptr nonnull @_ZTIN4sycl3_V19exceptionE, ptr nonnull @_ZN4sycl3_V19exceptionD1Ev) #40
  unreachable

lpad.i:                                           ; preds = %if.then.i
  %3 = landingpad { ptr, i32 }
          cleanup
  tail call void @__cxa_free_exception(ptr nonnull %exception.i) #37
  resume { ptr, i32 } %3

for.cond2.1:                                      ; preds = %entry
  ret void
}

declare dso_local void @_ZN4sycl3_V17handler7setTypeENS0_6detail6CGTypeE(ptr noundef nonnull align 8 dereferenceable(216), i32 noundef) local_unnamed_addr #8

declare dso_local noundef i32 @_ZNK4sycl3_V17handler7getTypeEv(ptr noundef nonnull align 8 dereferenceable(216)) local_unnamed_addr #8

declare dso_local noundef zeroext i1 @_ZN4sycl3_V17handler20DisableRangeRoundingEv(ptr noundef nonnull align 8 dereferenceable(216)) local_unnamed_addr #8

declare dso_local void @_ZN4sycl3_V17handler24GetRangeRoundingSettingsERmS2_S2_(ptr noundef nonnull align 8 dereferenceable(216), ptr noundef nonnull align 8 dereferenceable(8), ptr noundef nonnull align 8 dereferenceable(8), ptr noundef nonnull align 8 dereferenceable(8)) local_unnamed_addr #8

declare dso_local void @_ZN4sycl3_V17handler19getMaxWorkGroups_v2Ev(ptr dead_on_unwind writable sret(%"class.std::tuple.66") align 8, ptr noundef nonnull align 8 dereferenceable(216)) local_unnamed_addr #8

declare dso_local noundef zeroext i1 @_ZN4sycl3_V17handler18RangeRoundingTraceEv(ptr noundef nonnull align 8 dereferenceable(216)) local_unnamed_addr #8

; Function Attrs: nofree
declare dso_local noundef nonnull align 8 dereferenceable(8) ptr @_ZNSo9_M_insertImEERSoT_(ptr noundef nonnull align 8 dereferenceable(8), i64 noundef) local_unnamed_addr #0

declare dso_local void @_ZN4sycl3_V17handler26setNDRangeDescriptorPaddedENS0_5rangeILi3EEEbi(ptr noundef nonnull align 8 dereferenceable(216), ptr noundef byval(%"class.sycl::_V1::range.69") align 8, i1 noundef zeroext, i32 noundef) local_unnamed_addr #8

declare dso_local void @_ZN4sycl3_V17handler9clearArgsEv(ptr noundef nonnull align 8 dereferenceable(216)) local_unnamed_addr #8

declare dso_local void @_ZN4sycl3_V17handler28extractArgsAndReqsFromLambdaEPcRKSt6vectorINS0_6detail19kernel_param_desc_tESaIS5_EEb(ptr noundef nonnull align 8 dereferenceable(216), ptr noundef, ptr noundef nonnull align 8 dereferenceable(24), i1 noundef zeroext) local_unnamed_addr #8

; Function Attrs: nobuiltin allocsize(0)
declare dso_local noundef nonnull ptr @_Znwm(i64 noundef) local_unnamed_addr #27

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define internal noundef nonnull ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE6getPtrEv(ptr noundef nonnull readnone align 8 captures(ret: address, provenance) dereferenceable(24) %this) unnamed_addr #28 align 2 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel", ptr %this, i64 0, i32 1, !intel-tbaa !166
  ret ptr %MKernel
}

; Function Attrs: mustprogress nounwind uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EED0Ev(ptr noundef nonnull align 8 dereferenceable(24) %this) unnamed_addr #29 align 2 {
entry:
  tail call void @_ZdlPvm(ptr noundef nonnull %this, i64 noundef 24) #39
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind memory(readwrite, inaccessiblemem: none) uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE23InstantiateKernelOnHostEv(ptr noundef nonnull readonly align 8 captures(none) dereferenceable(24) %this) unnamed_addr #30 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel", ptr %this, i64 0, i32 1, !intel-tbaa !166
  %agg.tmp.sroa.0.0.copyload = load i64, ptr %MKernel, align 8
  %cmp6.not.i.not.i.i.not = icmp eq i64 %agg.tmp.sroa.0.0.copyload, 0
  br i1 %cmp6.not.i.not.i.i.not, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %for.body.i.preheader.i

for.body.i.preheader.i:                           ; preds = %entry
  %agg.tmp.sroa.2.0.MKernel.sroa_idx = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel", ptr %this, i64 0, i32 1, i32 1
  %agg.tmp.sroa.2.0.copyload = load ptr, ptr %agg.tmp.sroa.2.0.MKernel.sroa_idx, align 8
  %_M_i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::__atomic_base", ptr %agg.tmp.sroa.2.0.copyload, i64 0, i32 0, !intel-tbaa !4
  %xtraiter = and i64 %agg.tmp.sroa.0.0.copyload, 7
  %0 = icmp ult i64 %agg.tmp.sroa.0.0.copyload, 8
  br i1 %0, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, label %for.body.i.preheader.i.new

for.body.i.preheader.i.new:                       ; preds = %for.body.i.preheader.i
  %unroll_iter = and i64 %agg.tmp.sroa.0.0.copyload, -8
  br label %for.body.i.i

for.body.i.i:                                     ; preds = %for.body.i.i, %for.body.i.preheader.i.new
  %niter = phi i64 [ 0, %for.body.i.preheader.i.new ], [ %niter.next.7, %for.body.i.i ]
  %1 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %2 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %3 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %4 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %5 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %6 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %7 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %8 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %niter.next.7 = add i64 %niter, 8
  %niter.ncmp.7 = icmp eq i64 %niter.next.7, %unroll_iter
  br i1 %niter.ncmp.7, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, label %for.body.i.i, !llvm.loop !231

_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa: ; preds = %for.body.i.i, %for.body.i.preheader.i
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %for.body.i.i.epil

for.body.i.i.epil:                                ; preds = %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, %for.body.i.i.epil
  %epil.iter = phi i64 [ %epil.iter.next, %for.body.i.i.epil ], [ 0, %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa ]
  %9 = atomicrmw add ptr %_M_i.i.i.i.i.i.i, i32 1 seq_cst, align 4
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %epil.iter.next, %xtraiter
  br i1 %epil.iter.cmp.not, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %for.body.i.i.epil, !llvm.loop !232

_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit: ; preds = %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, %for.body.i.i.epil, %entry
  ret void
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #31

; Function Attrs: nobuiltin allocsize(0)
declare dso_local noundef nonnull ptr @_Znam(i64 noundef) local_unnamed_addr #27

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define internal noundef nonnull ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE6getPtrEv(ptr noundef nonnull readnone align 8 captures(ret: address, provenance) dereferenceable(16) %this) unnamed_addr #28 align 2 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.95", ptr %this, i64 0, i32 1, !intel-tbaa !224
  ret ptr %MKernel
}

; Function Attrs: mustprogress nounwind uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EED0Ev(ptr noundef nonnull align 8 dereferenceable(16) %this) unnamed_addr #29 align 2 {
entry:
  tail call void @_ZdlPvm(ptr noundef nonnull %this, i64 noundef 16) #39
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind willreturn memory(readwrite, inaccessiblemem: none) uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE23InstantiateKernelOnHostEv(ptr noundef nonnull readonly align 8 captures(none) dereferenceable(16) %this) unnamed_addr #32 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.95", ptr %this, i64 0, i32 1, !intel-tbaa !224
  %agg.tmp.sroa.0.0.copyload = load ptr, ptr %MKernel, align 8, !tbaa !97
  %_M_i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::__atomic_base", ptr %agg.tmp.sroa.0.0.copyload, i64 0, i32 0, !intel-tbaa !4
  %0 = atomicrmw add ptr %_M_i.i.i.i.i.i, i32 1 seq_cst, align 4
  ret void
}

; Function Attrs: mustprogress uwtable
define internal void @_ZN4sycl3_V16detail19type_erased_cgfo_ty7invokerIZ4mainEUlRNS0_7handlerEE0_E4callEPKvS5_(ptr noundef readonly captures(none) %object, ptr noundef nonnull align 8 dereferenceable(216) %cgh) #23 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %ref.tmp5.i54.i.i.i.i = alloca %"class.std::vector.79", align 8
  %agg.tmp.i52.i.i.i.i = alloca %"class.sycl::_V1::range.69", align 8
  %ref.tmp5.i.i.i.i.i = alloca %"class.std::vector.79", align 8
  %agg.tmp.i.i.i.i.i = alloca %"class.sycl::_V1::range.69", align 8
  %UserRange.i.i.i.i = alloca %"class.sycl::_V1::range", align 8
  %0 = alloca %"class.std::tuple.61", align 8
  %object.val = load ptr, ptr %object, align 8, !tbaa !234
  %object.val.val = load ptr, ptr %object.val, align 8, !tbaa !97
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %UserRange.i.i.i.i)
  %coerce.dive1.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::range", ptr %UserRange.i.i.i.i, i64 0, i32 0, i32 0
  store i64 1024, ptr %coerce.dive1.i.i.i.i, align 8
  %call.i.i.i.i.i = tail call noundef i32 @_ZNK4sycl3_V17handler7getTypeEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %cmp.not.i.i.i.i.i = icmp eq i32 %call.i.i.i.i.i, 0
  br i1 %cmp.not.i.i.i.i.i, label %if.end.i.i.i.i, label %if.then.i.i.i.i.i

if.then.i.i.i.i.i:                                ; preds = %entry
  %exception.i.i.i.i.i = tail call ptr @__cxa_allocate_exception(i64 64) #37
  %call2.i.i.i.i.i = tail call { i32, ptr } @_ZN4sycl3_V115make_error_codeENS0_4errcE(i32 noundef 1) #37
  %1 = extractvalue { i32, ptr } %call2.i.i.i.i.i, 0
  %2 = extractvalue { i32, ptr } %call2.i.i.i.i.i, 1
  invoke void @_ZN4sycl3_V19exceptionC1ESt10error_codePKc(ptr noundef nonnull align 8 dereferenceable(64) %exception.i.i.i.i.i, i32 %1, ptr %2, ptr noundef nonnull @.str.16)
          to label %invoke.cont.i.i.i.i.i unwind label %lpad.i.i.i.i.i

invoke.cont.i.i.i.i.i:                            ; preds = %if.then.i.i.i.i.i
  tail call void @__cxa_throw(ptr nonnull %exception.i.i.i.i.i, ptr nonnull @_ZTIN4sycl3_V19exceptionE, ptr nonnull @_ZN4sycl3_V19exceptionD1Ev) #40
  unreachable

common.resume.i.i.i.i:                            ; preds = %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i, %lpad.i.i.i.i.i
  %common.resume.op.i.i.i.i = phi { ptr, i32 } [ %3, %lpad.i.i.i.i.i ], [ %26, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i ], [ %15, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i ]
  resume { ptr, i32 } %common.resume.op.i.i.i.i

lpad.i.i.i.i.i:                                   ; preds = %if.then.i.i.i.i.i
  %3 = landingpad { ptr, i32 }
          cleanup
  tail call void @__cxa_free_exception(ptr nonnull %exception.i.i.i.i.i) #37
  br label %common.resume.i.i.i.i

if.end.i.i.i.i:                                   ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %0) #37
  call void @_ZN4sycl3_V17handler15getRoundedRangeILi1EEESt5tupleIJNS0_5rangeIXT_EEEbEES5_(ptr dead_on_unwind nonnull writable sret(%"class.std::tuple.61") align 8 %0, ptr noundef nonnull align 8 dereferenceable(216) %cgh, i64 1024)
  %_M_head_impl.i.i.i.i44.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Head_base.64", ptr %0, i64 0, i32 0, !intel-tbaa !149
  %4 = load i8, ptr %_M_head_impl.i.i.i.i44.i.i.i.i, align 8, !tbaa !149, !range !142, !noundef !143
  %loadedv.not.i.i.i.i = icmp eq i8 %4, 0
  br i1 %loadedv.not.i.i.i.i, label %if.else.i.i.i.i, label %if.then10.i.i.i.i

if.then10.i.i.i.i:                                ; preds = %if.end.i.i.i.i
  %_M_head_impl.i.i.i.i.i.i.i.i = getelementptr inbounds nuw i64, ptr %0, i64 1
  %agg.tmp12.sroa.0.0.copyload.i.i.i.i = load i64, ptr %UserRange.i.i.i.i, align 8
  call void @_ZN4sycl3_V17handler30verifyUsedKernelBundleInternalENS0_6detail11string_viewE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr nonnull @.str.30)
  call void @_ZN4sycl3_V16detail15checkValueRangeILi1ENS0_5rangeILi1EEEEENSt9enable_ifIXoosr3stdE9is_same_vIT0_NS3_IXT_EEEEsr3stdE9is_same_vIS6_NS0_2idIXT_EEEEEvE4typeERKS6_(ptr noundef nonnull align 8 dereferenceable(8) %UserRange.i.i.i.i)
  %agg.tmp21.sroa.0.0.copyload.i.i.i.i = load i64, ptr %_M_head_impl.i.i.i.i.i.i.i.i, align 8, !tbaa !151
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %agg.tmp.i.i.i.i.i)
  %common_array.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i.i.i.i.i, i64 0, i32 0, !intel-tbaa !156
  %5 = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i.i.i.i.i, i64 0, i32 0, i64 1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %5, i8 0, i64 16, i1 false), !alias.scope !236
  store i64 %agg.tmp21.sroa.0.0.copyload.i.i.i.i, ptr %common_array.i.i.i.i.i.i.i.i, align 8, !tbaa !162, !alias.scope !236
  call void @_ZN4sycl3_V17handler26setNDRangeDescriptorPaddedENS0_5rangeILi3EEEbi(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef nonnull byval(%"class.sycl::_V1::range.69") align 8 %agg.tmp.i.i.i.i.i, i1 noundef zeroext false, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %agg.tmp.i.i.i.i.i)
  %call.i.i45.i.i.i.i = call noalias noundef nonnull dereferenceable(24) ptr @_Znwm(i64 noundef 24) #41, !noalias !239
  store ptr getelementptr inbounds inrange(-16, 32) ({ [6 x ptr] }, ptr @_ZTVN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, i64 0, i32 0, i64 2), ptr %call.i.i45.i.i.i.i, align 8, !tbaa !39, !noalias !239
  %MKernel.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.107", ptr %call.i.i45.i.i.i.i, i64 0, i32 1, !intel-tbaa !242
  store i64 %agg.tmp12.sroa.0.0.copyload.i.i.i.i, ptr %MKernel.i.i.i.i.i.i.i, align 8, !noalias !239
  %Kernel.sroa.2.0.MKernel.sroa_idx.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.107", ptr %call.i.i45.i.i.i.i, i64 0, i32 1, i32 1
  store ptr %object.val.val, ptr %Kernel.sroa.2.0.MKernel.sroa_idx.i.i.i.i.i.i.i, align 8, !noalias !239
  %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 10
  %6 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  store ptr %call.i.i45.i.i.i.i, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  %tobool.not.i.i.i.i.i.i.i.i = icmp eq ptr %6, null
  br i1 %tobool.not.i.i.i.i.i.i.i.i, label %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE0_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i, label %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i

_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i: ; preds = %if.then10.i.i.i.i
  %vtable.i.i.i.i.i.i.i.i.i = load ptr, ptr %6, align 8, !tbaa !39
  %vfn.i.i.i.i.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i.i.i.i.i, i64 2
  %7 = load ptr, ptr %vfn.i.i.i.i.i.i.i.i.i, align 8
  call void %7(ptr noundef nonnull align 8 dereferenceable(8) %6) #37
  br label %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE0_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i

_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE0_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i: ; preds = %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i, %if.then10.i.i.i.i
  call void @_ZN4sycl3_V17handler9clearArgsEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %8 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  %vtable.i.i.i.i.i = load ptr, ptr %8, align 8, !tbaa !39
  %9 = load ptr, ptr %vtable.i.i.i.i.i, align 8
  %call4.i.i.i.i.i = call noundef ptr %9(ptr noundef nonnull align 8 dereferenceable(8) %8)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  %_M_end_of_storage.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i.i.i.i.i, i64 0, i32 0, i32 0, i32 2
  %_M_finish.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i.i.i.i.i, i64 0, i32 0, i32 0, i32 1
  %call5.i.i.i.i13.i.i.i.i.i.i = call noalias noundef nonnull dereferenceable(24) ptr @_Znwm(i64 noundef 24) #41, !noalias !246
  %add.ptr21.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 2, !intel-tbaa !177
  store i64 34359738369, ptr %call5.i.i.i.i13.i.i.i.i.i.i, align 4
  %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i = getelementptr inbounds nuw i32, ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 2
  store i32 0, ptr %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i, align 4, !tbaa !9
  %10 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 1
  store i64 34359738369, ptr %10, align 4
  %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i.1 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 1, i32 2
  store i32 8, ptr %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i.1, align 4, !tbaa !9
  %11 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %10, i64 1
  store ptr %11, ptr %_M_finish.i.i.i.i.i.i.i.i, align 8
  store ptr %add.ptr21.i.i.i.i.i.i.i, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8
  store ptr %call5.i.i.i.i13.i.i.i.i.i.i, ptr %ref.tmp5.i.i.i.i.i, align 8
  invoke void @_ZN4sycl3_V17handler28extractArgsAndReqsFromLambdaEPcRKSt6vectorINS0_6detail19kernel_param_desc_tESaIS5_EEb(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef %call4.i.i.i.i.i, ptr noundef nonnull align 8 dereferenceable(24) %ref.tmp5.i.i.i.i.i, i1 noundef zeroext false)
          to label %invoke.cont7.i.i.i.i.i unwind label %lpad.i47.i.i.i.i

invoke.cont7.i.i.i.i.i:                           ; preds = %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE0_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i
  %12 = load ptr, ptr %ref.tmp5.i.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i17.i.i.i.i.i = icmp eq ptr %12, null
  br i1 %tobool.not.i.i.i17.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i:                          ; preds = %invoke.cont7.i.i.i.i.i
  %13 = load ptr, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i.i.i.i.i.i = ptrtoint ptr %13 to i64
  %sub.ptr.rhs.cast.i.i.i.i.i.i.i = ptrtoint ptr %12 to i64
  %sub.ptr.sub.i.i.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i.i.i.i.i.i, %sub.ptr.rhs.cast.i.i.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %12, i64 noundef %sub.ptr.sub.i.i.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i: ; preds = %if.then.i.i.i.i.i.i.i.i, %invoke.cont7.i.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  %call2.i.i.i.i.i.i.i = call noalias noundef nonnull dereferenceable(123) ptr @_Znam(i64 noundef 123) #41
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(122) %call2.i.i.i.i.i.i.i, ptr noundef nonnull align 1 dereferenceable(122) @.str.31, i64 122, i1 false)
  %arrayidx.i.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %call2.i.i.i.i.i.i.i, i64 122
  store i8 0, ptr %arrayidx.i.i.i.i.i.i.i, align 1, !tbaa !41
  %str.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 4, i32 0, !intel-tbaa !184
  %14 = load ptr, ptr %str.i.i.i.i.i.i.i.i, align 8, !tbaa !217
  store ptr %call2.i.i.i.i.i.i.i, ptr %str.i.i.i.i.i.i.i.i, align 8, !tbaa !217
  %isnull.i.i.i.i.i.i.i = icmp eq ptr %14, null
  br i1 %isnull.i.i.i.i.i.i.i, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_.exit, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_.exit.sink.split

lpad.i47.i.i.i.i:                                 ; preds = %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE0_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i
  %15 = landingpad { ptr, i32 }
          cleanup
  %16 = load ptr, ptr %ref.tmp5.i.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i20.i.i.i.i.i = icmp eq ptr %16, null
  br i1 %tobool.not.i.i.i20.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i, label %if.then.i.i.i21.i.i.i.i.i

if.then.i.i.i21.i.i.i.i.i:                        ; preds = %lpad.i47.i.i.i.i
  %17 = load ptr, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i23.i.i.i.i.i = ptrtoint ptr %17 to i64
  %sub.ptr.rhs.cast.i.i24.i.i.i.i.i = ptrtoint ptr %16 to i64
  %sub.ptr.sub.i.i25.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i23.i.i.i.i.i, %sub.ptr.rhs.cast.i.i24.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %16, i64 noundef %sub.ptr.sub.i.i25.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i: ; preds = %if.then.i.i.i21.i.i.i.i.i, %lpad.i47.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  br label %common.resume.i.i.i.i

if.else.i.i.i.i:                                  ; preds = %if.end.i.i.i.i
  call void @_ZN4sycl3_V17handler30verifyUsedKernelBundleInternalENS0_6detail11string_viewE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr nonnull @.str.30)
  call void @_ZN4sycl3_V16detail15checkValueRangeILi1ENS0_5rangeILi1EEEEENSt9enable_ifIXoosr3stdE9is_same_vIT0_NS3_IXT_EEEEsr3stdE9is_same_vIS6_NS0_2idIXT_EEEEEvE4typeERKS6_(ptr noundef nonnull align 8 dereferenceable(8) %UserRange.i.i.i.i)
  %agg.tmp30.sroa.0.0.copyload.i.i.i.i = load i64, ptr %UserRange.i.i.i.i, align 8
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %agg.tmp.i52.i.i.i.i)
  %common_array.i.i.i.i53.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i52.i.i.i.i, i64 0, i32 0, !intel-tbaa !156
  %18 = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i52.i.i.i.i, i64 0, i32 0, i64 1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %18, i8 0, i64 16, i1 false), !alias.scope !249
  store i64 %agg.tmp30.sroa.0.0.copyload.i.i.i.i, ptr %common_array.i.i.i.i53.i.i.i.i, align 8, !tbaa !162, !alias.scope !249
  call void @_ZN4sycl3_V17handler26setNDRangeDescriptorPaddedENS0_5rangeILi3EEEbi(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef nonnull byval(%"class.sycl::_V1::range.69") align 8 %agg.tmp.i52.i.i.i.i, i1 noundef zeroext false, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %agg.tmp.i52.i.i.i.i)
  %call.i.i55.i.i.i.i = call noalias noundef nonnull dereferenceable(16) ptr @_Znwm(i64 noundef 16) #41, !noalias !252
  store ptr getelementptr inbounds inrange(-16, 32) ({ [6 x ptr] }, ptr @_ZTVN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, i64 0, i32 0, i64 2), ptr %call.i.i55.i.i.i.i, align 8, !tbaa !39, !noalias !252
  %MKernel.i.i.i56.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.118", ptr %call.i.i55.i.i.i.i, i64 0, i32 1, !intel-tbaa !255
  store ptr %object.val.val, ptr %MKernel.i.i.i56.i.i.i.i, align 8, !tbaa !97, !noalias !252
  %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 10
  %19 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  store ptr %call.i.i55.i.i.i.i, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  %tobool.not.i.i.i.i60.i.i.i.i = icmp eq ptr %19, null
  br i1 %tobool.not.i.i.i.i60.i.i.i.i, label %invoke.cont.i64.i.i.i.i, label %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i

_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i: ; preds = %if.else.i.i.i.i
  %vtable.i.i.i.i.i62.i.i.i.i = load ptr, ptr %19, align 8, !tbaa !39
  %vfn.i.i.i.i.i63.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i62.i.i.i.i, i64 2
  %20 = load ptr, ptr %vfn.i.i.i.i.i63.i.i.i.i, align 8
  call void %20(ptr noundef nonnull align 8 dereferenceable(8) %19) #37
  br label %invoke.cont.i64.i.i.i.i

invoke.cont.i64.i.i.i.i:                          ; preds = %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i, %if.else.i.i.i.i
  call void @_ZN4sycl3_V17handler9clearArgsEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %21 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  %vtable.i65.i.i.i.i = load ptr, ptr %21, align 8, !tbaa !39
  %22 = load ptr, ptr %vtable.i65.i.i.i.i, align 8
  %call4.i66.i.i.i.i = call noundef ptr %22(ptr noundef nonnull align 8 dereferenceable(8) %21)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  call void @llvm.experimental.noalias.scope.decl(metadata !257)
  %_M_end_of_storage.i.i.i.i69.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i54.i.i.i.i, i64 0, i32 0, i32 0, i32 2
  %_M_finish.i.i.i.i70.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i54.i.i.i.i, i64 0, i32 0, i32 0, i32 1
  %call5.i.i.i.i13.i.i71.i.i.i.i = call noalias noundef nonnull dereferenceable(12) ptr @_Znwm(i64 noundef 12) #41, !noalias !257
  store ptr %call5.i.i.i.i13.i.i71.i.i.i.i, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180, !alias.scope !257
  %add.ptr21.i.i.i72.i.i.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i71.i.i.i.i, i64 1, !intel-tbaa !177
  store ptr %add.ptr21.i.i.i72.i.i.i.i, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183, !alias.scope !257
  store i64 34359738371, ptr %call5.i.i.i.i13.i.i71.i.i.i.i, align 4
  %ref.tmp.i.sroa.6.0..sroa_idx.i73.i.i.i.i = getelementptr inbounds nuw i32, ptr %call5.i.i.i.i13.i.i71.i.i.i.i, i64 2
  store i32 0, ptr %ref.tmp.i.sroa.6.0..sroa_idx.i73.i.i.i.i, align 4, !tbaa !9
  store ptr %add.ptr21.i.i.i72.i.i.i.i, ptr %_M_finish.i.i.i.i70.i.i.i.i, align 8, !tbaa !229
  invoke void @_ZN4sycl3_V17handler28extractArgsAndReqsFromLambdaEPcRKSt6vectorINS0_6detail19kernel_param_desc_tESaIS5_EEb(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef %call4.i66.i.i.i.i, ptr noundef nonnull align 8 dereferenceable(24) %ref.tmp5.i54.i.i.i.i, i1 noundef zeroext false)
          to label %invoke.cont7.i76.i.i.i.i unwind label %lpad.i75.i.i.i.i

invoke.cont7.i76.i.i.i.i:                         ; preds = %invoke.cont.i64.i.i.i.i
  %23 = load ptr, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i16.i.i.i.i.i = icmp eq ptr %23, null
  br i1 %tobool.not.i.i.i16.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i, label %if.then.i.i.i.i77.i.i.i.i

if.then.i.i.i.i77.i.i.i.i:                        ; preds = %invoke.cont7.i76.i.i.i.i
  %24 = load ptr, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i.i78.i.i.i.i = ptrtoint ptr %24 to i64
  %sub.ptr.rhs.cast.i.i.i79.i.i.i.i = ptrtoint ptr %23 to i64
  %sub.ptr.sub.i.i.i80.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i.i78.i.i.i.i, %sub.ptr.rhs.cast.i.i.i79.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %23, i64 noundef %sub.ptr.sub.i.i.i80.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i: ; preds = %if.then.i.i.i.i77.i.i.i.i, %invoke.cont7.i76.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  %call2.i.i.i82.i.i.i.i = call noalias noundef nonnull dereferenceable(65) ptr @_Znam(i64 noundef 65) #41
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(64) %call2.i.i.i82.i.i.i.i, ptr noundef nonnull align 1 dereferenceable(64) @.str.30, i64 64, i1 false)
  %arrayidx.i.i.i83.i.i.i.i = getelementptr inbounds nuw i8, ptr %call2.i.i.i82.i.i.i.i, i64 64
  store i8 0, ptr %arrayidx.i.i.i83.i.i.i.i, align 1, !tbaa !41
  %str.i.i.i.i84.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 4, i32 0, !intel-tbaa !184
  %25 = load ptr, ptr %str.i.i.i.i84.i.i.i.i, align 8, !tbaa !217
  store ptr %call2.i.i.i82.i.i.i.i, ptr %str.i.i.i.i84.i.i.i.i, align 8, !tbaa !217
  %isnull.i.i.i85.i.i.i.i = icmp eq ptr %25, null
  br i1 %isnull.i.i.i85.i.i.i.i, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_.exit, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_.exit.sink.split

lpad.i75.i.i.i.i:                                 ; preds = %invoke.cont.i64.i.i.i.i
  %26 = landingpad { ptr, i32 }
          cleanup
  %27 = load ptr, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i19.i.i.i.i.i = icmp eq ptr %27, null
  br i1 %tobool.not.i.i.i19.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i, label %if.then.i.i.i20.i.i.i.i.i

if.then.i.i.i20.i.i.i.i.i:                        ; preds = %lpad.i75.i.i.i.i
  %28 = load ptr, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i22.i.i.i.i.i = ptrtoint ptr %28 to i64
  %sub.ptr.rhs.cast.i.i23.i.i.i.i.i = ptrtoint ptr %27 to i64
  %sub.ptr.sub.i.i24.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i22.i.i.i.i.i, %sub.ptr.rhs.cast.i.i23.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %27, i64 noundef %sub.ptr.sub.i.i24.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i: ; preds = %if.then.i.i.i20.i.i.i.i.i, %lpad.i75.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  br label %common.resume.i.i.i.i

_ZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_.exit.sink.split: ; preds = %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i
  %.sink = phi ptr [ %14, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i ], [ %25, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i ]
  call void @_ZdaPv(ptr noundef nonnull %.sink) #39
  br label %_ZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_.exit

_ZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_.exit:  ; preds = %_ZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_.exit.sink.split, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i81.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i
  call void @_ZN4sycl3_V17handler7setTypeENS0_6detail6CGTypeE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %0) #37
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %UserRange.i.i.i.i)
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define internal noundef nonnull ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE6getPtrEv(ptr noundef nonnull readnone align 8 captures(ret: address, provenance) dereferenceable(24) %this) unnamed_addr #28 align 2 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.107", ptr %this, i64 0, i32 1, !intel-tbaa !242
  ret ptr %MKernel
}

; Function Attrs: mustprogress nounwind uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EED0Ev(ptr noundef nonnull align 8 dereferenceable(24) %this) unnamed_addr #29 align 2 {
entry:
  tail call void @_ZdlPvm(ptr noundef nonnull %this, i64 noundef 24) #39
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE23InstantiateKernelOnHostEv(ptr noundef nonnull readonly align 8 captures(none) dereferenceable(24) %this) unnamed_addr #33 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.107", ptr %this, i64 0, i32 1, !intel-tbaa !242
  %agg.tmp.sroa.0.0.copyload = load i64, ptr %MKernel, align 8
  %agg.tmp.sroa.2.0.MKernel.sroa_idx = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.107", ptr %this, i64 0, i32 1, i32 1
  %agg.tmp.sroa.2.0.copyload = load ptr, ptr %agg.tmp.sroa.2.0.MKernel.sroa_idx, align 8
  %cmp6.not.i.not.i.i.not = icmp eq i64 %agg.tmp.sroa.0.0.copyload, 0
  br i1 %cmp6.not.i.not.i.i.not, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %for.body.i.i.preheader

for.body.i.i.preheader:                           ; preds = %entry
  %xtraiter = and i64 %agg.tmp.sroa.0.0.copyload, 3
  %0 = icmp ult i64 %agg.tmp.sroa.0.0.copyload, 4
  br i1 %0, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, label %for.body.i.i.preheader.new

for.body.i.i.preheader.new:                       ; preds = %for.body.i.i.preheader
  %unroll_iter = and i64 %agg.tmp.sroa.0.0.copyload, -4
  br label %for.body.i.i

for.body.i.i:                                     ; preds = %for.body.i.i, %for.body.i.i.preheader.new
  %niter = phi i64 [ 0, %for.body.i.i.preheader.new ], [ %niter.next.3, %for.body.i.i ]
  fence seq_cst
  %1 = load i32, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  %add.i.i.i.i = add nsw i32 %1, 1
  store i32 %add.i.i.i.i, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  fence seq_cst
  %2 = load i32, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  %add.i.i.i.i.1 = add nsw i32 %2, 1
  store i32 %add.i.i.i.i.1, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  fence seq_cst
  %3 = load i32, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  %add.i.i.i.i.2 = add nsw i32 %3, 1
  store i32 %add.i.i.i.i.2, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  fence seq_cst
  %4 = load i32, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  %add.i.i.i.i.3 = add nsw i32 %4, 1
  store i32 %add.i.i.i.i.3, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  fence seq_cst
  %niter.next.3 = add i64 %niter, 4
  %niter.ncmp.3 = icmp eq i64 %niter.next.3, %unroll_iter
  br i1 %niter.ncmp.3, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, label %for.body.i.i, !llvm.loop !260

_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa: ; preds = %for.body.i.i, %for.body.i.i.preheader
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %for.body.i.i.epil

for.body.i.i.epil:                                ; preds = %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, %for.body.i.i.epil
  %epil.iter = phi i64 [ %epil.iter.next, %for.body.i.i.epil ], [ 0, %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa ]
  fence seq_cst
  %5 = load i32, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  %add.i.i.i.i.epil = add nsw i32 %5, 1
  store i32 %add.i.i.i.i.epil, ptr %agg.tmp.sroa.2.0.copyload, align 4, !tbaa !9
  fence seq_cst
  %epil.iter.next = add i64 %epil.iter, 1
  %epil.iter.cmp.not = icmp eq i64 %epil.iter.next, %xtraiter
  br i1 %epil.iter.cmp.not, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %for.body.i.i.epil, !llvm.loop !261

_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit: ; preds = %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, %for.body.i.i.epil, %entry
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define internal noundef nonnull ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE6getPtrEv(ptr noundef nonnull readnone align 8 captures(ret: address, provenance) dereferenceable(16) %this) unnamed_addr #28 align 2 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.118", ptr %this, i64 0, i32 1, !intel-tbaa !255
  ret ptr %MKernel
}

; Function Attrs: mustprogress nounwind uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EED0Ev(ptr noundef nonnull align 8 dereferenceable(16) %this) unnamed_addr #29 align 2 {
entry:
  tail call void @_ZdlPvm(ptr noundef nonnull %this, i64 noundef 16) #39
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind willreturn uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE23InstantiateKernelOnHostEv(ptr noundef nonnull readonly align 8 captures(none) dereferenceable(16) %this) unnamed_addr #5 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.118", ptr %this, i64 0, i32 1, !intel-tbaa !255
  %agg.tmp.sroa.0.0.copyload = load ptr, ptr %MKernel, align 8, !tbaa !97
  fence seq_cst
  %0 = load i32, ptr %agg.tmp.sroa.0.0.copyload, align 4, !tbaa !9
  %add.i.i.i = add nsw i32 %0, 1
  store i32 %add.i.i.i, ptr %agg.tmp.sroa.0.0.copyload, align 4, !tbaa !9
  fence seq_cst
  ret void
}

; Function Attrs: mustprogress uwtable
define internal void @_ZN4sycl3_V16detail19type_erased_cgfo_ty7invokerIZ4mainEUlRNS0_7handlerEE1_E4callEPKvS5_(ptr noundef readonly captures(none) %object, ptr noundef nonnull align 8 dereferenceable(216) %cgh) #23 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %ref.tmp5.i54.i.i.i.i = alloca %"class.std::vector.79", align 8
  %agg.tmp.i52.i.i.i.i = alloca %"class.sycl::_V1::range.69", align 8
  %ref.tmp5.i.i.i.i.i = alloca %"class.std::vector.79", align 8
  %agg.tmp.i.i.i.i.i = alloca %"class.sycl::_V1::range.69", align 8
  %UserRange.i.i.i.i = alloca %"class.sycl::_V1::range", align 8
  %0 = alloca %"class.std::tuple.61", align 8
  %object.val = load ptr, ptr %object, align 8, !tbaa !262
  %object.val.val = load ptr, ptr %object.val, align 8, !tbaa !97
  call void @llvm.lifetime.start.p0(i64 8, ptr nonnull %UserRange.i.i.i.i)
  %coerce.dive1.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::range", ptr %UserRange.i.i.i.i, i64 0, i32 0, i32 0
  store i64 1024, ptr %coerce.dive1.i.i.i.i, align 8
  %call.i.i.i.i.i = tail call noundef i32 @_ZNK4sycl3_V17handler7getTypeEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %cmp.not.i.i.i.i.i = icmp eq i32 %call.i.i.i.i.i, 0
  br i1 %cmp.not.i.i.i.i.i, label %if.end.i.i.i.i, label %if.then.i.i.i.i.i

if.then.i.i.i.i.i:                                ; preds = %entry
  %exception.i.i.i.i.i = tail call ptr @__cxa_allocate_exception(i64 64) #37
  %call2.i.i.i.i.i = tail call { i32, ptr } @_ZN4sycl3_V115make_error_codeENS0_4errcE(i32 noundef 1) #37
  %1 = extractvalue { i32, ptr } %call2.i.i.i.i.i, 0
  %2 = extractvalue { i32, ptr } %call2.i.i.i.i.i, 1
  invoke void @_ZN4sycl3_V19exceptionC1ESt10error_codePKc(ptr noundef nonnull align 8 dereferenceable(64) %exception.i.i.i.i.i, i32 %1, ptr %2, ptr noundef nonnull @.str.16)
          to label %invoke.cont.i.i.i.i.i unwind label %lpad.i.i.i.i.i

invoke.cont.i.i.i.i.i:                            ; preds = %if.then.i.i.i.i.i
  tail call void @__cxa_throw(ptr nonnull %exception.i.i.i.i.i, ptr nonnull @_ZTIN4sycl3_V19exceptionE, ptr nonnull @_ZN4sycl3_V19exceptionD1Ev) #40
  unreachable

common.resume.i.i.i.i:                            ; preds = %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i, %lpad.i.i.i.i.i
  %common.resume.op.i.i.i.i = phi { ptr, i32 } [ %3, %lpad.i.i.i.i.i ], [ %26, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i ], [ %15, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i ]
  resume { ptr, i32 } %common.resume.op.i.i.i.i

lpad.i.i.i.i.i:                                   ; preds = %if.then.i.i.i.i.i
  %3 = landingpad { ptr, i32 }
          cleanup
  tail call void @__cxa_free_exception(ptr nonnull %exception.i.i.i.i.i) #37
  br label %common.resume.i.i.i.i

if.end.i.i.i.i:                                   ; preds = %entry
  call void @llvm.lifetime.start.p0(i64 16, ptr nonnull %0) #37
  call void @_ZN4sycl3_V17handler15getRoundedRangeILi1EEESt5tupleIJNS0_5rangeIXT_EEEbEES5_(ptr dead_on_unwind nonnull writable sret(%"class.std::tuple.61") align 8 %0, ptr noundef nonnull align 8 dereferenceable(216) %cgh, i64 1024)
  %_M_head_impl.i.i.i.i44.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Head_base.64", ptr %0, i64 0, i32 0, !intel-tbaa !149
  %4 = load i8, ptr %_M_head_impl.i.i.i.i44.i.i.i.i, align 8, !tbaa !149, !range !142, !noundef !143
  %loadedv.not.i.i.i.i = icmp eq i8 %4, 0
  br i1 %loadedv.not.i.i.i.i, label %if.else.i.i.i.i, label %if.then10.i.i.i.i

if.then10.i.i.i.i:                                ; preds = %if.end.i.i.i.i
  %_M_head_impl.i.i.i.i.i.i.i.i = getelementptr inbounds nuw i64, ptr %0, i64 1
  %agg.tmp12.sroa.0.0.copyload.i.i.i.i = load i64, ptr %UserRange.i.i.i.i, align 8
  call void @_ZN4sycl3_V17handler30verifyUsedKernelBundleInternalENS0_6detail11string_viewE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr nonnull @.str.32)
  call void @_ZN4sycl3_V16detail15checkValueRangeILi1ENS0_5rangeILi1EEEEENSt9enable_ifIXoosr3stdE9is_same_vIT0_NS3_IXT_EEEEsr3stdE9is_same_vIS6_NS0_2idIXT_EEEEEvE4typeERKS6_(ptr noundef nonnull align 8 dereferenceable(8) %UserRange.i.i.i.i)
  %agg.tmp21.sroa.0.0.copyload.i.i.i.i = load i64, ptr %_M_head_impl.i.i.i.i.i.i.i.i, align 8, !tbaa !151
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %agg.tmp.i.i.i.i.i)
  %common_array.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i.i.i.i.i, i64 0, i32 0, !intel-tbaa !156
  %5 = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i.i.i.i.i, i64 0, i32 0, i64 1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %5, i8 0, i64 16, i1 false), !alias.scope !264
  store i64 %agg.tmp21.sroa.0.0.copyload.i.i.i.i, ptr %common_array.i.i.i.i.i.i.i.i, align 8, !tbaa !162, !alias.scope !264
  call void @_ZN4sycl3_V17handler26setNDRangeDescriptorPaddedENS0_5rangeILi3EEEbi(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef nonnull byval(%"class.sycl::_V1::range.69") align 8 %agg.tmp.i.i.i.i.i, i1 noundef zeroext false, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %agg.tmp.i.i.i.i.i)
  %call.i.i45.i.i.i.i = call noalias noundef nonnull dereferenceable(24) ptr @_Znwm(i64 noundef 24) #41, !noalias !267
  store ptr getelementptr inbounds inrange(-16, 32) ({ [6 x ptr] }, ptr @_ZTVN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE, i64 0, i32 0, i64 2), ptr %call.i.i45.i.i.i.i, align 8, !tbaa !39, !noalias !267
  %MKernel.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.130", ptr %call.i.i45.i.i.i.i, i64 0, i32 1, !intel-tbaa !270
  store i64 %agg.tmp12.sroa.0.0.copyload.i.i.i.i, ptr %MKernel.i.i.i.i.i.i.i, align 8, !noalias !267
  %Kernel.sroa.2.0.MKernel.sroa_idx.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.130", ptr %call.i.i45.i.i.i.i, i64 0, i32 1, i32 1
  store ptr %object.val.val, ptr %Kernel.sroa.2.0.MKernel.sroa_idx.i.i.i.i.i.i.i, align 8, !noalias !267
  %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 10
  %6 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  store ptr %call.i.i45.i.i.i.i, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  %tobool.not.i.i.i.i.i.i.i.i = icmp eq ptr %6, null
  br i1 %tobool.not.i.i.i.i.i.i.i.i, label %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE1_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i, label %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i

_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i: ; preds = %if.then10.i.i.i.i
  %vtable.i.i.i.i.i.i.i.i.i = load ptr, ptr %6, align 8, !tbaa !39
  %vfn.i.i.i.i.i.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i.i.i.i.i, i64 2
  %7 = load ptr, ptr %vfn.i.i.i.i.i.i.i.i.i, align 8
  call void %7(ptr noundef nonnull align 8 dereferenceable(8) %6) #37
  br label %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE1_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i

_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE1_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i: ; preds = %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i.i.i.i.i, %if.then10.i.i.i.i
  call void @_ZN4sycl3_V17handler9clearArgsEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %8 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i.i.i.i.i, align 8, !tbaa !171
  %vtable.i.i.i.i.i = load ptr, ptr %8, align 8, !tbaa !39
  %9 = load ptr, ptr %vtable.i.i.i.i.i, align 8
  %call4.i.i.i.i.i = call noundef ptr %9(ptr noundef nonnull align 8 dereferenceable(8) %8)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  %_M_end_of_storage.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i.i.i.i.i, i64 0, i32 0, i32 0, i32 2
  %_M_finish.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i.i.i.i.i, i64 0, i32 0, i32 0, i32 1
  %call5.i.i.i.i13.i.i.i.i.i.i = call noalias noundef nonnull dereferenceable(24) ptr @_Znwm(i64 noundef 24) #41, !noalias !274
  %add.ptr21.i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 2, !intel-tbaa !177
  store i64 34359738369, ptr %call5.i.i.i.i13.i.i.i.i.i.i, align 4
  %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i = getelementptr inbounds nuw i32, ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 2
  store i32 0, ptr %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i, align 4, !tbaa !9
  %10 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 1
  store i64 34359738369, ptr %10, align 4
  %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i.1 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i.i.i.i.i, i64 1, i32 2
  store i32 8, ptr %ref.tmp.i.sroa.6.0..sroa_idx.i.i.i.i.i.1, align 4, !tbaa !9
  %11 = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %10, i64 1
  store ptr %11, ptr %_M_finish.i.i.i.i.i.i.i.i, align 8
  store ptr %add.ptr21.i.i.i.i.i.i.i, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8
  store ptr %call5.i.i.i.i13.i.i.i.i.i.i, ptr %ref.tmp5.i.i.i.i.i, align 8
  invoke void @_ZN4sycl3_V17handler28extractArgsAndReqsFromLambdaEPcRKSt6vectorINS0_6detail19kernel_param_desc_tESaIS5_EEb(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef %call4.i.i.i.i.i, ptr noundef nonnull align 8 dereferenceable(24) %ref.tmp5.i.i.i.i.i, i1 noundef zeroext false)
          to label %invoke.cont7.i.i.i.i.i unwind label %lpad.i47.i.i.i.i

invoke.cont7.i.i.i.i.i:                           ; preds = %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE1_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i
  %12 = load ptr, ptr %ref.tmp5.i.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i17.i.i.i.i.i = icmp eq ptr %12, null
  br i1 %tobool.not.i.i.i17.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i, label %if.then.i.i.i.i.i.i.i.i

if.then.i.i.i.i.i.i.i.i:                          ; preds = %invoke.cont7.i.i.i.i.i
  %13 = load ptr, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i.i.i.i.i.i = ptrtoint ptr %13 to i64
  %sub.ptr.rhs.cast.i.i.i.i.i.i.i = ptrtoint ptr %12 to i64
  %sub.ptr.sub.i.i.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i.i.i.i.i.i, %sub.ptr.rhs.cast.i.i.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %12, i64 noundef %sub.ptr.sub.i.i.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i: ; preds = %if.then.i.i.i.i.i.i.i.i, %invoke.cont7.i.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  %call2.i.i.i.i.i.i.i = call noalias noundef nonnull dereferenceable(123) ptr @_Znam(i64 noundef 123) #41
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(122) %call2.i.i.i.i.i.i.i, ptr noundef nonnull align 1 dereferenceable(122) @.str.33, i64 122, i1 false)
  %arrayidx.i.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %call2.i.i.i.i.i.i.i, i64 122
  store i8 0, ptr %arrayidx.i.i.i.i.i.i.i, align 1, !tbaa !41
  %str.i.i.i.i.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 4, i32 0, !intel-tbaa !184
  %14 = load ptr, ptr %str.i.i.i.i.i.i.i.i, align 8, !tbaa !217
  store ptr %call2.i.i.i.i.i.i.i, ptr %str.i.i.i.i.i.i.i.i, align 8, !tbaa !217
  %isnull.i.i.i.i.i.i.i = icmp eq ptr %14, null
  br i1 %isnull.i.i.i.i.i.i.i, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_.exit, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_.exit.sink.split

lpad.i47.i.i.i.i:                                 ; preds = %_ZNSt10unique_ptrIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE1_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEESt14default_deleteISE_EED2Ev.exit.i.i.i.i.i
  %15 = landingpad { ptr, i32 }
          cleanup
  %16 = load ptr, ptr %ref.tmp5.i.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i20.i.i.i.i.i = icmp eq ptr %16, null
  br i1 %tobool.not.i.i.i20.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i, label %if.then.i.i.i21.i.i.i.i.i

if.then.i.i.i21.i.i.i.i.i:                        ; preds = %lpad.i47.i.i.i.i
  %17 = load ptr, ptr %_M_end_of_storage.i.i.i.i.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i23.i.i.i.i.i = ptrtoint ptr %17 to i64
  %sub.ptr.rhs.cast.i.i24.i.i.i.i.i = ptrtoint ptr %16 to i64
  %sub.ptr.sub.i.i25.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i23.i.i.i.i.i, %sub.ptr.rhs.cast.i.i24.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %16, i64 noundef %sub.ptr.sub.i.i25.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit26.i.i.i.i.i: ; preds = %if.then.i.i.i21.i.i.i.i.i, %lpad.i47.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i.i.i.i.i) #37
  br label %common.resume.i.i.i.i

if.else.i.i.i.i:                                  ; preds = %if.end.i.i.i.i
  call void @_ZN4sycl3_V17handler30verifyUsedKernelBundleInternalENS0_6detail11string_viewE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr nonnull @.str.32)
  call void @_ZN4sycl3_V16detail15checkValueRangeILi1ENS0_5rangeILi1EEEEENSt9enable_ifIXoosr3stdE9is_same_vIT0_NS3_IXT_EEEEsr3stdE9is_same_vIS6_NS0_2idIXT_EEEEEvE4typeERKS6_(ptr noundef nonnull align 8 dereferenceable(8) %UserRange.i.i.i.i)
  %agg.tmp30.sroa.0.0.copyload.i.i.i.i = load i64, ptr %UserRange.i.i.i.i, align 8
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %agg.tmp.i52.i.i.i.i)
  %common_array.i.i.i.i53.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i52.i.i.i.i, i64 0, i32 0, !intel-tbaa !156
  %18 = getelementptr inbounds nuw %"class.sycl::_V1::detail::array.70", ptr %agg.tmp.i52.i.i.i.i, i64 0, i32 0, i64 1
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %18, i8 0, i64 16, i1 false), !alias.scope !277
  store i64 %agg.tmp30.sroa.0.0.copyload.i.i.i.i, ptr %common_array.i.i.i.i53.i.i.i.i, align 8, !tbaa !162, !alias.scope !277
  call void @_ZN4sycl3_V17handler26setNDRangeDescriptorPaddedENS0_5rangeILi3EEEbi(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef nonnull byval(%"class.sycl::_V1::range.69") align 8 %agg.tmp.i52.i.i.i.i, i1 noundef zeroext false, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %agg.tmp.i52.i.i.i.i)
  %call.i.i55.i.i.i.i = call noalias noundef nonnull dereferenceable(16) ptr @_Znwm(i64 noundef 16) #41, !noalias !280
  store ptr getelementptr inbounds inrange(-16, 32) ({ [6 x ptr] }, ptr @_ZTVN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE, i64 0, i32 0, i64 2), ptr %call.i.i55.i.i.i.i, align 8, !tbaa !39, !noalias !280
  %MKernel.i.i.i56.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.141", ptr %call.i.i55.i.i.i.i, i64 0, i32 1, !intel-tbaa !283
  store ptr %object.val.val, ptr %MKernel.i.i.i56.i.i.i.i, align 8, !tbaa !97, !noalias !280
  %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 10
  %19 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  store ptr %call.i.i55.i.i.i.i, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  %tobool.not.i.i.i.i60.i.i.i.i = icmp eq ptr %19, null
  br i1 %tobool.not.i.i.i.i60.i.i.i.i, label %invoke.cont.i64.i.i.i.i, label %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i

_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i: ; preds = %if.else.i.i.i.i
  %vtable.i.i.i.i.i62.i.i.i.i = load ptr, ptr %19, align 8, !tbaa !39
  %vfn.i.i.i.i.i63.i.i.i.i = getelementptr inbounds nuw ptr, ptr %vtable.i.i.i.i.i62.i.i.i.i, i64 2
  %20 = load ptr, ptr %vfn.i.i.i.i.i63.i.i.i.i, align 8
  call void %20(ptr noundef nonnull align 8 dereferenceable(8) %19) #37
  br label %invoke.cont.i64.i.i.i.i

invoke.cont.i64.i.i.i.i:                          ; preds = %_ZNKSt14default_deleteIN4sycl3_V16detail14HostKernelBaseEEclEPS3_.exit.i.i.i.i61.i.i.i.i, %if.else.i.i.i.i
  call void @_ZN4sycl3_V17handler9clearArgsEv(ptr noundef nonnull align 8 dereferenceable(216) %cgh)
  %21 = load ptr, ptr %_M_head_impl.i.i.i.i.i.i.i7.i.i59.i.i.i.i, align 8, !tbaa !171
  %vtable.i65.i.i.i.i = load ptr, ptr %21, align 8, !tbaa !39
  %22 = load ptr, ptr %vtable.i65.i.i.i.i, align 8
  %call4.i66.i.i.i.i = call noundef ptr %22(ptr noundef nonnull align 8 dereferenceable(8) %21)
  call void @llvm.lifetime.start.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  call void @llvm.experimental.noalias.scope.decl(metadata !285)
  %_M_end_of_storage.i.i.i.i69.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i54.i.i.i.i, i64 0, i32 0, i32 0, i32 2
  %call5.i.i.i.i13.i.i70.i.i.i.i = call noalias noundef nonnull dereferenceable(12) ptr @_Znwm(i64 noundef 12) #41, !noalias !285
  store ptr %call5.i.i.i.i13.i.i70.i.i.i.i, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180, !alias.scope !285
  %add.ptr21.i.i.i71.i.i.i.i = getelementptr inbounds nuw %"struct.sycl::_V1::detail::kernel_param_desc_t", ptr %call5.i.i.i.i13.i.i70.i.i.i.i, i64 1, !intel-tbaa !177
  store ptr %add.ptr21.i.i.i71.i.i.i.i, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183, !alias.scope !285
  %_M_finish.i.i15.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::_Vector_base.80", ptr %ref.tmp5.i54.i.i.i.i, i64 0, i32 0, i32 0, i32 1
  store i64 34359738371, ptr %call5.i.i.i.i13.i.i70.i.i.i.i, align 4, !noalias !285
  %ref.tmp.sroa.6.0..sroa_idx.i.i.i.i.i.i = getelementptr inbounds nuw i32, ptr %call5.i.i.i.i13.i.i70.i.i.i.i, i64 2
  store i32 0, ptr %ref.tmp.sroa.6.0..sroa_idx.i.i.i.i.i.i, align 4, !tbaa !9, !noalias !285
  store ptr %add.ptr21.i.i.i71.i.i.i.i, ptr %_M_finish.i.i15.i.i.i.i.i.i, align 8, !tbaa !229, !alias.scope !285
  invoke void @_ZN4sycl3_V17handler28extractArgsAndReqsFromLambdaEPcRKSt6vectorINS0_6detail19kernel_param_desc_tESaIS5_EEb(ptr noundef nonnull align 8 dereferenceable(216) %cgh, ptr noundef %call4.i66.i.i.i.i, ptr noundef nonnull align 8 dereferenceable(24) %ref.tmp5.i54.i.i.i.i, i1 noundef zeroext false)
          to label %invoke.cont7.i73.i.i.i.i unwind label %lpad.i72.i.i.i.i

invoke.cont7.i73.i.i.i.i:                         ; preds = %invoke.cont.i64.i.i.i.i
  %23 = load ptr, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i16.i.i.i.i.i = icmp eq ptr %23, null
  br i1 %tobool.not.i.i.i16.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i78.i.i.i.i, label %if.then.i.i.i.i74.i.i.i.i

if.then.i.i.i.i74.i.i.i.i:                        ; preds = %invoke.cont7.i73.i.i.i.i
  %24 = load ptr, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i.i75.i.i.i.i = ptrtoint ptr %24 to i64
  %sub.ptr.rhs.cast.i.i.i76.i.i.i.i = ptrtoint ptr %23 to i64
  %sub.ptr.sub.i.i.i77.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i.i75.i.i.i.i, %sub.ptr.rhs.cast.i.i.i76.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %23, i64 noundef %sub.ptr.sub.i.i.i77.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i78.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i78.i.i.i.i: ; preds = %if.then.i.i.i.i74.i.i.i.i, %invoke.cont7.i73.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  %call2.i.i.i79.i.i.i.i = call noalias noundef nonnull dereferenceable(65) ptr @_Znam(i64 noundef 65) #41
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 1 dereferenceable(64) %call2.i.i.i79.i.i.i.i, ptr noundef nonnull align 1 dereferenceable(64) @.str.32, i64 64, i1 false)
  %arrayidx.i.i.i80.i.i.i.i = getelementptr inbounds nuw i8, ptr %call2.i.i.i79.i.i.i.i, i64 64
  store i8 0, ptr %arrayidx.i.i.i80.i.i.i.i, align 1, !tbaa !41
  %str.i.i.i.i81.i.i.i.i = getelementptr inbounds nuw %"class.sycl::_V1::handler", ptr %cgh, i64 0, i32 4, i32 0, !intel-tbaa !184
  %25 = load ptr, ptr %str.i.i.i.i81.i.i.i.i, align 8, !tbaa !217
  store ptr %call2.i.i.i79.i.i.i.i, ptr %str.i.i.i.i81.i.i.i.i, align 8, !tbaa !217
  %isnull.i.i.i82.i.i.i.i = icmp eq ptr %25, null
  br i1 %isnull.i.i.i82.i.i.i.i, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_.exit, label %_ZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_.exit.sink.split

lpad.i72.i.i.i.i:                                 ; preds = %invoke.cont.i64.i.i.i.i
  %26 = landingpad { ptr, i32 }
          cleanup
  %27 = load ptr, ptr %ref.tmp5.i54.i.i.i.i, align 8, !tbaa !180
  %tobool.not.i.i.i19.i.i.i.i.i = icmp eq ptr %27, null
  br i1 %tobool.not.i.i.i19.i.i.i.i.i, label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i, label %if.then.i.i.i20.i.i.i.i.i

if.then.i.i.i20.i.i.i.i.i:                        ; preds = %lpad.i72.i.i.i.i
  %28 = load ptr, ptr %_M_end_of_storage.i.i.i.i69.i.i.i.i, align 8, !tbaa !183
  %sub.ptr.lhs.cast.i.i22.i.i.i.i.i = ptrtoint ptr %28 to i64
  %sub.ptr.rhs.cast.i.i23.i.i.i.i.i = ptrtoint ptr %27 to i64
  %sub.ptr.sub.i.i24.i.i.i.i.i = sub i64 %sub.ptr.lhs.cast.i.i22.i.i.i.i.i, %sub.ptr.rhs.cast.i.i23.i.i.i.i.i
  call void @_ZdlPvm(ptr noundef nonnull %27, i64 noundef %sub.ptr.sub.i.i24.i.i.i.i.i) #39
  br label %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i

_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit25.i.i.i.i.i: ; preds = %if.then.i.i.i20.i.i.i.i.i, %lpad.i72.i.i.i.i
  call void @llvm.lifetime.end.p0(i64 24, ptr nonnull %ref.tmp5.i54.i.i.i.i) #37
  br label %common.resume.i.i.i.i

_ZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_.exit.sink.split: ; preds = %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i78.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i
  %.sink = phi ptr [ %14, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i ], [ %25, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i78.i.i.i.i ]
  call void @_ZdaPv(ptr noundef nonnull %.sink) #39
  br label %_ZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_.exit

_ZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_.exit:  ; preds = %_ZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_.exit.sink.split, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i78.i.i.i.i, %_ZNSt6vectorIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EED2Ev.exit.i.i.i.i.i
  call void @_ZN4sycl3_V17handler7setTypeENS0_6detail6CGTypeE(ptr noundef nonnull align 8 dereferenceable(216) %cgh, i32 noundef 1)
  call void @llvm.lifetime.end.p0(i64 16, ptr nonnull %0) #37
  call void @llvm.lifetime.end.p0(i64 8, ptr nonnull %UserRange.i.i.i.i)
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define internal noundef nonnull ptr @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE6getPtrEv(ptr noundef nonnull readnone align 8 captures(ret: address, provenance) dereferenceable(24) %this) unnamed_addr #28 align 2 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.130", ptr %this, i64 0, i32 1, !intel-tbaa !270
  ret ptr %MKernel
}

; Function Attrs: mustprogress nounwind uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EED0Ev(ptr noundef nonnull align 8 dereferenceable(24) %this) unnamed_addr #29 align 2 {
entry:
  tail call void @_ZdlPvm(ptr noundef nonnull %this, i64 noundef 24) #39
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind memory(readwrite, inaccessiblemem: none) uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EE23InstantiateKernelOnHostEv(ptr noundef nonnull readonly align 8 captures(none) dereferenceable(24) %this) unnamed_addr #30 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.130", ptr %this, i64 0, i32 1, !intel-tbaa !270
  %agg.tmp.sroa.0.0.copyload = load i64, ptr %MKernel, align 8
  %cmp6.not.i.not.i.i.not = icmp eq i64 %agg.tmp.sroa.0.0.copyload, 0
  br i1 %cmp6.not.i.not.i.i.not, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %for.body.i.preheader.i

for.body.i.preheader.i:                           ; preds = %entry
  %agg.tmp.sroa.2.0.MKernel.sroa_idx = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.130", ptr %this, i64 0, i32 1, i32 1
  %agg.tmp.sroa.2.0.copyload = load ptr, ptr %agg.tmp.sroa.2.0.MKernel.sroa_idx, align 8
  %_M_i.i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::__atomic_base", ptr %agg.tmp.sroa.2.0.copyload, i64 0, i32 0, !intel-tbaa !4
  %xtraiter = and i64 %agg.tmp.sroa.0.0.copyload, 1
  %0 = icmp eq i64 %agg.tmp.sroa.0.0.copyload, 1
  br i1 %0, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, label %for.body.i.preheader.i.new

for.body.i.preheader.i.new:                       ; preds = %for.body.i.preheader.i
  %unroll_iter = and i64 %agg.tmp.sroa.0.0.copyload, -2
  br label %for.body.i.i

for.body.i.i:                                     ; preds = %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i.1, %for.body.i.preheader.i.new
  %niter = phi i64 [ 0, %for.body.i.preheader.i.new ], [ %niter.next.1, %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i.1 ]
  %1 = load atomic i32, ptr %_M_i.i.i.i.i.i.i seq_cst, align 4
  %add6.i.i.i.i = add nsw i32 %1, 1
  %2 = cmpxchg weak ptr %_M_i.i.i.i.i.i.i, i32 %1, i32 %add6.i.i.i.i seq_cst seq_cst, align 4
  %3 = extractvalue { i32, i1 } %2, 1
  br i1 %3, label %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i

_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i: ; preds = %for.body.i.i, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i
  %4 = phi { i32, i1 } [ %6, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i ], [ %2, %for.body.i.i ]
  %5 = extractvalue { i32, i1 } %4, 0
  %add.i.i.i.i = add nsw i32 %5, 1
  %6 = cmpxchg weak ptr %_M_i.i.i.i.i.i.i, i32 %5, i32 %add.i.i.i.i seq_cst seq_cst, align 4
  %7 = extractvalue { i32, i1 } %6, 1
  br i1 %7, label %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i, !llvm.loop !10

_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i: ; preds = %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i, %for.body.i.i
  %8 = load atomic i32, ptr %_M_i.i.i.i.i.i.i seq_cst, align 4
  %add6.i.i.i.i.1 = add nsw i32 %8, 1
  %9 = cmpxchg weak ptr %_M_i.i.i.i.i.i.i, i32 %8, i32 %add6.i.i.i.i.1 seq_cst seq_cst, align 4
  %10 = extractvalue { i32, i1 } %9, 1
  br i1 %10, label %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i.1, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.1

_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.1: ; preds = %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.1
  %11 = phi { i32, i1 } [ %13, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.1 ], [ %9, %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i ]
  %12 = extractvalue { i32, i1 } %11, 0
  %add.i.i.i.i.1 = add nsw i32 %12, 1
  %13 = cmpxchg weak ptr %_M_i.i.i.i.i.i.i, i32 %12, i32 %add.i.i.i.i.1 seq_cst seq_cst, align 4
  %14 = extractvalue { i32, i1 } %13, 1
  br i1 %14, label %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i.1, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.1, !llvm.loop !10

_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i.1: ; preds = %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.1, %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i
  %niter.next.1 = add i64 %niter, 2
  %niter.ncmp.1 = icmp eq i64 %niter.next.1, %unroll_iter
  br i1 %niter.ncmp.1, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, label %for.body.i.i, !llvm.loop !288

_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa: ; preds = %_ZZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_ENKUlNS0_2idILi1EEEE_clES5_.exit.i.i.1, %for.body.i.preheader.i
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  br i1 %lcmp.mod.not, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %for.body.i.i.epil

for.body.i.i.epil:                                ; preds = %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa
  %15 = load atomic i32, ptr %_M_i.i.i.i.i.i.i seq_cst, align 4
  %add6.i.i.i.i.epil = add nsw i32 %15, 1
  %16 = cmpxchg weak ptr %_M_i.i.i.i.i.i.i, i32 %15, i32 %add6.i.i.i.i.epil seq_cst seq_cst, align 4
  %17 = extractvalue { i32, i1 } %16, 1
  br i1 %17, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.epil

_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.epil: ; preds = %for.body.i.i.epil, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.epil
  %18 = phi { i32, i1 } [ %20, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.epil ], [ %16, %for.body.i.i.epil ]
  %19 = extractvalue { i32, i1 } %18, 0
  %add.i.i.i.i.epil = add nsw i32 %19, 1
  %20 = cmpxchg weak ptr %_M_i.i.i.i.i.i.i, i32 %19, i32 %add.i.i.i.i.epil seq_cst seq_cst, align 4
  %21 = extractvalue { i32, i1 } %20, 1
  br i1 %21, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.epil, !llvm.loop !10

_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit: ; preds = %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEENS1_18RoundedRangeKernelIS4_Li1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESE_SF_.exit.loopexit.unr-lcssa, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i.i.epil, %for.body.i.i.epil, %entry
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define internal noundef nonnull ptr @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE6getPtrEv(ptr noundef nonnull readnone align 8 captures(ret: address, provenance) dereferenceable(16) %this) unnamed_addr #28 align 2 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.141", ptr %this, i64 0, i32 1, !intel-tbaa !283
  ret ptr %MKernel
}

; Function Attrs: mustprogress nounwind uwtable
define linkonce_odr dso_local void @_ZN4sycl3_V16detail14HostKernelBaseD2Ev(ptr noundef nonnull align 8 dereferenceable(8) %this) unnamed_addr #29 comdat align 2 {
entry:
  ret void
}

; Function Attrs: mustprogress nounwind uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EED0Ev(ptr noundef nonnull align 8 dereferenceable(16) %this) unnamed_addr #29 align 2 {
entry:
  tail call void @_ZdlPvm(ptr noundef nonnull %this, i64 noundef 16) #39
  ret void
}

; Function Attrs: mustprogress nofree norecurse nounwind memory(readwrite, inaccessiblemem: none) uwtable
define internal void @_ZN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EE23InstantiateKernelOnHostEv(ptr noundef nonnull readonly align 8 captures(none) dereferenceable(16) %this) unnamed_addr #30 align 2 personality ptr @__gxx_personality_v0 {
entry:
  %MKernel = getelementptr inbounds nuw %"class.sycl::_V1::detail::HostKernel.141", ptr %this, i64 0, i32 1, !intel-tbaa !283
  %agg.tmp.sroa.0.0.copyload = load ptr, ptr %MKernel, align 8, !tbaa !97
  %_M_i.i.i.i.i.i = getelementptr inbounds nuw %"struct.std::__atomic_base", ptr %agg.tmp.sroa.0.0.copyload, i64 0, i32 0, !intel-tbaa !4
  %0 = load atomic i32, ptr %_M_i.i.i.i.i.i seq_cst, align 4
  %add6.i.i.i = add nsw i32 %0, 1
  %1 = cmpxchg weak ptr %_M_i.i.i.i.i.i, i32 %0, i32 %add6.i.i.i seq_cst seq_cst, align 4
  %2 = extractvalue { i32, i1 } %1, 1
  br i1 %2, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEEZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESC_SD_.exit, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i

_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i: ; preds = %entry, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i
  %3 = phi { i32, i1 } [ %5, %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i ], [ %1, %entry ]
  %4 = extractvalue { i32, i1 } %3, 0
  %add.i.i.i = add nsw i32 %4, 1
  %5 = cmpxchg weak ptr %_M_i.i.i.i.i.i, i32 %4, i32 %add.i.i.i seq_cst seq_cst, align 4
  %6 = extractvalue { i32, i1 } %5, 1
  br i1 %6, label %_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEEZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESC_SD_.exit, label %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i, !llvm.loop !10

_ZN4sycl3_V16detail16runKernelWithArgINS0_4itemILi1ELb1EEEZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EENSt9enable_ifIXntsr32KernelLambdaHasKernelHandlerArgTIT0_T_EE5valueEvE4typeESC_SD_.exit: ; preds = %_ZNK4sycl3_V16detail15atomic_ref_baseIiLNS0_12memory_orderE5ELNS0_12memory_scopeE4ELNS0_6access13address_spaceE1EE21compare_exchange_weakERiiS3_S4_.exit.i.i.i, %entry
  ret void
}

; Function Attrs: nofree uwtable
define internal void @_GLOBAL__sub_I_test_atomic_asm.cpp() #34 section ".text.startup" {
entry:
  tail call void @_ZNSt8ios_base4InitC1Ev(ptr noundef nonnull align 1 dereferenceable(1) @_ZStL8__ioinit)
  %0 = tail call i32 @__cxa_atexit(ptr nonnull @_ZNSt8ios_base4InitD1Ev, ptr nonnull @_ZStL8__ioinit, ptr nonnull @__dso_handle) #37
  ret void
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umin.i64(i64, i64) #35

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #36

attributes #0 = { nofree "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #1 = { nofree nounwind "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #2 = { nofree nounwind }
attributes #3 = { mustprogress nofree norecurse nounwind willreturn memory(argmem: readwrite) uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #4 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #5 = { mustprogress nofree norecurse nounwind willreturn uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #6 = { mustprogress nofree norecurse nounwind memory(argmem: readwrite) uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #7 = { mustprogress norecurse uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #8 = { "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #9 = { inlinehint mustprogress nounwind uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #10 = { inlinehint mustprogress uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "pre_loopopt" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #11 = { nofree nosync nounwind memory(none) }
attributes #12 = { nofree }
attributes #13 = { nounwind "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #14 = { noinline noreturn nounwind uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #15 = { cold nofree noreturn nounwind }
attributes #16 = { mustprogress noinline nounwind uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #17 = { nobuiltin nounwind "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #18 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: read) "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #19 = { nofree noreturn "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #20 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #21 = { inlinehint mustprogress uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #22 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #23 = { mustprogress uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #24 = { noreturn "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #25 = { nofree noreturn nounwind "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #26 = { cold noreturn }
attributes #27 = { nobuiltin allocsize(0) "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #28 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #29 = { mustprogress nounwind uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #30 = { mustprogress nofree norecurse nounwind memory(readwrite, inaccessiblemem: none) uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #31 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #32 = { mustprogress nofree norecurse nounwind willreturn memory(readwrite, inaccessiblemem: none) uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #33 = { mustprogress nofree norecurse nounwind uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #34 = { nofree uwtable "approx-func-fp-math"="true" "denormal-fp-math"="preserve-sign,preserve-sign" "loopopt-pipeline"="light" "min-legal-vector-width"="0" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx16,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" "unsafe-fp-math"="true" }
attributes #35 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #36 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #37 = { nounwind }
attributes #38 = { noreturn nounwind }
attributes #39 = { builtin nounwind }
attributes #40 = { noreturn }
attributes #41 = { builtin allocsize(0) }

!llvm.dependent-libraries = !{!0}
!llvm.module.flags = !{!1, !2}
!llvm.ident = !{!3}

!0 = !{!"sycl-devicelib-host"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"Intel(R) oneAPI DPC++/C++ Compiler 2025.3.0 (2025.x.0.YYYYMMDD)"}
!4 = !{!5, !6, i64 0}
!5 = !{!"struct@_ZTSSt13__atomic_baseIiE", !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C++ TBAA"}
!9 = !{!6, !6, i64 0}
!10 = distinct !{!10, !11}
!11 = !{!"llvm.loop.mustprogress"}
!12 = !{!13, !14, i64 0}
!13 = !{!"struct@_ZTSN4sycl3_V16detail16PropertyListBaseE", !14, i64 0, !17, i64 8}
!14 = !{!"struct@_ZTSSt6bitsetILm32EE", !15, i64 0}
!15 = !{!"struct@_ZTSSt12_Base_bitsetILm1EE", !16, i64 0}
!16 = !{!"long", !7, i64 0}
!17 = !{!"struct@_ZTSSt6vectorISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEESaIS5_EE", !18, i64 0}
!18 = !{!"struct@_ZTSSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEESaIS5_EE", !19, i64 0}
!19 = !{!"struct@_ZTSNSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEESaIS5_EE12_Vector_implE", !20, i64 0}
!20 = !{!"struct@_ZTSNSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEESaIS5_EE17_Vector_impl_dataE", !21, i64 0, !21, i64 8, !21, i64 16}
!21 = !{!"pointer@_ZTSPSt10shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseEE", !7, i64 0}
!22 = !{!23, !7, i64 0}
!23 = !{!"struct@_ZTSSt14_Function_base", !7, i64 0, !24, i64 16}
!24 = !{!"unspecified pointer", !7, i64 0}
!25 = !{!23, !24, i64 16}
!26 = !{!27, !24, i64 24}
!27 = !{!"struct@_ZTSSt8functionIFiRKN4sycl3_V16deviceEEE", !23, i64 0, !24, i64 24}
!28 = !{!24, !24, i64 0}
!29 = !{!30, !24, i64 24}
!30 = !{!"struct@_ZTSSt8functionIFvN4sycl3_V114exception_listEEE", !23, i64 0, !24, i64 24}
!31 = !{!32, !32, i64 0}
!32 = !{!"pointer@_ZTSPFvN4sycl3_V114exception_listEE", !7, i64 0}
!33 = !{!34, !35, i64 0}
!34 = !{!"struct@_ZTSSt14__shared_countILN9__gnu_cxx12_Lock_policyE2EE", !35, i64 0}
!35 = !{!"pointer@_ZTSPSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE", !7, i64 0}
!36 = !{!37, !6, i64 8}
!37 = !{!"struct@_ZTSSt16_Sp_counted_baseILN9__gnu_cxx12_Lock_policyE2EE", !6, i64 8, !6, i64 12}
!38 = !{!37, !6, i64 12}
!39 = !{!40, !40, i64 0}
!40 = !{!"vtable pointer", !8, i64 0}
!41 = !{!7, !7, i64 0}
!42 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!43 = !{!20, !21, i64 0}
!44 = !{!20, !21, i64 8}
!45 = !{!46, !35, i64 8}
!46 = !{!"struct@_ZTSSt12__shared_ptrIN4sycl3_V16detail20PropertyWithDataBaseELN9__gnu_cxx12_Lock_policyE2EE", !47, i64 0, !34, i64 8}
!47 = !{!"pointer@_ZTSPN4sycl3_V16detail20PropertyWithDataBaseE", !7, i64 0}
!48 = distinct !{!48, !11}
!49 = !{!20, !21, i64 16}
!50 = !{!51}
!51 = distinct !{!51, !52, !"_ZNK4sycl3_V16device8get_infoINS0_4info6device4nameEEENS0_6detail19is_device_info_descIT_E11return_typeEv: %agg.result"}
!52 = distinct !{!52, !"_ZNK4sycl3_V16device8get_infoINS0_4info6device4nameEEENS0_6detail19is_device_info_descIT_E11return_typeEv"}
!53 = !{!54, !55, i64 0}
!54 = !{!"struct@_ZTSN4sycl3_V16detail6stringE", !55, i64 0}
!55 = !{!"pointer@_ZTSPc", !7, i64 0}
!56 = !{!57, !7, i64 16}
!57 = !{!"struct@_ZTSNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE", !58, i64 0, !16, i64 8, !7, i64 16}
!58 = !{!"struct@_ZTSNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE12_Alloc_hiderE", !55, i64 0}
!59 = !{!58, !55, i64 0}
!60 = !{!16, !16, i64 0}
!61 = !{!57, !55, i64 0}
!62 = !{!57, !16, i64 8}
!63 = !{!64, !78, i64 240}
!64 = !{!"struct@_ZTSSt9basic_iosIcSt11char_traitsIcEE", !65, i64 0, !75, i64 216, !7, i64 224, !76, i64 225, !77, i64 232, !78, i64 240, !79, i64 248, !80, i64 256}
!65 = !{!"struct@_ZTSSt8ios_base", !16, i64 8, !16, i64 16, !66, i64 24, !67, i64 28, !67, i64 32, !68, i64 40, !69, i64 48, !71, i64 64, !6, i64 192, !72, i64 200, !73, i64 208}
!66 = !{!"_ZTSSt13_Ios_Fmtflags", !7, i64 0}
!67 = !{!"_ZTSSt12_Ios_Iostate", !7, i64 0}
!68 = !{!"pointer@_ZTSPNSt8ios_base14_Callback_listE", !7, i64 0}
!69 = !{!"struct@_ZTSNSt8ios_base6_WordsE", !70, i64 0, !16, i64 8}
!70 = !{!"pointer@_ZTSPv", !7, i64 0}
!71 = !{!"array@_ZTSA8_NSt8ios_base6_WordsE", !69, i64 0}
!72 = !{!"pointer@_ZTSPNSt8ios_base6_WordsE", !7, i64 0}
!73 = !{!"struct@_ZTSSt6locale", !74, i64 0}
!74 = !{!"pointer@_ZTSPNSt6locale5_ImplE", !7, i64 0}
!75 = !{!"pointer@_ZTSPSo", !7, i64 0}
!76 = !{!"bool", !7, i64 0}
!77 = !{!"pointer@_ZTSPSt15basic_streambufIcSt11char_traitsIcEE", !7, i64 0}
!78 = !{!"pointer@_ZTSPSt5ctypeIcE", !7, i64 0}
!79 = !{!"pointer@_ZTSPSt7num_putIcSt19ostreambuf_iteratorIcSt11char_traitsIcEEE", !7, i64 0}
!80 = !{!"pointer@_ZTSPSt7num_getIcSt19istreambuf_iteratorIcSt11char_traitsIcEEE", !7, i64 0}
!81 = !{!82, !7, i64 56}
!82 = !{!"struct@_ZTSSt5ctypeIcE", !83, i64 0, !84, i64 16, !76, i64 24, !85, i64 32, !85, i64 40, !86, i64 48, !7, i64 56, !87, i64 57, !87, i64 313, !7, i64 569}
!83 = !{!"struct@_ZTSNSt6locale5facetE", !6, i64 8}
!84 = !{!"pointer@_ZTSP15__locale_struct", !7, i64 0}
!85 = !{!"pointer@_ZTSPi", !7, i64 0}
!86 = !{!"pointer@_ZTSPt", !7, i64 0}
!87 = !{!"array@_ZTSA256_c", !7, i64 0}
!88 = !{!82, !7, i64 57}
!89 = !{!90, !55, i64 0}
!90 = !{!"struct@_ZTSN4sycl3_V16detail13code_locationE", !55, i64 0, !55, i64 8, !16, i64 16, !16, i64 24}
!91 = !{!92}
!92 = distinct !{!92, !93, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm: %agg.result"}
!93 = distinct !{!93, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm"}
!94 = !{!90, !55, i64 8}
!95 = !{!90, !16, i64 16}
!96 = !{!90, !16, i64 24}
!97 = !{!85, !85, i64 0}
!98 = !{!99}
!99 = distinct !{!99, !100, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm: %agg.result"}
!100 = distinct !{!100, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm"}
!101 = !{!102}
!102 = distinct !{!102, !103, !"_ZN4sycl3_V15queue6submitIZ4mainEUlRNS0_7handlerEE_EENSt9enable_ifIXsr3stdE16is_invocable_r_vIvT_S4_EENS0_5eventEE4typeES7_RKNS0_6detail13code_locationE: %agg.result"}
!103 = distinct !{!103, !"_ZN4sycl3_V15queue6submitIZ4mainEUlRNS0_7handlerEE_EENSt9enable_ifIXsr3stdE16is_invocable_r_vIvT_S4_EENS0_5eventEE4typeES7_RKNS0_6detail13code_locationE"}
!104 = !{!105, !70, i64 0}
!105 = !{!"struct@_ZTSN4sycl3_V16detail19type_erased_cgfo_tyE", !70, i64 0, !24, i64 8}
!106 = !{!105, !24, i64 8}
!107 = !{!108}
!108 = distinct !{!108, !109, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm: %agg.result"}
!109 = distinct !{!109, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm"}
!110 = !{!111}
!111 = distinct !{!111, !112, !"_ZN4sycl3_V15queue6submitIZ4mainEUlRNS0_7handlerEE0_EENSt9enable_ifIXsr3stdE16is_invocable_r_vIvT_S4_EENS0_5eventEE4typeES7_RKNS0_6detail13code_locationE: %agg.result"}
!112 = distinct !{!112, !"_ZN4sycl3_V15queue6submitIZ4mainEUlRNS0_7handlerEE0_EENSt9enable_ifIXsr3stdE16is_invocable_r_vIvT_S4_EENS0_5eventEE4typeES7_RKNS0_6detail13code_locationE"}
!113 = !{!114}
!114 = distinct !{!114, !115, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm: %agg.result"}
!115 = distinct !{!115, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm"}
!116 = !{!117}
!117 = distinct !{!117, !118, !"_ZN4sycl3_V15queue6submitIZ4mainEUlRNS0_7handlerEE1_EENSt9enable_ifIXsr3stdE16is_invocable_r_vIvT_S4_EENS0_5eventEE4typeES7_RKNS0_6detail13code_locationE: %agg.result"}
!118 = distinct !{!118, !"_ZN4sycl3_V15queue6submitIZ4mainEUlRNS0_7handlerEE1_EENSt9enable_ifIXsr3stdE16is_invocable_r_vIvT_S4_EENS0_5eventEE4typeES7_RKNS0_6detail13code_locationE"}
!119 = !{!120}
!120 = distinct !{!120, !121, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm: %agg.result"}
!121 = distinct !{!121, !"_ZN4sycl3_V16detail13code_location7currentEPKcS4_mm"}
!122 = !{!123, !70, i64 0}
!123 = !{!"struct@_ZTSNSt15__exception_ptr13exception_ptrE", !70, i64 0}
!124 = !{!65, !67, i64 32}
!125 = !{!126, !126, i64 0}
!126 = !{!"pointer@_ZTSPSt9type_info", !7, i64 0}
!127 = !{!128, !129, i64 0}
!128 = !{!"struct@_ZTSNSt12_Vector_baseINSt15__exception_ptr13exception_ptrESaIS1_EE17_Vector_impl_dataE", !129, i64 0, !129, i64 8, !129, i64 16}
!129 = !{!"pointer@_ZTSPNSt15__exception_ptr13exception_ptrE", !7, i64 0}
!130 = !{!129, !129, i64 0}
!131 = !{!128, !129, i64 16}
!132 = !{!128, !129, i64 8}
!133 = distinct !{!133, !11}
!134 = !{!135, !135, i64 0}
!135 = !{!"pointer@_ZTSPPFvN4sycl3_V114exception_listEE", !7, i64 0}
!136 = !{!137, !138, i64 0}
!137 = !{!"struct@_ZTSSt12__shared_ptrIN4sycl3_V16detail10queue_implELN9__gnu_cxx12_Lock_policyE2EE", !138, i64 0, !34, i64 8}
!138 = !{!"pointer@_ZTSPN4sycl3_V16detail10queue_implE", !7, i64 0}
!139 = !{!137, !35, i64 8}
!140 = !{!141, !76, i64 0}
!141 = !{!"struct@_ZTSN4sycl3_V16detail14tls_code_loc_tE", !76, i64 0}
!142 = !{i8 0, i8 2}
!143 = !{}
!144 = !{!145, !146, i64 0}
!145 = !{!"struct@_ZTSZ4mainEUlRN4sycl3_V17handlerEE_", !146, i64 0}
!146 = !{!"p2 int", !147, i64 0}
!147 = !{!"any p2 pointer", !148, i64 0}
!148 = !{!"any pointer", !7, i64 0}
!149 = !{!150, !76, i64 0}
!150 = !{!"struct@_ZTSSt10_Head_baseILm1EbLb0EE", !76, i64 0}
!151 = !{!152, !153, i64 0}
!152 = !{!"struct@_ZTSSt10_Head_baseILm0EN4sycl3_V15rangeILi1EEELb0EE", !153, i64 0}
!153 = !{!"struct@_ZTSN4sycl3_V15rangeILi1EEE", !154, i64 0}
!154 = !{!"struct@_ZTSN4sycl3_V16detail5arrayILi1EEE", !155, i64 0}
!155 = !{!"array@_ZTSA1_m", !16, i64 0}
!156 = !{!157, !158, i64 0}
!157 = !{!"struct@_ZTSN4sycl3_V16detail5arrayILi3EEE", !158, i64 0}
!158 = !{!"array@_ZTSA3_m", !16, i64 0}
!159 = !{!160}
!160 = distinct !{!160, !161, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE: %agg.result"}
!161 = distinct !{!161, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE"}
!162 = !{!157, !16, i64 0}
!163 = !{!164}
!164 = distinct !{!164, !165, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEEJRSD_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_: %agg.result"}
!165 = distinct !{!165, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEEJRSD_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_"}
!166 = !{!167, !169, i64 8}
!167 = !{!"struct@_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE", !168, i64 0, !169, i64 8}
!168 = !{!"struct@_ZTSN4sycl3_V16detail14HostKernelBaseE"}
!169 = !{!"struct@_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES6_EUlNS0_2idILi1EEEE_EE", !153, i64 0, !170, i64 8}
!170 = !{!"struct@_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE_clES2_EUlNS0_2idILi1EEEE_", !85, i64 0}
!171 = !{!172, !173, i64 0}
!172 = !{!"struct@_ZTSSt10_Head_baseILm0EPN4sycl3_V16detail14HostKernelBaseELb0EE", !173, i64 0}
!173 = !{!"pointer@_ZTSPN4sycl3_V16detail14HostKernelBaseE", !7, i64 0}
!174 = !{!175}
!175 = distinct !{!175, !176, !"_ZN4sycl3_V16detail19getKernelParamDescsINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEESt6vectorINS1_19kernel_param_desc_tESaISE_EEv: %agg.result"}
!176 = distinct !{!176, !"_ZN4sycl3_V16detail19getKernelParamDescsINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE_clES7_EUlNS0_2idILi1EEEE_EEEESt6vectorINS1_19kernel_param_desc_tESaISE_EEv"}
!177 = !{!178, !178, i64 0}
!178 = !{!"struct@_ZTSN4sycl3_V16detail19kernel_param_desc_tE", !179, i64 0, !6, i64 4, !6, i64 8}
!179 = !{!"_ZTSN4sycl3_V16detail19kernel_param_kind_tE", !7, i64 0}
!180 = !{!181, !182, i64 0}
!181 = !{!"struct@_ZTSNSt12_Vector_baseIN4sycl3_V16detail19kernel_param_desc_tESaIS3_EE17_Vector_impl_dataE", !182, i64 0, !182, i64 8, !182, i64 16}
!182 = !{!"pointer@_ZTSPN4sycl3_V16detail19kernel_param_desc_tE", !7, i64 0}
!183 = !{!181, !182, i64 16}
!184 = !{!185, !55, i64 80}
!185 = !{!"struct@_ZTSN4sycl3_V17handlerE", !186, i64 0, !189, i64 16, !190, i64 32, !195, i64 56, !54, i64 80, !200, i64 88, !70, i64 104, !70, i64 112, !16, i64 120, !203, i64 128, !208, i64 152, !90, i64 160, !76, i64 192, !213, i64 200}
!186 = !{!"struct@_ZTSSt10shared_ptrIN4sycl3_V16detail12handler_implEE", !187, i64 0}
!187 = !{!"struct@_ZTSSt12__shared_ptrIN4sycl3_V16detail12handler_implELN9__gnu_cxx12_Lock_policyE2EE", !188, i64 0, !34, i64 8}
!188 = !{!"pointer@_ZTSPN4sycl3_V16detail12handler_implE", !7, i64 0}
!189 = !{!"struct@_ZTSSt10shared_ptrIN4sycl3_V16detail10queue_implEE", !137, i64 0}
!190 = !{!"struct@_ZTSSt6vectorISt10shared_ptrIN4sycl3_V16detail21LocalAccessorImplHostEESaIS5_EE", !191, i64 0}
!191 = !{!"struct@_ZTSSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail21LocalAccessorImplHostEESaIS5_EE", !192, i64 0}
!192 = !{!"struct@_ZTSNSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail21LocalAccessorImplHostEESaIS5_EE12_Vector_implE", !193, i64 0}
!193 = !{!"struct@_ZTSNSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail21LocalAccessorImplHostEESaIS5_EE17_Vector_impl_dataE", !194, i64 0, !194, i64 8, !194, i64 16}
!194 = !{!"pointer@_ZTSPSt10shared_ptrIN4sycl3_V16detail21LocalAccessorImplHostEE", !7, i64 0}
!195 = !{!"struct@_ZTSSt6vectorISt10shared_ptrIN4sycl3_V16detail11stream_implEESaIS5_EE", !196, i64 0}
!196 = !{!"struct@_ZTSSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail11stream_implEESaIS5_EE", !197, i64 0}
!197 = !{!"struct@_ZTSNSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail11stream_implEESaIS5_EE12_Vector_implE", !198, i64 0}
!198 = !{!"struct@_ZTSNSt12_Vector_baseISt10shared_ptrIN4sycl3_V16detail11stream_implEESaIS5_EE17_Vector_impl_dataE", !199, i64 0, !199, i64 8, !199, i64 16}
!199 = !{!"pointer@_ZTSPSt10shared_ptrIN4sycl3_V16detail11stream_implEE", !7, i64 0}
!200 = !{!"struct@_ZTSSt10shared_ptrIN4sycl3_V16detail11kernel_implEE", !201, i64 0}
!201 = !{!"struct@_ZTSSt12__shared_ptrIN4sycl3_V16detail11kernel_implELN9__gnu_cxx12_Lock_policyE2EE", !202, i64 0, !34, i64 8}
!202 = !{!"pointer@_ZTSPN4sycl3_V16detail11kernel_implE", !7, i64 0}
!203 = !{!"struct@_ZTSSt6vectorIhSaIhEE", !204, i64 0}
!204 = !{!"struct@_ZTSSt12_Vector_baseIhSaIhEE", !205, i64 0}
!205 = !{!"struct@_ZTSNSt12_Vector_baseIhSaIhEE12_Vector_implE", !206, i64 0}
!206 = !{!"struct@_ZTSNSt12_Vector_baseIhSaIhEE17_Vector_impl_dataE", !207, i64 0, !207, i64 8, !207, i64 16}
!207 = !{!"pointer@_ZTSPh", !7, i64 0}
!208 = !{!"struct@_ZTSSt10unique_ptrIN4sycl3_V16detail14HostKernelBaseESt14default_deleteIS3_EE", !209, i64 0}
!209 = !{!"struct@_ZTSSt15__uniq_ptr_dataIN4sycl3_V16detail14HostKernelBaseESt14default_deleteIS3_ELb1ELb1EE", !210, i64 0}
!210 = !{!"struct@_ZTSSt15__uniq_ptr_implIN4sycl3_V16detail14HostKernelBaseESt14default_deleteIS3_EE", !211, i64 0}
!211 = !{!"struct@_ZTSSt5tupleIJPN4sycl3_V16detail14HostKernelBaseESt14default_deleteIS3_EEE", !212, i64 0}
!212 = !{!"struct@_ZTSSt11_Tuple_implILm0EJPN4sycl3_V16detail14HostKernelBaseESt14default_deleteIS3_EEE", !172, i64 0}
!213 = !{!"struct@_ZTSN4sycl3_V15eventE", !214, i64 0}
!214 = !{!"struct@_ZTSSt10shared_ptrIN4sycl3_V16detail10event_implEE", !215, i64 0}
!215 = !{!"struct@_ZTSSt12__shared_ptrIN4sycl3_V16detail10event_implELN9__gnu_cxx12_Lock_policyE2EE", !216, i64 0, !34, i64 8}
!216 = !{!"pointer@_ZTSPN4sycl3_V16detail10event_implE", !7, i64 0}
!217 = !{!55, !55, i64 0}
!218 = !{!219}
!219 = distinct !{!219, !220, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE: %agg.result"}
!220 = distinct !{!220, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE"}
!221 = !{!222}
!222 = distinct !{!222, !223, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS1_7handlerEE_clES5_EUlNS1_2idILi1EEEE_NS1_4itemILi1ELb1EEELi1EEEJRS9_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_: %agg.result"}
!223 = distinct !{!223, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS1_7handlerEE_clES5_EUlNS1_2idILi1EEEE_NS1_4itemILi1ELb1EEELi1EEEJRS9_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_"}
!224 = !{!225, !170, i64 8}
!225 = !{!"struct@_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE", !168, i64 0, !170, i64 8}
!226 = !{!227}
!227 = distinct !{!227, !228, !"_ZN4sycl3_V16detail19getKernelParamDescsIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_EESt6vectorINS1_19kernel_param_desc_tESaISA_EEv: %agg.result"}
!228 = distinct !{!228, !"_ZN4sycl3_V16detail19getKernelParamDescsIZZ4mainENKUlRNS0_7handlerEE_clES4_EUlNS0_2idILi1EEEE_EESt6vectorINS1_19kernel_param_desc_tESaISA_EEv"}
!229 = !{!181, !182, i64 8}
!230 = !{!154, !16, i64 0}
!231 = distinct !{!231, !11}
!232 = distinct !{!232, !233}
!233 = !{!"llvm.loop.unroll.disable"}
!234 = !{!235, !146, i64 0}
!235 = !{!"struct@_ZTSZ4mainEUlRN4sycl3_V17handlerEE0_", !146, i64 0}
!236 = !{!237}
!237 = distinct !{!237, !238, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE: %agg.result"}
!238 = distinct !{!238, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE"}
!239 = !{!240}
!240 = distinct !{!240, !241, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE0_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEEJRSD_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_: %agg.result"}
!241 = distinct !{!241, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE0_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEEJRSD_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_"}
!242 = !{!243, !244, i64 8}
!243 = !{!"struct@_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE", !168, i64 0, !244, i64 8}
!244 = !{!"struct@_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES6_EUlNS0_2idILi1EEEE_EE", !153, i64 0, !245, i64 8}
!245 = !{!"struct@_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE0_clES2_EUlNS0_2idILi1EEEE_", !85, i64 0}
!246 = !{!247}
!247 = distinct !{!247, !248, !"_ZN4sycl3_V16detail19getKernelParamDescsINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEESt6vectorINS1_19kernel_param_desc_tESaISE_EEv: %agg.result"}
!248 = distinct !{!248, !"_ZN4sycl3_V16detail19getKernelParamDescsINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE0_clES7_EUlNS0_2idILi1EEEE_EEEESt6vectorINS1_19kernel_param_desc_tESaISE_EEv"}
!249 = !{!250}
!250 = distinct !{!250, !251, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE: %agg.result"}
!251 = distinct !{!251, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE"}
!252 = !{!253}
!253 = distinct !{!253, !254, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS1_7handlerEE0_clES5_EUlNS1_2idILi1EEEE_NS1_4itemILi1ELb1EEELi1EEEJRS9_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_: %agg.result"}
!254 = distinct !{!254, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS1_7handlerEE0_clES5_EUlNS1_2idILi1EEEE_NS1_4itemILi1ELb1EEELi1EEEJRS9_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_"}
!255 = !{!256, !245, i64 8}
!256 = !{!"struct@_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE", !168, i64 0, !245, i64 8}
!257 = !{!258}
!258 = distinct !{!258, !259, !"_ZN4sycl3_V16detail19getKernelParamDescsIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_EESt6vectorINS1_19kernel_param_desc_tESaISA_EEv: %agg.result"}
!259 = distinct !{!259, !"_ZN4sycl3_V16detail19getKernelParamDescsIZZ4mainENKUlRNS0_7handlerEE0_clES4_EUlNS0_2idILi1EEEE_EESt6vectorINS1_19kernel_param_desc_tESaISA_EEv"}
!260 = distinct !{!260, !11}
!261 = distinct !{!261, !233}
!262 = !{!263, !146, i64 0}
!263 = !{!"struct@_ZTSZ4mainEUlRN4sycl3_V17handlerEE1_", !146, i64 0}
!264 = !{!265}
!265 = distinct !{!265, !266, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE: %agg.result"}
!266 = distinct !{!266, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE"}
!267 = !{!268}
!268 = distinct !{!268, !269, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE1_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEEJRSD_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_: %agg.result"}
!269 = distinct !{!269, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelINS2_18RoundedRangeKernelINS1_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS1_7handlerEE1_clES8_EUlNS1_2idILi1EEEE_EES6_Li1EEEJRSD_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_"}
!270 = !{!271, !272, i64 8}
!271 = !{!"struct@_ZTSN4sycl3_V16detail10HostKernelINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EES5_Li1EEE", !168, i64 0, !272, i64 8}
!272 = !{!"struct@_ZTSN4sycl3_V16detail18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES6_EUlNS0_2idILi1EEEE_EE", !153, i64 0, !273, i64 8}
!273 = !{!"struct@_ZTSZZ4mainENKUlRN4sycl3_V17handlerEE1_clES2_EUlNS0_2idILi1EEEE_", !85, i64 0}
!274 = !{!275}
!275 = distinct !{!275, !276, !"_ZN4sycl3_V16detail19getKernelParamDescsINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEESt6vectorINS1_19kernel_param_desc_tESaISE_EEv: %agg.result"}
!276 = distinct !{!276, !"_ZN4sycl3_V16detail19getKernelParamDescsINS1_18RoundedRangeKernelINS0_4itemILi1ELb1EEELi1EZZ4mainENKUlRNS0_7handlerEE1_clES7_EUlNS0_2idILi1EEEE_EEEESt6vectorINS1_19kernel_param_desc_tESaISE_EEv"}
!277 = !{!278}
!278 = distinct !{!278, !279, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE: %agg.result"}
!279 = distinct !{!279, !"_ZN4sycl3_V17handler8padRangeILi1EEENS0_5rangeILi3EEENS3_IXT_EEE"}
!280 = !{!281}
!281 = distinct !{!281, !282, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS1_7handlerEE1_clES5_EUlNS1_2idILi1EEEE_NS1_4itemILi1ELb1EEELi1EEEJRS9_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_: %agg.result"}
!282 = distinct !{!282, !"_ZSt11make_uniqueIN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS1_7handlerEE1_clES5_EUlNS1_2idILi1EEEE_NS1_4itemILi1ELb1EEELi1EEEJRS9_EENSt8__detail9_MakeUniqIT_E15__single_objectEDpOT0_"}
!283 = !{!284, !273, i64 8}
!284 = !{!"struct@_ZTSN4sycl3_V16detail10HostKernelIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_NS0_4itemILi1ELb1EEELi1EEE", !168, i64 0, !273, i64 8}
!285 = !{!286}
!286 = distinct !{!286, !287, !"_ZN4sycl3_V16detail19getKernelParamDescsIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_EESt6vectorINS1_19kernel_param_desc_tESaISA_EEv: %agg.result"}
!287 = distinct !{!287, !"_ZN4sycl3_V16detail19getKernelParamDescsIZZ4mainENKUlRNS0_7handlerEE1_clES4_EUlNS0_2idILi1EEEE_EESt6vectorINS1_19kernel_param_desc_tESaISA_EEv"}
!288 = distinct !{!288, !11}

; __CLANG_OFFLOAD_BUNDLE____END__ host-x86_64-unknown-linux-gnu
