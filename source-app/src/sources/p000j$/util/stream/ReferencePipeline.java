package p000j$.util.stream;

import java.util.Comparator;
import java.util.Iterator;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.Function;
import java.util.function.IntConsumer;
import java.util.function.IntFunction;
import java.util.function.LongConsumer;
import java.util.function.Predicate;
import java.util.function.Supplier;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;
import p000j$.util.Objects;
import p000j$.util.Optional;
import p000j$.util.Spliterator;
import p000j$.util.Spliterators;
import p000j$.util.function.BinaryOperator$CC;
import p000j$.util.function.Consumer$CC;

abstract class ReferencePipeline extends AbstractPipeline implements Stream {
    ReferencePipeline(Supplier supplier, int i, boolean z) {
        super(supplier, i, z);
    }

    ReferencePipeline(Spliterator spliterator, int i, boolean z) {
        super(spliterator, i, z);
    }

    ReferencePipeline(AbstractPipeline abstractPipeline, int i) {
        super(abstractPipeline, i);
    }

    @Override
    final StreamShape getOutputShape() {
        return StreamShape.REFERENCE;
    }

    @Override
    final Node evaluateToNode(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z, IntFunction intFunction) {
        return Nodes.collect(pipelineHelper, spliterator, z, intFunction);
    }

    @Override
    final Spliterator wrap(PipelineHelper pipelineHelper, Supplier supplier, boolean z) {
        return new StreamSpliterators$WrappingSpliterator(pipelineHelper, supplier, z);
    }

    @Override
    final Spliterator lazySpliterator(Supplier supplier) {
        return new StreamSpliterators$DelegatingSpliterator(supplier);
    }

    @Override
    final boolean forEachWithCancel(Spliterator spliterator, Sink sink) {
        boolean zCancellationRequested;
        do {
            zCancellationRequested = sink.cancellationRequested();
            if (zCancellationRequested) {
                break;
            }
        } while (spliterator.tryAdvance(sink));
        return zCancellationRequested;
    }

    @Override
    final Node.Builder makeNodeBuilder(long j, IntFunction intFunction) {
        return Nodes.builder(j, intFunction);
    }

    @Override
    public final Iterator iterator() {
        return Spliterators.iterator(spliterator());
    }

    @Override
    public Stream unordered() {
        return !isOrdered() ? this : new StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_ORDERED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return sink;
            }
        };
    }

    @Override
    public final Stream filter(final Predicate predicate) {
        Objects.requireNonNull(predicate);
        return new StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SIZED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    @Override
                    public void begin(long j) {
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void accept(Object obj) {
                        if (predicate.test(obj)) {
                            this.downstream.accept(obj);
                        }
                    }
                };
            }
        };
    }

    @Override
    public final Stream map(final Function function) {
        Objects.requireNonNull(function);
        return new StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    @Override
                    public void accept(Object obj) {
                        this.downstream.accept(function.apply(obj));
                    }
                };
            }
        };
    }

    @Override
    public final IntStream mapToInt(final ToIntFunction toIntFunction) {
        Objects.requireNonNull(toIntFunction);
        return new IntPipeline.StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    @Override
                    public void accept(Object obj) {
                        this.downstream.accept(toIntFunction.applyAsInt(obj));
                    }
                };
            }
        };
    }

    @Override
    public final LongStream mapToLong(final ToLongFunction toLongFunction) {
        Objects.requireNonNull(toLongFunction);
        return new LongPipeline.StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    @Override
                    public void accept(Object obj) {
                        this.downstream.accept(toLongFunction.applyAsLong(obj));
                    }
                };
            }
        };
    }

    @Override
    public final DoubleStream mapToDouble(final ToDoubleFunction toDoubleFunction) {
        Objects.requireNonNull(toDoubleFunction);
        return new DoublePipeline.StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    @Override
                    public void accept(Object obj) {
                        this.downstream.accept(toDoubleFunction.applyAsDouble(obj));
                    }
                };
            }
        };
    }

    @Override
    public final Stream flatMap(final Function function) {
        Objects.requireNonNull(function);
        return new StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT | StreamOpFlag.NOT_SIZED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    boolean cancellationRequestedCalled;

                    @Override
                    public void begin(long j) {
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void accept(Object obj) {
                        Stream stream = (Stream) function.apply(obj);
                        if (stream != null) {
                            try {
                                if (!this.cancellationRequestedCalled) {
                                    ((Stream) stream.sequential()).forEach(this.downstream);
                                } else {
                                    Spliterator spliterator = ((Stream) stream.sequential()).spliterator();
                                    while (!this.downstream.cancellationRequested() && spliterator.tryAdvance(this.downstream)) {
                                    }
                                }
                            } catch (Throwable th) {
                                try {
                                    stream.close();
                                } catch (Throwable th2) {
                                    th.addSuppressed(th2);
                                }
                                throw th;
                            }
                        }
                        if (stream != null) {
                            stream.close();
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
    public final IntStream flatMapToInt(final Function function) {
        Objects.requireNonNull(function);
        return new IntPipeline.StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT | StreamOpFlag.NOT_SIZED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    boolean cancellationRequestedCalled;
                    IntConsumer downstreamAsInt;

                    {
                        Sink sink2 = this.downstream;
                        Objects.requireNonNull(sink2);
                        this.downstreamAsInt = new IntPipeline$$ExternalSyntheticLambda10(sink2);
                    }

                    @Override
                    public void begin(long j) {
                        this.downstream.begin(-1L);
                    }

                    @Override
                    public void accept(Object obj) {
                        IntStream intStream = (IntStream) function.apply(obj);
                        if (intStream != null) {
                            try {
                                if (!this.cancellationRequestedCalled) {
                                    intStream.sequential().forEach(this.downstreamAsInt);
                                } else {
                                    Spliterator.OfInt ofIntSpliterator = intStream.sequential().spliterator();
                                    while (!this.downstream.cancellationRequested() && ofIntSpliterator.tryAdvance(this.downstreamAsInt)) {
                                    }
                                }
                            } catch (Throwable th) {
                                try {
                                    intStream.close();
                                } catch (Throwable th2) {
                                    th.addSuppressed(th2);
                                }
                                throw th;
                            }
                        }
                        if (intStream != null) {
                            intStream.close();
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
    public final DoubleStream flatMapToDouble(final Function function) {
        Objects.requireNonNull(function);
        return new DoublePipeline.StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT | StreamOpFlag.NOT_SIZED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
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
                    public void accept(Object obj) {
                        DoubleStream doubleStream = (DoubleStream) function.apply(obj);
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
    public final LongStream flatMapToLong(final Function function) {
        Objects.requireNonNull(function);
        return new LongPipeline.StatelessOp(this, StreamShape.REFERENCE, StreamOpFlag.NOT_SORTED | StreamOpFlag.NOT_DISTINCT | StreamOpFlag.NOT_SIZED) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
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
                    public void accept(Object obj) {
                        LongStream longStream = (LongStream) function.apply(obj);
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
    public final Stream peek(final Consumer consumer) {
        Objects.requireNonNull(consumer);
        return new StatelessOp(this, StreamShape.REFERENCE, 0) {
            @Override
            Sink opWrapSink(int i, Sink sink) {
                return new Sink.ChainedReference(sink) {
                    @Override
                    public void accept(Object obj) {
                        consumer.accept(obj);
                        this.downstream.accept(obj);
                    }
                };
            }
        };
    }

    @Override
    public final Stream distinct() {
        return DistinctOps.makeRef(this);
    }

    @Override
    public final Stream sorted() {
        return SortedOps.makeRef(this);
    }

    @Override
    public final Stream sorted(Comparator comparator) {
        return SortedOps.makeRef(this, comparator);
    }

    @Override
    public final Stream limit(long j) {
        if (j < 0) {
            throw new IllegalArgumentException(Long.toString(j));
        }
        return SliceOps.makeRef(this, 0L, j);
    }

    @Override
    public final Stream skip(long j) {
        if (j >= 0) {
            return j == 0 ? this : SliceOps.makeRef(this, j, -1L);
        }
        throw new IllegalArgumentException(Long.toString(j));
    }

    @Override
    public final Stream takeWhile(Predicate predicate) {
        return WhileOps.makeTakeWhileRef(this, predicate);
    }

    @Override
    public final Stream dropWhile(Predicate predicate) {
        return WhileOps.makeDropWhileRef(this, predicate);
    }

    @Override
    public void forEach(Consumer consumer) {
        evaluate(ForEachOps.makeRef(consumer, false));
    }

    @Override
    public void forEachOrdered(Consumer consumer) {
        evaluate(ForEachOps.makeRef(consumer, true));
    }

    @Override
    public final Object[] toArray(IntFunction intFunction) {
        return Nodes.flatten(evaluateToArrayNode(intFunction), intFunction).asArray(intFunction);
    }

    static Object[] lambda$toArray$0(int i) {
        return new Object[i];
    }

    @Override
    public final Object[] toArray() {
        return toArray(new IntFunction() {
            @Override
            public final Object apply(int i) {
                return ReferencePipeline.lambda$toArray$0(i);
            }
        });
    }

    @Override
    public final boolean anyMatch(Predicate predicate) {
        return ((Boolean) evaluate(MatchOps.makeRef(predicate, MatchOps.MatchKind.ANY))).booleanValue();
    }

    @Override
    public final boolean allMatch(Predicate predicate) {
        return ((Boolean) evaluate(MatchOps.makeRef(predicate, MatchOps.MatchKind.ALL))).booleanValue();
    }

    @Override
    public final boolean noneMatch(Predicate predicate) {
        return ((Boolean) evaluate(MatchOps.makeRef(predicate, MatchOps.MatchKind.NONE))).booleanValue();
    }

    @Override
    public final Optional findFirst() {
        return (Optional) evaluate(FindOps.makeRef(true));
    }

    @Override
    public final Optional findAny() {
        return (Optional) evaluate(FindOps.makeRef(false));
    }

    @Override
    public final Object reduce(Object obj, BinaryOperator binaryOperator) {
        return evaluate(ReduceOps.makeRef(obj, binaryOperator, binaryOperator));
    }

    @Override
    public final Optional reduce(BinaryOperator binaryOperator) {
        return (Optional) evaluate(ReduceOps.makeRef(binaryOperator));
    }

    @Override
    public final Object reduce(Object obj, BiFunction biFunction, BinaryOperator binaryOperator) {
        return evaluate(ReduceOps.makeRef(obj, biFunction, binaryOperator));
    }

    @Override
    public final Object collect(Collector collector) {
        final Object objEvaluate;
        if (isParallel() && collector.characteristics().contains(Collector.Characteristics.CONCURRENT) && (!isOrdered() || collector.characteristics().contains(Collector.Characteristics.UNORDERED))) {
            objEvaluate = collector.supplier().get();
            final BiConsumer biConsumerAccumulator = collector.accumulator();
            forEach(new Consumer() {
                @Override
                public final void accept(Object obj) {
                    biConsumerAccumulator.accept(objEvaluate, obj);
                }

                public Consumer andThen(Consumer consumer) {
                    return Consumer$CC.$default$andThen(this, consumer);
                }
            });
        } else {
            objEvaluate = evaluate(ReduceOps.makeRef(collector));
        }
        return collector.characteristics().contains(Collector.Characteristics.IDENTITY_FINISH) ? objEvaluate : collector.finisher().apply(objEvaluate);
    }

    @Override
    public final Object collect(Supplier supplier, BiConsumer biConsumer, BiConsumer biConsumer2) {
        return evaluate(ReduceOps.makeRef(supplier, biConsumer, biConsumer2));
    }

    @Override
    public final Optional max(Comparator comparator) {
        return reduce(BinaryOperator$CC.maxBy(comparator));
    }

    @Override
    public final Optional min(Comparator comparator) {
        return reduce(BinaryOperator$CC.minBy(comparator));
    }

    @Override
    public final long count() {
        return ((Long) evaluate(ReduceOps.makeRefCounting())).longValue();
    }

    static class Head extends ReferencePipeline {
        @Override
        public BaseStream unordered() {
            return super.unordered();
        }

        Head(Supplier supplier, int i, boolean z) {
            super(supplier, i, z);
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
        public void forEach(Consumer consumer) {
            if (!isParallel()) {
                sourceStageSpliterator().forEachRemaining(consumer);
            } else {
                super.forEach(consumer);
            }
        }

        @Override
        public void forEachOrdered(Consumer consumer) {
            if (!isParallel()) {
                sourceStageSpliterator().forEachRemaining(consumer);
            } else {
                super.forEachOrdered(consumer);
            }
        }
    }

    static abstract class StatelessOp extends ReferencePipeline {
        @Override
        final boolean opIsStateful() {
            return false;
        }

        @Override
        public BaseStream unordered() {
            return super.unordered();
        }

        StatelessOp(AbstractPipeline abstractPipeline, StreamShape streamShape, int i) {
            super(abstractPipeline, i);
        }
    }

    static abstract class StatefulOp extends ReferencePipeline {
        @Override
        final boolean opIsStateful() {
            return true;
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
