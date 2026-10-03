package com.google.android.gms.auth.api.accounttransfer;

import android.os.RemoteException;
import com.google.android.gms.internal.auth.zzab;
import com.google.android.gms.internal.auth.zzz;

final class zzj extends AccountTransferClient.zzc {
    private final zzab zzau;

    zzj(AccountTransferClient accountTransferClient, zzab zzabVar) {
        super(null);
        this.zzau = zzabVar;
    }

    @Override
    protected final void zza(zzz zzzVar) throws RemoteException {
        zzzVar.zza(this.zzax, this.zzau);
    }
}
