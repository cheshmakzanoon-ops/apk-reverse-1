package com.google.android.gms.common.internal;

import android.app.Activity;
import android.content.Intent;

final class zad extends zag {
    final Intent zaa;
    final Activity zab;
    final int zac;

    zad(Intent intent, Activity activity, int i) {
        this.zaa = intent;
        this.zab = activity;
        this.zac = i;
    }

    @Override
    public final void zaa() {
        Intent intent = this.zaa;
        if (intent != null) {
            this.zab.startActivityForResult(intent, this.zac);
        }
    }
}
