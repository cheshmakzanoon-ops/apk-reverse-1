package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzqe implements Supplier<zzqh> {
    private static zzqe zza = new zzqe();
    private final Supplier<zzqh> zzb = Suppliers.ofInstance(new zzqg());

    @Override
    public final zzqh get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzqh) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zzqh) zza.get()).zzb();
    }
}
