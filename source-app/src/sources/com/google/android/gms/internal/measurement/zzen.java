package com.google.android.gms.internal.measurement;

import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.dynamic.ObjectWrapper;

final class zzen extends zzdf.zza {
    private final String zzc;
    private final String zzd;
    private final Object zze;
    private final boolean zzf;
    private final zzdf zzg;

    zzen(zzdf zzdfVar, String str, String str2, Object obj, boolean z) {
        super(zzdfVar);
        this.zzg = zzdfVar;
        this.zzc = str;
        this.zzd = str2;
        this.zze = obj;
        this.zzf = z;
    }

    @Override
    final void zza() throws RemoteException {
        ((zzcu) Preconditions.checkNotNull(this.zzg.zzj)).setUserProperty(this.zzc, this.zzd, ObjectWrapper.wrap(this.zze), this.zzf, this.zza);
    }
}
