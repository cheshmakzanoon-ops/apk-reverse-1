package com.google.android.gms.internal.play_billing;

import java.util.concurrent.Executor;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public final class zzcx extends zzcz {
    public static zzdc zza(Object obj) {
        return new zzda(obj);
    }

    public static zzdc zzb(zzdc zzdcVar, long j, TimeUnit timeUnit, ScheduledExecutorService scheduledExecutorService) {
        return zzdcVar.isDone() ? zzdcVar : zzdh.zzs(zzdcVar, 28500L, timeUnit, scheduledExecutorService);
    }

    public static void zzc(zzdc zzdcVar, zzcv zzcvVar, Executor executor) {
        zzdcVar.zzb(new zzcw(zzdcVar, zzcvVar), executor);
    }
}
