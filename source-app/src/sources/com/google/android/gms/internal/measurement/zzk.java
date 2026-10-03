package com.google.android.gms.internal.measurement;

import java.util.HashMap;
import java.util.List;

public final class zzk extends zzal {
    private final zzac zzk;

    @Override
    public final zzaq zza(zzh zzhVar, List<zzaq> list) {
        zzg.zza(this.zza, 3, list);
        String strZzf = zzhVar.zza(list.get(0)).zzf();
        long jZza = (long) zzg.zza(zzhVar.zza(list.get(1)).zze().doubleValue());
        zzaq zzaqVarZza = zzhVar.zza(list.get(2));
        this.zzk.zza(strZzf, jZza, zzaqVarZza instanceof zzap ? zzg.zza((zzap) zzaqVarZza) : new HashMap<>());
        return zzaq.zzc;
    }

    public zzk(zzac zzacVar) {
        super("internal.eventLogger");
        this.zzk = zzacVar;
    }
}
