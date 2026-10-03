package p000j$.util.stream;

import java.util.concurrent.CountedCompleter;
import java.util.function.IntFunction;
import p000j$.util.Spliterator;

abstract class SliceOps {
    public static long calcSliceFence(long j, long j2) {
        long j3 = j2 >= 0 ? j + j2 : Long.MAX_VALUE;
        if (j3 >= 0) {
            return j3;
        }
        return Long.MAX_VALUE;
    }

    public static long calcSize(long j, long j2, long j3) {
        if (j >= 0) {
            return Math.max(-1L, Math.min(j - j2, j3));
        }
        return -1L;
    }

    static class C05775 {
        static final int[] $SwitchMap$java$util$stream$StreamShape;

        static {
            int[] iArr = new int[StreamShape.values().length];
            $SwitchMap$java$util$stream$StreamShape = iArr;
            try {
                iArr[StreamShape.REFERENCE.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$java$util$stream$StreamShape[StreamShape.INT_VALUE.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$java$util$stream$StreamShape[StreamShape.LONG_VALUE.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$java$util$stream$StreamShape[StreamShape.DOUBLE_VALUE.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
        }
    }

    public static Spliterator sliceSpliterator(StreamShape streamShape, Spliterator spliterator, long j, long j2) {
        long jCalcSliceFence = calcSliceFence(j, j2);
        int i = C05775.$SwitchMap$java$util$stream$StreamShape[streamShape.ordinal()];
        if (i == 1) {
            return new StreamSpliterators$SliceSpliterator.OfRef(spliterator, j, jCalcSliceFence);
        }
        if (i == 2) {
            return new StreamSpliterators$SliceSpliterator.OfInt((Spliterator.OfInt) spliterator, j, jCalcSliceFence);
        }
        if (i == 3) {
            return new StreamSpliterators$SliceSpliterator.OfLong((Spliterator.OfLong) spliterator, j, jCalcSliceFence);
        }
        if (i == 4) {
            return new StreamSpliterators$SliceSpliterator.OfDouble((Spliterator.OfDouble) spliterator, j, jCalcSliceFence);
        }
        throw new IllegalStateException("Unknown shape " + streamShape);
    }

    public static Stream makeRef(AbstractPipeline abstractPipeline, final long j, final long j2) {
        if (j < 0) {
            throw new IllegalArgumentException("Skip must be non-negative: " + j);
        }
        return new ReferencePipeline.StatefulOp(abstractPipeline, StreamShape.REFERENCE, flags(j2)) {
            Spliterator unorderedSkipLimitSpliterator(Spliterator spliterator, long j3, long j4, long j5) {
                long j6;
                long jMin;
                if (j3 <= j5) {
                    long j7 = j5 - j3;
                    jMin = j4 >= 0 ? Math.min(j4, j7) : j7;
                    j6 = 0;
                } else {
                    j6 = j3;
                    jMin = j4;
                }
                return new StreamSpliterators$UnorderedSliceSpliterator.OfRef(spliterator, j6, jMin);
            }

            @Override
            Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
                long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
                if (jExactOutputSizeIfKnown > 0 && spliterator.hasCharacteristics(16384)) {
                    Spliterator spliteratorWrapSpliterator = pipelineHelper.wrapSpliterator(spliterator);
                    long j3 = j;
                    return new StreamSpliterators$SliceSpliterator.OfRef(spliteratorWrapSpliterator, j3, SliceOps.calcSliceFence(j3, j2));
                }
                if (!StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return unorderedSkipLimitSpliterator(pipelineHelper.wrapSpliterator(spliterator), j, j2, jExactOutputSizeIfKnown);
                }
                return ((Node) new SliceTask(this, pipelineHelper, spliterator, Nodes.castingArray(), j, j2).invoke()).spliterator();
            }

            @Override
            Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
                long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
                if (jExactOutputSizeIfKnown > 0 && spliterator.hasCharacteristics(16384)) {
                    return Nodes.collect(pipelineHelper, SliceOps.sliceSpliterator(pipelineHelper.getSourceShape(), spliterator, j, j2), true, intFunction);
                }
                if (!StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Nodes.collect(this, unorderedSkipLimitSpliterator(pipelineHelper.wrapSpliterator(spliterator), j, j2, jExactOutputSizeIfKnown), true, intFunction);
                }
                return (Node) new SliceTask(this, pipelineHelper, spliterator, intFunction, j, j2).invoke();
            }

            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {

                    long f1387m;

                    long f1388n;

                    {
                        this.f1388n = j;
                        long j3 = j2;
                        this.f1387m = j3 < 0 ? Long.MAX_VALUE : j3;
                    }

                    @Override
                    public void begin(long j3) {
                        this.downstream.begin(SliceOps.calcSize(j3, j, this.f1387m));
                    }

                    @Override
                    public void accept(Object obj) {
                        long j3 = this.f1388n;
                        if (j3 == 0) {
                            long j4 = this.f1387m;
                            if (j4 > 0) {
                                this.f1387m = j4 - 1;
                                this.downstream.accept(obj);
                                return;
                            }
                            return;
                        }
                        this.f1388n = j3 - 1;
                    }

                    @Override
                    public boolean cancellationRequested() {
                        return this.f1387m == 0 || this.downstream.cancellationRequested();
                    }
                };
            }
        };
    }

    class C05742 extends IntPipeline.StatefulOp {
        final long val$limit;
        final long val$skip;

        C05742(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, long j, long j2) {
            super(abstractPipeline, streamShape, i);
            this.val$skip = j;
            this.val$limit = j2;
        }

        Spliterator.OfInt unorderedSkipLimitSpliterator(Spliterator.OfInt ofInt, long j, long j2, long j3) {
            long j4;
            long jMin;
            if (j <= j3) {
                long j5 = j3 - j;
                jMin = j2 >= 0 ? Math.min(j2, j5) : j5;
                j4 = 0;
            } else {
                j4 = j;
                jMin = j2;
            }
            return new StreamSpliterators$UnorderedSliceSpliterator.OfInt(ofInt, j4, jMin);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
            if (jExactOutputSizeIfKnown > 0 && spliterator.hasCharacteristics(16384)) {
                Spliterator.OfInt ofInt = (Spliterator.OfInt) pipelineHelper.wrapSpliterator(spliterator);
                long j = this.val$skip;
                return new StreamSpliterators$SliceSpliterator.OfInt(ofInt, j, SliceOps.calcSliceFence(j, this.val$limit));
            }
            if (!StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return unorderedSkipLimitSpliterator((Spliterator.OfInt) pipelineHelper.wrapSpliterator(spliterator), this.val$skip, this.val$limit, jExactOutputSizeIfKnown);
            }
            return ((Node) new SliceTask(this, pipelineHelper, spliterator, new IntFunction() {
                @Override
                public final Object apply(int i) {
                    return SliceOps.C05742.lambda$opEvaluateParallelLazy$0(i);
                }
            }, this.val$skip, this.val$limit).invoke()).spliterator();
        }

        static Integer[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Integer[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
            if (jExactOutputSizeIfKnown > 0 && spliterator.hasCharacteristics(16384)) {
                return Nodes.collectInt(pipelineHelper, SliceOps.sliceSpliterator(pipelineHelper.getSourceShape(), spliterator, this.val$skip, this.val$limit), true);
            }
            if (!StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return Nodes.collectInt(this, unorderedSkipLimitSpliterator((Spliterator.OfInt) pipelineHelper.wrapSpliterator(spliterator), this.val$skip, this.val$limit, jExactOutputSizeIfKnown), true);
            }
            return (Node) new SliceTask(this, pipelineHelper, spliterator, intFunction, this.val$skip, this.val$limit).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return new Sink.ChainedInt(sink) {

                long f1389m;

                long f1390n;

                {
                    this.f1390n = C05742.this.val$skip;
                    long j = C05742.this.val$limit;
                    this.f1389m = j < 0 ? Long.MAX_VALUE : j;
                }

                @Override
                public void begin(long j) {
                    this.downstream.begin(SliceOps.calcSize(j, C05742.this.val$skip, this.f1389m));
                }

                @Override
                public void accept(int i2) {
                    long j = this.f1390n;
                    if (j == 0) {
                        long j2 = this.f1389m;
                        if (j2 > 0) {
                            this.f1389m = j2 - 1;
                            this.downstream.accept(i2);
                            return;
                        }
                        return;
                    }
                    this.f1390n = j - 1;
                }

                @Override
                public boolean cancellationRequested() {
                    return this.f1389m == 0 || this.downstream.cancellationRequested();
                }
            };
        }
    }

    public static IntStream makeInt(AbstractPipeline abstractPipeline, long j, long j2) {
        if (j < 0) {
            throw new IllegalArgumentException("Skip must be non-negative: " + j);
        }
        return new C05742(abstractPipeline, StreamShape.INT_VALUE, flags(j2), j, j2);
    }

    class C05753 extends LongPipeline.StatefulOp {
        final long val$limit;
        final long val$skip;

        C05753(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, long j, long j2) {
            super(abstractPipeline, streamShape, i);
            this.val$skip = j;
            this.val$limit = j2;
        }

        Spliterator.OfLong unorderedSkipLimitSpliterator(Spliterator.OfLong ofLong, long j, long j2, long j3) {
            long j4;
            long jMin;
            if (j <= j3) {
                long j5 = j3 - j;
                jMin = j2 >= 0 ? Math.min(j2, j5) : j5;
                j4 = 0;
            } else {
                j4 = j;
                jMin = j2;
            }
            return new StreamSpliterators$UnorderedSliceSpliterator.OfLong(ofLong, j4, jMin);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
            if (jExactOutputSizeIfKnown > 0 && spliterator.hasCharacteristics(16384)) {
                Spliterator.OfLong ofLong = (Spliterator.OfLong) pipelineHelper.wrapSpliterator(spliterator);
                long j = this.val$skip;
                return new StreamSpliterators$SliceSpliterator.OfLong(ofLong, j, SliceOps.calcSliceFence(j, this.val$limit));
            }
            if (!StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return unorderedSkipLimitSpliterator((Spliterator.OfLong) pipelineHelper.wrapSpliterator(spliterator), this.val$skip, this.val$limit, jExactOutputSizeIfKnown);
            }
            return ((Node) new SliceTask(this, pipelineHelper, spliterator, new IntFunction() {
                @Override
                public final Object apply(int i) {
                    return SliceOps.C05753.lambda$opEvaluateParallelLazy$0(i);
                }
            }, this.val$skip, this.val$limit).invoke()).spliterator();
        }

        static Long[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Long[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
            if (jExactOutputSizeIfKnown > 0 && spliterator.hasCharacteristics(16384)) {
                return Nodes.collectLong(pipelineHelper, SliceOps.sliceSpliterator(pipelineHelper.getSourceShape(), spliterator, this.val$skip, this.val$limit), true);
            }
            if (!StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return Nodes.collectLong(this, unorderedSkipLimitSpliterator((Spliterator.OfLong) pipelineHelper.wrapSpliterator(spliterator), this.val$skip, this.val$limit, jExactOutputSizeIfKnown), true);
            }
            return (Node) new SliceTask(this, pipelineHelper, spliterator, intFunction, this.val$skip, this.val$limit).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return new Sink.ChainedLong(sink) {

                long f1391m;

                long f1392n;

                {
                    this.f1392n = C05753.this.val$skip;
                    long j = C05753.this.val$limit;
                    this.f1391m = j < 0 ? Long.MAX_VALUE : j;
                }

                @Override
                public void begin(long j) {
                    this.downstream.begin(SliceOps.calcSize(j, C05753.this.val$skip, this.f1391m));
                }

                @Override
                public void accept(long j) {
                    long j2 = this.f1392n;
                    if (j2 == 0) {
                        long j3 = this.f1391m;
                        if (j3 > 0) {
                            this.f1391m = j3 - 1;
                            this.downstream.accept(j);
                            return;
                        }
                        return;
                    }
                    this.f1392n = j2 - 1;
                }

                @Override
                public boolean cancellationRequested() {
                    return this.f1391m == 0 || this.downstream.cancellationRequested();
                }
            };
        }
    }

    public static LongStream makeLong(AbstractPipeline abstractPipeline, long j, long j2) {
        if (j < 0) {
            throw new IllegalArgumentException("Skip must be non-negative: " + j);
        }
        return new C05753(abstractPipeline, StreamShape.LONG_VALUE, flags(j2), j, j2);
    }

    class C05764 extends DoublePipeline.StatefulOp {
        final long val$limit;
        final long val$skip;

        C05764(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, long j, long j2) {
            super(abstractPipeline, streamShape, i);
            this.val$skip = j;
            this.val$limit = j2;
        }

        Spliterator.OfDouble unorderedSkipLimitSpliterator(Spliterator.OfDouble ofDouble, long j, long j2, long j3) {
            long j4;
            long jMin;
            if (j <= j3) {
                long j5 = j3 - j;
                jMin = j2 >= 0 ? Math.min(j2, j5) : j5;
                j4 = 0;
            } else {
                j4 = j;
                jMin = j2;
            }
            return new StreamSpliterators$UnorderedSliceSpliterator.OfDouble(ofDouble, j4, jMin);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
            if (jExactOutputSizeIfKnown > 0 && spliterator.hasCharacteristics(16384)) {
                Spliterator.OfDouble ofDouble = (Spliterator.OfDouble) pipelineHelper.wrapSpliterator(spliterator);
                long j = this.val$skip;
                return new StreamSpliterators$SliceSpliterator.OfDouble(ofDouble, j, SliceOps.calcSliceFence(j, this.val$limit));
            }
            if (!StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return unorderedSkipLimitSpliterator((Spliterator.OfDouble) pipelineHelper.wrapSpliterator(spliterator), this.val$skip, this.val$limit, jExactOutputSizeIfKnown);
            }
            return ((Node) new SliceTask(this, pipelineHelper, spliterator, new IntFunction() {
                @Override
                public final Object apply(int i) {
                    return SliceOps.C05764.lambda$opEvaluateParallelLazy$0(i);
                }
            }, this.val$skip, this.val$limit).invoke()).spliterator();
        }

        static Double[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Double[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            long jExactOutputSizeIfKnown = pipelineHelper.exactOutputSizeIfKnown(spliterator);
            if (jExactOutputSizeIfKnown > 0 && spliterator.hasCharacteristics(16384)) {
                return Nodes.collectDouble(pipelineHelper, SliceOps.sliceSpliterator(pipelineHelper.getSourceShape(), spliterator, this.val$skip, this.val$limit), true);
            }
            if (!StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return Nodes.collectDouble(this, unorderedSkipLimitSpliterator((Spliterator.OfDouble) pipelineHelper.wrapSpliterator(spliterator), this.val$skip, this.val$limit, jExactOutputSizeIfKnown), true);
            }
            return (Node) new SliceTask(this, pipelineHelper, spliterator, intFunction, this.val$skip, this.val$limit).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return new Sink.ChainedDouble(sink) {

                long f1393m;

                long f1394n;

                {
                    this.f1394n = C05764.this.val$skip;
                    long j = C05764.this.val$limit;
                    this.f1393m = j < 0 ? Long.MAX_VALUE : j;
                }

                @Override
                public void begin(long j) {
                    this.downstream.begin(SliceOps.calcSize(j, C05764.this.val$skip, this.f1393m));
                }

                @Override
                public void accept(double d) {
                    long j = this.f1394n;
                    if (j == 0) {
                        long j2 = this.f1393m;
                        if (j2 > 0) {
                            this.f1393m = j2 - 1;
                            this.downstream.accept(d);
                            return;
                        }
                        return;
                    }
                    this.f1394n = j - 1;
                }

                @Override
                public boolean cancellationRequested() {
                    return this.f1393m == 0 || this.downstream.cancellationRequested();
                }
            };
        }
    }

    public static DoubleStream makeDouble(AbstractPipeline abstractPipeline, long j, long j2) {
        if (j < 0) {
            throw new IllegalArgumentException("Skip must be non-negative: " + j);
        }
        return new C05764(abstractPipeline, StreamShape.DOUBLE_VALUE, flags(j2), j, j2);
    }

    private static int flags(long j) {
        return (j != -1 ? StreamOpFlag.IS_SHORT_CIRCUIT : 0) | StreamOpFlag.NOT_SIZED;
    }

    private static final class SliceTask extends AbstractShortCircuitTask {
        private volatile boolean completed;
        private final IntFunction generator;

        private final AbstractPipeline f1395op;
        private final long targetOffset;
        private final long targetSize;
        private long thisNodeSize;

        SliceTask(AbstractPipeline abstractPipeline, PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction, long j, long j2) {
            super(pipelineHelper, spliterator);
            this.f1395op = abstractPipeline;
            this.generator = intFunction;
            this.targetOffset = j;
            this.targetSize = j2;
        }

        SliceTask(SliceTask sliceTask, Spliterator spliterator) {
            super(sliceTask, spliterator);
            this.f1395op = sliceTask.f1395op;
            this.generator = sliceTask.generator;
            this.targetOffset = sliceTask.targetOffset;
            this.targetSize = sliceTask.targetSize;
        }

        @Override
        public SliceTask makeChild(Spliterator spliterator) {
            return new SliceTask(this, spliterator);
        }

        @Override
        public final Node getEmptyResult() {
            return Nodes.emptyNode(this.f1395op.getOutputShape());
        }

        @Override
        public final Node doLeaf() {
            if (isRoot()) {
                Node.Builder builderMakeNodeBuilder = this.f1395op.makeNodeBuilder(StreamOpFlag.SIZED.isPreserved(this.f1395op.sourceOrOpFlags) ? this.f1395op.exactOutputSizeIfKnown(this.spliterator) : -1L, this.generator);
                Sink sinkOpWrapSink = this.f1395op.opWrapSink(this.helper.getStreamAndOpFlags(), builderMakeNodeBuilder);
                PipelineHelper pipelineHelper = this.helper;
                pipelineHelper.copyIntoWithCancel(pipelineHelper.wrapSink(sinkOpWrapSink), this.spliterator);
                return builderMakeNodeBuilder.build();
            }
            Node.Builder builderMakeNodeBuilder2 = this.f1395op.makeNodeBuilder(-1L, this.generator);
            if (this.targetOffset == 0) {
                Sink sinkOpWrapSink2 = this.f1395op.opWrapSink(this.helper.getStreamAndOpFlags(), builderMakeNodeBuilder2);
                PipelineHelper pipelineHelper2 = this.helper;
                pipelineHelper2.copyIntoWithCancel(pipelineHelper2.wrapSink(sinkOpWrapSink2), this.spliterator);
            } else {
                this.helper.wrapAndCopyInto(builderMakeNodeBuilder2, this.spliterator);
            }
            Node nodeBuild = builderMakeNodeBuilder2.build();
            this.thisNodeSize = nodeBuild.count();
            this.completed = true;
            this.spliterator = null;
            return nodeBuild;
        }

        @Override
        public final void onCompletion(CountedCompleter countedCompleter) {
            Node nodeConc;
            if (!isLeaf()) {
                this.thisNodeSize = ((SliceTask) this.leftChild).thisNodeSize + ((SliceTask) this.rightChild).thisNodeSize;
                if (this.canceled) {
                    this.thisNodeSize = 0L;
                    nodeConc = getEmptyResult();
                } else if (this.thisNodeSize == 0) {
                    nodeConc = getEmptyResult();
                } else if (((SliceTask) this.leftChild).thisNodeSize == 0) {
                    nodeConc = (Node) ((SliceTask) this.rightChild).getLocalResult();
                } else {
                    nodeConc = Nodes.conc(this.f1395op.getOutputShape(), (Node) ((SliceTask) this.leftChild).getLocalResult(), (Node) ((SliceTask) this.rightChild).getLocalResult());
                }
                if (isRoot()) {
                    nodeConc = doTruncate(nodeConc);
                }
                setLocalResult(nodeConc);
                this.completed = true;
            }
            if (this.targetSize >= 0 && !isRoot() && isLeftCompleted(this.targetOffset + this.targetSize)) {
                cancelLaterNodes();
            }
            super.onCompletion(countedCompleter);
        }

        @Override
        protected void cancel() {
            super.cancel();
            if (this.completed) {
                setLocalResult(getEmptyResult());
            }
        }

        private Node doTruncate(Node node) {
            return node.truncate(this.targetOffset, this.targetSize >= 0 ? Math.min(node.count(), this.targetOffset + this.targetSize) : this.thisNodeSize, this.generator);
        }

        private boolean isLeftCompleted(long j) {
            SliceTask sliceTask;
            long jCompletedSize = this.completed ? this.thisNodeSize : completedSize(j);
            if (jCompletedSize >= j) {
                return true;
            }
            SliceTask sliceTask2 = this;
            for (SliceTask sliceTask3 = (SliceTask) getParent(); sliceTask3 != null; sliceTask3 = (SliceTask) sliceTask3.getParent()) {
                if (sliceTask2 == sliceTask3.rightChild && (sliceTask = (SliceTask) sliceTask3.leftChild) != null) {
                    jCompletedSize += sliceTask.completedSize(j);
                    if (jCompletedSize >= j) {
                        return true;
                    }
                }
                sliceTask2 = sliceTask3;
            }
            return jCompletedSize >= j;
        }

        private long completedSize(long j) {
            if (this.completed) {
                return this.thisNodeSize;
            }
            SliceTask sliceTask = (SliceTask) this.leftChild;
            SliceTask sliceTask2 = (SliceTask) this.rightChild;
            if (sliceTask == null || sliceTask2 == null) {
                return this.thisNodeSize;
            }
            long jCompletedSize = sliceTask.completedSize(j);
            return jCompletedSize >= j ? jCompletedSize : jCompletedSize + sliceTask2.completedSize(j);
        }
    }
}
