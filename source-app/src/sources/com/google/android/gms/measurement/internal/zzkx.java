package com.google.android.gms.measurement.internal;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzkx implements Runnable {
    private final zzo zza;
    private final com.google.android.gms.internal.measurement.zzcv zzb;
    private final zzkp zzc;

    zzkx(zzkp zzkpVar, zzo zzoVar, com.google.android.gms.internal.measurement.zzcv zzcvVar) {
        this.zzc = zzkpVar;
        this.zza = zzoVar;
        this.zzb = zzcvVar;
    }

    @Override
    public final void run() {
        try {
            try {
                if (!this.zzc.zzk().zzm().zzh()) {
                    this.zzc.zzj().zzv().zza("Analytics storage consent denied; will not get app instance id");
                    this.zzc.zzm().zza((String) null);
                    this.zzc.zzk().zze.zza(null);
                    this.zzc.zzq().zza(this.zzb, (String) null);
                    return;
                }
                zzfk zzfkVar = this.zzc.zzb;
                if (zzfkVar == null) {
                    this.zzc.zzj().zzg().zza("Failed to get app instance id");
                    this.zzc.zzq().zza(this.zzb, (String) null);
                    return;
                }
                Preconditions.checkNotNull(this.zza);
                String strZzb = zzfkVar.zzb(this.zza);
                if (strZzb != null) {
                    this.zzc.zzm().zza(strZzb);
                    this.zzc.zzk().zze.zza(strZzb);
                }
                this.zzc.zzal();
                this.zzc.zzq().zza(this.zzb, strZzb);
            } catch (RemoteException e) {
                this.zzc.zzj().zzg().zza("Failed to get app instance id", e);
                this.zzc.zzq().zza(this.zzb, (String) null);
            }
        } catch (Throwable th) {
            this.zzc.zzq().zza(this.zzb, (String) null);
            throw th;
        }
    }
}
