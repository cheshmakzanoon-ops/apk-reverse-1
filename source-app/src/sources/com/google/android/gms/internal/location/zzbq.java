package com.google.android.gms.internal.location;

final class zzbq<E> extends zzbo<E> {
    private final zzbs<E> zza;

    zzbq(zzbs<E> zzbsVar, int i) {
        super(zzbsVar.size(), i);
        this.zza = zzbsVar;
    }

    @Override
    protected final E zza(int i) {
        return this.zza.get(i);
    }
}
