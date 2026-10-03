package com.google.android.gms.internal.p003authapi;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.auth.api.credentials.CredentialRequest;
import com.google.android.gms.auth.api.credentials.CredentialRequestResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;

final class zzi extends zzo<CredentialRequestResult> {
    private final CredentialRequest zzan;

    zzi(zzj zzjVar, GoogleApiClient googleApiClient, CredentialRequest credentialRequest) {
        super(googleApiClient);
        this.zzan = credentialRequest;
    }

    @Override
    protected final void zzc(Context context, zzx zzxVar) throws RemoteException {
        zzxVar.zzc(new zzl(this), this.zzan);
    }

    @Override
    protected final Result createFailedResult(Status status) {
        return zzg.zzc(status);
    }
}
