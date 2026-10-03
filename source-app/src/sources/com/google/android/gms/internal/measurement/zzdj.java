package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzdj extends zzdf.zza {
    private final String zzc;
    private final String zzd;
    private final zzcs zze;
    private final zzdf zzf;

    zzdj(zzdf zzdfVar, String str, String str2, zzcs zzcsVar) {
        super(zzdfVar);
        this.zzf = zzdfVar;
        this.zzc = str;
        this.zzd = str2;
        this.zze = zzcsVar;
    }

    @Override
    protected final void zzb() {
        this.zze.zza((Bundle) null);
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzf.zzj)).getConditionalUserProperties(this.zzc, this.zzd, this.zze);
    }
}
