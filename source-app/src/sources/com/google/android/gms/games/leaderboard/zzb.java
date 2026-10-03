package com.google.android.gms.games.leaderboard;

import com.google.android.gms.common.data.DataBufferRef;
import com.google.android.gms.common.data.DataHolder;

public final class zzb extends DataBufferRef implements LeaderboardVariant {
    zzb(DataHolder dataHolder, int i) {
        super(dataHolder, i);
    }

    @Override
    public final boolean equals(Object obj) {
        return LeaderboardVariantEntity.zze(this, obj);
    }

    @Override
    public final LeaderboardVariant freeze() {
        return new LeaderboardVariantEntity(this);
    }

    @Override
    public final int getCollection() {
        return getInteger("collection");
    }

    @Override
    public final String getDisplayPlayerRank() {
        return getString("player_display_rank");
    }

    @Override
    public final String getDisplayPlayerScore() {
        return getString("player_display_score");
    }

    @Override
    public final long getNumScores() {
        if (hasNull("total_scores")) {
            return -1L;
        }
        return getLong("total_scores");
    }

    @Override
    public final long getPlayerRank() {
        if (hasNull("player_rank")) {
            return -1L;
        }
        return getLong("player_rank");
    }

    @Override
    public final String getPlayerScoreTag() {
        return getString("player_score_tag");
    }

    @Override
    public final long getRawPlayerScore() {
        if (hasNull("player_raw_score")) {
            return -1L;
        }
        return getLong("player_raw_score");
    }

    @Override
    public final int getTimeSpan() {
        return getInteger("timespan");
    }

    @Override
    public final boolean hasPlayerInfo() {
        return !hasNull("player_raw_score");
    }

    @Override
    public final int hashCode() {
        return LeaderboardVariantEntity.zzd(this);
    }

    public final String toString() {
        return LeaderboardVariantEntity.zzf(this);
    }

    @Override
    public final String zza() {
        return getString("top_page_token_next");
    }

    @Override
    public final String zzb() {
        return getString("window_page_token_prev");
    }

    @Override
    public final String zzc() {
        return getString("window_page_token_next");
    }
}
