package p000j$.util.stream;

import java.util.concurrent.CountedCompleter;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.IntConsumer;
import java.util.function.IntFunction;
import java.util.function.LongConsumer;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.concurrent.ConcurrentHashMap;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;
import p000j$.util.function.IntConsumer$CC;
import p000j$.util.function.LongConsumer$CC;

abstract class ForEachOps {
    public static TerminalOp makeRef(Consumer consumer, boolean z) {
        Objects.requireNonNull(consumer);
        return new ForEachOp.OfRef(consumer, z);
    }

    public static TerminalOp makeInt(IntConsumer intConsumer, boolean z) {
        Objects.requireNonNull(intConsumer);
        return new ForEachOp.OfInt(intConsumer, z);
    }

    public static TerminalOp makeLong(LongConsumer longConsumer, boolean z) {
        Objects.requireNonNull(longConsumer);
        return new ForEachOp.OfLong(longConsumer, z);
    }

    public static TerminalOp makeDouble(DoubleConsumer doubleConsumer, boolean z) {
        Objects.requireNonNull(doubleConsumer);
        return new ForEachOp.OfDouble(doubleConsumer, z);
    }

    static abstract class ForEachOp implements TerminalOp, TerminalSink {
        private final boolean ordered;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        @Override
        public void begin(long j) {
            Sink.CC.$default$begin(this, j);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        @Override
        public Void get() {
            return null;
        }

        protected ForEachOp(boolean z) {
            this.ordered = z;
        }

        @Override
        public int getOpFlags() {
            if (this.ordered) {
                return 0;
            }
            return StreamOpFlag.NOT_ORDERED;
        }

        @Override
        public Void evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
            return ((ForEachOp) pipelineHelper.wrapAndCopyInto(this, spliterator)).get();
        }

        @Override
        public Void evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (this.ordered) {
                new ForEachOrderedTask(pipelineHelper, spliterator, this).invoke();
                return null;
            }
            new ForEachTask(pipelineHelper, spliterator, pipelineHelper.wrapSink(this)).invoke();
            return null;
        }

        static final class OfRef extends ForEachOp {
            final Consumer consumer;

            @Override
            public Object evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
                return super.evaluateParallel(pipelineHelper, spliterator);
            }

            @Override
            public Object evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
                return super.evaluateSequential(pipelineHelper, spliterator);
            }

            @Override
            public Object get() {
                return super.get();
            }

            OfRef(Consumer consumer, boolean z) {
                super(z);
                this.consumer = consumer;
            }

            @Override
            public void accept(Object obj) {
                this.consumer.accept(obj);
            }
        }

        static final class OfInt extends ForEachOp implements Sink.OfInt {
            final IntConsumer consumer;

            @Override
            public void accept(Integer num) {
                Sink.OfInt.CC.$default$accept((Sink.OfInt) this, num);
            }

            @Override
            public void accept(Object obj) {
                Sink.OfInt.CC.$default$accept(this, obj);
            }

            public IntConsumer andThen(IntConsumer intConsumer) {
                return IntConsumer$CC.$default$andThen(this, intConsumer);
            }

            @Override
            public Object evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
                return super.evaluateParallel(pipelineHelper, spliterator);
            }

            @Override
            public Object evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
                return super.evaluateSequential(pipelineHelper, spliterator);
            }

            @Override
            public Object get() {
                return super.get();
            }

            OfInt(IntConsumer intConsumer, boolean z) {
                super(z);
                this.consumer = intConsumer;
            }

            @Override
            public void accept(int i) {
                this.consumer.accept(i);
            }
        }

        static final class OfLong extends ForEachOp implements Sink.OfLong {
            final LongConsumer consumer;

            @Override
            public void accept(Long l) {
                Sink.OfLong.CC.$default$accept((Sink.OfLong) this, l);
            }

            @Override
            public void accept(Object obj) {
                Sink.OfLong.CC.$default$accept(this, obj);
            }

            public LongConsumer andThen(LongConsumer longConsumer) {
                return LongConsumer$CC.$default$andThen(this, longConsumer);
            }

            @Override
            public Object evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
                return super.evaluateParallel(pipelineHelper, spliterator);
            }

            @Override
            public Object evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
                return super.evaluateSequential(pipelineHelper, spliterator);
            }

            @Override
            public Object get() {
                return super.get();
            }

            OfLong(LongConsumer longConsumer, boolean z) {
                super(z);
                this.consumer = longConsumer;
            }

            @Override
            public void accept(long j) {
                this.consumer.accept(j);
            }
        }

        static final class OfDouble extends ForEachOp implements Sink.OfDouble {
            final DoubleConsumer consumer;

            @Override
            public void accept(Double d) {
                Sink.OfDouble.CC.$default$accept((Sink.OfDouble) this, d);
            }

            @Override
            public void accept(Object obj) {
                Sink.OfDouble.CC.$default$accept(this, obj);
            }

            public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
                return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
            }

            @Override
            public Object evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
                return super.evaluateParallel(pipelineHelper, spliterator);
            }

            @Override
            public Object evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
                return super.evaluateSequential(pipelineHelper, spliterator);
            }

            @Override
            public Object get() {
                return super.get();
            }

            OfDouble(DoubleConsumer doubleConsumer, boolean z) {
                super(z);
                this.consumer = doubleConsumer;
            }

            @Override
            public void accept(double d) {
                this.consumer.accept(d);
            }
        }
    }

    static final class ForEachTask extends CountedCompleter {
        private final PipelineHelper helper;
        private final Sink sink;
        private Spliterator spliterator;
        private long targetSize;

        ForEachTask(PipelineHelper pipelineHelper, Spliterator spliterator, Sink sink) {
            super(null);
            this.sink = sink;
            this.helper = pipelineHelper;
            this.spliterator = spliterator;
            this.targetSize = 0L;
        }

        ForEachTask(ForEachTask forEachTask, Spliterator spliterator) {
            super(forEachTask);
            this.spliterator = spliterator;
            this.sink = forEachTask.sink;
            this.targetSize = forEachTask.targetSize;
            this.helper = forEachTask.helper;
        }

        @Override
        public void compute() {
            Spliterator spliteratorTrySplit;
            Spliterator spliterator = this.spliterator;
            long jEstimateSize = spliterator.estimateSize();
            long jSuggestTargetSize = this.targetSize;
            if (jSuggestTargetSize == 0) {
                jSuggestTargetSize = AbstractTask.suggestTargetSize(jEstimateSize);
                this.targetSize = jSuggestTargetSize;
            }
            boolean zIsKnown = StreamOpFlag.SHORT_CIRCUIT.isKnown(this.helper.getStreamAndOpFlags());
            Sink sink = this.sink;
            boolean z = false;
            ForEachTask forEachTask = this;
            while (true) {
                if (zIsKnown && sink.cancellationRequested()) {
                    break;
                }
                if (jEstimateSize <= jSuggestTargetSize || (spliteratorTrySplit = spliterator.trySplit()) == null) {
                    forEachTask.helper.copyInto(sink, spliterator);
                    break;
                }
                ForEachTask forEachTask2 = new ForEachTask(forEachTask, spliteratorTrySplit);
                forEachTask.addToPendingCount(1);
                if (z) {
                    spliterator = spliteratorTrySplit;
                } else {
                    ForEachTask forEachTask3 = forEachTask;
                    forEachTask = forEachTask2;
                    forEachTask2 = forEachTask3;
                }
                z = !z;
                forEachTask.fork();
                forEachTask = forEachTask2;
                jEstimateSize = spliterator.estimateSize();
            }
            forEachTask.spliterator = null;
            forEachTask.propagateCompletion();
        }
    }

    static final class ForEachOrderedTask extends CountedCompleter {
        private final Sink action;
        private final ConcurrentHashMap completionMap;
        private final PipelineHelper helper;
        private final ForEachOrderedTask leftPredecessor;
        private Node node;
        private Spliterator spliterator;
        private final long targetSize;

        protected ForEachOrderedTask(PipelineHelper pipelineHelper, Spliterator spliterator, Sink sink) {
            super(null);
            this.helper = pipelineHelper;
            this.spliterator = spliterator;
            this.targetSize = AbstractTask.suggestTargetSize(spliterator.estimateSize());
            this.completionMap = new ConcurrentHashMap(Math.max(16, AbstractTask.getLeafTarget() << 1));
            this.action = sink;
            this.leftPredecessor = null;
        }

        ForEachOrderedTask(ForEachOrderedTask forEachOrderedTask, Spliterator spliterator, ForEachOrderedTask forEachOrderedTask2) {
            super(forEachOrderedTask);
            this.helper = forEachOrderedTask.helper;
            this.spliterator = spliterator;
            this.targetSize = forEachOrderedTask.targetSize;
            this.completionMap = forEachOrderedTask.completionMap;
            this.action = forEachOrderedTask.action;
            this.leftPredecessor = forEachOrderedTask2;
        }

        @Override
        public final void compute() {
            doCompute(this);
        }

        private static void doCompute(ForEachOrderedTask forEachOrderedTask) {
            Spliterator spliteratorTrySplit;
            Spliterator spliterator = forEachOrderedTask.spliterator;
            long j = forEachOrderedTask.targetSize;
            boolean z = false;
            while (spliterator.estimateSize() > j && (spliteratorTrySplit = spliterator.trySplit()) != null) {
                ForEachOrderedTask forEachOrderedTask2 = new ForEachOrderedTask(forEachOrderedTask, spliteratorTrySplit, forEachOrderedTask.leftPredecessor);
                ForEachOrderedTask forEachOrderedTask3 = new ForEachOrderedTask(forEachOrderedTask, spliterator, forEachOrderedTask2);
                forEachOrderedTask.addToPendingCount(1);
                forEachOrderedTask3.addToPendingCount(1);
                forEachOrderedTask.completionMap.put(forEachOrderedTask2, forEachOrderedTask3);
                if (forEachOrderedTask.leftPredecessor != null) {
                    forEachOrderedTask2.addToPendingCount(1);
                    if (forEachOrderedTask.completionMap.replace(forEachOrderedTask.leftPredecessor, forEachOrderedTask, forEachOrderedTask2)) {
                        forEachOrderedTask.addToPendingCount(-1);
                    } else {
                        forEachOrderedTask2.addToPendingCount(-1);
                    }
                }
                if (z) {
                    spliterator = spliteratorTrySplit;
                    forEachOrderedTask = forEachOrderedTask2;
                    forEachOrderedTask2 = forEachOrderedTask3;
                } else {
                    forEachOrderedTask = forEachOrderedTask3;
                }
                z = !z;
                forEachOrderedTask2.fork();
            }
            if (forEachOrderedTask.getPendingCount() > 0) {
                IntFunction intFunction = new IntFunction() {
                    @Override
                    public final Object apply(int i) {
                        return ForEachOps.ForEachOrderedTask.lambda$doCompute$0(i);
                    }
                };
                PipelineHelper pipelineHelper = forEachOrderedTask.helper;
                forEachOrderedTask.node = ((Node.Builder) forEachOrderedTask.helper.wrapAndCopyInto(pipelineHelper.makeNodeBuilder(pipelineHelper.exactOutputSizeIfKnown(spliterator), intFunction), spliterator)).build();
                forEachOrderedTask.spliterator = null;
            }
            forEachOrderedTask.tryComplete();
        }

        static Object[] lambda$doCompute$0(int i) {
            return new Object[i];
        }

        @Override
        public void onCompletion(CountedCompleter countedCompleter) {
            Node node = this.node;
            if (node != null) {
                node.forEach(this.action);
                this.node = null;
            } else {
                Spliterator spliterator = this.spliterator;
                if (spliterator != null) {
                    this.helper.wrapAndCopyInto(this.action, spliterator);
                    this.spliterator = null;
                }
            }
            ForEachOrderedTask forEachOrderedTask = (ForEachOrderedTask) this.completionMap.remove(this);
            if (forEachOrderedTask != null) {
                forEachOrderedTask.tryComplete();
            }
        }
    }
}
