package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzeh extends zzdf.zza {
    private final boolean zzc;
    private final zzdf zzd;

    zzeh(zzdf zzdfVar, boolean z) {
        super(zzdfVar);
        this.zzd = zzdfVar;
        this.zzc = z;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).setDataCollectionEnabled(this.zzc);
    }
}
