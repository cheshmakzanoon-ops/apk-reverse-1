package com.google.android.gms.internal.games_v2;

import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Function;

final class zzgi implements BinaryOperator {
    static final zzgi zza = new zzgi();

    private zzgi() {
    }

    @Override
    public BiFunction andThen(Function function) {
        return j$.util.function.BiFunction.-CC.$default$andThen(this, function);
    }

    @Override
    public final Object apply(Object obj, Object obj2) {
        zzhj zzhjVar = (zzhj) obj2;
        zzhj zzhjVar2 = (zzhj) obj;
        zzhjVar2.zzb(zzhjVar.zza, zzhjVar.zzb);
        return zzhjVar2;
    }
}
