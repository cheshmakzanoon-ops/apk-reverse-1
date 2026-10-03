package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzps implements Supplier<zzpv> {
    private static zzps zza = new zzps();
    private final Supplier<zzpv> zzb = Suppliers.ofInstance(new zzpu());

    @Override
    public final zzpv get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzpv) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zzpv) zza.get()).zzb();
    }

    public static boolean zzc() {
        return ((zzpv) zza.get()).zzc();
    }

    public static boolean zzd() {
        return ((zzpv) zza.get()).zzd();
    }
}
