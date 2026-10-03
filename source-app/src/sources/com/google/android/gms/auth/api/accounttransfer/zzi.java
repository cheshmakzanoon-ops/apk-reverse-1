package com.google.android.gms.auth.api.accounttransfer;

import android.os.RemoteException;
import com.google.android.gms.internal.auth.zzah;
import com.google.android.gms.internal.auth.zzz;

final class zzi extends AccountTransferClient.zzc {
    private final zzah zzat;

    zzi(AccountTransferClient accountTransferClient, zzah zzahVar) {
        super(null);
        this.zzat = zzahVar;
    }

    @Override
    protected final void zza(zzz zzzVar) throws RemoteException {
        zzzVar.zza(this.zzax, this.zzat);
    }
}
