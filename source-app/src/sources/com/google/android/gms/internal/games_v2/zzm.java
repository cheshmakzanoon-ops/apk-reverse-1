package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.tasks.TaskCompletionSource;
import j$.util.Objects;

final class zzm extends zzg {
    final TaskCompletionSource zza;

    zzm(zzo zzoVar, TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
        Objects.requireNonNull(zzoVar);
    }

    @Override
    public final void zzb(Status status, zzs zzsVar) {
        if (zzsVar == null) {
            this.zza.setException(new ApiException(status));
        } else {
            this.zza.setResult(zzsVar);
        }
    }
}
