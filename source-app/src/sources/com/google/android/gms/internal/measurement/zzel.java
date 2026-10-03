package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.RemoteException;
import com.google.android.gms.common.internal.Preconditions;

final class zzel extends zzdf.zza {
    private final Long zzc;
    private final String zzd;
    private final String zze;
    private final Bundle zzf;
    private final boolean zzg;
    private final boolean zzh;
    private final zzdf zzi;

    zzel(zzdf zzdfVar, Long l, String str, String str2, Bundle bundle, boolean z, boolean z2) {
        super(zzdfVar);
        this.zzi = zzdfVar;
        this.zzc = l;
        this.zzd = str;
        this.zze = str2;
        this.zzf = bundle;
        this.zzg = z;
        this.zzh = z2;
    }

    @Override
    final void zza() throws RemoteException {
        Long l = this.zzc;
        ((zzcu) Preconditions.checkNotNull(this.zzi.zzj)).logEvent(this.zzd, this.zze, this.zzf, this.zzg, this.zzh, l == null ? this.zza : l.longValue());
    }
}
