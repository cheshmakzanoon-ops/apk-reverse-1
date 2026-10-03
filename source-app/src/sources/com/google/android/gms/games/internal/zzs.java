package com.google.android.gms.games.internal;

import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.GamesStatusUtils;
import com.google.android.gms.games.event.EventBuffer;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzs extends zza {
    private final TaskCompletionSource zza;

    zzs(TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void zzc(DataHolder dataHolder) {
        int statusCode = dataHolder.getStatusCode();
        boolean z = statusCode == 3;
        if (statusCode == 0 || z) {
            this.zza.setResult(new AnnotatedData(new EventBuffer(dataHolder), z));
        } else {
            GamesStatusUtils.zzb(this.zza, statusCode);
            dataHolder.close();
        }
    }
}
