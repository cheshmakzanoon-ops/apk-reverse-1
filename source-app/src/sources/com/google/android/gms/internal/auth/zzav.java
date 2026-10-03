package com.google.android.gms.internal.auth;

import com.google.android.gms.auth.api.proxy.AuthApiStatusCodes;
import com.google.android.gms.common.api.Status;

final class zzav extends zzaj {
    private final zzau zzcg;

    zzav(zzau zzauVar) {
        this.zzcg = zzauVar;
    }

    @Override
    public final void zzb(String str) {
        if (str != null) {
            this.zzcg.setResult(new zzax(str));
        } else {
            this.zzcg.setResult(zzau.zzc(new Status(AuthApiStatusCodes.AUTH_APP_CERT_ERROR)));
        }
    }
}
