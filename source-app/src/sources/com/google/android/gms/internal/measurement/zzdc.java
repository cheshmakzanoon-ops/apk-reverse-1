package com.google.android.gms.internal.measurement;

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;

public final class zzdc extends zzbu implements zzda {
    @Override
    public final int zza() throws RemoteException {
        Parcel parcelZza = zza(2, m23a_());
        int i = parcelZza.readInt();
        parcelZza.recycle();
        return i;
    }

    zzdc(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.measurement.api.internal.IEventHandlerProxy");
    }

    @Override
    public final void zza(String str, String str2, Bundle bundle, long j) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        zzbw.zza(parcelM23a_, bundle);
        parcelM23a_.writeLong(j);
        zzb(1, parcelM23a_);
    }
}
