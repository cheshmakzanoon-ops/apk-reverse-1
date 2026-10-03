package com.google.android.gms.measurement.internal;

import android.content.ComponentName;

final class zzlo implements Runnable {
    private final ComponentName zza;
    private final zzlm zzb;

    zzlo(zzlm zzlmVar, ComponentName componentName) {
        this.zzb = zzlmVar;
        this.zza = componentName;
    }

    @Override
    public final void run() {
        zzkp.zza(this.zzb.zza, this.zza);
    }
}
