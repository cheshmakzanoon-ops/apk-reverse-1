package com.google.android.gms.games.gamessignin;

import java.util.function.Function;

final class zza implements Function {
    static final zza zza = new zza();

    private zza() {
    }

    @Override
    public Function andThen(Function function) {
        return j$.util.function.Function.-CC.$default$andThen(this, function);
    }

    @Override
    public final Object apply(Object obj) {
        return AuthScope.zzc((String) obj);
    }

    @Override
    public Function compose(Function function) {
        return j$.util.function.Function.-CC.$default$compose(this, function);
    }
}
