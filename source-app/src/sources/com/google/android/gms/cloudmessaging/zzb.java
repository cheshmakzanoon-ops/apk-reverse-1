package com.google.android.gms.cloudmessaging;

import android.os.Parcel;
import android.os.Parcelable;

final class zzb implements Parcelable.Creator<zzd> {
    zzb() {
    }

    @Override
    public final zzd createFromParcel(Parcel parcel) {
        return new zzd(parcel.readStrongBinder());
    }

    @Override
    public final zzd[] newArray(int i) {
        return new zzd[i];
    }
}
