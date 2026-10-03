package com.google.android.gms.games;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import com.google.android.gms.common.data.DataHolder;

public final class GameRef extends zzg implements Game {
    public GameRef(DataHolder dataHolder, int i) {
        super(dataHolder, i);
    }

    @Override
    public final boolean areSnapshotsEnabled() {
        return getInteger("snapshots_enabled") > 0;
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return GameEntity.zzj(this, obj);
    }

    @Override
    public final Game freeze() {
        return new GameEntity(this);
    }

    @Override
    public final int getAchievementTotalCount() {
        return getInteger("achievement_total_count");
    }

    @Override
    public final String getApplicationId() {
        return getString("external_game_id");
    }

    @Override
    public final String getDescription() {
        return getString("game_description");
    }

    @Override
    public final String getDeveloperName() {
        return getString("developer_name");
    }

    @Override
    public final String getDisplayName() {
        return getString("display_name");
    }

    @Override
    public final Uri getFeaturedImageUri() {
        return parseUri("featured_image_uri");
    }

    @Override
    public String getFeaturedImageUrl() {
        return getString("featured_image_url");
    }

    @Override
    public final Uri getHiResImageUri() {
        return parseUri("game_hi_res_image_uri");
    }

    @Override
    public String getHiResImageUrl() {
        return getString("game_hi_res_image_url");
    }

    @Override
    public final Uri getIconImageUri() {
        return parseUri("game_icon_image_uri");
    }

    @Override
    public String getIconImageUrl() {
        return getString("game_icon_image_url");
    }

    @Override
    public final int getLeaderboardCount() {
        return getInteger("leaderboard_count");
    }

    @Override
    public final String getPrimaryCategory() {
        return getString("primary_category");
    }

    @Override
    public final String getSecondaryCategory() {
        return getString("secondary_category");
    }

    @Override
    public final String getThemeColor() {
        return getString("theme_color");
    }

    @Override
    public final boolean hasGamepadSupport() {
        return getInteger("gamepad_support") > 0;
    }

    @Override
    public final int hashCode() {
        return GameEntity.zzi(this);
    }

    public final String toString() {
        return GameEntity.zzk(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        new GameEntity(this).writeToParcel(parcel, i);
    }

    @Override
    public final boolean zza() {
        return getBoolean("play_enabled_game");
    }

    @Override
    public final boolean zzb() {
        return getBoolean("muted");
    }

    @Override
    public final boolean zzc() {
        return getBoolean("identity_sharing_confirmed");
    }

    @Override
    public final boolean zzd() {
        if (!hasColumn("profileless_recall_enabled_v3") || hasNull("profileless_recall_enabled_v3")) {
            return false;
        }
        return getBoolean("profileless_recall_enabled_v3");
    }

    @Override
    public final boolean zze() {
        return getInteger("installed") > 0;
    }

    @Override
    public final String zzf() {
        return getString("package_name");
    }

    @Override
    public final boolean zzg() {
        return getInteger("real_time_support") > 0;
    }

    @Override
    public final boolean zzh() {
        return getInteger("turn_based_support") > 0;
    }

    @Override
    public final void getDescription(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("game_description", charArrayBuffer);
    }

    @Override
    public final void getDeveloperName(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("developer_name", charArrayBuffer);
    }

    @Override
    public final void getDisplayName(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("display_name", charArrayBuffer);
    }
}
