package com.google.android.gms.internal.games_v2;

import java.util.function.BiConsumer;

final class zzgc implements BiConsumer {
    static final zzgc zza = new zzgc();

    private zzgc() {
    }

    @Override
    public final void accept(Object obj, Object obj2) {
        ((zzgz) obj).zzd(obj2);
    }

    @Override
    public BiConsumer andThen(BiConsumer biConsumer) {
        return j$.util.function.BiConsumer.-CC.$default$andThen(this, biConsumer);
    }
}
