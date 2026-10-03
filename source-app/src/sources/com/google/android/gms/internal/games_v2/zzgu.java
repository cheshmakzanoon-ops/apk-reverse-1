package com.google.android.gms.internal.games_v2;

import java.io.Serializable;

abstract class zzgu implements Comparable, Serializable {
    final Comparable zza = "";

    zzgu(Comparable comparable) {
    }

    public final boolean equals(Object obj) {
        if (obj instanceof zzgu) {
            try {
                if (compareTo((zzgu) obj) == 0) {
                    return true;
                }
            } catch (ClassCastException unused) {
            }
        }
        return false;
    }

    public abstract int hashCode();

    abstract void zza(StringBuilder sb);

    abstract void zzb(StringBuilder sb);

    @Override
    public int compareTo(zzgu zzguVar) {
        if (zzguVar == zzgt.zzb) {
            return 1;
        }
        if (zzguVar == zzgr.zzb) {
            return -1;
        }
        Comparable comparable = zzguVar.zza;
        int i = zzhw.zzc;
        int iCompareTo = "".compareTo("");
        return iCompareTo != 0 ? iCompareTo : Boolean.compare(this instanceof zzgs, zzguVar instanceof zzgs);
    }
}
