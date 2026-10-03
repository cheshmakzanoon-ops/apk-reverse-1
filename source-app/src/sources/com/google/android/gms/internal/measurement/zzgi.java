package com.google.android.gms.internal.measurement;

import android.database.ContentObserver;
import android.os.Handler;

final class zzgi extends ContentObserver {
    zzgi(zzgg zzggVar, Handler handler) {
        super(null);
    }

    @Override
    public final void onChange(boolean z) {
        zzgn.zzc();
    }
}
