package com.google.android.gms.internal.games_v2;

import android.content.Intent;
import android.os.RemoteException;
import com.google.android.gms.common.api.GoogleApi;
import com.google.android.gms.common.api.internal.RemoteCall;
import com.google.android.gms.common.api.internal.TaskApiCall;
import com.google.android.gms.games.AnnotatedData;
import com.google.android.gms.games.LeaderboardsClient;
import com.google.android.gms.games.leaderboard.Leaderboard;
import com.google.android.gms.games.leaderboard.LeaderboardBuffer;
import com.google.android.gms.games.leaderboard.LeaderboardScore;
import com.google.android.gms.games.leaderboard.LeaderboardScoreBuffer;
import com.google.android.gms.games.leaderboard.ScoreSubmissionData;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.tasks.TaskCompletionSource;

public final class zzdq implements LeaderboardsClient {
    private final zzaq zza;

    public zzdq(zzaq zzaqVar) {
        this.zza = zzaqVar;
    }

    @Override
    public final Task<Intent> getAllLeaderboardsIntent() {
        return this.zza.zzb(zzdp.zza);
    }

    @Override
    public final Task<Intent> getLeaderboardIntent(String str) {
        return getLeaderboardIntent(str, -1, -1);
    }

    @Override
    public final Task<AnnotatedData<LeaderboardScore>> loadCurrentPlayerLeaderboardScore(final String str, final int i, final int i2) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final int i3 = i;
                final int i4 = i2;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzw((TaskCompletionSource) obj2, str2, i3, i4);
                    }
                }).setMethodKey(6703).build());
            }
        });
    }

    @Override
    public final Task<AnnotatedData<Leaderboard>> loadLeaderboardMetadata(final String str, final boolean z) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final boolean z2 = z;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzv((TaskCompletionSource) obj2, str2, z2);
                    }
                }).setMethodKey(6702).build());
            }
        });
    }

    @Override
    public final Task<AnnotatedData<LeaderboardsClient.LeaderboardScores>> loadMoreScores(final LeaderboardScoreBuffer leaderboardScoreBuffer, final int i, final int i2) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final LeaderboardScoreBuffer leaderboardScoreBuffer2 = leaderboardScoreBuffer;
                final int i3 = i;
                final int i4 = i2;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzz((TaskCompletionSource) obj2, leaderboardScoreBuffer2, i3, i4);
                    }
                }).setMethodKey(6706).build());
            }
        });
    }

    @Override
    public final Task<AnnotatedData<LeaderboardsClient.LeaderboardScores>> loadPlayerCenteredScores(String str, int i, int i2, int i3) {
        return this.zza.zzb(new zzdk(str, i, i2, i3, false));
    }

    @Override
    public final Task<AnnotatedData<LeaderboardsClient.LeaderboardScores>> loadTopScores(String str, int i, int i2, int i3) {
        return this.zza.zzb(new zzdj(str, i, i2, i3, false));
    }

    @Override
    public final void submitScore(String str, long j) {
        this.zza.zzb(new zzdm(str, j));
    }

    @Override
    public final Task<ScoreSubmissionData> submitScoreImmediate(String str, long j) {
        return this.zza.zzb(new zzdm(str, j));
    }

    @Override
    public final Task<Intent> getLeaderboardIntent(String str, int i) {
        return getLeaderboardIntent(str, i, -1);
    }

    @Override
    public final Task<AnnotatedData<LeaderboardBuffer>> loadLeaderboardMetadata(final boolean z) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final boolean z2 = z;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) throws RemoteException {
                        ((com.google.android.gms.games.internal.zzah) obj).zzu((TaskCompletionSource) obj2, z2);
                    }
                }).setMethodKey(6702).build());
            }
        });
    }

    @Override
    public final Task<AnnotatedData<LeaderboardsClient.LeaderboardScores>> loadPlayerCenteredScores(String str, int i, int i2, int i3, boolean z) {
        return this.zza.zzb(new zzdk(str, i, i2, i3, z));
    }

    @Override
    public final Task<AnnotatedData<LeaderboardsClient.LeaderboardScores>> loadTopScores(String str, int i, int i2, int i3, boolean z) {
        return this.zza.zzb(new zzdj(str, i, i2, i3, z));
    }

    @Override
    public final void submitScore(String str, long j, String str2) {
        this.zza.zzb(new zzdn(str, j, str2));
    }

    @Override
    public final Task<ScoreSubmissionData> submitScoreImmediate(String str, long j, String str2) {
        return this.zza.zzb(new zzdn(str, j, str2));
    }

    @Override
    public final Task<Intent> getLeaderboardIntent(final String str, final int i, final int i2) {
        return this.zza.zzb(new zzap() {
            @Override
            public final Task zza(GoogleApi googleApi) {
                TaskApiCall.Builder builder = TaskApiCall.builder();
                final String str2 = str;
                final int i3 = i;
                final int i4 = i2;
                return googleApi.doRead(builder.run(new RemoteCall() {
                    @Override
                    public final void accept(Object obj, Object obj2) {
                        ((TaskCompletionSource) obj2).setResult(((com.google.android.gms.games.internal.zzam) ((com.google.android.gms.games.internal.zzah) obj).getService()).zzP(str2, i3, i4));
                    }
                }).setMethodKey(6701).build());
            }
        });
    }
}
