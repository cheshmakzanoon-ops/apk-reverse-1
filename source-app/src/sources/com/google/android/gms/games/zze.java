package com.google.android.gms.games;

import android.net.Uri;
import android.os.Parcel;

final class zze extends zzf {
    zze() {
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        return createFromParcel(parcel);
    }

    @Override
    public final GameEntity createFromParcel(Parcel parcel) {
        if (GameEntity.zzp(GameEntity.getUnparcelClientVersion()) || GameEntity.canUnparcelSafely(GameEntity.class.getCanonicalName())) {
            return super.createFromParcel(parcel);
        }
        String string = parcel.readString();
        String string2 = parcel.readString();
        String string3 = parcel.readString();
        String string4 = parcel.readString();
        String string5 = parcel.readString();
        String string6 = parcel.readString();
        String string7 = parcel.readString();
        Uri uri = string7 == null ? null : Uri.parse(string7);
        String string8 = parcel.readString();
        Uri uri2 = string8 == null ? null : Uri.parse(string8);
        String string9 = parcel.readString();
        return new GameEntity(string, string2, string3, string4, string5, string6, uri, uri2, string9 == null ? null : Uri.parse(string9), parcel.readInt() > 0, parcel.readInt() > 0, parcel.readString(), parcel.readInt(), parcel.readInt(), parcel.readInt(), false, false, null, null, null, false, false, false, null, false, false);
    }
}
