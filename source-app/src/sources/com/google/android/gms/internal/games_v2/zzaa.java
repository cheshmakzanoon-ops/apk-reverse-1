package com.google.android.gms.internal.games_v2;

import j$.util.Objects;

final class zzaa implements Runnable {
    final zzab zza;

    zzaa(zzab zzabVar) {
        Objects.requireNonNull(zzabVar);
        this.zza = zzabVar;
    }

    @Override
    public final void run() {
        this.zza.zzd();
    }
}
