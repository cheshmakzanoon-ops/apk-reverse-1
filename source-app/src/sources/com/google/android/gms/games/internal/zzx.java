package com.google.android.gms.games.internal;

import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.GamesStatusUtils;
import com.google.android.gms.games.leaderboard.LeaderboardScoreBuffer;
import com.google.android.gms.games.leaderboard.LeaderboardScoreEntity;
import com.google.android.gms.tasks.TaskCompletionSource;
import j$.util.Objects;

final class zzx extends zza {
    final zzah zza;
    private final TaskCompletionSource zzb;

    zzx(zzah zzahVar, TaskCompletionSource taskCompletionSource) {
        Objects.requireNonNull(zzahVar);
        this.zza = zzahVar;
        this.zzb = taskCompletionSource;
    }

    @Override
    public final void zzk(DataHolder dataHolder) {
        int statusCode = dataHolder.getStatusCode();
        if (statusCode == 10003) {
            this.zza.zzT(this.zzb);
            dataHolder.close();
            return;
        }
        boolean z = statusCode == 3;
        if (statusCode != 0 && !z) {
            GamesStatusUtils.zzb(this.zzb, statusCode);
            dataHolder.close();
            return;
        }
        LeaderboardScoreBuffer leaderboardScoreBuffer = new LeaderboardScoreBuffer(dataHolder);
        try {
            LeaderboardScoreEntity leaderboardScoreEntity = leaderboardScoreBuffer.getCount() > 0 ? new LeaderboardScoreEntity(leaderboardScoreBuffer.get(0)) : null;
            leaderboardScoreBuffer.close();
            this.zzb.setResult(new AnnotatedData(leaderboardScoreEntity, z));
        } catch (Throwable th) {
            try {
                leaderboardScoreBuffer.close();
            } catch (Throwable th2) {
                th.addSuppressed(th2);
            }
            throw th;
        }
    }
}
