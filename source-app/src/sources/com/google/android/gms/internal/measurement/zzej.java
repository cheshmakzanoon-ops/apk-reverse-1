package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzej extends zzdf.zza {
    private final zzdf.zzb zzc;
    private final zzdf zzd;

    zzej(zzdf zzdfVar, zzdf.zzb zzbVar) {
        super(zzdfVar);
        this.zzd = zzdfVar;
        this.zzc = zzbVar;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).registerOnMeasurementEventListener(this.zzc);
    }
}
