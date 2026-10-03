package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzpx implements Supplier<zzpw> {
    private static zzpx zza = new zzpx();
    private final Supplier<zzpw> zzb = Suppliers.ofInstance(new zzpz());

    @Override
    public final zzpw get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzpw) zza.get()).zza();
    }
}
