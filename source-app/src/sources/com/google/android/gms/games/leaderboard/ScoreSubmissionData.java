package com.google.android.gms.games.leaderboard;

import android.util.SparseArray;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.internal.games_v2.zzz;

public final class ScoreSubmissionData {
    private String zza;
    private String zzb;
    private int zzc;
    private SparseArray zzd = new SparseArray();

    public static final class Result {
        public final String formattedScore;
        public final boolean newBest;
        public final long rawScore;
        public final String scoreTag;

        public Result(long j, String str, String str2, boolean z) {
            this.rawScore = j;
            this.formattedScore = str;
            this.scoreTag = str2;
            this.newBest = z;
        }

        public String toString() {
            return Objects.toStringHelper(this).add("RawScore", Long.valueOf(this.rawScore)).add("FormattedScore", this.formattedScore).add("ScoreTag", this.scoreTag).add("NewBest", Boolean.valueOf(this.newBest)).toString();
        }
    }

    public ScoreSubmissionData(DataHolder dataHolder) {
        this.zzc = dataHolder.getStatusCode();
        int count = dataHolder.getCount();
        Preconditions.checkArgument(count == 3);
        int i = 0;
        while (i < count) {
            int windowIndex = dataHolder.getWindowIndex(i);
            if (i == 0) {
                this.zza = dataHolder.getString("leaderboardId", 0, windowIndex);
                this.zzb = dataHolder.getString("playerId", 0, windowIndex);
                i = 0;
            }
            if (dataHolder.getBoolean("hasResult", i, windowIndex)) {
                this.zzd.put(dataHolder.getInteger("timeSpan", i, windowIndex), new Result(dataHolder.getLong("rawScore", i, windowIndex), dataHolder.getString("formattedScore", i, windowIndex), dataHolder.getString("scoreTag", i, windowIndex), dataHolder.getBoolean("newBest", i, windowIndex)));
            }
            i++;
        }
    }

    public String getLeaderboardId() {
        return this.zza;
    }

    public String getPlayerId() {
        return this.zzb;
    }

    public Result getScoreResult(int i) {
        return (Result) this.zzd.get(i);
    }

    public String toString() {
        Objects.ToStringHelper toStringHelperAdd = Objects.toStringHelper(this).add("PlayerId", this.zzb).add("StatusCode", Integer.valueOf(this.zzc));
        for (int i = 0; i < 3; i++) {
            Result result = (Result) this.zzd.get(i);
            toStringHelperAdd.add("TimesSpan", zzz.zza(i));
            toStringHelperAdd.add("Result", result == null ? "null" : result.toString());
        }
        return toStringHelperAdd.toString();
    }
}
