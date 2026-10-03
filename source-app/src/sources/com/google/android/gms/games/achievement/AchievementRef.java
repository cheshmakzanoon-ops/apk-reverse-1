package com.google.android.gms.games.achievement;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import com.google.android.gms.common.data.DataBufferRef;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.common.internal.Asserts;
import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerRef;
import com.google.android.gms.measurement.api.AppMeasurementSdk;
import com.ishumei.smantifraud.l11l11I1111l;

public final class AchievementRef extends DataBufferRef implements Achievement {
    AchievementRef(DataHolder dataHolder, int i) {
        super(dataHolder, i);
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return AchievementEntity.zze(this, obj);
    }

    @Override
    public final Achievement freeze() {
        return new AchievementEntity(this);
    }

    @Override
    public final String getAchievementId() {
        return getString("external_achievement_id");
    }

    @Override
    public final int getCurrentSteps() {
        Asserts.checkState(getInteger(l11l11I1111l.l111l1111l1Il) == 1);
        return getInteger("current_steps");
    }

    @Override
    public final String getDescription() {
        return getString("description");
    }

    @Override
    public final String getFormattedCurrentSteps() {
        Asserts.checkState(getInteger(l11l11I1111l.l111l1111l1Il) == 1);
        return getString("formatted_current_steps");
    }

    @Override
    public final String getFormattedTotalSteps() {
        Asserts.checkState(getInteger(l11l11I1111l.l111l1111l1Il) == 1);
        return getString("formatted_total_steps");
    }

    @Override
    public final long getLastUpdatedTimestamp() {
        return getLong("last_updated_timestamp");
    }

    @Override
    public final String getName() {
        return getString(AppMeasurementSdk.ConditionalUserProperty.NAME);
    }

    @Override
    public final Player getPlayer() {
        return (Player) Preconditions.checkNotNull(zzb());
    }

    @Override
    public final Uri getRevealedImageUri() {
        return parseUri("revealed_icon_image_uri");
    }

    @Override
    public String getRevealedImageUrl() {
        return getString("revealed_icon_image_url");
    }

    @Override
    public final int getState() {
        return getInteger(l11l11I1111l.l111l1111llIl);
    }

    @Override
    public final int getTotalSteps() {
        Asserts.checkState(getInteger(l11l11I1111l.l111l1111l1Il) == 1);
        return getInteger("total_steps");
    }

    @Override
    public final int getType() {
        return getInteger(l11l11I1111l.l111l1111l1Il);
    }

    @Override
    public final Uri getUnlockedImageUri() {
        return parseUri("unlocked_icon_image_uri");
    }

    @Override
    public String getUnlockedImageUrl() {
        return getString("unlocked_icon_image_url");
    }

    @Override
    public final long getXpValue() {
        return (!hasColumn("instance_xp_value") || hasNull("instance_xp_value")) ? getLong("definition_xp_value") : getLong("instance_xp_value");
    }

    @Override
    public final int hashCode() {
        return AchievementEntity.zzd(this);
    }

    public final String toString() {
        return AchievementEntity.zzf(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        new AchievementEntity(this).writeToParcel(parcel, i);
    }

    @Override
    public final String zza() {
        return getString("external_game_id");
    }

    @Override
    public final Player zzb() {
        if (hasNull("external_player_id")) {
            return null;
        }
        return new PlayerRef(this.mDataHolder, this.mDataRow, null);
    }

    @Override
    public final float zzc() {
        if (!hasColumn("rarity_percent") || hasNull("rarity_percent")) {
            return -1.0f;
        }
        return getFloat("rarity_percent");
    }

    @Override
    public final void getDescription(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("description", charArrayBuffer);
    }

    @Override
    public final void getName(CharArrayBuffer charArrayBuffer) {
        copyToBuffer(AppMeasurementSdk.ConditionalUserProperty.NAME, charArrayBuffer);
    }

    @Override
    public final void getFormattedCurrentSteps(CharArrayBuffer charArrayBuffer) {
        Asserts.checkState(getInteger(l11l11I1111l.l111l1111l1Il) == 1);
        copyToBuffer("formatted_current_steps", charArrayBuffer);
    }

    @Override
    public final void getFormattedTotalSteps(CharArrayBuffer charArrayBuffer) {
        Asserts.checkState(getInteger(l11l11I1111l.l111l1111l1Il) == 1);
        copyToBuffer("formatted_total_steps", charArrayBuffer);
    }
}
