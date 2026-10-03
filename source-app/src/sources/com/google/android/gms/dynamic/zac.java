package com.google.android.gms.dynamic;

import android.os.Bundle;

final class zac implements zah {
    final Bundle zaa;
    final DeferredLifecycleHelper zab;

    zac(DeferredLifecycleHelper deferredLifecycleHelper, Bundle bundle) {
        this.zab = deferredLifecycleHelper;
        this.zaa = bundle;
    }

    @Override
    public final int zaa() {
        return 1;
    }

    @Override
    public final void zab(LifecycleDelegate lifecycleDelegate) {
        this.zab.zaa.onCreate(this.zaa);
    }
}
