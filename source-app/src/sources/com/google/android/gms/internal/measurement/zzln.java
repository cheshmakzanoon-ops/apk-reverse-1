package com.google.android.gms.internal.measurement;

import java.util.Map;

final class zzln<K, V> implements Comparable<zzln>, Map.Entry<K, V> {

    private final Comparable zza;
    private V zzb;
    private final zzlg zzc;

    @Override
    public final int compareTo(zzln zzlnVar) {
        return ((Comparable) getKey()).compareTo((Comparable) zzlnVar.getKey());
    }

    @Override
    public final int hashCode() {
        Comparable comparable = this.zza;
        int iHashCode = comparable == null ? 0 : comparable.hashCode();
        V v = this.zzb;
        return iHashCode ^ (v != null ? v.hashCode() : 0);
    }

    @Override
    public final Object getKey() {
        return this.zza;
    }

    @Override
    public final V getValue() {
        return this.zzb;
    }

    @Override
    public final V setValue(V v) {
        this.zzc.zzg();
        V v2 = this.zzb;
        this.zzb = v;
        return v2;
    }

    public final String toString() {
        return String.valueOf(this.zza) + "=" + String.valueOf(this.zzb);
    }

    zzln(zzlg zzlgVar, Map.Entry<K, V> entry) {
        this(zzlgVar, (Comparable) entry.getKey(), entry.getValue());
    }

    zzln(zzlg zzlgVar, K k, V v) {
        this.zzc = zzlgVar;
        this.zza = k;
        this.zzb = v;
    }

    @Override
    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof Map.Entry)) {
            return false;
        }
        Map.Entry entry = (Map.Entry) obj;
        return zza(this.zza, entry.getKey()) && zza(this.zzb, entry.getValue());
    }

    private static boolean zza(Object obj, Object obj2) {
        if (obj == null) {
            return obj2 == null;
        }
        return obj.equals(obj2);
    }
}
