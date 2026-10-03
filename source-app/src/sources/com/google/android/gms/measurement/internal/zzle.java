package com.google.android.gms.measurement.internal;

import android.os.RemoteException;

final class zzle implements Runnable {
    private final zzbg zza;
    private final String zzb;
    private final com.google.android.gms.internal.measurement.zzcv zzc;
    private final zzkp zzd;

    zzle(zzkp zzkpVar, zzbg zzbgVar, String str, com.google.android.gms.internal.measurement.zzcv zzcvVar) {
        this.zzd = zzkpVar;
        this.zza = zzbgVar;
        this.zzb = str;
        this.zzc = zzcvVar;
    }

    @Override
    public final void run() {
        try {
            try {
                zzfk zzfkVar = this.zzd.zzb;
                if (zzfkVar == null) {
                    this.zzd.zzj().zzg().zza("Discarding data. Failed to send event to service to bundle");
                    this.zzd.zzq().zza(this.zzc, (byte[]) null);
                } else {
                    byte[] bArrZza = zzfkVar.zza(this.zza, this.zzb);
                    this.zzd.zzal();
                    this.zzd.zzq().zza(this.zzc, bArrZza);
                }
            } catch (RemoteException e) {
                this.zzd.zzj().zzg().zza("Failed to send event to the service to bundle", e);
                this.zzd.zzq().zza(this.zzc, (byte[]) null);
            }
        } catch (Throwable th) {
            this.zzd.zzq().zza(this.zzc, (byte[]) null);
            throw th;
        }
    }
}
