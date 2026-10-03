package com.google.android.gms.auth.api.signin.internal;

import android.content.Context;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;

public final class zzo {
    private static zzo zzci;
    private Storage zzcj;
    private GoogleSignInAccount zzck;
    private GoogleSignInOptions zzcl;

    private zzo(Context context) {
        Storage storage = Storage.getInstance(context);
        this.zzcj = storage;
        this.zzck = storage.getSavedDefaultGoogleSignInAccount();
        this.zzcl = this.zzcj.getSavedDefaultGoogleSignInOptions();
    }

    public static synchronized zzo zzd(Context context) {
        return zze(context.getApplicationContext());
    }

    private static synchronized zzo zze(Context context) {
        zzo zzoVar = zzci;
        if (zzoVar != null) {
            return zzoVar;
        }
        zzo zzoVar2 = new zzo(context);
        zzci = zzoVar2;
        return zzoVar2;
    }

    public final synchronized void clear() {
        this.zzcj.clear();
        this.zzck = null;
        this.zzcl = null;
    }

    public final synchronized void zzc(GoogleSignInOptions googleSignInOptions, GoogleSignInAccount googleSignInAccount) {
        this.zzcj.saveDefaultGoogleSignInAccount(googleSignInAccount, googleSignInOptions);
        this.zzck = googleSignInAccount;
        this.zzcl = googleSignInOptions;
    }

    public final synchronized GoogleSignInAccount zzk() {
        return this.zzck;
    }

    public final synchronized GoogleSignInOptions zzl() {
        return this.zzcl;
    }
}
