package p000j$.util.stream;

import java.util.Iterator;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.DoubleBinaryOperator;
import java.util.function.DoubleConsumer;
import java.util.function.DoubleFunction;
import java.util.function.DoublePredicate;
import java.util.function.DoubleToIntFunction;
import java.util.function.DoubleToLongFunction;
import java.util.function.DoubleUnaryOperator;
import java.util.function.Function;
import java.util.function.IntFunction;
import java.util.function.ObjDoubleConsumer;
import java.util.function.Supplier;
import java.util.function.ToDoubleFunction;
import p000j$.util.DoubleSummaryStatistics;
import p000j$.util.Objects;
import p000j$.util.OptionalDouble;
import p000j$.util.Spliterator;
import p000j$.util.Spliterators;
import p000j$.util.function.BiConsumer$CC;
import p000j$.util.function.BiFunction$CC;

abstract class DoublePipeline extends AbstractPipeline implements DoubleStream {
    DoublePipeline(Spliterator spliterator, int i, boolean z) {
        super(spliterator, i, z);
    }

    DoublePipeline(AbstractPipeline abstractPipeline, int i) {
        super(abstractPipeline, i);
    }

    private static DoubleConsumer adapt(Sink sink) {
        if (sink instanceof DoubleConsumer) {
            return (DoubleConsumer) sink;
        }
        if (Tripwire.ENABLED) {
            Tripwire.trip(AbstractPipeline.class, "using DoubleStream.adapt(Sink<Double> s)");
        }
        Objects.requireNonNull(sink);
        return new DoublePipeline$$ExternalSyntheticLambda0(sink);
    }

    public static Spliterator.OfDouble adapt(Spliterator spliterator) {
        if (spliterator instanceof Spliterator.OfDouble) {
            return (Spliterator.OfDouble) spliterator;
        }
        if (Tripwire.ENABLED) {
            Tripwire.trip(AbstractPipeline.class, "using DoubleStream.adapt(Spliterator<Double> s)");
        }
        throw new UnsupportedOperationException("DoubleStream.adapt(Spliterator<Double> s)");
    }

    @Override
    final StreamShape getOutputShape() {
        return StreamShape.DOUBLE_VALUE;
    }

    @Override
    final Node evaluateToNode(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z, IntFunction intFunction) {
        return Nodes.collectDouble(pipelineHelper, spliterator, z);
    }

    @Override
    final Spliterator wrap(PipelineHelper pipelineHelper, Supplier supplier, boolean z) {
        return new StreamSpliterators$DoubleWrappingSpliterator(pipelineHelper, supplier, z);
    }

    @Override
    final Spliterator.OfDouble lazySpliterator(Supplier supplier) {
        return new StreamSpliterators$DelegatingSpliterator.OfDouble(supplier);
    }

    @Override
    final boolean forEachWithCancel(Spliterator spliterator, Sink sink) {
        boolean zCancellationRequested;
        Spliterator.OfDouble ofDoubleAdapt = adapt(spliterator);
        DoubleConsumer doubleConsumerAdapt = adapt(sink);
        do {
            zCancellationRequested = sink.cancellationRequested();
            if (zCancellationRequested) {
                break;
            }
        } while (ofDoubleAdapt.tryAdvance(doubleConsumerAdapt));
        return zCancellationRequested;
    }

    @Override
    final Node.Builder makeNodeBuilder(long j, IntFunction intFunction) {
        return Nodes.doubleBuilder(j);
    }

    private Stream mapToObj(final DoubleFunction doubleFunction, int i) {
        return new ReferencePipeline.StatelessOp(this, StreamShape.DOUBLE_VALUE, i) {
            @Override
            Sink opWrapSink(int i2, Sink sink) {
                return new Sink.ChainedDouble(sink) {
                    @Override
                    public void accept(double d) {
                        this.downstream.accept(doubleFunction.apply(d));
                    }
                };
            }
        };
    }

    @Override
    public final Iterator<Double> iterator() {
        return Spliterators.iterator(spliterator());
    }

    @Override
    public final Spliterator.OfDouble spliterator() {
        return adapt(super.spliterator());
    }

    @Override
    public final Stream boxed() {
        return mapToObj(new DoubleFunction() {
            @Override
            public final Object apply(double d) {
                return Double.valueOf(d);
            }
        }, 0);
    }

    @Override
    public final DoubleStream map(final DoubleUnaryOperator doubleUnaryOperator) {
        Objects.requireNonNull(doubleUnaryOperator);
        return new StatelessOp(this, StreamShape.DOUBLE_VALUE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedDouble(sink) {
                    @Override
                    public void accept(double d) {
                        this.downstream.accept(doubleUnaryOperator.applyAsDouble(d));
                    }
                };
            }
        };
    }

    @Override
    public final Stream mapToObj(DoubleFunction doubleFunction) {
        Objects.requireNonNull(doubleFunction);
        return mapToObj(doubleFunction, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT);
    }

    @Override
    public final IntStream mapToInt(DoubleToIntFunction doubleToIntFunction) {
        Objects.requireNonNull(doubleToIntFunction);
        return new IntPipeline.StatelessOp(this, StreamShape.DOUBLE_VALUE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT, doubleToIntFunction) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedDouble(sink) {
                    @Override
                    public void accept(double d) {
                        getClass();
                        DoubleToIntFunction doubleToIntFunction2 = null;
                        doubleToIntFunction2.applyAsInt(d);
                        throw null;
                    }
                };
            }
        };
    }

    @Override
    public final LongStream mapToLong(DoubleToLongFunction doubleToLongFunction) {
        Objects.requireNonNull(doubleToLongFunction);
        return new LongPipeline.StatelessOp(this, StreamShape.DOUBLE_VALUE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT, doubleToLongFunction) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedDouble(sink) {
                    @Override
                    public void accept(double d) {
                        getClass();
                        DoubleToLongFunction doubleToLongFunction2 = null;
                        doubleToLongFunction2.applyAsLong(d);
                        throw null;
                    }
                };
            }
        };
    }

    @Override
    public final DoubleStream flatMap(final DoubleFunction doubleFunction) {
        Objects.requireNonNull(doubleFunction);
        return new StatelessOp(this, StreamShape.DOUBLE_VALUE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT | StreamOpFlag.NOT_SIZED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedDouble(sink) {
                    boolean cancellationRequestedCalled;
                    DoubleConsumer downstreamAsDouble;

                    {
                        Sink sink2 = this.downstream;
                        Objects.requireNonNull(sink2);
                        this.downstreamAsDouble = new DoublePipeline$$ExternalSyntheticLambda0(sink2);
                    }

                    @Override
                    public void begin(long j) {
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void accept(double d) {
                        DoubleStream doubleStream = (DoubleStream) doubleFunction.apply(d);
                        if (doubleStream != null) {
                            try {
                                if (!this.cancellationRequestedCalled) {
                                    doubleStream.sequential().forEach(this.downstreamAsDouble);
                                } else {
                                    Spliterator.OfDouble ofDoubleSpliterator = doubleStream.sequential().spliterator();
                                    while (!this.downstream.cancellationRequested() && ofDoubleSpliterator.tryAdvance(this.downstreamAsDouble)) {
                                    }
                                }
                            } catch (Throwable th) {
                                try {
                                    doubleStream.close();
                                } catch (Throwable th2) {
                                    th.addSuppressed(th2);
                                }
                                throw th;
                            }
                        }
                        if (doubleStream != null) {
                            doubleStream.close();
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
    public DoubleStream unordered() {
        return !isOrdered() ? this : new StatelessOp(this, StreamShape.DOUBLE_VALUE, StreamOpFlag.NOT_ORDERED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return sink;
            }
        };
    }

    @Override
    public final DoubleStream filter(DoublePredicate doublePredicate) {
        Objects.requireNonNull(doublePredicate);
        return new StatelessOp(this, StreamShape.DOUBLE_VALUE, StreamOpFlag.NOT_SIZED, doublePredicate) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedDouble(sink) {
                    @Override
                    public void begin(long j) {
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void accept(double d) {
                        getClass();
                        DoublePredicate doublePredicate2 = null;
                        doublePredicate2.test(d);
                        throw null;
                    }
                };
            }
        };
    }

    @Override
    public final DoubleStream peek(final DoubleConsumer doubleConsumer) {
        Objects.requireNonNull(doubleConsumer);
        return new StatelessOp(this, StreamShape.DOUBLE_VALUE, 0) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedDouble(sink) {
                    @Override
                    public void accept(double d) {
                        doubleConsumer.accept(d);
                        this.downstream.accept(d);
                    }
                };
            }
        };
    }

    @Override
    public final DoubleStream limit(long j) {
        if (j < 0) {
            throw new IllegalArgumentException(Long.toString(j));
        }
        return SliceOps.makeDouble(this, 0L, j);
    }

    @Override
    public final DoubleStream skip(long j) {
        if (j >= 0) {
            return j == 0 ? this : SliceOps.makeDouble(this, j, -1L);
        }
        throw new IllegalArgumentException(Long.toString(j));
    }

    @Override
    public final DoubleStream takeWhile(DoublePredicate doublePredicate) {
        return WhileOps.makeTakeWhileDouble(this, doublePredicate);
    }

    @Override
    public final DoubleStream dropWhile(DoublePredicate doublePredicate) {
        return WhileOps.makeDropWhileDouble(this, doublePredicate);
    }

    @Override
    public final DoubleStream sorted() {
        return SortedOps.makeDouble(this);
    }

    @Override
    public final DoubleStream distinct() {
        return boxed().distinct().mapToDouble(new ToDoubleFunction() {
            @Override
            public final double applyAsDouble(Object obj) {
                return ((Double) obj).doubleValue();
            }
        });
    }

    @Override
    public void forEach(DoubleConsumer doubleConsumer) {
        evaluate(ForEachOps.makeDouble(doubleConsumer, false));
    }

    @Override
    public void forEachOrdered(DoubleConsumer doubleConsumer) {
        evaluate(ForEachOps.makeDouble(doubleConsumer, true));
    }

    static double[] lambda$sum$1() {
        return new double[3];
    }

    @Override
    public final double sum() {
        return Collectors.computeFinalSum((double[]) collect(new Supplier() {
            @Override
            public final Object get() {
                return DoublePipeline.lambda$sum$1();
            }
        }, new ObjDoubleConsumer() {
            @Override
            public final void accept(Object obj, double d) {
                DoublePipeline.lambda$sum$2((double[]) obj, d);
            }
        }, new BiConsumer() {
            @Override
            public final void accept(Object obj, Object obj2) {
                DoublePipeline.lambda$sum$3((double[]) obj, (double[]) obj2);
            }

            public BiConsumer andThen(BiConsumer biConsumer) {
                return BiConsumer$CC.$default$andThen(this, biConsumer);
            }
        }));
    }

    static void lambda$sum$2(double[] dArr, double d) {
        Collectors.sumWithCompensation(dArr, d);
        dArr[2] = dArr[2] + d;
    }

    static void lambda$sum$3(double[] dArr, double[] dArr2) {
        Collectors.sumWithCompensation(dArr, dArr2[0]);
        Collectors.sumWithCompensation(dArr, dArr2[1]);
        dArr[2] = dArr[2] + dArr2[2];
    }

    @Override
    public final OptionalDouble min() {
        return reduce(new DoubleBinaryOperator() {
            @Override
            public final double applyAsDouble(double d, double d2) {
                return Math.min(d, d2);
            }
        });
    }

    @Override
    public final OptionalDouble max() {
        return reduce(new DoubleBinaryOperator() {
            @Override
            public final double applyAsDouble(double d, double d2) {
                return Math.max(d, d2);
            }
        });
    }

    static double[] lambda$average$4() {
        return new double[4];
    }

    @Override
    public final OptionalDouble average() {
        double[] dArr = (double[]) collect(new Supplier() {
            @Override
            public final Object get() {
                return DoublePipeline.lambda$average$4();
            }
        }, new ObjDoubleConsumer() {
            @Override
            public final void accept(Object obj, double d) {
                DoublePipeline.lambda$average$5((double[]) obj, d);
            }
        }, new BiConsumer() {
            @Override
            public final void accept(Object obj, Object obj2) {
                DoublePipeline.lambda$average$6((double[]) obj, (double[]) obj2);
            }

            public BiConsumer andThen(BiConsumer biConsumer) {
                return BiConsumer$CC.$default$andThen(this, biConsumer);
            }
        });
        if (dArr[2] > 0.0d) {
            return OptionalDouble.m1721of(Collectors.computeFinalSum(dArr) / dArr[2]);
        }
        return OptionalDouble.empty();
    }

    static void lambda$average$5(double[] dArr, double d) {
        dArr[2] = dArr[2] + 1.0d;
        Collectors.sumWithCompensation(dArr, d);
        dArr[3] = dArr[3] + d;
    }

    static void lambda$average$6(double[] dArr, double[] dArr2) {
        Collectors.sumWithCompensation(dArr, dArr2[0]);
        Collectors.sumWithCompensation(dArr, dArr2[1]);
        dArr[2] = dArr[2] + dArr2[2];
        dArr[3] = dArr[3] + dArr2[3];
    }

    @Override
    public final long count() {
        return ((Long) evaluate(ReduceOps.makeDoubleCounting())).longValue();
    }

    @Override
    public final DoubleSummaryStatistics summaryStatistics() {
        return (DoubleSummaryStatistics) collect(new Supplier() {
            @Override
            public final Object get() {
                return new DoubleSummaryStatistics();
            }
        }, new ObjDoubleConsumer() {
            @Override
            public final void accept(Object obj, double d) {
                ((DoubleSummaryStatistics) obj).accept(d);
            }
        }, new BiConsumer() {
            @Override
            public final void accept(Object obj, Object obj2) {
                ((DoubleSummaryStatistics) obj).combine((DoubleSummaryStatistics) obj2);
            }

            public BiConsumer andThen(BiConsumer biConsumer) {
                return BiConsumer$CC.$default$andThen(this, biConsumer);
            }
        });
    }

    @Override
    public final double reduce(double d, DoubleBinaryOperator doubleBinaryOperator) {
        return ((Double) evaluate(ReduceOps.makeDouble(d, doubleBinaryOperator))).doubleValue();
    }

    @Override
    public final OptionalDouble reduce(DoubleBinaryOperator doubleBinaryOperator) {
        return (OptionalDouble) evaluate(ReduceOps.makeDouble(doubleBinaryOperator));
    }

    @Override
    public final Object collect(Supplier supplier, ObjDoubleConsumer objDoubleConsumer, final BiConsumer biConsumer) {
        Objects.requireNonNull(biConsumer);
        return evaluate(ReduceOps.makeDouble(supplier, objDoubleConsumer, new BinaryOperator() {
            public BiFunction andThen(Function function) {
                return BiFunction$CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj, Object obj2) {
                return DoublePipeline.lambda$collect$7(biConsumer, obj, obj2);
            }
        }));
    }

    static Object lambda$collect$7(BiConsumer biConsumer, Object obj, Object obj2) {
        biConsumer.accept(obj, obj2);
        return obj;
    }

    @Override
    public final boolean anyMatch(DoublePredicate doublePredicate) {
        return ((Boolean) evaluate(MatchOps.makeDouble(doublePredicate, MatchOps.MatchKind.ANY))).booleanValue();
    }

    @Override
    public final boolean allMatch(DoublePredicate doublePredicate) {
        return ((Boolean) evaluate(MatchOps.makeDouble(doublePredicate, MatchOps.MatchKind.ALL))).booleanValue();
    }

    @Override
    public final boolean noneMatch(DoublePredicate doublePredicate) {
        return ((Boolean) evaluate(MatchOps.makeDouble(doublePredicate, MatchOps.MatchKind.NONE))).booleanValue();
    }

    @Override
    public final OptionalDouble findFirst() {
        return (OptionalDouble) evaluate(FindOps.makeDouble(true));
    }

    @Override
    public final OptionalDouble findAny() {
        return (OptionalDouble) evaluate(FindOps.makeDouble(false));
    }

    static Double[] lambda$toArray$8(int i) {
        return new Double[i];
    }

    @Override
    public final double[] toArray() {
        return (double[]) Nodes.flattenDouble((Node.OfDouble) evaluateToArrayNode(new IntFunction() {
            @Override
            public final Object apply(int i) {
                return DoublePipeline.lambda$toArray$8(i);
            }
        })).asPrimitiveArray();
    }

    static class Head extends DoublePipeline {
        @Override
        public Iterator<Double> iterator() {
            return super.iterator();
        }

        @Override
        Spliterator lazySpliterator(Supplier supplier) {
            return super.lazySpliterator(supplier);
        }

        @Override
        public DoubleStream parallel() {
            return (DoubleStream) super.parallel();
        }

        @Override
        public DoubleStream sequential() {
            return (DoubleStream) super.sequential();
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
        public void forEach(DoubleConsumer doubleConsumer) {
            if (!isParallel()) {
                DoublePipeline.adapt(sourceStageSpliterator()).forEachRemaining(doubleConsumer);
            } else {
                super.forEach(doubleConsumer);
            }
        }

        @Override
        public void forEachOrdered(DoubleConsumer doubleConsumer) {
            if (!isParallel()) {
                DoublePipeline.adapt(sourceStageSpliterator()).forEachRemaining(doubleConsumer);
            } else {
                super.forEachOrdered(doubleConsumer);
            }
        }
    }

    static abstract class StatelessOp extends DoublePipeline {
        @Override
        final boolean opIsStateful() {
            return false;
        }

        @Override
        public Iterator<Double> iterator() {
            return super.iterator();
        }

        @Override
        Spliterator lazySpliterator(Supplier supplier) {
            return super.lazySpliterator(supplier);
        }

        @Override
        public DoubleStream parallel() {
            return (DoubleStream) super.parallel();
        }

        @Override
        public DoubleStream sequential() {
            return (DoubleStream) super.sequential();
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

    static abstract class StatefulOp extends DoublePipeline {
        @Override
        final boolean opIsStateful() {
            return true;
        }

        @Override
        public Iterator<Double> iterator() {
            return super.iterator();
        }

        @Override
        Spliterator lazySpliterator(Supplier supplier) {
            return super.lazySpliterator(supplier);
        }

        @Override
        public DoubleStream parallel() {
            return (DoubleStream) super.parallel();
        }

        @Override
        public DoubleStream sequential() {
            return (DoubleStream) super.sequential();
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
