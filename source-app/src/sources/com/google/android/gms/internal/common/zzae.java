package com.google.android.gms.internal.common;

final class zzae extends zzz {
    private final zzah zza;

    zzae(zzah zzahVar, int i) {
        super(zzahVar.size(), i);
        this.zza = zzahVar;
    }

    @Override
    protected final Object zza(int i) {
        return this.zza.get(i);
    }
}
