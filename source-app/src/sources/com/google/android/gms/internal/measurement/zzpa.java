package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzpa implements Supplier<zzpd> {
    private static zzpa zza = new zzpa();
    private final Supplier<zzpd> zzb = Suppliers.ofInstance(new zzpc());

    public static double zza() {
        return ((zzpd) zza.get()).zza();
    }

    public static long zzb() {
        return ((zzpd) zza.get()).zzb();
    }

    public static long zzc() {
        return ((zzpd) zza.get()).zzc();
    }

    @Override
    public final zzpd get() {
        return this.zzb.get();
    }

    public static String zzd() {
        return ((zzpd) zza.get()).zzd();
    }

    public static boolean zze() {
        return ((zzpd) zza.get()).zze();
    }
}
