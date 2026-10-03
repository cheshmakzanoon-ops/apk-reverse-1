package com.google.android.gms.internal.games_v2;

import java.io.Serializable;

final class zzhv extends zzht implements Serializable {
    static final zzht zza = new zzhv();

    private zzhv() {
    }

    @Override
    public final int compare(Object obj, Object obj2) {
        zzhw zzhwVar = (zzhw) obj;
        zzhw zzhwVar2 = (zzhw) obj2;
        return zzgq.zzc().zza(zzhwVar.zza, zzhwVar2.zza).zza(zzhwVar.zzb, zzhwVar2.zzb).zzb();
    }
}
