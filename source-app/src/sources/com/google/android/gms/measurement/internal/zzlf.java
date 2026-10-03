package com.google.android.gms.measurement.internal;

import android.os.RemoteException;
import android.text.TextUtils;
import com.google.android.gms.common.internal.Preconditions;

final class zzlf implements Runnable {
    private final boolean zza;
    private final zzo zzb;
    private final boolean zzc;
    private final zzbg zzd;
    private final String zze;
    private final zzkp zzf;

    zzlf(zzkp zzkpVar, boolean z, zzo zzoVar, boolean z2, zzbg zzbgVar, String str) {
        this.zzf = zzkpVar;
        this.zza = z;
        this.zzb = zzoVar;
        this.zzc = z2;
        this.zzd = zzbgVar;
        this.zze = str;
    }

    @Override
    public final void run() throws Throwable {
        zzfk zzfkVar = this.zzf.zzb;
        if (zzfkVar == null) {
            this.zzf.zzj().zzg().zza("Discarding data. Failed to send event to service");
            return;
        }
        if (this.zza) {
            Preconditions.checkNotNull(this.zzb);
            this.zzf.zza(zzfkVar, this.zzc ? null : this.zzd, this.zzb);
        } else {
            try {
                if (TextUtils.isEmpty(this.zze)) {
                    Preconditions.checkNotNull(this.zzb);
                    zzfkVar.zza(this.zzd, this.zzb);
                } else {
                    zzfkVar.zza(this.zzd, this.zze, this.zzf.zzj().zzx());
                }
            } catch (RemoteException e) {
                this.zzf.zzj().zzg().zza("Failed to send event to the service", e);
            }
        }
        this.zzf.zzal();
    }
}
