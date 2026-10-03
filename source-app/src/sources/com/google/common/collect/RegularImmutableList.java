package com.google.common.collect;

import com.google.common.base.Preconditions;
import j$.util.Objects;

@ElementTypesAreNonnullByDefault
class RegularImmutableList<E> extends ImmutableList<E> {
    static final ImmutableList<Object> EMPTY = new RegularImmutableList(new Object[0], 0);
    final transient Object[] array;
    private final transient int size;

    @Override
    int internalArrayStart() {
        return 0;
    }

    @Override
    boolean isPartialView() {
        return false;
    }

    RegularImmutableList(Object[] objArr, int i) {
        this.array = objArr;
        this.size = i;
    }

    @Override
    public int size() {
        return this.size;
    }

    @Override
    Object[] internalArray() {
        return this.array;
    }

    @Override
    int internalArrayEnd() {
        return this.size;
    }

    @Override
    int copyIntoArray(Object[] objArr, int i) {
        System.arraycopy(this.array, 0, objArr, i, this.size);
        return i + this.size;
    }

    @Override
    public E get(int i) {
        Preconditions.checkElementIndex(i, this.size);
        return (E) Objects.requireNonNull(this.array[i]);
    }
}
