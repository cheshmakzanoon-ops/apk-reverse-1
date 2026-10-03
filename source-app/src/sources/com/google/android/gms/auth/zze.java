package com.google.android.gms.auth;

import android.accounts.Account;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.os.RemoteException;
import com.google.android.gms.common.logging.Logger;
import com.google.android.gms.internal.auth.zzay;
import java.io.IOException;

final class zze implements zzj<TokenData> {
    private final Bundle val$options;
    private final Account zzo;
    private final String zzp;

    zze(Account account, String str, Bundle bundle) {
        this.zzo = account;
        this.zzp = str;
        this.val$options = bundle;
    }

    @Override
    public final TokenData zzb(IBinder iBinder) throws GoogleAuthException, IOException, RemoteException {
        Bundle bundle = (Bundle) zzd.zza(com.google.android.gms.internal.auth.zzf.zza(iBinder).zza(this.zzo, this.zzp, this.val$options));
        TokenData tokenDataZza = TokenData.zza(bundle, "tokenDetails");
        if (tokenDataZza != null) {
            return tokenDataZza;
        }
        String string = bundle.getString("Error");
        Intent intent = (Intent) bundle.getParcelable("userRecoveryIntent");
        zzay zzayVarZzc = zzay.zzc(string);
        if (!zzay.zza(zzayVarZzc)) {
            if (zzay.NETWORK_ERROR.equals(zzayVarZzc) || zzay.SERVICE_UNAVAILABLE.equals(zzayVarZzc) || zzay.INTNERNAL_ERROR.equals(zzayVarZzc)) {
                throw new IOException(string);
            }
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
