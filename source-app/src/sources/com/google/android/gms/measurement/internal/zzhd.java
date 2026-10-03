package com.google.android.gms.measurement.internal;

import com.google.android.gms.common.internal.Preconditions;
import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

final class zzhd<V> extends FutureTask<V> implements Comparable<zzhd<V>> {
    final boolean zza;
    private final long zzb;
    private final String zzc;
    private final zzgy zzd;

    @Override
    public final int compareTo(Object obj) {
        zzhd zzhdVar = (zzhd) obj;
        boolean z = this.zza;
        if (z != zzhdVar.zza) {
            return z ? -1 : 1;
        }
        long j = this.zzb;
        long j2 = zzhdVar.zzb;
        if (j < j2) {
            return -1;
        }
        if (j > j2) {
            return 1;
        }
        this.zzd.zzj().zzm().zza("Two tasks share the same index. index", Long.valueOf(this.zzb));
        return 0;
    }

    zzhd(zzgy zzgyVar, Runnable runnable, boolean z, String str) {
        super(com.google.android.gms.internal.measurement.zzcl.zza().zza(runnable), null);
        this.zzd = zzgyVar;
        Preconditions.checkNotNull(str);
        long andIncrement = zzgy.zza.getAndIncrement();
        this.zzb = andIncrement;
        this.zzc = str;
        this.zza = z;
        if (andIncrement == Long.MAX_VALUE) {
            zzgyVar.zzj().zzg().zza("Tasks index overflow");
        }
    }

    zzhd(zzgy zzgyVar, Callable<V> callable, boolean z, String str) {
        super(com.google.android.gms.internal.measurement.zzcl.zza().zza(callable));
        this.zzd = zzgyVar;
        Preconditions.checkNotNull(str);
        long andIncrement = zzgy.zza.getAndIncrement();
        this.zzb = andIncrement;
        this.zzc = str;
        this.zza = z;
        if (andIncrement == Long.MAX_VALUE) {
            zzgyVar.zzj().zzg().zza("Tasks index overflow");
        }
    }

    @Override
    protected final void setException(Throwable th) {
        Thread.UncaughtExceptionHandler defaultUncaughtExceptionHandler;
        this.zzd.zzj().zzg().zza(this.zzc, th);
        if ((th instanceof zzhb) && (defaultUncaughtExceptionHandler = Thread.getDefaultUncaughtExceptionHandler()) != null) {
            defaultUncaughtExceptionHandler.uncaughtException(Thread.currentThread(), th);
        }
        super.setException(th);
    }
}
