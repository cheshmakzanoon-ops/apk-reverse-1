package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzdz extends zzdf.zza {
    private final String zzc;
    private final String zzd;
    private final boolean zze;
    private final zzcs zzf;
    private final zzdf zzg;

    zzdz(zzdf zzdfVar, String str, String str2, boolean z, zzcs zzcsVar) {
        super(zzdfVar);
        this.zzg = zzdfVar;
        this.zzc = str;
        this.zzd = str2;
        this.zze = z;
        this.zzf = zzcsVar;
    }

    @Override
    protected final void zzb() {
        this.zzf.zza((Bundle) null);
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzg.zzj)).getUserProperties(this.zzc, this.zzd, this.zze, this.zzf);
    }
}
