package com.google.android.gms.games.internal;

import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.internal.ApiExceptionUtil;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzu extends zza {
    private final TaskCompletionSource zza;

    zzu(TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void zzr(Status status, String str) {
        if (status.isSuccess()) {
            this.zza.setResult(str);
            return;
        }
        TaskCompletionSource taskCompletionSource = this.zza;
        int i = zzah.zze;
        taskCompletionSource.setException(ApiExceptionUtil.fromStatus(status));
    }
}
