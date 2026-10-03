package com.google.android.gms.internal.play_billing;

import j$.util.Objects;
import java.util.Iterator;
import java.util.Map;

final class zzhq implements Iterator {
    final zzht zza;
    private int zzb;
    private boolean zzc;
    private Iterator zzd;

    zzhq(zzht zzhtVar, zzhs zzhsVar) {
        Objects.requireNonNull(zzhtVar);
        this.zza = zzhtVar;
        this.zzb = -1;
    }

    private final Iterator zza() {
        if (this.zzd == null) {
            this.zzd = this.zza.zzc.entrySet().iterator();
        }
        return this.zzd;
    }

    @Override
    public final boolean hasNext() {
        int i = this.zzb + 1;
        zzht zzhtVar = this.zza;
        if (i >= zzhtVar.zzb) {
            return !zzhtVar.zzc.isEmpty() && zza().hasNext();
        }
        return true;
    }

    @Override
    public final Object next() {
        this.zzc = true;
        int i = this.zzb + 1;
        this.zzb = i;
        zzht zzhtVar = this.zza;
        return i < zzhtVar.zzb ? (zzhp) zzhtVar.zza[i] : (Map.Entry) zza().next();
    }

    @Override
    public final void remove() {
        if (!this.zzc) {
            throw new IllegalStateException("remove() was called before next()");
        }
        this.zzc = false;
        zzht zzhtVar = this.zza;
        zzhtVar.zzo();
        int i = this.zzb;
        if (i >= zzhtVar.zzb) {
            zza().remove();
        } else {
            this.zzb = i - 1;
            zzhtVar.zzm(i);
        }
    }
}
