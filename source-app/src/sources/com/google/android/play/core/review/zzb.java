package com.google.android.play.core.review;

import android.app.PendingIntent;
import android.os.Parcel;
import android.os.Parcelable;

final class zzb implements Parcelable.Creator {
    zzb() {
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        return new zza((PendingIntent) parcel.readParcelable(ReviewInfo.class.getClassLoader()), parcel.readInt() != 0);
    }

    @Override
    public final Object[] newArray(int i) {
        return new ReviewInfo[i];
    }
}
