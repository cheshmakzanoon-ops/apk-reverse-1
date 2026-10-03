package com.google.android.gms.games.gamessignin;

import java.util.function.Function;

final class zzb implements Function {
    static final zzb zza = new zzb();

    private zzb() {
    }

    @Override
    public Function andThen(Function function) {
        return j$.util.function.Function.-CC.$default$andThen(this, function);
    }

    @Override
    public final Object apply(Object obj) {
        return ((AuthScope) obj).getValue();
    }

    @Override
    public Function compose(Function function) {
        return j$.util.function.Function.-CC.$default$compose(this, function);
    }
}
