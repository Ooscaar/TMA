; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.flow = type { i32, i32, i16, i16, i8 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.collect_vlans = type { [2 x i16] }
%struct.vlan_hdr = type { i16, i16 }
%struct.udphdr = type { i16, i16, i16, i16 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@xdp_flow_map = dso_local global %struct.bpf_map_def { i32 1, i32 16, i32 4, i32 1000, i32 0 }, section "maps", align 4, !dbg !50
@__const.xdp_pass_func.____fmt = private unnamed_addr constant [25 x i8] c"Looking up eBPF element\0A\00", align 1
@__const.xdp_pass_func.____fmt.1 = private unnamed_addr constant [44 x i8] c"writing in the new element of the eBPF map\0A\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !60
@llvm.used = appending global [4 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @xdp_flow_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readonly %0) #0 section "xdp_program" !dbg !95 {
  %2 = alloca %struct.flow, align 4
  %3 = alloca [25 x i8], align 1
  %4 = alloca i32, align 4
  %5 = alloca [44 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !107, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i32 2, metadata !108, metadata !DIExpression()), !dbg !209
  %6 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !210
  %7 = load i32, i32* %6, align 4, !dbg !210, !tbaa !211
  %8 = zext i32 %7 to i64, !dbg !216
  %9 = inttoptr i64 %8 to i8*, !dbg !217
  call void @llvm.dbg.value(metadata i8* %9, metadata !175, metadata !DIExpression()), !dbg !209
  %10 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !218
  %11 = load i32, i32* %10, align 4, !dbg !218, !tbaa !219
  %12 = zext i32 %11 to i64, !dbg !220
  %13 = inttoptr i64 %12 to i8*, !dbg !221
  call void @llvm.dbg.value(metadata i8* %13, metadata !176, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i8* %13, metadata !177, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !111, metadata !DIExpression(DW_OP_deref)), !dbg !209
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !222, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata i8* %9, metadata !229, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !230, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !233, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i8* %9, metadata !245, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !246, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !247, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i8* %13, metadata !248, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i32 14, metadata !249, metadata !DIExpression()), !dbg !258
  %14 = getelementptr i8, i8* %13, i64 14, !dbg !260
  %15 = icmp ugt i8* %14, %9, !dbg !262
  br i1 %15, label %113, label %16, !dbg !263

16:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %13, metadata !248, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i8* %14, metadata !177, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i8* %14, metadata !250, metadata !DIExpression()), !dbg !258
  %17 = getelementptr inbounds i8, i8* %13, i64 12, !dbg !264
  %18 = bitcast i8* %17 to i16*, !dbg !264
  call void @llvm.dbg.value(metadata i16 undef, metadata !256, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i32 0, metadata !257, metadata !DIExpression()), !dbg !258
  %19 = load i16, i16* %18, align 1, !dbg !258, !tbaa !265
  call void @llvm.dbg.value(metadata i16 %19, metadata !256, metadata !DIExpression()), !dbg !258
  %20 = inttoptr i64 %8 to %struct.vlan_hdr*, !dbg !267
  %21 = getelementptr i8, i8* %13, i64 22, !dbg !272
  %22 = bitcast i8* %21 to %struct.vlan_hdr*, !dbg !272
  switch i16 %19, label %37 [
    i16 -22392, label %23
    i16 129, label %23
  ], !dbg !273

23:                                               ; preds = %16, %16
  %24 = getelementptr i8, i8* %13, i64 18, !dbg !274
  %25 = bitcast i8* %24 to %struct.vlan_hdr*, !dbg !274
  %26 = icmp ugt %struct.vlan_hdr* %25, %20, !dbg !275
  br i1 %26, label %37, label %27, !dbg !276

27:                                               ; preds = %23
  call void @llvm.dbg.value(metadata i16 undef, metadata !256, metadata !DIExpression()), !dbg !258
  %28 = getelementptr i8, i8* %13, i64 16, !dbg !277
  %29 = bitcast i8* %28 to i16*, !dbg !277
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %25, metadata !250, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i32 1, metadata !257, metadata !DIExpression()), !dbg !258
  %30 = load i16, i16* %29, align 1, !dbg !258, !tbaa !265
  call void @llvm.dbg.value(metadata i16 %30, metadata !256, metadata !DIExpression()), !dbg !258
  switch i16 %30, label %37 [
    i16 -22392, label %31
    i16 129, label %31
  ], !dbg !273

31:                                               ; preds = %27, %27
  %32 = icmp ugt %struct.vlan_hdr* %22, %20, !dbg !275
  br i1 %32, label %37, label %33, !dbg !276

33:                                               ; preds = %31
  call void @llvm.dbg.value(metadata i16 undef, metadata !256, metadata !DIExpression()), !dbg !258
  %34 = getelementptr i8, i8* %13, i64 20, !dbg !277
  %35 = bitcast i8* %34 to i16*, !dbg !277
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %22, metadata !250, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i32 2, metadata !257, metadata !DIExpression()), !dbg !258
  %36 = load i16, i16* %35, align 1, !dbg !258, !tbaa !265
  call void @llvm.dbg.value(metadata i16 %36, metadata !256, metadata !DIExpression()), !dbg !258
  br label %37

37:                                               ; preds = %33, %31, %27, %23, %16
  %38 = phi i8* [ %14, %16 ], [ %14, %23 ], [ %24, %27 ], [ %24, %31 ], [ %21, %33 ], !dbg !258
  %39 = phi i16 [ %19, %16 ], [ %19, %23 ], [ %30, %27 ], [ %30, %31 ], [ %36, %33 ], !dbg !258
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !250, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !250, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !250, metadata !DIExpression()), !dbg !258
  call void @llvm.dbg.value(metadata i8* %38, metadata !177, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i8* %38, metadata !177, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i16 %39, metadata !109, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i16 %39, metadata !109, metadata !DIExpression()), !dbg !209
  %40 = icmp ne i16 %39, 8, !dbg !278
  %41 = getelementptr inbounds i8, i8* %38, i64 20, !dbg !280
  %42 = icmp ugt i8* %41, %9, !dbg !294
  %43 = or i1 %40, %42, !dbg !295
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !287, metadata !DIExpression()), !dbg !296
  call void @llvm.dbg.value(metadata i8* %9, metadata !288, metadata !DIExpression()), !dbg !296
  call void @llvm.dbg.value(metadata i8* %38, metadata !290, metadata !DIExpression()), !dbg !296
  br i1 %43, label %113, label %44, !dbg !295

44:                                               ; preds = %37
  %45 = load i8, i8* %38, align 4, !dbg !297
  %46 = shl i8 %45, 2, !dbg !298
  %47 = and i8 %46, 60, !dbg !298
  call void @llvm.dbg.value(metadata i8 %47, metadata !291, metadata !DIExpression()), !dbg !296
  %48 = icmp ult i8 %47, 20, !dbg !299
  br i1 %48, label %113, label %49, !dbg !301

49:                                               ; preds = %44
  %50 = zext i8 %47 to i64, !dbg !302
  call void @llvm.dbg.value(metadata i64 %50, metadata !291, metadata !DIExpression()), !dbg !296
  %51 = getelementptr i8, i8* %38, i64 %50, !dbg !303
  %52 = icmp ugt i8* %51, %9, !dbg !305
  br i1 %52, label %113, label %53, !dbg !306

53:                                               ; preds = %49
  call void @llvm.dbg.value(metadata i8* %51, metadata !177, metadata !DIExpression()), !dbg !209
  %54 = getelementptr inbounds i8, i8* %38, i64 9, !dbg !307
  %55 = load i8, i8* %54, align 1, !dbg !307, !tbaa !308
  call void @llvm.dbg.value(metadata i8* %51, metadata !177, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i16 0, metadata !183, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i16 0, metadata !182, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i8 %55, metadata !110, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !209
  switch i8 %55, label %113 [
    i8 17, label %56
    i8 6, label %67
  ], !dbg !310

56:                                               ; preds = %53
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !311, metadata !DIExpression()) #3, !dbg !321
  call void @llvm.dbg.value(metadata i8* %9, metadata !317, metadata !DIExpression()) #3, !dbg !321
  call void @llvm.dbg.value(metadata i8* %51, metadata !320, metadata !DIExpression()) #3, !dbg !321
  %57 = getelementptr inbounds i8, i8* %51, i64 8, !dbg !326
  %58 = bitcast i8* %57 to %struct.udphdr*, !dbg !326
  %59 = inttoptr i64 %8 to %struct.udphdr*, !dbg !328
  %60 = icmp ugt %struct.udphdr* %58, %59, !dbg !329
  br i1 %60, label %113, label %61, !dbg !330

61:                                               ; preds = %56
  call void @llvm.dbg.value(metadata %struct.udphdr* %58, metadata !177, metadata !DIExpression()), !dbg !209
  %62 = getelementptr inbounds i8, i8* %51, i64 4, !dbg !331
  %63 = bitcast i8* %62 to i16*, !dbg !331
  %64 = load i16, i16* %63, align 2, !dbg !331, !tbaa !332
  %65 = tail call i16 @llvm.bswap.i16(i16 %64) #3
  call void @llvm.dbg.value(metadata i16 %65, metadata !319, metadata !DIExpression(DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #3, !dbg !321
  %66 = icmp ult i16 %65, 8, !dbg !334
  br i1 %66, label %113, label %81, !dbg !336

67:                                               ; preds = %53
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !337, metadata !DIExpression()), !dbg !347
  call void @llvm.dbg.value(metadata i8* %9, metadata !343, metadata !DIExpression()), !dbg !347
  call void @llvm.dbg.value(metadata i8* %51, metadata !346, metadata !DIExpression()), !dbg !347
  %68 = getelementptr inbounds i8, i8* %51, i64 20, !dbg !352
  %69 = icmp ugt i8* %68, %9, !dbg !354
  br i1 %69, label %113, label %70, !dbg !355

70:                                               ; preds = %67
  %71 = getelementptr inbounds i8, i8* %51, i64 12, !dbg !356
  %72 = bitcast i8* %71 to i16*, !dbg !356
  %73 = load i16, i16* %72, align 4, !dbg !356
  %74 = lshr i16 %73, 2, !dbg !357
  %75 = and i16 %74, 60, !dbg !357
  call void @llvm.dbg.value(metadata i16 %75, metadata !345, metadata !DIExpression()), !dbg !347
  %76 = icmp ult i16 %75, 20, !dbg !358
  br i1 %76, label %113, label %77, !dbg !360

77:                                               ; preds = %70
  %78 = zext i16 %75 to i64, !dbg !361
  %79 = getelementptr i8, i8* %51, i64 %78, !dbg !362
  %80 = icmp ugt i8* %79, %9, !dbg !364
  br i1 %80, label %113, label %81, !dbg !365

81:                                               ; preds = %77, %61
  %82 = getelementptr inbounds i8, i8* %51, i64 2, !dbg !366
  %83 = bitcast i8* %82 to i16*, !dbg !366
  %84 = bitcast i8* %51 to i16*, !dbg !366
  %85 = load i16, i16* %84, align 2, !dbg !366, !tbaa !265
  %86 = load i16, i16* %83, align 2, !dbg !366, !tbaa !265
  call void @llvm.dbg.value(metadata i16 %85, metadata !182, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.value(metadata i16 %86, metadata !183, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.declare(metadata %struct.flow* %2, metadata !184, metadata !DIExpression()), !dbg !367
  %87 = bitcast %struct.flow* %2 to i8*, !dbg !368
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %87, i8 0, i64 16, i1 false), !dbg !368
  call void @llvm.dbg.value(metadata i8* %38, metadata !125, metadata !DIExpression()), !dbg !209
  %88 = getelementptr inbounds i8, i8* %38, i64 12, !dbg !369
  %89 = bitcast i8* %88 to i32*, !dbg !369
  %90 = load i32, i32* %89, align 4, !dbg !369, !tbaa !370
  %91 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 0, !dbg !371
  store i32 %90, i32* %91, align 4, !dbg !372, !tbaa !373
  call void @llvm.dbg.value(metadata i8* %38, metadata !125, metadata !DIExpression()), !dbg !209
  %92 = getelementptr inbounds i8, i8* %38, i64 16, !dbg !375
  %93 = bitcast i8* %92 to i32*, !dbg !375
  %94 = load i32, i32* %93, align 4, !dbg !375, !tbaa !376
  %95 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 1, !dbg !377
  store i32 %94, i32* %95, align 4, !dbg !378, !tbaa !379
  %96 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 2, !dbg !380
  store i16 %85, i16* %96, align 4, !dbg !381, !tbaa !382
  %97 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 3, !dbg !383
  store i16 %86, i16* %97, align 2, !dbg !384, !tbaa !385
  call void @llvm.dbg.value(metadata i8* %38, metadata !125, metadata !DIExpression()), !dbg !209
  %98 = load i8, i8* %54, align 1, !dbg !386, !tbaa !308
  %99 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 4, !dbg !387
  store i8 %98, i8* %99, align 4, !dbg !388, !tbaa !389
  %100 = getelementptr inbounds [25 x i8], [25 x i8]* %3, i64 0, i64 0, !dbg !390
  call void @llvm.lifetime.start.p0i8(i64 25, i8* nonnull %100) #3, !dbg !390
  call void @llvm.dbg.declare(metadata [25 x i8]* %3, metadata !193, metadata !DIExpression()), !dbg !390
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(25) %100, i8* nonnull align 1 dereferenceable(25) getelementptr inbounds ([25 x i8], [25 x i8]* @__const.xdp_pass_func.____fmt, i64 0, i64 0), i64 25, i1 false), !dbg !390
  %101 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %100, i32 25) #3, !dbg !390
  call void @llvm.lifetime.end.p0i8(i64 25, i8* nonnull %100) #3, !dbg !391
  call void @llvm.dbg.value(metadata i32 1, metadata !198, metadata !DIExpression()), !dbg !209
  store i32 1, i32* %4, align 4, !dbg !392, !tbaa !393
  %102 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_flow_map to i8*), i8* nonnull %87) #3, !dbg !394
  %103 = bitcast i8* %102 to i32*, !dbg !394
  call void @llvm.dbg.value(metadata i32* %103, metadata !199, metadata !DIExpression()), !dbg !209
  %104 = icmp eq i8* %102, null, !dbg !395
  br i1 %104, label %105, label %110, !dbg !396

105:                                              ; preds = %81
  %106 = getelementptr inbounds [44 x i8], [44 x i8]* %5, i64 0, i64 0, !dbg !397
  call void @llvm.lifetime.start.p0i8(i64 44, i8* nonnull %106) #3, !dbg !397
  call void @llvm.dbg.declare(metadata [44 x i8]* %5, metadata !201, metadata !DIExpression()), !dbg !397
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(44) %106, i8* nonnull align 1 dereferenceable(44) getelementptr inbounds ([44 x i8], [44 x i8]* @__const.xdp_pass_func.____fmt.1, i64 0, i64 0), i64 44, i1 false), !dbg !397
  %107 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %106, i32 44) #3, !dbg !397
  call void @llvm.lifetime.end.p0i8(i64 44, i8* nonnull %106) #3, !dbg !398
  %108 = bitcast i32* %4 to i8*, !dbg !399
  call void @llvm.dbg.value(metadata i32* %4, metadata !198, metadata !DIExpression(DW_OP_deref)), !dbg !209
  %109 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @xdp_flow_map to i8*), i8* nonnull %87, i8* nonnull %108, i64 0) #3, !dbg !400
  br label %113, !dbg !401

110:                                              ; preds = %81
  %111 = load i32, i32* %103, align 4, !dbg !402, !tbaa !393
  %112 = add i32 %111, 1, !dbg !404
  store i32 %112, i32* %103, align 4, !dbg !405, !tbaa !393
  br label %113

113:                                              ; preds = %37, %77, %70, %67, %61, %56, %49, %44, %1, %53, %105, %110
  %114 = phi i32 [ 2, %110 ], [ 2, %105 ], [ 2, %37 ], [ 2, %53 ], [ 0, %1 ], [ 2, %44 ], [ 2, %49 ], [ 0, %56 ], [ 0, %61 ], [ 0, %67 ], [ 0, %70 ], [ 0, %77 ], !dbg !209
  call void @llvm.dbg.value(metadata i32 %114, metadata !108, metadata !DIExpression()), !dbg !209
  call void @llvm.dbg.label(metadata !208), !dbg !406
  ret i32 %114, !dbg !407
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #2

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.label(metadata) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nounwind willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!91, !92, !93}
!llvm.ident = !{!94}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !90, line: 16, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !49, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "TMA_Project/headers/linux/bpf.h", directory: "/home/albert/Documents")
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
!49 = !{!0, !50, !60, !66, !76, !83}
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "xdp_flow_map", scope: !2, file: !3, line: 19, type: !52, isLocal: false, isDefinition: true)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !53, line: 33, size: 160, elements: !54)
!53 = !DIFile(filename: "TMA_Project/libbpf/src/build/usr/include/bpf/bpf_helpers.h", directory: "/home/albert/Documents")
!54 = !{!55, !56, !57, !58, !59}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !52, file: !53, line: 34, baseType: !7, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !52, file: !53, line: 35, baseType: !7, size: 32, offset: 32)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !52, file: !53, line: 36, baseType: !7, size: 32, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !52, file: !53, line: 37, baseType: !7, size: 32, offset: 96)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !52, file: !53, line: 38, baseType: !7, size: 32, offset: 128)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 106, type: !62, isLocal: false, isDefinition: true)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !63, size: 32, elements: !64)
!63 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!64 = !{!65}
!65 = !DISubrange(count: 4)
!66 = !DIGlobalVariableExpression(var: !67, expr: !DIExpression())
!67 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !68, line: 152, type: !69, isLocal: true, isDefinition: true)
!68 = !DIFile(filename: "TMA_Project/libbpf/src/build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/albert/Documents")
!69 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !70, size: 64)
!70 = !DISubroutineType(types: !71)
!71 = !{!72, !73, !75, null}
!72 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!73 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !74, size: 64)
!74 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !63)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!76 = !DIGlobalVariableExpression(var: !77, expr: !DIExpression())
!77 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !68, line: 33, type: !78, isLocal: true, isDefinition: true)
!78 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !79, size: 64)
!79 = !DISubroutineType(types: !80)
!80 = !{!44, !44, !81}
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !82, size: 64)
!82 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!83 = !DIGlobalVariableExpression(var: !84, expr: !DIExpression())
!84 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !68, line: 55, type: !85, isLocal: true, isDefinition: true)
!85 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !86, size: 64)
!86 = !DISubroutineType(types: !87)
!87 = !{!72, !44, !81, !81, !88}
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !89)
!89 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!90 = !DIFile(filename: "././common/xdp_stats_kern.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!91 = !{i32 7, !"Dwarf Version", i32 4}
!92 = !{i32 2, !"Debug Info Version", i32 3}
!93 = !{i32 1, !"wchar_size", i32 4}
!94 = !{!"clang version 10.0.0-4ubuntu1 "}
!95 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 33, type: !96, scopeLine: 33, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !106)
!96 = !DISubroutineType(types: !97)
!97 = !{!72, !98}
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !99, size: 64)
!99 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !100)
!100 = !{!101, !102, !103, !104, !105}
!101 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !99, file: !6, line: 2857, baseType: !75, size: 32)
!102 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !99, file: !6, line: 2858, baseType: !75, size: 32, offset: 32)
!103 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !99, file: !6, line: 2859, baseType: !75, size: 32, offset: 64)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !99, file: !6, line: 2861, baseType: !75, size: 32, offset: 96)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !99, file: !6, line: 2862, baseType: !75, size: 32, offset: 128)
!106 = !{!107, !108, !109, !110, !111, !125, !144, !153, !175, !176, !177, !182, !183, !184, !193, !198, !199, !201, !208}
!107 = !DILocalVariable(name: "ctx", arg: 1, scope: !95, file: !3, line: 33, type: !98)
!108 = !DILocalVariable(name: "action", scope: !95, file: !3, line: 34, type: !75)
!109 = !DILocalVariable(name: "eth_type", scope: !95, file: !3, line: 35, type: !72)
!110 = !DILocalVariable(name: "ip_type", scope: !95, file: !3, line: 35, type: !72)
!111 = !DILocalVariable(name: "eth", scope: !95, file: !3, line: 36, type: !112)
!112 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !113, size: 64)
!113 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !114, line: 163, size: 112, elements: !115)
!114 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!115 = !{!116, !121, !122}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !113, file: !114, line: 164, baseType: !117, size: 48)
!117 = !DICompositeType(tag: DW_TAG_array_type, baseType: !118, size: 48, elements: !119)
!118 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!119 = !{!120}
!120 = !DISubrange(count: 6)
!121 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !113, file: !114, line: 165, baseType: !117, size: 48, offset: 48)
!122 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !113, file: !114, line: 166, baseType: !123, size: 16, offset: 96)
!123 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !124, line: 25, baseType: !46)
!124 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!125 = !DILocalVariable(name: "iphdr", scope: !95, file: !3, line: 37, type: !126)
!126 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !127, size: 64)
!127 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !128, line: 86, size: 160, elements: !129)
!128 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!129 = !{!130, !132, !133, !134, !135, !136, !137, !138, !139, !141, !143}
!130 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !127, file: !128, line: 88, baseType: !131, size: 4, flags: DIFlagBitField, extraData: i64 0)
!131 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !118)
!132 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !127, file: !128, line: 89, baseType: !131, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!133 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !127, file: !128, line: 96, baseType: !131, size: 8, offset: 8)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !127, file: !128, line: 97, baseType: !123, size: 16, offset: 16)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !127, file: !128, line: 98, baseType: !123, size: 16, offset: 32)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !127, file: !128, line: 99, baseType: !123, size: 16, offset: 48)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !127, file: !128, line: 100, baseType: !131, size: 8, offset: 64)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !127, file: !128, line: 101, baseType: !131, size: 8, offset: 72)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !127, file: !128, line: 102, baseType: !140, size: 16, offset: 80)
!140 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !124, line: 31, baseType: !46)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !127, file: !128, line: 103, baseType: !142, size: 32, offset: 96)
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !124, line: 27, baseType: !75)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !127, file: !128, line: 104, baseType: !142, size: 32, offset: 128)
!144 = !DILocalVariable(name: "udphdr", scope: !95, file: !3, line: 39, type: !145)
!145 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !146, size: 64)
!146 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !147, line: 23, size: 64, elements: !148)
!147 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "")
!148 = !{!149, !150, !151, !152}
!149 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !146, file: !147, line: 24, baseType: !123, size: 16)
!150 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !146, file: !147, line: 25, baseType: !123, size: 16, offset: 16)
!151 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !146, file: !147, line: 26, baseType: !123, size: 16, offset: 32)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !146, file: !147, line: 27, baseType: !140, size: 16, offset: 48)
!153 = !DILocalVariable(name: "tcphdr", scope: !95, file: !3, line: 40, type: !154)
!154 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !155, size: 64)
!155 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !156, line: 25, size: 160, elements: !157)
!156 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "")
!157 = !{!158, !159, !160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174}
!158 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !155, file: !156, line: 26, baseType: !123, size: 16)
!159 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !155, file: !156, line: 27, baseType: !123, size: 16, offset: 16)
!160 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !155, file: !156, line: 28, baseType: !142, size: 32, offset: 32)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !155, file: !156, line: 29, baseType: !142, size: 32, offset: 64)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !155, file: !156, line: 31, baseType: !46, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !155, file: !156, line: 32, baseType: !46, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !155, file: !156, line: 33, baseType: !46, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !155, file: !156, line: 34, baseType: !46, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !155, file: !156, line: 35, baseType: !46, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !155, file: !156, line: 36, baseType: !46, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !155, file: !156, line: 37, baseType: !46, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !155, file: !156, line: 38, baseType: !46, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !155, file: !156, line: 39, baseType: !46, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !155, file: !156, line: 40, baseType: !46, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !155, file: !156, line: 55, baseType: !123, size: 16, offset: 112)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !155, file: !156, line: 56, baseType: !140, size: 16, offset: 128)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !155, file: !156, line: 57, baseType: !123, size: 16, offset: 144)
!175 = !DILocalVariable(name: "data_end", scope: !95, file: !3, line: 41, type: !44)
!176 = !DILocalVariable(name: "data", scope: !95, file: !3, line: 42, type: !44)
!177 = !DILocalVariable(name: "nh", scope: !95, file: !3, line: 43, type: !178)
!178 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !179, line: 33, size: 64, elements: !180)
!179 = !DIFile(filename: "././common/parsing_helpers.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!180 = !{!181}
!181 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !178, file: !179, line: 34, baseType: !44, size: 64)
!182 = !DILocalVariable(name: "sport", scope: !95, file: !3, line: 59, type: !123)
!183 = !DILocalVariable(name: "dport", scope: !95, file: !3, line: 59, type: !123)
!184 = !DILocalVariable(name: "curr_flow", scope: !95, file: !3, line: 81, type: !185)
!185 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "flow", file: !186, line: 8, size: 128, elements: !187)
!186 = !DIFile(filename: "./common_kern_user_datastructure.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!187 = !{!188, !189, !190, !191, !192}
!188 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !185, file: !186, line: 9, baseType: !142, size: 32)
!189 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !185, file: !186, line: 10, baseType: !142, size: 32, offset: 32)
!190 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !185, file: !186, line: 11, baseType: !123, size: 16, offset: 64)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !185, file: !186, line: 12, baseType: !123, size: 16, offset: 80)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !185, file: !186, line: 13, baseType: !131, size: 8, offset: 96)
!193 = !DILocalVariable(name: "____fmt", scope: !194, file: !3, line: 89, type: !195)
!194 = distinct !DILexicalBlock(scope: !95, file: !3, line: 89, column: 2)
!195 = !DICompositeType(tag: DW_TAG_array_type, baseType: !63, size: 200, elements: !196)
!196 = !{!197}
!197 = !DISubrange(count: 25)
!198 = !DILocalVariable(name: "times", scope: !95, file: !3, line: 90, type: !72)
!199 = !DILocalVariable(name: "n_times", scope: !95, file: !3, line: 91, type: !200)
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !75, size: 64)
!201 = !DILocalVariable(name: "____fmt", scope: !202, file: !3, line: 94, type: !205)
!202 = distinct !DILexicalBlock(scope: !203, file: !3, line: 94, column: 3)
!203 = distinct !DILexicalBlock(scope: !204, file: !3, line: 93, column: 16)
!204 = distinct !DILexicalBlock(scope: !95, file: !3, line: 93, column: 6)
!205 = !DICompositeType(tag: DW_TAG_array_type, baseType: !63, size: 352, elements: !206)
!206 = !{!207}
!207 = !DISubrange(count: 44)
!208 = !DILabel(scope: !95, name: "out", file: !3, line: 102)
!209 = !DILocation(line: 0, scope: !95)
!210 = !DILocation(line: 41, column: 38, scope: !95)
!211 = !{!212, !213, i64 4}
!212 = !{!"xdp_md", !213, i64 0, !213, i64 4, !213, i64 8, !213, i64 12, !213, i64 16}
!213 = !{!"int", !214, i64 0}
!214 = !{!"omnipotent char", !215, i64 0}
!215 = !{!"Simple C/C++ TBAA"}
!216 = !DILocation(line: 41, column: 27, scope: !95)
!217 = !DILocation(line: 41, column: 19, scope: !95)
!218 = !DILocation(line: 42, column: 34, scope: !95)
!219 = !{!212, !213, i64 0}
!220 = !DILocation(line: 42, column: 23, scope: !95)
!221 = !DILocation(line: 42, column: 15, scope: !95)
!222 = !DILocalVariable(name: "nh", arg: 1, scope: !223, file: !179, line: 124, type: !226)
!223 = distinct !DISubprogram(name: "parse_ethhdr", scope: !179, file: !179, line: 124, type: !224, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !228)
!224 = !DISubroutineType(types: !225)
!225 = !{!72, !226, !44, !227}
!226 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !178, size: 64)
!227 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!228 = !{!222, !229, !230}
!229 = !DILocalVariable(name: "data_end", arg: 2, scope: !223, file: !179, line: 125, type: !44)
!230 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !223, file: !179, line: 126, type: !227)
!231 = !DILocation(line: 0, scope: !223, inlinedAt: !232)
!232 = distinct !DILocation(line: 45, column: 13, scope: !95)
!233 = !DILocalVariable(name: "nh", arg: 1, scope: !234, file: !179, line: 79, type: !226)
!234 = distinct !DISubprogram(name: "parse_ethhdr_vlan", scope: !179, file: !179, line: 79, type: !235, scopeLine: 83, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !244)
!235 = !DISubroutineType(types: !236)
!236 = !{!72, !226, !44, !227, !237}
!237 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !238, size: 64)
!238 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "collect_vlans", file: !179, line: 64, size: 32, elements: !239)
!239 = !{!240}
!240 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !238, file: !179, line: 65, baseType: !241, size: 32)
!241 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 32, elements: !242)
!242 = !{!243}
!243 = !DISubrange(count: 2)
!244 = !{!233, !245, !246, !247, !248, !249, !250, !256, !257}
!245 = !DILocalVariable(name: "data_end", arg: 2, scope: !234, file: !179, line: 80, type: !44)
!246 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !234, file: !179, line: 81, type: !227)
!247 = !DILocalVariable(name: "vlans", arg: 4, scope: !234, file: !179, line: 82, type: !237)
!248 = !DILocalVariable(name: "eth", scope: !234, file: !179, line: 84, type: !112)
!249 = !DILocalVariable(name: "hdrsize", scope: !234, file: !179, line: 85, type: !72)
!250 = !DILocalVariable(name: "vlh", scope: !234, file: !179, line: 86, type: !251)
!251 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !252, size: 64)
!252 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !179, line: 42, size: 32, elements: !253)
!253 = !{!254, !255}
!254 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !252, file: !179, line: 43, baseType: !123, size: 16)
!255 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !252, file: !179, line: 44, baseType: !123, size: 16, offset: 16)
!256 = !DILocalVariable(name: "h_proto", scope: !234, file: !179, line: 87, type: !46)
!257 = !DILocalVariable(name: "i", scope: !234, file: !179, line: 88, type: !72)
!258 = !DILocation(line: 0, scope: !234, inlinedAt: !259)
!259 = distinct !DILocation(line: 129, column: 9, scope: !223, inlinedAt: !232)
!260 = !DILocation(line: 93, column: 14, scope: !261, inlinedAt: !259)
!261 = distinct !DILexicalBlock(scope: !234, file: !179, line: 93, column: 6)
!262 = !DILocation(line: 93, column: 24, scope: !261, inlinedAt: !259)
!263 = !DILocation(line: 93, column: 6, scope: !234, inlinedAt: !259)
!264 = !DILocation(line: 99, column: 17, scope: !234, inlinedAt: !259)
!265 = !{!266, !266, i64 0}
!266 = !{!"short", !214, i64 0}
!267 = !DILocation(line: 0, scope: !268, inlinedAt: !259)
!268 = distinct !DILexicalBlock(scope: !269, file: !179, line: 109, column: 7)
!269 = distinct !DILexicalBlock(scope: !270, file: !179, line: 105, column: 39)
!270 = distinct !DILexicalBlock(scope: !271, file: !179, line: 105, column: 2)
!271 = distinct !DILexicalBlock(scope: !234, file: !179, line: 105, column: 2)
!272 = !DILocation(line: 105, column: 2, scope: !271, inlinedAt: !259)
!273 = !DILocation(line: 106, column: 7, scope: !269, inlinedAt: !259)
!274 = !DILocation(line: 109, column: 11, scope: !268, inlinedAt: !259)
!275 = !DILocation(line: 109, column: 15, scope: !268, inlinedAt: !259)
!276 = !DILocation(line: 109, column: 7, scope: !269, inlinedAt: !259)
!277 = !DILocation(line: 112, column: 18, scope: !269, inlinedAt: !259)
!278 = !DILocation(line: 51, column: 15, scope: !279)
!279 = distinct !DILexicalBlock(scope: !95, file: !3, line: 51, column: 6)
!280 = !DILocation(line: 158, column: 10, scope: !281, inlinedAt: !292)
!281 = distinct !DILexicalBlock(scope: !282, file: !179, line: 158, column: 6)
!282 = distinct !DISubprogram(name: "parse_iphdr", scope: !179, file: !179, line: 151, type: !283, scopeLine: 154, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !286)
!283 = !DISubroutineType(types: !284)
!284 = !{!72, !226, !44, !285}
!285 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!286 = !{!287, !288, !289, !290, !291}
!287 = !DILocalVariable(name: "nh", arg: 1, scope: !282, file: !179, line: 151, type: !226)
!288 = !DILocalVariable(name: "data_end", arg: 2, scope: !282, file: !179, line: 152, type: !44)
!289 = !DILocalVariable(name: "iphdr", arg: 3, scope: !282, file: !179, line: 153, type: !285)
!290 = !DILocalVariable(name: "iph", scope: !282, file: !179, line: 155, type: !126)
!291 = !DILocalVariable(name: "hdrsize", scope: !282, file: !179, line: 156, type: !72)
!292 = distinct !DILocation(line: 52, column: 13, scope: !293)
!293 = distinct !DILexicalBlock(scope: !279, file: !3, line: 51, column: 39)
!294 = !DILocation(line: 158, column: 14, scope: !281, inlinedAt: !292)
!295 = !DILocation(line: 51, column: 6, scope: !95)
!296 = !DILocation(line: 0, scope: !282, inlinedAt: !292)
!297 = !DILocation(line: 161, column: 17, scope: !282, inlinedAt: !292)
!298 = !DILocation(line: 161, column: 21, scope: !282, inlinedAt: !292)
!299 = !DILocation(line: 163, column: 13, scope: !300, inlinedAt: !292)
!300 = distinct !DILexicalBlock(scope: !282, file: !179, line: 163, column: 5)
!301 = !DILocation(line: 163, column: 5, scope: !282, inlinedAt: !292)
!302 = !DILocation(line: 163, column: 5, scope: !300, inlinedAt: !292)
!303 = !DILocation(line: 167, column: 14, scope: !304, inlinedAt: !292)
!304 = distinct !DILexicalBlock(scope: !282, file: !179, line: 167, column: 6)
!305 = !DILocation(line: 167, column: 24, scope: !304, inlinedAt: !292)
!306 = !DILocation(line: 167, column: 6, scope: !282, inlinedAt: !292)
!307 = !DILocation(line: 173, column: 14, scope: !282, inlinedAt: !292)
!308 = !{!309, !214, i64 9}
!309 = !{!"iphdr", !214, i64 0, !214, i64 0, !214, i64 1, !266, i64 2, !266, i64 4, !266, i64 6, !214, i64 8, !214, i64 9, !266, i64 10, !213, i64 12, !213, i64 16}
!310 = !DILocation(line: 62, column: 6, scope: !95)
!311 = !DILocalVariable(name: "nh", arg: 1, scope: !312, file: !179, line: 224, type: !226)
!312 = distinct !DISubprogram(name: "parse_udphdr", scope: !179, file: !179, line: 224, type: !313, scopeLine: 227, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !316)
!313 = !DISubroutineType(types: !314)
!314 = !{!72, !226, !44, !315}
!315 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !145, size: 64)
!316 = !{!311, !317, !318, !319, !320}
!317 = !DILocalVariable(name: "data_end", arg: 2, scope: !312, file: !179, line: 225, type: !44)
!318 = !DILocalVariable(name: "udphdr", arg: 3, scope: !312, file: !179, line: 226, type: !315)
!319 = !DILocalVariable(name: "len", scope: !312, file: !179, line: 228, type: !72)
!320 = !DILocalVariable(name: "h", scope: !312, file: !179, line: 229, type: !145)
!321 = !DILocation(line: 0, scope: !312, inlinedAt: !322)
!322 = distinct !DILocation(line: 63, column: 7, scope: !323)
!323 = distinct !DILexicalBlock(scope: !324, file: !3, line: 63, column: 7)
!324 = distinct !DILexicalBlock(scope: !325, file: !3, line: 62, column: 30)
!325 = distinct !DILexicalBlock(scope: !95, file: !3, line: 62, column: 6)
!326 = !DILocation(line: 231, column: 8, scope: !327, inlinedAt: !322)
!327 = distinct !DILexicalBlock(scope: !312, file: !179, line: 231, column: 6)
!328 = !DILocation(line: 231, column: 14, scope: !327, inlinedAt: !322)
!329 = !DILocation(line: 231, column: 12, scope: !327, inlinedAt: !322)
!330 = !DILocation(line: 231, column: 6, scope: !312, inlinedAt: !322)
!331 = !DILocation(line: 237, column: 8, scope: !312, inlinedAt: !322)
!332 = !{!333, !266, i64 4}
!333 = !{!"udphdr", !266, i64 0, !266, i64 2, !266, i64 4, !266, i64 6}
!334 = !DILocation(line: 238, column: 10, scope: !335, inlinedAt: !322)
!335 = distinct !DILexicalBlock(scope: !312, file: !179, line: 238, column: 6)
!336 = !DILocation(line: 238, column: 6, scope: !312, inlinedAt: !322)
!337 = !DILocalVariable(name: "nh", arg: 1, scope: !338, file: !179, line: 247, type: !226)
!338 = distinct !DISubprogram(name: "parse_tcphdr", scope: !179, file: !179, line: 247, type: !339, scopeLine: 250, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !342)
!339 = !DISubroutineType(types: !340)
!340 = !{!72, !226, !44, !341}
!341 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !154, size: 64)
!342 = !{!337, !343, !344, !345, !346}
!343 = !DILocalVariable(name: "data_end", arg: 2, scope: !338, file: !179, line: 248, type: !44)
!344 = !DILocalVariable(name: "tcphdr", arg: 3, scope: !338, file: !179, line: 249, type: !341)
!345 = !DILocalVariable(name: "len", scope: !338, file: !179, line: 251, type: !72)
!346 = !DILocalVariable(name: "h", scope: !338, file: !179, line: 252, type: !154)
!347 = !DILocation(line: 0, scope: !338, inlinedAt: !348)
!348 = distinct !DILocation(line: 71, column: 7, scope: !349)
!349 = distinct !DILexicalBlock(scope: !350, file: !3, line: 71, column: 7)
!350 = distinct !DILexicalBlock(scope: !351, file: !3, line: 70, column: 37)
!351 = distinct !DILexicalBlock(scope: !325, file: !3, line: 70, column: 13)
!352 = !DILocation(line: 254, column: 8, scope: !353, inlinedAt: !348)
!353 = distinct !DILexicalBlock(scope: !338, file: !179, line: 254, column: 6)
!354 = !DILocation(line: 254, column: 12, scope: !353, inlinedAt: !348)
!355 = !DILocation(line: 254, column: 6, scope: !338, inlinedAt: !348)
!356 = !DILocation(line: 257, column: 11, scope: !338, inlinedAt: !348)
!357 = !DILocation(line: 257, column: 16, scope: !338, inlinedAt: !348)
!358 = !DILocation(line: 259, column: 9, scope: !359, inlinedAt: !348)
!359 = distinct !DILexicalBlock(scope: !338, file: !179, line: 259, column: 5)
!360 = !DILocation(line: 259, column: 5, scope: !338, inlinedAt: !348)
!361 = !DILocation(line: 259, column: 5, scope: !359, inlinedAt: !348)
!362 = !DILocation(line: 263, column: 14, scope: !363, inlinedAt: !348)
!363 = distinct !DILexicalBlock(scope: !338, file: !179, line: 263, column: 6)
!364 = !DILocation(line: 263, column: 20, scope: !363, inlinedAt: !348)
!365 = !DILocation(line: 263, column: 6, scope: !338, inlinedAt: !348)
!366 = !DILocation(line: 0, scope: !325)
!367 = !DILocation(line: 81, column: 14, scope: !95)
!368 = !DILocation(line: 82, column: 2, scope: !95)
!369 = !DILocation(line: 83, column: 27, scope: !95)
!370 = !{!309, !213, i64 12}
!371 = !DILocation(line: 83, column: 12, scope: !95)
!372 = !DILocation(line: 83, column: 18, scope: !95)
!373 = !{!374, !213, i64 0}
!374 = !{!"flow", !213, i64 0, !213, i64 4, !266, i64 8, !266, i64 10, !214, i64 12}
!375 = !DILocation(line: 84, column: 27, scope: !95)
!376 = !{!309, !213, i64 16}
!377 = !DILocation(line: 84, column: 12, scope: !95)
!378 = !DILocation(line: 84, column: 18, scope: !95)
!379 = !{!374, !213, i64 4}
!380 = !DILocation(line: 85, column: 12, scope: !95)
!381 = !DILocation(line: 85, column: 18, scope: !95)
!382 = !{!374, !266, i64 8}
!383 = !DILocation(line: 86, column: 12, scope: !95)
!384 = !DILocation(line: 86, column: 18, scope: !95)
!385 = !{!374, !266, i64 10}
!386 = !DILocation(line: 87, column: 30, scope: !95)
!387 = !DILocation(line: 87, column: 12, scope: !95)
!388 = !DILocation(line: 87, column: 21, scope: !95)
!389 = !{!374, !214, i64 12}
!390 = !DILocation(line: 89, column: 2, scope: !194)
!391 = !DILocation(line: 89, column: 2, scope: !95)
!392 = !DILocation(line: 90, column: 6, scope: !95)
!393 = !{!213, !213, i64 0}
!394 = !DILocation(line: 91, column: 19, scope: !95)
!395 = !DILocation(line: 93, column: 7, scope: !204)
!396 = !DILocation(line: 93, column: 6, scope: !95)
!397 = !DILocation(line: 94, column: 3, scope: !202)
!398 = !DILocation(line: 94, column: 3, scope: !203)
!399 = !DILocation(line: 95, column: 50, scope: !203)
!400 = !DILocation(line: 95, column: 3, scope: !203)
!401 = !DILocation(line: 96, column: 2, scope: !203)
!402 = !DILocation(line: 97, column: 14, scope: !403)
!403 = distinct !DILexicalBlock(scope: !204, file: !3, line: 96, column: 9)
!404 = !DILocation(line: 97, column: 22, scope: !403)
!405 = !DILocation(line: 97, column: 12, scope: !403)
!406 = !DILocation(line: 102, column: 1, scope: !95)
!407 = !DILocation(line: 103, column: 2, scope: !95)
