package com.google.common.collect;

import java.util.ListIterator;

@ElementTypesAreNonnullByDefault
public abstract class UnmodifiableListIterator<E> extends UnmodifiableIterator<E> implements ListIterator<E> {
    protected UnmodifiableListIterator() {
    }

    @Override
    @Deprecated
    public final void add(@ParametricNullness E e) {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final void set(@ParametricNullness E e) {
        throw new UnsupportedOperationException();
    }
}
