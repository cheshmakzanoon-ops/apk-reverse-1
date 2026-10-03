package com.google.android.gms.internal.games_v2;

import java.util.function.Function;

final class zzgb implements Function {
    static final zzgb zza = new zzgb();

    private zzgb() {
    }

    @Override
    public Function andThen(Function function) {
        return j$.util.function.Function.-CC.$default$andThen(this, function);
    }

    @Override
    public final Object apply(Object obj) {
        return ((zzgz) obj).zze();
    }

    @Override
    public Function compose(Function function) {
        return j$.util.function.Function.-CC.$default$compose(this, function);
    }
}
