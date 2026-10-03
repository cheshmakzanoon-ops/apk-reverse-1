package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zznj implements Supplier<zzni> {
    private static zznj zza = new zznj();
    private final Supplier<zzni> zzb = Suppliers.ofInstance(new zznl());

    public static long zza() {
        return ((zzni) zza.get()).zza();
    }

    @Override
    public final zzni get() {
        return this.zzb.get();
    }
}
