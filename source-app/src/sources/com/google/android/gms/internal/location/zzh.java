package com.google.android.gms.internal.location;

import android.os.DeadObjectException;

final class zzh implements zzbg<zzam> {
    final zzi zza;

    zzh(zzi zziVar) {
        this.zza = zziVar;
    }

    public final zzam zza() throws DeadObjectException {
        return (zzam) this.zza.getService();
    }
}
