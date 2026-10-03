package com.google.android.gms.games.internal;

import j$.util.Objects;

final class zzj extends com.google.android.gms.internal.games_v2.zzac {
    final zzah zza;

    zzj(zzah zzahVar) {
        Objects.requireNonNull(zzahVar);
        this.zza = zzahVar;
    }

    @Override
    public final com.google.android.gms.internal.games_v2.zzab zza() {
        return new zzt(this.zza);
    }
}
