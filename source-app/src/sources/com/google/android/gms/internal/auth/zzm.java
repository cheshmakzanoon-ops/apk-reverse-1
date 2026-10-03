package com.google.android.gms.internal.auth;

import com.google.android.gms.common.api.Status;

final class zzm extends zzn {
    private final zzl zzag;

    zzm(zzl zzlVar) {
        this.zzag = zzlVar;
    }

    @Override
    public final void zza(boolean z) {
        this.zzag.setResult(new zzq(z ? Status.RESULT_SUCCESS : zzh.zzad));
    }
}
