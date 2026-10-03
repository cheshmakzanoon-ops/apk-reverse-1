package com.google.android.gms.auth;

import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import com.google.android.gms.common.logging.Logger;
import com.google.android.gms.internal.auth.zzay;
import java.io.IOException;

final class zzi implements zzj<Boolean> {
    private final String zzt;

    zzi(String str) {
        this.zzt = str;
    }

    @Override
    public final Boolean zzb(IBinder iBinder) throws GoogleAuthException, RemoteException, IOException {
        Bundle bundle = (Bundle) zzd.zza(com.google.android.gms.internal.auth.zzf.zza(iBinder).zza(this.zzt));
        String string = bundle.getString("Error");
        Intent intent = (Intent) bundle.getParcelable("userRecoveryIntent");
        zzay zzayVarZzc = zzay.zzc(string);
        if (zzay.SUCCESS.equals(zzayVarZzc)) {
            return true;
        }
        if (!zzay.zza(zzayVarZzc)) {
            throw new GoogleAuthException(string);
        }
        Logger logger = zzd.zzn;
        String strValueOf = String.valueOf(zzayVarZzc);
        StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 31);
        sb.append("isUserRecoverableError status: ");
        sb.append(strValueOf);
        logger.m21w("GoogleAuthUtil", sb.toString());
        throw new UserRecoverableAuthException(string, intent);
    }
}
