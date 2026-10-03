package com.google.android.gms.location;

import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.BaseImplementation;
import com.google.android.gms.common.api.internal.TaskUtil;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzat implements BaseImplementation.ResultHolder<Status> {
    private final TaskCompletionSource<Void> zza;

    public zzat(TaskCompletionSource<Void> taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void setFailedResult(Status status) {
        this.zza.setException(new ApiException(status));
    }

    @Override
    public final void setResult(Status status) {
        TaskUtil.setResultOrApiException(status, null, this.zza);
    }
}
