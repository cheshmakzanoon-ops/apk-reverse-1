package com.google.android.gms.common.api;

import android.os.Parcel;
import android.os.Parcelable;

final class zza implements Parcelable.Creator {
    private static final zza zzb = new zza(new zzb());
    private final Parcelable.Creator zza;

    private zza(Parcelable.Creator creator) {
        this.zza = creator;
    }

    public static zza zza() {
        return zzb;
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        int iDataPosition = parcel.dataPosition();
        if (parcel.readInt() == -204102970) {
            return zzb.zza(parcel);
        }
        parcel.setDataPosition(iDataPosition - 4);
        return ApiMetadata.getEmptyInstance();
    }

    @Override
    public final Object[] newArray(int i) {
        return new ApiMetadata[i];
    }
}
