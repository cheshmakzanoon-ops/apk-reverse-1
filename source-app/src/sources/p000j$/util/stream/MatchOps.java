package p000j$.util.stream;

import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.DoublePredicate;
import java.util.function.IntConsumer;
import java.util.function.IntPredicate;
import java.util.function.LongConsumer;
import java.util.function.LongPredicate;
import java.util.function.Predicate;
import java.util.function.Supplier;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;
import p000j$.util.function.IntConsumer$CC;
import p000j$.util.function.LongConsumer$CC;

abstract class MatchOps {

    enum MatchKind {
        ANY(true, true),
        ALL(false, false),
        NONE(true, false);

        private final boolean shortCircuitResult;
        private final boolean stopOnPredicateMatches;

        MatchKind(boolean z, boolean z2) {
            this.stopOnPredicateMatches = z;
            this.shortCircuitResult = z2;
        }
    }

    public static TerminalOp makeRef(final Predicate predicate, final MatchKind matchKind) {
        Objects.requireNonNull(predicate);
        Objects.requireNonNull(matchKind);
        return new MatchOp(StreamShape.REFERENCE, matchKind, new Supplier() {
            @Override
            public final Object get() {
                return MatchOps.lambda$makeRef$0(matchKind, predicate);
            }
        });
    }

    static BooleanTerminalSink lambda$makeRef$0(MatchKind matchKind, Predicate predicate) {
        return new BooleanTerminalSink(predicate) {
            final Predicate val$predicate;

            {
                super(this.val$matchKind);
                this.val$predicate = predicate;
            }

            @Override
            public void accept(Object obj) {
                if (this.stop || this.val$predicate.test(obj) != this.val$matchKind.stopOnPredicateMatches) {
                    return;
                }
                this.stop = true;
                this.value = this.val$matchKind.shortCircuitResult;
            }
        };
    }

    public static TerminalOp makeInt(final IntPredicate intPredicate, final MatchKind matchKind) {
        Objects.requireNonNull(intPredicate);
        Objects.requireNonNull(matchKind);
        return new MatchOp(StreamShape.INT_VALUE, matchKind, new Supplier(intPredicate) {
            @Override
            public final Object get() {
                return MatchOps.lambda$makeInt$1(this.f$0, null);
            }
        });
    }

    class C2MatchSink extends BooleanTerminalSink implements Sink.OfInt {
        final MatchKind val$matchKind;

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

        C2MatchSink(MatchKind matchKind, IntPredicate intPredicate) {
            super(matchKind);
            this.val$matchKind = matchKind;
        }

        @Override
        public void accept(int i) {
            if (this.stop) {
                return;
            }
            IntPredicate intPredicate = null;
            intPredicate.test(i);
            throw null;
        }
    }

    static BooleanTerminalSink lambda$makeInt$1(MatchKind matchKind, IntPredicate intPredicate) {
        return new C2MatchSink(matchKind, intPredicate);
    }

    public static TerminalOp makeLong(final LongPredicate longPredicate, final MatchKind matchKind) {
        Objects.requireNonNull(longPredicate);
        Objects.requireNonNull(matchKind);
        return new MatchOp(StreamShape.LONG_VALUE, matchKind, new Supplier(longPredicate) {
            @Override
            public final Object get() {
                return MatchOps.lambda$makeLong$2(this.f$0, null);
            }
        });
    }

    class C3MatchSink extends BooleanTerminalSink implements Sink.OfLong {
        final MatchKind val$matchKind;

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

        C3MatchSink(MatchKind matchKind, LongPredicate longPredicate) {
            super(matchKind);
            this.val$matchKind = matchKind;
        }

        @Override
        public void accept(long j) {
            if (this.stop) {
                return;
            }
            LongPredicate longPredicate = null;
            longPredicate.test(j);
            throw null;
        }
    }

    static BooleanTerminalSink lambda$makeLong$2(MatchKind matchKind, LongPredicate longPredicate) {
        return new C3MatchSink(matchKind, longPredicate);
    }

    public static TerminalOp makeDouble(final DoublePredicate doublePredicate, final MatchKind matchKind) {
        Objects.requireNonNull(doublePredicate);
        Objects.requireNonNull(matchKind);
        return new MatchOp(StreamShape.DOUBLE_VALUE, matchKind, new Supplier(doublePredicate) {
            @Override
            public final Object get() {
                return MatchOps.lambda$makeDouble$3(this.f$0, null);
            }
        });
    }

    class C4MatchSink extends BooleanTerminalSink implements Sink.OfDouble {
        final MatchKind val$matchKind;

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

        C4MatchSink(MatchKind matchKind, DoublePredicate doublePredicate) {
            super(matchKind);
            this.val$matchKind = matchKind;
        }

        @Override
        public void accept(double d) {
            if (this.stop) {
                return;
            }
            DoublePredicate doublePredicate = null;
            doublePredicate.test(d);
            throw null;
        }
    }

    static BooleanTerminalSink lambda$makeDouble$3(MatchKind matchKind, DoublePredicate doublePredicate) {
        return new C4MatchSink(matchKind, doublePredicate);
    }

    private static final class MatchOp implements TerminalOp {
        private final StreamShape inputShape;
        final MatchKind matchKind;
        final Supplier sinkSupplier;

        MatchOp(StreamShape streamShape, MatchKind matchKind, Supplier supplier) {
            this.inputShape = streamShape;
            this.matchKind = matchKind;
            this.sinkSupplier = supplier;
        }

        @Override
        public int getOpFlags() {
            return StreamOpFlag.IS_SHORT_CIRCUIT | StreamOpFlag.NOT_ORDERED;
        }

        @Override
        public Boolean evaluateSequential(PipelineHelper pipelineHelper, Spliterator spliterator) {
            return Boolean.valueOf(((BooleanTerminalSink) pipelineHelper.wrapAndCopyInto((BooleanTerminalSink) this.sinkSupplier.get(), spliterator)).getAndClearState());
        }

        @Override
        public Boolean evaluateParallel(PipelineHelper pipelineHelper, Spliterator spliterator) {
            return (Boolean) new MatchTask(this, pipelineHelper, spliterator).invoke();
        }
    }

    static abstract class BooleanTerminalSink implements Sink {
        boolean stop;
        boolean value;

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

        BooleanTerminalSink(MatchKind matchKind) {
            this.value = !matchKind.shortCircuitResult;
        }

        public boolean getAndClearState() {
            return this.value;
        }

        @Override
        public boolean cancellationRequested() {
            return this.stop;
        }
    }

    private static final class MatchTask extends AbstractShortCircuitTask {

        private final MatchOp f1384op;

        MatchTask(MatchOp matchOp, PipelineHelper pipelineHelper, Spliterator spliterator) {
            super(pipelineHelper, spliterator);
            this.f1384op = matchOp;
        }

        MatchTask(MatchTask matchTask, Spliterator spliterator) {
            super(matchTask, spliterator);
            this.f1384op = matchTask.f1384op;
        }

        @Override
        public MatchTask makeChild(Spliterator spliterator) {
            return new MatchTask(this, spliterator);
        }

        @Override
        public Boolean doLeaf() {
            boolean andClearState = ((BooleanTerminalSink) this.helper.wrapAndCopyInto((BooleanTerminalSink) this.f1384op.sinkSupplier.get(), this.spliterator)).getAndClearState();
            if (andClearState != this.f1384op.matchKind.shortCircuitResult) {
                return null;
            }
            shortCircuit(Boolean.valueOf(andClearState));
            return null;
        }

        @Override
        public Boolean getEmptyResult() {
            return Boolean.valueOf(!this.f1384op.matchKind.shortCircuitResult);
        }
    }
}
