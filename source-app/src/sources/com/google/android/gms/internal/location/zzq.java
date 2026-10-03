package com.google.android.gms.internal.location;

import android.os.RemoteException;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;

final class zzq extends zzx {
    zzq(zzz zzzVar, GoogleApiClient googleApiClient) {
        super(googleApiClient);
    }

    @Override
    protected final void doExecute(Api.AnyClient anyClient) throws RemoteException {
        ((zzaz) anyClient).zzK(new zzy(this));
    }
}
