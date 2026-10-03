package com.google.android.gms.internal.p004authapiphone;

import android.os.RemoteException;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.common.api.internal.TaskUtil;
import com.google.android.gms.tasks.TaskCompletionSource;

abstract class zzm extends TaskApiCall<zzi, Void> {
    private TaskCompletionSource<Void> zzf;

    private zzm() {
    }

    zzm(zzk zzkVar) {
        this();
    }

    @Override
    protected void doExecute(Api.AnyClient anyClient, TaskCompletionSource<Void> taskCompletionSource) throws RemoteException {
        this.zzf = taskCompletionSource;
        zza((zze) ((zzi) anyClient).getService());
    }

    protected abstract void zza(zze zzeVar) throws RemoteException;

    protected final void zzb(Status status) {
        TaskUtil.setResultOrApiException(status, this.zzf);
    }
}
