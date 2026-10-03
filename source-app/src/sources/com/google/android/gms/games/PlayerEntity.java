package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Asserts;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;
import com.google.android.gms.common.util.DataUtils;
import com.google.android.gms.games.internal.GamesDowngradeableSafeParcel;
import com.google.android.gms.games.internal.player.MostRecentGameInfoEntity;

public final class PlayerEntity extends GamesDowngradeableSafeParcel implements Player {
    public static final Parcelable.Creator<PlayerEntity> CREATOR = new zzk();
    private final String zza;
    private final String zzb;
    private final Uri zzc;
    private final Uri zzd;
    private final long zze;
    private final int zzf;
    private final long zzg;
    private final String zzh;
    private final String zzi;
    private final String zzj;
    private final MostRecentGameInfoEntity zzk;
    private final PlayerLevelInfo zzl;
    private final boolean zzm;
    private final boolean zzn;
    private final String zzo;
    private final String zzp;
    private final Uri zzq;
    private final String zzr;
    private final Uri zzs;
    private final String zzt;
    private final long zzu;
    private final zzo zzv;
    private final zza zzw;
    private final boolean zzx;
    private final String zzy;

    public PlayerEntity(Player player) {
        String playerId = player.getPlayerId();
        this.zza = playerId;
        String displayName = player.getDisplayName();
        this.zzb = displayName;
        this.zzc = player.getIconImageUri();
        this.zzh = player.getIconImageUrl();
        this.zzd = player.getHiResImageUri();
        this.zzi = player.getHiResImageUrl();
        long retrievedTimestamp = player.getRetrievedTimestamp();
        this.zze = retrievedTimestamp;
        this.zzf = player.zze();
        this.zzg = player.getLastPlayedWithTimestamp();
        this.zzj = player.getTitle();
        this.zzm = player.zzf();
        com.google.android.gms.games.internal.player.zza zzaVarZzh = player.zzh();
        this.zzk = zzaVarZzh == null ? null : new MostRecentGameInfoEntity(zzaVarZzh);
        this.zzl = player.getLevelInfo();
        this.zzn = player.zzd();
        this.zzo = player.zzb();
        this.zzp = player.zzc();
        this.zzq = player.getBannerImageLandscapeUri();
        this.zzr = player.getBannerImageLandscapeUrl();
        this.zzs = player.getBannerImagePortraitUri();
        this.zzt = player.getBannerImagePortraitUrl();
        this.zzu = player.zzi();
        PlayerRelationshipInfo relationshipInfo = player.getRelationshipInfo();
        this.zzv = relationshipInfo == null ? null : new zzo(relationshipInfo.freeze());
        CurrentPlayerInfo currentPlayerInfo = player.getCurrentPlayerInfo();
        this.zzw = currentPlayerInfo != null ? (zza) currentPlayerInfo.freeze() : null;
        this.zzx = player.zzg();
        this.zzy = player.zza();
        Asserts.checkNotNull(playerId);
        Asserts.checkNotNull(displayName);
        Asserts.checkState(retrievedTimestamp > 0);
    }

    static int zzj(Player player) {
        return Objects.hashCode(player.getPlayerId(), player.getDisplayName(), Boolean.valueOf(player.zzd()), player.getIconImageUri(), player.getHiResImageUri(), Long.valueOf(player.getRetrievedTimestamp()), player.getTitle(), player.getLevelInfo(), player.zzb(), player.zzc(), player.getBannerImageLandscapeUri(), player.getBannerImagePortraitUri(), Long.valueOf(player.zzi()), player.getRelationshipInfo(), player.getCurrentPlayerInfo(), Boolean.valueOf(player.zzg()), player.zza());
    }

    static boolean zzk(Player player, Object obj) {
        if (!(obj instanceof Player)) {
            return false;
        }
        if (player == obj) {
            return true;
        }
        Player player2 = (Player) obj;
        return Objects.equal(player2.getPlayerId(), player.getPlayerId()) && Objects.equal(player2.getDisplayName(), player.getDisplayName()) && Objects.equal(Boolean.valueOf(player2.zzd()), Boolean.valueOf(player.zzd())) && Objects.equal(player2.getIconImageUri(), player.getIconImageUri()) && Objects.equal(player2.getHiResImageUri(), player.getHiResImageUri()) && Objects.equal(Long.valueOf(player2.getRetrievedTimestamp()), Long.valueOf(player.getRetrievedTimestamp())) && Objects.equal(player2.getTitle(), player.getTitle()) && Objects.equal(player2.getLevelInfo(), player.getLevelInfo()) && Objects.equal(player2.zzb(), player.zzb()) && Objects.equal(player2.zzc(), player.zzc()) && Objects.equal(player2.getBannerImageLandscapeUri(), player.getBannerImageLandscapeUri()) && Objects.equal(player2.getBannerImagePortraitUri(), player.getBannerImagePortraitUri()) && Objects.equal(Long.valueOf(player2.zzi()), Long.valueOf(player.zzi())) && Objects.equal(player2.getCurrentPlayerInfo(), player.getCurrentPlayerInfo()) && Objects.equal(player2.getRelationshipInfo(), player.getRelationshipInfo()) && Objects.equal(Boolean.valueOf(player2.zzg()), Boolean.valueOf(player.zzg())) && Objects.equal(player2.zza(), player.zza());
    }

    static String zzl(Player player) {
        Objects.ToStringHelper toStringHelperAdd = Objects.toStringHelper(player).add("PlayerId", player.getPlayerId()).add("DisplayName", player.getDisplayName()).add("HasDebugAccess", Boolean.valueOf(player.zzd())).add("IconImageUri", player.getIconImageUri()).add("IconImageUrl", player.getIconImageUrl()).add("HiResImageUri", player.getHiResImageUri()).add("HiResImageUrl", player.getHiResImageUrl()).add("RetrievedTimestamp", Long.valueOf(player.getRetrievedTimestamp())).add("Title", player.getTitle()).add("LevelInfo", player.getLevelInfo()).add("GamerTag", player.zzb()).add("Name", player.zzc()).add("BannerImageLandscapeUri", player.getBannerImageLandscapeUri()).add("BannerImageLandscapeUrl", player.getBannerImageLandscapeUrl()).add("BannerImagePortraitUri", player.getBannerImagePortraitUri()).add("BannerImagePortraitUrl", player.getBannerImagePortraitUrl()).add("CurrentPlayerInfo", player.getCurrentPlayerInfo()).add("TotalUnlockedAchievement", Long.valueOf(player.zzi()));
        if (player.zzg()) {
            toStringHelperAdd.add("AlwaysAutoSignIn", Boolean.valueOf(player.zzg()));
        }
        if (player.getRelationshipInfo() != null) {
            toStringHelperAdd.add("RelationshipInfo", player.getRelationshipInfo());
        }
        if (player.zza() != null) {
            toStringHelperAdd.add("GamePlayerId", player.zza());
        }
        return toStringHelperAdd.toString();
    }

    public boolean equals(Object obj) {
        return zzk(this, obj);
    }

    @Override
    public Player freeze() {
        return this;
    }

    @Override
    public final Player freeze() {
        return this;
    }

    @Override
    public Uri getBannerImageLandscapeUri() {
        return this.zzq;
    }

    @Override
    public String getBannerImageLandscapeUrl() {
        return this.zzr;
    }

    @Override
    public Uri getBannerImagePortraitUri() {
        return this.zzs;
    }

    @Override
    public String getBannerImagePortraitUrl() {
        return this.zzt;
    }

    @Override
    public CurrentPlayerInfo getCurrentPlayerInfo() {
        return this.zzw;
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
    public Uri getHiResImageUri() {
        return this.zzd;
    }

    @Override
    public String getHiResImageUrl() {
        return this.zzi;
    }

    @Override
    public Uri getIconImageUri() {
        return this.zzc;
    }

    @Override
    public String getIconImageUrl() {
        return this.zzh;
    }

    @Override
    public long getLastPlayedWithTimestamp() {
        return this.zzg;
    }

    @Override
    public PlayerLevelInfo getLevelInfo() {
        return this.zzl;
    }

    @Override
    public String getPlayerId() {
        return this.zza;
    }

    @Override
    public PlayerRelationshipInfo getRelationshipInfo() {
        return this.zzv;
    }

    @Override
    public long getRetrievedTimestamp() {
        return this.zze;
    }

    @Override
    public String getTitle() {
        return this.zzj;
    }

    @Override
    public void getTitle(CharArrayBuffer charArrayBuffer) {
        DataUtils.copyStringToBuffer(this.zzj, charArrayBuffer);
    }

    @Override
    public boolean hasHiResImage() {
        return getHiResImageUri() != null;
    }

    @Override
    public boolean hasIconImage() {
        return getIconImageUri() != null;
    }

    public int hashCode() {
        return zzj(this);
    }

    @Override
    public boolean isDataValid() {
        return true;
    }

    public String toString() {
        return zzl(this);
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        if (shouldDowngrade()) {
            parcel.writeString(this.zza);
            parcel.writeString(this.zzb);
            Uri uri = this.zzc;
            parcel.writeString(uri == null ? null : uri.toString());
            Uri uri2 = this.zzd;
            parcel.writeString(uri2 != null ? uri2.toString() : null);
            parcel.writeLong(this.zze);
            return;
        }
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeString(parcel, 1, getPlayerId(), false);
        SafeParcelWriter.writeString(parcel, 2, getDisplayName(), false);
        SafeParcelWriter.writeParcelable(parcel, 3, getIconImageUri(), i, false);
        SafeParcelWriter.writeParcelable(parcel, 4, getHiResImageUri(), i, false);
        SafeParcelWriter.writeLong(parcel, 5, getRetrievedTimestamp());
        SafeParcelWriter.writeInt(parcel, 6, this.zzf);
        SafeParcelWriter.writeLong(parcel, 7, getLastPlayedWithTimestamp());
        SafeParcelWriter.writeString(parcel, 8, getIconImageUrl(), false);
        SafeParcelWriter.writeString(parcel, 9, getHiResImageUrl(), false);
        SafeParcelWriter.writeString(parcel, 14, getTitle(), false);
        SafeParcelWriter.writeParcelable(parcel, 15, this.zzk, i, false);
        SafeParcelWriter.writeParcelable(parcel, 16, getLevelInfo(), i, false);
        SafeParcelWriter.writeBoolean(parcel, 18, this.zzm);
        SafeParcelWriter.writeBoolean(parcel, 19, this.zzn);
        SafeParcelWriter.writeString(parcel, 20, this.zzo, false);
        SafeParcelWriter.writeString(parcel, 21, this.zzp, false);
        SafeParcelWriter.writeParcelable(parcel, 22, getBannerImageLandscapeUri(), i, false);
        SafeParcelWriter.writeString(parcel, 23, getBannerImageLandscapeUrl(), false);
        SafeParcelWriter.writeParcelable(parcel, 24, getBannerImagePortraitUri(), i, false);
        SafeParcelWriter.writeString(parcel, 25, getBannerImagePortraitUrl(), false);
        SafeParcelWriter.writeLong(parcel, 29, this.zzu);
        SafeParcelWriter.writeParcelable(parcel, 33, getRelationshipInfo(), i, false);
        SafeParcelWriter.writeParcelable(parcel, 35, getCurrentPlayerInfo(), i, false);
        SafeParcelWriter.writeBoolean(parcel, 36, this.zzx);
        SafeParcelWriter.writeString(parcel, 37, this.zzy, false);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }

    @Override
    public final String zza() {
        return this.zzy;
    }

    @Override
    public final String zzb() {
        return this.zzo;
    }

    @Override
    public final String zzc() {
        return this.zzp;
    }

    @Override
    public final boolean zzd() {
        return this.zzn;
    }

    @Override
    public final int zze() {
        return this.zzf;
    }

    @Override
    public final boolean zzf() {
        return this.zzm;
    }

    @Override
    public final boolean zzg() {
        return this.zzx;
    }

    @Override
    public final com.google.android.gms.games.internal.player.zza zzh() {
        return this.zzk;
    }

    @Override
    public final long zzi() {
        return this.zzu;
    }

    PlayerEntity(String str, String str2, Uri uri, Uri uri2, long j, int i, long j2, String str3, String str4, String str5, MostRecentGameInfoEntity mostRecentGameInfoEntity, PlayerLevelInfo playerLevelInfo, boolean z, boolean z2, String str6, String str7, Uri uri3, String str8, Uri uri4, String str9, long j3, zzo zzoVar, zza zzaVar, boolean z3, String str10) {
        this.zza = str;
        this.zzb = str2;
        this.zzc = uri;
        this.zzh = str3;
        this.zzd = uri2;
        this.zzi = str4;
        this.zze = j;
        this.zzf = i;
        this.zzg = j2;
        this.zzj = str5;
        this.zzm = z;
        this.zzk = mostRecentGameInfoEntity;
        this.zzl = playerLevelInfo;
        this.zzn = z2;
        this.zzo = str6;
        this.zzp = str7;
        this.zzq = uri3;
        this.zzr = str8;
        this.zzs = uri4;
        this.zzt = str9;
        this.zzu = j3;
        this.zzv = zzoVar;
        this.zzw = zzaVar;
        this.zzx = z3;
        this.zzy = str10;
    }
}
