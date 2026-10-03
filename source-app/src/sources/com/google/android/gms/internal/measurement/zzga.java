package com.google.android.gms.internal.measurement;

import android.database.ContentObserver;
import android.os.Handler;

final class zzga extends ContentObserver {
    private final zzfy zza;

    zzga(zzfy zzfyVar, Handler handler) {
        super(null);
        this.zza = zzfyVar;
    }

    @Override
    public final void onChange(boolean z) {
        this.zza.zzd();
    }
}
