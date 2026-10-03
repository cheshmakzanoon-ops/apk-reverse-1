package com.google.android.gms.internal.p003authapi;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.auth.api.credentials.Credential;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;

final class zzn extends zzo<Status> {
    private final Credential zzao;

    zzn(zzj zzjVar, GoogleApiClient googleApiClient, Credential credential) {
        super(googleApiClient);
        this.zzao = credential;
    }

    @Override
    protected final Result createFailedResult(Status status) {
        return status;
    }

    @Override
    protected final void zzc(Context context, zzx zzxVar) throws RemoteException {
        zzxVar.zzc(new zzp(this), new zzt(this.zzao));
    }
}
