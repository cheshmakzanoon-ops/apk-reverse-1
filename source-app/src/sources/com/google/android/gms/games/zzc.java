package com.google.android.gms.games;

import android.os.Parcel;
import com.google.android.gms.common.data.DataHolder;

public final class zzc extends zzg implements CurrentPlayerInfo {
    private final com.google.android.gms.games.internal.player.zzd zza;

    public zzc(DataHolder dataHolder, int i, com.google.android.gms.games.internal.player.zzd zzdVar) {
        super(dataHolder, i);
        this.zza = zzdVar;
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return zza.zzb(this, obj);
    }

    @Override
    public final CurrentPlayerInfo freeze() {
        return new zza(this);
    }

    @Override
    public final int getFriendsListVisibilityStatus() {
        return zzu(this.zza.zzL, 0);
    }

    @Override
    public final int hashCode() {
        return zza.zza(this);
    }

    public final String toString() {
        return zza.zzc(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        zzb.zza(new zza(this), parcel, i);
    }

    public final boolean zza() {
        String str = this.zza.zzL;
        return hasColumn(str) && !hasNull(str);
    }
}
