package com.google.android.gms.auth.api.accounttransfer;

import android.os.RemoteException;
import com.google.android.gms.internal.auth.zzz;

final class zzg extends AccountTransferClient.zzb<DeviceMetaData> {
    private final com.google.android.gms.internal.auth.zzv zzar;

    zzg(AccountTransferClient accountTransferClient, com.google.android.gms.internal.auth.zzv zzvVar) {
        super(null);
        this.zzar = zzvVar;
    }

    @Override
    protected final void zza(zzz zzzVar) throws RemoteException {
        zzzVar.zza(new zzh(this, this), this.zzar);
    }
}
