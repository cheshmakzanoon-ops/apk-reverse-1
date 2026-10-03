package com.google.android.gms.internal.p003authapi;

import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.auth.api.credentials.CredentialRequest;

public final class zzw extends zzd implements zzx {
    zzw(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.auth.api.credentials.internal.ICredentialsService");
    }

    @Override
    public final void zzc(zzv zzvVar, CredentialRequest credentialRequest) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        zzf.zzc(parcelObtainAndWriteInterfaceToken, zzvVar);
        zzf.zzc(parcelObtainAndWriteInterfaceToken, credentialRequest);
        transactAndReadExceptionReturnVoid(1, parcelObtainAndWriteInterfaceToken);
    }

    @Override
    public final void zzc(zzv zzvVar, zzz zzzVar) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        zzf.zzc(parcelObtainAndWriteInterfaceToken, zzvVar);
        zzf.zzc(parcelObtainAndWriteInterfaceToken, zzzVar);
        transactAndReadExceptionReturnVoid(2, parcelObtainAndWriteInterfaceToken);
    }

    @Override
    public final void zzc(zzv zzvVar, zzt zztVar) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        zzf.zzc(parcelObtainAndWriteInterfaceToken, zzvVar);
        zzf.zzc(parcelObtainAndWriteInterfaceToken, zztVar);
        transactAndReadExceptionReturnVoid(3, parcelObtainAndWriteInterfaceToken);
    }

    @Override
    public final void zzc(zzv zzvVar) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        zzf.zzc(parcelObtainAndWriteInterfaceToken, zzvVar);
        transactAndReadExceptionReturnVoid(4, parcelObtainAndWriteInterfaceToken);
    }
}
