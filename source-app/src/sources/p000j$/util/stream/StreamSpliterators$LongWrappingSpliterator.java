package p000j$.util.stream;

import java.util.function.BooleanSupplier;
import java.util.function.Consumer;
import java.util.function.LongConsumer;
import java.util.function.Supplier;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;
import p000j$.util.function.LongConsumer$CC;

final class StreamSpliterators$LongWrappingSpliterator extends StreamSpliterators$AbstractWrappingSpliterator implements Spliterator.OfLong {
    @Override
    public void forEachRemaining(Consumer consumer) {
        Spliterator.OfLong.CC.$default$forEachRemaining((Spliterator.OfLong) this, consumer);
    }

    @Override
    public boolean tryAdvance(Consumer consumer) {
        return Spliterator.OfLong.CC.$default$tryAdvance(this, consumer);
    }

    StreamSpliterators$LongWrappingSpliterator(PipelineHelper pipelineHelper, Supplier supplier, boolean z) {
        super(pipelineHelper, supplier, z);
    }

    StreamSpliterators$LongWrappingSpliterator(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z) {
        super(pipelineHelper, spliterator, z);
    }

    @Override
    StreamSpliterators$AbstractWrappingSpliterator wrap(Spliterator spliterator) {
        return new StreamSpliterators$LongWrappingSpliterator(this.f1400ph, spliterator, this.isParallel);
    }

    @Override
    void initPartialTraversalState() {
        final SpinedBuffer.OfLong ofLong = new SpinedBuffer.OfLong();
        this.buffer = ofLong;
        PipelineHelper pipelineHelper = this.f1400ph;
        Objects.requireNonNull(ofLong);
        this.bufferSink = pipelineHelper.wrapSink(new Sink.OfLong() {
            @Override
            public void accept(double d) {
                Sink.CC.$default$accept(this, d);
            }

            @Override
            public void accept(int i) {
                Sink.CC.$default$accept((Sink) this, i);
            }

            @Override
            public final void accept(long j) {
                ofLong.accept(j);
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
                return this.f$0.m1738x44d1e433();
            }
        };
    }

    boolean m1738x44d1e433() {
        return this.spliterator.tryAdvance(this.bufferSink);
    }

    @Override
    public Spliterator.OfLong trySplit() {
        return (Spliterator.OfLong) super.trySplit();
    }

    @Override
    public boolean tryAdvance(LongConsumer longConsumer) {
        Objects.requireNonNull(longConsumer);
        boolean zDoAdvance = doAdvance();
        if (zDoAdvance) {
            longConsumer.accept(((SpinedBuffer.OfLong) this.buffer).get(this.nextToConsume));
        }
        return zDoAdvance;
    }

    @Override
    public void forEachRemaining(final LongConsumer longConsumer) {
        if (this.buffer == null && !this.finished) {
            Objects.requireNonNull(longConsumer);
            init();
            PipelineHelper pipelineHelper = this.f1400ph;
            Objects.requireNonNull(longConsumer);
            pipelineHelper.wrapAndCopyInto(new Sink.OfLong() {
                @Override
                public void accept(double d) {
                    Sink.CC.$default$accept(this, d);
                }

                @Override
                public void accept(int i) {
                    Sink.CC.$default$accept((Sink) this, i);
                }

                @Override
                public final void accept(long j) {
                    longConsumer.accept(j);
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

                public LongConsumer andThen(LongConsumer longConsumer2) {
                    return LongConsumer$CC.$default$andThen(this, longConsumer2);
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
        while (tryAdvance(longConsumer)) {
        }
    }
}
