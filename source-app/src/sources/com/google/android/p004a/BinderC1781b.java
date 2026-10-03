package com.google.android.p004a;

import android.os.Binder;
import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public class BinderC1781b extends Binder implements IInterface {
    protected BinderC1781b() {
        attachInterface(this, "com.google.android.finsky.externalreferrer.IGetInstallReferrerService");
    }

    protected boolean m212a(int i, Parcel parcel, Parcel parcel2) throws RemoteException {
        throw null;
    }

    @Override
    public final IBinder asBinder() {
        return this;
    }

    @Override
    public final boolean onTransact(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        if (i <= 16777215) {
            parcel.enforceInterface(getInterfaceDescriptor());
        } else if (super.onTransact(i, parcel, parcel2, i2)) {
            return true;
        }
        return m212a(i, parcel, parcel2);
    }
}
