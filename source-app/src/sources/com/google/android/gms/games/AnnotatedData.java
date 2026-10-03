package com.google.android.gms.games;

public class AnnotatedData<T> {
    private final Object zza;
    private final boolean zzb;

    public AnnotatedData(Object obj, boolean z) {
        this.zza = obj;
        this.zzb = z;
    }

    public T get() {
        return (T) this.zza;
    }

    public boolean isStale() {
        return this.zzb;
    }
}
