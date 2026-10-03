package com.google.android.gms.games;

import android.content.Intent;
import com.google.android.gms.common.api.Releasable;
import com.google.android.gms.games.leaderboard.Leaderboard;
import com.google.android.gms.games.leaderboard.LeaderboardBuffer;
import com.google.android.gms.games.leaderboard.LeaderboardScore;
import com.google.android.gms.games.leaderboard.LeaderboardScoreBuffer;
import com.google.android.gms.games.leaderboard.ScoreSubmissionData;
import com.google.android.gms.tasks.Task;

public interface LeaderboardsClient {

    public static class LeaderboardScores implements Releasable {
        private final Leaderboard zza;
        private final LeaderboardScoreBuffer zzb;

        public LeaderboardScores(Leaderboard leaderboard, LeaderboardScoreBuffer leaderboardScoreBuffer) {
            this.zza = leaderboard;
            this.zzb = leaderboardScoreBuffer;
        }

        public Leaderboard getLeaderboard() {
            return this.zza;
        }

        public LeaderboardScoreBuffer getScores() {
            return this.zzb;
        }

        @Override
        public void release() {
            this.zzb.release();
        }
    }

    Task<Intent> getAllLeaderboardsIntent();

    Task<Intent> getLeaderboardIntent(String str);

    Task<Intent> getLeaderboardIntent(String str, int i);

    Task<Intent> getLeaderboardIntent(String str, int i, int i2);

    Task<AnnotatedData<LeaderboardScore>> loadCurrentPlayerLeaderboardScore(String str, int i, int i2);

    Task<AnnotatedData<Leaderboard>> loadLeaderboardMetadata(String str, boolean z);

    Task<AnnotatedData<LeaderboardBuffer>> loadLeaderboardMetadata(boolean z);

    Task<AnnotatedData<LeaderboardScores>> loadMoreScores(LeaderboardScoreBuffer leaderboardScoreBuffer, int i, int i2);

    Task<AnnotatedData<LeaderboardScores>> loadPlayerCenteredScores(String str, int i, int i2, int i3);

    Task<AnnotatedData<LeaderboardScores>> loadPlayerCenteredScores(String str, int i, int i2, int i3, boolean z);

    Task<AnnotatedData<LeaderboardScores>> loadTopScores(String str, int i, int i2, int i3);

    Task<AnnotatedData<LeaderboardScores>> loadTopScores(String str, int i, int i2, int i3, boolean z);

    void submitScore(String str, long j);

    void submitScore(String str, long j, String str2);

    Task<ScoreSubmissionData> submitScoreImmediate(String str, long j);

    Task<ScoreSubmissionData> submitScoreImmediate(String str, long j, String str2);
}
