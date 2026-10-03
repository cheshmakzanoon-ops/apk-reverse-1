package com.google.android.gms.measurement;

import android.app.job.JobParameters;
import android.app.job.JobService;
import android.content.Intent;
import com.google.android.gms.measurement.internal.zzlu;
import com.google.android.gms.measurement.internal.zzly;

public final class AppMeasurementJobService extends JobService implements zzly {
    private zzlu<AppMeasurementJobService> zza;

    private final zzlu<AppMeasurementJobService> zza() {
        if (this.zza == null) {
            this.zza = new zzlu<>(this);
        }
        return this.zza;
    }

    @Override
    public final boolean onStopJob(JobParameters jobParameters) {
        return false;
    }

    @Override
    public final void zza(Intent intent) {
    }

    @Override
    public final void onCreate() {
        super.onCreate();
        zza().zza();
    }

    @Override
    public final void onDestroy() {
        zza().zzb();
        super.onDestroy();
    }

    @Override
    public final void onRebind(Intent intent) {
        zza().zzb(intent);
    }

    @Override
    public final void zza(JobParameters jobParameters, boolean z) {
        jobFinished(jobParameters, false);
    }

    @Override
    public final boolean zza(int i) {
        throw new UnsupportedOperationException();
    }

    @Override
    public final boolean onStartJob(JobParameters jobParameters) {
        return zza().zza(jobParameters);
    }

    @Override
    public final boolean onUnbind(Intent intent) {
        return zza().zzc(intent);
    }
}
