package com.google.android.gms.internal.games_v2;

final class zzha extends zzfy {
    private final zzhd zza;

    zzha(zzhd zzhdVar, int i) {
        super(zzhdVar.size(), i);
        this.zza = zzhdVar;
    }

    @Override
    protected final Object zza(int i) {
        return this.zza.get(i);
    }
}
