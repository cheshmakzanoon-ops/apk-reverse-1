package com.google.android.gms.internal.auth;

import android.accounts.Account;
import com.google.android.gms.common.api.Status;

final class zzk extends zzn {
    private final zzj zzaf;

    zzk(zzj zzjVar) {
        this.zzaf = zzjVar;
    }

    @Override
    public final void zzc(Account account) {
        this.zzaf.setResult(new zzo(account != null ? Status.RESULT_SUCCESS : zzh.zzad, account));
    }
}
