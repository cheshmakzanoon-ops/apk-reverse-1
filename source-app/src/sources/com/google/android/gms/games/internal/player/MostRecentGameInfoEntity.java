package com.google.android.gms.games.internal.player;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Objects;

public final class MostRecentGameInfoEntity extends com.google.android.gms.games.internal.zzg implements zza {
    public static final Parcelable.Creator<MostRecentGameInfoEntity> CREATOR = new zzb();
    private final String zza;
    private final String zzb;
    private final long zzc;
    private final Uri zzd;
    private final Uri zze;
    private final Uri zzf;

    public MostRecentGameInfoEntity(zza zzaVar) {
        this.zza = zzaVar.zza();
        this.zzb = zzaVar.zzb();
        this.zzc = zzaVar.zzc();
        this.zzd = zzaVar.zzd();
        this.zze = zzaVar.zze();
        this.zzf = zzaVar.zzf();
    }

    static int zzg(zza zzaVar) {
        return Objects.hashCode(zzaVar.zza(), zzaVar.zzb(), Long.valueOf(zzaVar.zzc()), zzaVar.zzd(), zzaVar.zze(), zzaVar.zzf());
    }

    static boolean zzh(zza zzaVar, Object obj) {
        if (!(obj instanceof zza)) {
            return false;
        }
        if (zzaVar == obj) {
            return true;
        }
        zza zzaVar2 = (zza) obj;
        return Objects.equal(zzaVar2.zza(), zzaVar.zza()) && Objects.equal(zzaVar2.zzb(), zzaVar.zzb()) && Objects.equal(Long.valueOf(zzaVar2.zzc()), Long.valueOf(zzaVar.zzc())) && Objects.equal(zzaVar2.zzd(), zzaVar.zzd()) && Objects.equal(zzaVar2.zze(), zzaVar.zze()) && Objects.equal(zzaVar2.zzf(), zzaVar.zzf());
    }

    static String zzi(zza zzaVar) {
        return Objects.toStringHelper(zzaVar).add("GameId", zzaVar.zza()).add("GameName", zzaVar.zzb()).add("ActivityTimestampMillis", Long.valueOf(zzaVar.zzc())).add("GameIconUri", zzaVar.zzd()).add("GameHiResUri", zzaVar.zze()).add("GameFeaturedUri", zzaVar.zzf()).toString();
    }

    public final boolean equals(Object obj) {
        return zzh(this, obj);
    }

    @Override
    public final Object freeze() {
        return this;
    }

    public final int hashCode() {
        return zzg(this);
    }

    @Override
    public final boolean isDataValid() {
        return true;
    }

    public final String toString() {
        return zzi(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        zzb.zza(this, parcel, i);
    }

    @Override
    public final String zza() {
        return this.zza;
    }

    @Override
    public final String zzb() {
        return this.zzb;
    }

    @Override
    public final long zzc() {
        return this.zzc;
    }

    @Override
    public final Uri zzd() {
        return this.zzd;
    }

    @Override
    public final Uri zze() {
        return this.zze;
    }

    @Override
    public final Uri zzf() {
        return this.zzf;
    }

    MostRecentGameInfoEntity(String str, String str2, long j, Uri uri, Uri uri2, Uri uri3) {
        this.zza = str;
        this.zzb = str2;
        this.zzc = j;
        this.zzd = uri;
        this.zze = uri2;
        this.zzf = uri3;
    }
}
