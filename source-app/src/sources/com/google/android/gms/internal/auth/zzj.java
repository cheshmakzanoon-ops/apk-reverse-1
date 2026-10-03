package com.google.android.gms.internal.auth;

import android.os.RemoteException;
import com.google.android.gms.auth.account.WorkAccountApi;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.BaseImplementation;

final class zzj extends BaseImplementation.ApiMethodImpl<WorkAccountApi.AddAccountResult, zzr> {
    private final String zzq;

    zzj(zzh zzhVar, Api api, GoogleApiClient googleApiClient, String str) {
        super((Api<?>) api, googleApiClient);
        this.zzq = str;
    }

    @Override
    protected final void doExecute(Api.AnyClient anyClient) throws RemoteException {
        ((com.google.android.gms.auth.account.zzc) ((zzr) anyClient).getService()).zza(new zzk(this), this.zzq);
    }

    @Override
    protected final Result createFailedResult(Status status) {
        return new zzo(status, null);
    }
}
