package com.google.android.gms.games.leaderboard;

import android.database.CharArrayBuffer;
import android.net.Uri;
import com.google.android.gms.common.data.DataBufferRef;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerRef;

public final class LeaderboardScoreRef extends DataBufferRef implements LeaderboardScore {
    private final PlayerRef zza;

    public LeaderboardScoreRef(DataHolder dataHolder, int i) {
        super(dataHolder, i);
        this.zza = new PlayerRef(dataHolder, i, null);
    }

    @Override
    public final boolean equals(Object obj) {
        return LeaderboardScoreEntity.zzb(this, obj);
    }

    @Override
    public final LeaderboardScore freeze() {
        return new LeaderboardScoreEntity(this);
    }

    @Override
    public final String getDisplayRank() {
        return getString("display_rank");
    }

    @Override
    public final String getDisplayScore() {
        return getString("display_score");
    }

    @Override
    public final long getRank() {
        return getLong("rank");
    }

    @Override
    public final long getRawScore() {
        return getLong("raw_score");
    }

    @Override
    public final Player getScoreHolder() {
        if (hasNull("external_player_id")) {
            return null;
        }
        return this.zza;
    }

    @Override
    public final String getScoreHolderDisplayName() {
        return hasNull("external_player_id") ? getString("default_display_name") : this.zza.getDisplayName();
    }

    @Override
    public final Uri getScoreHolderHiResImageUri() {
        if (hasNull("external_player_id")) {
            return null;
        }
        return this.zza.getHiResImageUri();
    }

    @Override
    public String getScoreHolderHiResImageUrl() {
        if (hasNull("external_player_id")) {
            return null;
        }
        return this.zza.getHiResImageUrl();
    }

    @Override
    public final Uri getScoreHolderIconImageUri() {
        return hasNull("external_player_id") ? parseUri("default_display_image_uri") : this.zza.getIconImageUri();
    }

    @Override
    public String getScoreHolderIconImageUrl() {
        return hasNull("external_player_id") ? getString("default_display_image_url") : this.zza.getIconImageUrl();
    }

    @Override
    public final String getScoreTag() {
        return getString("score_tag");
    }

    @Override
    public final long getTimestampMillis() {
        return getLong("achieved_timestamp");
    }

    @Override
    public final int hashCode() {
        return LeaderboardScoreEntity.zza(this);
    }

    public final String toString() {
        return LeaderboardScoreEntity.zzc(this);
    }

    @Override
    public final void getDisplayRank(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("display_rank", charArrayBuffer);
    }

    @Override
    public final void getDisplayScore(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("display_score", charArrayBuffer);
    }

    @Override
    public final void getScoreHolderDisplayName(CharArrayBuffer charArrayBuffer) {
        if (hasNull("external_player_id")) {
            copyToBuffer("default_display_name", charArrayBuffer);
        } else {
            this.zza.getDisplayName(charArrayBuffer);
        }
    }
}
