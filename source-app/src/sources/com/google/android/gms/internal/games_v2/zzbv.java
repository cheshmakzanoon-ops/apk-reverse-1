package com.google.android.gms.internal.games_v2;

import android.app.PendingIntent;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.common.internal.Objects;
import com.google.android.gms.common.internal.Preconditions;

final class zzbv {
    private final String zza;
    private final Status zzb;

    private zzbv(Status status, String str) {
        this.zzb = status;
        this.zza = str;
    }

    public static zzbv zza(String str) {
        return new zzbv(Status.RESULT_SUCCESS, str);
    }

    public static zzbv zzb(Status status) {
        Preconditions.checkArgument(!status.isSuccess());
        return new zzbv(status, null);
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof zzbv)) {
            return false;
        }
        zzbv zzbvVar = (zzbv) obj;
        return Objects.equal(this.zzb, zzbvVar.zzb) && Objects.equal(this.zza, zzbvVar.zza);
    }

    public final int hashCode() {
        return Objects.hashCode(this.zzb, this.zza);
    }

    public final String toString() {
        return Objects.toStringHelper(this).add("status", this.zzb).add("gameRunToken", this.zza).toString();
    }

    public final boolean zzc() {
        return this.zzb.isSuccess();
    }

    public final String zzd() {
        return this.zza;
    }

    public final PendingIntent zze() {
        return this.zzb.getResolution();
    }
}
