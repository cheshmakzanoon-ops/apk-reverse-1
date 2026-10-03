package com.google.android.gms.measurement.internal;

final class zzkl implements Runnable {
    private final zzkh zza;

    zzkl(zzkh zzkhVar) {
        this.zza = zzkhVar;
    }

    @Override
    public final void run() {
        zzkh zzkhVar = this.zza;
        zzkhVar.zza = zzkhVar.zzh;
    }
}
