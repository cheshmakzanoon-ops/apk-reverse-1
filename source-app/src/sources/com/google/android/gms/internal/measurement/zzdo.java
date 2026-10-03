package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzdo extends zzdf.zza {
    private final Boolean zzc;
    private final zzdf zzd;

    zzdo(zzdf zzdfVar, Boolean bool) {
        super(zzdfVar);
        this.zzd = zzdfVar;
        this.zzc = bool;
    }

    @Override
    final void zza() throws RemoteException {
        if (this.zzc != null) {
            ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).setMeasurementEnabled(this.zzc.booleanValue(), this.zza);
        } else {
            ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).clearMeasurementEnabled(this.zza);
        }
    }
}
