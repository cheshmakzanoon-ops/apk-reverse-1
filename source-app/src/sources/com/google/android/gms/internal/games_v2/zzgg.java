package com.google.android.gms.internal.games_v2;

import java.util.function.BiConsumer;

final class zzgg implements BiConsumer {
    static final zzgg zza = new zzgg();

    private zzgg() {
    }

    @Override
    public final void accept(Object obj, Object obj2) {
        ((zzhh) obj).zza((zzhw) obj2);
    }

    @Override
    public BiConsumer andThen(BiConsumer biConsumer) {
        return j$.util.function.BiConsumer.-CC.$default$andThen(this, biConsumer);
    }
}
