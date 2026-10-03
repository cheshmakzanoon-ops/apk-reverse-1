package com.google.android.gms.common.internal;

import android.os.Parcel;
import android.os.Parcelable;

final class zzh implements Parcelable.Creator {
    zzh() {
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        return new BinderWrapper(parcel, null);
    }

    @Override
    public final Object[] newArray(int i) {
        return new BinderWrapper[i];
    }
}
