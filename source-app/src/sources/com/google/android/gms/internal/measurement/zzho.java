package com.google.android.gms.internal.measurement;

import java.util.Comparator;

final class zzho implements Comparator<zzhm> {
    @Override
    public final int compare(zzhm zzhmVar, zzhm zzhmVar2) {
        zzhm zzhmVar3 = zzhmVar;
        zzhm zzhmVar4 = zzhmVar2;
        zzhs zzhsVar = (zzhs) zzhmVar3.iterator();
        zzhs zzhsVar2 = (zzhs) zzhmVar4.iterator();
        while (zzhsVar.hasNext() && zzhsVar2.hasNext()) {
            int iCompareTo = Integer.valueOf(zzhm.zza(zzhsVar.zza())).compareTo(Integer.valueOf(zzhm.zza(zzhsVar2.zza())));
            if (iCompareTo != 0) {
                return iCompareTo;
            }
        }
        return Integer.valueOf(zzhmVar3.zzb()).compareTo(Integer.valueOf(zzhmVar4.zzb()));
    }

    zzho() {
    }
}
