package com.google.android.gms.games.internal.p000v2.appshortcuts;

import android.os.IBinder;
import android.os.IInterface;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.internal.games_v2.zza;
import com.google.android.gms.internal.games_v2.zzc;
import java.util.List;

public final class zzv extends zza implements IInterface {
    zzv(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.games.internal.v2.appshortcuts.IAppShortcutsService");
    }

    public final void zzd(zzx zzxVar, zzr zzrVar, List list, List list2) throws RemoteException {
        Parcel parcelZza = zza();
        zzc.zzd(parcelZza, zzxVar);
        zzc.zzc(parcelZza, zzrVar);
        parcelZza.writeTypedList(list);
        parcelZza.writeTypedList(list2);
        zzc(3, parcelZza);
    }

    public final void zze(zzx zzxVar, zzr zzrVar, zzi zziVar) throws RemoteException {
        Parcel parcelZza = zza();
        zzc.zzd(parcelZza, zzxVar);
        zzc.zzc(parcelZza, zzrVar);
        zzc.zzc(parcelZza, zziVar);
        zzc(4, parcelZza);
    }
}
