package com.google.android.p004a;

import android.os.Parcel;
import android.os.Parcelable;

public final class C1782c {
    static {
        C1782c.class.getClassLoader();
    }

    private C1782c() {
    }

    public static <T extends Parcelable> T m213a(Parcel parcel, Parcelable.Creator<T> creator) {
        if (parcel.readInt() == 0) {
            return null;
        }
        return creator.createFromParcel(parcel);
    }

    public static void m214b(Parcel parcel, Parcelable parcelable) {
        parcel.writeInt(1);
        parcelable.writeToParcel(parcel, 0);
    }

    public static void m215c(Parcel parcel, Parcelable parcelable) {
        if (parcelable == null) {
            parcel.writeInt(0);
        } else {
            parcel.writeInt(1);
            parcelable.writeToParcel(parcel, 1);
        }
    }
}
