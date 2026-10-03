package com.google.android.gms.dynamic;

final class zag implements zah {
    final DeferredLifecycleHelper zaa;

    zag(DeferredLifecycleHelper deferredLifecycleHelper) {
        this.zaa = deferredLifecycleHelper;
    }

    @Override
    public final int zaa() {
        return 5;
    }

    @Override
    public final void zab(LifecycleDelegate lifecycleDelegate) {
        this.zaa.zaa.onResume();
    }
}
