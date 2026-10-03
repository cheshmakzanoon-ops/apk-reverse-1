package p000j$.util.stream;

import java.util.Comparator;
import java.util.function.Consumer;
import p000j$.util.Spliterator;
import p000j$.util.concurrent.ConcurrentHashMap;
import p000j$.util.function.Consumer$CC;

final class StreamSpliterators$DistinctSpliterator implements Spliterator, Consumer {
    private static final Object NULL_VALUE = new Object();

    private final Spliterator f1402s;
    private final ConcurrentHashMap seen;
    private Object tmpSlot;

    public Consumer andThen(Consumer consumer) {
        return Consumer$CC.$default$andThen(this, consumer);
    }

    @Override
    public long getExactSizeIfKnown() {
        return Spliterator.CC.$default$getExactSizeIfKnown(this);
    }

    @Override
    public boolean hasCharacteristics(int i) {
        return Spliterator.CC.$default$hasCharacteristics(this, i);
    }

    StreamSpliterators$DistinctSpliterator(Spliterator spliterator) {
        this(spliterator, new ConcurrentHashMap());
    }

    private StreamSpliterators$DistinctSpliterator(Spliterator spliterator, ConcurrentHashMap concurrentHashMap) {
        this.f1402s = spliterator;
        this.seen = concurrentHashMap;
    }

    @Override
    public void accept(Object obj) {
        this.tmpSlot = obj;
    }

    private Object mapNull(Object obj) {
        return obj != null ? obj : NULL_VALUE;
    }

    @Override
    public boolean tryAdvance(Consumer consumer) {
        while (this.f1402s.tryAdvance(this)) {
            if (this.seen.putIfAbsent(mapNull(this.tmpSlot), Boolean.TRUE) == null) {
                consumer.accept(this.tmpSlot);
                this.tmpSlot = null;
                return true;
            }
        }
        return false;
    }

    @Override
    public void forEachRemaining(final Consumer consumer) {
        this.f1402s.forEachRemaining(new Consumer() {
            @Override
            public final void accept(Object obj) {
                this.f$0.m1735xb9bff3f1(consumer, obj);
            }

            public Consumer andThen(Consumer consumer2) {
                return Consumer$CC.$default$andThen(this, consumer2);
            }
        });
    }

    void m1735xb9bff3f1(Consumer consumer, Object obj) {
        if (this.seen.putIfAbsent(mapNull(obj), Boolean.TRUE) == null) {
            consumer.accept(obj);
        }
    }

    @Override
    public Spliterator trySplit() {
        Spliterator spliteratorTrySplit = this.f1402s.trySplit();
        if (spliteratorTrySplit != null) {
            return new StreamSpliterators$DistinctSpliterator(spliteratorTrySplit, this.seen);
        }
        return null;
    }

    @Override
    public long estimateSize() {
        return this.f1402s.estimateSize();
    }

    @Override
    public int characteristics() {
        return (this.f1402s.characteristics() & (-16469)) | 1;
    }

    @Override
    public Comparator getComparator() {
        return this.f1402s.getComparator();
    }
}
