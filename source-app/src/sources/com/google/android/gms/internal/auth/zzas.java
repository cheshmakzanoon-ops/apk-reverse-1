package com.google.android.gms.internal.auth;

import android.content.Context;
import android.os.RemoteException;
import com.google.android.gms.auth.api.proxy.ProxyRequest;
import com.google.android.gms.common.api.GoogleApiClient;

final class zzas extends zzap {
    private final ProxyRequest zzce;

    zzas(zzar zzarVar, GoogleApiClient googleApiClient, ProxyRequest proxyRequest) {
        super(googleApiClient);
        this.zzce = proxyRequest;
    }

    @Override
    protected final void zza(Context context, zzan zzanVar) throws RemoteException {
        zzanVar.zza(new zzat(this), this.zzce);
    }
}
