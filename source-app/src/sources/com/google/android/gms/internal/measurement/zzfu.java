package com.google.android.gms.internal.measurement;

import android.database.ContentObserver;
import android.os.Handler;

final class zzfu extends ContentObserver {
    zzfu(Handler handler) {
        super(null);
    }

    @Override
    public final void onChange(boolean z) {
        zzfr.zze.set(true);
    }
}
