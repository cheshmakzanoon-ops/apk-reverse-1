package com.google.android.gms.internal.games_v2;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;
import java.util.AbstractMap;

final class zzia extends zzhd {
    final zzib zza;

    zzia(zzib zzibVar) {
        Objects.requireNonNull(zzibVar);
        this.zza = zzibVar;
    }

    @Override
    public final Object get(int i) {
        zzib zzibVar = this.zza;
        zzfu.zzb(i, zzibVar.zzl(), FirebaseAnalytics.Param.INDEX);
        int i2 = i + i;
        return new AbstractMap.SimpleImmutableEntry(Objects.requireNonNull(zzibVar.zzk()[i2]), Objects.requireNonNull(zzibVar.zzk()[i2 + 1]));
    }

    @Override
    public final int size() {
        return this.zza.zzl();
    }
}
