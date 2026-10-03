package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;
import com.google.android.gms.common.util.DataUtils;
import com.google.android.gms.games.internal.GamesDowngradeableSafeParcel;

public final class GameEntity extends GamesDowngradeableSafeParcel implements Game {
    public static final Parcelable.Creator<GameEntity> CREATOR = new zze();
    private final String zza;
    private final String zzb;
    private final String zzc;
    private final String zzd;
    private final String zze;
    private final String zzf;
    private final Uri zzg;
    private final Uri zzh;
    private final Uri zzi;
    private final boolean zzj;
    private final boolean zzk;
    private final String zzl;
    private final int zzm;
    private final int zzn;
    private final int zzo;
    private final boolean zzp;
    private final boolean zzq;
    private final String zzr;
    private final String zzs;
    private final String zzt;
    private final boolean zzu;
    private final boolean zzv;
    private final boolean zzw;
    private final String zzx;
    private final boolean zzy;
    private final boolean zzz;

    public GameEntity(Game game) {
        this.zza = game.getApplicationId();
        this.zzc = game.getPrimaryCategory();
        this.zzd = game.getSecondaryCategory();
        this.zze = game.getDescription();
        this.zzf = game.getDeveloperName();
        this.zzb = game.getDisplayName();
        this.zzg = game.getIconImageUri();
        this.zzr = game.getIconImageUrl();
        this.zzh = game.getHiResImageUri();
        this.zzs = game.getHiResImageUrl();
        this.zzi = game.getFeaturedImageUri();
        this.zzt = game.getFeaturedImageUrl();
        this.zzj = game.zza();
        this.zzk = game.zze();
        this.zzl = game.zzf();
        this.zzm = 1;
        this.zzn = game.getAchievementTotalCount();
        this.zzo = game.getLeaderboardCount();
        this.zzp = game.zzg();
        this.zzq = game.zzh();
        this.zzu = game.zzb();
        this.zzv = game.zzc();
        this.zzw = game.areSnapshotsEnabled();
        this.zzx = game.getThemeColor();
        this.zzy = game.hasGamepadSupport();
        this.zzz = game.zzd();
    }

    static int zzi(Game game) {
        return Objects.hashCode(game.getApplicationId(), game.getDisplayName(), game.getPrimaryCategory(), game.getSecondaryCategory(), game.getDescription(), game.getDeveloperName(), game.getIconImageUri(), game.getHiResImageUri(), game.getFeaturedImageUri(), Boolean.valueOf(game.zza()), Boolean.valueOf(game.zze()), game.zzf(), Integer.valueOf(game.getAchievementTotalCount()), Integer.valueOf(game.getLeaderboardCount()), Boolean.valueOf(game.zzg()), Boolean.valueOf(game.zzh()), Boolean.valueOf(game.zzb()), Boolean.valueOf(game.zzc()), Boolean.valueOf(game.areSnapshotsEnabled()), game.getThemeColor(), Boolean.valueOf(game.hasGamepadSupport()), Boolean.valueOf(game.zzd()));
    }

    static boolean zzj(Game game, Object obj) {
        if (!(obj instanceof Game)) {
            return false;
        }
        if (game == obj) {
            return true;
        }
        Game game2 = (Game) obj;
        return Objects.equal(game2.getApplicationId(), game.getApplicationId()) && Objects.equal(game2.getDisplayName(), game.getDisplayName()) && Objects.equal(game2.getPrimaryCategory(), game.getPrimaryCategory()) && Objects.equal(game2.getSecondaryCategory(), game.getSecondaryCategory()) && Objects.equal(game2.getDescription(), game.getDescription()) && Objects.equal(game2.getDeveloperName(), game.getDeveloperName()) && Objects.equal(game2.getIconImageUri(), game.getIconImageUri()) && Objects.equal(game2.getHiResImageUri(), game.getHiResImageUri()) && Objects.equal(game2.getFeaturedImageUri(), game.getFeaturedImageUri()) && Objects.equal(Boolean.valueOf(game2.zza()), Boolean.valueOf(game.zza())) && Objects.equal(Boolean.valueOf(game2.zze()), Boolean.valueOf(game.zze())) && Objects.equal(game2.zzf(), game.zzf()) && Objects.equal(Integer.valueOf(game2.getAchievementTotalCount()), Integer.valueOf(game.getAchievementTotalCount())) && Objects.equal(Integer.valueOf(game2.getLeaderboardCount()), Integer.valueOf(game.getLeaderboardCount())) && Objects.equal(Boolean.valueOf(game2.zzg()), Boolean.valueOf(game.zzg())) && Objects.equal(Boolean.valueOf(game2.zzh()), Boolean.valueOf(game.zzh())) && Objects.equal(Boolean.valueOf(game2.zzb()), Boolean.valueOf(game.zzb())) && Objects.equal(Boolean.valueOf(game2.zzc()), Boolean.valueOf(game.zzc())) && Objects.equal(Boolean.valueOf(game2.areSnapshotsEnabled()), Boolean.valueOf(game.areSnapshotsEnabled())) && Objects.equal(game2.getThemeColor(), game.getThemeColor()) && Objects.equal(Boolean.valueOf(game2.hasGamepadSupport()), Boolean.valueOf(game.hasGamepadSupport())) && Objects.equal(Boolean.valueOf(game2.zzd()), Boolean.valueOf(game.zzd()));
    }

    static String zzk(Game game) {
        return Objects.toStringHelper(game).add("ApplicationId", game.getApplicationId()).add("DisplayName", game.getDisplayName()).add("PrimaryCategory", game.getPrimaryCategory()).add("SecondaryCategory", game.getSecondaryCategory()).add("Description", game.getDescription()).add("DeveloperName", game.getDeveloperName()).add("IconImageUri", game.getIconImageUri()).add("IconImageUrl", game.getIconImageUrl()).add("HiResImageUri", game.getHiResImageUri()).add("HiResImageUrl", game.getHiResImageUrl()).add("FeaturedImageUri", game.getFeaturedImageUri()).add("FeaturedImageUrl", game.getFeaturedImageUrl()).add("PlayEnabledGame", Boolean.valueOf(game.zza())).add("InstanceInstalled", Boolean.valueOf(game.zze())).add("InstancePackageName", game.zzf()).add("AchievementTotalCount", Integer.valueOf(game.getAchievementTotalCount())).add("LeaderboardCount", Integer.valueOf(game.getLeaderboardCount())).add("AreSnapshotsEnabled", Boolean.valueOf(game.areSnapshotsEnabled())).add("ThemeColor", game.getThemeColor()).add("HasGamepadSupport", Boolean.valueOf(game.hasGamepadSupport())).toString();
    }

    @Override
    public boolean areSnapshotsEnabled() {
        return this.zzw;
    }

    public boolean equals(Object obj) {
        return zzj(this, obj);
    }

    @Override
    public Game freeze() {
        return this;
    }

    @Override
    public final Game freeze() {
        return this;
    }

    @Override
    public int getAchievementTotalCount() {
        return this.zzn;
    }

    @Override
    public String getApplicationId() {
        return this.zza;
    }

    @Override
    public String getDescription() {
        return this.zze;
    }

    @Override
    public void getDescription(CharArrayBuffer charArrayBuffer) {
        DataUtils.copyStringToBuffer(this.zze, charArrayBuffer);
    }

    @Override
    public String getDeveloperName() {
        return this.zzf;
    }

    @Override
    public void getDeveloperName(CharArrayBuffer charArrayBuffer) {
        DataUtils.copyStringToBuffer(this.zzf, charArrayBuffer);
    }

    @Override
    public String getDisplayName() {
        return this.zzb;
    }

    @Override
    public void getDisplayName(CharArrayBuffer charArrayBuffer) {
        DataUtils.copyStringToBuffer(this.zzb, charArrayBuffer);
    }

    @Override
    public Uri getFeaturedImageUri() {
        return this.zzi;
    }

    @Override
    public String getFeaturedImageUrl() {
        return this.zzt;
    }

    @Override
    public Uri getHiResImageUri() {
        return this.zzh;
    }

    @Override
    public String getHiResImageUrl() {
        return this.zzs;
    }

    @Override
    public Uri getIconImageUri() {
        return this.zzg;
    }

    @Override
    public String getIconImageUrl() {
        return this.zzr;
    }

    @Override
    public int getLeaderboardCount() {
        return this.zzo;
    }

    @Override
    public String getPrimaryCategory() {
        return this.zzc;
    }

    @Override
    public String getSecondaryCategory() {
        return this.zzd;
    }

    @Override
    public String getThemeColor() {
        return this.zzx;
    }

    @Override
    public boolean hasGamepadSupport() {
        return this.zzy;
    }

    public int hashCode() {
        return zzi(this);
    }

    @Override
    public boolean isDataValid() {
        return true;
    }

    public String toString() {
        return zzk(this);
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        if (shouldDowngrade()) {
            parcel.writeString(this.zza);
            parcel.writeString(this.zzb);
            parcel.writeString(this.zzc);
            parcel.writeString(this.zzd);
            parcel.writeString(this.zze);
            parcel.writeString(this.zzf);
            Uri uri = this.zzg;
            parcel.writeString(uri == null ? null : uri.toString());
            Uri uri2 = this.zzh;
            parcel.writeString(uri2 == null ? null : uri2.toString());
            Uri uri3 = this.zzi;
            parcel.writeString(uri3 != null ? uri3.toString() : null);
            parcel.writeInt(this.zzj ? 1 : 0);
            parcel.writeInt(this.zzk ? 1 : 0);
            parcel.writeString(this.zzl);
            parcel.writeInt(this.zzm);
            parcel.writeInt(this.zzn);
            parcel.writeInt(this.zzo);
            return;
        }
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeString(parcel, 1, getApplicationId(), false);
        SafeParcelWriter.writeString(parcel, 2, getDisplayName(), false);
        SafeParcelWriter.writeString(parcel, 3, getPrimaryCategory(), false);
        SafeParcelWriter.writeString(parcel, 4, getSecondaryCategory(), false);
        SafeParcelWriter.writeString(parcel, 5, getDescription(), false);
        SafeParcelWriter.writeString(parcel, 6, getDeveloperName(), false);
        SafeParcelWriter.writeParcelable(parcel, 7, getIconImageUri(), i, false);
        SafeParcelWriter.writeParcelable(parcel, 8, getHiResImageUri(), i, false);
        SafeParcelWriter.writeParcelable(parcel, 9, getFeaturedImageUri(), i, false);
        SafeParcelWriter.writeBoolean(parcel, 10, this.zzj);
        SafeParcelWriter.writeBoolean(parcel, 11, this.zzk);
        SafeParcelWriter.writeString(parcel, 12, this.zzl, false);
        SafeParcelWriter.writeInt(parcel, 13, this.zzm);
        SafeParcelWriter.writeInt(parcel, 14, getAchievementTotalCount());
        SafeParcelWriter.writeInt(parcel, 15, getLeaderboardCount());
        SafeParcelWriter.writeBoolean(parcel, 16, this.zzp);
        SafeParcelWriter.writeBoolean(parcel, 17, this.zzq);
        SafeParcelWriter.writeString(parcel, 18, getIconImageUrl(), false);
        SafeParcelWriter.writeString(parcel, 19, getHiResImageUrl(), false);
        SafeParcelWriter.writeString(parcel, 20, getFeaturedImageUrl(), false);
        SafeParcelWriter.writeBoolean(parcel, 21, this.zzu);
        SafeParcelWriter.writeBoolean(parcel, 22, this.zzv);
        SafeParcelWriter.writeBoolean(parcel, 23, areSnapshotsEnabled());
        SafeParcelWriter.writeString(parcel, 24, getThemeColor(), false);
        SafeParcelWriter.writeBoolean(parcel, 25, hasGamepadSupport());
        SafeParcelWriter.writeBoolean(parcel, 28, this.zzz);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }

    @Override
    public final boolean zza() {
        return this.zzj;
    }

    @Override
    public final boolean zzb() {
        return this.zzu;
    }

    @Override
    public final boolean zzc() {
        return this.zzv;
    }

    @Override
    public final boolean zzd() {
        return this.zzz;
    }

    @Override
    public final boolean zze() {
        return this.zzk;
    }

    @Override
    public final String zzf() {
        return this.zzl;
    }

    @Override
    public final boolean zzg() {
        return this.zzp;
    }

    @Override
    public final boolean zzh() {
        return this.zzq;
    }

    GameEntity(String str, String str2, String str3, String str4, String str5, String str6, Uri uri, Uri uri2, Uri uri3, boolean z, boolean z2, String str7, int i, int i2, int i3, boolean z3, boolean z4, String str8, String str9, String str10, boolean z5, boolean z6, boolean z7, String str11, boolean z8, boolean z9) {
        this.zza = str;
        this.zzb = str2;
        this.zzc = str3;
        this.zzd = str4;
        this.zze = str5;
        this.zzf = str6;
        this.zzg = uri;
        this.zzr = str8;
        this.zzh = uri2;
        this.zzs = str9;
        this.zzi = uri3;
        this.zzt = str10;
        this.zzj = z;
        this.zzk = z2;
        this.zzl = str7;
        this.zzm = i;
        this.zzn = i2;
        this.zzo = i3;
        this.zzp = z3;
        this.zzq = z4;
        this.zzu = z5;
        this.zzv = z6;
        this.zzw = z7;
        this.zzx = str11;
        this.zzy = z8;
        this.zzz = z9;
    }
}
