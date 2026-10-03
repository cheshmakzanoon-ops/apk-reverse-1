package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;

public final class zzca extends zzbu implements zzby {
    @Override
    public final Bundle zza(Bundle bundle) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        zzbw.zza(parcelM23a_, bundle);
        Parcel parcelZza = zza(1, parcelM23a_);
        Bundle bundle2 = (Bundle) zzbw.zza(parcelZza, Bundle.CREATOR);
        parcelZza.recycle();
        return bundle2;
    }

    zzca(IBinder iBinder) {
        super(iBinder, "com.google.android.finsky.externalreferrer.IGetInstallReferrerService");
    }
}
