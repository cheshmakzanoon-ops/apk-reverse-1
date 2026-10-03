package p000j$.util;

import java.util.Comparator;

public interface SortedSet<E> extends Set<E> {

    public abstract class CC {
        public static Spliterator $default$spliterator(final java.util.SortedSet sortedSet) {
            return new Spliterators.IteratorSpliterator(sortedSet, 21) {
                @Override
                public Comparator getComparator() {
                    return sortedSet.comparator();
                }
            };
        }
    }
}
