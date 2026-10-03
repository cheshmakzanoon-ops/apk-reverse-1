package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzee extends zzdf.zza {
    private final zzdf.zzc zzc;
    private final zzdf zzd;

    zzee(zzdf zzdfVar, zzdf.zzc zzcVar) {
        super(zzdfVar);
        this.zzd = zzdfVar;
        this.zzc = zzcVar;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).setEventInterceptor(this.zzc);
    }
}
