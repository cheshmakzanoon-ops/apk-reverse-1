package com.google.android.play.core.review;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzf extends com.google.android.play.core.review.internal.zzj {
    final TaskCompletionSource zza;
    final zzi zzb;

    zzf(zzi zziVar, TaskCompletionSource taskCompletionSource, TaskCompletionSource taskCompletionSource2) {
        super(taskCompletionSource);
        this.zzb = zziVar;
        this.zza = taskCompletionSource2;
    }

    @Override
    protected final void zza() {
        try {
            ?? Zze = this.zzb.zza.zze();
            String str = this.zzb.zzc;
            Bundle bundleZza = zzj.zza();
            zzi zziVar = this.zzb;
            Zze.zzc(str, bundleZza, new zzh(zziVar, this.zza, zziVar.zzc));
        } catch (RemoteException e) {
            zzi.zzb.zzc(e, "error requesting in-app review for %s", this.zzb.zzc);
            this.zza.trySetException(new RuntimeException(e));
        }
    }
}
