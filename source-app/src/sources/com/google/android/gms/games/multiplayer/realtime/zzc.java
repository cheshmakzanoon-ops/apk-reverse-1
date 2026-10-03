package com.google.android.gms.games.multiplayer.realtime;

import android.os.Parcel;

final class zzc extends zzd {
    zzc() {
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        return createFromParcel(parcel);
    }

    @Override
    public final RoomEntity createFromParcel(Parcel parcel) {
        return (RoomEntity.zzp(RoomEntity.getUnparcelClientVersion()) || RoomEntity.canUnparcelSafely(RoomEntity.class.getCanonicalName())) ? super.createFromParcel(parcel) : new RoomEntity();
    }
}
