package com.google.android.gms.internal.play_billing;

import java.util.Arrays;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

public final class zzgv extends LinkedHashMap {
    private static final zzgv zza;
    private boolean zzb;

    static {
        zzgv zzgvVar = new zzgv();
        zza = zzgvVar;
        zzgvVar.zzb = false;
    }

    private zzgv() {
        this.zzb = true;
    }

    public static zzgv zza() {
        return zza;
    }

    private static int zzf(Object obj) {
        if (!(obj instanceof byte[])) {
            if (obj instanceof zzfw) {
                throw new UnsupportedOperationException();
            }
            return obj.hashCode();
        }
        byte[] bArr = (byte[]) obj;
        byte[] bArr2 = zzga.zzb;
        int length = bArr.length;
        int iZzb = zzga.zzb(length, bArr, 0, length);
        if (iZzb == 0) {
            return 1;
        }
        return iZzb;
    }

    private final void zzg() {
        if (!this.zzb) {
            throw new UnsupportedOperationException();
        }
    }

    @Override
    public final void clear() {
        zzg();
        super.clear();
    }

    @Override
    public final Set entrySet() {
        return isEmpty() ? Collections.emptySet() : super.entrySet();
    }

    @Override
    public final boolean equals(Object obj) {
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
        Iterator it = entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry entry = (Map.Entry) it.next();
            if (!map.containsKey(entry.getKey())) {
                return false;
            }
            Object value = entry.getValue();
            Object obj2 = map.get(entry.getKey());
            if (!(((value instanceof byte[]) && (obj2 instanceof byte[])) ? Arrays.equals((byte[]) value, (byte[]) obj2) : value.equals(obj2))) {
                return false;
            }
        }
        return true;
    }

    @Override
    public final int hashCode() {
        Iterator it = entrySet().iterator();
        int iZzf = 0;
        while (it.hasNext()) {
            Map.Entry entry = (Map.Entry) it.next();
            iZzf += zzf(entry.getValue()) ^ zzf(entry.getKey());
        }
        return iZzf;
    }

    @Override
    public final Object put(Object obj, Object obj2) {
        zzg();
        byte[] bArr = zzga.zzb;
        obj.getClass();
        obj2.getClass();
        return super.put(obj, obj2);
    }

    @Override
    public final void putAll(Map map) {
        zzg();
        for (Object obj : map.keySet()) {
            byte[] bArr = zzga.zzb;
            obj.getClass();
            map.get(obj).getClass();
        }
        super.putAll(map);
    }

    @Override
    public final Object remove(Object obj) {
        zzg();
        return super.remove(obj);
    }

    public final zzgv zzb() {
        return isEmpty() ? new zzgv() : new zzgv(this);
    }

    public final void zzc() {
        this.zzb = false;
    }

    public final void zzd(zzgv zzgvVar) {
        zzg();
        if (zzgvVar.isEmpty()) {
            return;
        }
        putAll(zzgvVar);
    }

    public final boolean zze() {
        return this.zzb;
    }

    private zzgv(Map map) {
        super(map);
        this.zzb = true;
    }
}
