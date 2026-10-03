package com.google.android.gms.internal.games_v2;

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.common.internal.safeparcel.SafeParcelWriter;

public final class zzaf extends com.google.android.gms.games.internal.zzg {
    public static final Parcelable.Creator<zzaf> CREATOR = new zzag();
    private final Bundle zza;
    private final IBinder zzb;

    zzaf(Bundle bundle, IBinder iBinder) {
        this.zza = bundle;
        this.zzb = iBinder;
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        Bundle bundle = this.zza;
        int iBeginObjectHeader = SafeParcelWriter.beginObjectHeader(parcel);
        SafeParcelWriter.writeBundle(parcel, 1, bundle, false);
        SafeParcelWriter.writeIBinder(parcel, 2, this.zzb, false);
        SafeParcelWriter.finishObjectHeader(parcel, iBeginObjectHeader);
    }

    public zzaf(zzae zzaeVar) {
        this.zza = zzaeVar.zza();
        this.zzb = zzaeVar.zza;
    }
}
