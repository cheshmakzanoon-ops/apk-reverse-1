package com.google.android.gms.auth.api.signin.internal;

import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.auth.api.signin.GoogleSignInAccount;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.location.LocationRequest;

public abstract class zzs extends com.google.android.gms.internal.p003authapi.zzc implements zzt {
    public zzs() {
        super("com.google.android.gms.auth.api.signin.internal.ISignInCallbacks");
    }

    @Override
    protected final boolean dispatchTransaction(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        switch (i) {
            case 101:
                zzc((GoogleSignInAccount) com.google.android.gms.internal.p003authapi.zzf.zzc(parcel, GoogleSignInAccount.CREATOR), (Status) com.google.android.gms.internal.p003authapi.zzf.zzc(parcel, Status.CREATOR));
                break;
            case LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY:
                zze((Status) com.google.android.gms.internal.p003authapi.zzf.zzc(parcel, Status.CREATOR));
                break;
            case 103:
                zzf((Status) com.google.android.gms.internal.p003authapi.zzf.zzc(parcel, Status.CREATOR));
                break;
            default:
                return false;
        }
        parcel2.writeNoException();
        return true;
    }
}
