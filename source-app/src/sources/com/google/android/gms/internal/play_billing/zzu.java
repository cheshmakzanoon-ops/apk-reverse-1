package com.google.android.gms.internal.play_billing;

public final class zzu {
    public static zzdc zza(zzr zzrVar) {
        zzp zzpVar = new zzp();
        zzt zztVar = new zzt(zzpVar);
        zzpVar.zzb = zztVar;
        zzpVar.zza = zzrVar.getClass();
        try {
            zzpVar.zza = zzrVar.zza(zzpVar);
        } catch (Exception e) {
            zztVar.zzc(e);
        }
        return zztVar;
    }
}
