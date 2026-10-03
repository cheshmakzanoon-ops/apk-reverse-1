package p000j$.util.stream;

import java.util.Iterator;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.IntFunction;
import java.util.function.LongBinaryOperator;
import java.util.function.LongConsumer;
import java.util.function.LongFunction;
import java.util.function.LongPredicate;
import java.util.function.LongToDoubleFunction;
import java.util.function.LongToIntFunction;
import java.util.function.LongUnaryOperator;
import java.util.function.ObjLongConsumer;
import java.util.function.Supplier;
import java.util.function.ToLongFunction;
import p000j$.util.LongSummaryStatistics;
import p000j$.util.Objects;
import p000j$.util.OptionalDouble;
import p000j$.util.OptionalLong;
import p000j$.util.Spliterator;
import p000j$.util.Spliterators;
import p000j$.util.function.BiConsumer$CC;
import p000j$.util.function.BiFunction$CC;

abstract class LongPipeline extends AbstractPipeline implements LongStream {
    LongPipeline(Spliterator spliterator, int i, boolean z) {
        super(spliterator, i, z);
    }

    LongPipeline(AbstractPipeline abstractPipeline, int i) {
        super(abstractPipeline, i);
    }

    private static LongConsumer adapt(Sink sink) {
        if (sink instanceof LongConsumer) {
            return (LongConsumer) sink;
        }
        if (Tripwire.ENABLED) {
            Tripwire.trip(AbstractPipeline.class, "using LongStream.adapt(Sink<Long> s)");
        }
        Objects.requireNonNull(sink);
        return new LongPipeline$$ExternalSyntheticLambda12(sink);
    }

    public static Spliterator.OfLong adapt(Spliterator spliterator) {
        if (spliterator instanceof Spliterator.OfLong) {
            return (Spliterator.OfLong) spliterator;
        }
        if (Tripwire.ENABLED) {
            Tripwire.trip(AbstractPipeline.class, "using LongStream.adapt(Spliterator<Long> s)");
        }
        throw new UnsupportedOperationException("LongStream.adapt(Spliterator<Long> s)");
    }

    @Override
    final StreamShape getOutputShape() {
        return StreamShape.LONG_VALUE;
    }

    @Override
    final Node evaluateToNode(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z, IntFunction intFunction) {
        return Nodes.collectLong(pipelineHelper, spliterator, z);
    }

    @Override
    final Spliterator wrap(PipelineHelper pipelineHelper, Supplier supplier, boolean z) {
        return new StreamSpliterators$LongWrappingSpliterator(pipelineHelper, supplier, z);
    }

    @Override
    final Spliterator.OfLong lazySpliterator(Supplier supplier) {
        return new StreamSpliterators$DelegatingSpliterator.OfLong(supplier);
    }

    @Override
    final boolean forEachWithCancel(Spliterator spliterator, Sink sink) {
        boolean zCancellationRequested;
        Spliterator.OfLong ofLongAdapt = adapt(spliterator);
        LongConsumer longConsumerAdapt = adapt(sink);
        do {
            zCancellationRequested = sink.cancellationRequested();
            if (zCancellationRequested) {
                break;
            }
        } while (ofLongAdapt.tryAdvance(longConsumerAdapt));
        return zCancellationRequested;
    }

    @Override
    final Node.Builder makeNodeBuilder(long j, IntFunction intFunction) {
        return Nodes.longBuilder(j);
    }

    private Stream mapToObj(final LongFunction longFunction, int i) {
        return new ReferencePipeline.StatelessOp(this, StreamShape.LONG_VALUE, i) {
            @Override
            Sink opWrapSink(int i2, Sink sink) {
                return new Sink.ChainedLong(sink) {
                    @Override
                    public void accept(long j) {
                        this.downstream.accept(longFunction.apply(j));
                    }
                };
            }
        };
    }

    @Override
    public final Iterator<Long> iterator() {
        return Spliterators.iterator(spliterator());
    }

    @Override
    public final Spliterator.OfLong spliterator() {
        return adapt(super.spliterator());
    }

    @Override
    public final DoubleStream asDoubleStream() {
        return new DoublePipeline.StatelessOp(this, StreamShape.LONG_VALUE, StreamOpFlag.NOT_DISTINCT) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedLong(sink) {
                    @Override
                    public void accept(long j) {
                        this.downstream.accept(j);
                    }
                };
            }
        };
    }

    @Override
    public final Stream boxed() {
        return mapToObj(new LongFunction() {
            @Override
            public final Object apply(long j) {
                return Long.valueOf(j);
            }
        }, 0);
    }

    @Override
    public final LongStream map(LongUnaryOperator longUnaryOperator) {
        Objects.requireNonNull(longUnaryOperator);
        return new StatelessOp(this, StreamShape.LONG_VALUE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT, longUnaryOperator) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedLong(sink) {
                    @Override
                    public void accept(long j) {
                        getClass();
                        LongUnaryOperator longUnaryOperator2 = null;
                        longUnaryOperator2.applyAsLong(j);
                        throw null;
                    }
                };
            }
        };
    }

    @Override
    public final Stream mapToObj(LongFunction longFunction) {
        Objects.requireNonNull(longFunction);
        return mapToObj(longFunction, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT);
    }

    @Override
    public final IntStream mapToInt(LongToIntFunction longToIntFunction) {
        Objects.requireNonNull(longToIntFunction);
        return new IntPipeline.StatelessOp(this, StreamShape.LONG_VALUE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT, longToIntFunction) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedLong(sink) {
                    @Override
                    public void accept(long j) {
                        getClass();
                        LongToIntFunction longToIntFunction2 = null;
                        longToIntFunction2.applyAsInt(j);
                        throw null;
                    }
                };
            }
        };
    }

    @Override
    public final DoubleStream mapToDouble(LongToDoubleFunction longToDoubleFunction) {
        Objects.requireNonNull(longToDoubleFunction);
        return new DoublePipeline.StatelessOp(this, StreamShape.LONG_VALUE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT, longToDoubleFunction) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedLong(sink) {
                    @Override
                    public void accept(long j) {
                        getClass();
                        LongToDoubleFunction longToDoubleFunction2 = null;
                        longToDoubleFunction2.applyAsDouble(j);
                        throw null;
                    }
                };
            }
        };
    }

    @Override
    public final LongStream flatMap(final LongFunction longFunction) {
        Objects.requireNonNull(longFunction);
        return new StatelessOp(this, StreamShape.LONG_VALUE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT | StreamOpFlag.NOT_SIZED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedLong(sink) {
                    boolean cancellationRequestedCalled;
                    LongConsumer downstreamAsLong;

                    {
                        Sink sink2 = this.downstream;
                        Objects.requireNonNull(sink2);
                        this.downstreamAsLong = new LongPipeline$$ExternalSyntheticLambda12(sink2);
                    }

                    @Override
                    public void begin(long j) {
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void accept(long j) {
                        LongStream longStream = (LongStream) longFunction.apply(j);
                        if (longStream != null) {
                            try {
                                if (!this.cancellationRequestedCalled) {
                                    longStream.sequential().forEach(this.downstreamAsLong);
                                } else {
                                    Spliterator.OfLong ofLongSpliterator = longStream.sequential().spliterator();
                                    while (!this.downstream.cancellationRequested() && ofLongSpliterator.tryAdvance(this.downstreamAsLong)) {
                                    }
                                }
                            } catch (Throwable th) {
                                try {
                                    longStream.close();
                                } catch (Throwable th2) {
                                    th.addSuppressed(th2);
                                }
                                throw th;
                            }
                        }
                        if (longStream != null) {
                            longStream.close();
                        }
                    }

                    @Override
                    public boolean cancellationRequested() {
                        this.cancellationRequestedCalled = true;
                        return this.downstream.cancellationRequested();
                    }
                };
            }
        };
    }

    @Override
    public LongStream unordered() {
        return !isOrdered() ? this : new StatelessOp(this, StreamShape.LONG_VALUE, StreamOpFlag.NOT_ORDERED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return sink;
            }
        };
    }

    @Override
    public final LongStream filter(LongPredicate longPredicate) {
        Objects.requireNonNull(longPredicate);
        return new StatelessOp(this, StreamShape.LONG_VALUE, StreamOpFlag.NOT_SIZED, longPredicate) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedLong(sink) {
                    @Override
                    public void begin(long j) {
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void accept(long j) {
                        getClass();
                        LongPredicate longPredicate2 = null;
                        longPredicate2.test(j);
                        throw null;
                    }
                };
            }
        };
    }

    @Override
    public final LongStream peek(final LongConsumer longConsumer) {
        Objects.requireNonNull(longConsumer);
        return new StatelessOp(this, StreamShape.LONG_VALUE, 0) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedLong(sink) {
                    @Override
                    public void accept(long j) {
                        longConsumer.accept(j);
                        this.downstream.accept(j);
                    }
                };
            }
        };
    }

    @Override
    public final LongStream limit(long j) {
        if (j < 0) {
            throw new IllegalArgumentException(Long.toString(j));
        }
        return SliceOps.makeLong(this, 0L, j);
    }

    @Override
    public final LongStream skip(long j) {
        if (j >= 0) {
            return j == 0 ? this : SliceOps.makeLong(this, j, -1L);
        }
        throw new IllegalArgumentException(Long.toString(j));
    }

    @Override
    public final LongStream takeWhile(LongPredicate longPredicate) {
        return WhileOps.makeTakeWhileLong(this, longPredicate);
    }

    @Override
    public final LongStream dropWhile(LongPredicate longPredicate) {
        return WhileOps.makeDropWhileLong(this, longPredicate);
    }

    @Override
    public final LongStream sorted() {
        return SortedOps.makeLong(this);
    }

    @Override
    public final LongStream distinct() {
        return boxed().distinct().mapToLong(new ToLongFunction() {
            @Override
            public final long applyAsLong(Object obj) {
                return ((Long) obj).longValue();
            }
        });
    }

    @Override
    public void forEach(LongConsumer longConsumer) {
        evaluate(ForEachOps.makeLong(longConsumer, false));
    }

    @Override
    public void forEachOrdered(LongConsumer longConsumer) {
        evaluate(ForEachOps.makeLong(longConsumer, true));
    }

    @Override
    public final long sum() {
        return reduce(0L, new LongBinaryOperator() {
            @Override
            public final long applyAsLong(long j, long j2) {
                return j + j2;
            }
        });
    }

    @Override
    public final OptionalLong min() {
        return reduce(new LongBinaryOperator() {
            @Override
            public final long applyAsLong(long j, long j2) {
                return Math.min(j, j2);
            }
        });
    }

    @Override
    public final OptionalLong max() {
        return reduce(new LongBinaryOperator() {
            @Override
            public final long applyAsLong(long j, long j2) {
                return Math.max(j, j2);
            }
        });
    }

    static long[] lambda$average$1() {
        return new long[2];
    }

    @Override
    public final OptionalDouble average() {
        long[] jArr = (long[]) collect(new Supplier() {
            @Override
            public final Object get() {
                return LongPipeline.lambda$average$1();
            }
        }, new ObjLongConsumer() {
            @Override
            public final void accept(Object obj, long j) {
                LongPipeline.lambda$average$2((long[]) obj, j);
            }
        }, new BiConsumer() {
            @Override
            public final void accept(Object obj, Object obj2) {
                LongPipeline.lambda$average$3((long[]) obj, (long[]) obj2);
            }

            public BiConsumer andThen(BiConsumer biConsumer) {
                return BiConsumer$CC.$default$andThen(this, biConsumer);
            }
        });
        long j = jArr[0];
        if (j > 0) {
            return OptionalDouble.m1721of(jArr[1] / j);
        }
        return OptionalDouble.empty();
    }

    static void lambda$average$2(long[] jArr, long j) {
        jArr[0] = jArr[0] + 1;
        jArr[1] = jArr[1] + j;
    }

    static void lambda$average$3(long[] jArr, long[] jArr2) {
        jArr[0] = jArr[0] + jArr2[0];
        jArr[1] = jArr[1] + jArr2[1];
    }

    @Override
    public final long count() {
        return ((Long) evaluate(ReduceOps.makeLongCounting())).longValue();
    }

    @Override
    public final LongSummaryStatistics summaryStatistics() {
        return (LongSummaryStatistics) collect(new Supplier() {
            @Override
            public final Object get() {
                return new LongSummaryStatistics();
            }
        }, new ObjLongConsumer() {
            @Override
            public final void accept(Object obj, long j) {
                ((LongSummaryStatistics) obj).accept(j);
            }
        }, new BiConsumer() {
            @Override
            public final void accept(Object obj, Object obj2) {
                ((LongSummaryStatistics) obj).combine((LongSummaryStatistics) obj2);
            }

            public BiConsumer andThen(BiConsumer biConsumer) {
                return BiConsumer$CC.$default$andThen(this, biConsumer);
            }
        });
    }

    @Override
    public final long reduce(long j, LongBinaryOperator longBinaryOperator) {
        return ((Long) evaluate(ReduceOps.makeLong(j, longBinaryOperator))).longValue();
    }

    @Override
    public final OptionalLong reduce(LongBinaryOperator longBinaryOperator) {
        return (OptionalLong) evaluate(ReduceOps.makeLong(longBinaryOperator));
    }

    @Override
    public final Object collect(Supplier supplier, ObjLongConsumer objLongConsumer, final BiConsumer biConsumer) {
        Objects.requireNonNull(biConsumer);
        return evaluate(ReduceOps.makeLong(supplier, objLongConsumer, new BinaryOperator() {
            public BiFunction andThen(Function function) {
                return BiFunction$CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj, Object obj2) {
                return LongPipeline.lambda$collect$4(biConsumer, obj, obj2);
            }
        }));
    }

    static Object lambda$collect$4(BiConsumer biConsumer, Object obj, Object obj2) {
        biConsumer.accept(obj, obj2);
        return obj;
    }

    @Override
    public final boolean anyMatch(LongPredicate longPredicate) {
        return ((Boolean) evaluate(MatchOps.makeLong(longPredicate, MatchOps.MatchKind.ANY))).booleanValue();
    }

    @Override
    public final boolean allMatch(LongPredicate longPredicate) {
        return ((Boolean) evaluate(MatchOps.makeLong(longPredicate, MatchOps.MatchKind.ALL))).booleanValue();
    }

    @Override
    public final boolean noneMatch(LongPredicate longPredicate) {
        return ((Boolean) evaluate(MatchOps.makeLong(longPredicate, MatchOps.MatchKind.NONE))).booleanValue();
    }

    @Override
    public final OptionalLong findFirst() {
        return (OptionalLong) evaluate(FindOps.makeLong(true));
    }

    @Override
    public final OptionalLong findAny() {
        return (OptionalLong) evaluate(FindOps.makeLong(false));
    }

    static Long[] lambda$toArray$5(int i) {
        return new Long[i];
    }

    @Override
    public final long[] toArray() {
        return (long[]) Nodes.flattenLong((Node.OfLong) evaluateToArrayNode(new IntFunction() {
            @Override
            public final Object apply(int i) {
                return LongPipeline.lambda$toArray$5(i);
            }
        })).asPrimitiveArray();
    }

    static class Head extends LongPipeline {
        @Override
        public Iterator<Long> iterator() {
            return super.iterator();
        }

        @Override
        Spliterator lazySpliterator(Supplier supplier) {
            return super.lazySpliterator(supplier);
        }

        @Override
        public LongStream parallel() {
            return (LongStream) super.parallel();
        }

        @Override
        public LongStream sequential() {
            return (LongStream) super.sequential();
        }

        @Override
        public Spliterator spliterator() {
            return super.spliterator();
        }

        @Override
        public BaseStream unordered() {
            return super.unordered();
        }

        Head(Spliterator spliterator, int i, boolean z) {
            super(spliterator, i, z);
        }

        @Override
        final boolean opIsStateful() {
            throw new UnsupportedOperationException();
        }

        @Override
        final Sink opWrapSink(int i, Sink sink) {
            throw new UnsupportedOperationException();
        }

        @Override
        public void forEach(LongConsumer longConsumer) {
            if (!isParallel()) {
                LongPipeline.adapt(sourceStageSpliterator()).forEachRemaining(longConsumer);
            } else {
                super.forEach(longConsumer);
            }
        }

        @Override
        public void forEachOrdered(LongConsumer longConsumer) {
            if (!isParallel()) {
                LongPipeline.adapt(sourceStageSpliterator()).forEachRemaining(longConsumer);
            } else {
                super.forEachOrdered(longConsumer);
            }
        }
    }

    static abstract class StatelessOp extends LongPipeline {
        @Override
        final boolean opIsStateful() {
            return false;
        }

        @Override
        public Iterator<Long> iterator() {
            return super.iterator();
        }

        @Override
        Spliterator lazySpliterator(Supplier supplier) {
            return super.lazySpliterator(supplier);
        }

        @Override
        public LongStream parallel() {
            return (LongStream) super.parallel();
        }

        @Override
        public LongStream sequential() {
            return (LongStream) super.sequential();
        }

        @Override
        public Spliterator spliterator() {
            return super.spliterator();
        }

        @Override
        public BaseStream unordered() {
            return super.unordered();
        }

        StatelessOp(AbstractPipeline abstractPipeline, StreamShape streamShape, int i) {
            super(abstractPipeline, i);
        }
    }

    static abstract class StatefulOp extends LongPipeline {
        @Override
        final boolean opIsStateful() {
            return true;
        }

        @Override
        public Iterator<Long> iterator() {
            return super.iterator();
        }

        @Override
        Spliterator lazySpliterator(Supplier supplier) {
            return super.lazySpliterator(supplier);
        }

        @Override
        public LongStream parallel() {
            return (LongStream) super.parallel();
        }

        @Override
        public LongStream sequential() {
            return (LongStream) super.sequential();
        }

        @Override
        public Spliterator spliterator() {
            return super.spliterator();
        }

        @Override
        public BaseStream unordered() {
            return super.unordered();
        }

        StatefulOp(AbstractPipeline abstractPipeline, StreamShape streamShape, int i) {
            super(abstractPipeline, i);
        }
    }
}
