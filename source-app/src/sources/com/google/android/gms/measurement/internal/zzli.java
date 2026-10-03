package com.google.android.gms.measurement.internal;

import android.os.RemoteException;
import android.text.TextUtils;
import com.google.android.gms.common.internal.Preconditions;

final class zzli implements Runnable {
    private final boolean zza = true;
    private final zzo zzb;
    private final boolean zzc;
    private final zzad zzd;
    private final zzad zze;
    private final zzkp zzf;

    zzli(zzkp zzkpVar, boolean z, zzo zzoVar, boolean z2, zzad zzadVar, zzad zzadVar2) {
        this.zzf = zzkpVar;
        this.zzb = zzoVar;
        this.zzc = z2;
        this.zzd = zzadVar;
        this.zze = zzadVar2;
    }

    @Override
    public final void run() throws Throwable {
        zzfk zzfkVar = this.zzf.zzb;
        if (zzfkVar == null) {
            this.zzf.zzj().zzg().zza("Discarding data. Failed to send conditional user property to service");
            return;
        }
        if (this.zza) {
            Preconditions.checkNotNull(this.zzb);
            this.zzf.zza(zzfkVar, this.zzc ? null : this.zzd, this.zzb);
        } else {
            try {
                if (TextUtils.isEmpty(this.zze.zza)) {
                    Preconditions.checkNotNull(this.zzb);
                    zzfkVar.zza(this.zzd, this.zzb);
                } else {
                    zzfkVar.zza(this.zzd);
                }
            } catch (RemoteException e) {
                this.zzf.zzj().zzg().zza("Failed to send conditional user property to the service", e);
            }
        }
        this.zzf.zzal();
    }
}
