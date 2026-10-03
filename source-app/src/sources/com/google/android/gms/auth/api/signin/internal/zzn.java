package com.google.android.gms.auth.api.signin.internal;

import android.os.RemoteException;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;

final class zzn extends zzp<Status> {
    zzn(GoogleApiClient googleApiClient) {
        super(googleApiClient);
    }

    @Override
    protected final Result createFailedResult(Status status) {
        return status;
    }

    @Override
    protected final void doExecute(Api.AnyClient anyClient) throws RemoteException {
        zzh zzhVar = (zzh) anyClient;
        ((zzv) zzhVar.getService()).zze(new zzm(this), zzhVar.zzj());
    }
}
