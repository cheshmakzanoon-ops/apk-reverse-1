package com.google.android.gms.internal.measurement;

import java.util.Iterator;
import java.util.NoSuchElementException;

final class zzll implements Iterator<Object> {
    @Override
    public final boolean hasNext() {
        return false;
    }

    @Override
    public final Object next() {
        throw new NoSuchElementException();
    }

    zzll() {
    }

    @Override
    public final void remove() {
        throw new UnsupportedOperationException();
    }
}
