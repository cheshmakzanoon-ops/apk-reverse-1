package com.google.android.gms.internal.play_billing;

import java.util.Map;

final class zzge implements Map.Entry {
    private final Map.Entry zza;

    @Override
    public final Object getKey() {
        return this.zza.getKey();
    }

    @Override
    public final Object getValue() {
        if (((zzgh) this.zza.getValue()) == null) {
            return null;
        }
        throw null;
    }

    @Override
    public final Object setValue(Object obj) {
        if (obj instanceof zzhb) {
            return ((zzgh) this.zza.getValue()).zzc((zzhb) obj);
        }
        throw new IllegalArgumentException("LazyField now only used for MessageSet, and the value of MessageSet must be an instance of MessageLite");
    }

    public final zzgh zza() {
        return (zzgh) this.zza.getValue();
    }
}
