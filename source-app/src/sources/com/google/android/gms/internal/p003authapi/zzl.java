package com.google.android.gms.internal.p003authapi;

import com.google.android.gms.auth.api.credentials.Credential;
import com.google.android.gms.common.api.Status;

final class zzl extends zzh {
    private final zzi zzap;

    zzl(zzi zziVar) {
        this.zzap = zziVar;
    }

    @Override
    public final void zzc(Status status, Credential credential) {
        this.zzap.setResult(new zzg(status, credential));
    }

    @Override
    public final void zzd(Status status) {
        this.zzap.setResult(zzg.zzc(status));
    }
}
