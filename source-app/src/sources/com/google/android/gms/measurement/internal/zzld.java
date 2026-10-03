package com.google.android.gms.measurement.internal;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzld implements Runnable {
    private final zzo zza;
    private final zzkp zzb;

    zzld(zzkp zzkpVar, zzo zzoVar) {
        this.zzb = zzkpVar;
        this.zza = zzoVar;
    }

    @Override
    public final void run() {
        zzfk zzfkVar = this.zzb.zzb;
        if (zzfkVar == null) {
            this.zzb.zzj().zzg().zza("Failed to send measurementEnabled to service");
            return;
        }
        try {
            Preconditions.checkNotNull(this.zza);
            zzfkVar.zzf(this.zza);
            this.zzb.zzal();
        } catch (RemoteException e) {
            this.zzb.zzj().zzg().zza("Failed to send measurementEnabled to the service", e);
        }
    }
}
