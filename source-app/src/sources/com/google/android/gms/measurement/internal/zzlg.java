package com.google.android.gms.measurement.internal;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzlg implements Runnable {
    private final zzo zza;
    private final zzkp zzb;

    zzlg(zzkp zzkpVar, zzo zzoVar) {
        this.zzb = zzkpVar;
        this.zza = zzoVar;
    }

    @Override
    public final void run() {
        zzfk zzfkVar = this.zzb.zzb;
        if (zzfkVar == null) {
            this.zzb.zzj().zzg().zza("Failed to send consent settings to service");
            return;
        }
        try {
            Preconditions.checkNotNull(this.zza);
            zzfkVar.zze(this.zza);
            this.zzb.zzal();
        } catch (RemoteException e) {
            this.zzb.zzj().zzg().zza("Failed to send consent settings to the service", e);
        }
    }
}
