package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzoh implements Supplier<zzog> {
    private static zzoh zza = new zzoh();
    private final Supplier<zzog> zzb = Suppliers.ofInstance(new zzoj());

    @Override
    public final zzog get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzog) zza.get()).zza();
    }

    public static boolean zzb() {
        return ((zzog) zza.get()).zzb();
    }
}
