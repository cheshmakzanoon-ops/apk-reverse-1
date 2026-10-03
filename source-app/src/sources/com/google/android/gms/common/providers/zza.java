package com.google.android.gms.common.providers;

import com.google.android.gms.internal.common.zzf;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;

final class zza implements PooledExecutorsProvider.PooledExecutorFactory {
    zza() {
    }

    @Override
    public final ScheduledExecutorService newSingleThreadScheduledExecutor() {
        zzf.zza();
        return Executors.unconfigurableScheduledExecutorService(Executors.newScheduledThreadPool(1));
    }
}
