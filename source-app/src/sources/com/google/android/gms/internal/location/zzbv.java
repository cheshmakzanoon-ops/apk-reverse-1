package com.google.android.gms.internal.location;

import java.util.ListIterator;

public abstract class zzbv<E> extends zzbu<E> implements ListIterator<E> {
    protected zzbv() {
    }

    @Override
    @Deprecated
    public final void add(E e) {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final void set(E e) {
        throw new UnsupportedOperationException();
    }
}
