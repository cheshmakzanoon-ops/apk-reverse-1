package com.google.android.gms.measurement.internal;

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.RemoteException;
import java.util.ArrayList;
import java.util.List;

public final class zzfm extends com.google.android.gms.internal.measurement.zzbu implements zzfk {
    @Override
    public final zzam zza(zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        Parcel parcelZza = zza(21, parcelM23a_);
        zzam zzamVar = (zzam) com.google.android.gms.internal.measurement.zzbw.zza(parcelZza, zzam.CREATOR);
        parcelZza.recycle();
        return zzamVar;
    }

    @Override
    public final String zzb(zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        Parcel parcelZza = zza(11, parcelM23a_);
        String string = parcelZza.readString();
        parcelZza.recycle();
        return string;
    }

    @Override
    public final List<zzmh> zza(zzo zzoVar, Bundle bundle) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, bundle);
        Parcel parcelZza = zza(24, parcelM23a_);
        ArrayList arrayListCreateTypedArrayList = parcelZza.createTypedArrayList(zzmh.CREATOR);
        parcelZza.recycle();
        return arrayListCreateTypedArrayList;
    }

    @Override
    public final List<zznc> zza(zzo zzoVar, boolean z) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, z);
        Parcel parcelZza = zza(7, parcelM23a_);
        ArrayList arrayListCreateTypedArrayList = parcelZza.createTypedArrayList(zznc.CREATOR);
        parcelZza.recycle();
        return arrayListCreateTypedArrayList;
    }

    @Override
    public final List<zzad> zza(String str, String str2, zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        Parcel parcelZza = zza(16, parcelM23a_);
        ArrayList arrayListCreateTypedArrayList = parcelZza.createTypedArrayList(zzad.CREATOR);
        parcelZza.recycle();
        return arrayListCreateTypedArrayList;
    }

    @Override
    public final List<zzad> zza(String str, String str2, String str3) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        parcelM23a_.writeString(str3);
        Parcel parcelZza = zza(17, parcelM23a_);
        ArrayList arrayListCreateTypedArrayList = parcelZza.createTypedArrayList(zzad.CREATOR);
        parcelZza.recycle();
        return arrayListCreateTypedArrayList;
    }

    @Override
    public final List<zznc> zza(String str, String str2, boolean z, zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, z);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        Parcel parcelZza = zza(14, parcelM23a_);
        ArrayList arrayListCreateTypedArrayList = parcelZza.createTypedArrayList(zznc.CREATOR);
        parcelZza.recycle();
        return arrayListCreateTypedArrayList;
    }

    @Override
    public final List<zznc> zza(String str, String str2, String str3, boolean z) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        parcelM23a_.writeString(str3);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, z);
        Parcel parcelZza = zza(15, parcelM23a_);
        ArrayList arrayListCreateTypedArrayList = parcelZza.createTypedArrayList(zznc.CREATOR);
        parcelZza.recycle();
        return arrayListCreateTypedArrayList;
    }

    zzfm(IBinder iBinder) {
        super(iBinder, "com.google.android.gms.measurement.internal.IMeasurementService");
    }

    @Override
    public final void zzc(zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        zzb(4, parcelM23a_);
    }

    @Override
    public final void zza(zzbg zzbgVar, zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzbgVar);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        zzb(1, parcelM23a_);
    }

    @Override
    public final void zza(zzbg zzbgVar, String str, String str2) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzbgVar);
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        zzb(5, parcelM23a_);
    }

    @Override
    public final void zzd(zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        zzb(18, parcelM23a_);
    }

    @Override
    public final void zza(zzad zzadVar, zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzadVar);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        zzb(12, parcelM23a_);
    }

    @Override
    public final void zza(zzad zzadVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzadVar);
        zzb(13, parcelM23a_);
    }

    @Override
    public final void zze(zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        zzb(20, parcelM23a_);
    }

    @Override
    public final void zza(long j, String str, String str2, String str3) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        parcelM23a_.writeLong(j);
        parcelM23a_.writeString(str);
        parcelM23a_.writeString(str2);
        parcelM23a_.writeString(str3);
        zzb(10, parcelM23a_);
    }

    @Override
    public final void zza(Bundle bundle, zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, bundle);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        zzb(19, parcelM23a_);
    }

    @Override
    public final void zzf(zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        zzb(6, parcelM23a_);
    }

    @Override
    public final void zza(zznc zzncVar, zzo zzoVar) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzncVar);
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzoVar);
        zzb(2, parcelM23a_);
    }

    @Override
    public final byte[] zza(zzbg zzbgVar, String str) throws RemoteException {
        Parcel parcelM23a_ = m23a_();
        com.google.android.gms.internal.measurement.zzbw.zza(parcelM23a_, zzbgVar);
        parcelM23a_.writeString(str);
        Parcel parcelZza = zza(9, parcelM23a_);
        byte[] bArrCreateByteArray = parcelZza.createByteArray();
        parcelZza.recycle();
        return bArrCreateByteArray;
    }
}
