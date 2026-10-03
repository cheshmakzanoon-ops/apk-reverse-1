package com.google.android.gms.games.internal.experience;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;
import com.google.android.gms.games.Game;
import com.google.android.gms.games.GameEntity;
import com.google.android.gms.games.internal.zzg;

public final class ExperienceEventEntity extends zzg implements ExperienceEvent {
    public static final Parcelable.Creator<ExperienceEventEntity> CREATOR = new zza();
    private final String zza;
    private final GameEntity zzb;
    private final String zzc;
    private final String zzd;
    private final String zze;
    private final Uri zzf;
    private final long zzg;
    private final long zzh;
    private final long zzi;
    private final int zzj;
    private final int zzk;

    ExperienceEventEntity(String str, GameEntity gameEntity, String str2, String str3, String str4, Uri uri, long j, long j2, long j3, int i, int i2) {
        this.zza = str;
        this.zzb = gameEntity;
        this.zzc = str2;
        this.zzd = str3;
        this.zze = str4;
        this.zzf = uri;
        this.zzg = j;
        this.zzh = j2;
        this.zzi = j3;
        this.zzj = i;
        this.zzk = i2;
    }

    public final boolean equals(Object obj) {
        if (!(obj instanceof ExperienceEvent)) {
            return false;
        }
        if (this == obj) {
            return true;
        }
        ExperienceEvent experienceEvent = (ExperienceEvent) obj;
        return Objects.equal(experienceEvent.zza(), this.zza) && Objects.equal(experienceEvent.zzb(), this.zzb) && Objects.equal(experienceEvent.zzc(), this.zzc) && Objects.equal(experienceEvent.zzd(), this.zzd) && Objects.equal(experienceEvent.getIconImageUrl(), getIconImageUrl()) && Objects.equal(experienceEvent.zze(), this.zzf) && Objects.equal(Long.valueOf(experienceEvent.zzf()), Long.valueOf(this.zzg)) && Objects.equal(Long.valueOf(experienceEvent.zzg()), Long.valueOf(this.zzh)) && Objects.equal(Long.valueOf(experienceEvent.zzh()), Long.valueOf(this.zzi)) && Objects.equal(Integer.valueOf(experienceEvent.zzi()), Integer.valueOf(this.zzj)) && Objects.equal(Integer.valueOf(experienceEvent.zzj()), Integer.valueOf(this.zzk));
    }

    @Override
    public final ExperienceEvent freeze() {
        return this;
    }

    @Override
    public String getIconImageUrl() {
        return this.zze;
    }

    public final int hashCode() {
        return Objects.hashCode(this.zza, this.zzb, this.zzc, this.zzd, getIconImageUrl(), this.zzf, Long.valueOf(this.zzg), Long.valueOf(this.zzh), Long.valueOf(this.zzi), Integer.valueOf(this.zzj), Integer.valueOf(this.zzk));
    }

    @Override
    public final boolean isDataValid() {
        return true;
    }

    public final String toString() {
        return Objects.toStringHelper(this).add("ExperienceId", this.zza).add("Game", this.zzb).add("DisplayTitle", this.zzc).add("DisplayDescription", this.zzd).add("IconImageUrl", getIconImageUrl()).add("IconImageUri", this.zzf).add("CreatedTimestamp", Long.valueOf(this.zzg)).add("XpEarned", Long.valueOf(this.zzh)).add("CurrentXp", Long.valueOf(this.zzi)).add("Type", Integer.valueOf(this.zzj)).add("NewLevel", Integer.valueOf(this.zzk)).toString();
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        String str = this.zza;
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeString(parcel, 1, str, false);
        SafeParcelWriter.writeParcelable(parcel, 2, this.zzb, i, false);
        SafeParcelWriter.writeString(parcel, 3, this.zzc, false);
        SafeParcelWriter.writeString(parcel, 4, this.zzd, false);
        SafeParcelWriter.writeString(parcel, 5, getIconImageUrl(), false);
        SafeParcelWriter.writeParcelable(parcel, 6, this.zzf, i, false);
        SafeParcelWriter.writeLong(parcel, 7, this.zzg);
        SafeParcelWriter.writeLong(parcel, 8, this.zzh);
        SafeParcelWriter.writeLong(parcel, 9, this.zzi);
        SafeParcelWriter.writeInt(parcel, 10, this.zzj);
        SafeParcelWriter.writeInt(parcel, 11, this.zzk);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }

    @Override
    public final String zza() {
        return this.zza;
    }

    @Override
    public final Game zzb() {
        return this.zzb;
    }

    @Override
    public final String zzc() {
        return this.zzc;
    }

    @Override
    public final String zzd() {
        return this.zzd;
    }

    @Override
    public final Uri zze() {
        return this.zzf;
    }

    @Override
    public final long zzf() {
        return this.zzg;
    }

    @Override
    public final long zzg() {
        return this.zzh;
    }

    @Override
    public final long zzh() {
        return this.zzi;
    }

    @Override
    public final int zzi() {
        return this.zzj;
    }

    @Override
    public final int zzj() {
        return this.zzk;
    }
}
