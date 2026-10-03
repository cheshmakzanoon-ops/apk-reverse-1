package com.google.android.gms.common.internal;

import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import com.google.android.gms.dynamic.IObjectWrapper;

public final class zzab extends com.google.android.gms.internal.common.zza implements zzad {
    zzab(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.common.internal.IGoogleCertificatesApi");
    }

    @Override
    public final boolean zze(com.google.android.gms.common.zzt zztVar, IObjectWrapper iObjectWrapper) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.common.zzc.zzc(parcelZza, zztVar);
        com.google.android.gms.internal.common.zzc.zze(parcelZza, iObjectWrapper);
        Parcel parcelZzB = zzB(5, parcelZza);
        boolean zZza = com.google.android.gms.internal.common.zzc.zza(parcelZzB);
        parcelZzB.recycle();
        return zZza;
    }

    @Override
    public final com.google.android.gms.common.zzr zzf(com.google.android.gms.common.zzp zzpVar) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.common.zzc.zzc(parcelZza, zzpVar);
        Parcel parcelZzB = zzB(6, parcelZza);
        com.google.android.gms.common.zzr zzrVar = (com.google.android.gms.common.zzr) com.google.android.gms.internal.common.zzc.zzb(parcelZzB, com.google.android.gms.common.zzr.CREATOR);
        parcelZzB.recycle();
        return zzrVar;
    }

    @Override
    public final boolean zzg() throws RemoteException {
        Parcel parcelZzB = zzB(7, zza());
        boolean zZza = com.google.android.gms.internal.common.zzc.zza(parcelZzB);
        parcelZzB.recycle();
        return zZza;
    }

    @Override
    public final com.google.android.gms.common.zzr zzh(com.google.android.gms.common.zzp zzpVar) throws RemoteException {
        Parcel parcelZza = zza();
        com.google.android.gms.internal.common.zzc.zzc(parcelZza, zzpVar);
        Parcel parcelZzB = zzB(8, parcelZza);
        com.google.android.gms.common.zzr zzrVar = (com.google.android.gms.common.zzr) com.google.android.gms.internal.common.zzc.zzb(parcelZzB, com.google.android.gms.common.zzr.CREATOR);
        parcelZzB.recycle();
        return zzrVar;
    }

    @Override
    public final boolean zzi() throws RemoteException {
        Parcel parcelZzB = zzB(9, zza());
        boolean zZza = com.google.android.gms.internal.common.zzc.zza(parcelZzB);
        parcelZzB.recycle();
        return zZza;
    }
}
