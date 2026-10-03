package com.google.android.gms.measurement.internal;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.common.internal.safeparcel.AbstractSafeParcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;

public final class zzad extends AbstractSafeParcelable {
    public static final Parcelable.Creator<zzad> CREATOR = new zzag();
    public String zza;
    public String zzb;
    public zznc zzc;
    public long zzd;
    public boolean zze;
    public String zzf;
    public zzbg zzg;
    public long zzh;
    public zzbg zzi;
    public long zzj;
    public zzbg zzk;

    zzad(zzad zzadVar) {
        Preconditions.checkNotNull(zzadVar);
        this.zza = zzadVar.zza;
        this.zzb = zzadVar.zzb;
        this.zzc = zzadVar.zzc;
        this.zzd = zzadVar.zzd;
        this.zze = zzadVar.zze;
        this.zzf = zzadVar.zzf;
        this.zzg = zzadVar.zzg;
        this.zzh = zzadVar.zzh;
        this.zzi = zzadVar.zzi;
        this.zzj = zzadVar.zzj;
        this.zzk = zzadVar.zzk;
    }

    zzad(String str, String str2, zznc zzncVar, long j, boolean z, String str3, zzbg zzbgVar, long j2, zzbg zzbgVar2, long j3, zzbg zzbgVar3) {
        this.zza = str;
        this.zzb = str2;
        this.zzc = zzncVar;
        this.zzd = j;
        this.zze = z;
        this.zzf = str3;
        this.zzg = zzbgVar;
        this.zzh = j2;
        this.zzi = zzbgVar2;
        this.zzj = j3;
        this.zzk = zzbgVar3;
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeString(parcel, 2, this.zza, false);
        SafeParcelWriter.writeString(parcel, 3, this.zzb, false);
        SafeParcelWriter.writeParcelable(parcel, 4, this.zzc, i, false);
        SafeParcelWriter.writeLong(parcel, 5, this.zzd);
        SafeParcelWriter.writeBoolean(parcel, 6, this.zze);
        SafeParcelWriter.writeString(parcel, 7, this.zzf, false);
        SafeParcelWriter.writeParcelable(parcel, 8, this.zzg, i, false);
        SafeParcelWriter.writeLong(parcel, 9, this.zzh);
        SafeParcelWriter.writeParcelable(parcel, 10, this.zzi, i, false);
        SafeParcelWriter.writeLong(parcel, 11, this.zzj);
        SafeParcelWriter.writeParcelable(parcel, 12, this.zzk, i, false);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }
}
