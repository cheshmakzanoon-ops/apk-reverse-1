package com.google.android.gms.internal.common;

import java.util.ListIterator;

public abstract class zzal extends zzak implements ListIterator {
    protected zzal() {
    }

    @Override
    @Deprecated
    public final void add(Object obj) {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final void set(Object obj) {
        throw new UnsupportedOperationException();
    }
}
