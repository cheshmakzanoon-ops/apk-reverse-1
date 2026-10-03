package com.google.android.gms.auth;

import android.accounts.Account;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import java.io.IOException;

final class zzh implements zzj<Bundle> {
    private final Account zzo;

    zzh(Account account) {
        this.zzo = account;
    }

    @Override
    public final Bundle zzb(IBinder iBinder) throws RemoteException, IOException, GoogleAuthException {
        return (Bundle) zzd.zza(com.google.android.gms.internal.auth.zzf.zza(iBinder).zza(this.zzo));
    }
}
