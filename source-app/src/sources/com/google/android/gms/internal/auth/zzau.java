package com.google.android.gms.internal.auth;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApiClient;

final class zzau extends zzaq {
    zzau(zzar zzarVar, GoogleApiClient googleApiClient) {
        super(googleApiClient);
    }

    @Override
    protected final void zza(Context context, zzan zzanVar) throws RemoteException {
        zzanVar.zza(new zzav(this));
    }
}
