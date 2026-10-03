package com.google.android.gms.measurement.internal;

import android.content.SharedPreferences;
import com.google.android.gms.common.internal.Preconditions;

public final class zzgj {
    private final String zza;
    private final String zzb;
    private boolean zzc;
    private String zzd;
    private final zzgd zze;

    public final String zza() {
        if (!this.zzc) {
            this.zzc = true;
            this.zzd = this.zze.zzc().getString(this.zza, null);
        }
        return this.zzd;
    }

    public zzgj(zzgd zzgdVar, String str, String str2) {
        this.zze = zzgdVar;
        Preconditions.checkNotEmpty(str);
        this.zza = str;
        this.zzb = null;
    }

    public final void zza(String str) {
        SharedPreferences.Editor editorEdit = this.zze.zzc().edit();
        editorEdit.putString(this.zza, str);
        editorEdit.apply();
        this.zzd = str;
    }
}
