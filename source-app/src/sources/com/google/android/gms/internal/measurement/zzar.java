package com.google.android.gms.internal.measurement;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public final class zzar extends zzal implements zzak {
    private final List<String> zzk;
    private final List<zzaq> zzl;
    private zzh zzm;

    @Override
    public final zzaq zzc() {
        return new zzar(this);
    }

    @Override
    public final zzaq zza(zzh zzhVar, List<zzaq> list) {
        zzh zzhVarZza = this.zzm.zza();
        for (int i = 0; i < this.zzk.size(); i++) {
            if (i < list.size()) {
                zzhVarZza.zza(this.zzk.get(i), zzhVar.zza(list.get(i)));
            } else {
                zzhVarZza.zza(this.zzk.get(i), zzc);
            }
        }
        for (zzaq zzaqVar : this.zzl) {
            zzaq zzaqVarZza = zzhVarZza.zza(zzaqVar);
            if (zzaqVarZza instanceof zzat) {
                zzaqVarZza = zzhVarZza.zza(zzaqVar);
            }
            if (zzaqVarZza instanceof zzaj) {
                return ((zzaj) zzaqVarZza).zza();
            }
        }
        return zzaq.zzc;
    }

    private zzar(zzar zzarVar) {
        super(zzarVar.zza);
        ArrayList arrayList = new ArrayList(zzarVar.zzk.size());
        this.zzk = arrayList;
        arrayList.addAll(zzarVar.zzk);
        ArrayList arrayList2 = new ArrayList(zzarVar.zzl.size());
        this.zzl = arrayList2;
        arrayList2.addAll(zzarVar.zzl);
        this.zzm = zzarVar.zzm;
    }

    public zzar(String str, List<zzaq> list, List<zzaq> list2, zzh zzhVar) {
        super(str);
        this.zzk = new ArrayList();
        this.zzm = zzhVar;
        if (!list.isEmpty()) {
            Iterator<zzaq> it = list.iterator();
            while (it.hasNext()) {
                this.zzk.add(it.next().zzf());
            }
        }
        this.zzl = new ArrayList(list2);
    }
}
