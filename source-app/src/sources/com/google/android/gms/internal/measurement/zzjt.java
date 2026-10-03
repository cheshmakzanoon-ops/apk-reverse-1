package com.google.android.gms.internal.measurement;

import java.util.List;

final class zzjt extends zzjs {
    private static <E> zzjf<E> zzc(Object obj, long j) {
        return (zzjf) zzmg.zze(obj, j);
    }

    @Override
    final <L> List<L> zza(Object obj, long j) {
        zzjf zzjfVarZzc = zzc(obj, j);
        if (zzjfVarZzc.zzc()) {
            return zzjfVarZzc;
        }
        int size = zzjfVarZzc.size();
        zzjf zzjfVarZza = zzjfVarZzc.zza(size == 0 ? 10 : size << 1);
        zzmg.zza(obj, j, zzjfVarZza);
        return zzjfVarZza;
    }

    private zzjt() {
        super();
    }

    @Override
    final void zzb(Object obj, long j) {
        zzc(obj, j).mo24i_();
    }

    @Override
    final <E> void zza(Object obj, Object obj2, long j) {
        zzjf zzjfVarZzc = zzc(obj, j);
        zzjf zzjfVarZzc2 = zzc(obj2, j);
        int size = zzjfVarZzc.size();
        int size2 = zzjfVarZzc2.size();
        if (size > 0 && size2 > 0) {
            if (!zzjfVarZzc.zzc()) {
                zzjfVarZzc = zzjfVarZzc.zza(size2 + size);
            }
            zzjfVarZzc.addAll(zzjfVarZzc2);
        }
        if (size > 0) {
            zzjfVarZzc2 = zzjfVarZzc;
        }
        zzmg.zza(obj, j, zzjfVarZzc2);
    }
}
