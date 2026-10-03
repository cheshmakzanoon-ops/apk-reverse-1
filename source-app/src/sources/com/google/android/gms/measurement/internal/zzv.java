package com.google.android.gms.measurement.internal;

import androidx.collection.ArrayMap;
import com.google.android.gms.internal.measurement.zzob;
import java.util.ArrayList;
import java.util.BitSet;
import java.util.Collections;
import java.util.List;
import java.util.Map;

final class zzv {
    private String zza;
    private boolean zzb;
    private com.google.android.gms.internal.measurement.zzfi.zzl zzc;
    private BitSet zzd;
    private BitSet zze;
    private Map<Integer, Long> zzf;
    private Map<Integer, List<Long>> zzg;
    private final zzt zzh;

    final com.google.android.gms.internal.measurement.zzfi.zzc zza(int i) {
        ArrayList arrayList;
        ?? arrayList2;
        ?? Zzb = com.google.android.gms.internal.measurement.zzfi.zzc.zzb();
        Zzb.zza(i);
        Zzb.zza(this.zzb);
        com.google.android.gms.internal.measurement.zzfi.zzl zzlVar = this.zzc;
        if (zzlVar != null) {
            Zzb.zza(zzlVar);
        }
        ?? Zzd = com.google.android.gms.internal.measurement.zzfi.zzl.zze().zzb(zzmz.zza(this.zzd)).zzd(zzmz.zza(this.zze));
        if (this.zzf == null) {
            arrayList = null;
        } else {
            arrayList = new ArrayList(this.zzf.size());
            for (Integer num : this.zzf.keySet()) {
                int iIntValue = num.intValue();
                Long l = this.zzf.get(num);
                if (l != null) {
                    arrayList.add((com.google.android.gms.internal.measurement.zzfi.zzd) ((com.google.android.gms.internal.measurement.zzix) com.google.android.gms.internal.measurement.zzfi.zzd.zzc().zza(iIntValue).zza(l.longValue()).zzab()));
                }
            }
        }
        if (arrayList != null) {
            Zzd.zza(arrayList);
        }
        if (this.zzg == null) {
            arrayList2 = Collections.emptyList();
        } else {
            arrayList2 = new ArrayList(this.zzg.size());
            for (Integer num2 : this.zzg.keySet()) {
                com.google.android.gms.internal.measurement.zzfi.zzm.zza zzaVarZza = com.google.android.gms.internal.measurement.zzfi.zzm.zzc().zza(num2.intValue());
                List<Long> list = this.zzg.get(num2);
                if (list != null) {
                    Collections.sort(list);
                    zzaVarZza.zza(list);
                }
                arrayList2.add((com.google.android.gms.internal.measurement.zzfi.zzm) ((com.google.android.gms.internal.measurement.zzix) zzaVarZza.zzab()));
            }
        }
        Zzd.zzc(arrayList2);
        Zzb.zza(Zzd);
        return (com.google.android.gms.internal.measurement.zzfi.zzc) ((com.google.android.gms.internal.measurement.zzix) Zzb.zzab());
    }

    private zzv(zzt zztVar, String str) {
        this.zzh = zztVar;
        this.zza = str;
        this.zzb = true;
        this.zzd = new BitSet();
        this.zze = new BitSet();
        this.zzf = new ArrayMap();
        this.zzg = new ArrayMap();
    }

    private zzv(zzt zztVar, String str, com.google.android.gms.internal.measurement.zzfi.zzl zzlVar, BitSet bitSet, BitSet bitSet2, Map<Integer, Long> map, Map<Integer, Long> map2) {
        this.zzh = zztVar;
        this.zza = str;
        this.zzd = bitSet;
        this.zze = bitSet2;
        this.zzf = map;
        this.zzg = new ArrayMap();
        if (map2 != null) {
            for (Integer num : map2.keySet()) {
                ArrayList arrayList = new ArrayList();
                arrayList.add(map2.get(num));
                this.zzg.put(num, arrayList);
            }
        }
        this.zzb = false;
        this.zzc = zzlVar;
    }

    final void zza(zzac zzacVar) {
        int iZza = zzacVar.zza();
        if (zzacVar.zzc != null) {
            this.zze.set(iZza, zzacVar.zzc.booleanValue());
        }
        if (zzacVar.zzd != null) {
            this.zzd.set(iZza, zzacVar.zzd.booleanValue());
        }
        if (zzacVar.zze != null) {
            Long l = this.zzf.get(Integer.valueOf(iZza));
            long jLongValue = zzacVar.zze.longValue() / 1000;
            if (l == null || jLongValue > l.longValue()) {
                this.zzf.put(Integer.valueOf(iZza), Long.valueOf(jLongValue));
            }
        }
        if (zzacVar.zzf != null) {
            List<Long> arrayList = this.zzg.get(Integer.valueOf(iZza));
            if (arrayList == null) {
                arrayList = new ArrayList<>();
                this.zzg.put(Integer.valueOf(iZza), arrayList);
            }
            if (zzacVar.zzc()) {
                arrayList.clear();
            }
            if (zzob.zza() && this.zzh.zze().zzf(this.zza, zzbi.zzbg) && zzacVar.zzb()) {
                arrayList.clear();
            }
            if (zzob.zza() && this.zzh.zze().zzf(this.zza, zzbi.zzbg)) {
                long jLongValue2 = zzacVar.zzf.longValue() / 1000;
                if (arrayList.contains(Long.valueOf(jLongValue2))) {
                    return;
                }
                arrayList.add(Long.valueOf(jLongValue2));
                return;
            }
            arrayList.add(Long.valueOf(zzacVar.zzf.longValue() / 1000));
        }
    }
}
