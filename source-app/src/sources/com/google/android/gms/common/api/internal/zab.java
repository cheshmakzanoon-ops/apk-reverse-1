package com.google.android.gms.common.api.internal;

import java.lang.ref.WeakReference;

public final class zab extends ActivityLifecycleObserver {
    private final WeakReference zaa;

    zab(zaa zaaVar) {
        this.zaa = new WeakReference(zaaVar);
    }

    @Override
    public final ActivityLifecycleObserver onStopCallOnce(Runnable runnable) {
        zaa zaaVar = (zaa) this.zaa.get();
        if (zaaVar == null) {
            throw new IllegalStateException("The target activity has already been GC'd");
        }
        zaaVar.zac(runnable);
        return this;
    }
}
