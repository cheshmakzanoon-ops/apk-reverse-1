package com.google.android.gms.internal.play_billing;

import android.os.Parcel;
import android.os.RemoteException;

public abstract class zzaz extends zzat implements zzba {
    public zzaz() {
        super("com.google.android.apps.play.billingtestcompanion.aidl.IBillingOverrideServiceCallback");
    }

    @Override
    protected final boolean dispatchTransaction(int i, Parcel parcel, Parcel parcel2, int i2) throws RemoteException {
        if (i != 1) {
            return false;
        }
        int i3 = parcel.readInt();
        enforceNoDataAvail(parcel);
        zza(i3);
        return true;
    }
}
