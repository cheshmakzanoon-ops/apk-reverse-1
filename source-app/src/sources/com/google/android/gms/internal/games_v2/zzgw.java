package com.google.android.gms.internal.games_v2;

import java.util.Arrays;

class zzgw extends zzgx {
    Object[] zza;
    int zzb;
    boolean zzc;

    zzgw(int i) {
        zzgn.zzb(i, "initialCapacity");
        this.zza = new Object[i];
        this.zzb = 0;
    }

    private final void zzd(int i) {
        int length = this.zza.length;
        int iZzc = zzc(length, this.zzb + i);
        if (iZzc > length || this.zzc) {
            this.zza = Arrays.copyOf(this.zza, iZzc);
            this.zzc = false;
        }
    }

    final void zzb(Object[] objArr, int i) {
        zzhs.zza(objArr, i);
        zzd(i);
        System.arraycopy(objArr, 0, this.zza, this.zzb, i);
        this.zzb += i;
    }

    public final zzgw zza(Object obj) {
        obj.getClass();
        zzd(1);
        Object[] objArr = this.zza;
        int i = this.zzb;
        this.zzb = i + 1;
        objArr[i] = obj;
        return this;
    }
}
