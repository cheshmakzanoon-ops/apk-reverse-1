package com.google.android.gms.internal.p003authapi;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.auth.api.Auth;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.internal.BaseImplementation;

abstract class zzo<R extends Result> extends BaseImplementation.ApiMethodImpl<R, zzq> {
    zzo(GoogleApiClient googleApiClient) {
        super(Auth.CREDENTIALS_API, googleApiClient);
    }

    protected abstract void zzc(Context context, zzx zzxVar) throws RemoteException;

    @Override
    protected void doExecute(Api.AnyClient anyClient) throws RemoteException {
        zzq zzqVar = (zzq) anyClient;
        zzc(zzqVar.getContext(), (zzx) zzqVar.getService());
    }
}
