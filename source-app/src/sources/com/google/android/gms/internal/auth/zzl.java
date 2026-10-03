package com.google.android.gms.internal.auth;

import android.accounts.Account;
import android.os.RemoteException;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.api.internal.BaseImplementation;

final class zzl extends BaseImplementation.ApiMethodImpl<Result, zzr> {
    private final Account zzo;

    zzl(zzh zzhVar, Api api, GoogleApiClient googleApiClient, Account account) {
        super((Api<?>) api, googleApiClient);
        this.zzo = account;
    }

    @Override
    protected final Result createFailedResult(Status status) {
        return new zzq(status);
    }

    @Override
    protected final void doExecute(Api.AnyClient anyClient) throws RemoteException {
        ((com.google.android.gms.auth.account.zzc) ((zzr) anyClient).getService()).zza(new zzm(this), this.zzo);
    }
}
