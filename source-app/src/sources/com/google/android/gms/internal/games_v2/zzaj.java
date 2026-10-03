package com.google.android.gms.internal.games_v2;

import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;

public final class zzaj extends zza implements zzal {
    zzaj(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.games.internal.recall.IRecallService");
    }

    @Override
    public final void zzd(zzai zzaiVar, String str) throws RemoteException {
        Parcel parcelZza = zza();
        zzc.zzd(parcelZza, zzaiVar);
        parcelZza.writeString("unusedServerClientId");
        zzc(2, parcelZza);
    }
}
