package com.google.android.gms.internal.measurement;

import com.ishumei.smantifraud.l11l11I1111l;
import java.util.List;

public final class zzw extends zzal {
    private zzaa zzk;

    @Override
    public final zzaq zza(zzh zzhVar, List<zzaq> list) {
        zzg.zza(this.zza, 3, list);
        String strZzf = zzhVar.zza(list.get(0)).zzf();
        zzaq zzaqVarZza = zzhVar.zza(list.get(1));
        if (!(zzaqVarZza instanceof zzar)) {
            throw new IllegalArgumentException("Invalid callback type");
        }
        zzaq zzaqVarZza2 = zzhVar.zza(list.get(2));
        if (!(zzaqVarZza2 instanceof zzap)) {
            throw new IllegalArgumentException("Invalid callback params");
        }
        zzap zzapVar = (zzap) zzaqVarZza2;
        if (!zzapVar.zzc(l11l11I1111l.l111l1111l1Il)) {
            throw new IllegalArgumentException("Undefined rule type");
        }
        this.zzk.zza(strZzf, zzapVar.zzc("priority") ? zzg.zzb(zzapVar.zza("priority").zze().doubleValue()) : 1000, (zzar) zzaqVarZza, zzapVar.zza(l11l11I1111l.l111l1111l1Il).zzf());
        return zzaq.zzc;
    }

    public zzw(zzaa zzaaVar) {
        super("internal.registerCallback");
        this.zzk = zzaaVar;
    }
}
