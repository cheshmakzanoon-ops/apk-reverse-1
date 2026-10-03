package com.google.android.gms.games.snapshot;

import android.graphics.Bitmap;
import android.net.Uri;
import com.google.android.gms.common.data.BitmapTeleporter;

public interface SnapshotMetadataChange {
    public static final SnapshotMetadataChange EMPTY_CHANGE = new SnapshotMetadataChangeEntity();

    public static final class Builder {
        private String zza;
        private Long zzb;
        private Long zzc;
        private BitmapTeleporter zzd;
        private Uri zze;

        public SnapshotMetadataChange build() {
            return new SnapshotMetadataChangeEntity(this.zza, this.zzb, this.zzd, this.zze, this.zzc);
        }

        public Builder fromMetadata(SnapshotMetadata snapshotMetadata) {
            this.zza = snapshotMetadata.getDescription();
            this.zzb = Long.valueOf(snapshotMetadata.getPlayedTime());
            this.zzc = Long.valueOf(snapshotMetadata.getProgressValue());
            if (this.zzb.longValue() == -1) {
                this.zzb = null;
            }
            Uri coverImageUri = snapshotMetadata.getCoverImageUri();
            this.zze = coverImageUri;
            if (coverImageUri != null) {
                this.zzd = null;
            }
            return this;
        }

        public Builder setCoverImage(Bitmap bitmap) {
            this.zzd = new BitmapTeleporter(bitmap);
            this.zze = null;
            return this;
        }

        public Builder setDescription(String str) {
            this.zza = str;
            return this;
        }

        public Builder setPlayedTimeMillis(long j) {
            this.zzb = Long.valueOf(j);
            return this;
        }

        public Builder setProgressValue(long j) {
            this.zzc = Long.valueOf(j);
            return this;
        }
    }

    Bitmap getCoverImage();

    String getDescription();

    Long getPlayedTimeMillis();

    Long getProgressValue();

    BitmapTeleporter zza();
}
