; ModuleID = 'xdp_prog_kern.c'
source_filename = "xdp_prog_kern.c"
target datalayout = "e-m:e-p:64:64-i64:64-n32:64-S128"
target triple = "bpf"

%struct.bpf_map_def = type { i32, i32, i32, i32, i32 }
%struct.xdp_md = type { i32, i32, i32, i32, i32 }
%struct.flow = type { i32, i32, i16, i16, i8 }
%struct.info_map = type { i32, i64 }
%struct.ethhdr = type { [6 x i8], [6 x i8], i16 }
%struct.hdr_cursor = type { i8* }
%struct.collect_vlans = type { [2 x i16] }
%struct.vlan_hdr = type { i16, i16 }
%struct.udphdr = type { i16, i16, i16, i16 }

@xdp_stats_map = dso_local global %struct.bpf_map_def { i32 6, i32 4, i32 16, i32 5, i32 0 }, section "maps", align 4, !dbg !0
@xdp_flow_map = dso_local global %struct.bpf_map_def { i32 1, i32 16, i32 16, i32 15000, i32 0 }, section "maps", align 4, !dbg !50
@xdp_blocked_flows = dso_local global %struct.bpf_map_def { i32 1, i32 16, i32 4, i32 15000, i32 0 }, section "maps", align 4, !dbg !60
@__const.xdp_pass_func.____fmt = private unnamed_addr constant [25 x i8] c"Looking up eBPF element\0A\00", align 1
@__const.xdp_pass_func.____fmt.1 = private unnamed_addr constant [59 x i8] c"This flow is in the black list, so the program will abort\0A\00", align 1
@__const.xdp_pass_func.____fmt.2 = private unnamed_addr constant [44 x i8] c"Writing in the new element of the eBPF map\0A\00", align 1
@_license = dso_local global [4 x i8] c"GPL\00", section "license", align 1, !dbg !62
@llvm.used = appending global [5 x i8*] [i8* getelementptr inbounds ([4 x i8], [4 x i8]* @_license, i32 0, i32 0), i8* bitcast (%struct.bpf_map_def* @xdp_blocked_flows to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_flow_map to i8*), i8* bitcast (i32 (%struct.xdp_md*)* @xdp_pass_func to i8*), i8* bitcast (%struct.bpf_map_def* @xdp_stats_map to i8*)], section "llvm.metadata"

; Function Attrs: nounwind
define dso_local i32 @xdp_pass_func(%struct.xdp_md* nocapture readonly %0) #0 section "xdp_program" !dbg !97 {
  %2 = alloca %struct.flow, align 4
  %3 = alloca [25 x i8], align 1
  %4 = alloca [59 x i8], align 1
  %5 = alloca [44 x i8], align 1
  %6 = alloca %struct.info_map, align 8
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !109, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i32 2, metadata !110, metadata !DIExpression()), !dbg !225
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !226
  %8 = load i32, i32* %7, align 4, !dbg !226, !tbaa !227
  %9 = zext i32 %8 to i64, !dbg !232
  %10 = inttoptr i64 %9 to i8*, !dbg !233
  call void @llvm.dbg.value(metadata i8* %10, metadata !177, metadata !DIExpression()), !dbg !225
  %11 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !234
  %12 = load i32, i32* %11, align 4, !dbg !234, !tbaa !235
  %13 = zext i32 %12 to i64, !dbg !236
  %14 = inttoptr i64 %13 to i8*, !dbg !237
  call void @llvm.dbg.value(metadata i8* %14, metadata !178, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i8* %14, metadata !179, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !113, metadata !DIExpression(DW_OP_deref)), !dbg !225
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !238, metadata !DIExpression()), !dbg !247
  call void @llvm.dbg.value(metadata i8* %10, metadata !245, metadata !DIExpression()), !dbg !247
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !246, metadata !DIExpression()), !dbg !247
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !249, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i8* %10, metadata !261, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !262, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !263, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i8* %14, metadata !264, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i32 14, metadata !265, metadata !DIExpression()), !dbg !274
  %15 = getelementptr i8, i8* %14, i64 14, !dbg !276
  %16 = icmp ugt i8* %15, %10, !dbg !278
  br i1 %16, label %131, label %17, !dbg !279

17:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %14, metadata !264, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i8* %15, metadata !179, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i8* %15, metadata !266, metadata !DIExpression()), !dbg !274
  %18 = getelementptr inbounds i8, i8* %14, i64 12, !dbg !280
  %19 = bitcast i8* %18 to i16*, !dbg !280
  call void @llvm.dbg.value(metadata i16 undef, metadata !272, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i32 0, metadata !273, metadata !DIExpression()), !dbg !274
  %20 = load i16, i16* %19, align 1, !dbg !274, !tbaa !281
  call void @llvm.dbg.value(metadata i16 %20, metadata !272, metadata !DIExpression()), !dbg !274
  %21 = inttoptr i64 %9 to %struct.vlan_hdr*, !dbg !283
  %22 = getelementptr i8, i8* %14, i64 22, !dbg !288
  %23 = bitcast i8* %22 to %struct.vlan_hdr*, !dbg !288
  switch i16 %20, label %38 [
    i16 -22392, label %24
    i16 129, label %24
  ], !dbg !289

24:                                               ; preds = %17, %17
  %25 = getelementptr i8, i8* %14, i64 18, !dbg !290
  %26 = bitcast i8* %25 to %struct.vlan_hdr*, !dbg !290
  %27 = icmp ugt %struct.vlan_hdr* %26, %21, !dbg !291
  br i1 %27, label %38, label %28, !dbg !292

28:                                               ; preds = %24
  call void @llvm.dbg.value(metadata i16 undef, metadata !272, metadata !DIExpression()), !dbg !274
  %29 = getelementptr i8, i8* %14, i64 16, !dbg !293
  %30 = bitcast i8* %29 to i16*, !dbg !293
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %26, metadata !266, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i32 1, metadata !273, metadata !DIExpression()), !dbg !274
  %31 = load i16, i16* %30, align 1, !dbg !274, !tbaa !281
  call void @llvm.dbg.value(metadata i16 %31, metadata !272, metadata !DIExpression()), !dbg !274
  switch i16 %31, label %38 [
    i16 -22392, label %32
    i16 129, label %32
  ], !dbg !289

32:                                               ; preds = %28, %28
  %33 = icmp ugt %struct.vlan_hdr* %23, %21, !dbg !291
  br i1 %33, label %38, label %34, !dbg !292

34:                                               ; preds = %32
  call void @llvm.dbg.value(metadata i16 undef, metadata !272, metadata !DIExpression()), !dbg !274
  %35 = getelementptr i8, i8* %14, i64 20, !dbg !293
  %36 = bitcast i8* %35 to i16*, !dbg !293
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %23, metadata !266, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i32 2, metadata !273, metadata !DIExpression()), !dbg !274
  %37 = load i16, i16* %36, align 1, !dbg !274, !tbaa !281
  call void @llvm.dbg.value(metadata i16 %37, metadata !272, metadata !DIExpression()), !dbg !274
  br label %38

38:                                               ; preds = %34, %32, %28, %24, %17
  %39 = phi i8* [ %15, %17 ], [ %15, %24 ], [ %25, %28 ], [ %25, %32 ], [ %22, %34 ], !dbg !274
  %40 = phi i16 [ %20, %17 ], [ %20, %24 ], [ %31, %28 ], [ %31, %32 ], [ %37, %34 ], !dbg !274
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !266, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !266, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !266, metadata !DIExpression()), !dbg !274
  call void @llvm.dbg.value(metadata i8* %39, metadata !179, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i8* %39, metadata !179, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i16 %40, metadata !111, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i16 %40, metadata !111, metadata !DIExpression()), !dbg !225
  %41 = icmp ne i16 %40, 8, !dbg !294
  %42 = getelementptr inbounds i8, i8* %39, i64 20, !dbg !296
  %43 = icmp ugt i8* %42, %10, !dbg !310
  %44 = or i1 %41, %43, !dbg !311
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !303, metadata !DIExpression()), !dbg !312
  call void @llvm.dbg.value(metadata i8* %10, metadata !304, metadata !DIExpression()), !dbg !312
  call void @llvm.dbg.value(metadata i8* %39, metadata !306, metadata !DIExpression()), !dbg !312
  br i1 %44, label %131, label %45, !dbg !311

45:                                               ; preds = %38
  %46 = load i8, i8* %39, align 4, !dbg !313
  %47 = shl i8 %46, 2, !dbg !314
  %48 = and i8 %47, 60, !dbg !314
  call void @llvm.dbg.value(metadata i8 %48, metadata !307, metadata !DIExpression()), !dbg !312
  %49 = icmp ult i8 %48, 20, !dbg !315
  br i1 %49, label %131, label %50, !dbg !317

50:                                               ; preds = %45
  %51 = zext i8 %48 to i64, !dbg !318
  call void @llvm.dbg.value(metadata i64 %51, metadata !307, metadata !DIExpression()), !dbg !312
  %52 = getelementptr i8, i8* %39, i64 %51, !dbg !319
  %53 = icmp ugt i8* %52, %10, !dbg !321
  br i1 %53, label %131, label %54, !dbg !322

54:                                               ; preds = %50
  call void @llvm.dbg.value(metadata i8* %52, metadata !179, metadata !DIExpression()), !dbg !225
  %55 = getelementptr inbounds i8, i8* %39, i64 9, !dbg !323
  %56 = load i8, i8* %55, align 1, !dbg !323, !tbaa !324
  call void @llvm.dbg.value(metadata i8* %52, metadata !179, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i16 0, metadata !185, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i16 0, metadata !184, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i8 %56, metadata !112, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !225
  switch i8 %56, label %131 [
    i8 17, label %57
    i8 6, label %68
  ], !dbg !326

57:                                               ; preds = %54
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !327, metadata !DIExpression()) #3, !dbg !337
  call void @llvm.dbg.value(metadata i8* %10, metadata !333, metadata !DIExpression()) #3, !dbg !337
  call void @llvm.dbg.value(metadata i8* %52, metadata !336, metadata !DIExpression()) #3, !dbg !337
  %58 = getelementptr inbounds i8, i8* %52, i64 8, !dbg !342
  %59 = bitcast i8* %58 to %struct.udphdr*, !dbg !342
  %60 = inttoptr i64 %9 to %struct.udphdr*, !dbg !344
  %61 = icmp ugt %struct.udphdr* %59, %60, !dbg !345
  br i1 %61, label %131, label %62, !dbg !346

62:                                               ; preds = %57
  call void @llvm.dbg.value(metadata %struct.udphdr* %59, metadata !179, metadata !DIExpression()), !dbg !225
  %63 = getelementptr inbounds i8, i8* %52, i64 4, !dbg !347
  %64 = bitcast i8* %63 to i16*, !dbg !347
  %65 = load i16, i16* %64, align 2, !dbg !347, !tbaa !348
  %66 = tail call i16 @llvm.bswap.i16(i16 %65) #3
  call void @llvm.dbg.value(metadata i16 %66, metadata !335, metadata !DIExpression(DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #3, !dbg !337
  %67 = icmp ult i16 %66, 8, !dbg !350
  br i1 %67, label %131, label %82, !dbg !352

68:                                               ; preds = %54
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !353, metadata !DIExpression()), !dbg !363
  call void @llvm.dbg.value(metadata i8* %10, metadata !359, metadata !DIExpression()), !dbg !363
  call void @llvm.dbg.value(metadata i8* %52, metadata !362, metadata !DIExpression()), !dbg !363
  %69 = getelementptr inbounds i8, i8* %52, i64 20, !dbg !368
  %70 = icmp ugt i8* %69, %10, !dbg !370
  br i1 %70, label %131, label %71, !dbg !371

71:                                               ; preds = %68
  %72 = getelementptr inbounds i8, i8* %52, i64 12, !dbg !372
  %73 = bitcast i8* %72 to i16*, !dbg !372
  %74 = load i16, i16* %73, align 4, !dbg !372
  %75 = lshr i16 %74, 2, !dbg !373
  %76 = and i16 %75, 60, !dbg !373
  call void @llvm.dbg.value(metadata i16 %76, metadata !361, metadata !DIExpression()), !dbg !363
  %77 = icmp ult i16 %76, 20, !dbg !374
  br i1 %77, label %131, label %78, !dbg !376

78:                                               ; preds = %71
  %79 = zext i16 %76 to i64, !dbg !377
  %80 = getelementptr i8, i8* %52, i64 %79, !dbg !378
  %81 = icmp ugt i8* %80, %10, !dbg !380
  br i1 %81, label %131, label %82, !dbg !381

82:                                               ; preds = %78, %62
  %83 = getelementptr inbounds i8, i8* %52, i64 2, !dbg !382
  %84 = bitcast i8* %83 to i16*, !dbg !382
  %85 = bitcast i8* %52 to i16*, !dbg !382
  %86 = load i16, i16* %85, align 2, !dbg !382, !tbaa !281
  %87 = load i16, i16* %84, align 2, !dbg !382, !tbaa !281
  call void @llvm.dbg.value(metadata i16 %86, metadata !184, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.value(metadata i16 %87, metadata !185, metadata !DIExpression()), !dbg !225
  call void @llvm.dbg.declare(metadata %struct.flow* %2, metadata !186, metadata !DIExpression()), !dbg !383
  %88 = bitcast %struct.flow* %2 to i8*, !dbg !384
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %88, i8 0, i64 16, i1 false), !dbg !384
  call void @llvm.dbg.value(metadata i8* %39, metadata !127, metadata !DIExpression()), !dbg !225
  %89 = getelementptr inbounds i8, i8* %39, i64 12, !dbg !385
  %90 = bitcast i8* %89 to i32*, !dbg !385
  %91 = load i32, i32* %90, align 4, !dbg !385, !tbaa !386
  %92 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 0, !dbg !387
  store i32 %91, i32* %92, align 4, !dbg !388, !tbaa !389
  call void @llvm.dbg.value(metadata i8* %39, metadata !127, metadata !DIExpression()), !dbg !225
  %93 = getelementptr inbounds i8, i8* %39, i64 16, !dbg !391
  %94 = bitcast i8* %93 to i32*, !dbg !391
  %95 = load i32, i32* %94, align 4, !dbg !391, !tbaa !392
  %96 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 1, !dbg !393
  store i32 %95, i32* %96, align 4, !dbg !394, !tbaa !395
  %97 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 2, !dbg !396
  store i16 %86, i16* %97, align 4, !dbg !397, !tbaa !398
  %98 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 3, !dbg !399
  store i16 %87, i16* %98, align 2, !dbg !400, !tbaa !401
  call void @llvm.dbg.value(metadata i8* %39, metadata !127, metadata !DIExpression()), !dbg !225
  %99 = load i8, i8* %55, align 1, !dbg !402, !tbaa !324
  %100 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 4, !dbg !403
  store i8 %99, i8* %100, align 4, !dbg !404, !tbaa !405
  %101 = getelementptr inbounds [25 x i8], [25 x i8]* %3, i64 0, i64 0, !dbg !406
  call void @llvm.lifetime.start.p0i8(i64 25, i8* nonnull %101) #3, !dbg !406
  call void @llvm.dbg.declare(metadata [25 x i8]* %3, metadata !195, metadata !DIExpression()), !dbg !406
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(25) %101, i8* nonnull align 1 dereferenceable(25) getelementptr inbounds ([25 x i8], [25 x i8]* @__const.xdp_pass_func.____fmt, i64 0, i64 0), i64 25, i1 false), !dbg !406
  %102 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %101, i32 25) #3, !dbg !406
  call void @llvm.lifetime.end.p0i8(i64 25, i8* nonnull %101) #3, !dbg !407
  %103 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_blocked_flows to i8*), i8* nonnull %88) #3, !dbg !408
  call void @llvm.dbg.value(metadata i8* %103, metadata !200, metadata !DIExpression()), !dbg !225
  %104 = icmp eq i8* %103, null, !dbg !409
  br i1 %104, label %112, label %105, !dbg !410

105:                                              ; preds = %82
  %106 = bitcast i8* %103 to i32*, !dbg !408
  call void @llvm.dbg.value(metadata i32* %106, metadata !200, metadata !DIExpression()), !dbg !225
  %107 = load i32, i32* %106, align 4, !dbg !411, !tbaa !412
  %108 = icmp eq i32 %107, 1, !dbg !413
  br i1 %108, label %109, label %112, !dbg !414

109:                                              ; preds = %105
  %110 = getelementptr inbounds [59 x i8], [59 x i8]* %4, i64 0, i64 0, !dbg !415
  call void @llvm.lifetime.start.p0i8(i64 59, i8* nonnull %110) #3, !dbg !415
  call void @llvm.dbg.declare(metadata [59 x i8]* %4, metadata !202, metadata !DIExpression()), !dbg !415
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(59) %110, i8* nonnull align 1 dereferenceable(59) getelementptr inbounds ([59 x i8], [59 x i8]* @__const.xdp_pass_func.____fmt.1, i64 0, i64 0), i64 59, i1 false), !dbg !415
  %111 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %110, i32 59) #3, !dbg !415
  call void @llvm.lifetime.end.p0i8(i64 59, i8* nonnull %110) #3, !dbg !416
  br label %131, !dbg !417

112:                                              ; preds = %82, %105
  %113 = sub nsw i64 %9, %13, !dbg !418
  call void @llvm.dbg.value(metadata i64 %113, metadata !209, metadata !DIExpression()), !dbg !225
  %114 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_flow_map to i8*), i8* nonnull %88) #3, !dbg !419
  call void @llvm.dbg.value(metadata i8* %114, metadata !210, metadata !DIExpression()), !dbg !225
  %115 = icmp eq i8* %114, null, !dbg !420
  br i1 %115, label %116, label %123, !dbg !421

116:                                              ; preds = %112
  %117 = getelementptr inbounds [44 x i8], [44 x i8]* %5, i64 0, i64 0, !dbg !422
  call void @llvm.lifetime.start.p0i8(i64 44, i8* nonnull %117) #3, !dbg !422
  call void @llvm.dbg.declare(metadata [44 x i8]* %5, metadata !216, metadata !DIExpression()), !dbg !422
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(44) %117, i8* nonnull align 1 dereferenceable(44) getelementptr inbounds ([44 x i8], [44 x i8]* @__const.xdp_pass_func.____fmt.2, i64 0, i64 0), i64 44, i1 false), !dbg !422
  %118 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %117, i32 44) #3, !dbg !422
  call void @llvm.lifetime.end.p0i8(i64 44, i8* nonnull %117) #3, !dbg !423
  %119 = bitcast %struct.info_map* %6 to i8*, !dbg !424
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %119) #3, !dbg !424
  call void @llvm.dbg.declare(metadata %struct.info_map* %6, metadata !223, metadata !DIExpression()), !dbg !425
  %120 = getelementptr inbounds %struct.info_map, %struct.info_map* %6, i64 0, i32 0, !dbg !426
  store i32 1, i32* %120, align 8, !dbg !427, !tbaa !428
  %121 = getelementptr inbounds %struct.info_map, %struct.info_map* %6, i64 0, i32 1, !dbg !431
  store i64 %113, i64* %121, align 8, !dbg !432, !tbaa !433
  %122 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @xdp_flow_map to i8*), i8* nonnull %88, i8* nonnull %119, i64 0) #3, !dbg !434
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %119) #3, !dbg !435
  br label %131, !dbg !436

123:                                              ; preds = %112
  call void @llvm.dbg.value(metadata i8* %114, metadata !210, metadata !DIExpression()), !dbg !225
  %124 = bitcast i8* %114 to i32*, !dbg !437
  %125 = load i32, i32* %124, align 8, !dbg !439, !tbaa !428
  %126 = add i32 %125, 1, !dbg !439
  store i32 %126, i32* %124, align 8, !dbg !439, !tbaa !428
  %127 = getelementptr inbounds i8, i8* %114, i64 8, !dbg !440
  %128 = bitcast i8* %127 to i64*, !dbg !440
  %129 = load i64, i64* %128, align 8, !dbg !441, !tbaa !433
  %130 = add i64 %129, %113, !dbg !441
  store i64 %130, i64* %128, align 8, !dbg !441, !tbaa !433
  br label %131

131:                                              ; preds = %38, %78, %71, %68, %62, %57, %50, %45, %1, %123, %116, %54, %109
  %132 = phi i32 [ 1, %109 ], [ 2, %116 ], [ 2, %123 ], [ 2, %38 ], [ 2, %54 ], [ 0, %1 ], [ 2, %45 ], [ 2, %50 ], [ 0, %57 ], [ 0, %62 ], [ 0, %68 ], [ 0, %71 ], [ 0, %78 ], !dbg !225
  ret i32 %132, !dbg !442
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
declare i16 @llvm.bswap.i16(i16) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #1

attributes #0 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { argmemonly nounwind willreturn }
attributes #3 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!93, !94, !95}
!llvm.ident = !{!96}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "xdp_stats_map", scope: !2, file: !92, line: 16, type: !52, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 10.0.0-4ubuntu1 ", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !43, globals: !49, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "xdp_prog_kern.c", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!4 = !{!5, !14}
!5 = !DICompositeType(tag: DW_TAG_enumeration_type, name: "xdp_action", file: !6, line: 2845, baseType: !7, size: 32, elements: !8)
!6 = !DIFile(filename: "headers/linux/bpf.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
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
!49 = !{!0, !50, !60, !62, !68, !78, !85}
!50 = !DIGlobalVariableExpression(var: !51, expr: !DIExpression())
!51 = distinct !DIGlobalVariable(name: "xdp_flow_map", scope: !2, file: !3, line: 19, type: !52, isLocal: false, isDefinition: true)
!52 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "bpf_map_def", file: !53, line: 33, size: 160, elements: !54)
!53 = !DIFile(filename: "libbpf/src/build/usr/include/bpf/bpf_helpers.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!54 = !{!55, !56, !57, !58, !59}
!55 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !52, file: !53, line: 34, baseType: !7, size: 32)
!56 = !DIDerivedType(tag: DW_TAG_member, name: "key_size", scope: !52, file: !53, line: 35, baseType: !7, size: 32, offset: 32)
!57 = !DIDerivedType(tag: DW_TAG_member, name: "value_size", scope: !52, file: !53, line: 36, baseType: !7, size: 32, offset: 64)
!58 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !52, file: !53, line: 37, baseType: !7, size: 32, offset: 96)
!59 = !DIDerivedType(tag: DW_TAG_member, name: "map_flags", scope: !52, file: !53, line: 38, baseType: !7, size: 32, offset: 128)
!60 = !DIGlobalVariableExpression(var: !61, expr: !DIExpression())
!61 = distinct !DIGlobalVariable(name: "xdp_blocked_flows", scope: !2, file: !3, line: 26, type: !52, isLocal: false, isDefinition: true)
!62 = !DIGlobalVariableExpression(var: !63, expr: !DIExpression())
!63 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 115, type: !64, isLocal: false, isDefinition: true)
!64 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 32, elements: !66)
!65 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!66 = !{!67}
!67 = !DISubrange(count: 4)
!68 = !DIGlobalVariableExpression(var: !69, expr: !DIExpression())
!69 = distinct !DIGlobalVariable(name: "bpf_trace_printk", scope: !2, file: !70, line: 152, type: !71, isLocal: true, isDefinition: true)
!70 = !DIFile(filename: "libbpf/src/build/usr/include/bpf/bpf_helper_defs.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DISubroutineType(types: !73)
!73 = !{!74, !75, !77, null}
!74 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!75 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !76, size: 64)
!76 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !65)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u32", file: !47, line: 27, baseType: !7)
!78 = !DIGlobalVariableExpression(var: !79, expr: !DIExpression())
!79 = distinct !DIGlobalVariable(name: "bpf_map_lookup_elem", scope: !2, file: !70, line: 33, type: !80, isLocal: true, isDefinition: true)
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DISubroutineType(types: !82)
!82 = !{!44, !44, !83}
!83 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !84, size: 64)
!84 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!85 = !DIGlobalVariableExpression(var: !86, expr: !DIExpression())
!86 = distinct !DIGlobalVariable(name: "bpf_map_update_elem", scope: !2, file: !70, line: 55, type: !87, isLocal: true, isDefinition: true)
!87 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!88 = !DISubroutineType(types: !89)
!89 = !{!74, !44, !83, !83, !90}
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u64", file: !47, line: 31, baseType: !91)
!91 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!92 = !DIFile(filename: "././common/xdp_stats_kern.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!93 = !{i32 7, !"Dwarf Version", i32 4}
!94 = !{i32 2, !"Debug Info Version", i32 3}
!95 = !{i32 1, !"wchar_size", i32 4}
!96 = !{!"clang version 10.0.0-4ubuntu1 "}
!97 = distinct !DISubprogram(name: "xdp_pass_func", scope: !3, file: !3, line: 35, type: !98, scopeLine: 35, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !108)
!98 = !DISubroutineType(types: !99)
!99 = !{!74, !100}
!100 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !101, size: 64)
!101 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "xdp_md", file: !6, line: 2856, size: 160, elements: !102)
!102 = !{!103, !104, !105, !106, !107}
!103 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !101, file: !6, line: 2857, baseType: !77, size: 32)
!104 = !DIDerivedType(tag: DW_TAG_member, name: "data_end", scope: !101, file: !6, line: 2858, baseType: !77, size: 32, offset: 32)
!105 = !DIDerivedType(tag: DW_TAG_member, name: "data_meta", scope: !101, file: !6, line: 2859, baseType: !77, size: 32, offset: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "ingress_ifindex", scope: !101, file: !6, line: 2861, baseType: !77, size: 32, offset: 96)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "rx_queue_index", scope: !101, file: !6, line: 2862, baseType: !77, size: 32, offset: 128)
!108 = !{!109, !110, !111, !112, !113, !127, !146, !155, !177, !178, !179, !184, !185, !186, !195, !200, !202, !209, !210, !216, !223, !224}
!109 = !DILocalVariable(name: "ctx", arg: 1, scope: !97, file: !3, line: 35, type: !100)
!110 = !DILocalVariable(name: "action", scope: !97, file: !3, line: 36, type: !77)
!111 = !DILocalVariable(name: "eth_type", scope: !97, file: !3, line: 37, type: !74)
!112 = !DILocalVariable(name: "ip_type", scope: !97, file: !3, line: 37, type: !74)
!113 = !DILocalVariable(name: "eth", scope: !97, file: !3, line: 38, type: !114)
!114 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!115 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ethhdr", file: !116, line: 163, size: 112, elements: !117)
!116 = !DIFile(filename: "/usr/include/linux/if_ether.h", directory: "")
!117 = !{!118, !123, !124}
!118 = !DIDerivedType(tag: DW_TAG_member, name: "h_dest", scope: !115, file: !116, line: 164, baseType: !119, size: 48)
!119 = !DICompositeType(tag: DW_TAG_array_type, baseType: !120, size: 48, elements: !121)
!120 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!121 = !{!122}
!122 = !DISubrange(count: 6)
!123 = !DIDerivedType(tag: DW_TAG_member, name: "h_source", scope: !115, file: !116, line: 165, baseType: !119, size: 48, offset: 48)
!124 = !DIDerivedType(tag: DW_TAG_member, name: "h_proto", scope: !115, file: !116, line: 166, baseType: !125, size: 16, offset: 96)
!125 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be16", file: !126, line: 25, baseType: !46)
!126 = !DIFile(filename: "/usr/include/linux/types.h", directory: "")
!127 = !DILocalVariable(name: "iphdr", scope: !97, file: !3, line: 39, type: !128)
!128 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !129, size: 64)
!129 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "iphdr", file: !130, line: 86, size: 160, elements: !131)
!130 = !DIFile(filename: "/usr/include/linux/ip.h", directory: "")
!131 = !{!132, !134, !135, !136, !137, !138, !139, !140, !141, !143, !145}
!132 = !DIDerivedType(tag: DW_TAG_member, name: "ihl", scope: !129, file: !130, line: 88, baseType: !133, size: 4, flags: DIFlagBitField, extraData: i64 0)
!133 = !DIDerivedType(tag: DW_TAG_typedef, name: "__u8", file: !47, line: 21, baseType: !120)
!134 = !DIDerivedType(tag: DW_TAG_member, name: "version", scope: !129, file: !130, line: 89, baseType: !133, size: 4, offset: 4, flags: DIFlagBitField, extraData: i64 0)
!135 = !DIDerivedType(tag: DW_TAG_member, name: "tos", scope: !129, file: !130, line: 96, baseType: !133, size: 8, offset: 8)
!136 = !DIDerivedType(tag: DW_TAG_member, name: "tot_len", scope: !129, file: !130, line: 97, baseType: !125, size: 16, offset: 16)
!137 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !129, file: !130, line: 98, baseType: !125, size: 16, offset: 32)
!138 = !DIDerivedType(tag: DW_TAG_member, name: "frag_off", scope: !129, file: !130, line: 99, baseType: !125, size: 16, offset: 48)
!139 = !DIDerivedType(tag: DW_TAG_member, name: "ttl", scope: !129, file: !130, line: 100, baseType: !133, size: 8, offset: 64)
!140 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !129, file: !130, line: 101, baseType: !133, size: 8, offset: 72)
!141 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !129, file: !130, line: 102, baseType: !142, size: 16, offset: 80)
!142 = !DIDerivedType(tag: DW_TAG_typedef, name: "__sum16", file: !126, line: 31, baseType: !46)
!143 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !129, file: !130, line: 103, baseType: !144, size: 32, offset: 96)
!144 = !DIDerivedType(tag: DW_TAG_typedef, name: "__be32", file: !126, line: 27, baseType: !77)
!145 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !129, file: !130, line: 104, baseType: !144, size: 32, offset: 128)
!146 = !DILocalVariable(name: "udphdr", scope: !97, file: !3, line: 40, type: !147)
!147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !148, size: 64)
!148 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "udphdr", file: !149, line: 23, size: 64, elements: !150)
!149 = !DIFile(filename: "/usr/include/linux/udp.h", directory: "")
!150 = !{!151, !152, !153, !154}
!151 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !148, file: !149, line: 24, baseType: !125, size: 16)
!152 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !148, file: !149, line: 25, baseType: !125, size: 16, offset: 16)
!153 = !DIDerivedType(tag: DW_TAG_member, name: "len", scope: !148, file: !149, line: 26, baseType: !125, size: 16, offset: 32)
!154 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !148, file: !149, line: 27, baseType: !142, size: 16, offset: 48)
!155 = !DILocalVariable(name: "tcphdr", scope: !97, file: !3, line: 41, type: !156)
!156 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !157, size: 64)
!157 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tcphdr", file: !158, line: 25, size: 160, elements: !159)
!158 = !DIFile(filename: "/usr/include/linux/tcp.h", directory: "")
!159 = !{!160, !161, !162, !163, !164, !165, !166, !167, !168, !169, !170, !171, !172, !173, !174, !175, !176}
!160 = !DIDerivedType(tag: DW_TAG_member, name: "source", scope: !157, file: !158, line: 26, baseType: !125, size: 16)
!161 = !DIDerivedType(tag: DW_TAG_member, name: "dest", scope: !157, file: !158, line: 27, baseType: !125, size: 16, offset: 16)
!162 = !DIDerivedType(tag: DW_TAG_member, name: "seq", scope: !157, file: !158, line: 28, baseType: !144, size: 32, offset: 32)
!163 = !DIDerivedType(tag: DW_TAG_member, name: "ack_seq", scope: !157, file: !158, line: 29, baseType: !144, size: 32, offset: 64)
!164 = !DIDerivedType(tag: DW_TAG_member, name: "res1", scope: !157, file: !158, line: 31, baseType: !46, size: 4, offset: 96, flags: DIFlagBitField, extraData: i64 96)
!165 = !DIDerivedType(tag: DW_TAG_member, name: "doff", scope: !157, file: !158, line: 32, baseType: !46, size: 4, offset: 100, flags: DIFlagBitField, extraData: i64 96)
!166 = !DIDerivedType(tag: DW_TAG_member, name: "fin", scope: !157, file: !158, line: 33, baseType: !46, size: 1, offset: 104, flags: DIFlagBitField, extraData: i64 96)
!167 = !DIDerivedType(tag: DW_TAG_member, name: "syn", scope: !157, file: !158, line: 34, baseType: !46, size: 1, offset: 105, flags: DIFlagBitField, extraData: i64 96)
!168 = !DIDerivedType(tag: DW_TAG_member, name: "rst", scope: !157, file: !158, line: 35, baseType: !46, size: 1, offset: 106, flags: DIFlagBitField, extraData: i64 96)
!169 = !DIDerivedType(tag: DW_TAG_member, name: "psh", scope: !157, file: !158, line: 36, baseType: !46, size: 1, offset: 107, flags: DIFlagBitField, extraData: i64 96)
!170 = !DIDerivedType(tag: DW_TAG_member, name: "ack", scope: !157, file: !158, line: 37, baseType: !46, size: 1, offset: 108, flags: DIFlagBitField, extraData: i64 96)
!171 = !DIDerivedType(tag: DW_TAG_member, name: "urg", scope: !157, file: !158, line: 38, baseType: !46, size: 1, offset: 109, flags: DIFlagBitField, extraData: i64 96)
!172 = !DIDerivedType(tag: DW_TAG_member, name: "ece", scope: !157, file: !158, line: 39, baseType: !46, size: 1, offset: 110, flags: DIFlagBitField, extraData: i64 96)
!173 = !DIDerivedType(tag: DW_TAG_member, name: "cwr", scope: !157, file: !158, line: 40, baseType: !46, size: 1, offset: 111, flags: DIFlagBitField, extraData: i64 96)
!174 = !DIDerivedType(tag: DW_TAG_member, name: "window", scope: !157, file: !158, line: 55, baseType: !125, size: 16, offset: 112)
!175 = !DIDerivedType(tag: DW_TAG_member, name: "check", scope: !157, file: !158, line: 56, baseType: !142, size: 16, offset: 128)
!176 = !DIDerivedType(tag: DW_TAG_member, name: "urg_ptr", scope: !157, file: !158, line: 57, baseType: !125, size: 16, offset: 144)
!177 = !DILocalVariable(name: "data_end", scope: !97, file: !3, line: 42, type: !44)
!178 = !DILocalVariable(name: "data", scope: !97, file: !3, line: 43, type: !44)
!179 = !DILocalVariable(name: "nh", scope: !97, file: !3, line: 44, type: !180)
!180 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "hdr_cursor", file: !181, line: 33, size: 64, elements: !182)
!181 = !DIFile(filename: "././common/parsing_helpers.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!182 = !{!183}
!183 = !DIDerivedType(tag: DW_TAG_member, name: "pos", scope: !180, file: !181, line: 34, baseType: !44, size: 64)
!184 = !DILocalVariable(name: "sport", scope: !97, file: !3, line: 58, type: !125)
!185 = !DILocalVariable(name: "dport", scope: !97, file: !3, line: 58, type: !125)
!186 = !DILocalVariable(name: "curr_flow", scope: !97, file: !3, line: 79, type: !187)
!187 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "flow", file: !188, line: 5, size: 128, elements: !189)
!188 = !DIFile(filename: "./common_kern_user_datastructure.h", directory: "/home/albert/Documents/TMA_github/eBPF_code")
!189 = !{!190, !191, !192, !193, !194}
!190 = !DIDerivedType(tag: DW_TAG_member, name: "saddr", scope: !187, file: !188, line: 6, baseType: !144, size: 32)
!191 = !DIDerivedType(tag: DW_TAG_member, name: "daddr", scope: !187, file: !188, line: 7, baseType: !144, size: 32, offset: 32)
!192 = !DIDerivedType(tag: DW_TAG_member, name: "sport", scope: !187, file: !188, line: 8, baseType: !125, size: 16, offset: 64)
!193 = !DIDerivedType(tag: DW_TAG_member, name: "dport", scope: !187, file: !188, line: 9, baseType: !125, size: 16, offset: 80)
!194 = !DIDerivedType(tag: DW_TAG_member, name: "protocol", scope: !187, file: !188, line: 10, baseType: !133, size: 8, offset: 96)
!195 = !DILocalVariable(name: "____fmt", scope: !196, file: !3, line: 87, type: !197)
!196 = distinct !DILexicalBlock(scope: !97, file: !3, line: 87, column: 2)
!197 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 200, elements: !198)
!198 = !{!199}
!199 = !DISubrange(count: 25)
!200 = !DILocalVariable(name: "blocked", scope: !97, file: !3, line: 89, type: !201)
!201 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !77, size: 64)
!202 = !DILocalVariable(name: "____fmt", scope: !203, file: !3, line: 91, type: !206)
!203 = distinct !DILexicalBlock(scope: !204, file: !3, line: 91, column: 3)
!204 = distinct !DILexicalBlock(scope: !205, file: !3, line: 90, column: 32)
!205 = distinct !DILexicalBlock(scope: !97, file: !3, line: 90, column: 6)
!206 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 472, elements: !207)
!207 = !{!208}
!208 = !DISubrange(count: 59)
!209 = !DILocalVariable(name: "pack_length", scope: !97, file: !3, line: 95, type: !90)
!210 = !DILocalVariable(name: "data_map", scope: !97, file: !3, line: 96, type: !211)
!211 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !212, size: 64)
!212 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "info_map", file: !188, line: 13, size: 128, elements: !213)
!213 = !{!214, !215}
!214 = !DIDerivedType(tag: DW_TAG_member, name: "packets", scope: !212, file: !188, line: 14, baseType: !77, size: 32)
!215 = !DIDerivedType(tag: DW_TAG_member, name: "bytes", scope: !212, file: !188, line: 15, baseType: !90, size: 64, offset: 64)
!216 = !DILocalVariable(name: "____fmt", scope: !217, file: !3, line: 99, type: !220)
!217 = distinct !DILexicalBlock(scope: !218, file: !3, line: 99, column: 3)
!218 = distinct !DILexicalBlock(scope: !219, file: !3, line: 98, column: 24)
!219 = distinct !DILexicalBlock(scope: !97, file: !3, line: 98, column: 6)
!220 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 352, elements: !221)
!221 = !{!222}
!222 = !DISubrange(count: 44)
!223 = !DILocalVariable(name: "new_data", scope: !218, file: !3, line: 100, type: !212)
!224 = !DILabel(scope: !97, name: "out", file: !3, line: 111)
!225 = !DILocation(line: 0, scope: !97)
!226 = !DILocation(line: 42, column: 38, scope: !97)
!227 = !{!228, !229, i64 4}
!228 = !{!"xdp_md", !229, i64 0, !229, i64 4, !229, i64 8, !229, i64 12, !229, i64 16}
!229 = !{!"int", !230, i64 0}
!230 = !{!"omnipotent char", !231, i64 0}
!231 = !{!"Simple C/C++ TBAA"}
!232 = !DILocation(line: 42, column: 27, scope: !97)
!233 = !DILocation(line: 42, column: 19, scope: !97)
!234 = !DILocation(line: 43, column: 34, scope: !97)
!235 = !{!228, !229, i64 0}
!236 = !DILocation(line: 43, column: 23, scope: !97)
!237 = !DILocation(line: 43, column: 15, scope: !97)
!238 = !DILocalVariable(name: "nh", arg: 1, scope: !239, file: !181, line: 124, type: !242)
!239 = distinct !DISubprogram(name: "parse_ethhdr", scope: !181, file: !181, line: 124, type: !240, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !244)
!240 = !DISubroutineType(types: !241)
!241 = !{!74, !242, !44, !243}
!242 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !180, size: 64)
!243 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!244 = !{!238, !245, !246}
!245 = !DILocalVariable(name: "data_end", arg: 2, scope: !239, file: !181, line: 125, type: !44)
!246 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !239, file: !181, line: 126, type: !243)
!247 = !DILocation(line: 0, scope: !239, inlinedAt: !248)
!248 = distinct !DILocation(line: 46, column: 13, scope: !97)
!249 = !DILocalVariable(name: "nh", arg: 1, scope: !250, file: !181, line: 79, type: !242)
!250 = distinct !DISubprogram(name: "parse_ethhdr_vlan", scope: !181, file: !181, line: 79, type: !251, scopeLine: 83, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !260)
!251 = !DISubroutineType(types: !252)
!252 = !{!74, !242, !44, !243, !253}
!253 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !254, size: 64)
!254 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "collect_vlans", file: !181, line: 64, size: 32, elements: !255)
!255 = !{!256}
!256 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !254, file: !181, line: 65, baseType: !257, size: 32)
!257 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 32, elements: !258)
!258 = !{!259}
!259 = !DISubrange(count: 2)
!260 = !{!249, !261, !262, !263, !264, !265, !266, !272, !273}
!261 = !DILocalVariable(name: "data_end", arg: 2, scope: !250, file: !181, line: 80, type: !44)
!262 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !250, file: !181, line: 81, type: !243)
!263 = !DILocalVariable(name: "vlans", arg: 4, scope: !250, file: !181, line: 82, type: !253)
!264 = !DILocalVariable(name: "eth", scope: !250, file: !181, line: 84, type: !114)
!265 = !DILocalVariable(name: "hdrsize", scope: !250, file: !181, line: 85, type: !74)
!266 = !DILocalVariable(name: "vlh", scope: !250, file: !181, line: 86, type: !267)
!267 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !268, size: 64)
!268 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !181, line: 42, size: 32, elements: !269)
!269 = !{!270, !271}
!270 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !268, file: !181, line: 43, baseType: !125, size: 16)
!271 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !268, file: !181, line: 44, baseType: !125, size: 16, offset: 16)
!272 = !DILocalVariable(name: "h_proto", scope: !250, file: !181, line: 87, type: !46)
!273 = !DILocalVariable(name: "i", scope: !250, file: !181, line: 88, type: !74)
!274 = !DILocation(line: 0, scope: !250, inlinedAt: !275)
!275 = distinct !DILocation(line: 129, column: 9, scope: !239, inlinedAt: !248)
!276 = !DILocation(line: 93, column: 14, scope: !277, inlinedAt: !275)
!277 = distinct !DILexicalBlock(scope: !250, file: !181, line: 93, column: 6)
!278 = !DILocation(line: 93, column: 24, scope: !277, inlinedAt: !275)
!279 = !DILocation(line: 93, column: 6, scope: !250, inlinedAt: !275)
!280 = !DILocation(line: 99, column: 17, scope: !250, inlinedAt: !275)
!281 = !{!282, !282, i64 0}
!282 = !{!"short", !230, i64 0}
!283 = !DILocation(line: 0, scope: !284, inlinedAt: !275)
!284 = distinct !DILexicalBlock(scope: !285, file: !181, line: 109, column: 7)
!285 = distinct !DILexicalBlock(scope: !286, file: !181, line: 105, column: 39)
!286 = distinct !DILexicalBlock(scope: !287, file: !181, line: 105, column: 2)
!287 = distinct !DILexicalBlock(scope: !250, file: !181, line: 105, column: 2)
!288 = !DILocation(line: 105, column: 2, scope: !287, inlinedAt: !275)
!289 = !DILocation(line: 106, column: 7, scope: !285, inlinedAt: !275)
!290 = !DILocation(line: 109, column: 11, scope: !284, inlinedAt: !275)
!291 = !DILocation(line: 109, column: 15, scope: !284, inlinedAt: !275)
!292 = !DILocation(line: 109, column: 7, scope: !285, inlinedAt: !275)
!293 = !DILocation(line: 112, column: 18, scope: !285, inlinedAt: !275)
!294 = !DILocation(line: 52, column: 15, scope: !295)
!295 = distinct !DILexicalBlock(scope: !97, file: !3, line: 52, column: 6)
!296 = !DILocation(line: 158, column: 10, scope: !297, inlinedAt: !308)
!297 = distinct !DILexicalBlock(scope: !298, file: !181, line: 158, column: 6)
!298 = distinct !DISubprogram(name: "parse_iphdr", scope: !181, file: !181, line: 151, type: !299, scopeLine: 154, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !302)
!299 = !DISubroutineType(types: !300)
!300 = !{!74, !242, !44, !301}
!301 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!302 = !{!303, !304, !305, !306, !307}
!303 = !DILocalVariable(name: "nh", arg: 1, scope: !298, file: !181, line: 151, type: !242)
!304 = !DILocalVariable(name: "data_end", arg: 2, scope: !298, file: !181, line: 152, type: !44)
!305 = !DILocalVariable(name: "iphdr", arg: 3, scope: !298, file: !181, line: 153, type: !301)
!306 = !DILocalVariable(name: "iph", scope: !298, file: !181, line: 155, type: !128)
!307 = !DILocalVariable(name: "hdrsize", scope: !298, file: !181, line: 156, type: !74)
!308 = distinct !DILocation(line: 53, column: 13, scope: !309)
!309 = distinct !DILexicalBlock(scope: !295, file: !3, line: 52, column: 39)
!310 = !DILocation(line: 158, column: 14, scope: !297, inlinedAt: !308)
!311 = !DILocation(line: 52, column: 6, scope: !97)
!312 = !DILocation(line: 0, scope: !298, inlinedAt: !308)
!313 = !DILocation(line: 161, column: 17, scope: !298, inlinedAt: !308)
!314 = !DILocation(line: 161, column: 21, scope: !298, inlinedAt: !308)
!315 = !DILocation(line: 163, column: 13, scope: !316, inlinedAt: !308)
!316 = distinct !DILexicalBlock(scope: !298, file: !181, line: 163, column: 5)
!317 = !DILocation(line: 163, column: 5, scope: !298, inlinedAt: !308)
!318 = !DILocation(line: 163, column: 5, scope: !316, inlinedAt: !308)
!319 = !DILocation(line: 167, column: 14, scope: !320, inlinedAt: !308)
!320 = distinct !DILexicalBlock(scope: !298, file: !181, line: 167, column: 6)
!321 = !DILocation(line: 167, column: 24, scope: !320, inlinedAt: !308)
!322 = !DILocation(line: 167, column: 6, scope: !298, inlinedAt: !308)
!323 = !DILocation(line: 173, column: 14, scope: !298, inlinedAt: !308)
!324 = !{!325, !230, i64 9}
!325 = !{!"iphdr", !230, i64 0, !230, i64 0, !230, i64 1, !282, i64 2, !282, i64 4, !282, i64 6, !230, i64 8, !230, i64 9, !282, i64 10, !229, i64 12, !229, i64 16}
!326 = !DILocation(line: 61, column: 6, scope: !97)
!327 = !DILocalVariable(name: "nh", arg: 1, scope: !328, file: !181, line: 224, type: !242)
!328 = distinct !DISubprogram(name: "parse_udphdr", scope: !181, file: !181, line: 224, type: !329, scopeLine: 227, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !332)
!329 = !DISubroutineType(types: !330)
!330 = !{!74, !242, !44, !331}
!331 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64)
!332 = !{!327, !333, !334, !335, !336}
!333 = !DILocalVariable(name: "data_end", arg: 2, scope: !328, file: !181, line: 225, type: !44)
!334 = !DILocalVariable(name: "udphdr", arg: 3, scope: !328, file: !181, line: 226, type: !331)
!335 = !DILocalVariable(name: "len", scope: !328, file: !181, line: 228, type: !74)
!336 = !DILocalVariable(name: "h", scope: !328, file: !181, line: 229, type: !147)
!337 = !DILocation(line: 0, scope: !328, inlinedAt: !338)
!338 = distinct !DILocation(line: 62, column: 7, scope: !339)
!339 = distinct !DILexicalBlock(scope: !340, file: !3, line: 62, column: 7)
!340 = distinct !DILexicalBlock(scope: !341, file: !3, line: 61, column: 30)
!341 = distinct !DILexicalBlock(scope: !97, file: !3, line: 61, column: 6)
!342 = !DILocation(line: 231, column: 8, scope: !343, inlinedAt: !338)
!343 = distinct !DILexicalBlock(scope: !328, file: !181, line: 231, column: 6)
!344 = !DILocation(line: 231, column: 14, scope: !343, inlinedAt: !338)
!345 = !DILocation(line: 231, column: 12, scope: !343, inlinedAt: !338)
!346 = !DILocation(line: 231, column: 6, scope: !328, inlinedAt: !338)
!347 = !DILocation(line: 237, column: 8, scope: !328, inlinedAt: !338)
!348 = !{!349, !282, i64 4}
!349 = !{!"udphdr", !282, i64 0, !282, i64 2, !282, i64 4, !282, i64 6}
!350 = !DILocation(line: 238, column: 10, scope: !351, inlinedAt: !338)
!351 = distinct !DILexicalBlock(scope: !328, file: !181, line: 238, column: 6)
!352 = !DILocation(line: 238, column: 6, scope: !328, inlinedAt: !338)
!353 = !DILocalVariable(name: "nh", arg: 1, scope: !354, file: !181, line: 247, type: !242)
!354 = distinct !DISubprogram(name: "parse_tcphdr", scope: !181, file: !181, line: 247, type: !355, scopeLine: 250, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !358)
!355 = !DISubroutineType(types: !356)
!356 = !{!74, !242, !44, !357}
!357 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!358 = !{!353, !359, !360, !361, !362}
!359 = !DILocalVariable(name: "data_end", arg: 2, scope: !354, file: !181, line: 248, type: !44)
!360 = !DILocalVariable(name: "tcphdr", arg: 3, scope: !354, file: !181, line: 249, type: !357)
!361 = !DILocalVariable(name: "len", scope: !354, file: !181, line: 251, type: !74)
!362 = !DILocalVariable(name: "h", scope: !354, file: !181, line: 252, type: !156)
!363 = !DILocation(line: 0, scope: !354, inlinedAt: !364)
!364 = distinct !DILocation(line: 69, column: 7, scope: !365)
!365 = distinct !DILexicalBlock(scope: !366, file: !3, line: 69, column: 7)
!366 = distinct !DILexicalBlock(scope: !367, file: !3, line: 68, column: 37)
!367 = distinct !DILexicalBlock(scope: !341, file: !3, line: 68, column: 13)
!368 = !DILocation(line: 254, column: 8, scope: !369, inlinedAt: !364)
!369 = distinct !DILexicalBlock(scope: !354, file: !181, line: 254, column: 6)
!370 = !DILocation(line: 254, column: 12, scope: !369, inlinedAt: !364)
!371 = !DILocation(line: 254, column: 6, scope: !354, inlinedAt: !364)
!372 = !DILocation(line: 257, column: 11, scope: !354, inlinedAt: !364)
!373 = !DILocation(line: 257, column: 16, scope: !354, inlinedAt: !364)
!374 = !DILocation(line: 259, column: 9, scope: !375, inlinedAt: !364)
!375 = distinct !DILexicalBlock(scope: !354, file: !181, line: 259, column: 5)
!376 = !DILocation(line: 259, column: 5, scope: !354, inlinedAt: !364)
!377 = !DILocation(line: 259, column: 5, scope: !375, inlinedAt: !364)
!378 = !DILocation(line: 263, column: 14, scope: !379, inlinedAt: !364)
!379 = distinct !DILexicalBlock(scope: !354, file: !181, line: 263, column: 6)
!380 = !DILocation(line: 263, column: 20, scope: !379, inlinedAt: !364)
!381 = !DILocation(line: 263, column: 6, scope: !354, inlinedAt: !364)
!382 = !DILocation(line: 0, scope: !341)
!383 = !DILocation(line: 79, column: 14, scope: !97)
!384 = !DILocation(line: 80, column: 2, scope: !97)
!385 = !DILocation(line: 81, column: 27, scope: !97)
!386 = !{!325, !229, i64 12}
!387 = !DILocation(line: 81, column: 12, scope: !97)
!388 = !DILocation(line: 81, column: 18, scope: !97)
!389 = !{!390, !229, i64 0}
!390 = !{!"flow", !229, i64 0, !229, i64 4, !282, i64 8, !282, i64 10, !230, i64 12}
!391 = !DILocation(line: 82, column: 27, scope: !97)
!392 = !{!325, !229, i64 16}
!393 = !DILocation(line: 82, column: 12, scope: !97)
!394 = !DILocation(line: 82, column: 18, scope: !97)
!395 = !{!390, !229, i64 4}
!396 = !DILocation(line: 83, column: 12, scope: !97)
!397 = !DILocation(line: 83, column: 18, scope: !97)
!398 = !{!390, !282, i64 8}
!399 = !DILocation(line: 84, column: 12, scope: !97)
!400 = !DILocation(line: 84, column: 18, scope: !97)
!401 = !{!390, !282, i64 10}
!402 = !DILocation(line: 85, column: 30, scope: !97)
!403 = !DILocation(line: 85, column: 12, scope: !97)
!404 = !DILocation(line: 85, column: 21, scope: !97)
!405 = !{!390, !230, i64 12}
!406 = !DILocation(line: 87, column: 2, scope: !196)
!407 = !DILocation(line: 87, column: 2, scope: !97)
!408 = !DILocation(line: 89, column: 19, scope: !97)
!409 = !DILocation(line: 90, column: 6, scope: !205)
!410 = !DILocation(line: 90, column: 14, scope: !205)
!411 = !DILocation(line: 90, column: 17, scope: !205)
!412 = !{!229, !229, i64 0}
!413 = !DILocation(line: 90, column: 26, scope: !205)
!414 = !DILocation(line: 90, column: 6, scope: !97)
!415 = !DILocation(line: 91, column: 3, scope: !203)
!416 = !DILocation(line: 91, column: 3, scope: !204)
!417 = !DILocation(line: 92, column: 3, scope: !204)
!418 = !DILocation(line: 95, column: 31, scope: !97)
!419 = !DILocation(line: 96, column: 30, scope: !97)
!420 = !DILocation(line: 98, column: 15, scope: !219)
!421 = !DILocation(line: 98, column: 6, scope: !97)
!422 = !DILocation(line: 99, column: 3, scope: !217)
!423 = !DILocation(line: 99, column: 3, scope: !218)
!424 = !DILocation(line: 100, column: 3, scope: !218)
!425 = !DILocation(line: 100, column: 19, scope: !218)
!426 = !DILocation(line: 101, column: 12, scope: !218)
!427 = !DILocation(line: 101, column: 20, scope: !218)
!428 = !{!429, !229, i64 0}
!429 = !{!"info_map", !229, i64 0, !430, i64 8}
!430 = !{!"long long", !230, i64 0}
!431 = !DILocation(line: 102, column: 12, scope: !218)
!432 = !DILocation(line: 102, column: 18, scope: !218)
!433 = !{!429, !430, i64 8}
!434 = !DILocation(line: 103, column: 3, scope: !218)
!435 = !DILocation(line: 104, column: 2, scope: !219)
!436 = !DILocation(line: 104, column: 2, scope: !218)
!437 = !DILocation(line: 105, column: 13, scope: !438)
!438 = distinct !DILexicalBlock(scope: !219, file: !3, line: 104, column: 9)
!439 = !DILocation(line: 105, column: 20, scope: !438)
!440 = !DILocation(line: 106, column: 13, scope: !438)
!441 = !DILocation(line: 106, column: 19, scope: !438)
!442 = !DILocation(line: 113, column: 1, scope: !97)
