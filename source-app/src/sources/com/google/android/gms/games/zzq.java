package com.google.android.gms.games;

import android.os.Parcel;
import com.google.android.gms.common.data.DataHolder;

public final class zzq extends zzg implements PlayerRelationshipInfo {
    private final com.google.android.gms.games.internal.player.zzd zza;

    public zzq(DataHolder dataHolder, int i, com.google.android.gms.games.internal.player.zzd zzdVar) {
        super(dataHolder, i);
        this.zza = zzdVar;
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return zzo.zze(this, obj);
    }

    @Override
    public final PlayerRelationshipInfo freeze() {
        return new zzo(this);
    }

    @Override
    public final int getFriendStatus() {
        return zzu(this.zza.zzH, -1);
    }

    @Override
    public final int hashCode() {
        return zzo.zzd(this);
    }

    public final String toString() {
        return zzo.zzf(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        zzp.zza(new zzo(this), parcel, i);
    }

    @Override
    public final String zza() {
        return zzj(this.zza.zzI, null);
    }

    @Override
    public final String zzb() {
        return zzj(this.zza.zzJ, null);
    }

    @Override
    public final String zzc() {
        return zzj(this.zza.zzK, null);
    }
}
