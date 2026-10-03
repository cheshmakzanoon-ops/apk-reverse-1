package com.google.android.gms.measurement.internal;

import com.google.common.util.concurrent.FutureCallback;

final class zzjc implements FutureCallback<Object> {
    private final zzmh zza;
    private final zziq zzb;

    zzjc(zziq zziqVar, zzmh zzmhVar) {
        this.zzb = zziqVar;
        this.zza = zzmhVar;
    }

    @Override
    public final void onFailure(Throwable th) {
        this.zzb.zzt();
        this.zzb.zzh = false;
        this.zzb.zzan();
        this.zzb.zzj().zzg().zza("registerTriggerAsync failed with throwable", th);
    }

    @Override
    public final void onSuccess(Object obj) {
        this.zzb.zzt();
        this.zzb.zzh = false;
        this.zzb.zzan();
        this.zzb.zzj().zzc().zza("registerTriggerAsync ran. uri", this.zza.zza);
    }
}
