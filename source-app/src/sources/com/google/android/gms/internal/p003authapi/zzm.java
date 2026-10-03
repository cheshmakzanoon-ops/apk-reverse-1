package com.google.android.gms.internal.p003authapi;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;

final class zzm extends zzo<Status> {
    zzm(zzj zzjVar, GoogleApiClient googleApiClient) {
        super(googleApiClient);
    }

    @Override
    protected final Result createFailedResult(Status status) {
        return status;
    }

    @Override
    protected final void zzc(Context context, zzx zzxVar) throws RemoteException {
        zzxVar.zzc(new zzp(this));
    }
}
