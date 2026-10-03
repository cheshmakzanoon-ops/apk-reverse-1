package com.google.android.gms.internal.measurement;

import com.google.common.base.Supplier;
import com.google.common.base.Suppliers;

public final class zzmy implements Supplier<zznb> {
    private static zzmy zza = new zzmy();
    private final Supplier<zznb> zzb = Suppliers.ofInstance(new zzna());

    @Override
    public final zznb get() {
        return this.zzb.get();
    }

    public static boolean zza() {
        return ((zznb) zza.get()).zza();
    }
}
