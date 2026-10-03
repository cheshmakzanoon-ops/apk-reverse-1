package com.google.android.gms.dynamic;

final class zaf implements zah {
    final DeferredLifecycleHelper zaa;

    zaf(DeferredLifecycleHelper deferredLifecycleHelper) {
        this.zaa = deferredLifecycleHelper;
    }

    @Override
    public final int zaa() {
        return 4;
    }

    @Override
    public final void zab(LifecycleDelegate lifecycleDelegate) {
        this.zaa.zaa.onStart();
    }
}
