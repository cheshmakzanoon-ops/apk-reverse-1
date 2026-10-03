package com.google.android.gms.internal.p003authapi;

import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.auth.api.identity.BeginSignInResult;
import com.google.android.gms.common.api.Status;

public abstract class zzaa extends zzc implements zzab {
    public zzaa() {
        super("com.google.android.gms.auth.api.identity.internal.IBeginSignInCallback");
    }

    @Override
    protected final boolean dispatchTransaction(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        if (i != 1) {
            return false;
        }
        zzc((Status) zzf.zzc(parcel, Status.CREATOR), (BeginSignInResult) zzf.zzc(parcel, BeginSignInResult.CREATOR));
        return true;
    }
}
