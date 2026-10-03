package com.google.android.gms.internal.games_v2;

import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Function;

final class zzge implements BinaryOperator {
    static final zzge zza = new zzge();

    private zzge() {
    }

    @Override
    public BiFunction andThen(Function function) {
        return j$.util.function.BiFunction.-CC.$default$andThen(this, function);
    }

    @Override
    public final Object apply(Object obj, Object obj2) {
        zzhh zzhhVar = (zzhh) obj;
        zzhhVar.zzb((zzhh) obj2);
        return zzhhVar;
    }
}
