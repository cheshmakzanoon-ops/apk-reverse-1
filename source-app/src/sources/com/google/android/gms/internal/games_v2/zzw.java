package com.google.android.gms.internal.games_v2;

import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;

public final class zzw extends zza implements IInterface {
    zzw(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.games.internal.connect.IGamesConnectService");
    }

    public final void zzd(zzv zzvVar, zzq zzqVar) throws RemoteException {
        Parcel parcelZza = zza();
        zzc.zzd(parcelZza, zzvVar);
        zzc.zzc(parcelZza, zzqVar);
        zzc(2, parcelZza);
    }
}
