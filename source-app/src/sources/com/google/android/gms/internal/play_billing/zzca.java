package com.google.android.gms.internal.play_billing;

import java.util.Set;

public abstract class zzca extends zzbt implements Set, j$.util.Set {
    private transient zzbw zza;

    zzca() {
    }

    @Override
    public final boolean equals(Object obj) {
        if (obj == this || obj == this) {
            return true;
        }
        if (obj instanceof Set) {
            Set set = (Set) obj;
            try {
                if (size() == set.size() && containsAll(set)) {
                    return true;
                }
            } catch (ClassCastException | NullPointerException unused) {
            }
        }
        return false;
    }

    @Override
    public final int hashCode() {
        return zzcj.zza(this);
    }

    @Override
    public zzbw zzd() {
        zzbw zzbwVar = this.zza;
        if (zzbwVar != null) {
            return zzbwVar;
        }
        zzbw zzbwVarZzh = zzh();
        this.zza = zzbwVarZzh;
        return zzbwVarZzh;
    }

    @Override
    public abstract zzck iterator();

    zzbw zzh() {
        Object[] array = toArray();
        int i = zzbw.zzd;
        return zzbw.zzi(array, array.length);
    }
}
