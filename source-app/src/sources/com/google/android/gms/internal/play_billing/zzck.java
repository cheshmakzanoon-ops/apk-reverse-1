package com.google.android.gms.internal.play_billing;

import java.util.Iterator;

public abstract class zzck implements Iterator {
    protected zzck() {
    }

    @Override
    @Deprecated
    public final void remove() {
        throw new UnsupportedOperationException();
    }
}
