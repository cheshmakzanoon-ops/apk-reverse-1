package com.google.android.gms.measurement.internal;

import android.os.Handler;
import com.google.android.gms.common.internal.Preconditions;

abstract class zzaw {
    private static volatile Handler zza;
    private final zzif zzb;
    private final Runnable zzc;
    private volatile long zzd;

    private final Handler zzd() {
        Handler handler;
        if (zza != null) {
            return zza;
        }
        synchronized (zzaw.class) {
            if (zza == null) {
                zza = new com.google.android.gms.internal.measurement.zzcp(this.zzb.zza().getMainLooper());
            }
            handler = zza;
        }
        return handler;
    }

    public abstract void zzb();

    zzaw(zzif zzifVar) {
        Preconditions.checkNotNull(zzifVar);
        this.zzb = zzifVar;
        this.zzc = new zzav(this, zzifVar);
    }

    final void zza() {
        this.zzd = 0L;
        zzd().removeCallbacks(this.zzc);
    }

    public final void zza(long j) {
        zza();
        if (j >= 0) {
            this.zzd = this.zzb.zzb().currentTimeMillis();
            if (zzd().postDelayed(this.zzc, j)) {
                return;
            }
            this.zzb.zzj().zzg().zza("Failed to schedule delayed post. time", Long.valueOf(j));
        }
    }

    public final boolean zzc() {
        return this.zzd != 0;
    }
}
