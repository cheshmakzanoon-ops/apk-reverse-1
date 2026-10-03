package com.google.android.gms.tasks;

final class zzi implements Runnable {
    final Task zza;
    final zzj zzb;

    zzi(zzj zzjVar, Task task) {
        this.zzb = zzjVar;
        this.zza = task;
    }

    @Override
    public final void run() {
        synchronized (this.zzb.zzb) {
            zzj zzjVar = this.zzb;
            if (zzjVar.zzc != null) {
                zzjVar.zzc.onComplete(this.zza);
            }
        }
    }
}
