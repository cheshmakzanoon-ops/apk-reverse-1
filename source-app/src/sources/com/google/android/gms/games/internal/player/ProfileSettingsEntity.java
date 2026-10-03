package com.google.android.gms.games.internal.player;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;
import com.google.android.gms.games.zzr;

public class ProfileSettingsEntity extends com.google.android.gms.games.internal.zzg implements zzr {
    public static final Parcelable.Creator<ProfileSettingsEntity> CREATOR = new zzg();
    private final Status zza;
    private final String zzb;
    private final boolean zzc;
    private final boolean zzd;
    private final boolean zze;
    private final StockProfileImageEntity zzf;
    private final boolean zzg;
    private final boolean zzh;
    private final int zzi;
    private final boolean zzj;
    private final boolean zzk;
    private final int zzl;
    private final int zzm;
    private final boolean zzn;
    private final zzh zzo;
    private final Boolean zzp;

    public ProfileSettingsEntity(Status status, String str, boolean z, boolean z2, boolean z3, StockProfileImageEntity stockProfileImageEntity, boolean z4, boolean z5, int i, boolean z6, boolean z7, int i2, int i3, boolean z8, zzh zzhVar, Boolean bool) {
        this.zza = status;
        this.zzb = str;
        this.zzc = z;
        this.zzd = z2;
        this.zze = z3;
        this.zzf = stockProfileImageEntity;
        this.zzg = z4;
        this.zzh = z5;
        this.zzi = i;
        this.zzj = z6;
        this.zzk = z7;
        this.zzl = i2;
        this.zzm = i3;
        this.zzn = z8;
        this.zzo = zzhVar;
        this.zzp = bool;
    }

    public final boolean equals(Object obj) {
        if (!(obj instanceof zzr)) {
            return false;
        }
        if (this == obj) {
            return true;
        }
        zzr zzrVar = (zzr) obj;
        return Objects.equal(this.zzb, zzrVar.zzc()) && Objects.equal(Boolean.valueOf(this.zzc), Boolean.valueOf(zzrVar.zze())) && Objects.equal(Boolean.valueOf(this.zzd), Boolean.valueOf(zzrVar.zza())) && Objects.equal(Boolean.valueOf(this.zze), Boolean.valueOf(zzrVar.zzb())) && Objects.equal(this.zza, zzrVar.getStatus()) && Objects.equal(this.zzf, zzrVar.zzd()) && Objects.equal(Boolean.valueOf(this.zzg), Boolean.valueOf(zzrVar.zzf())) && Objects.equal(Boolean.valueOf(this.zzh), Boolean.valueOf(zzrVar.zzg())) && this.zzi == zzrVar.zzj() && this.zzj == zzrVar.zzh() && this.zzk == zzrVar.zzi() && this.zzl == zzrVar.zzk() && this.zzm == zzrVar.zzl() && this.zzn == zzrVar.zzm() && Objects.equal(this.zzp, zzrVar.zzo()) && Objects.equal(this.zzo, zzrVar.zzn());
    }

    @Override
    public final Status getStatus() {
        return this.zza;
    }

    public final int hashCode() {
        return Objects.hashCode(this.zzb, Boolean.valueOf(this.zzc), Boolean.valueOf(this.zzd), Boolean.valueOf(this.zze), this.zza, this.zzf, Boolean.valueOf(this.zzg), Boolean.valueOf(this.zzh), Integer.valueOf(this.zzi), Boolean.valueOf(this.zzj), Boolean.valueOf(this.zzk), Integer.valueOf(this.zzl), Integer.valueOf(this.zzm), Boolean.valueOf(this.zzn), this.zzo, this.zzp);
    }

    public final String toString() {
        return Objects.toStringHelper(this).add("GamerTag", this.zzb).add("IsGamerTagExplicitlySet", Boolean.valueOf(this.zzc)).add("IsProfileVisible", Boolean.valueOf(this.zzd)).add("IsVisibilityExplicitlySet", Boolean.valueOf(this.zze)).add("Status", this.zza).add("StockProfileImage", this.zzf).add("IsProfileDiscoverable", Boolean.valueOf(this.zzg)).add("AutoSignIn", Boolean.valueOf(this.zzh)).add("httpErrorCode", Integer.valueOf(this.zzi)).add("IsSettingsChangesProhibited", Boolean.valueOf(this.zzj)).add("AllowFriendInvites", Boolean.valueOf(this.zzk)).add("ProfileVisibility", Integer.valueOf(this.zzl)).add("global_friends_list_visibility", Integer.valueOf(this.zzm)).add("always_auto_sign_in", Boolean.valueOf(this.zzn)).add("profileless_recall_summary", this.zzo).add("games_streaks_enabled", this.zzp).toString();
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeParcelable(parcel, 1, this.zza, i, false);
        SafeParcelWriter.writeString(parcel, 2, this.zzb, false);
        SafeParcelWriter.writeBoolean(parcel, 3, this.zzc);
        SafeParcelWriter.writeBoolean(parcel, 4, this.zzd);
        SafeParcelWriter.writeBoolean(parcel, 5, this.zze);
        SafeParcelWriter.writeParcelable(parcel, 6, this.zzf, i, false);
        SafeParcelWriter.writeBoolean(parcel, 7, this.zzg);
        SafeParcelWriter.writeBoolean(parcel, 8, this.zzh);
        SafeParcelWriter.writeInt(parcel, 9, this.zzi);
        SafeParcelWriter.writeBoolean(parcel, 10, this.zzj);
        SafeParcelWriter.writeBoolean(parcel, 11, this.zzk);
        SafeParcelWriter.writeInt(parcel, 12, this.zzl);
        SafeParcelWriter.writeInt(parcel, 13, this.zzm);
        SafeParcelWriter.writeBoolean(parcel, 14, this.zzn);
        SafeParcelWriter.writeParcelable(parcel, 15, this.zzo, i, false);
        SafeParcelWriter.writeBooleanObject(parcel, 16, this.zzp, false);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }

    @Override
    public final boolean zza() {
        return this.zzd;
    }

    @Override
    public final boolean zzb() {
        return this.zze;
    }

    @Override
    public final String zzc() {
        return this.zzb;
    }

    @Override
    public final StockProfileImage zzd() {
        return this.zzf;
    }

    @Override
    public final boolean zze() {
        return this.zzc;
    }

    @Override
    public final boolean zzf() {
        return this.zzg;
    }

    @Override
    public final boolean zzg() {
        return this.zzh;
    }

    @Override
    public final boolean zzh() {
        return this.zzj;
    }

    @Override
    public final boolean zzi() {
        return this.zzk;
    }

    @Override
    public final int zzj() {
        return this.zzi;
    }

    @Override
    public final int zzk() {
        return this.zzl;
    }

    @Override
    public final int zzl() {
        return this.zzm;
    }

    @Override
    public final boolean zzm() {
        return this.zzn;
    }

    @Override
    public final zzh zzn() {
        return this.zzo;
    }

    @Override
    public final Boolean zzo() {
        return this.zzp;
    }
}
