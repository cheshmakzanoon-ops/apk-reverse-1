package com.google.android.gms.internal.play_billing;

final class zzbu extends zzbq {
    private final zzbw zza;

    zzbu(zzbw zzbwVar, int i) {
        super(zzbwVar.size(), i);
        this.zza = zzbwVar;
    }

    @Override
    protected final Object zza(int i) {
        return this.zza.get(i);
    }
}
