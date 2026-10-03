package com.google.android.gms.games.internal.p000v2.appshortcuts;

import com.google.android.gms.common.api.Status;
import com.google.android.gms.tasks.TaskCompletionSource;
import j$.util.Objects;

final class zzl extends zzn {
    zzl(zzq zzqVar, TaskCompletionSource taskCompletionSource) {
        super(taskCompletionSource);
        Objects.requireNonNull(zzqVar);
    }

    @Override
    public final void zzb(zzg zzgVar) {
        if (zzgVar == null) {
            zzd(new Status(17));
        } else {
            this.zza.trySetResult(zzgVar);
        }
    }
}
