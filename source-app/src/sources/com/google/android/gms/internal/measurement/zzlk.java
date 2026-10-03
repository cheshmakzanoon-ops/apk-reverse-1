package com.google.android.gms.internal.measurement;

import java.util.Iterator;
import java.util.Map;

final class zzlk extends zzls {
    private final zzlg zza;

    @Override
    public final Iterator<Map.Entry<K, V>> iterator() {
        return new zzli(this.zza);
    }

    private zzlk(zzlg zzlgVar) {
        super(zzlgVar);
        this.zza = zzlgVar;
    }
}
