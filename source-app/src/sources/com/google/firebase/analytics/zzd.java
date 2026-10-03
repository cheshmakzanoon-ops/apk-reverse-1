package com.google.firebase.analytics;

import java.util.concurrent.Callable;

final class zzd implements Callable<Long> {
    private final FirebaseAnalytics zza;

    @Override
    public final Long call() throws Exception {
        return this.zza.zzb.zzc();
    }

    zzd(FirebaseAnalytics firebaseAnalytics) {
        this.zza = firebaseAnalytics;
    }
}
