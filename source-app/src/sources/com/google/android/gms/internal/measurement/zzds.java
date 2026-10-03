package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzds extends zzdf.zza {
    private final long zzc;
    private final zzdf zzd;

    zzds(zzdf zzdfVar, long j) {
        super(zzdfVar);
        this.zzd = zzdfVar;
        this.zzc = j;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).setSessionTimeoutDuration(this.zzc);
    }
}
