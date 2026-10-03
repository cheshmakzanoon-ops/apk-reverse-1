package com.google.android.gms.measurement.internal;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.internal.safeparcel.AbstractSafeParcelable;

final class zzla implements Runnable {
    private final zzo zza;
    private final zzkp zzb;

    zzla(zzkp zzkpVar, zzo zzoVar) {
        this.zzb = zzkpVar;
        this.zza = zzoVar;
    }

    @Override
    public final void run() throws Throwable {
        zzfk zzfkVar = this.zzb.zzb;
        if (zzfkVar == null) {
            this.zzb.zzj().zzg().zza("Discarding data. Failed to send app launch");
            return;
        }
        try {
            Preconditions.checkNotNull(this.zza);
            zzfkVar.zzc(this.zza);
            this.zzb.zzh().zzac();
            this.zzb.zza(zzfkVar, (AbstractSafeParcelable) null, this.zza);
            this.zzb.zzal();
        } catch (RemoteException e) {
            this.zzb.zzj().zzg().zza("Failed to send app launch to the service", e);
        }
    }
}
