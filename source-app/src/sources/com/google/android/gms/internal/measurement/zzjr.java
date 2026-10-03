package com.google.android.gms.internal.measurement;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

final class zzjr extends zzjs {
    private static final Class<?> zza = Collections.unmodifiableList(Collections.emptyList()).getClass();

    private static <E> List<E> zzc(Object obj, long j) {
        return (List) zzmg.zze(obj, j);
    }

    @Override
    final <L> List<L> zza(Object obj, long j) {
        return zza(obj, j, 10);
    }

    private static <L> List<L> zza(Object obj, long j, int i) {
        Object obj2;
        List<L> arrayList;
        List<L> listZzc = zzc(obj, j);
        if (listZzc.isEmpty()) {
            if (listZzc instanceof zzjp) {
                arrayList = new zzjq(i);
            } else if ((listZzc instanceof zzkv) && (listZzc instanceof zzjf)) {
                arrayList = ((zzjf) listZzc).zza(i);
            } else {
                arrayList = new ArrayList<>(i);
            }
            zzmg.zza(obj, j, arrayList);
            return arrayList;
        }
        if (zza.isAssignableFrom(listZzc.getClass())) {
            ArrayList arrayList2 = new ArrayList(listZzc.size() + i);
            arrayList2.addAll(listZzc);
            zzmg.zza(obj, j, arrayList2);
            obj2 = arrayList2;
        } else if (listZzc instanceof zzmb) {
            zzjq zzjqVar = new zzjq(listZzc.size() + i);
            zzjqVar.addAll((zzmb) listZzc);
            zzmg.zza(obj, j, zzjqVar);
            obj2 = zzjqVar;
        } else {
            if (!(listZzc instanceof zzkv) || !(listZzc instanceof zzjf)) {
                return listZzc;
            }
            zzjf zzjfVar = (zzjf) listZzc;
            if (zzjfVar.zzc()) {
                return listZzc;
            }
            zzjf zzjfVarZza = zzjfVar.zza(listZzc.size() + i);
            zzmg.zza(obj, j, zzjfVarZza);
            return zzjfVarZza;
        }
        return (List<L>) obj2;
    }

    private zzjr() {
        super();
    }

    @Override
    final void zzb(Object obj, long j) {
        Object objUnmodifiableList;
        List list = (List) zzmg.zze(obj, j);
        if (list instanceof zzjp) {
            objUnmodifiableList = ((zzjp) list).mo25h_();
        } else {
            if (zza.isAssignableFrom(list.getClass())) {
                return;
            }
            if ((list instanceof zzkv) && (list instanceof zzjf)) {
                zzjf zzjfVar = (zzjf) list;
                if (zzjfVar.zzc()) {
                    zzjfVar.mo24i_();
                    return;
                }
                return;
            }
            objUnmodifiableList = Collections.unmodifiableList(list);
        }
        zzmg.zza(obj, j, objUnmodifiableList);
    }

    @Override
    final <E> void zza(Object obj, Object obj2, long j) {
        List listZzc = zzc(obj2, j);
        List listZza = zza(obj, j, listZzc.size());
        int size = listZza.size();
        int size2 = listZzc.size();
        if (size > 0 && size2 > 0) {
            listZza.addAll(listZzc);
        }
        if (size > 0) {
            listZzc = listZza;
        }
        zzmg.zza(obj, j, listZzc);
    }
}
