package com.google.android.gms.internal.p003authapi;

import android.os.RemoteException;
import com.google.android.gms.auth.api.identity.BeginSignInResult;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.TaskUtil;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzaj extends zzaa {
    private final TaskCompletionSource zzbk;

    zzaj(zzaf zzafVar, TaskCompletionSource taskCompletionSource) {
        this.zzbk = taskCompletionSource;
    }

    @Override
    public final void zzc(Status status, BeginSignInResult beginSignInResult) throws RemoteException {
        TaskUtil.setResultOrApiException(status, beginSignInResult, this.zzbk);
    }
}
