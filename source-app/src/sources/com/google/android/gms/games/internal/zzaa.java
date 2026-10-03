package com.google.android.gms.games.internal;

import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.GamesStatusUtils;
import com.google.android.gms.games.snapshot.SnapshotMetadataBuffer;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzaa extends zza {
    private final TaskCompletionSource zza;

    zzaa(TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void zzl(DataHolder dataHolder) {
        int statusCode = dataHolder.getStatusCode();
        boolean z = statusCode == 3;
        if (statusCode == 0 || z) {
            this.zza.setResult(new AnnotatedData(new SnapshotMetadataBuffer(dataHolder), z));
        } else {
            GamesStatusUtils.zzb(this.zza, statusCode);
            dataHolder.close();
        }
    }
}
