package com.google.android.gms.internal.games_v2;

import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.safeparcel.AbstractSafeParcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;

public final class zzq extends AbstractSafeParcelable {
    public static final Parcelable.Creator<zzq> CREATOR = new zzr();
    private final int zza;
    private final zzx zzb;

    zzq(int i, zzx zzxVar) {
        this.zza = i;
        this.zzb = zzxVar;
    }

    public static zzq zza(int i) {
        return new zzq(i, null);
    }

    public static zzq zzb(int i, zzx zzxVar) {
        return new zzq(i, zzxVar);
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof zzq)) {
            return false;
        }
        zzq zzqVar = (zzq) obj;
        return this.zza == zzqVar.zza && Objects.equal(this.zzb, zzqVar.zzb);
    }

    public final int hashCode() {
        return Objects.hashCode(Integer.valueOf(this.zza), this.zzb);
    }

    public final String toString() {
        return Objects.toStringHelper(this).add("signInType", Integer.valueOf(this.zza)).add("previousStepResolutionResult", this.zzb).toString();
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeInt(parcel, 1, this.zza);
        SafeParcelWriter.writeParcelable(parcel, 2, this.zzb, i, false);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }

    public final int zzc() {
        return this.zza;
    }

    public final boolean zzd() {
        return this.zzb == null;
    }
}
