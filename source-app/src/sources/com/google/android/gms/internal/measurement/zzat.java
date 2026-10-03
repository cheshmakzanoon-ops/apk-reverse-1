package com.google.android.gms.internal.measurement;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public final class zzat implements zzaq {
    private final String zza;
    private final ArrayList<zzaq> zzb;

    public final int hashCode() {
        String str = this.zza;
        int iHashCode = (str != null ? str.hashCode() : 0) * 31;
        ArrayList<zzaq> arrayList = this.zzb;
        return iHashCode + (arrayList != null ? arrayList.hashCode() : 0);
    }

    @Override
    public final zzaq zzc() {
        return this;
    }

    @Override
    public final Iterator<zzaq> zzh() {
        return null;
    }

    @Override
    public final zzaq zza(String str, zzh zzhVar, List<zzaq> list) {
        throw new IllegalStateException("Statement is not an evaluated entity");
    }

    @Override
    public final Boolean zzd() {
        throw new IllegalStateException("Statement cannot be cast as Boolean");
    }

    @Override
    public final Double zze() {
        throw new IllegalStateException("Statement cannot be cast as Double");
    }

    public final String zza() {
        return this.zza;
    }

    @Override
    public final String zzf() {
        throw new IllegalStateException("Statement cannot be cast as String");
    }

    public final ArrayList<zzaq> zzb() {
        return this.zzb;
    }

    public zzat(String str, List<zzaq> list) {
        this.zza = str;
        ArrayList<zzaq> arrayList = new ArrayList<>();
        this.zzb = arrayList;
        arrayList.addAll(list);
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof zzat)) {
            return false;
        }
        zzat zzatVar = (zzat) obj;
        String str = this.zza;
        if (str == null ? zzatVar.zza != null : !str.equals(zzatVar.zza)) {
            return false;
        }
        ArrayList<zzaq> arrayList = this.zzb;
        ArrayList<zzaq> arrayList2 = zzatVar.zzb;
        if (arrayList != null) {
            return arrayList.equals(arrayList2);
        }
        return arrayList2 == null;
    }
}
