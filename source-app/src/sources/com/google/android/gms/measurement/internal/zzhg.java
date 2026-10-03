package com.google.android.gms.measurement.internal;

final class zzhg implements Runnable {
    private final zzio zza;
    private final zzhf zzb;

    zzhg(zzhf zzhfVar, zzio zzioVar) {
        this.zzb = zzhfVar;
        this.zza = zzioVar;
    }

    @Override
    public final void run() {
        zzhf.zza(this.zzb, this.zza);
        this.zzb.zza(this.zza.zzg);
    }
}
