package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzdp extends zzdf.zza {
    private final zzdf zzc;

    zzdp(zzdf zzdfVar) {
        super(zzdfVar);
        this.zzc = zzdfVar;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzc.zzj)).resetAnalyticsData(this.zza);
    }
}
