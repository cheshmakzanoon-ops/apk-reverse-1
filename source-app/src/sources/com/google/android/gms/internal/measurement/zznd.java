package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zznd implements Supplier<zznc> {
    private static zznd zza = new zznd();
    private final Supplier<zznc> zzb = Suppliers.ofInstance(new zznf());

    @Override
    public final zznc get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zznc) zza.get()).zza();
    }
}
