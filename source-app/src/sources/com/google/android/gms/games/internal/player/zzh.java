package com.google.android.gms.games.internal.player;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;

public final class zzh extends com.google.android.gms.games.internal.zzg {
    public static final Parcelable.Creator<zzh> CREATOR = new zzi();
    private final String zza;

    public zzh(String str) {
        this.zza = str;
    }

    public final boolean equals(Object obj) {
        if (!(obj instanceof zzh)) {
            return false;
        }
        if (obj == this) {
            return true;
        }
        return Objects.equal(this.zza, ((zzh) obj).zza);
    }

    public final int hashCode() {
        return Objects.hashCode(this.zza);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        String str = this.zza;
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeString(parcel, 1, str, false);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }
}
