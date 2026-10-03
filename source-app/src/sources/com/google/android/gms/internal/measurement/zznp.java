package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zznp implements Supplier<zzno> {
    private static zznp zza = new zznp();
    private final Supplier<zzno> zzb = Suppliers.ofInstance(new zznr());

    @Override
    public final zzno get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzno) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zzno) zza.get()).zzb();
    }

    public static boolean zzc() {
        return ((zzno) zza.get()).zzc();
    }

    public static boolean zzd() {
        return ((zzno) zza.get()).zzd();
    }

    public static boolean zze() {
        return ((zzno) zza.get()).zze();
    }

    public static boolean zzf() {
        return ((zzno) zza.get()).zzf();
    }

    public static boolean zzg() {
        return ((zzno) zza.get()).zzg();
    }
}
