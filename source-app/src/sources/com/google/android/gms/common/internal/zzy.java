package com.google.android.gms.common.internal;

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;

public final class zzy extends com.google.android.gms.internal.common.zza implements IGmsCallbacks {
    zzy(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.common.internal.IGmsCallbacks");
    }

    @Override
    public final void onPostInitComplete(int i, IBinder iBinder, Bundle bundle) throws RemoteException {
        Parcel parcelZza = zza();
        parcelZza.writeInt(i);
        parcelZza.writeStrongBinder(iBinder);
        com.google.android.gms.internal.common.zzc.zzc(parcelZza, bundle);
        zzD(1, parcelZza);
    }

    @Override
    public final void zzb(int i, Bundle bundle) throws RemoteException {
        throw null;
    }

    @Override
    public final void zzc(int i, IBinder iBinder, zzj zzjVar) throws RemoteException {
        throw null;
    }
}
