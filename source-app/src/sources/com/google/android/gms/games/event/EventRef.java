package com.google.android.gms.games.event;

import android.database.CharArrayBuffer;
import android.net.Uri;
import android.os.Parcel;
import com.google.android.gms.common.data.DataBufferRef;
import com.google.android.gms.common.data.DataHolder;
import com.google.android.gms.games.Player;
import com.google.android.gms.games.PlayerRef;
import com.google.android.gms.measurement.api.AppMeasurementSdk;

public final class EventRef extends DataBufferRef implements Event {
    EventRef(DataHolder dataHolder, int i) {
        super(dataHolder, i);
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return EventEntity.zzb(this, obj);
    }

    @Override
    public final Event freeze() {
        return new EventEntity(this);
    }

    @Override
    public final String getDescription() {
        return getString("description");
    }

    @Override
    public final String getEventId() {
        return getString("external_event_id");
    }

    @Override
    public final String getFormattedValue() {
        return getString("formatted_value");
    }

    @Override
    public final Uri getIconImageUri() {
        return parseUri("icon_image_uri");
    }

    @Override
    public String getIconImageUrl() {
        return getString("icon_image_url");
    }

    @Override
    public final String getName() {
        return getString(AppMeasurementSdk.ConditionalUserProperty.NAME);
    }

    @Override
    public final Player getPlayer() {
        return new PlayerRef(this.mDataHolder, this.mDataRow, null);
    }

    @Override
    public final long getValue() {
        return getLong("value");
    }

    @Override
    public final int hashCode() {
        return EventEntity.zza(this);
    }

    @Override
    public final boolean isVisible() {
        return getBoolean("visibility");
    }

    public final String toString() {
        return EventEntity.zzc(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        new EventEntity(this).writeToParcel(parcel, i);
    }

    @Override
    public final void getDescription(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("description", charArrayBuffer);
    }

    @Override
    public final void getFormattedValue(CharArrayBuffer charArrayBuffer) {
        copyToBuffer("formatted_value", charArrayBuffer);
    }

    @Override
    public final void getName(CharArrayBuffer charArrayBuffer) {
        copyToBuffer(AppMeasurementSdk.ConditionalUserProperty.NAME, charArrayBuffer);
    }
}
