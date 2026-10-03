package com.google.android.gms.internal.play_billing;

import java.lang.ref.WeakReference;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Executor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

final class zzt implements zzdc {
    final WeakReference zza;
    private final zzo zzb = new zzs(this);

    zzt(zzp zzpVar) {
        this.zza = new WeakReference(zzpVar);
    }

    @Override
    public final boolean cancel(boolean z) {
        zzp zzpVar = (zzp) this.zza.get();
        boolean zCancel = this.zzb.cancel(z);
        if (!zCancel || zzpVar == null) {
            return zCancel;
        }
        zzpVar.zza();
        return true;
    }

    @Override
    public final Object get() throws ExecutionException, InterruptedException {
        return this.zzb.get();
    }

    @Override
    public final boolean isCancelled() {
        return this.zzb.zzc instanceof zze;
    }

    @Override
    public final boolean isDone() {
        return this.zzb.isDone();
    }

    public final String toString() {
        return this.zzb.toString();
    }

    final boolean zza(Object obj) {
        return this.zzb.zzd(obj);
    }

    @Override
    public final void zzb(Runnable runnable, Executor executor) {
        this.zzb.zzb(runnable, executor);
    }

    final boolean zzc(Throwable th) {
        zzg zzgVar = new zzg(th);
        zzd zzdVar = zzo.zzb;
        zzo zzoVar = this.zzb;
        if (!zzdVar.zzd(zzoVar, null, zzgVar)) {
            return false;
        }
        zzo.zzc(zzoVar);
        return true;
    }

    @Override
    public final Object get(long j, TimeUnit timeUnit) throws ExecutionException, InterruptedException, TimeoutException {
        return this.zzb.get(j, timeUnit);
    }
}
