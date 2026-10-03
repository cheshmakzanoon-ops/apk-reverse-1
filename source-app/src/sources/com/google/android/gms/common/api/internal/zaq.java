package com.google.android.gms.common.api.internal;

final class zaq extends ThreadLocal {
    zaq() {
    }

    @Override
    protected final Object initialValue() {
        return false;
    }
}
