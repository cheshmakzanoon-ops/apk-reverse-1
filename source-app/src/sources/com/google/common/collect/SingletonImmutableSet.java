package com.google.common.collect;

import com.google.common.base.Preconditions;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
final class SingletonImmutableSet<E> extends ImmutableSet<E> {
    final transient E element;

    @Override
    boolean isPartialView() {
        return false;
    }

    @Override
    public int size() {
        return 1;
    }

    SingletonImmutableSet(E e) {
        this.element = (E) Preconditions.checkNotNull(e);
    }

    @Override
    public boolean contains(@CheckForNull Object obj) {
        return this.element.equals(obj);
    }

    @Override
    public UnmodifiableIterator<E> iterator() {
        return Iterators.singletonIterator(this.element);
    }

    @Override
    public ImmutableList<E> asList() {
        return ImmutableList.m161of((Object) this.element);
    }

    @Override
    int copyIntoArray(Object[] objArr, int i) {
        objArr[i] = this.element;
        return i + 1;
    }

    @Override
    public final int hashCode() {
        return this.element.hashCode();
    }

    @Override
    public String toString() {
        String string = this.element.toString();
        StringBuilder sb = new StringBuilder(String.valueOf(string).length() + 2);
        sb.append('[');
        sb.append(string);
        sb.append(']');
        return sb.toString();
    }
}
