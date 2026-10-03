package p000j$.util.stream;

import java.util.function.BooleanSupplier;
import java.util.function.Consumer;
import java.util.function.IntConsumer;
import java.util.function.Supplier;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.IntConsumer$CC;

final class StreamSpliterators$IntWrappingSpliterator extends StreamSpliterators$AbstractWrappingSpliterator implements Spliterator.OfInt {
    @Override
    public void forEachRemaining(Consumer consumer) {
        Spliterator.OfInt.CC.$default$forEachRemaining((Spliterator.OfInt) this, consumer);
    }

    @Override
    public boolean tryAdvance(Consumer consumer) {
        return Spliterator.OfInt.CC.$default$tryAdvance(this, consumer);
    }

    StreamSpliterators$IntWrappingSpliterator(PipelineHelper pipelineHelper, Supplier supplier, boolean z) {
        super(pipelineHelper, supplier, z);
    }

    StreamSpliterators$IntWrappingSpliterator(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z) {
        super(pipelineHelper, spliterator, z);
    }

    @Override
    StreamSpliterators$AbstractWrappingSpliterator wrap(Spliterator spliterator) {
        return new StreamSpliterators$IntWrappingSpliterator(this.f1400ph, spliterator, this.isParallel);
    }

    @Override
    void initPartialTraversalState() {
        final SpinedBuffer.OfInt ofInt = new SpinedBuffer.OfInt();
        this.buffer = ofInt;
        PipelineHelper pipelineHelper = this.f1400ph;
        Objects.requireNonNull(ofInt);
        this.bufferSink = pipelineHelper.wrapSink(new Sink.OfInt() {
            @Override
            public void accept(double d) {
                Sink.CC.$default$accept(this, d);
            }

            @Override
            public final void accept(int i) {
                ofInt.accept(i);
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
                return this.f$0.m1737x68714704();
            }
        };
    }

    boolean m1737x68714704() {
        return this.spliterator.tryAdvance(this.bufferSink);
    }

    @Override
    public Spliterator.OfInt trySplit() {
        return (Spliterator.OfInt) super.trySplit();
    }

    @Override
    public boolean tryAdvance(IntConsumer intConsumer) {
        Objects.requireNonNull(intConsumer);
        boolean zDoAdvance = doAdvance();
        if (zDoAdvance) {
            intConsumer.accept(((SpinedBuffer.OfInt) this.buffer).get(this.nextToConsume));
        }
        return zDoAdvance;
    }

    @Override
    public void forEachRemaining(final IntConsumer intConsumer) {
        if (this.buffer == null && !this.finished) {
            Objects.requireNonNull(intConsumer);
            init();
            PipelineHelper pipelineHelper = this.f1400ph;
            Objects.requireNonNull(intConsumer);
            pipelineHelper.wrapAndCopyInto(new Sink.OfInt() {
                @Override
                public void accept(double d) {
                    Sink.CC.$default$accept(this, d);
                }

                @Override
                public final void accept(int i) {
                    intConsumer.accept(i);
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

                public IntConsumer andThen(IntConsumer intConsumer2) {
                    return IntConsumer$CC.$default$andThen(this, intConsumer2);
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
        while (tryAdvance(intConsumer)) {
        }
    }
}
