package p000j$.util.stream;

import java.util.concurrent.CountedCompleter;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.IntConsumer;
import java.util.function.LongConsumer;
import java.util.function.Predicate;
import java.util.function.Supplier;
import p000j$.util.Optional;
import p000j$.util.OptionalDouble;
import p000j$.util.OptionalInt;
import p000j$.util.OptionalLong;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;
import p000j$.util.function.IntConsumer$CC;
import p000j$.util.function.LongConsumer$CC;
import p000j$.util.function.Predicate$CC;

abstract class FindOps {
    public static TerminalOp makeRef(boolean z) {
        return z ? FindSink.OfRef.OP_FIND_FIRST : FindSink.OfRef.OP_FIND_ANY;
    }

    public static TerminalOp makeInt(boolean z) {
        return z ? FindSink.OfInt.OP_FIND_FIRST : FindSink.OfInt.OP_FIND_ANY;
    }

    public static TerminalOp makeLong(boolean z) {
        return z ? FindSink.OfLong.OP_FIND_FIRST : FindSink.OfLong.OP_FIND_ANY;
    }

    public static TerminalOp makeDouble(boolean z) {
        return z ? FindSink.OfDouble.OP_FIND_FIRST : FindSink.OfDouble.OP_FIND_ANY;
    }

    private static final class FindOp implements TerminalOp {
        final Object emptyValue;
        final int opFlags;
        final Predicate presentPredicate;
        private final StreamShape shape;
        final Supplier sinkSupplier;

        FindOp(boolean z, StreamShape streamShape, Object obj, Predicate predicate, Supplier supplier) {
            this.opFlags = (z ? 0 : StreamOpFlag.NOT_ORDERED) | StreamOpFlag.IS_SHORT_CIRCUIT;
            this.shape = streamShape;
            this.emptyValue = obj;
            this.presentPredicate = predicate;
            this.sinkSupplier = supplier;
        }

        @Override
        public int getOpFlags() {
            return this.opFlags;
        }

        @Override
        public Object evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
            Object obj = ((TerminalSink) pipelineHelper.wrapAndCopyInto((TerminalSink) this.sinkSupplier.get(), spliterator)).get();
            return obj != null ? obj : this.emptyValue;
        }

        @Override
        public Object evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
            return new FindTask(this, StreamOpFlag.ORDERED.isKnown(pipelineHelper.getStreamAndOpFlags()), pipelineHelper, spliterator).invoke();
        }
    }

    static abstract class FindSink implements TerminalSink {
        boolean hasValue;
        Object value;

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
        public void end() {
            Sink.CC.$default$end(this);
        }

        FindSink() {
        }

        @Override
        public void accept(Object obj) {
            if (this.hasValue) {
                return;
            }
            this.hasValue = true;
            this.value = obj;
        }

        @Override
        public boolean cancellationRequested() {
            return this.hasValue;
        }

        static final class OfRef extends FindSink {
            static final TerminalOp OP_FIND_ANY;
            static final TerminalOp OP_FIND_FIRST;

            OfRef() {
            }

            @Override
            public Optional get() {
                if (this.hasValue) {
                    return Optional.m1720of(this.value);
                }
                return null;
            }

            static {
                StreamShape streamShape = StreamShape.REFERENCE;
                OP_FIND_FIRST = new FindOp(true, streamShape, Optional.empty(), new Predicate() {
                    public Predicate and(Predicate predicate) {
                        return Predicate$CC.$default$and(this, predicate);
                    }

                    public Predicate negate() {
                        return Predicate$CC.$default$negate(this);
                    }

                    public Predicate m1734or(Predicate predicate) {
                        return Predicate$CC.$default$or(this, predicate);
                    }

                    @Override
                    public final boolean test(Object obj) {
                        return ((Optional) obj).isPresent();
                    }
                }, new Supplier() {
                    @Override
                    public final Object get() {
                        return new FindOps.FindSink.OfRef();
                    }
                });
                OP_FIND_ANY = new FindOp(false, streamShape, Optional.empty(), new Predicate() {
                    public Predicate and(Predicate predicate) {
                        return Predicate$CC.$default$and(this, predicate);
                    }

                    public Predicate negate() {
                        return Predicate$CC.$default$negate(this);
                    }

                    public Predicate m1734or(Predicate predicate) {
                        return Predicate$CC.$default$or(this, predicate);
                    }

                    @Override
                    public final boolean test(Object obj) {
                        return ((Optional) obj).isPresent();
                    }
                }, new Supplier() {
                    @Override
                    public final Object get() {
                        return new FindOps.FindSink.OfRef();
                    }
                });
            }
        }

        static final class OfInt extends FindSink implements Sink.OfInt {
            static final TerminalOp OP_FIND_ANY;
            static final TerminalOp OP_FIND_FIRST;

            public IntConsumer andThen(IntConsumer intConsumer) {
                return IntConsumer$CC.$default$andThen(this, intConsumer);
            }

            OfInt() {
            }

            @Override
            public void accept(Integer num) {
                super.accept((Object) num);
            }

            @Override
            public void accept(int i) {
                accept((Object) Integer.valueOf(i));
            }

            @Override
            public OptionalInt get() {
                if (this.hasValue) {
                    return OptionalInt.m1723of(((Integer) this.value).intValue());
                }
                return null;
            }

            static {
                StreamShape streamShape = StreamShape.INT_VALUE;
                OP_FIND_FIRST = new FindOp(true, streamShape, OptionalInt.empty(), new Predicate() {
                    public Predicate and(Predicate predicate) {
                        return Predicate$CC.$default$and(this, predicate);
                    }

                    public Predicate negate() {
                        return Predicate$CC.$default$negate(this);
                    }

                    public Predicate m1732or(Predicate predicate) {
                        return Predicate$CC.$default$or(this, predicate);
                    }

                    @Override
                    public final boolean test(Object obj) {
                        return ((OptionalInt) obj).isPresent();
                    }
                }, new Supplier() {
                    @Override
                    public final Object get() {
                        return new FindOps.FindSink.OfInt();
                    }
                });
                OP_FIND_ANY = new FindOp(false, streamShape, OptionalInt.empty(), new Predicate() {
                    public Predicate and(Predicate predicate) {
                        return Predicate$CC.$default$and(this, predicate);
                    }

                    public Predicate negate() {
                        return Predicate$CC.$default$negate(this);
                    }

                    public Predicate m1732or(Predicate predicate) {
                        return Predicate$CC.$default$or(this, predicate);
                    }

                    @Override
                    public final boolean test(Object obj) {
                        return ((OptionalInt) obj).isPresent();
                    }
                }, new Supplier() {
                    @Override
                    public final Object get() {
                        return new FindOps.FindSink.OfInt();
                    }
                });
            }
        }

        static final class OfLong extends FindSink implements Sink.OfLong {
            static final TerminalOp OP_FIND_ANY;
            static final TerminalOp OP_FIND_FIRST;

            public LongConsumer andThen(LongConsumer longConsumer) {
                return LongConsumer$CC.$default$andThen(this, longConsumer);
            }

            OfLong() {
            }

            @Override
            public void accept(Long l) {
                super.accept((Object) l);
            }

            @Override
            public void accept(long j) {
                accept((Object) Long.valueOf(j));
            }

            @Override
            public OptionalLong get() {
                if (this.hasValue) {
                    return OptionalLong.m1724of(((Long) this.value).longValue());
                }
                return null;
            }

            static {
                StreamShape streamShape = StreamShape.LONG_VALUE;
                OP_FIND_FIRST = new FindOp(true, streamShape, OptionalLong.empty(), new Predicate() {
                    public Predicate and(Predicate predicate) {
                        return Predicate$CC.$default$and(this, predicate);
                    }

                    public Predicate negate() {
                        return Predicate$CC.$default$negate(this);
                    }

                    public Predicate m1733or(Predicate predicate) {
                        return Predicate$CC.$default$or(this, predicate);
                    }

                    @Override
                    public final boolean test(Object obj) {
                        return ((OptionalLong) obj).isPresent();
                    }
                }, new Supplier() {
                    @Override
                    public final Object get() {
                        return new FindOps.FindSink.OfLong();
                    }
                });
                OP_FIND_ANY = new FindOp(false, streamShape, OptionalLong.empty(), new Predicate() {
                    public Predicate and(Predicate predicate) {
                        return Predicate$CC.$default$and(this, predicate);
                    }

                    public Predicate negate() {
                        return Predicate$CC.$default$negate(this);
                    }

                    public Predicate m1733or(Predicate predicate) {
                        return Predicate$CC.$default$or(this, predicate);
                    }

                    @Override
                    public final boolean test(Object obj) {
                        return ((OptionalLong) obj).isPresent();
                    }
                }, new Supplier() {
                    @Override
                    public final Object get() {
                        return new FindOps.FindSink.OfLong();
                    }
                });
            }
        }

        static final class OfDouble extends FindSink implements Sink.OfDouble {
            static final TerminalOp OP_FIND_ANY;
            static final TerminalOp OP_FIND_FIRST;

            public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
                return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
            }

            OfDouble() {
            }

            @Override
            public void accept(Double d) {
                super.accept((Object) d);
            }

            @Override
            public void accept(double d) {
                accept((Object) Double.valueOf(d));
            }

            @Override
            public OptionalDouble get() {
                if (this.hasValue) {
                    return OptionalDouble.m1721of(((Double) this.value).doubleValue());
                }
                return null;
            }

            static {
                StreamShape streamShape = StreamShape.DOUBLE_VALUE;
                OP_FIND_FIRST = new FindOp(true, streamShape, OptionalDouble.empty(), new Predicate() {
                    public Predicate and(Predicate predicate) {
                        return Predicate$CC.$default$and(this, predicate);
                    }

                    public Predicate negate() {
                        return Predicate$CC.$default$negate(this);
                    }

                    public Predicate m1731or(Predicate predicate) {
                        return Predicate$CC.$default$or(this, predicate);
                    }

                    @Override
                    public final boolean test(Object obj) {
                        return ((OptionalDouble) obj).isPresent();
                    }
                }, new Supplier() {
                    @Override
                    public final Object get() {
                        return new FindOps.FindSink.OfDouble();
                    }
                });
                OP_FIND_ANY = new FindOp(false, streamShape, OptionalDouble.empty(), new Predicate() {
                    public Predicate and(Predicate predicate) {
                        return Predicate$CC.$default$and(this, predicate);
                    }

                    public Predicate negate() {
                        return Predicate$CC.$default$negate(this);
                    }

                    public Predicate m1731or(Predicate predicate) {
                        return Predicate$CC.$default$or(this, predicate);
                    }

                    @Override
                    public final boolean test(Object obj) {
                        return ((OptionalDouble) obj).isPresent();
                    }
                }, new Supplier() {
                    @Override
                    public final Object get() {
                        return new FindOps.FindSink.OfDouble();
                    }
                });
            }
        }
    }

    private static final class FindTask extends AbstractShortCircuitTask {
        private final boolean mustFindFirst;

        private final FindOp f1383op;

        FindTask(FindOp findOp, boolean z, PipelineHelper pipelineHelper, Spliterator spliterator) {
            super(pipelineHelper, spliterator);
            this.mustFindFirst = z;
            this.f1383op = findOp;
        }

        FindTask(FindTask findTask, Spliterator spliterator) {
            super(findTask, spliterator);
            this.mustFindFirst = findTask.mustFindFirst;
            this.f1383op = findTask.f1383op;
        }

        @Override
        public FindTask makeChild(Spliterator spliterator) {
            return new FindTask(this, spliterator);
        }

        @Override
        protected Object getEmptyResult() {
            return this.f1383op.emptyValue;
        }

        private void foundResult(Object obj) {
            if (isLeftmostNode()) {
                shortCircuit(obj);
            } else {
                cancelLaterNodes();
            }
        }

        @Override
        protected Object doLeaf() {
            Object obj = ((TerminalSink) this.helper.wrapAndCopyInto((TerminalSink) this.f1383op.sinkSupplier.get(), this.spliterator)).get();
            if (!this.mustFindFirst) {
                if (obj != null) {
                    shortCircuit(obj);
                }
                return null;
            }
            if (obj == null) {
                return null;
            }
            foundResult(obj);
            return obj;
        }

        @Override
        public void onCompletion(CountedCompleter countedCompleter) {
            if (this.mustFindFirst) {
                FindTask findTask = (FindTask) this.leftChild;
                FindTask findTask2 = null;
                while (findTask != findTask2) {
                    Object localResult = findTask.getLocalResult();
                    if (localResult == null || !this.f1383op.presentPredicate.test(localResult)) {
                        findTask2 = findTask;
                        findTask = (FindTask) this.rightChild;
                    } else {
                        setLocalResult(localResult);
                        foundResult(localResult);
                        break;
                    }
                }
            }
            super.onCompletion(countedCompleter);
        }
    }
}
