package com.google.android.gms.internal.measurement;

import android.app.Activity;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.dynamic.ObjectWrapper;

final class zzep extends zzdf.zza {
    private final Activity zzc;
    private final zzdf.zzd zzd;

    zzep(zzdf.zzd zzdVar, Activity activity) {
        super(zzdf.this);
        this.zzd = zzdVar;
        this.zzc = activity;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(zzdf.this.zzj)).onActivityResumed(ObjectWrapper.wrap(this.zzc), this.zzb);
    }
}
