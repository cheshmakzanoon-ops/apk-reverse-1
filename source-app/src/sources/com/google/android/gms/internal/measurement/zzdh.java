package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzdh extends zzdf.zza {
    private final Bundle zzc;
    private final zzdf zzd;

    zzdh(zzdf zzdfVar, Bundle bundle) {
        super(zzdfVar);
        this.zzd = zzdfVar;
        this.zzc = bundle;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzd.zzj)).setConditionalUserProperty(this.zzc, this.zza);
    }
}
