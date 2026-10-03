package com.google.android.gms.games.internal.player;

import android.net.Uri;
import android.os.Parcel;
import com.google.android.gms.common.data.DataBufferRef;
import com.google.android.gms.common.data.DataHolder;

public final class zzc extends DataBufferRef implements zza {
    private final zzd zza;

    public zzc(DataHolder dataHolder, int i, zzd zzdVar) {
        super(dataHolder, i);
        this.zza = zzdVar;
    }

    @Override
    public final int describeContents() {
        return 0;
    }

    @Override
    public final boolean equals(Object obj) {
        return MostRecentGameInfoEntity.zzh(this, obj);
    }

    @Override
    public final Object freeze() {
        return new MostRecentGameInfoEntity(this);
    }

    @Override
    public final int hashCode() {
        return MostRecentGameInfoEntity.zzg(this);
    }

    public final String toString() {
        return MostRecentGameInfoEntity.zzi(this);
    }

    @Override
    public final void writeToParcel(Parcel parcel, int i) {
        zzb.zza(new MostRecentGameInfoEntity(this), parcel, i);
    }

    @Override
    public final String zza() {
        return getString(this.zza.zzt);
    }

    @Override
    public final String zzb() {
        return getString(this.zza.zzu);
    }

    @Override
    public final long zzc() {
        return getLong(this.zza.zzv);
    }

    @Override
    public final Uri zzd() {
        return parseUri(this.zza.zzw);
    }

    @Override
    public final Uri zze() {
        return parseUri(this.zza.zzx);
    }

    @Override
    public final Uri zzf() {
        return parseUri(this.zza.zzy);
    }
}
