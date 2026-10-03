package com.google.android.gms.games.multiplayer.realtime;

import android.os.Parcel;
import android.os.Parcelable;

final class zza implements Parcelable.Creator {
    zza() {
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        return new zzb();
    }

    @Override
    public final Object[] newArray(int i) {
        return new zzb[i];
    }
}
