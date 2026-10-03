package p000j$.util.stream;

import java.util.function.BooleanSupplier;
import java.util.function.Consumer;
import java.util.function.Supplier;
import p000j$.util.Objects;
import p000j$.util.Spliterator;
import p000j$.util.function.Consumer$CC;

final class StreamSpliterators$WrappingSpliterator extends StreamSpliterators$AbstractWrappingSpliterator {
    StreamSpliterators$WrappingSpliterator(PipelineHelper pipelineHelper, Supplier supplier, boolean z) {
        super(pipelineHelper, supplier, z);
    }

    StreamSpliterators$WrappingSpliterator(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z) {
        super(pipelineHelper, spliterator, z);
    }

    @Override
    public StreamSpliterators$WrappingSpliterator wrap(Spliterator spliterator) {
        return new StreamSpliterators$WrappingSpliterator(this.f1400ph, spliterator, this.isParallel);
    }

    @Override
    void initPartialTraversalState() {
        final SpinedBuffer spinedBuffer = new SpinedBuffer();
        this.buffer = spinedBuffer;
        PipelineHelper pipelineHelper = this.f1400ph;
        Objects.requireNonNull(spinedBuffer);
        this.bufferSink = pipelineHelper.wrapSink(new Sink() {
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

            @Override
            public final void accept(Object obj) {
                spinedBuffer.accept(obj);
            }

            public Consumer andThen(Consumer consumer) {
                return Consumer$CC.$default$andThen(this, consumer);
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
                return this.f$0.m1739xf58cc34f();
            }
        };
    }

    boolean m1739xf58cc34f() {
        return this.spliterator.tryAdvance(this.bufferSink);
    }

    @Override
    public boolean tryAdvance(Consumer consumer) {
        Objects.requireNonNull(consumer);
        boolean zDoAdvance = doAdvance();
        if (zDoAdvance) {
            consumer.accept(((SpinedBuffer) this.buffer).get(this.nextToConsume));
        }
        return zDoAdvance;
    }

    @Override
    public void forEachRemaining(final Consumer consumer) {
        if (this.buffer == null && !this.finished) {
            Objects.requireNonNull(consumer);
            init();
            PipelineHelper pipelineHelper = this.f1400ph;
            Objects.requireNonNull(consumer);
            pipelineHelper.wrapAndCopyInto(new Sink() {
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

                @Override
                public final void accept(Object obj) {
                    consumer.accept(obj);
                }

                public Consumer andThen(Consumer consumer2) {
                    return Consumer$CC.$default$andThen(this, consumer2);
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
        while (tryAdvance(consumer)) {
        }
    }
}
