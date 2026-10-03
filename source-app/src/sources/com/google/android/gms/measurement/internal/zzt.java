package com.google.android.gms.measurement.internal;

import android.content.ContentValues;
import android.database.sqlite.SQLiteException;
import androidx.collection.ArrayMap;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.internal.measurement.zzob;
import java.util.ArrayList;
import java.util.BitSet;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

final class zzt extends zzmo {
    private String zza;
    private Set<Integer> zzb;
    private Map<Integer, zzv> zzc;
    private Long zzd;
    private Long zze;

    private final zzv zza(Integer num) {
        if (this.zzc.containsKey(num)) {
            return this.zzc.get(num);
        }
        zzv zzvVar = new zzv(this, this.zza);
        this.zzc.put(num, zzvVar);
        return zzvVar;
    }

    @Override
    protected final boolean zzc() {
        return false;
    }

    final List<com.google.android.gms.internal.measurement.zzfi.zzc> zza(String str, List<com.google.android.gms.internal.measurement.zzfi.zze> list, List<com.google.android.gms.internal.measurement.zzfi.zzn> list2, Long l, Long l2) {
        boolean z;
        zzbc zzbcVar;
        zzx zzxVar;
        Map map;
        Map map2;
        List<com.google.android.gms.internal.measurement.zzew.zzb> list3;
        Map map3;
        boolean z2;
        Map<Integer, List<Integer>> map4;
        Preconditions.checkNotEmpty(str);
        Preconditions.checkNotNull(list);
        Preconditions.checkNotNull(list2);
        this.zza = str;
        this.zzb = new HashSet();
        this.zzc = new ArrayMap();
        this.zzd = l;
        this.zze = l2;
        Iterator<com.google.android.gms.internal.measurement.zzfi.zze> it = list.iterator();
        while (true) {
            if (!it.hasNext()) {
                z = false;
                break;
            }
            if ("_s".equals(it.next().zzg())) {
                z = true;
                break;
            }
        }
        boolean z3 = zzob.zza() && zze().zzf(this.zza, zzbi.zzbg);
        boolean z4 = zzob.zza() && zze().zzf(this.zza, zzbi.zzbf);
        if (z) {
            zzao zzaoVarZzh = zzh();
            String str2 = this.zza;
            zzaoVarZzh.zzak();
            zzaoVarZzh.zzt();
            Preconditions.checkNotEmpty(str2);
            ContentValues contentValues = new ContentValues();
            contentValues.put("current_session_count", (Integer) 0);
            try {
                zzaoVarZzh.m30e_().update("events", contentValues, "app_id = ?", new String[]{str2});
            } catch (SQLiteException e) {
                zzaoVarZzh.zzj().zzg().zza("Error resetting session-scoped event counts. appId", zzfr.zza(str2), e);
            }
        }
        Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zzb>> mapEmptyMap = Collections.emptyMap();
        if (z4 && z3) {
            mapEmptyMap = zzh().zzk(this.zza);
        }
        Map mapZzj = zzh().zzj(this.zza);
        if (!mapZzj.isEmpty()) {
            HashSet hashSet = new HashSet(mapZzj.keySet());
            if (z) {
                String str3 = this.zza;
                Map<Integer, List<Integer>> mapZzl = zzh().zzl(this.zza);
                Preconditions.checkNotEmpty(str3);
                Preconditions.checkNotNull(mapZzj);
                Map arrayMap = new ArrayMap();
                if (!mapZzj.isEmpty()) {
                    for (Integer num : mapZzj.keySet()) {
                        num.intValue();
                        com.google.android.gms.internal.measurement.zzfi.zzl zzlVar = mapZzj.get(num);
                        List<Integer> list4 = mapZzl.get(num);
                        if (list4 == null || list4.isEmpty()) {
                            map4 = mapZzl;
                            arrayMap.put(num, zzlVar);
                            mapZzl = map4;
                        } else {
                            List<Long> listZza = mo32g_().zza(zzlVar.zzi(), list4);
                            if (!listZza.isEmpty()) {
                                com.google.android.gms.internal.measurement.zzfi.zzl.zza zzaVarZzb = zzlVar.zzby().zzb().zzb(listZza);
                                zzaVarZzb.zzd().zzd(mo32g_().zza(zzlVar.zzk(), list4));
                                ArrayList arrayList = new ArrayList();
                                for (com.google.android.gms.internal.measurement.zzfi.zzd zzdVar : zzlVar.zzh()) {
                                    Map<Integer, List<Integer>> map5 = mapZzl;
                                    if (!list4.contains(Integer.valueOf(zzdVar.zza()))) {
                                        arrayList.add(zzdVar);
                                    }
                                    mapZzl = map5;
                                }
                                map4 = mapZzl;
                                zzaVarZzb.zza().zza(arrayList);
                                ArrayList arrayList2 = new ArrayList();
                                for (com.google.android.gms.internal.measurement.zzfi.zzm zzmVar : zzlVar.zzj()) {
                                    if (!list4.contains(Integer.valueOf(zzmVar.zzb()))) {
                                        arrayList2.add(zzmVar);
                                    }
                                }
                                zzaVarZzb.zzc().zzc(arrayList2);
                                arrayMap.put(num, (com.google.android.gms.internal.measurement.zzfi.zzl) ((com.google.android.gms.internal.measurement.zzix) zzaVarZzb.zzab()));
                                mapZzl = map4;
                            }
                        }
                    }
                }
                map2 = arrayMap;
            } else {
                map2 = mapZzj;
            }
            Iterator it2 = hashSet.iterator();
            while (it2.hasNext()) {
                Integer num2 = (Integer) it2.next();
                num2.intValue();
                com.google.android.gms.internal.measurement.zzfi.zzl zzlVar2 = map2.get(num2);
                BitSet bitSet = new BitSet();
                BitSet bitSet2 = new BitSet();
                ArrayMap arrayMap2 = new ArrayMap();
                if (zzlVar2 != null && zzlVar2.zza() != 0) {
                    for (com.google.android.gms.internal.measurement.zzfi.zzd zzdVar2 : zzlVar2.zzh()) {
                        if (zzdVar2.zzf()) {
                            arrayMap2.put(Integer.valueOf(zzdVar2.zza()), zzdVar2.zze() ? Long.valueOf(zzdVar2.zzb()) : null);
                        }
                    }
                }
                ArrayMap arrayMap3 = new ArrayMap();
                if (zzlVar2 != null && zzlVar2.zzc() != 0) {
                    for (Iterator<com.google.android.gms.internal.measurement.zzfi.zzm> it3 = zzlVar2.zzj().iterator(); it3.hasNext(); it3 = it3) {
                        com.google.android.gms.internal.measurement.zzfi.zzm next = it3.next();
                        if (next.zzf() && next.zza() > 0) {
                            arrayMap3.put(Integer.valueOf(next.zzb()), Long.valueOf(next.zza(next.zza() - 1)));
                        }
                    }
                }
                if (zzlVar2 != null) {
                    int i = 0;
                    while (i < (zzlVar2.zzd() << 6)) {
                        if (zzmz.zza(zzlVar2.zzk(), i)) {
                            map3 = map2;
                            zzj().zzp().zza("Filter already evaluated. audience ID, filter ID", num2, Integer.valueOf(i));
                            bitSet2.set(i);
                            if (zzmz.zza(zzlVar2.zzi(), i)) {
                                bitSet.set(i);
                                z2 = true;
                            }
                            if (!z2) {
                                arrayMap2.remove(Integer.valueOf(i));
                            }
                            i++;
                            map2 = map3;
                        } else {
                            map3 = map2;
                        }
                        z2 = false;
                        if (!z2) {
                            arrayMap2.remove(Integer.valueOf(i));
                        }
                        i++;
                        map2 = map3;
                    }
                }
                Map map6 = map2;
                com.google.android.gms.internal.measurement.zzfi.zzl zzlVar3 = mapZzj.get(num2);
                if (z4 && z3 && (list3 = mapEmptyMap.get(num2)) != null && this.zze != null && this.zzd != null) {
                    for (com.google.android.gms.internal.measurement.zzew.zzb zzbVar : list3) {
                        int iZzb = zzbVar.zzb();
                        long jLongValue = this.zze.longValue() / 1000;
                        if (zzbVar.zzi()) {
                            jLongValue = this.zzd.longValue() / 1000;
                        }
                        if (arrayMap2.containsKey(Integer.valueOf(iZzb))) {
                            arrayMap2.put(Integer.valueOf(iZzb), Long.valueOf(jLongValue));
                        }
                        if (arrayMap3.containsKey(Integer.valueOf(iZzb))) {
                            arrayMap3.put(Integer.valueOf(iZzb), Long.valueOf(jLongValue));
                        }
                    }
                }
                this.zzc.put(num2, new zzv(this, this.zza, zzlVar3, bitSet, bitSet2, arrayMap2, arrayMap3));
                it2 = it2;
                map2 = map6;
            }
        }
        if (!list.isEmpty()) {
            zzx zzxVar2 = new zzx(this);
            Map arrayMap4 = new ArrayMap();
            for (com.google.android.gms.internal.measurement.zzfi.zze zzeVar : list) {
                com.google.android.gms.internal.measurement.zzfi.zze zzeVarZza = zzxVar2.zza(this.zza, zzeVar);
                if (zzeVarZza != null) {
                    zzao zzaoVarZzh2 = zzh();
                    String str4 = this.zza;
                    String strZzg = zzeVarZza.zzg();
                    zzbc zzbcVarZzd = zzaoVarZzh2.zzd(str4, zzeVar.zzg());
                    if (zzbcVarZzd == null) {
                        zzaoVarZzh2.zzj().zzu().zza("Event aggregate wasn't created during raw event logging. appId, event", zzfr.zza(str4), zzaoVarZzh2.zzi().zza(strZzg));
                        zzbcVar = new zzbc(str4, zzeVar.zzg(), 1L, 1L, 1L, zzeVar.zzd(), 0L, null, null, null, null);
                    } else {
                        zzbcVar = new zzbc(zzbcVarZzd.zza, zzbcVarZzd.zzb, zzbcVarZzd.zzc + 1, zzbcVarZzd.zzd + 1, zzbcVarZzd.zze + 1, zzbcVarZzd.zzf, zzbcVarZzd.zzg, zzbcVarZzd.zzh, zzbcVarZzd.zzi, zzbcVarZzd.zzj, zzbcVarZzd.zzk);
                    }
                    zzh().zza(zzbcVar);
                    long j = zzbcVar.zzc;
                    String strZzg2 = zzeVarZza.zzg();
                    Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zzb>> mapZzf = (Map) arrayMap4.get(strZzg2);
                    if (mapZzf == null) {
                        mapZzf = zzh().zzf(this.zza, strZzg2);
                        arrayMap4.put(strZzg2, mapZzf);
                    }
                    for (Integer num3 : mapZzf.keySet()) {
                        int iIntValue = num3.intValue();
                        if (this.zzb.contains(num3)) {
                            zzj().zzp().zza("Skipping failed audience ID", num3);
                        } else {
                            Iterator<com.google.android.gms.internal.measurement.zzew.zzb> it4 = mapZzf.get(num3).iterator();
                            boolean zZza = true;
                            while (true) {
                                if (!it4.hasNext()) {
                                    zzxVar = zzxVar2;
                                    map = arrayMap4;
                                    break;
                                }
                                com.google.android.gms.internal.measurement.zzew.zzb next2 = it4.next();
                                zzxVar = zzxVar2;
                                zzz zzzVar = new zzz(this, this.zza, iIntValue, next2);
                                map = arrayMap4;
                                zZza = zzzVar.zza(this.zzd, this.zze, zzeVarZza, j, zzbcVar, zza(iIntValue, next2.zzb()));
                                if (zZza) {
                                    zza(num3).zza(zzzVar);
                                    zzxVar2 = zzxVar;
                                    arrayMap4 = map;
                                } else {
                                    this.zzb.add(num3);
                                    break;
                                }
                            }
                            if (!zZza) {
                                this.zzb.add(num3);
                            }
                            zzxVar2 = zzxVar;
                            arrayMap4 = map;
                        }
                    }
                }
            }
        }
        if (!list2.isEmpty()) {
            ArrayMap arrayMap5 = new ArrayMap();
            for (com.google.android.gms.internal.measurement.zzfi.zzn zznVar : list2) {
                String strZzg3 = zznVar.zzg();
                Map<Integer, List<com.google.android.gms.internal.measurement.zzew.zze>> mapZzg = (Map) arrayMap5.get(strZzg3);
                if (mapZzg == null) {
                    mapZzg = zzh().zzg(this.zza, strZzg3);
                    arrayMap5.put(strZzg3, mapZzg);
                }
                for (Integer num4 : mapZzg.keySet()) {
                    int iIntValue2 = num4.intValue();
                    if (this.zzb.contains(num4)) {
                        zzj().zzp().zza("Skipping failed audience ID", num4);
                        break;
                    }
                    boolean zZza2 = true;
                    for (com.google.android.gms.internal.measurement.zzew.zze zzeVar2 : mapZzg.get(num4)) {
                        if (zzj().zza(2)) {
                            zzj().zzp().zza("Evaluating filter. audience, filter, property", num4, zzeVar2.zzi() ? Integer.valueOf(zzeVar2.zza()) : null, zzi().zzc(zzeVar2.zze()));
                            zzj().zzp().zza("Filter definition", mo32g_().zza(zzeVar2));
                        }
                        if (!zzeVar2.zzi() || zzeVar2.zza() > 256) {
                            zzj().zzu().zza("Invalid property filter ID. appId, id", zzfr.zza(this.zza), String.valueOf(zzeVar2.zzi() ? Integer.valueOf(zzeVar2.zza()) : null));
                            zZza2 = false;
                            break;
                        }
                        zzab zzabVar = new zzab(this, this.zza, iIntValue2, zzeVar2);
                        zZza2 = zzabVar.zza(this.zzd, this.zze, zznVar, zza(iIntValue2, zzeVar2.zza()));
                        if (zZza2) {
                            zza(num4).zza(zzabVar);
                        } else {
                            this.zzb.add(num4);
                            break;
                        }
                    }
                    if (!zZza2) {
                        this.zzb.add(num4);
                    }
                }
            }
        }
        ArrayList arrayList3 = new ArrayList();
        Set<Integer> setKeySet = this.zzc.keySet();
        setKeySet.removeAll(this.zzb);
        for (Integer num5 : setKeySet) {
            int iIntValue3 = num5.intValue();
            zzv zzvVar = this.zzc.get(num5);
            Preconditions.checkNotNull(zzvVar);
            com.google.android.gms.internal.measurement.zzfi.zzc zzcVarZza = zzvVar.zza(iIntValue3);
            arrayList3.add(zzcVarZza);
            zzao zzaoVarZzh3 = zzh();
            String str5 = this.zza;
            com.google.android.gms.internal.measurement.zzfi.zzl zzlVarZzd = zzcVarZza.zzd();
            zzaoVarZzh3.zzak();
            zzaoVarZzh3.zzt();
            Preconditions.checkNotEmpty(str5);
            Preconditions.checkNotNull(zzlVarZzd);
            byte[] bArrZzbv = zzlVarZzd.zzbv();
            ContentValues contentValues2 = new ContentValues();
            contentValues2.put("app_id", str5);
            contentValues2.put("audience_id", num5);
            contentValues2.put("current_results", bArrZzbv);
            try {
                try {
                    if (zzaoVarZzh3.m30e_().insertWithOnConflict("audience_filter_values", null, contentValues2, 5) == -1) {
                        zzaoVarZzh3.zzj().zzg().zza("Failed to insert filter results (got -1). appId", zzfr.zza(str5));
                    }
                } catch (SQLiteException e2) {
                    e = e2;
                    zzaoVarZzh3.zzj().zzg().zza("Error storing filter results. appId", zzfr.zza(str5), e);
                }
            } catch (SQLiteException e3) {
                e = e3;
            }
        }
        return arrayList3;
    }

    zzt(zzmp zzmpVar) {
        super(zzmpVar);
    }

    private final boolean zza(int i, int i2) {
        zzv zzvVar = this.zzc.get(Integer.valueOf(i));
        if (zzvVar == null) {
            return false;
        }
        return zzvVar.zzd.get(i2);
    }
}
