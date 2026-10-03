package com.google.android.gms.measurement.internal;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzlc implements Runnable {
    private final zzo zza;
    private final Bundle zzb;
    private final zzkp zzc;

    zzlc(zzkp zzkpVar, zzo zzoVar, Bundle bundle) {
        this.zzc = zzkpVar;
        this.zza = zzoVar;
        this.zzb = bundle;
    }

    @Override
    public final void run() {
        zzfk zzfkVar = this.zzc.zzb;
        if (zzfkVar == null) {
            this.zzc.zzj().zzg().zza("Failed to send default event parameters to service");
            return;
        }
        try {
            Preconditions.checkNotNull(this.zza);
            zzfkVar.zza(this.zzb, this.zza);
        } catch (RemoteException e) {
            this.zzc.zzj().zzg().zza("Failed to send default event parameters to service", e);
        }
    }
}
