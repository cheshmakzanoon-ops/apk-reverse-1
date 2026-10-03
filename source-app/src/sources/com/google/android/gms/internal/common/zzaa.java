package com.google.android.gms.internal.common;

import com.google.android.gms.common.api.Api;
import java.util.Arrays;

class zzaa extends zzab {
    Object[] zza = new Object[4];
    int zzb = 0;
    boolean zzc;

    zzaa(int i) {
    }

    public final zzaa zza(Object obj) {
        int i;
        obj.getClass();
        int length = this.zza.length;
        int i2 = this.zzb;
        int i3 = i2 + 1;
        if (i3 < 0) {
            throw new IllegalArgumentException("cannot store more than Integer.MAX_VALUE elements");
        }
        if (i3 <= length) {
            i = length;
        } else {
            i = (length >> 1) + length + 1;
            if (i < i3) {
                int iHighestOneBit = Integer.highestOneBit(i2);
                i = iHighestOneBit + iHighestOneBit;
            }
            if (i < 0) {
                i = Api.BaseClientBuilder.API_PRIORITY_OTHER;
            }
        }
        if (i > length || this.zzc) {
            this.zza = Arrays.copyOf(this.zza, i);
            this.zzc = false;
        }
        Object[] objArr = this.zza;
        int i4 = this.zzb;
        this.zzb = i4 + 1;
        objArr[i4] = obj;
        return this;
    }
}
