package com.google.android.gms.games.internal;

public final class zzao {
    private static final zzao zza = new zzao();
    private volatile boolean zzb = false;

    zzao() {
    }

    public static zzao zza() {
        return zza;
    }

    public final boolean zzb() {
        return this.zzb;
    }

    public final void zzc() {
        this.zzb = true;
    }
}
