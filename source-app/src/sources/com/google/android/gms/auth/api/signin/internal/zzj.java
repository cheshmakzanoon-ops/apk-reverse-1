package com.google.android.gms.auth.api.signin.internal;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.auth.api.signin.GoogleSignInResult;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.Result;
import com.google.android.gms.common.api.Status;

final class zzj extends zzp<GoogleSignInResult> {
    final Context val$context;
    final GoogleSignInOptions zzcf;

    zzj(GoogleApiClient googleApiClient, Context context, GoogleSignInOptions googleSignInOptions) {
        super(googleApiClient);
        this.val$context = context;
        this.zzcf = googleSignInOptions;
    }

    @Override
    protected final void doExecute(Api.AnyClient anyClient) throws RemoteException {
        ((zzv) ((zzh) anyClient).getService()).zzc(new zzi(this), this.zzcf);
    }

    @Override
    protected final Result createFailedResult(Status status) {
        return new GoogleSignInResult(null, status);
    }
}
