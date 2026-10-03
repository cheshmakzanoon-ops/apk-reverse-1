package com.google.android.gms.auth.api.accounttransfer;

import android.os.RemoteException;
import com.google.android.gms.internal.auth.zzad;
import com.google.android.gms.internal.auth.zzz;

final class zze extends AccountTransferClient.zzb<byte[]> {
    private final zzad zzap;

    zze(AccountTransferClient accountTransferClient, zzad zzadVar) {
        super(null);
        this.zzap = zzadVar;
    }

    @Override
    protected final void zza(zzz zzzVar) throws RemoteException {
        zzzVar.zza(new zzf(this, this), this.zzap);
    }
}
