package com.google.android.gms.tasks;

final class zzm implements Runnable {
    final Task zza;
    final zzn zzb;

    zzm(zzn zznVar, Task task) {
        this.zzb = zznVar;
        this.zza = task;
    }

    @Override
    public final void run() {
        synchronized (this.zzb.zzb) {
            zzn zznVar = this.zzb;
            if (zznVar.zzc != null) {
                zznVar.zzc.onSuccess(this.zza.getResult());
            }
        }
    }
}
