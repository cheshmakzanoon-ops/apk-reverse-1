package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.content.Intent;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.tasks.TaskCompletionSource;
import j$.util.Objects;

final class zzm extends zzn {
    zzm(zzq zzqVar, TaskCompletionSource taskCompletionSource) {
        super(taskCompletionSource);
        Objects.requireNonNull(zzqVar);
    }

    @Override
    public final void zzc(Intent intent) {
        if (intent == null) {
            zzd(new Status(17));
        } else {
            this.zza.trySetResult(intent);
        }
    }
}
