package com.google.android.gms.measurement.internal;

import android.content.SharedPreferences;
import com.google.android.gms.common.internal.Preconditions;

public final class zzgg {
    private final String zza;
    private final boolean zzb;
    private boolean zzc;
    private boolean zzd;
    private final zzgd zze;

    public zzgg(zzgd zzgdVar, String str, boolean z) {
        this.zze = zzgdVar;
        Preconditions.checkNotEmpty(str);
        this.zza = str;
        this.zzb = z;
    }

    public final void zza(boolean z) {
        SharedPreferences.Editor editorEdit = this.zze.zzc().edit();
        editorEdit.putBoolean(this.zza, z);
        editorEdit.apply();
        this.zzd = z;
    }

    public final boolean zza() {
        if (!this.zzc) {
            this.zzc = true;
            this.zzd = this.zze.zzc().getBoolean(this.zza, this.zzb);
        }
        return this.zzd;
    }
}
