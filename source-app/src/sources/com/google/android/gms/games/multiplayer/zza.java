package com.google.android.gms.games.multiplayer;

import android.os.Parcel;

final class zza extends zzb {
    zza() {
    }

    @Override
    public final Object createFromParcel(Parcel parcel) {
        return createFromParcel(parcel);
    }

    @Override
    public final ParticipantEntity createFromParcel(Parcel parcel) {
        return (ParticipantEntity.zzp(ParticipantEntity.getUnparcelClientVersion()) || ParticipantEntity.canUnparcelSafely(ParticipantEntity.class.getCanonicalName())) ? super.createFromParcel(parcel) : new ParticipantEntity();
    }
}
