package com.google.android.gms.measurement.internal;

import android.os.RemoteException;

final class zzkz implements Runnable {
    private final zzki zza;
    private final zzkp zzb;

    zzkz(zzkp zzkpVar, zzki zzkiVar) {
        this.zzb = zzkpVar;
        this.zza = zzkiVar;
    }

    @Override
    public final void run() {
        zzfk zzfkVar = this.zzb.zzb;
        if (zzfkVar == null) {
            this.zzb.zzj().zzg().zza("Failed to send current screen to service");
            return;
        }
        try {
            zzki zzkiVar = this.zza;
            if (zzkiVar == null) {
                zzfkVar.zza(0L, (String) null, (String) null, this.zzb.zza().getPackageName());
            } else {
                zzfkVar.zza(zzkiVar.zzc, this.zza.zza, this.zza.zzb, this.zzb.zza().getPackageName());
            }
            this.zzb.zzal();
        } catch (RemoteException e) {
            this.zzb.zzj().zzg().zza("Failed to send current screen to the service", e);
        }
    }
}
