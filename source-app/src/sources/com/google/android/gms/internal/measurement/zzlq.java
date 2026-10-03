package com.google.android.gms.internal.measurement;

import java.util.Iterator;
import java.util.Map;

final class zzlq<K, V> implements Iterator<Map.Entry<K, V>> {
    private int zza;
    private boolean zzb;
    private Iterator<Map.Entry<K, V>> zzc;
    private final zzlg zzd;

    @Override
    public final Object next() {
        this.zzb = true;
        int i = this.zza + 1;
        this.zza = i;
        return i < this.zzd.zzb.size() ? (Map.Entry) this.zzd.zzb.get(this.zza) : zza().next();
    }

    private final Iterator<Map.Entry<K, V>> zza() {
        if (this.zzc == null) {
            this.zzc = this.zzd.zzc.entrySet().iterator();
        }
        return this.zzc;
    }

    private zzlq(zzlg zzlgVar) {
        this.zzd = zzlgVar;
        this.zza = -1;
    }

    @Override
    public final void remove() {
        if (!this.zzb) {
            throw new IllegalStateException("remove() was called before next()");
        }
        this.zzb = false;
        this.zzd.zzg();
        if (this.zza < this.zzd.zzb.size()) {
            zzlg zzlgVar = this.zzd;
            int i = this.zza;
            this.zza = i - 1;
            zzlgVar.zzc(i);
            return;
        }
        zza().remove();
    }

    @Override
    public final boolean hasNext() {
        return this.zza + 1 < this.zzd.zzb.size() || (!this.zzd.zzc.isEmpty() && zza().hasNext());
    }
}
