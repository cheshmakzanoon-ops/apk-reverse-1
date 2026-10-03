package com.google.android.gms.internal.measurement;

import java.util.AbstractSet;
import java.util.Iterator;
import java.util.Map;

class zzls<K, V> extends AbstractSet<Map.Entry<K, V>> {
    private final zzlg zza;

    @Override
    public int size() {
        return this.zza.size();
    }

    @Override
    public Iterator<Map.Entry<K, V>> iterator() {
        return new zzlq(this.zza);
    }

    private zzls(zzlg zzlgVar) {
        this.zza = zzlgVar;
    }

    @Override
    public void clear() {
        this.zza.clear();
    }

    @Override
    public boolean add(Object obj) {
        Map.Entry entry = (Map.Entry) obj;
        if (contains(entry)) {
            return false;
        }
        this.zza.put((Comparable) entry.getKey(), entry.getValue());
        return true;
    }

    @Override
    public boolean contains(Object obj) {
        Map.Entry entry = (Map.Entry) obj;
        Object obj2 = this.zza.get(entry.getKey());
        Object value = entry.getValue();
        if (obj2 != value) {
            return obj2 != null && obj2.equals(value);
        }
        return true;
    }

    @Override
    public boolean remove(Object obj) {
        Map.Entry entry = (Map.Entry) obj;
        if (!contains(entry)) {
            return false;
        }
        this.zza.remove(entry.getKey());
        return true;
    }
}
