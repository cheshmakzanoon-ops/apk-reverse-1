package p000j$.util.stream;

import java.util.concurrent.CountedCompleter;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Consumer;
import java.util.function.DoubleBinaryOperator;
import java.util.function.DoubleConsumer;
import java.util.function.IntBinaryOperator;
import java.util.function.IntConsumer;
import java.util.function.LongBinaryOperator;
import java.util.function.LongConsumer;
import java.util.function.ObjDoubleConsumer;
import java.util.function.ObjIntConsumer;
import java.util.function.ObjLongConsumer;
import java.util.function.Supplier;
import p000j$.util.Objects;
import p000j$.util.Optional;
import p000j$.util.OptionalDouble;
import p000j$.util.OptionalInt;
import p000j$.util.OptionalLong;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;
import p000j$.util.function.IntConsumer$CC;
import p000j$.util.function.LongConsumer$CC;

abstract class ReduceOps {

    private interface AccumulatingSink extends TerminalSink {
        void combine(AccumulatingSink accumulatingSink);
    }

    public static TerminalOp makeRef(final Object obj, final BiFunction biFunction, final BinaryOperator binaryOperator) {
        Objects.requireNonNull(biFunction);
        Objects.requireNonNull(binaryOperator);
        return new ReduceOp(StreamShape.REFERENCE) {
            @Override
            public C1ReducingSink makeSink() {
                return new C1ReducingSink(obj, biFunction, binaryOperator);
            }
        };
    }

    class C1ReducingSink extends Box implements AccumulatingSink {
        final BinaryOperator val$combiner;
        final BiFunction val$reducer;
        final Object val$seed;

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
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C1ReducingSink(Object obj, BiFunction biFunction, BinaryOperator binaryOperator) {
            this.val$seed = obj;
            this.val$reducer = biFunction;
            this.val$combiner = binaryOperator;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$seed;
        }

        @Override
        public void accept(Object obj) {
            this.state = this.val$reducer.apply(this.state, obj);
        }

        @Override
        public void combine(C1ReducingSink c1ReducingSink) {
            this.state = this.val$combiner.apply(this.state, c1ReducingSink.state);
        }
    }

    public static TerminalOp makeRef(final BinaryOperator binaryOperator) {
        Objects.requireNonNull(binaryOperator);
        return new ReduceOp(StreamShape.REFERENCE) {
            @Override
            public C2ReducingSink makeSink() {
                final BinaryOperator binaryOperator2 = binaryOperator;
                return new AccumulatingSink() {
                    private boolean empty;
                    private Object state;

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
                    public boolean cancellationRequested() {
                        return Sink.CC.$default$cancellationRequested(this);
                    }

                    @Override
                    public void end() {
                        Sink.CC.$default$end(this);
                    }

                    @Override
                    public void begin(long j) {
                        this.empty = true;
                        this.state = null;
                    }

                    @Override
                    public void accept(Object obj) {
                        if (this.empty) {
                            this.empty = false;
                            this.state = obj;
                        } else {
                            this.state = binaryOperator2.apply(this.state, obj);
                        }
                    }

                    @Override
                    public Optional get() {
                        return this.empty ? Optional.empty() : Optional.m1720of(this.state);
                    }

                    @Override
                    public void combine(C2ReducingSink c2ReducingSink) {
                        if (c2ReducingSink.empty) {
                            return;
                        }
                        accept(c2ReducingSink.state);
                    }
                };
            }
        };
    }

    public static TerminalOp makeRef(final Collector collector) {
        final Supplier supplier = ((Collector) Objects.requireNonNull(collector)).supplier();
        final BiConsumer biConsumerAccumulator = collector.accumulator();
        final BinaryOperator binaryOperatorCombiner = collector.combiner();
        return new ReduceOp(StreamShape.REFERENCE) {
            @Override
            public C3ReducingSink makeSink() {
                return new C3ReducingSink(supplier, biConsumerAccumulator, binaryOperatorCombiner);
            }

            @Override
            public int getOpFlags() {
                if (collector.characteristics().contains(Collector.Characteristics.UNORDERED)) {
                    return StreamOpFlag.NOT_ORDERED;
                }
                return 0;
            }
        };
    }

    class C3ReducingSink extends Box implements AccumulatingSink {
        final BiConsumer val$accumulator;
        final BinaryOperator val$combiner;
        final Supplier val$supplier;

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
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C3ReducingSink(Supplier supplier, BiConsumer biConsumer, BinaryOperator binaryOperator) {
            this.val$supplier = supplier;
            this.val$accumulator = biConsumer;
            this.val$combiner = binaryOperator;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$supplier.get();
        }

        @Override
        public void accept(Object obj) {
            this.val$accumulator.accept(this.state, obj);
        }

        @Override
        public void combine(C3ReducingSink c3ReducingSink) {
            this.state = this.val$combiner.apply(this.state, c3ReducingSink.state);
        }
    }

    public static TerminalOp makeRef(final Supplier supplier, final BiConsumer biConsumer, final BiConsumer biConsumer2) {
        Objects.requireNonNull(supplier);
        Objects.requireNonNull(biConsumer);
        Objects.requireNonNull(biConsumer2);
        return new ReduceOp(StreamShape.REFERENCE) {
            @Override
            public C4ReducingSink makeSink() {
                return new C4ReducingSink(supplier, biConsumer, biConsumer2);
            }
        };
    }

    class C4ReducingSink extends Box implements AccumulatingSink {
        final BiConsumer val$accumulator;
        final BiConsumer val$reducer;
        final Supplier val$seedFactory;

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
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C4ReducingSink(Supplier supplier, BiConsumer biConsumer, BiConsumer biConsumer2) {
            this.val$seedFactory = supplier;
            this.val$accumulator = biConsumer;
            this.val$reducer = biConsumer2;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$seedFactory.get();
        }

        @Override
        public void accept(Object obj) {
            this.val$accumulator.accept(this.state, obj);
        }

        @Override
        public void combine(C4ReducingSink c4ReducingSink) {
            this.val$reducer.accept(this.state, c4ReducingSink.state);
        }
    }

    public static TerminalOp makeRefCounting() {
        return new ReduceOp(StreamShape.REFERENCE) {
            @Override
            public CountingSink makeSink() {
                return new CountingSink.OfRef();
            }

            @Override
            public Long evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.SIZED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Long.valueOf(spliterator.getExactSizeIfKnown());
                }
                return (Long) super.evaluateSequential(pipelineHelper, spliterator);
            }

            @Override
            public Long evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.SIZED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Long.valueOf(spliterator.getExactSizeIfKnown());
                }
                return (Long) super.evaluateParallel(pipelineHelper, spliterator);
            }

            @Override
            public int getOpFlags() {
                return StreamOpFlag.NOT_ORDERED;
            }
        };
    }

    class C5ReducingSink implements AccumulatingSink, Sink.OfInt {
        private int state;
        final int val$identity;
        final IntBinaryOperator val$operator;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Integer num) {
            Sink.OfInt.CC.$default$accept((Sink.OfInt) this, num);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfInt.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public IntConsumer andThen(IntConsumer intConsumer) {
            return IntConsumer$CC.$default$andThen(this, intConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C5ReducingSink(int i, IntBinaryOperator intBinaryOperator) {
            this.val$identity = i;
            this.val$operator = intBinaryOperator;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$identity;
        }

        @Override
        public void accept(int i) {
            this.state = this.val$operator.applyAsInt(this.state, i);
        }

        @Override
        public Integer get() {
            return Integer.valueOf(this.state);
        }

        @Override
        public void combine(C5ReducingSink c5ReducingSink) {
            accept(c5ReducingSink.state);
        }
    }

    public static TerminalOp makeInt(final int i, final IntBinaryOperator intBinaryOperator) {
        Objects.requireNonNull(intBinaryOperator);
        return new ReduceOp(StreamShape.INT_VALUE) {
            @Override
            public C5ReducingSink makeSink() {
                return new C5ReducingSink(i, intBinaryOperator);
            }
        };
    }

    class C6ReducingSink implements AccumulatingSink, Sink.OfInt {
        private boolean empty;
        private int state;
        final IntBinaryOperator val$operator;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Integer num) {
            Sink.OfInt.CC.$default$accept((Sink.OfInt) this, num);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfInt.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public IntConsumer andThen(IntConsumer intConsumer) {
            return IntConsumer$CC.$default$andThen(this, intConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C6ReducingSink(IntBinaryOperator intBinaryOperator) {
            this.val$operator = intBinaryOperator;
        }

        @Override
        public void begin(long j) {
            this.empty = true;
            this.state = 0;
        }

        @Override
        public void accept(int i) {
            if (this.empty) {
                this.empty = false;
                this.state = i;
            } else {
                this.state = this.val$operator.applyAsInt(this.state, i);
            }
        }

        @Override
        public OptionalInt get() {
            return this.empty ? OptionalInt.empty() : OptionalInt.m1723of(this.state);
        }

        @Override
        public void combine(C6ReducingSink c6ReducingSink) {
            if (c6ReducingSink.empty) {
                return;
            }
            accept(c6ReducingSink.state);
        }
    }

    public static TerminalOp makeInt(final IntBinaryOperator intBinaryOperator) {
        Objects.requireNonNull(intBinaryOperator);
        return new ReduceOp(StreamShape.INT_VALUE) {
            @Override
            public C6ReducingSink makeSink() {
                return new C6ReducingSink(intBinaryOperator);
            }
        };
    }

    public static TerminalOp makeInt(final Supplier supplier, final ObjIntConsumer objIntConsumer, final BinaryOperator binaryOperator) {
        Objects.requireNonNull(supplier);
        Objects.requireNonNull(objIntConsumer);
        Objects.requireNonNull(binaryOperator);
        return new ReduceOp(StreamShape.INT_VALUE) {
            @Override
            public C7ReducingSink makeSink() {
                return new C7ReducingSink(supplier, objIntConsumer, binaryOperator);
            }
        };
    }

    class C7ReducingSink extends Box implements AccumulatingSink, Sink.OfInt {
        final ObjIntConsumer val$accumulator;
        final BinaryOperator val$combiner;
        final Supplier val$supplier;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Integer num) {
            Sink.OfInt.CC.$default$accept((Sink.OfInt) this, num);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfInt.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public IntConsumer andThen(IntConsumer intConsumer) {
            return IntConsumer$CC.$default$andThen(this, intConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C7ReducingSink(Supplier supplier, ObjIntConsumer objIntConsumer, BinaryOperator binaryOperator) {
            this.val$supplier = supplier;
            this.val$accumulator = objIntConsumer;
            this.val$combiner = binaryOperator;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$supplier.get();
        }

        @Override
        public void accept(int i) {
            this.val$accumulator.accept(this.state, i);
        }

        @Override
        public void combine(C7ReducingSink c7ReducingSink) {
            this.state = this.val$combiner.apply(this.state, c7ReducingSink.state);
        }
    }

    public static TerminalOp makeIntCounting() {
        return new ReduceOp(StreamShape.INT_VALUE) {
            @Override
            public CountingSink makeSink() {
                return new CountingSink.OfInt();
            }

            @Override
            public Long evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.SIZED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Long.valueOf(spliterator.getExactSizeIfKnown());
                }
                return (Long) super.evaluateSequential(pipelineHelper, spliterator);
            }

            @Override
            public Long evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.SIZED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Long.valueOf(spliterator.getExactSizeIfKnown());
                }
                return (Long) super.evaluateParallel(pipelineHelper, spliterator);
            }

            @Override
            public int getOpFlags() {
                return StreamOpFlag.NOT_ORDERED;
            }
        };
    }

    class C8ReducingSink implements AccumulatingSink, Sink.OfLong {
        private long state;
        final long val$identity;
        final LongBinaryOperator val$operator;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(Long l) {
            Sink.OfLong.CC.$default$accept((Sink.OfLong) this, l);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfLong.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public LongConsumer andThen(LongConsumer longConsumer) {
            return LongConsumer$CC.$default$andThen(this, longConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C8ReducingSink(long j, LongBinaryOperator longBinaryOperator) {
            this.val$identity = j;
            this.val$operator = longBinaryOperator;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$identity;
        }

        @Override
        public void accept(long j) {
            this.state = this.val$operator.applyAsLong(this.state, j);
        }

        @Override
        public Long get() {
            return Long.valueOf(this.state);
        }

        @Override
        public void combine(C8ReducingSink c8ReducingSink) {
            accept(c8ReducingSink.state);
        }
    }

    public static TerminalOp makeLong(final long j, final LongBinaryOperator longBinaryOperator) {
        Objects.requireNonNull(longBinaryOperator);
        return new ReduceOp(StreamShape.LONG_VALUE) {
            @Override
            public C8ReducingSink makeSink() {
                return new C8ReducingSink(j, longBinaryOperator);
            }
        };
    }

    class C9ReducingSink implements AccumulatingSink, Sink.OfLong {
        private boolean empty;
        private long state;
        final LongBinaryOperator val$operator;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(Long l) {
            Sink.OfLong.CC.$default$accept((Sink.OfLong) this, l);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfLong.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public LongConsumer andThen(LongConsumer longConsumer) {
            return LongConsumer$CC.$default$andThen(this, longConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C9ReducingSink(LongBinaryOperator longBinaryOperator) {
            this.val$operator = longBinaryOperator;
        }

        @Override
        public void begin(long j) {
            this.empty = true;
            this.state = 0L;
        }

        @Override
        public void accept(long j) {
            if (this.empty) {
                this.empty = false;
                this.state = j;
            } else {
                this.state = this.val$operator.applyAsLong(this.state, j);
            }
        }

        @Override
        public OptionalLong get() {
            return this.empty ? OptionalLong.empty() : OptionalLong.m1724of(this.state);
        }

        @Override
        public void combine(C9ReducingSink c9ReducingSink) {
            if (c9ReducingSink.empty) {
                return;
            }
            accept(c9ReducingSink.state);
        }
    }

    public static TerminalOp makeLong(final LongBinaryOperator longBinaryOperator) {
        Objects.requireNonNull(longBinaryOperator);
        return new ReduceOp(StreamShape.LONG_VALUE) {
            @Override
            public C9ReducingSink makeSink() {
                return new C9ReducingSink(longBinaryOperator);
            }
        };
    }

    public static TerminalOp makeLong(final Supplier supplier, final ObjLongConsumer objLongConsumer, final BinaryOperator binaryOperator) {
        Objects.requireNonNull(supplier);
        Objects.requireNonNull(objLongConsumer);
        Objects.requireNonNull(binaryOperator);
        return new ReduceOp(StreamShape.LONG_VALUE) {
            @Override
            public C10ReducingSink makeSink() {
                return new C10ReducingSink(supplier, objLongConsumer, binaryOperator);
            }
        };
    }

    class C10ReducingSink extends Box implements AccumulatingSink, Sink.OfLong {
        final ObjLongConsumer val$accumulator;
        final BinaryOperator val$combiner;
        final Supplier val$supplier;

        @Override
        public void accept(double d) {
            Sink.CC.$default$accept(this, d);
        }

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(Long l) {
            Sink.OfLong.CC.$default$accept((Sink.OfLong) this, l);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfLong.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public LongConsumer andThen(LongConsumer longConsumer) {
            return LongConsumer$CC.$default$andThen(this, longConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C10ReducingSink(Supplier supplier, ObjLongConsumer objLongConsumer, BinaryOperator binaryOperator) {
            this.val$supplier = supplier;
            this.val$accumulator = objLongConsumer;
            this.val$combiner = binaryOperator;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$supplier.get();
        }

        @Override
        public void accept(long j) {
            this.val$accumulator.accept(this.state, j);
        }

        @Override
        public void combine(C10ReducingSink c10ReducingSink) {
            this.state = this.val$combiner.apply(this.state, c10ReducingSink.state);
        }
    }

    public static TerminalOp makeLongCounting() {
        return new ReduceOp(StreamShape.LONG_VALUE) {
            @Override
            public CountingSink makeSink() {
                return new CountingSink.OfLong();
            }

            @Override
            public Long evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.SIZED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Long.valueOf(spliterator.getExactSizeIfKnown());
                }
                return (Long) super.evaluateSequential(pipelineHelper, spliterator);
            }

            @Override
            public Long evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.SIZED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Long.valueOf(spliterator.getExactSizeIfKnown());
                }
                return (Long) super.evaluateParallel(pipelineHelper, spliterator);
            }

            @Override
            public int getOpFlags() {
                return StreamOpFlag.NOT_ORDERED;
            }
        };
    }

    class C11ReducingSink implements AccumulatingSink, Sink.OfDouble {
        private double state;
        final double val$identity;
        final DoubleBinaryOperator val$operator;

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Double d) {
            Sink.OfDouble.CC.$default$accept((Sink.OfDouble) this, d);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfDouble.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
            return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C11ReducingSink(double d, DoubleBinaryOperator doubleBinaryOperator) {
            this.val$identity = d;
            this.val$operator = doubleBinaryOperator;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$identity;
        }

        @Override
        public void accept(double d) {
            this.state = this.val$operator.applyAsDouble(this.state, d);
        }

        @Override
        public Double get() {
            return Double.valueOf(this.state);
        }

        @Override
        public void combine(C11ReducingSink c11ReducingSink) {
            accept(c11ReducingSink.state);
        }
    }

    public static TerminalOp makeDouble(final double d, final DoubleBinaryOperator doubleBinaryOperator) {
        Objects.requireNonNull(doubleBinaryOperator);
        return new ReduceOp(StreamShape.DOUBLE_VALUE) {
            @Override
            public C11ReducingSink makeSink() {
                return new C11ReducingSink(d, doubleBinaryOperator);
            }
        };
    }

    class C12ReducingSink implements AccumulatingSink, Sink.OfDouble {
        private boolean empty;
        private double state;
        final DoubleBinaryOperator val$operator;

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Double d) {
            Sink.OfDouble.CC.$default$accept((Sink.OfDouble) this, d);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfDouble.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
            return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C12ReducingSink(DoubleBinaryOperator doubleBinaryOperator) {
            this.val$operator = doubleBinaryOperator;
        }

        @Override
        public void begin(long j) {
            this.empty = true;
            this.state = 0.0d;
        }

        @Override
        public void accept(double d) {
            if (this.empty) {
                this.empty = false;
                this.state = d;
            } else {
                this.state = this.val$operator.applyAsDouble(this.state, d);
            }
        }

        @Override
        public OptionalDouble get() {
            return this.empty ? OptionalDouble.empty() : OptionalDouble.m1721of(this.state);
        }

        @Override
        public void combine(C12ReducingSink c12ReducingSink) {
            if (c12ReducingSink.empty) {
                return;
            }
            accept(c12ReducingSink.state);
        }
    }

    public static TerminalOp makeDouble(final DoubleBinaryOperator doubleBinaryOperator) {
        Objects.requireNonNull(doubleBinaryOperator);
        return new ReduceOp(StreamShape.DOUBLE_VALUE) {
            @Override
            public C12ReducingSink makeSink() {
                return new C12ReducingSink(doubleBinaryOperator);
            }
        };
    }

    public static TerminalOp makeDouble(final Supplier supplier, final ObjDoubleConsumer objDoubleConsumer, final BinaryOperator binaryOperator) {
        Objects.requireNonNull(supplier);
        Objects.requireNonNull(objDoubleConsumer);
        Objects.requireNonNull(binaryOperator);
        return new ReduceOp(StreamShape.DOUBLE_VALUE) {
            @Override
            public C13ReducingSink makeSink() {
                return new C13ReducingSink(supplier, objDoubleConsumer, binaryOperator);
            }
        };
    }

    class C13ReducingSink extends Box implements AccumulatingSink, Sink.OfDouble {
        final ObjDoubleConsumer val$accumulator;
        final BinaryOperator val$combiner;
        final Supplier val$supplier;

        @Override
        public void accept(int i) {
            Sink.CC.$default$accept((Sink) this, i);
        }

        @Override
        public void accept(long j) {
            Sink.CC.$default$accept((Sink) this, j);
        }

        @Override
        public void accept(Double d) {
            Sink.OfDouble.CC.$default$accept((Sink.OfDouble) this, d);
        }

        @Override
        public void accept(Object obj) {
            Sink.OfDouble.CC.$default$accept(this, obj);
        }

        public Consumer andThen(Consumer consumer) {
            return Consumer$CC.$default$andThen(this, consumer);
        }

        public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
            return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
        }

        @Override
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        C13ReducingSink(Supplier supplier, ObjDoubleConsumer objDoubleConsumer, BinaryOperator binaryOperator) {
            this.val$supplier = supplier;
            this.val$accumulator = objDoubleConsumer;
            this.val$combiner = binaryOperator;
        }

        @Override
        public void begin(long j) {
            this.state = this.val$supplier.get();
        }

        @Override
        public void accept(double d) {
            this.val$accumulator.accept(this.state, d);
        }

        @Override
        public void combine(C13ReducingSink c13ReducingSink) {
            this.state = this.val$combiner.apply(this.state, c13ReducingSink.state);
        }
    }

    public static TerminalOp makeDoubleCounting() {
        return new ReduceOp(StreamShape.DOUBLE_VALUE) {
            @Override
            public CountingSink makeSink() {
                return new CountingSink.OfDouble();
            }

            @Override
            public Long evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.SIZED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Long.valueOf(spliterator.getExactSizeIfKnown());
                }
                return (Long) super.evaluateSequential(pipelineHelper, spliterator);
            }

            @Override
            public Long evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
                if (StreamOpFlag.SIZED.isKnown(pipelineHelper.getStreamAndOpFlags())) {
                    return Long.valueOf(spliterator.getExactSizeIfKnown());
                }
                return (Long) super.evaluateParallel(pipelineHelper, spliterator);
            }

            @Override
            public int getOpFlags() {
                return StreamOpFlag.NOT_ORDERED;
            }
        };
    }

    static abstract class CountingSink extends Box implements AccumulatingSink {
        long count;

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
        public boolean cancellationRequested() {
            return Sink.CC.$default$cancellationRequested(this);
        }

        @Override
        public void end() {
            Sink.CC.$default$end(this);
        }

        CountingSink() {
        }

        @Override
        public void begin(long j) {
            this.count = 0L;
        }

        @Override
        public Long get() {
            return Long.valueOf(this.count);
        }

        public void combine(CountingSink countingSink) {
            this.count += countingSink.count;
        }

        static final class OfRef extends CountingSink {
            OfRef() {
            }

            @Override
            public void combine(AccumulatingSink accumulatingSink) {
                super.combine((CountingSink) accumulatingSink);
            }

            @Override
            public Object get() {
                return super.get();
            }

            @Override
            public void accept(Object obj) {
                this.count++;
            }
        }

        static final class OfInt extends CountingSink implements Sink.OfInt {
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

            OfInt() {
            }

            @Override
            public void combine(AccumulatingSink accumulatingSink) {
                super.combine((CountingSink) accumulatingSink);
            }

            @Override
            public Object get() {
                return super.get();
            }

            @Override
            public void accept(int i) {
                this.count++;
            }
        }

        static final class OfLong extends CountingSink implements Sink.OfLong {
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

            OfLong() {
            }

            @Override
            public void combine(AccumulatingSink accumulatingSink) {
                super.combine((CountingSink) accumulatingSink);
            }

            @Override
            public Object get() {
                return super.get();
            }

            @Override
            public void accept(long j) {
                this.count++;
            }
        }

        static final class OfDouble extends CountingSink implements Sink.OfDouble {
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

            OfDouble() {
            }

            @Override
            public void combine(AccumulatingSink accumulatingSink) {
                super.combine((CountingSink) accumulatingSink);
            }

            @Override
            public Object get() {
                return super.get();
            }

            @Override
            public void accept(double d) {
                this.count++;
            }
        }
    }

    private static abstract class Box {
        Object state;

        Box() {
        }

        public Object get() {
            return this.state;
        }
    }

    private static abstract class ReduceOp implements TerminalOp {
        private final StreamShape inputShape;

        @Override
        public int getOpFlags() {
            return TerminalOp.CC.$default$getOpFlags(this);
        }

        public abstract AccumulatingSink makeSink();

        ReduceOp(StreamShape streamShape) {
            this.inputShape = streamShape;
        }

        @Override
        public Object evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
            return ((AccumulatingSink) pipelineHelper.wrapAndCopyInto(makeSink(), spliterator)).get();
        }

        @Override
        public Object evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
            return ((AccumulatingSink) new ReduceTask(this, pipelineHelper, spliterator).invoke()).get();
        }
    }

    private static final class ReduceTask extends AbstractTask {

        private final ReduceOp f1386op;

        ReduceTask(ReduceOp reduceOp, PipelineHelper pipelineHelper, Spliterator spliterator) {
            super(pipelineHelper, spliterator);
            this.f1386op = reduceOp;
        }

        ReduceTask(ReduceTask reduceTask, Spliterator spliterator) {
            super(reduceTask, spliterator);
            this.f1386op = reduceTask.f1386op;
        }

        @Override
        public ReduceTask makeChild(Spliterator spliterator) {
            return new ReduceTask(this, spliterator);
        }

        @Override
        public AccumulatingSink doLeaf() {
            return (AccumulatingSink) this.helper.wrapAndCopyInto(this.f1386op.makeSink(), this.spliterator);
        }

        @Override
        public void onCompletion(CountedCompleter countedCompleter) {
            if (!isLeaf()) {
                AccumulatingSink accumulatingSink = (AccumulatingSink) ((ReduceTask) this.leftChild).getLocalResult();
                accumulatingSink.combine((AccumulatingSink) ((ReduceTask) this.rightChild).getLocalResult());
                setLocalResult(accumulatingSink);
            }
            super.onCompletion(countedCompleter);
        }
    }
}
