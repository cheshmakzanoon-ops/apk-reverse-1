package com.google.android.gms.tasks;

import com.google.android.gms.common.internal.Preconditions;

final class zzk implements Runnable {
    final Task zza;
    final zzl zzb;

    zzk(zzl zzlVar, Task task) {
        this.zzb = zzlVar;
        this.zza = task;
    }

    @Override
    public final void run() {
        synchronized (this.zzb.zzb) {
            zzl zzlVar = this.zzb;
            if (zzlVar.zzc != null) {
                zzlVar.zzc.onFailure((Exception) Preconditions.checkNotNull(this.zza.getException()));
            }
        }
    }
}
