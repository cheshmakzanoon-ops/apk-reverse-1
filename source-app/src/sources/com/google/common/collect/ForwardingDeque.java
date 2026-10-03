package com.google.common.collect;

import java.util.Deque;
import java.util.Iterator;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
public abstract class ForwardingDeque<E> extends ForwardingQueue<E> implements Deque<E> {
    @Override
    public abstract Deque<E> delegate();

    protected ForwardingDeque() {
    }

    @Override
    public void addFirst(@ParametricNullness E e) {
        delegate().addFirst(e);
    }

    @Override
    public void addLast(@ParametricNullness E e) {
        delegate().addLast(e);
    }

    @Override
    public Iterator<E> descendingIterator() {
        return delegate().descendingIterator();
    }

    @Override
    @ParametricNullness
    public E getFirst() {
        return delegate().getFirst();
    }

    @Override
    @ParametricNullness
    public E getLast() {
        return delegate().getLast();
    }

    @Override
    public boolean offerFirst(@ParametricNullness E e) {
        return delegate().offerFirst(e);
    }

    @Override
    public boolean offerLast(@ParametricNullness E e) {
        return delegate().offerLast(e);
    }

    @Override
    @CheckForNull
    public E peekFirst() {
        return delegate().peekFirst();
    }

    @Override
    @CheckForNull
    public E peekLast() {
        return delegate().peekLast();
    }

    @Override
    @CheckForNull
    public E pollFirst() {
        return delegate().pollFirst();
    }

    @Override
    @CheckForNull
    public E pollLast() {
        return delegate().pollLast();
    }

    @Override
    @ParametricNullness
    public E pop() {
        return delegate().pop();
    }

    @Override
    public void push(@ParametricNullness E e) {
        delegate().push(e);
    }

    @Override
    @ParametricNullness
    public E removeFirst() {
        return delegate().removeFirst();
    }

    @Override
    @ParametricNullness
    public E removeLast() {
        return delegate().removeLast();
    }

    @Override
    public boolean removeFirstOccurrence(@CheckForNull Object obj) {
        return delegate().removeFirstOccurrence(obj);
    }

    @Override
    public boolean removeLastOccurrence(@CheckForNull Object obj) {
        return delegate().removeLastOccurrence(obj);
    }
}
