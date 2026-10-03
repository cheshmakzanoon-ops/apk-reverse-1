package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.dynamic.ObjectWrapper;

final class zzec extends zzdf.zza {
    private final String zzd;
    private final Object zze;
    private final zzdf zzh;
    private final int zzc = 5;
    private final Object zzf = null;
    private final Object zzg = null;

    zzec(zzdf zzdfVar, boolean z, int i, String str, Object obj, Object obj2, Object obj3) {
        super(false);
        this.zzh = zzdfVar;
        this.zzd = str;
        this.zze = obj;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzh.zzj)).logHealthData(this.zzc, this.zzd, ObjectWrapper.wrap(this.zze), ObjectWrapper.wrap(null), ObjectWrapper.wrap(null));
    }
}
