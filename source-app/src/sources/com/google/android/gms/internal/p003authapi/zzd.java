package com.google.android.gms.internal.p003authapi;

import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public class zzd implements IInterface {
    private final IBinder zzd;
    private final String zze;

    protected zzd(IBinder iBinder, String str) {
        this.zzd = iBinder;
        this.zze = str;
    }

    @Override
    public IBinder asBinder() {
        return this.zzd;
    }

    protected final Parcel obtainAndWriteInterfaceToken() {
        Parcel parcelObtain = Parcel.obtain();
        parcelObtain.writeInterfaceToken(this.zze);
        return parcelObtain;
    }

    protected final void transactAndReadExceptionReturnVoid(int i, Parcel parcel) throws RemoteException {
        Parcel parcelObtain = Parcel.obtain();
        try {
            this.zzd.transact(i, parcel, parcelObtain, 0);
            parcelObtain.readException();
        } finally {
            parcel.recycle();
            parcelObtain.recycle();
        }
    }
}
