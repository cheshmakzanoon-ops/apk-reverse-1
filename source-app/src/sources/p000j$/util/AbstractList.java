package p000j$.util;

import java.util.AbstractCollection;
import java.util.Comparator;
import java.util.ConcurrentModificationException;
import java.util.List;
import java.util.function.Consumer;

public abstract class AbstractList extends AbstractCollection implements List {

    static final class RandomAccessSpliterator implements Spliterator {
        private int expectedModCount;
        private int fence;
        private int index;
        private final List list;

        static void checkAbstractListModCount(AbstractList abstractList, int i) {
        }

        @Override
        public int characteristics() {
            return 16464;
        }

        @Override
        public Comparator getComparator() {
            return Spliterator.CC.$default$getComparator(this);
        }

        @Override
        public long getExactSizeIfKnown() {
            return Spliterator.CC.$default$getExactSizeIfKnown(this);
        }

        @Override
        public boolean hasCharacteristics(int i) {
            return Spliterator.CC.$default$hasCharacteristics(this, i);
        }

        RandomAccessSpliterator(List list) {
            this.list = list;
            this.index = 0;
            this.fence = -1;
            this.expectedModCount = 0;
        }

        private RandomAccessSpliterator(RandomAccessSpliterator randomAccessSpliterator, int i, int i2) {
            this.list = randomAccessSpliterator.list;
            this.index = i;
            this.fence = i2;
            this.expectedModCount = randomAccessSpliterator.expectedModCount;
        }

        private int getFence() {
            List list = this.list;
            int i = this.fence;
            if (i >= 0) {
                return i;
            }
            int size = list.size();
            this.fence = size;
            return size;
        }

        @Override
        public Spliterator trySplit() {
            int fence = getFence();
            int i = this.index;
            int i2 = (fence + i) >>> 1;
            if (i >= i2) {
                return null;
            }
            this.index = i2;
            return new RandomAccessSpliterator(this, i, i2);
        }

        @Override
        public boolean tryAdvance(Consumer consumer) {
            consumer.getClass();
            int fence = getFence();
            int i = this.index;
            if (i >= fence) {
                return false;
            }
            this.index = i + 1;
            consumer.accept(get(this.list, i));
            checkAbstractListModCount(null, this.expectedModCount);
            return true;
        }

        @Override
        public void forEachRemaining(Consumer consumer) {
            Objects.requireNonNull(consumer);
            List list = this.list;
            int fence = getFence();
            this.index = fence;
            for (int i = this.index; i < fence; i++) {
                consumer.accept(get(list, i));
            }
            checkAbstractListModCount(null, this.expectedModCount);
        }

        @Override
        public long estimateSize() {
            return getFence() - this.index;
        }

        private static Object get(List list, int i) {
            try {
                return list.get(i);
            } catch (IndexOutOfBoundsException unused) {
                throw new ConcurrentModificationException();
            }
        }
    }
}
