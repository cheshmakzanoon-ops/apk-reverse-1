package com.google.android.gms.internal.games_v2;

import java.util.Arrays;

public final class zzhf {
    Object[] zza = new Object[8];
    int zzb = 0;
    zzhe zzc;

    public final zzhf zza(Object obj, Object obj2) {
        int i = this.zzb + 1;
        Object[] objArr = this.zza;
        int length = objArr.length;
        int i2 = i + i;
        if (i2 > length) {
            this.zza = Arrays.copyOf(objArr, zzgx.zzc(length, i2));
        }
        zzgn.zza(obj, obj2);
        Object[] objArr2 = this.zza;
        int i3 = this.zzb;
        int i4 = i3 + i3;
        objArr2[i4] = obj;
        objArr2[i4 + 1] = obj2;
        this.zzb = i3 + 1;
        return this;
    }

    public final zzhg zzb() {
        zzhe zzheVar = this.zzc;
        if (zzheVar != null) {
            throw zzheVar.zza();
        }
        zzie zzieVarZzf = zzie.zzf(this.zzb, this.zza, this);
        zzhe zzheVar2 = this.zzc;
        if (zzheVar2 == null) {
            return zzieVarZzf;
        }
        throw zzheVar2.zza();
    }
}
