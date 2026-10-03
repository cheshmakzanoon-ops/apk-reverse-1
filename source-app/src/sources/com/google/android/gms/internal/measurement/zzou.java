package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzou implements Supplier<zzox> {
    private static zzou zza = new zzou();
    private final Supplier<zzox> zzb = Suppliers.ofInstance(new zzow());

    @Override
    public final zzox get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzox) zza.get()).zza();
    }
}
