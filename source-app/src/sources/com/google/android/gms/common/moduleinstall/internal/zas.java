package com.google.android.gms.common.moduleinstall.internal;

import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.TaskUtil;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zas extends zaa {
    final TaskCompletionSource zaa;

    zas(zay zayVar, TaskCompletionSource taskCompletionSource) {
        this.zaa = taskCompletionSource;
    }

    @Override
    public final void zab(Status status) {
        TaskUtil.trySetResultOrApiException(status, null, this.zaa);
    }
}
