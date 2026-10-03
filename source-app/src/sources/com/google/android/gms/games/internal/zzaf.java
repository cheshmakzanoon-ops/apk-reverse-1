package com.google.android.gms.games.internal;

import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.GamesStatusUtils;
import com.google.android.gms.games.leaderboard.ScoreSubmissionData;
import com.google.android.gms.tasks.TaskCompletionSource;

final class zzaf extends zza {
    private final TaskCompletionSource zza;

    zzaf(TaskCompletionSource taskCompletionSource) {
        this.zza = taskCompletionSource;
    }

    @Override
    public final void zzg(DataHolder dataHolder) {
        int statusCode = dataHolder.getStatusCode();
        if (statusCode != 0 && statusCode != 5) {
            GamesStatusUtils.zzb(this.zza, statusCode);
            dataHolder.close();
        } else {
            try {
                this.zza.setResult(new ScoreSubmissionData(dataHolder));
            } finally {
                dataHolder.close();
            }
        }
    }
}
