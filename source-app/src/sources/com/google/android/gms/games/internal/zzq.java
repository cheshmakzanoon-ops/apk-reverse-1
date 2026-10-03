package com.google.android.gms.games.internal;

import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.GamesStatusUtils;
import com.google.android.gms.games.snapshot.SnapshotMetadataBuffer;
import com.google.android.gms.games.snapshot.SnapshotMetadataEntity;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzq extends zza {
    private final TaskCompletionSource zza;

    zzq(TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void zzo(DataHolder dataHolder) {
        int statusCode = dataHolder.getStatusCode();
        if (statusCode != 0) {
            GamesStatusUtils.zzb(this.zza, statusCode);
            dataHolder.close();
            return;
        }
        SnapshotMetadataBuffer snapshotMetadataBuffer = new SnapshotMetadataBuffer(dataHolder);
        try {
            SnapshotMetadataEntity snapshotMetadataEntity = snapshotMetadataBuffer.getCount() > 0 ? new SnapshotMetadataEntity(snapshotMetadataBuffer.get(0)) : null;
            snapshotMetadataBuffer.close();
            this.zza.setResult(snapshotMetadataEntity);
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
