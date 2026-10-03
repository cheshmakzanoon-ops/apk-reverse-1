package com.google.android.p004a;

import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public class C1780a implements IInterface {

    private final IBinder f165a;

    private final String f166b = "com.google.android.finsky.externalreferrer.IGetInstallReferrerService";

    protected C1780a(IBinder iBinder) {
        this.f165a = iBinder;
    }

    protected final Parcel m210a() {
        Parcel parcelObtain = Parcel.obtain();
        parcelObtain.writeInterfaceToken(this.f166b);
        return parcelObtain;
    }

    @Override
    public final IBinder asBinder() {
        return this.f165a;
    }

    protected final Parcel m211b(Parcel parcel) throws RemoteException {
        Parcel parcelObtain = Parcel.obtain();
        try {
            try {
                this.f165a.transact(1, parcel, parcelObtain, 0);
                parcelObtain.readException();
                parcel.recycle();
                return parcelObtain;
            } catch (RuntimeException e) {
                parcelObtain.recycle();
                throw e;
            }
        } catch (Throwable th) {
            parcel.recycle();
            throw th;
        }
    }
}
