package com.google.android.gms.internal.p003authapi;

import android.os.RemoteException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.IStatusCallback;
import com.google.android.gms.common.api.internal.TaskUtil;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzai extends IStatusCallback.Stub {
    private final TaskCompletionSource zzbk;

    zzai(zzaf zzafVar, TaskCompletionSource taskCompletionSource) {
        this.zzbk = taskCompletionSource;
    }

    @Override
    public final void onResult(Status status) throws RemoteException {
        TaskUtil.setResultOrApiException(status, this.zzbk);
    }
}
