package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzpy implements Supplier<zzqb> {
    private static zzpy zza = new zzpy();
    private final Supplier<zzqb> zzb = Suppliers.ofInstance(new zzqa());

    @Override
    public final zzqb get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzqb) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zzqb) zza.get()).zzb();
    }

    public static boolean zzc() {
        return ((zzqb) zza.get()).zzc();
    }
}
