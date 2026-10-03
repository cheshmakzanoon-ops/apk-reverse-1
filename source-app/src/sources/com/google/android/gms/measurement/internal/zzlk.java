package com.google.android.gms.measurement.internal;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;
import java.util.ArrayList;

final class zzlk implements Runnable {
    private final String zza;
    private final String zzb;
    private final zzo zzc;
    private final com.google.android.gms.internal.measurement.zzcv zzd;
    private final zzkp zze;

    zzlk(zzkp zzkpVar, String str, String str2, zzo zzoVar, com.google.android.gms.internal.measurement.zzcv zzcvVar) {
        this.zze = zzkpVar;
        this.zza = str;
        this.zzb = str2;
        this.zzc = zzoVar;
        this.zzd = zzcvVar;
    }

    @Override
    public final void run() {
        ArrayList<Bundle> arrayList = new ArrayList<>();
        try {
            try {
                zzfk zzfkVar = this.zze.zzb;
                if (zzfkVar == null) {
                    this.zze.zzj().zzg().zza("Failed to get conditional properties; not connected to service", this.zza, this.zzb);
                    this.zze.zzq().zza(this.zzd, arrayList);
                } else {
                    Preconditions.checkNotNull(this.zzc);
                    ArrayList<Bundle> arrayListZzb = zznd.zzb(zzfkVar.zza(this.zza, this.zzb, this.zzc));
                    this.zze.zzal();
                    this.zze.zzq().zza(this.zzd, arrayListZzb);
                }
            } catch (RemoteException e) {
                this.zze.zzj().zzg().zza("Failed to get conditional properties; remote exception", this.zza, this.zzb, e);
                this.zze.zzq().zza(this.zzd, arrayList);
            }
        } catch (Throwable th) {
            this.zze.zzq().zza(this.zzd, arrayList);
            throw th;
        }
    }
}
