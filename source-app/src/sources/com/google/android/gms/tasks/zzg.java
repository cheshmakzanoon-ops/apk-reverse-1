package com.google.android.gms.tasks;

final class zzg implements Runnable {
    final zzh zza;

    zzg(zzh zzhVar) {
        this.zza = zzhVar;
    }

    @Override
    public final void run() {
        synchronized (this.zza.zzb) {
            zzh zzhVar = this.zza;
            if (zzhVar.zzc != null) {
                zzhVar.zzc.onCanceled();
            }
        }
    }
}
