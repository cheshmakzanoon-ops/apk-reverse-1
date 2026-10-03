package com.google.android.gms.internal.p003authapi;

import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.auth.api.identity.BeginSignInRequest;
import com.google.android.gms.common.api.internal.IStatusCallback;

public final class zzac extends zzd implements zzad {
    zzac(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.auth.api.identity.internal.ISignInService");
    }

    @Override
    public final void zzc(zzab zzabVar, BeginSignInRequest beginSignInRequest) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        zzf.zzc(parcelObtainAndWriteInterfaceToken, zzabVar);
        zzf.zzc(parcelObtainAndWriteInterfaceToken, beginSignInRequest);
        transactAndReadExceptionReturnVoid(1, parcelObtainAndWriteInterfaceToken);
    }

    @Override
    public final void zzc(IStatusCallback iStatusCallback, String str) throws RemoteException {
        Parcel parcelObtainAndWriteInterfaceToken = obtainAndWriteInterfaceToken();
        zzf.zzc(parcelObtainAndWriteInterfaceToken, iStatusCallback);
        parcelObtainAndWriteInterfaceToken.writeString(str);
        transactAndReadExceptionReturnVoid(2, parcelObtainAndWriteInterfaceToken);
    }
}
