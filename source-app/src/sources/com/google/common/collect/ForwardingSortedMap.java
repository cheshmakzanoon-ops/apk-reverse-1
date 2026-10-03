package com.google.common.collect;

import com.google.common.base.Preconditions;
import java.util.Comparator;
import java.util.NoSuchElementException;
import java.util.SortedMap;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingSortedMap<K, V> extends ForwardingMap<K, V> implements SortedMap<K, V> {
    @Override
    public abstract SortedMap<K, V> delegate();

    protected ForwardingSortedMap() {
    }

    @Override
    @CheckForNull
    public Comparator<? super K> comparator() {
        return delegate().comparator();
    }

    @Override
    @ParametricNullness
    public K firstKey() {
        return delegate().firstKey();
    }

    @Override
    public SortedMap<K, V> headMap(@ParametricNullness K k) {
        return delegate().headMap(k);
    }

    @Override
    @ParametricNullness
    public K lastKey() {
        return delegate().lastKey();
    }

    @Override
    public SortedMap<K, V> subMap(@ParametricNullness K k, @ParametricNullness K k2) {
        return delegate().subMap(k, k2);
    }

    @Override
    public SortedMap<K, V> tailMap(@ParametricNullness K k) {
        return delegate().tailMap(k);
    }

    protected class StandardKeySet extends Maps.SortedKeySet<K, V> {
        public StandardKeySet(ForwardingSortedMap forwardingSortedMap) {
            super(forwardingSortedMap);
        }
    }

    static int unsafeCompare(@CheckForNull Comparator<?> comparator, @CheckForNull Object obj, @CheckForNull Object obj2) {
        if (comparator == null) {
            return ((Comparable) obj).compareTo(obj2);
        }
        return comparator.compare(obj, obj2);
    }

    @Override
    protected boolean standardContainsKey(@CheckForNull Object obj) {
        try {
            return unsafeCompare(comparator(), tailMap(obj).firstKey(), obj) == 0;
        } catch (ClassCastException | NullPointerException | NoSuchElementException unused) {
            return false;
        }
    }

    protected SortedMap<K, V> standardSubMap(K k, K k2) {
        Preconditions.checkArgument(unsafeCompare(comparator(), k, k2) <= 0, "fromKey must be <= toKey");
        return tailMap(k).headMap(k2);
    }
}
