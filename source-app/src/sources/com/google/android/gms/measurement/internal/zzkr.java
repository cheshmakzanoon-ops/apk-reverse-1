package com.google.android.gms.measurement.internal;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzkr implements Runnable {
    private final String zza;
    private final String zzb;
    private final zzo zzc;
    private final boolean zzd;
    private final com.google.android.gms.internal.measurement.zzcv zze;
    private final zzkp zzf;

    zzkr(zzkp zzkpVar, String str, String str2, zzo zzoVar, boolean z, com.google.android.gms.internal.measurement.zzcv zzcvVar) {
        this.zzf = zzkpVar;
        this.zza = str;
        this.zzb = str2;
        this.zzc = zzoVar;
        this.zzd = z;
        this.zze = zzcvVar;
    }

    @Override
    public final void run() {
        Bundle bundle = new Bundle();
        try {
            try {
                zzfk zzfkVar = this.zzf.zzb;
                if (zzfkVar == null) {
                    this.zzf.zzj().zzg().zza("Failed to get user properties; not connected to service", this.zza, this.zzb);
                    this.zzf.zzq().zza(this.zze, bundle);
                } else {
                    Preconditions.checkNotNull(this.zzc);
                    Bundle bundleZza = zznd.zza(zzfkVar.zza(this.zza, this.zzb, this.zzd, this.zzc));
                    this.zzf.zzal();
                    this.zzf.zzq().zza(this.zze, bundleZza);
                }
            } catch (RemoteException e) {
                this.zzf.zzj().zzg().zza("Failed to get user properties; remote exception", this.zza, e);
                this.zzf.zzq().zza(this.zze, bundle);
            }
        } catch (Throwable th) {
            this.zzf.zzq().zza(this.zze, bundle);
            throw th;
        }
    }
}
