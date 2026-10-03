package p000j$.util.stream;

import java.util.Comparator;
import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import java.util.function.IntConsumer;
import java.util.function.LongConsumer;
import java.util.function.Supplier;
import p000j$.util.Spliterator;

class StreamSpliterators$DelegatingSpliterator implements Spliterator {

    private Spliterator f1401s;
    private final Supplier supplier;

    @Override
    public boolean hasCharacteristics(int i) {
        return Spliterator.CC.$default$hasCharacteristics(this, i);
    }

    StreamSpliterators$DelegatingSpliterator(Supplier supplier) {
        this.supplier = supplier;
    }

    Spliterator get() {
        if (this.f1401s == null) {
            this.f1401s = (Spliterator) this.supplier.get();
        }
        return this.f1401s;
    }

    @Override
    public Spliterator trySplit() {
        return get().trySplit();
    }

    @Override
    public boolean tryAdvance(Consumer consumer) {
        return get().tryAdvance(consumer);
    }

    @Override
    public void forEachRemaining(Consumer consumer) {
        get().forEachRemaining(consumer);
    }

    @Override
    public long estimateSize() {
        return get().estimateSize();
    }

    @Override
    public int characteristics() {
        return get().characteristics();
    }

    @Override
    public Comparator getComparator() {
        return get().getComparator();
    }

    @Override
    public long getExactSizeIfKnown() {
        return get().getExactSizeIfKnown();
    }

    public String toString() {
        return getClass().getName() + "[" + get() + "]";
    }

    static class OfPrimitive extends StreamSpliterators$DelegatingSpliterator implements Spliterator.OfPrimitive {
        @Override
        public Spliterator.OfPrimitive trySplit() {
            return (Spliterator.OfPrimitive) super.trySplit();
        }

        OfPrimitive(Supplier supplier) {
            super(supplier);
        }

        @Override
        public boolean tryAdvance(Object obj) {
            return ((Spliterator.OfPrimitive) get()).tryAdvance(obj);
        }

        @Override
        public void forEachRemaining(Object obj) {
            ((Spliterator.OfPrimitive) get()).forEachRemaining(obj);
        }
    }

    static final class OfInt extends OfPrimitive implements Spliterator.OfInt {
        @Override
        public void forEachRemaining(IntConsumer intConsumer) {
            super.forEachRemaining((Object) intConsumer);
        }

        @Override
        public boolean tryAdvance(IntConsumer intConsumer) {
            return super.tryAdvance((Object) intConsumer);
        }

        @Override
        public Spliterator.OfInt trySplit() {
            return (Spliterator.OfInt) super.trySplit();
        }

        OfInt(Supplier supplier) {
            super(supplier);
        }
    }

    static final class OfLong extends OfPrimitive implements Spliterator.OfLong {
        @Override
        public void forEachRemaining(LongConsumer longConsumer) {
            super.forEachRemaining((Object) longConsumer);
        }

        @Override
        public boolean tryAdvance(LongConsumer longConsumer) {
            return super.tryAdvance((Object) longConsumer);
        }

        @Override
        public Spliterator.OfLong trySplit() {
            return (Spliterator.OfLong) super.trySplit();
        }

        OfLong(Supplier supplier) {
            super(supplier);
        }
    }

    static final class OfDouble extends OfPrimitive implements Spliterator.OfDouble {
        @Override
        public void forEachRemaining(DoubleConsumer doubleConsumer) {
            super.forEachRemaining((Object) doubleConsumer);
        }

        @Override
        public boolean tryAdvance(DoubleConsumer doubleConsumer) {
            return super.tryAdvance((Object) doubleConsumer);
        }

        @Override
        public Spliterator.OfDouble trySplit() {
            return (Spliterator.OfDouble) super.trySplit();
        }

        OfDouble(Supplier supplier) {
            super(supplier);
        }
    }
}
