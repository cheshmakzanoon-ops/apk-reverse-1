package com.google.android.gms.internal.games_v2;

import java.io.Serializable;
import java.util.Map;
import java.util.Set;
import java.util.function.BiConsumer;
import java.util.function.BiFunction;
import java.util.function.Function;

public abstract class zzhg implements Map, Serializable, j$.util.Map {
    private transient zzhk zza;
    private transient zzhk zzb;
    private transient zzgy zzc;

    zzhg() {
    }

    @Override
    @Deprecated
    public final void clear() {
        throw new UnsupportedOperationException();
    }

    @Override
    public Object compute(Object obj, BiFunction biFunction) {
        return j$.util.Map.-CC.$default$compute(this, obj, biFunction);
    }

    @Override
    public Object computeIfAbsent(Object obj, Function function) {
        return j$.util.Map.-CC.$default$computeIfAbsent(this, obj, function);
    }

    @Override
    public Object computeIfPresent(Object obj, BiFunction biFunction) {
        return j$.util.Map.-CC.$default$computeIfPresent(this, obj, biFunction);
    }

    @Override
    public final boolean containsKey(Object obj) {
        return get(obj) != null;
    }

    @Override
    public final boolean containsValue(Object obj) {
        return values().contains(obj);
    }

    @Override
    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof Map) {
            return entrySet().equals(((Map) obj).entrySet());
        }
        return false;
    }

    @Override
    public void forEach(BiConsumer biConsumer) {
        j$.util.Map.-CC.$default$forEach(this, biConsumer);
    }

    @Override
    public abstract Object get(Object obj);

    @Override
    public final Object getOrDefault(Object obj, Object obj2) {
        Object obj3 = get(obj);
        return obj3 != null ? obj3 : obj2;
    }

    @Override
    public final int hashCode() {
        return zzih.zza(entrySet());
    }

    @Override
    public final boolean isEmpty() {
        return size() == 0;
    }

    @Override
    public final Set keySet() {
        zzhk zzhkVar = this.zzb;
        if (zzhkVar != null) {
            return zzhkVar;
        }
        zzhk zzhkVarZzc = zzc();
        this.zzb = zzhkVarZzc;
        return zzhkVarZzc;
    }

    @Override
    public Object merge(Object obj, Object obj2, BiFunction biFunction) {
        return j$.util.Map.-CC.$default$merge(this, obj, obj2, biFunction);
    }

    @Override
    @Deprecated
    public final Object put(Object obj, Object obj2) {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final void putAll(Map map) {
        throw new UnsupportedOperationException();
    }

    @Override
    public Object putIfAbsent(Object obj, Object obj2) {
        return j$.util.Map.-CC.$default$putIfAbsent(this, obj, obj2);
    }

    @Override
    @Deprecated
    public final Object remove(Object obj) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean remove(Object obj, Object obj2) {
        return j$.util.Map.-CC.$default$remove(this, obj, obj2);
    }

    @Override
    public Object replace(Object obj, Object obj2) {
        return j$.util.Map.-CC.$default$replace(this, obj, obj2);
    }

    @Override
    public boolean replace(Object obj, Object obj2, Object obj3) {
        return j$.util.Map.-CC.$default$replace(this, obj, obj2, obj3);
    }

    @Override
    public void replaceAll(BiFunction biFunction) {
        j$.util.Map.-CC.$default$replaceAll(this, biFunction);
    }

    public final String toString() {
        int size = size();
        zzgn.zzb(size, "size");
        StringBuilder sb = new StringBuilder((int) Math.min(((long) size) * 8, 1073741824L));
        sb.append('{');
        boolean z = true;
        for (Map.Entry entry : entrySet()) {
            if (!z) {
                sb.append(", ");
            }
            sb.append(entry.getKey());
            sb.append('=');
            sb.append(entry.getValue());
            z = false;
        }
        sb.append('}');
        return sb.toString();
    }

    @Override
    public final zzhk entrySet() {
        zzhk zzhkVar = this.zza;
        if (zzhkVar != null) {
            return zzhkVar;
        }
        zzhk zzhkVarZzb = zzb();
        this.zza = zzhkVarZzb;
        return zzhkVarZzb;
    }

    abstract zzhk zzb();

    abstract zzhk zzc();

    @Override
    public final zzgy values() {
        zzgy zzgyVar = this.zzc;
        if (zzgyVar != null) {
            return zzgyVar;
        }
        zzgy zzgyVarZze = zze();
        this.zzc = zzgyVarZze;
        return zzgyVarZze;
    }

    abstract zzgy zze();
}
