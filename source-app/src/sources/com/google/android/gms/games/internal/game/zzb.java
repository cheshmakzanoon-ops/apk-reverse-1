package com.google.android.gms.games.internal.game;

import android.net.Uri;
import android.os.Parcel;

final class zzb extends zzc {
    zzb() {
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        return createFromParcel(parcel);
    }

    @Override
    public final GameBadgeEntity createFromParcel(Parcel parcel) {
        if (GameBadgeEntity.zzp(GameBadgeEntity.getUnparcelClientVersion()) || GameBadgeEntity.canUnparcelSafely(GameBadgeEntity.class.getCanonicalName())) {
            return super.createFromParcel(parcel);
        }
        int i = parcel.readInt();
        String string = parcel.readString();
        String string2 = parcel.readString();
        String string3 = parcel.readString();
        return new GameBadgeEntity(i, string, string2, string3 == null ? null : Uri.parse(string3));
    }
}
