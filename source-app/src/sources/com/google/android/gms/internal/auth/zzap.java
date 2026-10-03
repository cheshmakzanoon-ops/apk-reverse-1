package com.google.android.gms.internal.auth;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.auth.api.AuthProxy;
import com.google.android.gms.auth.api.proxy.ProxyApi;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.BaseImplementation;

abstract class zzap extends BaseImplementation.ApiMethodImpl<ProxyApi.ProxyResult, zzak> {
    public zzap(GoogleApiClient googleApiClient) {
        super(AuthProxy.API, googleApiClient);
    }

    protected abstract void zza(Context context, zzan zzanVar) throws RemoteException;

    @Override
    protected void doExecute(Api.AnyClient anyClient) throws RemoteException {
        zzak zzakVar = (zzak) anyClient;
        zza(zzakVar.getContext(), (zzan) zzakVar.getService());
    }

    @Override
    protected Result createFailedResult(Status status) {
        return new zzaw(status);
    }
}
