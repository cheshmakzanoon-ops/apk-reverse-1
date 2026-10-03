package com.google.android.gms.internal.games_v2;

import java.util.Iterator;

public abstract class zzil implements Iterator {
    protected zzil() {
    }

    @Override
    @Deprecated
    public final void remove() {
        throw new UnsupportedOperationException();
    }
}
