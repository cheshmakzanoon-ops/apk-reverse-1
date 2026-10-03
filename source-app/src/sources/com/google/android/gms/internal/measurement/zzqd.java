package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzqd implements Supplier<zzqc> {
    private static zzqd zza = new zzqd();
    private final Supplier<zzqc> zzb = Suppliers.ofInstance(new zzqf());

    @Override
    public final zzqc get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzqc) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zzqc) zza.get()).zzb();
    }

    public static boolean zzc() {
        return ((zzqc) zza.get()).zzc();
    }
}
