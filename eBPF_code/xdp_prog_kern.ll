; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.collect_vlans = type { [2 x i16] }
%struct.vlan_hdr = type { i16, i16 }
%struct.iphdr = type { i8, i8, i16, i16, i16, i8, i8, i16, i32, i32 }
%struct.ipv6hdr = type { i8, [3 x i8], i16, i8, i8, %struct.in6_addr, %struct.in6_addr }
%struct.in6_addr = type { %union.anon }
%union.anon = type { [4 x i32] }
%struct.udphdr = type { i16, i16, i16, i16 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !50
@llvm.used = appending global [3 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readonly %0) #0 section "xdp_pass" !dbg !77 {
  %2 = alloca i32, align 4
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !91, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata i32 2, metadata !92, metadata !DIExpression()), !dbg !199
  %3 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !200
  %4 = load i32, i32* %3, align 4, !dbg !200, !tbaa !201
  %5 = zext i32 %4 to i64, !dbg !206
  %6 = inttoptr i64 %5 to i8*, !dbg !207
  call void @llvm.dbg.value(metadata i8* %6, metadata !191, metadata !DIExpression()), !dbg !199
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !208
  %8 = load i32, i32* %7, align 4, !dbg !208, !tbaa !209
  %9 = zext i32 %8 to i64, !dbg !210
  %10 = inttoptr i64 %9 to i8*, !dbg !211
  call void @llvm.dbg.value(metadata i8* %10, metadata !192, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata i8* %10, metadata !193, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !95, metadata !DIExpression(DW_OP_deref)), !dbg !199
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !212, metadata !DIExpression()), !dbg !221
  call void @llvm.dbg.value(metadata i8* %6, metadata !219, metadata !DIExpression()), !dbg !221
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !220, metadata !DIExpression()), !dbg !221
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !223, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i8* %6, metadata !235, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !236, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !237, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i8* %10, metadata !238, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i32 14, metadata !239, metadata !DIExpression()), !dbg !248
  %11 = getelementptr i8, i8* %10, i64 14, !dbg !250
  %12 = icmp ugt i8* %11, %6, !dbg !252
  br i1 %12, label %98, label %13, !dbg !253

13:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %10, metadata !238, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i8* %11, metadata !193, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata i8* %11, metadata !240, metadata !DIExpression()), !dbg !248
  %14 = getelementptr inbounds i8, i8* %10, i64 12, !dbg !254
  %15 = bitcast i8* %14 to i16*, !dbg !254
  call void @llvm.dbg.value(metadata i16 undef, metadata !246, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i32 0, metadata !247, metadata !DIExpression()), !dbg !248
  %16 = load i16, i16* %15, align 1, !dbg !248, !tbaa !255
  call void @llvm.dbg.value(metadata i16 %16, metadata !246, metadata !DIExpression()), !dbg !248
  %17 = inttoptr i64 %5 to %struct.vlan_hdr*, !dbg !257
  %18 = getelementptr i8, i8* %10, i64 22, !dbg !262
  %19 = bitcast i8* %18 to %struct.vlan_hdr*, !dbg !262
  switch i16 %16, label %34 [
    i16 -22392, label %20
    i16 129, label %20
  ], !dbg !263

20:                                               ; preds = %13, %13
  %21 = getelementptr i8, i8* %10, i64 18, !dbg !264
  %22 = bitcast i8* %21 to %struct.vlan_hdr*, !dbg !264
  %23 = icmp ugt %struct.vlan_hdr* %22, %17, !dbg !265
  br i1 %23, label %34, label %24, !dbg !266

24:                                               ; preds = %20
  call void @llvm.dbg.value(metadata i16 undef, metadata !246, metadata !DIExpression()), !dbg !248
  %25 = getelementptr i8, i8* %10, i64 16, !dbg !267
  %26 = bitcast i8* %25 to i16*, !dbg !267
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %22, metadata !240, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i32 1, metadata !247, metadata !DIExpression()), !dbg !248
  %27 = load i16, i16* %26, align 1, !dbg !248, !tbaa !255
  call void @llvm.dbg.value(metadata i16 %27, metadata !246, metadata !DIExpression()), !dbg !248
  switch i16 %27, label %34 [
    i16 -22392, label %28
    i16 129, label %28
  ], !dbg !263

28:                                               ; preds = %24, %24
  %29 = icmp ugt %struct.vlan_hdr* %19, %17, !dbg !265
  br i1 %29, label %34, label %30, !dbg !266

30:                                               ; preds = %28
  call void @llvm.dbg.value(metadata i16 undef, metadata !246, metadata !DIExpression()), !dbg !248
  %31 = getelementptr i8, i8* %10, i64 20, !dbg !267
  %32 = bitcast i8* %31 to i16*, !dbg !267
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %19, metadata !240, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i32 2, metadata !247, metadata !DIExpression()), !dbg !248
  %33 = load i16, i16* %32, align 1, !dbg !248, !tbaa !255
  call void @llvm.dbg.value(metadata i16 %33, metadata !246, metadata !DIExpression()), !dbg !248
  br label %34

34:                                               ; preds = %30, %28, %24, %20, %13
  %35 = phi i8* [ %11, %13 ], [ %11, %20 ], [ %21, %24 ], [ %21, %28 ], [ %18, %30 ], !dbg !248
  %36 = phi i16 [ %16, %13 ], [ %16, %20 ], [ %27, %24 ], [ %27, %28 ], [ %33, %30 ], !dbg !248
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !240, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !240, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !240, metadata !DIExpression()), !dbg !248
  call void @llvm.dbg.value(metadata i8* %35, metadata !193, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata i8* %35, metadata !193, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata i16 %36, metadata !93, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata i16 %36, metadata !93, metadata !DIExpression(DW_OP_LLVM_convert, 16, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !199
  switch i16 %36, label %98 [
    i16 8, label %37
    i16 -8826, label %49
  ], !dbg !268

37:                                               ; preds = %34
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !109, metadata !DIExpression(DW_OP_deref)), !dbg !199
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !269, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.value(metadata i8* %6, metadata !275, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.value(metadata %struct.iphdr** undef, metadata !276, metadata !DIExpression()), !dbg !279
  call void @llvm.dbg.value(metadata i8* %35, metadata !277, metadata !DIExpression()), !dbg !279
  %38 = getelementptr inbounds i8, i8* %35, i64 20, !dbg !283
  %39 = icmp ugt i8* %38, %6, !dbg !285
  br i1 %39, label %98, label %40, !dbg !286

40:                                               ; preds = %37
  %41 = load i8, i8* %35, align 4, !dbg !287
  %42 = shl i8 %41, 2, !dbg !288
  %43 = and i8 %42, 60, !dbg !288
  call void @llvm.dbg.value(metadata i8 %43, metadata !278, metadata !DIExpression()), !dbg !279
  %44 = icmp ult i8 %43, 20, !dbg !289
  br i1 %44, label %98, label %45, !dbg !291

45:                                               ; preds = %40
  %46 = zext i8 %43 to i64, !dbg !292
  call void @llvm.dbg.value(metadata i64 %46, metadata !278, metadata !DIExpression()), !dbg !279
  %47 = getelementptr i8, i8* %35, i64 %46, !dbg !293
  %48 = icmp ugt i8* %47, %6, !dbg !295
  br i1 %48, label %98, label %54, !dbg !296

49:                                               ; preds = %34
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !297, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.value(metadata i8* %6, metadata !303, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.value(metadata i8* %35, metadata !305, metadata !DIExpression()), !dbg !306
  %50 = getelementptr inbounds i8, i8* %35, i64 40, !dbg !310
  %51 = bitcast i8* %50 to %struct.ipv6hdr*, !dbg !310
  %52 = inttoptr i64 %5 to %struct.ipv6hdr*, !dbg !312
  %53 = icmp ugt %struct.ipv6hdr* %51, %52, !dbg !313
  br i1 %53, label %98, label %54, !dbg !314

54:                                               ; preds = %49, %45
  %55 = phi i64 [ 9, %45 ], [ 6, %49 ]
  %56 = phi i8* [ %47, %45 ], [ %50, %49 ], !dbg !315
  %57 = getelementptr inbounds i8, i8* %35, i64 %55, !dbg !316
  %58 = load i8, i8* %57, align 1, !dbg !316, !tbaa !317
  call void @llvm.dbg.value(metadata i8* %56, metadata !193, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata i8 %58, metadata !94, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !199
  switch i8 %58, label %98 [
    i8 17, label %59
    i8 6, label %77
  ], !dbg !318

59:                                               ; preds = %54
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !319, metadata !DIExpression()) #3, !dbg !329
  call void @llvm.dbg.value(metadata i8* %6, metadata !325, metadata !DIExpression()) #3, !dbg !329
  call void @llvm.dbg.value(metadata i8* %56, metadata !328, metadata !DIExpression()) #3, !dbg !329
  %60 = getelementptr inbounds i8, i8* %56, i64 8, !dbg !334
  %61 = bitcast i8* %60 to %struct.udphdr*, !dbg !334
  %62 = inttoptr i64 %5 to %struct.udphdr*, !dbg !336
  %63 = icmp ugt %struct.udphdr* %61, %62, !dbg !337
  br i1 %63, label %98, label %64, !dbg !338

64:                                               ; preds = %59
  call void @llvm.dbg.value(metadata %struct.udphdr* %61, metadata !193, metadata !DIExpression()), !dbg !199
  %65 = getelementptr inbounds i8, i8* %56, i64 4, !dbg !339
  %66 = bitcast i8* %65 to i16*, !dbg !339
  %67 = load i16, i16* %66, align 2, !dbg !339, !tbaa !340
  %68 = tail call i16 @llvm.bswap.i16(i16 %67) #3
  call void @llvm.dbg.value(metadata i16 %68, metadata !327, metadata !DIExpression(DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #3, !dbg !329
  %69 = icmp ult i16 %68, 8, !dbg !342
  br i1 %69, label %98, label %70, !dbg !344

70:                                               ; preds = %64
  call void @llvm.dbg.value(metadata i16 %68, metadata !327, metadata !DIExpression(DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #3, !dbg !329
  call void @llvm.dbg.value(metadata i8* %56, metadata !160, metadata !DIExpression()), !dbg !199
  %71 = getelementptr inbounds i8, i8* %56, i64 2, !dbg !345
  %72 = bitcast i8* %71 to i16*, !dbg !345
  %73 = load i16, i16* %72, align 2, !dbg !345, !tbaa !346
  %74 = tail call i16 @llvm.bswap.i16(i16 %73)
  %75 = add i16 %74, -1, !dbg !345
  %76 = tail call i16 @llvm.bswap.i16(i16 %75), !dbg !345
  store i16 %76, i16* %72, align 2, !dbg !347, !tbaa !346
  br label %98, !dbg !348

77:                                               ; preds = %54
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !349, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.value(metadata i8* %6, metadata !355, metadata !DIExpression()), !dbg !359
  call void @llvm.dbg.value(metadata i8* %56, metadata !358, metadata !DIExpression()), !dbg !359
  %78 = getelementptr inbounds i8, i8* %56, i64 20, !dbg !364
  %79 = icmp ugt i8* %78, %6, !dbg !366
  br i1 %79, label %98, label %80, !dbg !367

80:                                               ; preds = %77
  %81 = getelementptr inbounds i8, i8* %56, i64 12, !dbg !368
  %82 = bitcast i8* %81 to i16*, !dbg !368
  %83 = load i16, i16* %82, align 4, !dbg !368
  %84 = lshr i16 %83, 2, !dbg !369
  %85 = and i16 %84, 60, !dbg !369
  call void @llvm.dbg.value(metadata i16 %85, metadata !357, metadata !DIExpression()), !dbg !359
  %86 = icmp ult i16 %85, 20, !dbg !370
  br i1 %86, label %98, label %87, !dbg !372

87:                                               ; preds = %80
  %88 = zext i16 %85 to i64, !dbg !373
  %89 = getelementptr i8, i8* %56, i64 %88, !dbg !374
  %90 = icmp ugt i8* %89, %6, !dbg !376
  br i1 %90, label %98, label %91, !dbg !377

91:                                               ; preds = %87
  call void @llvm.dbg.value(metadata i8* %89, metadata !193, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.value(metadata i8* %56, metadata !169, metadata !DIExpression()), !dbg !199
  %92 = getelementptr inbounds i8, i8* %56, i64 2, !dbg !378
  %93 = bitcast i8* %92 to i16*, !dbg !378
  %94 = load i16, i16* %93, align 2, !dbg !378, !tbaa !379
  %95 = tail call i16 @llvm.bswap.i16(i16 %94)
  %96 = add i16 %95, -1, !dbg !378
  %97 = tail call i16 @llvm.bswap.i16(i16 %96), !dbg !378
  store i16 %97, i16* %93, align 2, !dbg !381, !tbaa !379
  br label %98, !dbg !382

98:                                               ; preds = %87, %80, %77, %64, %59, %49, %45, %40, %37, %1, %54, %34, %70, %91
  %99 = phi i32 [ 2, %70 ], [ 2, %91 ], [ 2, %34 ], [ 2, %54 ], [ 0, %1 ], [ 2, %37 ], [ 2, %40 ], [ 2, %45 ], [ 2, %49 ], [ 0, %59 ], [ 0, %64 ], [ 0, %77 ], [ 0, %80 ], [ 0, %87 ], !dbg !199
  call void @llvm.dbg.value(metadata i32 %99, metadata !92, metadata !DIExpression()), !dbg !199
  call void @llvm.dbg.label(metadata !198), !dbg !383
  %100 = bitcast i32* %2 to i8*, !dbg !384
  call void @llvm.lifetime.start.p0i8(i64 4, i8* nonnull %100), !dbg !384
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !389, metadata !DIExpression()) #3, !dbg !384
  call void @llvm.dbg.value(metadata i32 %99, metadata !390, metadata !DIExpression()) #3, !dbg !384
  store i32 %99, i32* %2, align 4, !tbaa !401
  call void @llvm.dbg.value(metadata i32* %2, metadata !390, metadata !DIExpression(DW_OP_deref)) #3, !dbg !384
  %101 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*), i8* nonnull %100) #3, !dbg !402
  call void @llvm.dbg.value(metadata i8* %101, metadata !391, metadata !DIExpression()) #3, !dbg !384
  %102 = icmp eq i8* %101, null, !dbg !403
  br i1 %102, label %116, label %103, !dbg !405

103:                                              ; preds = %98
  call void @llvm.dbg.value(metadata i8* %101, metadata !391, metadata !DIExpression()) #3, !dbg !384
  %104 = bitcast i8* %101 to i64*, !dbg !406
  %105 = load i64, i64* %104, align 8, !dbg !407, !tbaa !408
  %106 = add i64 %105, 1, !dbg !407
  store i64 %106, i64* %104, align 8, !dbg !407, !tbaa !408
  %107 = load i32, i32* %3, align 4, !dbg !411, !tbaa !201
  %108 = load i32, i32* %7, align 4, !dbg !412, !tbaa !209
  %109 = sub i32 %107, %108, !dbg !413
  %110 = zext i32 %109 to i64, !dbg !414
  %111 = getelementptr inbounds i8, i8* %101, i64 8, !dbg !415
  %112 = bitcast i8* %111 to i64*, !dbg !415
  %113 = load i64, i64* %112, align 8, !dbg !416, !tbaa !417
  %114 = add i64 %113, %110, !dbg !416
  store i64 %114, i64* %112, align 8, !dbg !416, !tbaa !417
  %115 = load i32, i32* %2, align 4, !dbg !418, !tbaa !401
  call void @llvm.dbg.value(metadata i32 %115, metadata !390, metadata !DIExpression()) #3, !dbg !384
  br label %116, !dbg !419

116:                                              ; preds = %98, %103
  %117 = phi i32 [ %115, %103 ], [ 0, %98 ], !dbg !384
  call void @llvm.lifetime.end.p0i8(i64 4, i8* nonnull %100), !dbg !420
  ret i32 %117, !dbg !421
}

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #2

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #2

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind willreturn }
attributes #2 = { nounwind readnone speculatable willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!73, !74, !75}
!llvm.ident = !{!76}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !64, line: 16, type: !65, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !49, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/albert/Desktop/eBPF_code")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "Documents/TMA_Project/headers/linux/bpf.h", directory: "/home/albert")
!7 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!8 = !{!9, !10, !11, !12, !13}
!9 = !DIEnumerator(name: "XDP_ABORTED", value: 0, isUnsigned: true)
!10 = !DIEnumerator(name: "XDP_DROP", value: 1, isUnsigned: true)
!11 = !DIEnumerator(name: "XDP_PASS", value: 2, isUnsigned: true)
!12 = !DIEnumerator(name: "XDP_TX", value: 3, isUnsigned: true)
!13 = !DIEnumerator(name: "XDP_REDIRECT", value: 4, isUnsigned: true)
!14 = !DICompositeType(tag: DW_TAG_enumeration_type, file: !15, line: 28, baseType: !7, size: 32, elements: !16)
!15 = !DIFile(filename: "/usr/include/linux/in.h", directory: "")
!16 = !{!17, !18, !19, !20, !21, !22, !23, !24, !25, !26, !27, !28, !29, !30, !31, !32, !33, !34, !35, !36, !37, !38, !39, !40, !41, !42}
!17 = !DIEnumerator(name: "IPPROTO_IP", value: 0, isUnsigned: true)
!18 = !DIEnumerator(name: "IPPROTO_ICMP", value: 1, isUnsigned: true)
!19 = !DIEnumerator(name: "IPPROTO_IGMP", value: 2, isUnsigned: true)
!20 = !DIEnumerator(name: "IPPROTO_IPIP", value: 4, isUnsigned: true)
!21 = !DIEnumerator(name: "IPPROTO_TCP", value: 6, isUnsigned: true)
!22 = !DIEnumerator(name: "IPPROTO_EGP", value: 8, isUnsigned: true)
!23 = !DIEnumerator(name: "IPPROTO_PUP", value: 12, isUnsigned: true)
!24 = !DIEnumerator(name: "IPPROTO_UDP", value: 17, isUnsigned: true)
!25 = !DIEnumerator(name: "IPPROTO_IDP", value: 22, isUnsigned: true)
!26 = !DIEnumerator(name: "IPPROTO_TP", value: 29, isUnsigned: true)
!27 = !DIEnumerator(name: "IPPROTO_DCCP", value: 33, isUnsigned: true)
!28 = !DIEnumerator(name: "IPPROTO_IPV6", value: 41, isUnsigned: true)
!29 = !DIEnumerator(name: "IPPROTO_RSVP", value: 46, isUnsigned: true)
!30 = !DIEnumerator(name: "IPPROTO_GRE", value: 47, isUnsigned: true)
!31 = !DIEnumerator(name: "IPPROTO_ESP", value: 50, isUnsigned: true)
!32 = !DIEnumerator(name: "IPPROTO_AH", value: 51, isUnsigned: true)
!33 = !DIEnumerator(name: "IPPROTO_MTP", value: 92, isUnsigned: true)
!34 = !DIEnumerator(name: "IPPROTO_BEETPH", value: 94, isUnsigned: true)
!35 = !DIEnumerator(name: "IPPROTO_ENCAP", value: 98, isUnsigned: true)
!36 = !DIEnumerator(name: "IPPROTO_PIM", value: 103, isUnsigned: true)
!37 = !DIEnumerator(name: "IPPROTO_COMP", value: 108, isUnsigned: true)
!38 = !DIEnumerator(name: "IPPROTO_SCTP", value: 132, isUnsigned: true)
!39 = !DIEnumerator(name: "IPPROTO_UDPLITE", value: 136, isUnsigned: true)
!40 = !DIEnumerator(name: "IPPROTO_MPLS", value: 137, isUnsigned: true)
!41 = !DIEnumerator(name: "IPPROTO_RAW", value: 255, isUnsigned: true)
!42 = !DIEnumerator(name: "IPPROTO_MAX", value: 256, isUnsigned: true)
!43 = !{!44, !45, !46}
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!45 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u16", file: !47, line: 24, baseType: !48)
!47 = !DIFile(filename: "/usr/include/asm-generic/int-ll64.h", directory: "")
!48 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!49 = !{!0, !50, !56}
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 111, type: !52, isLocal: false, isDefinition: true)
!52 = !DICompositeType(tag: DW_TAG_array_type, baseType: !53, size: 32, elements: !54)
!53 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!54 = !{!55}
!55 = !DISubrange(count: 4)
!56 = !DIGlobalVariableExpression(var: !57, expr: !DIExpression())
!57 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !58, line: 33, type: !59, isLocal: true, isDefinition: true)
!58 = !DIFile(filename: "Documents/TMA_Project/libbpf/src/build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/albert")
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!60 = !DISubroutineType(types: !61)
!61 = !{!44, !44, !62}
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !63, size: 64)
!63 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!64 = !DIFile(filename: "././common/xdp_stats_kern.h", directory: "/home/albert/Desktop/eBPF_code")
!65 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !66, line: 33, size: 160, elements: !67)
!66 = !DIFile(filename: "Documents/TMA_Project/libbpf/src/build/usr/include/bpf/bpf_helpers.h", directory: "/home/albert")
!67 = !{!68, !69, !70, !71, !72}
!68 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !65, file: !66, line: 34, baseType: !7, size: 32)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !65, file: !66, line: 35, baseType: !7, size: 32, offset: 32)
!70 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !65, file: !66, line: 36, baseType: !7, size: 32, offset: 64)
!71 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !65, file: !66, line: 37, baseType: !7, size: 32, offset: 96)
!72 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !65, file: !66, line: 38, baseType: !7, size: 32, offset: 128)
!73 = !{i32 7, !"Dwarf Version", i32 4}
!74 = !{i32 2, !"Debug Info Version", i32 3}
!75 = !{i32 1, !"wchar_size", i32 4}
!76 = !{!"clang version 10.0.0-4ubuntu1 "}
!77 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 64, type: !78, scopeLine: 65, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !90)
!78 = !DISubroutineType(types: !79)
!79 = !{!80, !81}
!80 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !83)
!83 = !{!84, !86, !87, !88, !89}
!84 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !82, file: !6, line: 2857, baseType: !85, size: 32)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!86 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !82, file: !6, line: 2858, baseType: !85, size: 32, offset: 32)
!87 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !82, file: !6, line: 2859, baseType: !85, size: 32, offset: 64)
!88 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !82, file: !6, line: 2861, baseType: !85, size: 32, offset: 96)
!89 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !82, file: !6, line: 2862, baseType: !85, size: 32, offset: 128)
!90 = !{!91, !92, !93, !94, !95, !109, !128, !160, !169, !191, !192, !193, !198}
!91 = !DILocalVariable(name: "ctx", arg: 1, scope: !77, file: !3, line: 64, type: !81)
!92 = !DILocalVariable(name: "action", scope: !77, file: !3, line: 66, type: !85)
!93 = !DILocalVariable(name: "eth_type", scope: !77, file: !3, line: 67, type: !80)
!94 = !DILocalVariable(name: "ip_type", scope: !77, file: !3, line: 67, type: !80)
!95 = !DILocalVariable(name: "eth", scope: !77, file: !3, line: 68, type: !96)
!96 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !97, size: 64)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !98, line: 163, size: 112, elements: !99)
!98 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!99 = !{!100, !105, !106}
!100 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !97, file: !98, line: 164, baseType: !101, size: 48)
!101 = !DICompositeType(tag: DW_TAG_array_type, baseType: !102, size: 48, elements: !103)
!102 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!103 = !{!104}
!104 = !DISubrange(count: 6)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !97, file: !98, line: 165, baseType: !101, size: 48, offset: 48)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !97, file: !98, line: 166, baseType: !107, size: 16, offset: 96)
!107 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !108, line: 25, baseType: !46)
!108 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!109 = !DILocalVariable(name: "iphdr", scope: !77, file: !3, line: 69, type: !110)
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !111, size: 64)
!111 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !112, line: 86, size: 160, elements: !113)
!112 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!113 = !{!114, !116, !117, !118, !119, !120, !121, !122, !123, !125, !127}
!114 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !111, file: !112, line: 88, baseType: !115, size: 4, flags: DIFlagBitField, extraData: i64 0)
!115 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !102)
!116 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !111, file: !112, line: 89, baseType: !115, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!117 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !111, file: !112, line: 96, baseType: !115, size: 8, offset: 8)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !111, file: !112, line: 97, baseType: !107, size: 16, offset: 16)
!119 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !111, file: !112, line: 98, baseType: !107, size: 16, offset: 32)
!120 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !111, file: !112, line: 99, baseType: !107, size: 16, offset: 48)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !111, file: !112, line: 100, baseType: !115, size: 8, offset: 64)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !111, file: !112, line: 101, baseType: !115, size: 8, offset: 72)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !111, file: !112, line: 102, baseType: !124, size: 16, offset: 80)
!124 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !108, line: 31, baseType: !46)
!125 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !111, file: !112, line: 103, baseType: !126, size: 32, offset: 96)
!126 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !108, line: 27, baseType: !85)
!127 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !111, file: !112, line: 104, baseType: !126, size: 32, offset: 128)
!128 = !DILocalVariable(name: "ipv6hdr", scope: !77, file: !3, line: 70, type: !129)
!129 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !130, size: 64)
!130 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ipv6hdr", file: !131, line: 116, size: 320, elements: !132)
!131 = !DIFile(filename: "/usr/include/linux/ipv6.h", directory: "")
!132 = !{!133, !134, !135, !139, !140, !141, !142, !159}
!133 = !DIDerivedType(tag: DW_TAG_member, name: "priority", scope: !130, file: !131, line: 118, baseType: !115, size: 4, flags: DIFlagBitField, extraData: i64 0)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !130, file: !131, line: 119, baseType: !115, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "flow_lbl", scope: !130, file: !131, line: 126, baseType: !136, size: 24, offset: 8)
!136 = !DICompositeType(tag: DW_TAG_array_type, baseType: !115, size: 24, elements: !137)
!137 = !{!138}
!138 = !DISubrange(count: 3)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "payload_len", scope: !130, file: !131, line: 128, baseType: !107, size: 16, offset: 32)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "nexthdr", scope: !130, file: !131, line: 129, baseType: !115, size: 8, offset: 48)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "hop_limit", scope: !130, file: !131, line: 130, baseType: !115, size: 8, offset: 56)
!142 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !130, file: !131, line: 132, baseType: !143, size: 128, offset: 64)
!143 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "in6_addr", file: !144, line: 33, size: 128, elements: !145)
!144 = !DIFile(filename: "/usr/include/linux/in6.h", directory: "")
!145 = !{!146}
!146 = !DIDerivedType(tag: DW_TAG_member, name: "in6_u", scope: !143, file: !144, line: 40, baseType: !147, size: 128)
!147 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !143, file: !144, line: 34, size: 128, elements: !148)
!148 = !{!149, !153, !157}
!149 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr8", scope: !147, file: !144, line: 35, baseType: !150, size: 128)
!150 = !DICompositeType(tag: DW_TAG_array_type, baseType: !115, size: 128, elements: !151)
!151 = !{!152}
!152 = !DISubrange(count: 16)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr16", scope: !147, file: !144, line: 37, baseType: !154, size: 128)
!154 = !DICompositeType(tag: DW_TAG_array_type, baseType: !107, size: 128, elements: !155)
!155 = !{!156}
!156 = !DISubrange(count: 8)
!157 = !DIDerivedType(tag: DW_TAG_member, name: "u6_addr32", scope: !147, file: !144, line: 38, baseType: !158, size: 128)
!158 = !DICompositeType(tag: DW_TAG_array_type, baseType: !126, size: 128, elements: !54)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !130, file: !131, line: 133, baseType: !143, size: 128, offset: 192)
!160 = !DILocalVariable(name: "udphdr", scope: !77, file: !3, line: 71, type: !161)
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !163, line: 23, size: 64, elements: !164)
!163 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "")
!164 = !{!165, !166, !167, !168}
!165 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !162, file: !163, line: 24, baseType: !107, size: 16)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !162, file: !163, line: 25, baseType: !107, size: 16, offset: 16)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !162, file: !163, line: 26, baseType: !107, size: 16, offset: 32)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !162, file: !163, line: 27, baseType: !124, size: 16, offset: 48)
!169 = !DILocalVariable(name: "tcphdr", scope: !77, file: !3, line: 72, type: !170)
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !171, size: 64)
!171 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !172, line: 25, size: 160, elements: !173)
!172 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "")
!173 = !{!174, !175, !176, !177, !178, !179, !180, !181, !182, !183, !184, !185, !186, !187, !188, !189, !190}
!174 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !171, file: !172, line: 26, baseType: !107, size: 16)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !171, file: !172, line: 27, baseType: !107, size: 16, offset: 16)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !171, file: !172, line: 28, baseType: !126, size: 32, offset: 32)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !171, file: !172, line: 29, baseType: !126, size: 32, offset: 64)
!178 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !171, file: !172, line: 31, baseType: !46, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!179 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !171, file: !172, line: 32, baseType: !46, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!180 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !171, file: !172, line: 33, baseType: !46, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!181 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !171, file: !172, line: 34, baseType: !46, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!182 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !171, file: !172, line: 35, baseType: !46, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!183 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !171, file: !172, line: 36, baseType: !46, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!184 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !171, file: !172, line: 37, baseType: !46, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!185 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !171, file: !172, line: 38, baseType: !46, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!186 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !171, file: !172, line: 39, baseType: !46, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!187 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !171, file: !172, line: 40, baseType: !46, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!188 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !171, file: !172, line: 55, baseType: !107, size: 16, offset: 112)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !171, file: !172, line: 56, baseType: !124, size: 16, offset: 128)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !171, file: !172, line: 57, baseType: !107, size: 16, offset: 144)
!191 = !DILocalVariable(name: "data_end", scope: !77, file: !3, line: 73, type: !44)
!192 = !DILocalVariable(name: "data", scope: !77, file: !3, line: 74, type: !44)
!193 = !DILocalVariable(name: "nh", scope: !77, file: !3, line: 75, type: !194)
!194 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !195, line: 33, size: 64, elements: !196)
!195 = !DIFile(filename: "././common/parsing_helpers.h", directory: "/home/albert/Desktop/eBPF_code")
!196 = !{!197}
!197 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !194, file: !195, line: 34, baseType: !44, size: 64)
!198 = !DILabel(scope: !77, name: "out", file: !3, line: 107)
!199 = !DILocation(line: 0, scope: !77)
!200 = !DILocation(line: 73, column: 38, scope: !77)
!201 = !{!202, !203, i64 4}
!202 = !{!"xdp_md", !203, i64 0, !203, i64 4, !203, i64 8, !203, i64 12, !203, i64 16}
!203 = !{!"int", !204, i64 0}
!204 = !{!"omnipotent char", !205, i64 0}
!205 = !{!"Simple C/C++ TBAA"}
!206 = !DILocation(line: 73, column: 27, scope: !77)
!207 = !DILocation(line: 73, column: 19, scope: !77)
!208 = !DILocation(line: 74, column: 34, scope: !77)
!209 = !{!202, !203, i64 0}
!210 = !DILocation(line: 74, column: 23, scope: !77)
!211 = !DILocation(line: 74, column: 15, scope: !77)
!212 = !DILocalVariable(name: "nh", arg: 1, scope: !213, file: !195, line: 124, type: !216)
!213 = distinct !DISubprogram(name: "parse_ethhdr", scope: !195, file: !195, line: 124, type: !214, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !218)
!214 = !DISubroutineType(types: !215)
!215 = !{!80, !216, !44, !217}
!216 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !194, size: 64)
!217 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !96, size: 64)
!218 = !{!212, !219, !220}
!219 = !DILocalVariable(name: "data_end", arg: 2, scope: !213, file: !195, line: 125, type: !44)
!220 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !213, file: !195, line: 126, type: !217)
!221 = !DILocation(line: 0, scope: !213, inlinedAt: !222)
!222 = distinct !DILocation(line: 77, column: 13, scope: !77)
!223 = !DILocalVariable(name: "nh", arg: 1, scope: !224, file: !195, line: 79, type: !216)
!224 = distinct !DISubprogram(name: "parse_ethhdr_vlan", scope: !195, file: !195, line: 79, type: !225, scopeLine: 83, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !234)
!225 = !DISubroutineType(types: !226)
!226 = !{!80, !216, !44, !217, !227}
!227 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !228, size: 64)
!228 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "collect_vlans", file: !195, line: 64, size: 32, elements: !229)
!229 = !{!230}
!230 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !228, file: !195, line: 65, baseType: !231, size: 32)
!231 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 32, elements: !232)
!232 = !{!233}
!233 = !DISubrange(count: 2)
!234 = !{!223, !235, !236, !237, !238, !239, !240, !246, !247}
!235 = !DILocalVariable(name: "data_end", arg: 2, scope: !224, file: !195, line: 80, type: !44)
!236 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !224, file: !195, line: 81, type: !217)
!237 = !DILocalVariable(name: "vlans", arg: 4, scope: !224, file: !195, line: 82, type: !227)
!238 = !DILocalVariable(name: "eth", scope: !224, file: !195, line: 84, type: !96)
!239 = !DILocalVariable(name: "hdrsize", scope: !224, file: !195, line: 85, type: !80)
!240 = !DILocalVariable(name: "vlh", scope: !224, file: !195, line: 86, type: !241)
!241 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !242, size: 64)
!242 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !195, line: 42, size: 32, elements: !243)
!243 = !{!244, !245}
!244 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !242, file: !195, line: 43, baseType: !107, size: 16)
!245 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !242, file: !195, line: 44, baseType: !107, size: 16, offset: 16)
!246 = !DILocalVariable(name: "h_proto", scope: !224, file: !195, line: 87, type: !46)
!247 = !DILocalVariable(name: "i", scope: !224, file: !195, line: 88, type: !80)
!248 = !DILocation(line: 0, scope: !224, inlinedAt: !249)
!249 = distinct !DILocation(line: 129, column: 9, scope: !213, inlinedAt: !222)
!250 = !DILocation(line: 93, column: 14, scope: !251, inlinedAt: !249)
!251 = distinct !DILexicalBlock(scope: !224, file: !195, line: 93, column: 6)
!252 = !DILocation(line: 93, column: 24, scope: !251, inlinedAt: !249)
!253 = !DILocation(line: 93, column: 6, scope: !224, inlinedAt: !249)
!254 = !DILocation(line: 99, column: 17, scope: !224, inlinedAt: !249)
!255 = !{!256, !256, i64 0}
!256 = !{!"short", !204, i64 0}
!257 = !DILocation(line: 0, scope: !258, inlinedAt: !249)
!258 = distinct !DILexicalBlock(scope: !259, file: !195, line: 109, column: 7)
!259 = distinct !DILexicalBlock(scope: !260, file: !195, line: 105, column: 39)
!260 = distinct !DILexicalBlock(scope: !261, file: !195, line: 105, column: 2)
!261 = distinct !DILexicalBlock(scope: !224, file: !195, line: 105, column: 2)
!262 = !DILocation(line: 105, column: 2, scope: !261, inlinedAt: !249)
!263 = !DILocation(line: 106, column: 7, scope: !259, inlinedAt: !249)
!264 = !DILocation(line: 109, column: 11, scope: !258, inlinedAt: !249)
!265 = !DILocation(line: 109, column: 15, scope: !258, inlinedAt: !249)
!266 = !DILocation(line: 109, column: 7, scope: !259, inlinedAt: !249)
!267 = !DILocation(line: 112, column: 18, scope: !259, inlinedAt: !249)
!268 = !DILocation(line: 83, column: 6, scope: !77)
!269 = !DILocalVariable(name: "nh", arg: 1, scope: !270, file: !195, line: 151, type: !216)
!270 = distinct !DISubprogram(name: "parse_iphdr", scope: !195, file: !195, line: 151, type: !271, scopeLine: 154, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !274)
!271 = !DISubroutineType(types: !272)
!272 = !{!80, !216, !44, !273}
!273 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !110, size: 64)
!274 = !{!269, !275, !276, !277, !278}
!275 = !DILocalVariable(name: "data_end", arg: 2, scope: !270, file: !195, line: 152, type: !44)
!276 = !DILocalVariable(name: "iphdr", arg: 3, scope: !270, file: !195, line: 153, type: !273)
!277 = !DILocalVariable(name: "iph", scope: !270, file: !195, line: 155, type: !110)
!278 = !DILocalVariable(name: "hdrsize", scope: !270, file: !195, line: 156, type: !80)
!279 = !DILocation(line: 0, scope: !270, inlinedAt: !280)
!280 = distinct !DILocation(line: 84, column: 13, scope: !281)
!281 = distinct !DILexicalBlock(scope: !282, file: !3, line: 83, column: 39)
!282 = distinct !DILexicalBlock(scope: !77, file: !3, line: 83, column: 6)
!283 = !DILocation(line: 158, column: 10, scope: !284, inlinedAt: !280)
!284 = distinct !DILexicalBlock(scope: !270, file: !195, line: 158, column: 6)
!285 = !DILocation(line: 158, column: 14, scope: !284, inlinedAt: !280)
!286 = !DILocation(line: 158, column: 6, scope: !270, inlinedAt: !280)
!287 = !DILocation(line: 161, column: 17, scope: !270, inlinedAt: !280)
!288 = !DILocation(line: 161, column: 21, scope: !270, inlinedAt: !280)
!289 = !DILocation(line: 163, column: 13, scope: !290, inlinedAt: !280)
!290 = distinct !DILexicalBlock(scope: !270, file: !195, line: 163, column: 5)
!291 = !DILocation(line: 163, column: 5, scope: !270, inlinedAt: !280)
!292 = !DILocation(line: 163, column: 5, scope: !290, inlinedAt: !280)
!293 = !DILocation(line: 167, column: 14, scope: !294, inlinedAt: !280)
!294 = distinct !DILexicalBlock(scope: !270, file: !195, line: 167, column: 6)
!295 = !DILocation(line: 167, column: 24, scope: !294, inlinedAt: !280)
!296 = !DILocation(line: 167, column: 6, scope: !270, inlinedAt: !280)
!297 = !DILocalVariable(name: "nh", arg: 1, scope: !298, file: !195, line: 132, type: !216)
!298 = distinct !DISubprogram(name: "parse_ip6hdr", scope: !195, file: !195, line: 132, type: !299, scopeLine: 135, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !302)
!299 = !DISubroutineType(types: !300)
!300 = !{!80, !216, !44, !301}
!301 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !129, size: 64)
!302 = !{!297, !303, !304, !305}
!303 = !DILocalVariable(name: "data_end", arg: 2, scope: !298, file: !195, line: 133, type: !44)
!304 = !DILocalVariable(name: "ip6hdr", arg: 3, scope: !298, file: !195, line: 134, type: !301)
!305 = !DILocalVariable(name: "ip6h", scope: !298, file: !195, line: 136, type: !129)
!306 = !DILocation(line: 0, scope: !298, inlinedAt: !307)
!307 = distinct !DILocation(line: 86, column: 13, scope: !308)
!308 = distinct !DILexicalBlock(scope: !309, file: !3, line: 85, column: 48)
!309 = distinct !DILexicalBlock(scope: !282, file: !3, line: 85, column: 13)
!310 = !DILocation(line: 142, column: 11, scope: !311, inlinedAt: !307)
!311 = distinct !DILexicalBlock(scope: !298, file: !195, line: 142, column: 6)
!312 = !DILocation(line: 142, column: 17, scope: !311, inlinedAt: !307)
!313 = !DILocation(line: 142, column: 15, scope: !311, inlinedAt: !307)
!314 = !DILocation(line: 142, column: 6, scope: !298, inlinedAt: !307)
!315 = !DILocation(line: 75, column: 25, scope: !77)
!316 = !DILocation(line: 0, scope: !282)
!317 = !{!204, !204, i64 0}
!318 = !DILocation(line: 91, column: 6, scope: !77)
!319 = !DILocalVariable(name: "nh", arg: 1, scope: !320, file: !195, line: 224, type: !216)
!320 = distinct !DISubprogram(name: "parse_udphdr", scope: !195, file: !195, line: 224, type: !321, scopeLine: 227, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !324)
!321 = !DISubroutineType(types: !322)
!322 = !{!80, !216, !44, !323}
!323 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !161, size: 64)
!324 = !{!319, !325, !326, !327, !328}
!325 = !DILocalVariable(name: "data_end", arg: 2, scope: !320, file: !195, line: 225, type: !44)
!326 = !DILocalVariable(name: "udphdr", arg: 3, scope: !320, file: !195, line: 226, type: !323)
!327 = !DILocalVariable(name: "len", scope: !320, file: !195, line: 228, type: !80)
!328 = !DILocalVariable(name: "h", scope: !320, file: !195, line: 229, type: !161)
!329 = !DILocation(line: 0, scope: !320, inlinedAt: !330)
!330 = distinct !DILocation(line: 92, column: 7, scope: !331)
!331 = distinct !DILexicalBlock(scope: !332, file: !3, line: 92, column: 7)
!332 = distinct !DILexicalBlock(scope: !333, file: !3, line: 91, column: 30)
!333 = distinct !DILexicalBlock(scope: !77, file: !3, line: 91, column: 6)
!334 = !DILocation(line: 231, column: 8, scope: !335, inlinedAt: !330)
!335 = distinct !DILexicalBlock(scope: !320, file: !195, line: 231, column: 6)
!336 = !DILocation(line: 231, column: 14, scope: !335, inlinedAt: !330)
!337 = !DILocation(line: 231, column: 12, scope: !335, inlinedAt: !330)
!338 = !DILocation(line: 231, column: 6, scope: !320, inlinedAt: !330)
!339 = !DILocation(line: 237, column: 8, scope: !320, inlinedAt: !330)
!340 = !{!341, !256, i64 4}
!341 = !{!"udphdr", !256, i64 0, !256, i64 2, !256, i64 4, !256, i64 6}
!342 = !DILocation(line: 238, column: 10, scope: !343, inlinedAt: !330)
!343 = distinct !DILexicalBlock(scope: !320, file: !195, line: 238, column: 6)
!344 = !DILocation(line: 238, column: 6, scope: !320, inlinedAt: !330)
!345 = !DILocation(line: 96, column: 18, scope: !332)
!346 = !{!341, !256, i64 2}
!347 = !DILocation(line: 96, column: 16, scope: !332)
!348 = !DILocation(line: 97, column: 2, scope: !332)
!349 = !DILocalVariable(name: "nh", arg: 1, scope: !350, file: !195, line: 247, type: !216)
!350 = distinct !DISubprogram(name: "parse_tcphdr", scope: !195, file: !195, line: 247, type: !351, scopeLine: 250, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !354)
!351 = !DISubroutineType(types: !352)
!352 = !{!80, !216, !44, !353}
!353 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !170, size: 64)
!354 = !{!349, !355, !356, !357, !358}
!355 = !DILocalVariable(name: "data_end", arg: 2, scope: !350, file: !195, line: 248, type: !44)
!356 = !DILocalVariable(name: "tcphdr", arg: 3, scope: !350, file: !195, line: 249, type: !353)
!357 = !DILocalVariable(name: "len", scope: !350, file: !195, line: 251, type: !80)
!358 = !DILocalVariable(name: "h", scope: !350, file: !195, line: 252, type: !170)
!359 = !DILocation(line: 0, scope: !350, inlinedAt: !360)
!360 = distinct !DILocation(line: 98, column: 7, scope: !361)
!361 = distinct !DILexicalBlock(scope: !362, file: !3, line: 98, column: 7)
!362 = distinct !DILexicalBlock(scope: !363, file: !3, line: 97, column: 37)
!363 = distinct !DILexicalBlock(scope: !333, file: !3, line: 97, column: 13)
!364 = !DILocation(line: 254, column: 8, scope: !365, inlinedAt: !360)
!365 = distinct !DILexicalBlock(scope: !350, file: !195, line: 254, column: 6)
!366 = !DILocation(line: 254, column: 12, scope: !365, inlinedAt: !360)
!367 = !DILocation(line: 254, column: 6, scope: !350, inlinedAt: !360)
!368 = !DILocation(line: 257, column: 11, scope: !350, inlinedAt: !360)
!369 = !DILocation(line: 257, column: 16, scope: !350, inlinedAt: !360)
!370 = !DILocation(line: 259, column: 9, scope: !371, inlinedAt: !360)
!371 = distinct !DILexicalBlock(scope: !350, file: !195, line: 259, column: 5)
!372 = !DILocation(line: 259, column: 5, scope: !350, inlinedAt: !360)
!373 = !DILocation(line: 259, column: 5, scope: !371, inlinedAt: !360)
!374 = !DILocation(line: 263, column: 14, scope: !375, inlinedAt: !360)
!375 = distinct !DILexicalBlock(scope: !350, file: !195, line: 263, column: 6)
!376 = !DILocation(line: 263, column: 20, scope: !375, inlinedAt: !360)
!377 = !DILocation(line: 263, column: 6, scope: !350, inlinedAt: !360)
!378 = !DILocation(line: 102, column: 18, scope: !362)
!379 = !{!380, !256, i64 2}
!380 = !{!"tcphdr", !256, i64 0, !256, i64 2, !203, i64 4, !203, i64 8, !256, i64 12, !256, i64 12, !256, i64 13, !256, i64 13, !256, i64 13, !256, i64 13, !256, i64 13, !256, i64 13, !256, i64 13, !256, i64 13, !256, i64 14, !256, i64 16, !256, i64 18}
!381 = !DILocation(line: 102, column: 16, scope: !362)
!382 = !DILocation(line: 103, column: 2, scope: !362)
!383 = !DILocation(line: 107, column: 1, scope: !77)
!384 = !DILocation(line: 0, scope: !385, inlinedAt: !400)
!385 = distinct !DISubprogram(name: "xdp_stats_record_action", scope: !64, file: !64, line: 24, type: !386, scopeLine: 25, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !388)
!386 = !DISubroutineType(types: !387)
!387 = !{!85, !81, !85}
!388 = !{!389, !390, !391}
!389 = !DILocalVariable(name: "ctx", arg: 1, scope: !385, file: !64, line: 24, type: !81)
!390 = !DILocalVariable(name: "action", arg: 2, scope: !385, file: !64, line: 24, type: !85)
!391 = !DILocalVariable(name: "rec", scope: !385, file: !64, line: 30, type: !392)
!392 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !393, size: 64)
!393 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "datarec", file: !394, line: 10, size: 128, elements: !395)
!394 = !DIFile(filename: "././common/xdp_stats_kern_user.h", directory: "/home/albert/Desktop/eBPF_code")
!395 = !{!396, !399}
!396 = !DIDerivedType(tag: DW_TAG_member, name: "rx_packets", scope: !393, file: !394, line: 11, baseType: !397, size: 64)
!397 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !398)
!398 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!399 = !DIDerivedType(tag: DW_TAG_member, name: "rx_bytes", scope: !393, file: !394, line: 12, baseType: !397, size: 64, offset: 64)
!400 = distinct !DILocation(line: 108, column: 9, scope: !77)
!401 = !{!203, !203, i64 0}
!402 = !DILocation(line: 30, column: 24, scope: !385, inlinedAt: !400)
!403 = !DILocation(line: 31, column: 7, scope: !404, inlinedAt: !400)
!404 = distinct !DILexicalBlock(scope: !385, file: !64, line: 31, column: 6)
!405 = !DILocation(line: 31, column: 6, scope: !385, inlinedAt: !400)
!406 = !DILocation(line: 38, column: 7, scope: !385, inlinedAt: !400)
!407 = !DILocation(line: 38, column: 17, scope: !385, inlinedAt: !400)
!408 = !{!409, !410, i64 0}
!409 = !{!"datarec", !410, i64 0, !410, i64 8}
!410 = !{!"long long", !204, i64 0}
!411 = !DILocation(line: 39, column: 25, scope: !385, inlinedAt: !400)
!412 = !DILocation(line: 39, column: 41, scope: !385, inlinedAt: !400)
!413 = !DILocation(line: 39, column: 34, scope: !385, inlinedAt: !400)
!414 = !DILocation(line: 39, column: 19, scope: !385, inlinedAt: !400)
!415 = !DILocation(line: 39, column: 7, scope: !385, inlinedAt: !400)
!416 = !DILocation(line: 39, column: 16, scope: !385, inlinedAt: !400)
!417 = !{!409, !410, i64 8}
!418 = !DILocation(line: 41, column: 9, scope: !385, inlinedAt: !400)
!419 = !DILocation(line: 41, column: 2, scope: !385, inlinedAt: !400)
!420 = !DILocation(line: 42, column: 1, scope: !385, inlinedAt: !400)
!421 = !DILocation(line: 108, column: 2, scope: !77)
