package com.google.android.gms.auth.api.accounttransfer;

import android.os.RemoteException;
import com.google.android.gms.internal.auth.zzaf;
import com.google.android.gms.internal.auth.zzz;

final class zzd extends AccountTransferClient.zzc {
    private final zzaf zzao;

    zzd(AccountTransferClient accountTransferClient, zzaf zzafVar) {
        super(null);
        this.zzao = zzafVar;
    }

    @Override
    protected final void zza(zzz zzzVar) throws RemoteException {
        zzzVar.zza(this.zzax, this.zzao);
    }
}
