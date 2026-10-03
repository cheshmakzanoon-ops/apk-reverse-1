package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import com.google.android.gms.common.data.DataHolder;

public final class PlayerRef extends zzg implements Player {
    private final com.google.android.gms.games.internal.player.zzd zza;
    private final PlayerLevelInfo zzb;
    private final com.google.android.gms.games.internal.player.zzc zzc;
    private final zzq zzd;
    private final zzc zze;

    public PlayerRef(DataHolder dataHolder, int i, String str) {
        super(dataHolder, i);
        com.google.android.gms.games.internal.player.zzd zzdVar = new com.google.android.gms.games.internal.player.zzd(null);
        this.zza = zzdVar;
        this.zzc = new com.google.android.gms.games.internal.player.zzc(dataHolder, i, zzdVar);
        this.zzd = new zzq(dataHolder, i, zzdVar);
        this.zze = new zzc(dataHolder, i, zzdVar);
        if (hasNull(zzdVar.zzk) || getLong(zzdVar.zzk) == -1) {
            this.zzb = null;
            return;
        }
        int integer = getInteger(zzdVar.zzl);
        int integer2 = getInteger(zzdVar.zzo);
        PlayerLevel playerLevel = new PlayerLevel(integer, getLong(zzdVar.zzm), getLong(zzdVar.zzn));
        this.zzb = new PlayerLevelInfo(getLong(zzdVar.zzk), getLong(zzdVar.zzq), playerLevel, integer != integer2 ? new PlayerLevel(integer2, getLong(zzdVar.zzn), getLong(zzdVar.zzp)) : playerLevel);
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return PlayerEntity.zzk(this, obj);
    }

    @Override
    public final Player freeze() {
        return new PlayerEntity(this);
    }

    @Override
    public final Uri getBannerImageLandscapeUri() {
        return parseUri(this.zza.zzC);
    }

    @Override
    public String getBannerImageLandscapeUrl() {
        return getString(this.zza.zzD);
    }

    @Override
    public final Uri getBannerImagePortraitUri() {
        return parseUri(this.zza.zzE);
    }

    @Override
    public String getBannerImagePortraitUrl() {
        return getString(this.zza.zzF);
    }

    @Override
    public final CurrentPlayerInfo getCurrentPlayerInfo() {
        zzc zzcVar = this.zze;
        if (zzcVar.zza()) {
            return zzcVar;
        }
        return null;
    }

    @Override
    public final String getDisplayName() {
        return getString(this.zza.zzc);
    }

    @Override
    public final Uri getHiResImageUri() {
        return parseUri(this.zza.zzf);
    }

    @Override
    public String getHiResImageUrl() {
        return getString(this.zza.zzg);
    }

    @Override
    public final Uri getIconImageUri() {
        return parseUri(this.zza.zzd);
    }

    @Override
    public String getIconImageUrl() {
        return getString(this.zza.zze);
    }

    @Override
    public final long getLastPlayedWithTimestamp() {
        String str = this.zza.zzj;
        if (!hasColumn(str) || hasNull(str)) {
            return -1L;
        }
        return getLong(str);
    }

    @Override
    public final PlayerLevelInfo getLevelInfo() {
        return this.zzb;
    }

    @Override
    public final String getPlayerId() {
        return getString(this.zza.zza);
    }

    @Override
    public final PlayerRelationshipInfo getRelationshipInfo() {
        zzq zzqVar = this.zzd;
        if (zzqVar.getFriendStatus() == -1 && zzqVar.zza() == null && zzqVar.zzb() == null) {
            return null;
        }
        return zzqVar;
    }

    @Override
    public final long getRetrievedTimestamp() {
        return getLong(this.zza.zzh);
    }

    @Override
    public final String getTitle() {
        return getString(this.zza.zzr);
    }

    @Override
    public final boolean hasHiResImage() {
        return getHiResImageUri() != null;
    }

    @Override
    public final boolean hasIconImage() {
        return getIconImageUri() != null;
    }

    @Override
    public final int hashCode() {
        return PlayerEntity.zzj(this);
    }

    public final String toString() {
        return PlayerEntity.zzl(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        new PlayerEntity(this).writeToParcel(parcel, i);
    }

    @Override
    public final String zza() {
        return zzj(this.zza.zzb, null);
    }

    @Override
    public final String zzb() {
        return getString(this.zza.zzA);
    }

    @Override
    public final String zzc() {
        return getString(this.zza.zzB);
    }

    @Override
    public final boolean zzd() {
        return getBoolean(this.zza.zzz);
    }

    @Override
    public final int zze() {
        return getInteger(this.zza.zzi);
    }

    @Override
    public final boolean zzf() {
        return getBoolean(this.zza.zzs);
    }

    @Override
    public final boolean zzg() {
        String str = this.zza.zzM;
        return hasColumn(str) && getBoolean(str);
    }

    @Override
    public final com.google.android.gms.games.internal.player.zza zzh() {
        if (hasNull(this.zza.zzt)) {
            return null;
        }
        return this.zzc;
    }

    @Override
    public final long zzi() {
        String str = this.zza.zzG;
        if (!hasColumn(str) || hasNull(str)) {
            return -1L;
        }
        return getLong(str);
    }

    @Override
    public final void getDisplayName(CharArrayBuffer charArrayBuffer) {
        copyToBuffer(this.zza.zzc, charArrayBuffer);
    }

    @Override
    public final void getTitle(CharArrayBuffer charArrayBuffer) {
        copyToBuffer(this.zza.zzr, charArrayBuffer);
    }
}
