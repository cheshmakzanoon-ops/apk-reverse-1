package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzpf implements Supplier<zzpe> {
    private static zzpf zza = new zzpf();
    private final Supplier<zzpe> zzb = Suppliers.ofInstance(new zzph());

    @Override
    public final zzpe get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzpe) zza.get()).zza();
    }
}
