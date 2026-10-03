package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzeb extends zzdf.zza {
    private final Bundle zzc;
    private final zzcs zzd;
    private final zzdf zze;

    zzeb(zzdf zzdfVar, Bundle bundle, zzcs zzcsVar) {
        super(zzdfVar);
        this.zze = zzdfVar;
        this.zzc = bundle;
        this.zzd = zzcsVar;
    }

    @Override
    protected final void zzb() {
        this.zzd.zza((Bundle) null);
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zze.zzj)).performAction(this.zzc, this.zzd, this.zza);
    }
}
