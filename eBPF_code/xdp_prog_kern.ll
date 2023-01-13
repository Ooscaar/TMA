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
@xdp_flow_map = dso_local global %struct.bpf_map_def { i32 1, i32 16, i32 4, i32 15000, i32 0 }, section "maps", align 4, !dbg !50
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
  %5 = alloca i32, align 4
  %6 = alloca [44 x i8], align 1
  call void @llvm.dbg.value(metadata %struct.xdp_md* %0, metadata !109, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i32 2, metadata !110, metadata !DIExpression()), !dbg !219
  %7 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 1, !dbg !220
  %8 = load i32, i32* %7, align 4, !dbg !220, !tbaa !221
  %9 = zext i32 %8 to i64, !dbg !226
  %10 = inttoptr i64 %9 to i8*, !dbg !227
  call void @llvm.dbg.value(metadata i8* %10, metadata !177, metadata !DIExpression()), !dbg !219
  %11 = getelementptr inbounds %struct.xdp_md, %struct.xdp_md* %0, i64 0, i32 0, !dbg !228
  %12 = load i32, i32* %11, align 4, !dbg !228, !tbaa !229
  %13 = zext i32 %12 to i64, !dbg !230
  %14 = inttoptr i64 %13 to i8*, !dbg !231
  call void @llvm.dbg.value(metadata i8* %14, metadata !178, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i8* %14, metadata !179, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !113, metadata !DIExpression(DW_OP_deref)), !dbg !219
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !232, metadata !DIExpression()), !dbg !241
  call void @llvm.dbg.value(metadata i8* %10, metadata !239, metadata !DIExpression()), !dbg !241
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !240, metadata !DIExpression()), !dbg !241
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !243, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata i8* %10, metadata !255, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata %struct.ethhdr** undef, metadata !256, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata %struct.collect_vlans* null, metadata !257, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata i8* %14, metadata !258, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata i32 14, metadata !259, metadata !DIExpression()), !dbg !268
  %15 = getelementptr i8, i8* %14, i64 14, !dbg !270
  %16 = icmp ugt i8* %15, %10, !dbg !272
  br i1 %16, label %124, label %17, !dbg !273

17:                                               ; preds = %1
  call void @llvm.dbg.value(metadata i8* %14, metadata !258, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata i8* %15, metadata !179, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i8* %15, metadata !260, metadata !DIExpression()), !dbg !268
  %18 = getelementptr inbounds i8, i8* %14, i64 12, !dbg !274
  %19 = bitcast i8* %18 to i16*, !dbg !274
  call void @llvm.dbg.value(metadata i16 undef, metadata !266, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata i32 0, metadata !267, metadata !DIExpression()), !dbg !268
  %20 = load i16, i16* %19, align 1, !dbg !268, !tbaa !275
  call void @llvm.dbg.value(metadata i16 %20, metadata !266, metadata !DIExpression()), !dbg !268
  %21 = inttoptr i64 %9 to %struct.vlan_hdr*, !dbg !277
  %22 = getelementptr i8, i8* %14, i64 22, !dbg !282
  %23 = bitcast i8* %22 to %struct.vlan_hdr*, !dbg !282
  switch i16 %20, label %38 [
    i16 -22392, label %24
    i16 129, label %24
  ], !dbg !283

24:                                               ; preds = %17, %17
  %25 = getelementptr i8, i8* %14, i64 18, !dbg !284
  %26 = bitcast i8* %25 to %struct.vlan_hdr*, !dbg !284
  %27 = icmp ugt %struct.vlan_hdr* %26, %21, !dbg !285
  br i1 %27, label %38, label %28, !dbg !286

28:                                               ; preds = %24
  call void @llvm.dbg.value(metadata i16 undef, metadata !266, metadata !DIExpression()), !dbg !268
  %29 = getelementptr i8, i8* %14, i64 16, !dbg !287
  %30 = bitcast i8* %29 to i16*, !dbg !287
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %26, metadata !260, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata i32 1, metadata !267, metadata !DIExpression()), !dbg !268
  %31 = load i16, i16* %30, align 1, !dbg !268, !tbaa !275
  call void @llvm.dbg.value(metadata i16 %31, metadata !266, metadata !DIExpression()), !dbg !268
  switch i16 %31, label %38 [
    i16 -22392, label %32
    i16 129, label %32
  ], !dbg !283

32:                                               ; preds = %28, %28
  %33 = icmp ugt %struct.vlan_hdr* %23, %21, !dbg !285
  br i1 %33, label %38, label %34, !dbg !286

34:                                               ; preds = %32
  call void @llvm.dbg.value(metadata i16 undef, metadata !266, metadata !DIExpression()), !dbg !268
  %35 = getelementptr i8, i8* %14, i64 20, !dbg !287
  %36 = bitcast i8* %35 to i16*, !dbg !287
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* %23, metadata !260, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata i32 2, metadata !267, metadata !DIExpression()), !dbg !268
  %37 = load i16, i16* %36, align 1, !dbg !268, !tbaa !275
  call void @llvm.dbg.value(metadata i16 %37, metadata !266, metadata !DIExpression()), !dbg !268
  br label %38

38:                                               ; preds = %34, %32, %28, %24, %17
  %39 = phi i8* [ %15, %17 ], [ %15, %24 ], [ %25, %28 ], [ %25, %32 ], [ %22, %34 ], !dbg !268
  %40 = phi i16 [ %20, %17 ], [ %20, %24 ], [ %31, %28 ], [ %31, %32 ], [ %37, %34 ], !dbg !268
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !260, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !260, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata %struct.vlan_hdr* undef, metadata !260, metadata !DIExpression()), !dbg !268
  call void @llvm.dbg.value(metadata i8* %39, metadata !179, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i8* %39, metadata !179, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i16 %40, metadata !111, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i16 %40, metadata !111, metadata !DIExpression()), !dbg !219
  %41 = icmp ne i16 %40, 8, !dbg !288
  %42 = getelementptr inbounds i8, i8* %39, i64 20, !dbg !290
  %43 = icmp ugt i8* %42, %10, !dbg !304
  %44 = or i1 %41, %43, !dbg !305
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !297, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.value(metadata i8* %10, metadata !298, metadata !DIExpression()), !dbg !306
  call void @llvm.dbg.value(metadata i8* %39, metadata !300, metadata !DIExpression()), !dbg !306
  br i1 %44, label %124, label %45, !dbg !305

45:                                               ; preds = %38
  %46 = load i8, i8* %39, align 4, !dbg !307
  %47 = shl i8 %46, 2, !dbg !308
  %48 = and i8 %47, 60, !dbg !308
  call void @llvm.dbg.value(metadata i8 %48, metadata !301, metadata !DIExpression()), !dbg !306
  %49 = icmp ult i8 %48, 20, !dbg !309
  br i1 %49, label %124, label %50, !dbg !311

50:                                               ; preds = %45
  %51 = zext i8 %48 to i64, !dbg !312
  call void @llvm.dbg.value(metadata i64 %51, metadata !301, metadata !DIExpression()), !dbg !306
  %52 = getelementptr i8, i8* %39, i64 %51, !dbg !313
  %53 = icmp ugt i8* %52, %10, !dbg !315
  br i1 %53, label %124, label %54, !dbg !316

54:                                               ; preds = %50
  call void @llvm.dbg.value(metadata i8* %52, metadata !179, metadata !DIExpression()), !dbg !219
  %55 = getelementptr inbounds i8, i8* %39, i64 9, !dbg !317
  %56 = load i8, i8* %55, align 1, !dbg !317, !tbaa !318
  call void @llvm.dbg.value(metadata i8* %52, metadata !179, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i16 0, metadata !185, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i16 0, metadata !184, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i8 %56, metadata !112, metadata !DIExpression(DW_OP_LLVM_convert, 8, DW_ATE_signed, DW_OP_LLVM_convert, 32, DW_ATE_signed, DW_OP_stack_value)), !dbg !219
  switch i8 %56, label %124 [
    i8 17, label %57
    i8 6, label %68
  ], !dbg !320

57:                                               ; preds = %54
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !321, metadata !DIExpression()) #3, !dbg !331
  call void @llvm.dbg.value(metadata i8* %10, metadata !327, metadata !DIExpression()) #3, !dbg !331
  call void @llvm.dbg.value(metadata i8* %52, metadata !330, metadata !DIExpression()) #3, !dbg !331
  %58 = getelementptr inbounds i8, i8* %52, i64 8, !dbg !336
  %59 = bitcast i8* %58 to %struct.udphdr*, !dbg !336
  %60 = inttoptr i64 %9 to %struct.udphdr*, !dbg !338
  %61 = icmp ugt %struct.udphdr* %59, %60, !dbg !339
  br i1 %61, label %124, label %62, !dbg !340

62:                                               ; preds = %57
  call void @llvm.dbg.value(metadata %struct.udphdr* %59, metadata !179, metadata !DIExpression()), !dbg !219
  %63 = getelementptr inbounds i8, i8* %52, i64 4, !dbg !341
  %64 = bitcast i8* %63 to i16*, !dbg !341
  %65 = load i16, i16* %64, align 2, !dbg !341, !tbaa !342
  %66 = tail call i16 @llvm.bswap.i16(i16 %65) #3
  call void @llvm.dbg.value(metadata i16 %66, metadata !329, metadata !DIExpression(DW_OP_constu, 8, DW_OP_minus, DW_OP_stack_value)) #3, !dbg !331
  %67 = icmp ult i16 %66, 8, !dbg !344
  br i1 %67, label %124, label %82, !dbg !346

68:                                               ; preds = %54
  call void @llvm.dbg.value(metadata %struct.hdr_cursor* undef, metadata !347, metadata !DIExpression()), !dbg !357
  call void @llvm.dbg.value(metadata i8* %10, metadata !353, metadata !DIExpression()), !dbg !357
  call void @llvm.dbg.value(metadata i8* %52, metadata !356, metadata !DIExpression()), !dbg !357
  %69 = getelementptr inbounds i8, i8* %52, i64 20, !dbg !362
  %70 = icmp ugt i8* %69, %10, !dbg !364
  br i1 %70, label %124, label %71, !dbg !365

71:                                               ; preds = %68
  %72 = getelementptr inbounds i8, i8* %52, i64 12, !dbg !366
  %73 = bitcast i8* %72 to i16*, !dbg !366
  %74 = load i16, i16* %73, align 4, !dbg !366
  %75 = lshr i16 %74, 2, !dbg !367
  %76 = and i16 %75, 60, !dbg !367
  call void @llvm.dbg.value(metadata i16 %76, metadata !355, metadata !DIExpression()), !dbg !357
  %77 = icmp ult i16 %76, 20, !dbg !368
  br i1 %77, label %124, label %78, !dbg !370

78:                                               ; preds = %71
  %79 = zext i16 %76 to i64, !dbg !371
  %80 = getelementptr i8, i8* %52, i64 %79, !dbg !372
  %81 = icmp ugt i8* %80, %10, !dbg !374
  br i1 %81, label %124, label %82, !dbg !375

82:                                               ; preds = %78, %62
  %83 = getelementptr inbounds i8, i8* %52, i64 2, !dbg !376
  %84 = bitcast i8* %83 to i16*, !dbg !376
  %85 = bitcast i8* %52 to i16*, !dbg !376
  %86 = load i16, i16* %85, align 2, !dbg !376, !tbaa !275
  %87 = load i16, i16* %84, align 2, !dbg !376, !tbaa !275
  call void @llvm.dbg.value(metadata i16 %86, metadata !184, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.value(metadata i16 %87, metadata !185, metadata !DIExpression()), !dbg !219
  call void @llvm.dbg.declare(metadata %struct.flow* %2, metadata !186, metadata !DIExpression()), !dbg !377
  %88 = bitcast %struct.flow* %2 to i8*, !dbg !378
  call void @llvm.memset.p0i8.i64(i8* nonnull align 4 dereferenceable(16) %88, i8 0, i64 16, i1 false), !dbg !378
  call void @llvm.dbg.value(metadata i8* %39, metadata !127, metadata !DIExpression()), !dbg !219
  %89 = getelementptr inbounds i8, i8* %39, i64 12, !dbg !379
  %90 = bitcast i8* %89 to i32*, !dbg !379
  %91 = load i32, i32* %90, align 4, !dbg !379, !tbaa !380
  %92 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 0, !dbg !381
  store i32 %91, i32* %92, align 4, !dbg !382, !tbaa !383
  call void @llvm.dbg.value(metadata i8* %39, metadata !127, metadata !DIExpression()), !dbg !219
  %93 = getelementptr inbounds i8, i8* %39, i64 16, !dbg !385
  %94 = bitcast i8* %93 to i32*, !dbg !385
  %95 = load i32, i32* %94, align 4, !dbg !385, !tbaa !386
  %96 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 1, !dbg !387
  store i32 %95, i32* %96, align 4, !dbg !388, !tbaa !389
  %97 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 2, !dbg !390
  store i16 %86, i16* %97, align 4, !dbg !391, !tbaa !392
  %98 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 3, !dbg !393
  store i16 %87, i16* %98, align 2, !dbg !394, !tbaa !395
  call void @llvm.dbg.value(metadata i8* %39, metadata !127, metadata !DIExpression()), !dbg !219
  %99 = load i8, i8* %55, align 1, !dbg !396, !tbaa !318
  %100 = getelementptr inbounds %struct.flow, %struct.flow* %2, i64 0, i32 4, !dbg !397
  store i8 %99, i8* %100, align 4, !dbg !398, !tbaa !399
  %101 = getelementptr inbounds [25 x i8], [25 x i8]* %3, i64 0, i64 0, !dbg !400
  call void @llvm.lifetime.start.p0i8(i64 25, i8* nonnull %101) #3, !dbg !400
  call void @llvm.dbg.declare(metadata [25 x i8]* %3, metadata !195, metadata !DIExpression()), !dbg !400
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(25) %101, i8* nonnull align 1 dereferenceable(25) getelementptr inbounds ([25 x i8], [25 x i8]* @__const.xdp_pass_func.____fmt, i64 0, i64 0), i64 25, i1 false), !dbg !400
  %102 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %101, i32 25) #3, !dbg !400
  call void @llvm.lifetime.end.p0i8(i64 25, i8* nonnull %101) #3, !dbg !401
  %103 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_blocked_flows to i8*), i8* nonnull %88) #3, !dbg !402
  call void @llvm.dbg.value(metadata i8* %103, metadata !200, metadata !DIExpression()), !dbg !219
  %104 = icmp eq i8* %103, null, !dbg !403
  br i1 %104, label %112, label %105, !dbg !404

105:                                              ; preds = %82
  %106 = bitcast i8* %103 to i32*, !dbg !402
  call void @llvm.dbg.value(metadata i32* %106, metadata !200, metadata !DIExpression()), !dbg !219
  %107 = load i32, i32* %106, align 4, !dbg !405, !tbaa !406
  %108 = icmp eq i32 %107, 1, !dbg !407
  br i1 %108, label %109, label %112, !dbg !408

109:                                              ; preds = %105
  %110 = getelementptr inbounds [59 x i8], [59 x i8]* %4, i64 0, i64 0, !dbg !409
  call void @llvm.lifetime.start.p0i8(i64 59, i8* nonnull %110) #3, !dbg !409
  call void @llvm.dbg.declare(metadata [59 x i8]* %4, metadata !202, metadata !DIExpression()), !dbg !409
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(59) %110, i8* nonnull align 1 dereferenceable(59) getelementptr inbounds ([59 x i8], [59 x i8]* @__const.xdp_pass_func.____fmt.1, i64 0, i64 0), i64 59, i1 false), !dbg !409
  %111 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %110, i32 59) #3, !dbg !409
  call void @llvm.lifetime.end.p0i8(i64 59, i8* nonnull %110) #3, !dbg !410
  br label %124, !dbg !411

112:                                              ; preds = %82, %105
  call void @llvm.dbg.value(metadata i32 1, metadata !209, metadata !DIExpression()), !dbg !219
  store i32 1, i32* %5, align 4, !dbg !412, !tbaa !406
  %113 = call i8* inttoptr (i64 1 to i8* (i8*, i8*)*)(i8* bitcast (%struct.bpf_map_def* @xdp_flow_map to i8*), i8* nonnull %88) #3, !dbg !413
  %114 = bitcast i8* %113 to i32*, !dbg !413
  call void @llvm.dbg.value(metadata i32* %114, metadata !210, metadata !DIExpression()), !dbg !219
  %115 = icmp eq i8* %113, null, !dbg !414
  br i1 %115, label %116, label %121, !dbg !415

116:                                              ; preds = %112
  %117 = getelementptr inbounds [44 x i8], [44 x i8]* %6, i64 0, i64 0, !dbg !416
  call void @llvm.lifetime.start.p0i8(i64 44, i8* nonnull %117) #3, !dbg !416
  call void @llvm.dbg.declare(metadata [44 x i8]* %6, metadata !211, metadata !DIExpression()), !dbg !416
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* nonnull align 1 dereferenceable(44) %117, i8* nonnull align 1 dereferenceable(44) getelementptr inbounds ([44 x i8], [44 x i8]* @__const.xdp_pass_func.____fmt.2, i64 0, i64 0), i64 44, i1 false), !dbg !416
  %118 = call i32 (i8*, i32, ...) inttoptr (i64 6 to i32 (i8*, i32, ...)*)(i8* nonnull %117, i32 44) #3, !dbg !416
  call void @llvm.lifetime.end.p0i8(i64 44, i8* nonnull %117) #3, !dbg !417
  %119 = bitcast i32* %5 to i8*, !dbg !418
  call void @llvm.dbg.value(metadata i32* %5, metadata !209, metadata !DIExpression(DW_OP_deref)), !dbg !219
  %120 = call i32 inttoptr (i64 2 to i32 (i8*, i8*, i8*, i64)*)(i8* bitcast (%struct.bpf_map_def* @xdp_flow_map to i8*), i8* nonnull %88, i8* nonnull %119, i64 0) #3, !dbg !419
  br label %124, !dbg !420

121:                                              ; preds = %112
  %122 = load i32, i32* %114, align 4, !dbg !421, !tbaa !406
  %123 = add i32 %122, 1, !dbg !423
  store i32 %123, i32* %114, align 4, !dbg !424, !tbaa !406
  br label %124

124:                                              ; preds = %38, %78, %71, %68, %62, %57, %50, %45, %1, %121, %116, %54, %109
  %125 = phi i32 [ 1, %109 ], [ 2, %121 ], [ 2, %116 ], [ 2, %38 ], [ 2, %54 ], [ 0, %1 ], [ 2, %45 ], [ 2, %50 ], [ 0, %57 ], [ 0, %62 ], [ 0, %68 ], [ 0, %71 ], [ 0, %78 ], !dbg !219
  ret i32 %125, !dbg !425
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
!63 = distinct !DIGlobalVariable(name: "_license", scope: !2, file: !3, line: 111, type: !64, isLocal: false, isDefinition: true)
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
!108 = !{!109, !110, !111, !112, !113, !127, !146, !155, !177, !178, !179, !184, !185, !186, !195, !200, !202, !209, !210, !211, !218}
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
!209 = !DILocalVariable(name: "times", scope: !97, file: !3, line: 95, type: !74)
!210 = !DILocalVariable(name: "n_times", scope: !97, file: !3, line: 96, type: !201)
!211 = !DILocalVariable(name: "____fmt", scope: !212, file: !3, line: 99, type: !215)
!212 = distinct !DILexicalBlock(scope: !213, file: !3, line: 99, column: 3)
!213 = distinct !DILexicalBlock(scope: !214, file: !3, line: 98, column: 16)
!214 = distinct !DILexicalBlock(scope: !97, file: !3, line: 98, column: 6)
!215 = !DICompositeType(tag: DW_TAG_array_type, baseType: !65, size: 352, elements: !216)
!216 = !{!217}
!217 = !DISubrange(count: 44)
!218 = !DILabel(scope: !97, name: "out", file: !3, line: 107)
!219 = !DILocation(line: 0, scope: !97)
!220 = !DILocation(line: 42, column: 38, scope: !97)
!221 = !{!222, !223, i64 4}
!222 = !{!"xdp_md", !223, i64 0, !223, i64 4, !223, i64 8, !223, i64 12, !223, i64 16}
!223 = !{!"int", !224, i64 0}
!224 = !{!"omnipotent char", !225, i64 0}
!225 = !{!"Simple C/C++ TBAA"}
!226 = !DILocation(line: 42, column: 27, scope: !97)
!227 = !DILocation(line: 42, column: 19, scope: !97)
!228 = !DILocation(line: 43, column: 34, scope: !97)
!229 = !{!222, !223, i64 0}
!230 = !DILocation(line: 43, column: 23, scope: !97)
!231 = !DILocation(line: 43, column: 15, scope: !97)
!232 = !DILocalVariable(name: "nh", arg: 1, scope: !233, file: !181, line: 124, type: !236)
!233 = distinct !DISubprogram(name: "parse_ethhdr", scope: !181, file: !181, line: 124, type: !234, scopeLine: 127, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !238)
!234 = !DISubroutineType(types: !235)
!235 = !{!74, !236, !44, !237}
!236 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !180, size: 64)
!237 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!238 = !{!232, !239, !240}
!239 = !DILocalVariable(name: "data_end", arg: 2, scope: !233, file: !181, line: 125, type: !44)
!240 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !233, file: !181, line: 126, type: !237)
!241 = !DILocation(line: 0, scope: !233, inlinedAt: !242)
!242 = distinct !DILocation(line: 46, column: 13, scope: !97)
!243 = !DILocalVariable(name: "nh", arg: 1, scope: !244, file: !181, line: 79, type: !236)
!244 = distinct !DISubprogram(name: "parse_ethhdr_vlan", scope: !181, file: !181, line: 79, type: !245, scopeLine: 83, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !254)
!245 = !DISubroutineType(types: !246)
!246 = !{!74, !236, !44, !237, !247}
!247 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !248, size: 64)
!248 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "collect_vlans", file: !181, line: 64, size: 32, elements: !249)
!249 = !{!250}
!250 = !DIDerivedType(tag: DW_TAG_member, name: "id", scope: !248, file: !181, line: 65, baseType: !251, size: 32)
!251 = !DICompositeType(tag: DW_TAG_array_type, baseType: !46, size: 32, elements: !252)
!252 = !{!253}
!253 = !DISubrange(count: 2)
!254 = !{!243, !255, !256, !257, !258, !259, !260, !266, !267}
!255 = !DILocalVariable(name: "data_end", arg: 2, scope: !244, file: !181, line: 80, type: !44)
!256 = !DILocalVariable(name: "ethhdr", arg: 3, scope: !244, file: !181, line: 81, type: !237)
!257 = !DILocalVariable(name: "vlans", arg: 4, scope: !244, file: !181, line: 82, type: !247)
!258 = !DILocalVariable(name: "eth", scope: !244, file: !181, line: 84, type: !114)
!259 = !DILocalVariable(name: "hdrsize", scope: !244, file: !181, line: 85, type: !74)
!260 = !DILocalVariable(name: "vlh", scope: !244, file: !181, line: 86, type: !261)
!261 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !262, size: 64)
!262 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "vlan_hdr", file: !181, line: 42, size: 32, elements: !263)
!263 = !{!264, !265}
!264 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_TCI", scope: !262, file: !181, line: 43, baseType: !125, size: 16)
!265 = !DIDerivedType(tag: DW_TAG_member, name: "h_vlan_encapsulated_proto", scope: !262, file: !181, line: 44, baseType: !125, size: 16, offset: 16)
!266 = !DILocalVariable(name: "h_proto", scope: !244, file: !181, line: 87, type: !46)
!267 = !DILocalVariable(name: "i", scope: !244, file: !181, line: 88, type: !74)
!268 = !DILocation(line: 0, scope: !244, inlinedAt: !269)
!269 = distinct !DILocation(line: 129, column: 9, scope: !233, inlinedAt: !242)
!270 = !DILocation(line: 93, column: 14, scope: !271, inlinedAt: !269)
!271 = distinct !DILexicalBlock(scope: !244, file: !181, line: 93, column: 6)
!272 = !DILocation(line: 93, column: 24, scope: !271, inlinedAt: !269)
!273 = !DILocation(line: 93, column: 6, scope: !244, inlinedAt: !269)
!274 = !DILocation(line: 99, column: 17, scope: !244, inlinedAt: !269)
!275 = !{!276, !276, i64 0}
!276 = !{!"short", !224, i64 0}
!277 = !DILocation(line: 0, scope: !278, inlinedAt: !269)
!278 = distinct !DILexicalBlock(scope: !279, file: !181, line: 109, column: 7)
!279 = distinct !DILexicalBlock(scope: !280, file: !181, line: 105, column: 39)
!280 = distinct !DILexicalBlock(scope: !281, file: !181, line: 105, column: 2)
!281 = distinct !DILexicalBlock(scope: !244, file: !181, line: 105, column: 2)
!282 = !DILocation(line: 105, column: 2, scope: !281, inlinedAt: !269)
!283 = !DILocation(line: 106, column: 7, scope: !279, inlinedAt: !269)
!284 = !DILocation(line: 109, column: 11, scope: !278, inlinedAt: !269)
!285 = !DILocation(line: 109, column: 15, scope: !278, inlinedAt: !269)
!286 = !DILocation(line: 109, column: 7, scope: !279, inlinedAt: !269)
!287 = !DILocation(line: 112, column: 18, scope: !279, inlinedAt: !269)
!288 = !DILocation(line: 52, column: 15, scope: !289)
!289 = distinct !DILexicalBlock(scope: !97, file: !3, line: 52, column: 6)
!290 = !DILocation(line: 158, column: 10, scope: !291, inlinedAt: !302)
!291 = distinct !DILexicalBlock(scope: !292, file: !181, line: 158, column: 6)
!292 = distinct !DISubprogram(name: "parse_iphdr", scope: !181, file: !181, line: 151, type: !293, scopeLine: 154, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !296)
!293 = !DISubroutineType(types: !294)
!294 = !{!74, !236, !44, !295}
!295 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!296 = !{!297, !298, !299, !300, !301}
!297 = !DILocalVariable(name: "nh", arg: 1, scope: !292, file: !181, line: 151, type: !236)
!298 = !DILocalVariable(name: "data_end", arg: 2, scope: !292, file: !181, line: 152, type: !44)
!299 = !DILocalVariable(name: "iphdr", arg: 3, scope: !292, file: !181, line: 153, type: !295)
!300 = !DILocalVariable(name: "iph", scope: !292, file: !181, line: 155, type: !128)
!301 = !DILocalVariable(name: "hdrsize", scope: !292, file: !181, line: 156, type: !74)
!302 = distinct !DILocation(line: 53, column: 13, scope: !303)
!303 = distinct !DILexicalBlock(scope: !289, file: !3, line: 52, column: 39)
!304 = !DILocation(line: 158, column: 14, scope: !291, inlinedAt: !302)
!305 = !DILocation(line: 52, column: 6, scope: !97)
!306 = !DILocation(line: 0, scope: !292, inlinedAt: !302)
!307 = !DILocation(line: 161, column: 17, scope: !292, inlinedAt: !302)
!308 = !DILocation(line: 161, column: 21, scope: !292, inlinedAt: !302)
!309 = !DILocation(line: 163, column: 13, scope: !310, inlinedAt: !302)
!310 = distinct !DILexicalBlock(scope: !292, file: !181, line: 163, column: 5)
!311 = !DILocation(line: 163, column: 5, scope: !292, inlinedAt: !302)
!312 = !DILocation(line: 163, column: 5, scope: !310, inlinedAt: !302)
!313 = !DILocation(line: 167, column: 14, scope: !314, inlinedAt: !302)
!314 = distinct !DILexicalBlock(scope: !292, file: !181, line: 167, column: 6)
!315 = !DILocation(line: 167, column: 24, scope: !314, inlinedAt: !302)
!316 = !DILocation(line: 167, column: 6, scope: !292, inlinedAt: !302)
!317 = !DILocation(line: 173, column: 14, scope: !292, inlinedAt: !302)
!318 = !{!319, !224, i64 9}
!319 = !{!"iphdr", !224, i64 0, !224, i64 0, !224, i64 1, !276, i64 2, !276, i64 4, !276, i64 6, !224, i64 8, !224, i64 9, !276, i64 10, !223, i64 12, !223, i64 16}
!320 = !DILocation(line: 61, column: 6, scope: !97)
!321 = !DILocalVariable(name: "nh", arg: 1, scope: !322, file: !181, line: 224, type: !236)
!322 = distinct !DISubprogram(name: "parse_udphdr", scope: !181, file: !181, line: 224, type: !323, scopeLine: 227, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !326)
!323 = !DISubroutineType(types: !324)
!324 = !{!74, !236, !44, !325}
!325 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !147, size: 64)
!326 = !{!321, !327, !328, !329, !330}
!327 = !DILocalVariable(name: "data_end", arg: 2, scope: !322, file: !181, line: 225, type: !44)
!328 = !DILocalVariable(name: "udphdr", arg: 3, scope: !322, file: !181, line: 226, type: !325)
!329 = !DILocalVariable(name: "len", scope: !322, file: !181, line: 228, type: !74)
!330 = !DILocalVariable(name: "h", scope: !322, file: !181, line: 229, type: !147)
!331 = !DILocation(line: 0, scope: !322, inlinedAt: !332)
!332 = distinct !DILocation(line: 62, column: 7, scope: !333)
!333 = distinct !DILexicalBlock(scope: !334, file: !3, line: 62, column: 7)
!334 = distinct !DILexicalBlock(scope: !335, file: !3, line: 61, column: 30)
!335 = distinct !DILexicalBlock(scope: !97, file: !3, line: 61, column: 6)
!336 = !DILocation(line: 231, column: 8, scope: !337, inlinedAt: !332)
!337 = distinct !DILexicalBlock(scope: !322, file: !181, line: 231, column: 6)
!338 = !DILocation(line: 231, column: 14, scope: !337, inlinedAt: !332)
!339 = !DILocation(line: 231, column: 12, scope: !337, inlinedAt: !332)
!340 = !DILocation(line: 231, column: 6, scope: !322, inlinedAt: !332)
!341 = !DILocation(line: 237, column: 8, scope: !322, inlinedAt: !332)
!342 = !{!343, !276, i64 4}
!343 = !{!"udphdr", !276, i64 0, !276, i64 2, !276, i64 4, !276, i64 6}
!344 = !DILocation(line: 238, column: 10, scope: !345, inlinedAt: !332)
!345 = distinct !DILexicalBlock(scope: !322, file: !181, line: 238, column: 6)
!346 = !DILocation(line: 238, column: 6, scope: !322, inlinedAt: !332)
!347 = !DILocalVariable(name: "nh", arg: 1, scope: !348, file: !181, line: 247, type: !236)
!348 = distinct !DISubprogram(name: "parse_tcphdr", scope: !181, file: !181, line: 247, type: !349, scopeLine: 250, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !352)
!349 = !DISubroutineType(types: !350)
!350 = !{!74, !236, !44, !351}
!351 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !156, size: 64)
!352 = !{!347, !353, !354, !355, !356}
!353 = !DILocalVariable(name: "data_end", arg: 2, scope: !348, file: !181, line: 248, type: !44)
!354 = !DILocalVariable(name: "tcphdr", arg: 3, scope: !348, file: !181, line: 249, type: !351)
!355 = !DILocalVariable(name: "len", scope: !348, file: !181, line: 251, type: !74)
!356 = !DILocalVariable(name: "h", scope: !348, file: !181, line: 252, type: !156)
!357 = !DILocation(line: 0, scope: !348, inlinedAt: !358)
!358 = distinct !DILocation(line: 69, column: 7, scope: !359)
!359 = distinct !DILexicalBlock(scope: !360, file: !3, line: 69, column: 7)
!360 = distinct !DILexicalBlock(scope: !361, file: !3, line: 68, column: 37)
!361 = distinct !DILexicalBlock(scope: !335, file: !3, line: 68, column: 13)
!362 = !DILocation(line: 254, column: 8, scope: !363, inlinedAt: !358)
!363 = distinct !DILexicalBlock(scope: !348, file: !181, line: 254, column: 6)
!364 = !DILocation(line: 254, column: 12, scope: !363, inlinedAt: !358)
!365 = !DILocation(line: 254, column: 6, scope: !348, inlinedAt: !358)
!366 = !DILocation(line: 257, column: 11, scope: !348, inlinedAt: !358)
!367 = !DILocation(line: 257, column: 16, scope: !348, inlinedAt: !358)
!368 = !DILocation(line: 259, column: 9, scope: !369, inlinedAt: !358)
!369 = distinct !DILexicalBlock(scope: !348, file: !181, line: 259, column: 5)
!370 = !DILocation(line: 259, column: 5, scope: !348, inlinedAt: !358)
!371 = !DILocation(line: 259, column: 5, scope: !369, inlinedAt: !358)
!372 = !DILocation(line: 263, column: 14, scope: !373, inlinedAt: !358)
!373 = distinct !DILexicalBlock(scope: !348, file: !181, line: 263, column: 6)
!374 = !DILocation(line: 263, column: 20, scope: !373, inlinedAt: !358)
!375 = !DILocation(line: 263, column: 6, scope: !348, inlinedAt: !358)
!376 = !DILocation(line: 0, scope: !335)
!377 = !DILocation(line: 79, column: 14, scope: !97)
!378 = !DILocation(line: 80, column: 2, scope: !97)
!379 = !DILocation(line: 81, column: 27, scope: !97)
!380 = !{!319, !223, i64 12}
!381 = !DILocation(line: 81, column: 12, scope: !97)
!382 = !DILocation(line: 81, column: 18, scope: !97)
!383 = !{!384, !223, i64 0}
!384 = !{!"flow", !223, i64 0, !223, i64 4, !276, i64 8, !276, i64 10, !224, i64 12}
!385 = !DILocation(line: 82, column: 27, scope: !97)
!386 = !{!319, !223, i64 16}
!387 = !DILocation(line: 82, column: 12, scope: !97)
!388 = !DILocation(line: 82, column: 18, scope: !97)
!389 = !{!384, !223, i64 4}
!390 = !DILocation(line: 83, column: 12, scope: !97)
!391 = !DILocation(line: 83, column: 18, scope: !97)
!392 = !{!384, !276, i64 8}
!393 = !DILocation(line: 84, column: 12, scope: !97)
!394 = !DILocation(line: 84, column: 18, scope: !97)
!395 = !{!384, !276, i64 10}
!396 = !DILocation(line: 85, column: 30, scope: !97)
!397 = !DILocation(line: 85, column: 12, scope: !97)
!398 = !DILocation(line: 85, column: 21, scope: !97)
!399 = !{!384, !224, i64 12}
!400 = !DILocation(line: 87, column: 2, scope: !196)
!401 = !DILocation(line: 87, column: 2, scope: !97)
!402 = !DILocation(line: 89, column: 19, scope: !97)
!403 = !DILocation(line: 90, column: 6, scope: !205)
!404 = !DILocation(line: 90, column: 14, scope: !205)
!405 = !DILocation(line: 90, column: 17, scope: !205)
!406 = !{!223, !223, i64 0}
!407 = !DILocation(line: 90, column: 26, scope: !205)
!408 = !DILocation(line: 90, column: 6, scope: !97)
!409 = !DILocation(line: 91, column: 3, scope: !203)
!410 = !DILocation(line: 91, column: 3, scope: !204)
!411 = !DILocation(line: 92, column: 3, scope: !204)
!412 = !DILocation(line: 95, column: 6, scope: !97)
!413 = !DILocation(line: 96, column: 19, scope: !97)
!414 = !DILocation(line: 98, column: 7, scope: !214)
!415 = !DILocation(line: 98, column: 6, scope: !97)
!416 = !DILocation(line: 99, column: 3, scope: !212)
!417 = !DILocation(line: 99, column: 3, scope: !213)
!418 = !DILocation(line: 100, column: 50, scope: !213)
!419 = !DILocation(line: 100, column: 3, scope: !213)
!420 = !DILocation(line: 101, column: 2, scope: !213)
!421 = !DILocation(line: 102, column: 14, scope: !422)
!422 = distinct !DILexicalBlock(scope: !214, file: !3, line: 101, column: 9)
!423 = !DILocation(line: 102, column: 22, scope: !422)
!424 = !DILocation(line: 102, column: 12, scope: !422)
!425 = !DILocation(line: 109, column: 1, scope: !97)
