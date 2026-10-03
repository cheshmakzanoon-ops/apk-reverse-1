package com.google.android.gms.games.internal;

import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.drive.Contents;
import com.google.android.gms.games.GamesStatusUtils;
import com.google.android.gms.games.SnapshotsClient;
import com.google.android.gms.games.snapshot.SnapshotContentsEntity;
import com.google.android.gms.games.snapshot.SnapshotEntity;
import com.google.android.gms.games.snapshot.SnapshotMetadataBuffer;
import com.google.android.gms.games.snapshot.SnapshotMetadataEntity;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzag extends zza {
    private final TaskCompletionSource zza;

    zzag(TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void zzm(DataHolder dataHolder, Contents contents) {
        int statusCode = dataHolder.getStatusCode();
        SnapshotMetadataBuffer snapshotMetadataBuffer = new SnapshotMetadataBuffer(dataHolder);
        try {
            SnapshotEntity snapshotEntity = snapshotMetadataBuffer.getCount() > 0 ? new SnapshotEntity(new SnapshotMetadataEntity(snapshotMetadataBuffer.get(0)), new SnapshotContentsEntity(contents)) : null;
            snapshotMetadataBuffer.close();
            if (statusCode == 0) {
                this.zza.setResult(new SnapshotsClient.DataOrConflict(snapshotEntity, null));
                return;
            }
            if (statusCode == 4002) {
                if (snapshotEntity != null && snapshotEntity.getMetadata() != null) {
                    this.zza.setException(new SnapshotsClient.SnapshotContentUnavailableApiException(com.google.android.gms.games.zzj.zza(4002), snapshotEntity.getMetadata()));
                    return;
                }
                statusCode = 4002;
            }
            GamesStatusUtils.zzb(this.zza, statusCode);
        } catch (Throwable th) {
            try {
                snapshotMetadataBuffer.close();
            } catch (Throwable th2) {
                th.addSuppressed(th2);
            }
            throw th;
        }
    }

    @Override
    public final void zzn(DataHolder dataHolder, String str, Contents contents, Contents contents2, Contents contents3) {
        SnapshotMetadataBuffer snapshotMetadataBuffer = new SnapshotMetadataBuffer(dataHolder);
        try {
            if (snapshotMetadataBuffer.getCount() >= 2 && str != null && contents3 != null) {
                SnapshotEntity snapshotEntity = new SnapshotEntity(new SnapshotMetadataEntity(snapshotMetadataBuffer.get(0)), new SnapshotContentsEntity(contents));
                SnapshotEntity snapshotEntity2 = new SnapshotEntity(new SnapshotMetadataEntity(snapshotMetadataBuffer.get(1)), new SnapshotContentsEntity(contents2));
                snapshotMetadataBuffer.close();
                this.zza.setResult(new SnapshotsClient.DataOrConflict(null, new SnapshotsClient.SnapshotConflict(snapshotEntity, str, snapshotEntity2, new SnapshotContentsEntity(contents3))));
                return;
            }
            this.zza.setResult(null);
            snapshotMetadataBuffer.close();
        } catch (Throwable th) {
            try {
                snapshotMetadataBuffer.close();
            } catch (Throwable th2) {
                th.addSuppressed(th2);
            }
            throw th;
        }
    }
}
