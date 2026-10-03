package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzei extends zzdf.zza {
    private final zzcs zzc;
    private final int zzd;
    private final zzdf zze;

    zzei(zzdf zzdfVar, zzcs zzcsVar, int i) {
        super(zzdfVar);
        this.zze = zzdfVar;
        this.zzc = zzcsVar;
        this.zzd = i;
    }

    @Override
    protected final void zzb() {
        this.zzc.zza((Bundle) null);
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zze.zzj)).getTestFlag(this.zzc, this.zzd);
    }
}
