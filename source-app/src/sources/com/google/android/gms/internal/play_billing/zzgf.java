package com.google.android.gms.internal.play_billing;

import java.util.Iterator;
import java.util.Map;

final class zzgf implements Iterator {
    private final Iterator zza;

    public zzgf(Iterator it) {
        this.zza = it;
    }

    @Override
    public final boolean hasNext() {
        return this.zza.hasNext();
    }

    @Override
    public final Object next() {
        Map.Entry entry = (Map.Entry) this.zza.next();
        return entry.getValue() instanceof zzgh ? new zzge(entry, null) : entry;
    }

    @Override
    public final void remove() {
        this.zza.remove();
    }
}
