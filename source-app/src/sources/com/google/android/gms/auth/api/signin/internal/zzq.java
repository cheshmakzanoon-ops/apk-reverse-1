package com.google.android.gms.auth.api.signin.internal;

import android.os.Parcel;
import android.os.RemoteException;

public abstract class zzq extends com.google.android.gms.internal.p003authapi.zzc implements zzr {
    public zzq() {
        super("com.google.android.gms.auth.api.signin.internal.IRevocationService");
    }

    @Override
    protected final boolean dispatchTransaction(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        if (i == 1) {
            zzm();
        } else {
            if (i != 2) {
                return false;
            }
            zzn();
        }
        return true;
    }
}
