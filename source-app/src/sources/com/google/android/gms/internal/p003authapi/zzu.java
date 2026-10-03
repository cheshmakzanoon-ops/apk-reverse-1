package com.google.android.gms.internal.p003authapi;

import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.auth.api.credentials.Credential;
import com.google.android.gms.common.api.Status;

public abstract class zzu extends zzc implements zzv {
    public zzu() {
        super("com.google.android.gms.auth.api.credentials.internal.ICredentialsCallbacks");
    }

    @Override
    protected final boolean dispatchTransaction(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        if (i == 1) {
            zzc((Status) zzf.zzc(parcel, Status.CREATOR), (Credential) zzf.zzc(parcel, Credential.CREATOR));
        } else if (i == 2) {
            zzd((Status) zzf.zzc(parcel, Status.CREATOR));
        } else {
            if (i != 3) {
                return false;
            }
            zzc((Status) zzf.zzc(parcel, Status.CREATOR), parcel.readString());
        }
        parcel2.writeNoException();
        return true;
    }
}
