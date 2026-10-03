package com.google.android.gms.common.internal.safeparcel;

public abstract class AbstractSafeParcelable implements SafeParcelable {
    @Override
    public final int describeContents() {
        return 0;
    }
}
