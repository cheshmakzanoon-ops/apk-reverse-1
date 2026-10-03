package com.google.android.play.core.review.internal;

import com.google.android.gms.tasks.TaskCompletionSource;

final class zzm extends zzj {
    final zzj zza;
    final zzt zzb;

    zzm(zzt zztVar, TaskCompletionSource taskCompletionSource, zzj zzjVar) {
        super(taskCompletionSource);
        this.zzb = zztVar;
        this.zza = zzjVar;
    }

    @Override
    public final void zza() {
        zzt.zzm(this.zzb, this.zza);
    }
}
