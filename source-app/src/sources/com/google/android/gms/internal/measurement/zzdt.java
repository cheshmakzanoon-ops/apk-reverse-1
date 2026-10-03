package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzdt extends zzdf.zza {
    private final String zzc;
    private final zzdf zzd;

    zzdt(zzdf zzdfVar, String str) {
        super(zzdfVar);
        this.zzd = zzdfVar;
        this.zzc = str;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).endAdUnitExposure(this.zzc, this.zzb);
    }
}
