package com.google.android.gms.internal.measurement;

import java.util.Map;

final class zzjm<K> implements Map.Entry<K, Object> {
    private Map.Entry<K, zzjj> zza;

    public final zzjj zza() {
        return this.zza.getValue();
    }

    @Override
    public final K getKey() {
        return this.zza.getKey();
    }

    @Override
    public final Object getValue() {
        if (this.zza.getValue() == null) {
            return null;
        }
        return zzjj.zza();
    }

    @Override
    public final Object setValue(Object obj) {
        if (!(obj instanceof zzkj)) {
            throw new IllegalArgumentException("LazyField now only used for MessageSet, and the value of MessageSet must be an instance of MessageLite");
        }
        return this.zza.getValue().zza((zzkj) obj);
    }

    private zzjm(Map.Entry<K, zzjj> entry) {
        this.zza = entry;
    }
}
