package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zznk implements Supplier<zznn> {
    private static zznk zza = new zznk();
    private final Supplier<zznn> zzb = Suppliers.ofInstance(new zznm());

    @Override
    public final zznn get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zznn) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zznn) zza.get()).zzb();
    }
}
