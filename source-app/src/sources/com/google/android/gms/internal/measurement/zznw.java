package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zznw implements Supplier<zznz> {
    private static zznw zza = new zznw();
    private final Supplier<zznz> zzb = Suppliers.ofInstance(new zzny());

    @Override
    public final zznz get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zznz) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zznz) zza.get()).zzb();
    }
}
