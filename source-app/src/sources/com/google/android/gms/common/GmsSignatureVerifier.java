package com.google.android.gms.common;

import com.google.android.gms.internal.common.zzah;
import java.util.HashMap;

public class GmsSignatureVerifier {
    private static final zzab zza;
    private static final zzab zzb;
    private static final HashMap zzc;

    static {
        zzaa zzaaVar = new zzaa();
        zzaaVar.zza("com.google.android.gms");
        zzaaVar.zzb(204200000L);
        zzaaVar.zzc(zzah.zzm(zzo.zzf.zzc(), zzo.zzd.zzc(), zzo.zzb.zzc()));
        zzaaVar.zzd(zzah.zzm(zzo.zze.zzc(), zzo.zzc.zzc(), zzo.zza.zzc()));
        zza = zzaaVar.zze();
        zzaa zzaaVar2 = new zzaa();
        zzaaVar2.zza("com.android.vending");
        zzaaVar2.zzb(82240000L);
        zzaaVar2.zzc(zzah.zzk(zzo.zzf.zzc()));
        zzaaVar2.zzd(zzah.zzl(zzo.zze.zzc(), zzo.zzc.zzc()));
        zzb = zzaaVar2.zze();
        zzc = new HashMap();
    }
}
