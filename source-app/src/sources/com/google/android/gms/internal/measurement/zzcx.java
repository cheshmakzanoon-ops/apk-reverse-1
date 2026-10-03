package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;

public final class zzcx extends zzbu implements zzcv {
    zzcx(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.measurement.api.internal.IBundleReceiver");
    }

    @Override
    public final void zza(Bundle bundle) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, bundle);
        zzb(1, parcelM23a_);
    }
}
