package com.google.android.gms.auth;

import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import java.io.IOException;

final class zzf implements zzj<Void> {
    private final Bundle val$extras;
    private final String zzq;

    zzf(String str, Bundle bundle) {
        this.zzq = str;
        this.val$extras = bundle;
    }

    @Override
    public final Void zzb(IBinder iBinder) throws GoogleAuthException, RemoteException, IOException {
        Bundle bundle = (Bundle) zzd.zza(com.google.android.gms.internal.auth.zzf.zza(iBinder).zza(this.zzq, this.val$extras));
        String string = bundle.getString("Error");
        if (bundle.getBoolean("booleanResult")) {
            return null;
        }
        throw new GoogleAuthException(string);
    }
}
