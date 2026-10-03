package com.google.android.gms.internal.games_v2;

import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Function;

final class zzga implements BinaryOperator {
    static final zzga zza = new zzga();

    private zzga() {
    }

    @Override
    public BiFunction andThen(Function function) {
        return j$.util.function.BiFunction.-CC.$default$andThen(this, function);
    }

    @Override
    public final Object apply(Object obj, Object obj2) {
        zzgz zzgzVar = (zzgz) obj2;
        zzgz zzgzVar2 = (zzgz) obj;
        zzgzVar2.zzb(zzgzVar.zza, zzgzVar.zzb);
        return zzgzVar2;
    }
}
