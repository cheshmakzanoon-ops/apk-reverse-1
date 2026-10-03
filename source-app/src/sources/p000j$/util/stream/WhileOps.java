package p000j$.util.stream;

import java.util.Comparator;
import java.util.concurrent.CountedCompleter;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.DoublePredicate;
import java.util.function.IntConsumer;
import java.util.function.IntFunction;
import java.util.function.IntPredicate;
import java.util.function.LongConsumer;
import java.util.function.LongPredicate;
import java.util.function.Predicate;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;
import p000j$.util.function.IntConsumer$CC;
import p000j$.util.function.LongConsumer$CC;

abstract class WhileOps {
    static final int DROP_FLAGS;
    static final int TAKE_FLAGS;

    interface DropWhileOp {
        DropWhileSink opWrapSink(Sink sink, boolean z);
    }

    interface DropWhileSink extends Sink {
        long getDropCount();
    }

    static {
        int i = StreamOpFlag.NOT_SIZED;
        TAKE_FLAGS = StreamOpFlag.IS_SHORT_CIRCUIT | i;
        DROP_FLAGS = i;
    }

    static Stream makeTakeWhileRef(AbstractPipeline abstractPipeline, final Predicate predicate) {
        Objects.requireNonNull(predicate);
        return new ReferencePipeline.StatefulOp(abstractPipeline, StreamShape.REFERENCE, TAKE_FLAGS) {
            @Override
            Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return opEvaluateParallel(pipelineHelper, spliterator, Nodes.castingArray()).spliterator();
                }
                return new UnorderedWhileSpliterator.OfRef.Taking(pipelineHelper.wrapSpliterator(spliterator), false, predicate);
            }

            @Override
            Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
                return (Node) new TakeWhileTask(this, pipelineHelper, spliterator, intFunction).invoke();
            }

            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    boolean take = true;

                    @Override
                    public void begin(long j) {
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void accept(Object obj) {
                        if (this.take) {
                            boolean zTest = predicate.test(obj);
                            this.take = zTest;
                            if (zTest) {
                                this.downstream.accept(obj);
                            }
                        }
                    }

                    @Override
                    public boolean cancellationRequested() {
                        return !this.take || this.downstream.cancellationRequested();
                    }
                };
            }
        };
    }

    class C05942 extends IntPipeline.StatefulOp {
        C05942(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, IntPredicate intPredicate) {
            super(abstractPipeline, streamShape, i);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return opEvaluateParallel(pipelineHelper, spliterator, new IntFunction() {
                    @Override
                    public final Object apply(int i) {
                        return WhileOps.C05942.lambda$opEvaluateParallelLazy$0(i);
                    }
                }).spliterator();
            }
            return new UnorderedWhileSpliterator.OfInt.Taking((Spliterator.OfInt) pipelineHelper.wrapSpliterator(spliterator), false, null);
        }

        static Integer[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Integer[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            return (Node) new TakeWhileTask(this, pipelineHelper, spliterator, intFunction).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return new Sink.ChainedInt(sink) {
                boolean take = true;

                @Override
                public void begin(long j) {
                    this.downstream.begin(-1L);
                }

                @Override
                public void accept(int i2) {
                    if (this.take) {
                        C05942.this.getClass();
                        IntPredicate intPredicate = null;
                        intPredicate.test(i2);
                        throw null;
                    }
                }

                @Override
                public boolean cancellationRequested() {
                    return !this.take || this.downstream.cancellationRequested();
                }
            };
        }
    }

    static IntStream makeTakeWhileInt(AbstractPipeline abstractPipeline, IntPredicate intPredicate) {
        Objects.requireNonNull(intPredicate);
        return new C05942(abstractPipeline, StreamShape.INT_VALUE, TAKE_FLAGS, intPredicate);
    }

    class C05953 extends LongPipeline.StatefulOp {
        C05953(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, LongPredicate longPredicate) {
            super(abstractPipeline, streamShape, i);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return opEvaluateParallel(pipelineHelper, spliterator, new IntFunction() {
                    @Override
                    public final Object apply(int i) {
                        return WhileOps.C05953.lambda$opEvaluateParallelLazy$0(i);
                    }
                }).spliterator();
            }
            return new UnorderedWhileSpliterator.OfLong.Taking((Spliterator.OfLong) pipelineHelper.wrapSpliterator(spliterator), false, null);
        }

        static Long[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Long[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            return (Node) new TakeWhileTask(this, pipelineHelper, spliterator, intFunction).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return new Sink.ChainedLong(sink) {
                boolean take = true;

                @Override
                public void begin(long j) {
                    this.downstream.begin(-1L);
                }

                @Override
                public void accept(long j) {
                    if (this.take) {
                        C05953.this.getClass();
                        LongPredicate longPredicate = null;
                        longPredicate.test(j);
                        throw null;
                    }
                }

                @Override
                public boolean cancellationRequested() {
                    return !this.take || this.downstream.cancellationRequested();
                }
            };
        }
    }

    static LongStream makeTakeWhileLong(AbstractPipeline abstractPipeline, LongPredicate longPredicate) {
        Objects.requireNonNull(longPredicate);
        return new C05953(abstractPipeline, StreamShape.LONG_VALUE, TAKE_FLAGS, longPredicate);
    }

    class C05964 extends DoublePipeline.StatefulOp {
        C05964(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, DoublePredicate doublePredicate) {
            super(abstractPipeline, streamShape, i);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return opEvaluateParallel(pipelineHelper, spliterator, new IntFunction() {
                    @Override
                    public final Object apply(int i) {
                        return WhileOps.C05964.lambda$opEvaluateParallelLazy$0(i);
                    }
                }).spliterator();
            }
            return new UnorderedWhileSpliterator.OfDouble.Taking((Spliterator.OfDouble) pipelineHelper.wrapSpliterator(spliterator), false, null);
        }

        static Double[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Double[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            return (Node) new TakeWhileTask(this, pipelineHelper, spliterator, intFunction).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return new Sink.ChainedDouble(sink) {
                boolean take = true;

                @Override
                public void begin(long j) {
                    this.downstream.begin(-1L);
                }

                @Override
                public void accept(double d) {
                    if (this.take) {
                        C05964.this.getClass();
                        DoublePredicate doublePredicate = null;
                        doublePredicate.test(d);
                        throw null;
                    }
                }

                @Override
                public boolean cancellationRequested() {
                    return !this.take || this.downstream.cancellationRequested();
                }
            };
        }
    }

    static DoubleStream makeTakeWhileDouble(AbstractPipeline abstractPipeline, DoublePredicate doublePredicate) {
        Objects.requireNonNull(doublePredicate);
        return new C05964(abstractPipeline, StreamShape.DOUBLE_VALUE, TAKE_FLAGS, doublePredicate);
    }

    static Stream makeDropWhileRef(AbstractPipeline abstractPipeline, Predicate predicate) {
        Objects.requireNonNull(predicate);
        return new C1Op(abstractPipeline, StreamShape.REFERENCE, DROP_FLAGS, predicate);
    }

    class C1Op extends ReferencePipeline.StatefulOp implements DropWhileOp {
        final Predicate val$predicate;

        public C1Op(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, Predicate predicate) {
            super(abstractPipeline, streamShape, i);
            this.val$predicate = predicate;
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return opEvaluateParallel(pipelineHelper, spliterator, Nodes.castingArray()).spliterator();
            }
            return new UnorderedWhileSpliterator.OfRef.Dropping(pipelineHelper.wrapSpliterator(spliterator), false, this.val$predicate);
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            return (Node) new DropWhileTask(this, pipelineHelper, spliterator, intFunction).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return opWrapSink(sink, false);
        }

        class C1OpSink extends Sink.ChainedReference implements DropWhileSink {
            long dropCount;
            boolean take;
            final boolean val$retainAndCountDroppedElements;
            final Sink val$sink;

            C1OpSink(Sink sink, boolean z) {
                super(sink);
                this.val$sink = sink;
                this.val$retainAndCountDroppedElements = z;
            }

            @Override
            public void accept(Object obj) {
                boolean z;
                if (this.take) {
                    z = true;
                } else {
                    boolean zTest = C1Op.this.val$predicate.test(obj);
                    this.take = !zTest;
                    if (zTest) {
                        z = false;
                    } else {
                        z = true;
                    }
                }
                boolean z2 = this.val$retainAndCountDroppedElements;
                if (z2 && !z) {
                    this.dropCount++;
                }
                if (z2 || z) {
                    this.downstream.accept(obj);
                }
            }

            @Override
            public long getDropCount() {
                return this.dropCount;
            }
        }

        @Override
        public DropWhileSink opWrapSink(Sink sink, boolean z) {
            return new C1OpSink(sink, z);
        }
    }

    static IntStream makeDropWhileInt(AbstractPipeline abstractPipeline, IntPredicate intPredicate) {
        Objects.requireNonNull(intPredicate);
        return new C2Op(abstractPipeline, StreamShape.INT_VALUE, DROP_FLAGS, intPredicate);
    }

    class C2Op extends IntPipeline.StatefulOp implements DropWhileOp {
        public C2Op(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, IntPredicate intPredicate) {
            super(abstractPipeline, streamShape, i);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return opEvaluateParallel(pipelineHelper, spliterator, new IntFunction() {
                    @Override
                    public final Object apply(int i) {
                        return WhileOps.C2Op.lambda$opEvaluateParallelLazy$0(i);
                    }
                }).spliterator();
            }
            return new UnorderedWhileSpliterator.OfInt.Dropping((Spliterator.OfInt) pipelineHelper.wrapSpliterator(spliterator), false, null);
        }

        static Integer[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Integer[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            return (Node) new DropWhileTask(this, pipelineHelper, spliterator, intFunction).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return opWrapSink(sink, false);
        }

        class C1OpSink extends Sink.ChainedInt implements DropWhileSink {
            long dropCount;
            boolean take;
            final boolean val$retainAndCountDroppedElements;
            final Sink val$sink;

            C1OpSink(Sink sink, boolean z) {
                super(sink);
                this.val$sink = sink;
                this.val$retainAndCountDroppedElements = z;
            }

            @Override
            public void accept(int i) {
                if (!this.take) {
                    C2Op.this.getClass();
                    IntPredicate intPredicate = null;
                    intPredicate.test(i);
                    throw null;
                }
                this.downstream.accept(i);
            }

            @Override
            public long getDropCount() {
                return this.dropCount;
            }
        }

        @Override
        public DropWhileSink opWrapSink(Sink sink, boolean z) {
            return new C1OpSink(sink, z);
        }
    }

    static LongStream makeDropWhileLong(AbstractPipeline abstractPipeline, LongPredicate longPredicate) {
        Objects.requireNonNull(longPredicate);
        return new C3Op(abstractPipeline, StreamShape.LONG_VALUE, DROP_FLAGS, longPredicate);
    }

    class C3Op extends LongPipeline.StatefulOp implements DropWhileOp {
        public C3Op(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, LongPredicate longPredicate) {
            super(abstractPipeline, streamShape, i);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return opEvaluateParallel(pipelineHelper, spliterator, new IntFunction() {
                    @Override
                    public final Object apply(int i) {
                        return WhileOps.C3Op.lambda$opEvaluateParallelLazy$0(i);
                    }
                }).spliterator();
            }
            return new UnorderedWhileSpliterator.OfLong.Dropping((Spliterator.OfLong) pipelineHelper.wrapSpliterator(spliterator), false, null);
        }

        static Long[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Long[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            return (Node) new DropWhileTask(this, pipelineHelper, spliterator, intFunction).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return opWrapSink(sink, false);
        }

        class C1OpSink extends Sink.ChainedLong implements DropWhileSink {
            long dropCount;
            boolean take;
            final boolean val$retainAndCountDroppedElements;
            final Sink val$sink;

            C1OpSink(Sink sink, boolean z) {
                super(sink);
                this.val$sink = sink;
                this.val$retainAndCountDroppedElements = z;
            }

            @Override
            public void accept(long j) {
                if (!this.take) {
                    C3Op.this.getClass();
                    LongPredicate longPredicate = null;
                    longPredicate.test(j);
                    throw null;
                }
                this.downstream.accept(j);
            }

            @Override
            public long getDropCount() {
                return this.dropCount;
            }
        }

        @Override
        public DropWhileSink opWrapSink(Sink sink, boolean z) {
            return new C1OpSink(sink, z);
        }
    }

    static DoubleStream makeDropWhileDouble(AbstractPipeline abstractPipeline, DoublePredicate doublePredicate) {
        Objects.requireNonNull(doublePredicate);
        return new C4Op(abstractPipeline, StreamShape.DOUBLE_VALUE, DROP_FLAGS, doublePredicate);
    }

    class C4Op extends DoublePipeline.StatefulOp implements DropWhileOp {
        public C4Op(AbstractPipeline abstractPipeline, StreamShape streamShape, int i, DoublePredicate doublePredicate) {
            super(abstractPipeline, streamShape, i);
        }

        @Override
        Spliterator opEvaluateParallelLazy(PipelineHelper pipelineHelper, Spliterator spliterator) {
            if (StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                return opEvaluateParallel(pipelineHelper, spliterator, new IntFunction() {
                    @Override
                    public final Object apply(int i) {
                        return WhileOps.C4Op.lambda$opEvaluateParallelLazy$0(i);
                    }
                }).spliterator();
            }
            return new UnorderedWhileSpliterator.OfDouble.Dropping((Spliterator.OfDouble) pipelineHelper.wrapSpliterator(spliterator), false, null);
        }

        static Double[] lambda$opEvaluateParallelLazy$0(int i) {
            return new Double[i];
        }

        @Override
        Node opEvaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            return (Node) new DropWhileTask(this, pipelineHelper, spliterator, intFunction).invoke();
        }

        @Override
        Sink opWrapSink(int i, Sink sink) {
            return opWrapSink(sink, false);
        }

        class C1OpSink extends Sink.ChainedDouble implements DropWhileSink {
            long dropCount;
            boolean take;
            final boolean val$retainAndCountDroppedElements;
            final Sink val$sink;

            C1OpSink(Sink sink, boolean z) {
                super(sink);
                this.val$sink = sink;
                this.val$retainAndCountDroppedElements = z;
            }

            @Override
            public void accept(double d) {
                if (!this.take) {
                    C4Op.this.getClass();
                    DoublePredicate doublePredicate = null;
                    doublePredicate.test(d);
                    throw null;
                }
                this.downstream.accept(d);
            }

            @Override
            public long getDropCount() {
                return this.dropCount;
            }
        }

        @Override
        public DropWhileSink opWrapSink(Sink sink, boolean z) {
            return new C1OpSink(sink, z);
        }
    }

    static abstract class UnorderedWhileSpliterator implements Spliterator {
        final AtomicBoolean cancel;
        int count;
        final boolean noSplitting;

        final Spliterator f1407s;
        boolean takeOrDrop;

        @Override
        public void forEachRemaining(Consumer consumer) {
            Spliterator.CC.$default$forEachRemaining(this, consumer);
        }

        @Override
        public long getExactSizeIfKnown() {
            return -1L;
        }

        @Override
        public boolean hasCharacteristics(int i) {
            return Spliterator.CC.$default$hasCharacteristics(this, i);
        }

        abstract Spliterator makeSpliterator(Spliterator spliterator);

        UnorderedWhileSpliterator(Spliterator spliterator, boolean z) {
            this.takeOrDrop = true;
            this.f1407s = spliterator;
            this.noSplitting = z;
            this.cancel = new AtomicBoolean();
        }

        UnorderedWhileSpliterator(Spliterator spliterator, UnorderedWhileSpliterator unorderedWhileSpliterator) {
            this.takeOrDrop = true;
            this.f1407s = spliterator;
            this.noSplitting = unorderedWhileSpliterator.noSplitting;
            this.cancel = unorderedWhileSpliterator.cancel;
        }

        @Override
        public long estimateSize() {
            return this.f1407s.estimateSize();
        }

        @Override
        public int characteristics() {
            return this.f1407s.characteristics() & (-16449);
        }

        @Override
        public Comparator getComparator() {
            return this.f1407s.getComparator();
        }

        @Override
        public Spliterator trySplit() {
            Spliterator spliteratorTrySplit = this.noSplitting ? null : this.f1407s.trySplit();
            if (spliteratorTrySplit != null) {
                return makeSpliterator(spliteratorTrySplit);
            }
            return null;
        }

        boolean checkCancelOnCount() {
            return (this.count == 0 && this.cancel.get()) ? false : true;
        }

        static abstract class OfRef extends UnorderedWhileSpliterator implements Consumer {

            final Predicate f1411p;

            Object f1412t;

            public Consumer andThen(Consumer consumer) {
                return Consumer$CC.$default$andThen(this, consumer);
            }

            OfRef(Spliterator spliterator, boolean z, Predicate predicate) {
                super(spliterator, z);
                this.f1411p = predicate;
            }

            OfRef(Spliterator spliterator, OfRef ofRef) {
                super(spliterator, ofRef);
                this.f1411p = ofRef.f1411p;
            }

            @Override
            public void accept(Object obj) {
                this.count = (this.count + 1) & 63;
                this.f1412t = obj;
            }

            static final class Taking extends OfRef {
                Taking(Spliterator spliterator, boolean z, Predicate predicate) {
                    super(spliterator, z, predicate);
                }

                Taking(Spliterator spliterator, Taking taking) {
                    super(spliterator, taking);
                }

                @Override
                public boolean tryAdvance(Consumer consumer) {
                    boolean zTest;
                    if (this.takeOrDrop && checkCancelOnCount() && this.f1407s.tryAdvance(this)) {
                        zTest = this.f1411p.test(this.f1412t);
                        if (zTest) {
                            consumer.accept(this.f1412t);
                            return true;
                        }
                    } else {
                        zTest = true;
                    }
                    this.takeOrDrop = false;
                    if (!zTest) {
                        this.cancel.set(true);
                    }
                    return false;
                }

                @Override
                public Spliterator trySplit() {
                    if (this.cancel.get()) {
                        return null;
                    }
                    return super.trySplit();
                }

                @Override
                Spliterator makeSpliterator(Spliterator spliterator) {
                    return new Taking(spliterator, this);
                }
            }

            static final class Dropping extends OfRef {
                Dropping(Spliterator spliterator, boolean z, Predicate predicate) {
                    super(spliterator, z, predicate);
                }

                Dropping(Spliterator spliterator, Dropping dropping) {
                    super(spliterator, dropping);
                }

                @Override
                public boolean tryAdvance(Consumer consumer) {
                    boolean zTryAdvance;
                    if (this.takeOrDrop) {
                        boolean z = false;
                        this.takeOrDrop = false;
                        while (true) {
                            zTryAdvance = this.f1407s.tryAdvance(this);
                            if (!zTryAdvance || !checkCancelOnCount() || !this.f1411p.test(this.f1412t)) {
                                break;
                            }
                            z = true;
                        }
                        if (zTryAdvance) {
                            if (z) {
                                this.cancel.set(true);
                            }
                            consumer.accept(this.f1412t);
                        }
                        return zTryAdvance;
                    }
                    return this.f1407s.tryAdvance(consumer);
                }

                @Override
                Spliterator makeSpliterator(Spliterator spliterator) {
                    return new Dropping(spliterator, this);
                }
            }
        }

        static abstract class OfInt extends UnorderedWhileSpliterator implements IntConsumer, Spliterator.OfInt {

            int f1409t;

            public IntConsumer andThen(IntConsumer intConsumer) {
                return IntConsumer$CC.$default$andThen(this, intConsumer);
            }

            @Override
            public void forEachRemaining(Object obj) {
                forEachRemaining((IntConsumer) obj);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                Spliterator.OfInt.CC.$default$forEachRemaining((Spliterator.OfInt) this, consumer);
            }

            @Override
            public void forEachRemaining(IntConsumer intConsumer) {
                Spliterator.OfInt.CC.$default$forEachRemaining((Spliterator.OfInt) this, intConsumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return Spliterator.OfInt.CC.$default$tryAdvance(this, consumer);
            }

            OfInt(Spliterator.OfInt ofInt, boolean z, IntPredicate intPredicate) {
                super(ofInt, z);
            }

            OfInt(Spliterator.OfInt ofInt, OfInt ofInt2) {
                super(ofInt, ofInt2);
                ofInt2.getClass();
            }

            @Override
            public void accept(int i) {
                this.count = (this.count + 1) & 63;
                this.f1409t = i;
            }

            static final class Taking extends OfInt {
                Taking(Spliterator.OfInt ofInt, boolean z, IntPredicate intPredicate) {
                    super(ofInt, z, intPredicate);
                }

                Taking(Spliterator.OfInt ofInt, OfInt ofInt2) {
                    super(ofInt, ofInt2);
                }

                @Override
                public boolean tryAdvance(IntConsumer intConsumer) {
                    if (this.takeOrDrop && checkCancelOnCount() && ((Spliterator.OfInt) this.f1407s).tryAdvance((IntConsumer) this)) {
                        IntPredicate intPredicate = null;
                        intPredicate.test(this.f1409t);
                        throw null;
                    }
                    this.takeOrDrop = false;
                    return false;
                }

                @Override
                public Spliterator.OfInt trySplit() {
                    if (this.cancel.get()) {
                        return null;
                    }
                    return (Spliterator.OfInt) super.trySplit();
                }

                @Override
                public Spliterator.OfInt makeSpliterator(Spliterator.OfInt ofInt) {
                    return new Taking(ofInt, this);
                }
            }

            static final class Dropping extends OfInt {
                @Override
                public Spliterator.OfInt trySplit() {
                    return (Spliterator.OfInt) super.trySplit();
                }

                @Override
                public Spliterator.OfPrimitive trySplit() {
                    return (Spliterator.OfPrimitive) super.trySplit();
                }

                Dropping(Spliterator.OfInt ofInt, boolean z, IntPredicate intPredicate) {
                    super(ofInt, z, intPredicate);
                }

                Dropping(Spliterator.OfInt ofInt, OfInt ofInt2) {
                    super(ofInt, ofInt2);
                }

                @Override
                public boolean tryAdvance(IntConsumer intConsumer) {
                    if (this.takeOrDrop) {
                        this.takeOrDrop = false;
                        boolean zTryAdvance = ((Spliterator.OfInt) this.f1407s).tryAdvance((IntConsumer) this);
                        if (zTryAdvance && checkCancelOnCount()) {
                            IntPredicate intPredicate = null;
                            intPredicate.test(this.f1409t);
                            throw null;
                        }
                        if (zTryAdvance) {
                            intConsumer.accept(this.f1409t);
                        }
                        return zTryAdvance;
                    }
                    return ((Spliterator.OfInt) this.f1407s).tryAdvance(intConsumer);
                }

                @Override
                public Spliterator.OfInt makeSpliterator(Spliterator.OfInt ofInt) {
                    return new Dropping(ofInt, this);
                }
            }
        }

        static abstract class OfLong extends UnorderedWhileSpliterator implements LongConsumer, Spliterator.OfLong {

            long f1410t;

            public LongConsumer andThen(LongConsumer longConsumer) {
                return LongConsumer$CC.$default$andThen(this, longConsumer);
            }

            @Override
            public void forEachRemaining(Object obj) {
                forEachRemaining((LongConsumer) obj);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                Spliterator.OfLong.CC.$default$forEachRemaining((Spliterator.OfLong) this, consumer);
            }

            @Override
            public void forEachRemaining(LongConsumer longConsumer) {
                Spliterator.OfLong.CC.$default$forEachRemaining((Spliterator.OfLong) this, longConsumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return Spliterator.OfLong.CC.$default$tryAdvance(this, consumer);
            }

            OfLong(Spliterator.OfLong ofLong, boolean z, LongPredicate longPredicate) {
                super(ofLong, z);
            }

            OfLong(Spliterator.OfLong ofLong, OfLong ofLong2) {
                super(ofLong, ofLong2);
                ofLong2.getClass();
            }

            @Override
            public void accept(long j) {
                this.count = (this.count + 1) & 63;
                this.f1410t = j;
            }

            static final class Taking extends OfLong {
                Taking(Spliterator.OfLong ofLong, boolean z, LongPredicate longPredicate) {
                    super(ofLong, z, longPredicate);
                }

                Taking(Spliterator.OfLong ofLong, OfLong ofLong2) {
                    super(ofLong, ofLong2);
                }

                @Override
                public boolean tryAdvance(LongConsumer longConsumer) {
                    if (this.takeOrDrop && checkCancelOnCount() && ((Spliterator.OfLong) this.f1407s).tryAdvance((LongConsumer) this)) {
                        LongPredicate longPredicate = null;
                        longPredicate.test(this.f1410t);
                        throw null;
                    }
                    this.takeOrDrop = false;
                    return false;
                }

                @Override
                public Spliterator.OfLong trySplit() {
                    if (this.cancel.get()) {
                        return null;
                    }
                    return (Spliterator.OfLong) super.trySplit();
                }

                @Override
                public Spliterator.OfLong makeSpliterator(Spliterator.OfLong ofLong) {
                    return new Taking(ofLong, this);
                }
            }

            static final class Dropping extends OfLong {
                @Override
                public Spliterator.OfLong trySplit() {
                    return (Spliterator.OfLong) super.trySplit();
                }

                @Override
                public Spliterator.OfPrimitive trySplit() {
                    return (Spliterator.OfPrimitive) super.trySplit();
                }

                Dropping(Spliterator.OfLong ofLong, boolean z, LongPredicate longPredicate) {
                    super(ofLong, z, longPredicate);
                }

                Dropping(Spliterator.OfLong ofLong, OfLong ofLong2) {
                    super(ofLong, ofLong2);
                }

                @Override
                public boolean tryAdvance(LongConsumer longConsumer) {
                    if (this.takeOrDrop) {
                        this.takeOrDrop = false;
                        boolean zTryAdvance = ((Spliterator.OfLong) this.f1407s).tryAdvance((LongConsumer) this);
                        if (zTryAdvance && checkCancelOnCount()) {
                            LongPredicate longPredicate = null;
                            longPredicate.test(this.f1410t);
                            throw null;
                        }
                        if (zTryAdvance) {
                            longConsumer.accept(this.f1410t);
                        }
                        return zTryAdvance;
                    }
                    return ((Spliterator.OfLong) this.f1407s).tryAdvance(longConsumer);
                }

                @Override
                public Spliterator.OfLong makeSpliterator(Spliterator.OfLong ofLong) {
                    return new Dropping(ofLong, this);
                }
            }
        }

        static abstract class OfDouble extends UnorderedWhileSpliterator implements DoubleConsumer, Spliterator.OfDouble {

            double f1408t;

            public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
                return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
            }

            @Override
            public void forEachRemaining(Object obj) {
                forEachRemaining((DoubleConsumer) obj);
            }

            @Override
            public void forEachRemaining(Consumer consumer) {
                Spliterator.OfDouble.CC.$default$forEachRemaining((Spliterator.OfDouble) this, consumer);
            }

            @Override
            public void forEachRemaining(DoubleConsumer doubleConsumer) {
                Spliterator.OfDouble.CC.$default$forEachRemaining((Spliterator.OfDouble) this, doubleConsumer);
            }

            @Override
            public boolean tryAdvance(Consumer consumer) {
                return Spliterator.OfDouble.CC.$default$tryAdvance(this, consumer);
            }

            OfDouble(Spliterator.OfDouble ofDouble, boolean z, DoublePredicate doublePredicate) {
                super(ofDouble, z);
            }

            OfDouble(Spliterator.OfDouble ofDouble, OfDouble ofDouble2) {
                super(ofDouble, ofDouble2);
                ofDouble2.getClass();
            }

            @Override
            public void accept(double d) {
                this.count = (this.count + 1) & 63;
                this.f1408t = d;
            }

            static final class Taking extends OfDouble {
                Taking(Spliterator.OfDouble ofDouble, boolean z, DoublePredicate doublePredicate) {
                    super(ofDouble, z, doublePredicate);
                }

                Taking(Spliterator.OfDouble ofDouble, OfDouble ofDouble2) {
                    super(ofDouble, ofDouble2);
                }

                @Override
                public boolean tryAdvance(DoubleConsumer doubleConsumer) {
                    if (this.takeOrDrop && checkCancelOnCount() && ((Spliterator.OfDouble) this.f1407s).tryAdvance((DoubleConsumer) this)) {
                        DoublePredicate doublePredicate = null;
                        doublePredicate.test(this.f1408t);
                        throw null;
                    }
                    this.takeOrDrop = false;
                    return false;
                }

                @Override
                public Spliterator.OfDouble trySplit() {
                    if (this.cancel.get()) {
                        return null;
                    }
                    return (Spliterator.OfDouble) super.trySplit();
                }

                @Override
                public Spliterator.OfDouble makeSpliterator(Spliterator.OfDouble ofDouble) {
                    return new Taking(ofDouble, this);
                }
            }

            static final class Dropping extends OfDouble {
                @Override
                public Spliterator.OfDouble trySplit() {
                    return (Spliterator.OfDouble) super.trySplit();
                }

                @Override
                public Spliterator.OfPrimitive trySplit() {
                    return (Spliterator.OfPrimitive) super.trySplit();
                }

                Dropping(Spliterator.OfDouble ofDouble, boolean z, DoublePredicate doublePredicate) {
                    super(ofDouble, z, doublePredicate);
                }

                Dropping(Spliterator.OfDouble ofDouble, OfDouble ofDouble2) {
                    super(ofDouble, ofDouble2);
                }

                @Override
                public boolean tryAdvance(DoubleConsumer doubleConsumer) {
                    if (this.takeOrDrop) {
                        this.takeOrDrop = false;
                        boolean zTryAdvance = ((Spliterator.OfDouble) this.f1407s).tryAdvance((DoubleConsumer) this);
                        if (zTryAdvance && checkCancelOnCount()) {
                            DoublePredicate doublePredicate = null;
                            doublePredicate.test(this.f1408t);
                            throw null;
                        }
                        if (zTryAdvance) {
                            doubleConsumer.accept(this.f1408t);
                        }
                        return zTryAdvance;
                    }
                    return ((Spliterator.OfDouble) this.f1407s).tryAdvance(doubleConsumer);
                }

                @Override
                public Spliterator.OfDouble makeSpliterator(Spliterator.OfDouble ofDouble) {
                    return new Dropping(ofDouble, this);
                }
            }
        }
    }

    private static final class TakeWhileTask extends AbstractShortCircuitTask {
        private volatile boolean completed;
        private final IntFunction generator;
        private final boolean isOrdered;

        private final AbstractPipeline f1406op;
        private boolean shortCircuited;
        private long thisNodeSize;

        TakeWhileTask(AbstractPipeline abstractPipeline, PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            super(pipelineHelper, spliterator);
            this.f1406op = abstractPipeline;
            this.generator = intFunction;
            this.isOrdered = StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags());
        }

        TakeWhileTask(TakeWhileTask takeWhileTask, Spliterator spliterator) {
            super(takeWhileTask, spliterator);
            this.f1406op = takeWhileTask.f1406op;
            this.generator = takeWhileTask.generator;
            this.isOrdered = takeWhileTask.isOrdered;
        }

        @Override
        public TakeWhileTask makeChild(Spliterator spliterator) {
            return new TakeWhileTask(this, spliterator);
        }

        @Override
        public final Node getEmptyResult() {
            return Nodes.emptyNode(this.f1406op.getOutputShape());
        }

        @Override
        public final Node doLeaf() {
            Node.Builder builderMakeNodeBuilder = this.helper.makeNodeBuilder(-1L, this.generator);
            Sink sinkOpWrapSink = this.f1406op.opWrapSink(this.helper.getStreamAndOpFlags(), builderMakeNodeBuilder);
            PipelineHelper pipelineHelper = this.helper;
            boolean zCopyIntoWithCancel = pipelineHelper.copyIntoWithCancel(pipelineHelper.wrapSink(sinkOpWrapSink), this.spliterator);
            this.shortCircuited = zCopyIntoWithCancel;
            if (zCopyIntoWithCancel) {
                cancelLaterNodes();
            }
            Node nodeBuild = builderMakeNodeBuilder.build();
            this.thisNodeSize = nodeBuild.count();
            return nodeBuild;
        }

        @Override
        public final void onCompletion(CountedCompleter countedCompleter) {
            Node nodeMerge;
            if (!isLeaf()) {
                this.shortCircuited = ((TakeWhileTask) this.leftChild).shortCircuited | ((TakeWhileTask) this.rightChild).shortCircuited;
                if (this.isOrdered && this.canceled) {
                    this.thisNodeSize = 0L;
                    nodeMerge = getEmptyResult();
                } else if (this.isOrdered) {
                    AbstractTask abstractTask = this.leftChild;
                    if (((TakeWhileTask) abstractTask).shortCircuited) {
                        this.thisNodeSize = ((TakeWhileTask) abstractTask).thisNodeSize;
                        nodeMerge = (Node) ((TakeWhileTask) abstractTask).getLocalResult();
                    } else {
                        this.thisNodeSize = ((TakeWhileTask) this.leftChild).thisNodeSize + ((TakeWhileTask) this.rightChild).thisNodeSize;
                        nodeMerge = merge();
                    }
                } else {
                    this.thisNodeSize = ((TakeWhileTask) this.leftChild).thisNodeSize + ((TakeWhileTask) this.rightChild).thisNodeSize;
                    nodeMerge = merge();
                }
                setLocalResult(nodeMerge);
            }
            this.completed = true;
            super.onCompletion(countedCompleter);
        }

        Node merge() {
            AbstractTask abstractTask = this.leftChild;
            if (((TakeWhileTask) abstractTask).thisNodeSize == 0) {
                return (Node) ((TakeWhileTask) this.rightChild).getLocalResult();
            }
            if (((TakeWhileTask) this.rightChild).thisNodeSize == 0) {
                return (Node) ((TakeWhileTask) abstractTask).getLocalResult();
            }
            return Nodes.conc(this.f1406op.getOutputShape(), (Node) ((TakeWhileTask) this.leftChild).getLocalResult(), (Node) ((TakeWhileTask) this.rightChild).getLocalResult());
        }

        @Override
        protected void cancel() {
            super.cancel();
            if (this.isOrdered && this.completed) {
                setLocalResult(getEmptyResult());
            }
        }
    }

    private static final class DropWhileTask extends AbstractTask {
        private final IntFunction generator;
        private long index;
        private final boolean isOrdered;

        private final AbstractPipeline f1405op;
        private long thisNodeSize;

        DropWhileTask(AbstractPipeline abstractPipeline, PipelineHelper pipelineHelper, Spliterator spliterator, IntFunction intFunction) {
            super(pipelineHelper, spliterator);
            this.f1405op = abstractPipeline;
            this.generator = intFunction;
            this.isOrdered = StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags());
        }

        DropWhileTask(DropWhileTask dropWhileTask, Spliterator spliterator) {
            super(dropWhileTask, spliterator);
            this.f1405op = dropWhileTask.f1405op;
            this.generator = dropWhileTask.generator;
            this.isOrdered = dropWhileTask.isOrdered;
        }

        @Override
        public DropWhileTask makeChild(Spliterator spliterator) {
            return new DropWhileTask(this, spliterator);
        }

        @Override
        public final Node doLeaf() {
            boolean zIsRoot = isRoot();
            Node.Builder builderMakeNodeBuilder = this.helper.makeNodeBuilder((!zIsRoot && this.isOrdered && StreamOpFlag.SIZED.isPreserved(this.f1405op.sourceOrOpFlags)) ? this.f1405op.exactOutputSizeIfKnown(this.spliterator) : -1L, this.generator);
            DropWhileSink dropWhileSinkOpWrapSink = ((DropWhileOp) this.f1405op).opWrapSink(builderMakeNodeBuilder, this.isOrdered && !zIsRoot);
            this.helper.wrapAndCopyInto(dropWhileSinkOpWrapSink, this.spliterator);
            Node nodeBuild = builderMakeNodeBuilder.build();
            this.thisNodeSize = nodeBuild.count();
            this.index = dropWhileSinkOpWrapSink.getDropCount();
            return nodeBuild;
        }

        @Override
        public final void onCompletion(CountedCompleter countedCompleter) {
            if (!isLeaf()) {
                if (this.isOrdered) {
                    AbstractTask abstractTask = this.leftChild;
                    long j = ((DropWhileTask) abstractTask).index;
                    this.index = j;
                    if (j == ((DropWhileTask) abstractTask).thisNodeSize) {
                        this.index = j + ((DropWhileTask) this.rightChild).index;
                    }
                }
                this.thisNodeSize = ((DropWhileTask) this.leftChild).thisNodeSize + ((DropWhileTask) this.rightChild).thisNodeSize;
                Node nodeMerge = merge();
                if (isRoot()) {
                    nodeMerge = doTruncate(nodeMerge);
                }
                setLocalResult(nodeMerge);
            }
            super.onCompletion(countedCompleter);
        }

        private Node merge() {
            AbstractTask abstractTask = this.leftChild;
            if (((DropWhileTask) abstractTask).thisNodeSize == 0) {
                return (Node) ((DropWhileTask) this.rightChild).getLocalResult();
            }
            if (((DropWhileTask) this.rightChild).thisNodeSize == 0) {
                return (Node) ((DropWhileTask) abstractTask).getLocalResult();
            }
            return Nodes.conc(this.f1405op.getOutputShape(), (Node) ((DropWhileTask) this.leftChild).getLocalResult(), (Node) ((DropWhileTask) this.rightChild).getLocalResult());
        }

        private Node doTruncate(Node node) {
            return this.isOrdered ? node.truncate(this.index, node.count(), this.generator) : node;
        }
    }
}
