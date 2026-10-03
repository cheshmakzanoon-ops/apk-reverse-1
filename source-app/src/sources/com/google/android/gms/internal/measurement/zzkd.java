package com.google.android.gms.internal.measurement;

import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

public final class zzkd<K, V> extends LinkedHashMap<K, V> {
    private static final zzkd<?, ?> zza;
    private boolean zzb;

    private static int zza(Object obj) {
        if (obj instanceof byte[]) {
            return zziz.zza((byte[]) obj);
        }
        if (obj instanceof zzjc) {
            throw new UnsupportedOperationException();
        }
        return obj.hashCode();
    }

    @Override
    public final int hashCode() {
        int iZza = 0;
        for (Map.Entry<K, V> entry : entrySet()) {
            iZza += zza(entry.getValue()) ^ zza(entry.getKey());
        }
        return iZza;
    }

    public static <K, V> zzkd<K, V> zza() {
        return (zzkd<K, V>) zza;
    }

    public final zzkd<K, V> zzb() {
        return isEmpty() ? new zzkd<>() : new zzkd<>(this);
    }

    @Override
    public final V put(K k, V v) {
        zze();
        zziz.zza(k);
        zziz.zza(v);
        return (V) super.put(k, v);
    }

    @Override
    public final V remove(Object obj) {
        zze();
        return (V) super.remove(obj);
    }

    @Override
    public final Set<Map.Entry<K, V>> entrySet() {
        return isEmpty() ? Collections.emptySet() : super.entrySet();
    }

    static {
        zzkd<?, ?> zzkdVar = new zzkd<>();
        zza = zzkdVar;
        ((zzkd) zzkdVar).zzb = false;
    }

    private zzkd() {
        this.zzb = true;
    }

    private zzkd(Map<K, V> map) {
        super(map);
        this.zzb = true;
    }

    @Override
    public final void clear() {
        zze();
        super.clear();
    }

    private final void zze() {
        if (!this.zzb) {
            throw new UnsupportedOperationException();
        }
    }

    public final void zzc() {
        this.zzb = false;
    }

    public final void zza(zzkd<K, V> zzkdVar) {
        zze();
        if (zzkdVar.isEmpty()) {
            return;
        }
        putAll(zzkdVar);
    }

    @Override
    public final void putAll(Map<? extends K, ? extends V> map) {
        zze();
        for (K k : map.keySet()) {
            zziz.zza(k);
            zziz.zza(map.get(k));
        }
        super.putAll(map);
    }

    @Override
    public final boolean equals(Object obj) {
        boolean zEquals;
        if (!(obj instanceof Map)) {
            return false;
        }
        Map map = (Map) obj;
        if (this == map) {
            return true;
        }
        if (size() != map.size()) {
            return false;
        }
        for (Map.Entry<K, V> entry : entrySet()) {
            if (!map.containsKey(entry.getKey())) {
                return false;
            }
            V value = entry.getValue();
            Object obj2 = map.get(entry.getKey());
            if ((value instanceof byte[]) && (obj2 instanceof byte[])) {
                zEquals = Arrays.equals((byte[]) value, (byte[]) obj2);
            } else {
                zEquals = value.equals(obj2);
            }
            if (!zEquals) {
                return false;
            }
        }
        return true;
    }

    public final boolean zzd() {
        return this.zzb;
    }
}
