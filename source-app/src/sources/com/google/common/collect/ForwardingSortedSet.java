package com.google.common.collect;

import java.util.Comparator;
import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.SortedSet;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingSortedSet<E> extends ForwardingSet<E> implements SortedSet<E> {
    @Override
    public abstract SortedSet<E> delegate();

    protected ForwardingSortedSet() {
    }

    @Override
    @CheckForNull
    public Comparator<? super E> comparator() {
        return delegate().comparator();
    }

    @Override
    @ParametricNullness
    public E first() {
        return delegate().first();
    }

    @Override
    public SortedSet<E> headSet(@ParametricNullness E e) {
        return delegate().headSet(e);
    }

    @Override
    @ParametricNullness
    public E last() {
        return delegate().last();
    }

    @Override
    public SortedSet<E> subSet(@ParametricNullness E e, @ParametricNullness E e2) {
        return delegate().subSet(e, e2);
    }

    @Override
    public SortedSet<E> tailSet(@ParametricNullness E e) {
        return delegate().tailSet(e);
    }

    @Override
    protected boolean standardContains(@CheckForNull Object obj) {
        try {
            return ForwardingSortedMap.unsafeCompare(comparator(), tailSet(obj).first(), obj) == 0;
        } catch (ClassCastException | NullPointerException | NoSuchElementException unused) {
            return false;
        }
    }

    @Override
    protected boolean standardRemove(@CheckForNull Object obj) {
        try {
            Iterator<E> it = tailSet(obj).iterator();
            if (it.hasNext()) {
                if (ForwardingSortedMap.unsafeCompare(comparator(), it.next(), obj) == 0) {
                    it.remove();
                    return true;
                }
            }
        } catch (ClassCastException | NullPointerException unused) {
        }
        return false;
    }

    protected SortedSet<E> standardSubSet(@ParametricNullness E e, @ParametricNullness E e2) {
        return tailSet(e).headSet(e2);
    }
}
