package com.google.android.gms.auth.api.signin.internal;

import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.auth.api.signin.GoogleSignInOptions;
import com.google.android.gms.location.LocationRequest;

public final class zzu extends com.google.android.gms.internal.p003authapi.zzd implements zzv {
    zzu(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.auth.api.signin.internal.ISignInService");
    }

    @Override
    public final void zzc(zzt zztVar, GoogleSignInOptions googleSignInOptions) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        com.google.android.gms.internal.p003authapi.zzf.zzc(parcelObtainAndWriteInterfaceToken, zztVar);
        com.google.android.gms.internal.p003authapi.zzf.zzc(parcelObtainAndWriteInterfaceToken, googleSignInOptions);
        transactAndReadExceptionReturnVoid(101, parcelObtainAndWriteInterfaceToken);
    }

    @Override
    public final void zzd(zzt zztVar, GoogleSignInOptions googleSignInOptions) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        com.google.android.gms.internal.p003authapi.zzf.zzc(parcelObtainAndWriteInterfaceToken, zztVar);
        com.google.android.gms.internal.p003authapi.zzf.zzc(parcelObtainAndWriteInterfaceToken, googleSignInOptions);
        transactAndReadExceptionReturnVoid(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY, parcelObtainAndWriteInterfaceToken);
    }

    @Override
    public final void zze(zzt zztVar, GoogleSignInOptions googleSignInOptions) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        com.google.android.gms.internal.p003authapi.zzf.zzc(parcelObtainAndWriteInterfaceToken, zztVar);
        com.google.android.gms.internal.p003authapi.zzf.zzc(parcelObtainAndWriteInterfaceToken, googleSignInOptions);
        transactAndReadExceptionReturnVoid(103, parcelObtainAndWriteInterfaceToken);
    }
}
