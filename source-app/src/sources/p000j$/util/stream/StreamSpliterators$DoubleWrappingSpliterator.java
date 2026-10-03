package p000j$.util.stream;

import java.util.function.BooleanSupplier;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.Supplier;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.DoubleConsumer$CC;

final class StreamSpliterators$DoubleWrappingSpliterator extends StreamSpliterators$AbstractWrappingSpliterator implements Spliterator.OfDouble {
    @Override
    public void forEachRemaining(Consumer consumer) {
        Spliterator.OfDouble.CC.$default$forEachRemaining((Spliterator.OfDouble) this, consumer);
    }

    @Override
    public boolean tryAdvance(Consumer consumer) {
        return Spliterator.OfDouble.CC.$default$tryAdvance(this, consumer);
    }

    StreamSpliterators$DoubleWrappingSpliterator(PipelineHelper pipelineHelper, Supplier supplier, boolean z) {
        super(pipelineHelper, supplier, z);
    }

    StreamSpliterators$DoubleWrappingSpliterator(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z) {
        super(pipelineHelper, spliterator, z);
    }

    @Override
    StreamSpliterators$AbstractWrappingSpliterator wrap(Spliterator spliterator) {
        return new StreamSpliterators$DoubleWrappingSpliterator(this.f1400ph, spliterator, this.isParallel);
    }

    @Override
    void initPartialTraversalState() {
        final SpinedBuffer.OfDouble ofDouble = new SpinedBuffer.OfDouble();
        this.buffer = ofDouble;
        PipelineHelper pipelineHelper = this.f1400ph;
        Objects.requireNonNull(ofDouble);
        this.bufferSink = pipelineHelper.wrapSink(new Sink.OfDouble() {
            @Override
            public final void accept(double d) {
                ofDouble.accept(d);
            }

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
        });
        this.pusher = new BooleanSupplier() {
            @Override
            public final boolean getAsBoolean() {
                return this.f$0.m1736xbf8f913e();
            }
        };
    }

    boolean m1736xbf8f913e() {
        return this.spliterator.tryAdvance(this.bufferSink);
    }

    @Override
    public Spliterator.OfDouble trySplit() {
        return (Spliterator.OfDouble) super.trySplit();
    }

    @Override
    public boolean tryAdvance(DoubleConsumer doubleConsumer) {
        Objects.requireNonNull(doubleConsumer);
        boolean zDoAdvance = doAdvance();
        if (zDoAdvance) {
            doubleConsumer.accept(((SpinedBuffer.OfDouble) this.buffer).get(this.nextToConsume));
        }
        return zDoAdvance;
    }

    @Override
    public void forEachRemaining(final DoubleConsumer doubleConsumer) {
        if (this.buffer == null && !this.finished) {
            Objects.requireNonNull(doubleConsumer);
            init();
            PipelineHelper pipelineHelper = this.f1400ph;
            Objects.requireNonNull(doubleConsumer);
            pipelineHelper.wrapAndCopyInto(new Sink.OfDouble() {
                @Override
                public final void accept(double d) {
                    doubleConsumer.accept(d);
                }

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

                public DoubleConsumer andThen(DoubleConsumer doubleConsumer2) {
                    return DoubleConsumer$CC.$default$andThen(this, doubleConsumer2);
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
            }, this.spliterator);
            this.finished = true;
            return;
        }
        while (tryAdvance(doubleConsumer)) {
        }
    }
}
