package com.google.android.gms.games.multiplayer;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;
import com.google.android.gms.games.internal.GamesDowngradeableSafeParcel;

@Deprecated
public final class ParticipantEntity extends GamesDowngradeableSafeParcel {
    public static final Parcelable.Creator<ParticipantEntity> CREATOR = new zza();

    ParticipantEntity() {
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        if (!shouldDowngrade()) {
            SafeParcelWriter.finishObjectHeader(parcel, SafeParcelWriter.beginObjectHeader(parcel));
            return;
        }
        parcel.writeString("unsupported");
        parcel.writeString("unsupported");
        parcel.writeString(null);
        parcel.writeString(null);
        parcel.writeInt(0);
        parcel.writeString("unsupported");
        parcel.writeInt(0);
        parcel.writeInt(0);
    }
}
