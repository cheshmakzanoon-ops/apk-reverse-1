package com.google.android.gms.measurement.internal;

import android.content.SharedPreferences;
import com.google.android.gms.common.internal.Preconditions;

public final class zzgi {
    private final String zza;
    private final long zzb;
    private boolean zzc;
    private long zzd;
    private final zzgd zze;

    public final long zza() {
        if (!this.zzc) {
            this.zzc = true;
            this.zzd = this.zze.zzc().getLong(this.zza, this.zzb);
        }
        return this.zzd;
    }

    public zzgi(zzgd zzgdVar, String str, long j) {
        this.zze = zzgdVar;
        Preconditions.checkNotEmpty(str);
        this.zza = str;
        this.zzb = j;
    }

    public final void zza(long j) {
        SharedPreferences.Editor editorEdit = this.zze.zzc().edit();
        editorEdit.putLong(this.zza, j);
        editorEdit.apply();
        this.zzd = j;
    }
}
