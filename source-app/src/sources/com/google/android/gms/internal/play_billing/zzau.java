package com.google.android.gms.internal.play_billing;

import android.os.IInterface;
import android.os.Parcel;
import android.os.Parcelable;

public final class zzau {
    public static final int zza = 0;

    static {
        zzau.class.getClassLoader();
    }

    private zzau() {
    }

    public static Parcelable zza(Parcel parcel, Parcelable.Creator creator) {
        if (parcel.readInt() == 0) {
            return null;
        }
        return (Parcelable) creator.createFromParcel(parcel);
    }

    public static void zzb(Parcel parcel, Parcelable parcelable) {
        parcel.writeInt(1);
        parcelable.writeToParcel(parcel, 0);
    }

    public static void zzc(Parcel parcel, IInterface iInterface) {
        parcel.writeStrongBinder(iInterface.asBinder());
    }
}
