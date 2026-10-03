package com.google.android.gms.games.snapshot;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;
import com.google.android.gms.common.util.DataUtils;
import com.google.android.gms.games.Game;
import com.google.android.gms.games.GameEntity;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerEntity;
import com.google.android.gms.games.internal.zzg;

public final class SnapshotMetadataEntity extends zzg implements SnapshotMetadata {
    public static final Parcelable.Creator<SnapshotMetadataEntity> CREATOR = new zzd();
    private final GameEntity zza;
    private final PlayerEntity zzb;
    private final String zzc;
    private final Uri zzd;
    private final String zze;
    private final String zzf;
    private final String zzg;
    private final long zzh;
    private final long zzi;
    private final float zzj;
    private final String zzk;
    private final boolean zzl;
    private final long zzm;
    private final String zzn;

    SnapshotMetadataEntity(GameEntity gameEntity, PlayerEntity playerEntity, String str, Uri uri, String str2, String str3, String str4, long j, long j2, float f, String str5, boolean z, long j3, String str6) {
        this.zza = gameEntity;
        this.zzb = playerEntity;
        this.zzc = str;
        this.zzd = uri;
        this.zze = str2;
        this.zzj = f;
        this.zzf = str3;
        this.zzg = str4;
        this.zzh = j;
        this.zzi = j2;
        this.zzk = str5;
        this.zzl = z;
        this.zzm = j3;
        this.zzn = str6;
    }

    static int zzb(SnapshotMetadata snapshotMetadata) {
        return Objects.hashCode(snapshotMetadata.getGame(), snapshotMetadata.getOwner(), snapshotMetadata.getSnapshotId(), snapshotMetadata.getCoverImageUri(), Float.valueOf(snapshotMetadata.getCoverImageAspectRatio()), snapshotMetadata.zza(), snapshotMetadata.getDescription(), Long.valueOf(snapshotMetadata.getLastModifiedTimestamp()), Long.valueOf(snapshotMetadata.getPlayedTime()), snapshotMetadata.getUniqueName(), Boolean.valueOf(snapshotMetadata.hasChangePending()), Long.valueOf(snapshotMetadata.getProgressValue()), snapshotMetadata.getDeviceName());
    }

    static boolean zzc(SnapshotMetadata snapshotMetadata, Object obj) {
        if (!(obj instanceof SnapshotMetadata)) {
            return false;
        }
        if (snapshotMetadata == obj) {
            return true;
        }
        SnapshotMetadata snapshotMetadata2 = (SnapshotMetadata) obj;
        return Objects.equal(snapshotMetadata2.getGame(), snapshotMetadata.getGame()) && Objects.equal(snapshotMetadata2.getOwner(), snapshotMetadata.getOwner()) && Objects.equal(snapshotMetadata2.getSnapshotId(), snapshotMetadata.getSnapshotId()) && Objects.equal(snapshotMetadata2.getCoverImageUri(), snapshotMetadata.getCoverImageUri()) && Objects.equal(Float.valueOf(snapshotMetadata2.getCoverImageAspectRatio()), Float.valueOf(snapshotMetadata.getCoverImageAspectRatio())) && Objects.equal(snapshotMetadata2.zza(), snapshotMetadata.zza()) && Objects.equal(snapshotMetadata2.getDescription(), snapshotMetadata.getDescription()) && Objects.equal(Long.valueOf(snapshotMetadata2.getLastModifiedTimestamp()), Long.valueOf(snapshotMetadata.getLastModifiedTimestamp())) && Objects.equal(Long.valueOf(snapshotMetadata2.getPlayedTime()), Long.valueOf(snapshotMetadata.getPlayedTime())) && Objects.equal(snapshotMetadata2.getUniqueName(), snapshotMetadata.getUniqueName()) && Objects.equal(Boolean.valueOf(snapshotMetadata2.hasChangePending()), Boolean.valueOf(snapshotMetadata.hasChangePending())) && Objects.equal(Long.valueOf(snapshotMetadata2.getProgressValue()), Long.valueOf(snapshotMetadata.getProgressValue())) && Objects.equal(snapshotMetadata2.getDeviceName(), snapshotMetadata.getDeviceName());
    }

    static String zzd(SnapshotMetadata snapshotMetadata) {
        return Objects.toStringHelper(snapshotMetadata).add("Game", snapshotMetadata.getGame()).add("Owner", snapshotMetadata.getOwner()).add("SnapshotId", snapshotMetadata.getSnapshotId()).add("CoverImageUri", snapshotMetadata.getCoverImageUri()).add("CoverImageUrl", snapshotMetadata.getCoverImageUrl()).add("CoverImageAspectRatio", Float.valueOf(snapshotMetadata.getCoverImageAspectRatio())).add("Description", snapshotMetadata.getDescription()).add("LastModifiedTimestamp", Long.valueOf(snapshotMetadata.getLastModifiedTimestamp())).add("PlayedTime", Long.valueOf(snapshotMetadata.getPlayedTime())).add("UniqueName", snapshotMetadata.getUniqueName()).add("ChangePending", Boolean.valueOf(snapshotMetadata.hasChangePending())).add("ProgressValue", Long.valueOf(snapshotMetadata.getProgressValue())).add("DeviceName", snapshotMetadata.getDeviceName()).toString();
    }

    public boolean equals(Object obj) {
        return zzc(this, obj);
    }

    @Override
    public SnapshotMetadata freeze() {
        return this;
    }

    @Override
    public final SnapshotMetadata freeze() {
        return this;
    }

    @Override
    public float getCoverImageAspectRatio() {
        return this.zzj;
    }

    @Override
    public Uri getCoverImageUri() {
        return this.zzd;
    }

    @Override
    public String getCoverImageUrl() {
        return this.zze;
    }

    @Override
    public String getDescription() {
        return this.zzg;
    }

    @Override
    public void getDescription(CharArrayBuffer charArrayBuffer) {
        DataUtils.copyStringToBuffer(this.zzg, charArrayBuffer);
    }

    @Override
    public String getDeviceName() {
        return this.zzn;
    }

    @Override
    public Game getGame() {
        return this.zza;
    }

    @Override
    public long getLastModifiedTimestamp() {
        return this.zzh;
    }

    @Override
    public Player getOwner() {
        return this.zzb;
    }

    @Override
    public long getPlayedTime() {
        return this.zzi;
    }

    @Override
    public long getProgressValue() {
        return this.zzm;
    }

    @Override
    public String getSnapshotId() {
        return this.zzc;
    }

    @Override
    public String getUniqueName() {
        return this.zzk;
    }

    @Override
    public boolean hasChangePending() {
        return this.zzl;
    }

    public int hashCode() {
        return zzb(this);
    }

    @Override
    public boolean isDataValid() {
        return true;
    }

    public String toString() {
        return zzd(this);
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeParcelable(parcel, 1, getGame(), i, false);
        SafeParcelWriter.writeParcelable(parcel, 2, getOwner(), i, false);
        SafeParcelWriter.writeString(parcel, 3, getSnapshotId(), false);
        SafeParcelWriter.writeParcelable(parcel, 5, getCoverImageUri(), i, false);
        SafeParcelWriter.writeString(parcel, 6, getCoverImageUrl(), false);
        SafeParcelWriter.writeString(parcel, 7, this.zzf, false);
        SafeParcelWriter.writeString(parcel, 8, getDescription(), false);
        SafeParcelWriter.writeLong(parcel, 9, getLastModifiedTimestamp());
        SafeParcelWriter.writeLong(parcel, 10, getPlayedTime());
        SafeParcelWriter.writeFloat(parcel, 11, getCoverImageAspectRatio());
        SafeParcelWriter.writeString(parcel, 12, getUniqueName(), false);
        SafeParcelWriter.writeBoolean(parcel, 13, hasChangePending());
        SafeParcelWriter.writeLong(parcel, 14, getProgressValue());
        SafeParcelWriter.writeString(parcel, 15, getDeviceName(), false);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }

    @Override
    public final String zza() {
        return this.zzf;
    }

    public SnapshotMetadataEntity(SnapshotMetadata snapshotMetadata) {
        PlayerEntity playerEntity = new PlayerEntity(snapshotMetadata.getOwner());
        this.zza = new GameEntity(snapshotMetadata.getGame());
        this.zzb = playerEntity;
        this.zzc = snapshotMetadata.getSnapshotId();
        this.zzd = snapshotMetadata.getCoverImageUri();
        this.zze = snapshotMetadata.getCoverImageUrl();
        this.zzj = snapshotMetadata.getCoverImageAspectRatio();
        this.zzf = snapshotMetadata.zza();
        this.zzg = snapshotMetadata.getDescription();
        this.zzh = snapshotMetadata.getLastModifiedTimestamp();
        this.zzi = snapshotMetadata.getPlayedTime();
        this.zzk = snapshotMetadata.getUniqueName();
        this.zzl = snapshotMetadata.hasChangePending();
        this.zzm = snapshotMetadata.getProgressValue();
        this.zzn = snapshotMetadata.getDeviceName();
    }
}
