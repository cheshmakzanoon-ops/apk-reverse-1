package com.google.android.gms.internal.games_v2;

import java.util.function.Function;

final class zzgf implements Function {
    static final zzgf zza = new zzgf();

    private zzgf() {
    }

    @Override
    public Function andThen(Function function) {
        return j$.util.function.Function.-CC.$default$andThen(this, function);
    }

    @Override
    public final Object apply(Object obj) {
        return ((zzhh) obj).zzc();
    }

    @Override
    public Function compose(Function function) {
        return j$.util.function.Function.-CC.$default$compose(this, function);
    }
}
