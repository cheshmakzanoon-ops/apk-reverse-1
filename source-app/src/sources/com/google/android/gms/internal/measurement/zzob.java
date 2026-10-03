package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzob implements Supplier<zzoa> {
    private static zzob zza = new zzob();
    private final Supplier<zzoa> zzb = Suppliers.ofInstance(new zzod());

    @Override
    public final zzoa get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzoa) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zzoa) zza.get()).zzb();
    }

    public static boolean zzc() {
        return ((zzoa) zza.get()).zzc();
    }

    public static boolean zzd() {
        return ((zzoa) zza.get()).zzd();
    }
}
