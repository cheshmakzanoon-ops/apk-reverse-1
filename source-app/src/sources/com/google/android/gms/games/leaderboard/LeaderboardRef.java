package com.google.android.gms.games.leaderboard;

import android.database.CharArrayBuffer;
import android.net.Uri;
import com.google.android.gms.common.data.DataBufferRef;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.Game;
import com.google.android.gms.games.GameRef;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import java.util.ArrayList;

public final class LeaderboardRef extends DataBufferRef implements Leaderboard {
    private final int zza;
    private final Game zzb;

    LeaderboardRef(DataHolder dataHolder, int i, int i2) {
        super(dataHolder, i);
        this.zza = i2;
        this.zzb = new GameRef(dataHolder, i);
    }

    @Override
    public final boolean equals(Object obj) {
        return LeaderboardEntity.zzc(this, obj);
    }

    @Override
    public final Leaderboard freeze() {
        return new LeaderboardEntity(this);
    }

    @Override
    public final String getDisplayName() {
        return getString(AppMeasurementSdk.ConditionalUserProperty.NAME);
    }

    @Override
    public final Uri getIconImageUri() {
        return parseUri("board_icon_image_uri");
    }

    @Override
    public String getIconImageUrl() {
        return getString("board_icon_image_url");
    }

    @Override
    public final String getLeaderboardId() {
        return getString("external_leaderboard_id");
    }

    @Override
    public final int getScoreOrder() {
        return getInteger("score_order");
    }

    @Override
    public final ArrayList<LeaderboardVariant> getVariants() {
        int i = this.zza;
        ArrayList<LeaderboardVariant> arrayList = new ArrayList<>(i);
        for (int i2 = 0; i2 < i; i2++) {
            arrayList.add(new zzb(this.mDataHolder, this.mDataRow + i2));
        }
        return arrayList;
    }

    @Override
    public final int hashCode() {
        return LeaderboardEntity.zzb(this);
    }

    public final String toString() {
        return LeaderboardEntity.zzd(this);
    }

    @Override
    public final Game zza() {
        return this.zzb;
    }

    @Override
    public final void getDisplayName(CharArrayBuffer charArrayBuffer) {
        copyToBuffer(AppMeasurementSdk.ConditionalUserProperty.NAME, charArrayBuffer);
    }
}
