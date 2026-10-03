package com.google.android.gms.internal.games_v2;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.games.RecallAccess;
import com.google.android.gms.tasks.TaskCompletionSource;
import j$.util.Objects;

final class zzeo extends zzfl {
    final TaskCompletionSource zza;

    zzeo(zzer zzerVar, TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
        Objects.requireNonNull(zzerVar);
    }

    @Override
    public final void zzb(zzam zzamVar) {
        this.zza.setResult(RecallAccess.zza(zzamVar));
    }

    @Override
    public final void zzc(Status status) {
        this.zza.setException(new ApiException(status));
    }
}
