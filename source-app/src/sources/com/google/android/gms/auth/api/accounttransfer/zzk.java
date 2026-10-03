package com.google.android.gms.auth.api.accounttransfer;

import com.google.android.gms.common.api.Status;

final class zzk extends com.google.android.gms.internal.auth.zzs {
    private final AccountTransferClient.zzc zzay;

    zzk(AccountTransferClient.zzc zzcVar) {
        this.zzay = zzcVar;
    }

    @Override
    public final void zzd() {
        this.zzay.setResult(null);
    }

    @Override
    public final void onFailure(Status status) {
        this.zzay.zza(status);
    }
}
