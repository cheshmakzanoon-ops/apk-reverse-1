package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzdy extends zzdf.zza {
    private final zzcs zzc;
    private final zzdf zzd;

    zzdy(zzdf zzdfVar, zzcs zzcsVar) {
        super(zzdfVar);
        this.zzd = zzdfVar;
        this.zzc = zzcsVar;
    }

    @Override
    protected final void zzb() {
        this.zzc.zza((Bundle) null);
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).generateEventId(this.zzc);
    }
}
