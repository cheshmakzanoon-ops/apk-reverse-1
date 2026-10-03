package com.google.android.gms.common.api.internal;

import android.os.RemoteException;
import com.google.android.gms.common.Feature;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zacv extends TaskApiCall {
    final TaskApiCall.Builder zaa;

    zacv(TaskApiCall.Builder builder, Feature[] featureArr, boolean z, int i) {
        super(featureArr, z, i);
        this.zaa = builder;
    }

    @Override
    protected final void doExecute(Api.AnyClient anyClient, TaskCompletionSource taskCompletionSource) throws RemoteException {
        this.zaa.zaa.accept(anyClient, taskCompletionSource);
    }
}
