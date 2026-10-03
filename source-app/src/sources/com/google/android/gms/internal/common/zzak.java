package com.google.android.gms.internal.common;

import java.util.Iterator;

public abstract class zzak implements Iterator {
    protected zzak() {
    }

    @Override
    @Deprecated
    public final void remove() {
        throw new UnsupportedOperationException();
    }
}
