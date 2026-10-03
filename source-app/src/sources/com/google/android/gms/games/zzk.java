package com.google.android.gms.games;

import android.net.Uri;
import android.os.Parcel;

final class zzk extends zzl {
    zzk() {
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        return createFromParcel(parcel);
    }

    @Override
    public final PlayerEntity createFromParcel(Parcel parcel) {
        if (PlayerEntity.zzp(PlayerEntity.getUnparcelClientVersion()) || PlayerEntity.canUnparcelSafely(PlayerEntity.class.getCanonicalName())) {
            return super.createFromParcel(parcel);
        }
        String string = parcel.readString();
        String string2 = parcel.readString();
        String string3 = parcel.readString();
        String string4 = parcel.readString();
        return new PlayerEntity(string, string2, string3 == null ? null : Uri.parse(string3), string4 == null ? null : Uri.parse(string4), parcel.readLong(), -1, -1L, null, null, null, null, null, true, false, parcel.readString(), parcel.readString(), null, null, null, null, -1L, null, null, false, null);
    }
}
