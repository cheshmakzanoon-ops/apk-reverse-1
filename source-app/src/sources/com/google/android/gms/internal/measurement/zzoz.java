package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzoz implements Supplier<zzoy> {
    private static zzoz zza = new zzoz();
    private final Supplier<zzoy> zzb = Suppliers.ofInstance(new zzpb());

    @Override
    public final zzoy get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zzoy) zza.get()).zza();
    }
}
