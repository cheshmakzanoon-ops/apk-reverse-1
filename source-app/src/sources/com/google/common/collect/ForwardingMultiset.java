package com.google.common.collect;

import com.google.common.base.Objects;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingMultiset<E> extends ForwardingCollection<E> implements Multiset<E> {
    @Override
    public abstract Multiset<E> delegate();

    protected ForwardingMultiset() {
    }

    @Override
    public int count(@CheckForNull Object obj) {
        return delegate().count(obj);
    }

    @Override
    public int add(@ParametricNullness E e, int i) {
        return delegate().add(e, i);
    }

    @Override
    public int remove(@CheckForNull Object obj, int i) {
        return delegate().remove(obj, i);
    }

    public Set<E> elementSet() {
        return delegate().elementSet();
    }

    public Set<Multiset.Entry<E>> entrySet() {
        return delegate().entrySet();
    }

    @Override
    public boolean equals(@CheckForNull Object obj) {
        return obj == this || delegate().equals(obj);
    }

    @Override
    public int hashCode() {
        return delegate().hashCode();
    }

    @Override
    public int setCount(@ParametricNullness E e, int i) {
        return delegate().setCount(e, i);
    }

    @Override
    public boolean setCount(@ParametricNullness E e, int i, int i2) {
        return delegate().setCount(e, i, i2);
    }

    @Override
    protected boolean standardContains(@CheckForNull Object obj) {
        return count(obj) > 0;
    }

    @Override
    protected void standardClear() {
        Iterators.clear(entrySet().iterator());
    }

    protected int standardCount(@CheckForNull Object obj) {
        for (Multiset.Entry<E> entry : entrySet()) {
            if (Objects.equal(entry.getElement(), obj)) {
                return entry.getCount();
            }
        }
        return 0;
    }

    protected boolean standardAdd(@ParametricNullness E e) {
        add(e, 1);
        return true;
    }

    @Override
    protected boolean standardAddAll(Collection<? extends E> collection) {
        return Multisets.addAllImpl(this, collection);
    }

    @Override
    protected boolean standardRemove(@CheckForNull Object obj) {
        return remove(obj, 1) > 0;
    }

    @Override
    protected boolean standardRemoveAll(Collection<?> collection) {
        return Multisets.removeAllImpl(this, collection);
    }

    @Override
    protected boolean standardRetainAll(Collection<?> collection) {
        return Multisets.retainAllImpl(this, collection);
    }

    protected int standardSetCount(@ParametricNullness E e, int i) {
        return Multisets.setCountImpl(this, e, i);
    }

    protected boolean standardSetCount(@ParametricNullness E e, int i, int i2) {
        return Multisets.setCountImpl(this, e, i, i2);
    }

    protected class StandardElementSet extends Multisets.ElementSet<E> {
        public StandardElementSet() {
        }

        @Override
        Multiset<E> multiset() {
            return ForwardingMultiset.this;
        }

        @Override
        public Iterator<E> iterator() {
            return Multisets.elementIterator(multiset().entrySet().iterator());
        }
    }

    protected Iterator<E> standardIterator() {
        return Multisets.iteratorImpl(this);
    }

    protected int standardSize() {
        return Multisets.linearTimeSizeImpl(this);
    }

    protected boolean standardEquals(@CheckForNull Object obj) {
        return Multisets.equalsImpl(this, obj);
    }

    protected int standardHashCode() {
        return entrySet().hashCode();
    }

    @Override
    protected String standardToString() {
        return entrySet().toString();
    }
}
