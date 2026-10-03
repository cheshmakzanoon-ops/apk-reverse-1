package com.google.android.gms.games;

import android.content.Intent;
import android.os.Bundle;
import com.google.android.gms.common.api.ApiException;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.games.snapshot.Snapshot;
import com.google.android.gms.games.snapshot.SnapshotContents;
import com.google.android.gms.games.snapshot.SnapshotMetadata;
import com.google.android.gms.games.snapshot.SnapshotMetadataBuffer;
import com.google.android.gms.games.snapshot.SnapshotMetadataChange;
import com.google.android.gms.tasks.Task;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

public interface SnapshotsClient {
    public static final int DISPLAY_LIMIT_NONE = -1;
    public static final String EXTRA_SNAPSHOT_METADATA = "com.google.android.gms.games.SNAPSHOT_METADATA";
    public static final String EXTRA_SNAPSHOT_NEW = "com.google.android.gms.games.SNAPSHOT_NEW";
    public static final int RESOLUTION_POLICY_HIGHEST_PROGRESS = 4;
    public static final int RESOLUTION_POLICY_LAST_KNOWN_GOOD = 2;
    public static final int RESOLUTION_POLICY_LONGEST_PLAYTIME = 1;
    public static final int RESOLUTION_POLICY_MANUAL = -1;
    public static final int RESOLUTION_POLICY_MOST_RECENTLY_MODIFIED = 3;

    public final class CC {
        public static SnapshotMetadata getSnapshotFromBundle(Bundle bundle) {
            if (bundle == null || !bundle.containsKey(SnapshotsClient.EXTRA_SNAPSHOT_METADATA)) {
                return null;
            }
            return (SnapshotMetadata) bundle.getParcelable(SnapshotsClient.EXTRA_SNAPSHOT_METADATA);
        }
    }

    public static final class DataOrConflict<T> {
        private final Object zza;
        private final SnapshotConflict zzb;

        public DataOrConflict(Object obj, SnapshotConflict snapshotConflict) {
            this.zza = obj;
            this.zzb = snapshotConflict;
        }

        public SnapshotConflict getConflict() {
            if (isConflict()) {
                return this.zzb;
            }
            throw new IllegalStateException("getConflict called when there is no conflict.");
        }

        public T getData() {
            if (isConflict()) {
                throw new IllegalStateException("getData called when there is a conflict.");
            }
            return (T) this.zza;
        }

        public boolean isConflict() {
            return this.zzb != null;
        }
    }

    @Retention(RetentionPolicy.SOURCE)
    public @interface ResolutionPolicy {
    }

    public static final class SnapshotConflict {
        private final Snapshot zza;
        private final String zzb;
        private final Snapshot zzc;
        private final SnapshotContents zzd;

        public SnapshotConflict(Snapshot snapshot, String str, Snapshot snapshot2, SnapshotContents snapshotContents) {
            this.zza = snapshot;
            this.zzb = str;
            this.zzc = snapshot2;
            this.zzd = snapshotContents;
        }

        public String getConflictId() {
            return this.zzb;
        }

        public Snapshot getConflictingSnapshot() {
            return this.zzc;
        }

        public SnapshotContents getResolutionSnapshotContents() {
            return this.zzd;
        }

        public Snapshot getSnapshot() {
            return this.zza;
        }
    }

    public static final class SnapshotContentUnavailableApiException extends ApiException {
        protected final SnapshotMetadata metadata;

        public SnapshotContentUnavailableApiException(Status status, SnapshotMetadata snapshotMetadata) {
            super(status);
            this.metadata = snapshotMetadata;
        }

        public SnapshotMetadata getSnapshotMetadata() {
            return this.metadata;
        }
    }

    Task<SnapshotMetadata> commitAndClose(Snapshot snapshot, SnapshotMetadataChange snapshotMetadataChange);

    Task<String> delete(SnapshotMetadata snapshotMetadata);

    Task<Void> discardAndClose(Snapshot snapshot);

    Task<Integer> getMaxCoverImageSize();

    Task<Integer> getMaxDataSize();

    Task<Intent> getSelectSnapshotIntent(String str, boolean z, boolean z2, int i);

    Task<AnnotatedData<SnapshotMetadataBuffer>> load(boolean z);

    Task<DataOrConflict<Snapshot>> open(SnapshotMetadata snapshotMetadata);

    Task<DataOrConflict<Snapshot>> open(SnapshotMetadata snapshotMetadata, int i);

    Task<DataOrConflict<Snapshot>> open(String str, boolean z);

    Task<DataOrConflict<Snapshot>> open(String str, boolean z, int i);

    Task<DataOrConflict<Snapshot>> resolveConflict(String str, Snapshot snapshot);

    Task<DataOrConflict<Snapshot>> resolveConflict(String str, String str2, SnapshotMetadataChange snapshotMetadataChange, SnapshotContents snapshotContents);
}
