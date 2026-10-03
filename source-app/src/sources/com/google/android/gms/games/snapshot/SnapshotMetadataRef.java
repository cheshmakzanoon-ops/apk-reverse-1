package com.google.android.gms.games.snapshot;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import com.google.android.gms.common.data.DataBufferRef;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.Game;
import com.google.android.gms.games.GameRef;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerRef;

public final class SnapshotMetadataRef extends DataBufferRef implements SnapshotMetadata {
    private final Game zza;
    private final Player zzb;

    public SnapshotMetadataRef(DataHolder dataHolder, int i) {
        super(dataHolder, i);
        this.zza = new GameRef(dataHolder, i);
        this.zzb = new PlayerRef(dataHolder, i, null);
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return SnapshotMetadataEntity.zzc(this, obj);
    }

    @Override
    public final SnapshotMetadata freeze() {
        return new SnapshotMetadataEntity(this);
    }

    @Override
    public final float getCoverImageAspectRatio() {
        float f = getFloat("cover_icon_image_height");
        float f2 = getFloat("cover_icon_image_width");
        if (f == 0.0f) {
            return 0.0f;
        }
        return f2 / f;
    }

    @Override
    public final Uri getCoverImageUri() {
        return parseUri("cover_icon_image_uri");
    }

    @Override
    public String getCoverImageUrl() {
        return getString("cover_icon_image_url");
    }

    @Override
    public final String getDescription() {
        return getString("description");
    }

    @Override
    public final String getDeviceName() {
        return getString("device_name");
    }

    @Override
    public final Game getGame() {
        return this.zza;
    }

    @Override
    public final long getLastModifiedTimestamp() {
        return getLong("last_modified_timestamp");
    }

    @Override
    public final Player getOwner() {
        return this.zzb;
    }

    @Override
    public final long getPlayedTime() {
        return getLong("duration");
    }

    @Override
    public final long getProgressValue() {
        return getLong("progress_value");
    }

    @Override
    public final String getSnapshotId() {
        return getString("external_snapshot_id");
    }

    @Override
    public final String getUniqueName() {
        return getString("unique_name");
    }

    @Override
    public final boolean hasChangePending() {
        return getInteger("pending_change_count") > 0;
    }

    @Override
    public final int hashCode() {
        return SnapshotMetadataEntity.zzb(this);
    }

    public final String toString() {
        return SnapshotMetadataEntity.zzd(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        new SnapshotMetadataEntity(this).writeToParcel(parcel, i);
    }

    @Override
    public final String zza() {
        return getString("title");
    }

    @Override
    public final void getDescription(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("description", charArrayBuffer);
    }
}
