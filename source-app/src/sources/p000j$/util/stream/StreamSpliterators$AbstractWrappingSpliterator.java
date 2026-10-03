package p000j$.util.stream;

import java.util.Comparator;
import java.util.function.BooleanSupplier;
import java.util.function.Supplier;
import p000j$.util.Spliterator;

abstract class StreamSpliterators$AbstractWrappingSpliterator implements Spliterator {
    AbstractSpinedBuffer buffer;
    Sink bufferSink;
    boolean finished;
    final boolean isParallel;
    long nextToConsume;

    final PipelineHelper f1400ph;
    BooleanSupplier pusher;
    Spliterator spliterator;
    private Supplier spliteratorSupplier;

    @Override
    public boolean hasCharacteristics(int i) {
        return Spliterator.CC.$default$hasCharacteristics(this, i);
    }

    abstract void initPartialTraversalState();

    abstract StreamSpliterators$AbstractWrappingSpliterator wrap(Spliterator spliterator);

    StreamSpliterators$AbstractWrappingSpliterator(PipelineHelper pipelineHelper, Supplier supplier, boolean z) {
        this.f1400ph = pipelineHelper;
        this.spliteratorSupplier = supplier;
        this.spliterator = null;
        this.isParallel = z;
    }

    StreamSpliterators$AbstractWrappingSpliterator(PipelineHelper pipelineHelper, Spliterator spliterator, boolean z) {
        this.f1400ph = pipelineHelper;
        this.spliteratorSupplier = null;
        this.spliterator = spliterator;
        this.isParallel = z;
    }

    final void init() {
        if (this.spliterator == null) {
            this.spliterator = (Spliterator) this.spliteratorSupplier.get();
            this.spliteratorSupplier = null;
        }
    }

    final boolean doAdvance() {
        AbstractSpinedBuffer abstractSpinedBuffer = this.buffer;
        if (abstractSpinedBuffer == null) {
            if (this.finished) {
                return false;
            }
            init();
            initPartialTraversalState();
            this.nextToConsume = 0L;
            this.bufferSink.begin(this.spliterator.getExactSizeIfKnown());
            return fillBuffer();
        }
        long j = this.nextToConsume + 1;
        this.nextToConsume = j;
        boolean z = j < abstractSpinedBuffer.count();
        if (z) {
            return z;
        }
        this.nextToConsume = 0L;
        this.buffer.clear();
        return fillBuffer();
    }

    @Override
    public Spliterator trySplit() {
        if (!this.isParallel || this.buffer != null || this.finished) {
            return null;
        }
        init();
        Spliterator spliteratorTrySplit = this.spliterator.trySplit();
        if (spliteratorTrySplit == null) {
            return null;
        }
        return wrap(spliteratorTrySplit);
    }

    private boolean fillBuffer() {
        while (this.buffer.count() == 0) {
            if (this.bufferSink.cancellationRequested() || !this.pusher.getAsBoolean()) {
                if (this.finished) {
                    return false;
                }
                this.bufferSink.end();
                this.finished = true;
            }
        }
        return true;
    }

    @Override
    public final long estimateSize() {
        init();
        return this.spliterator.estimateSize();
    }

    @Override
    public final long getExactSizeIfKnown() {
        init();
        if (StreamOpFlag.SIZED.isKnown(this.f1400ph.getStreamAndOpFlags())) {
            return this.spliterator.getExactSizeIfKnown();
        }
        return -1L;
    }

    @Override
    public final int characteristics() {
        init();
        int characteristics = StreamOpFlag.toCharacteristics(StreamOpFlag.toStreamFlags(this.f1400ph.getStreamAndOpFlags()));
        return (characteristics & 64) != 0 ? (characteristics & (-16449)) | (this.spliterator.characteristics() & 16448) : characteristics;
    }

    @Override
    public Comparator getComparator() {
        if (hasCharacteristics(4)) {
            return null;
        }
        throw new IllegalStateException();
    }

    public final String toString() {
        return String.format("%s[%s]", getClass().getName(), this.spliterator);
    }
}
