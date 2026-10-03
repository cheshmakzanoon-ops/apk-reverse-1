package com.google.android.gms.internal.measurement;

import java.util.Iterator;
import java.util.Map;

final class zzjo<K> implements Iterator<Map.Entry<K, Object>> {
    private Iterator<Map.Entry<K, Object>> zza;

    @Override
    public final Object next() {
        Map.Entry<K, Object> next = this.zza.next();
        return next.getValue() instanceof zzjj ? new zzjm(next) : next;
    }

    public zzjo(Iterator<Map.Entry<K, Object>> it) {
        this.zza = it;
    }

    @Override
    public final void remove() {
        this.zza.remove();
    }

    @Override
    public final boolean hasNext() {
        return this.zza.hasNext();
    }
}
