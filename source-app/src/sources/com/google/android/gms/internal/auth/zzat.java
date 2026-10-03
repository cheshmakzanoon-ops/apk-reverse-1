package com.google.android.gms.internal.auth;

import com.google.android.gms.auth.api.proxy.ProxyResponse;

final class zzat extends zzaj {
    private final zzas zzcf;

    zzat(zzas zzasVar) {
        this.zzcf = zzasVar;
    }

    @Override
    public final void zza(ProxyResponse proxyResponse) {
        this.zzcf.setResult(new zzaw(proxyResponse));
    }
}
