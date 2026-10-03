package com.google.android.gms.location;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.BaseImplementation;
import com.google.android.gms.common.api.internal.TaskUtil;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzj implements BaseImplementation.ResultHolder<Status> {
    private final TaskCompletionSource<Void> zza;

    public zzj(TaskCompletionSource<Void> taskCompletionSource) {
        Preconditions.checkNotNull(taskCompletionSource);
        this.zza = taskCompletionSource;
    }

    @Override
    public final void setFailedResult(Status status) {
        if (status == null) {
            return;
        }
        this.zza.setException(new ApiException(status));
    }

    @Override
    public final void setResult(Status status) {
        TaskUtil.setResultOrApiException(status, null, this.zza);
    }
}
