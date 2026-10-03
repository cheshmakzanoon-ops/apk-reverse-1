package com.google.common.collect;

import java.util.NoSuchElementException;
import java.util.Queue;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingQueue<E> extends ForwardingCollection<E> implements Queue<E> {
    @Override
    public abstract Queue<E> delegate();

    protected ForwardingQueue() {
    }

    public boolean offer(@ParametricNullness E e) {
        return delegate().offer(e);
    }

    @Override
    @CheckForNull
    public E poll() {
        return delegate().poll();
    }

    @Override
    @ParametricNullness
    public E remove() {
        return delegate().remove();
    }

    @Override
    @CheckForNull
    public E peek() {
        return delegate().peek();
    }

    @Override
    @ParametricNullness
    public E element() {
        return delegate().element();
    }

    protected boolean standardOffer(@ParametricNullness E e) {
        try {
            return add(e);
        } catch (IllegalStateException unused) {
            return false;
        }
    }

    @CheckForNull
    protected E standardPeek() {
        try {
            return element();
        } catch (NoSuchElementException unused) {
            return null;
        }
    }

    @CheckForNull
    protected E standardPoll() {
        try {
            return remove();
        } catch (NoSuchElementException unused) {
            return null;
        }
    }
}
