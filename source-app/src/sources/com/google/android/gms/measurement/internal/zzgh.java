package com.google.android.gms.measurement.internal;

import android.content.SharedPreferences;
import android.util.Pair;
import com.google.android.gms.common.internal.Preconditions;

public final class zzgh {
    private final String zza;
    private final String zzb;
    private final String zzc;
    private final long zzd;
    private final zzgd zze;

    private final long zzb() {
        return this.zze.zzc().getLong(this.zza, 0L);
    }

    public final Pair<String, Long> zza() {
        long jAbs;
        this.zze.zzt();
        this.zze.zzt();
        long jZzb = zzb();
        if (jZzb == 0) {
            zzc();
            jAbs = 0;
        } else {
            jAbs = Math.abs(jZzb - this.zze.zzb().currentTimeMillis());
        }
        long j = this.zzd;
        if (jAbs < j) {
            return null;
        }
        if (jAbs > (j << 1)) {
            zzc();
            return null;
        }
        String string = this.zze.zzc().getString(this.zzc, null);
        long j2 = this.zze.zzc().getLong(this.zzb, 0L);
        zzc();
        return (string == null || j2 <= 0) ? zzgd.zza : new Pair<>(string, Long.valueOf(j2));
    }

    private zzgh(zzgd zzgdVar, String str, long j) {
        this.zze = zzgdVar;
        Preconditions.checkNotEmpty(str);
        Preconditions.checkArgument(j > 0);
        this.zza = str + ":start";
        this.zzb = str + ":count";
        this.zzc = str + ":value";
        this.zzd = j;
    }

    private final void zzc() {
        this.zze.zzt();
        long jCurrentTimeMillis = this.zze.zzb().currentTimeMillis();
        SharedPreferences.Editor editorEdit = this.zze.zzc().edit();
        editorEdit.remove(this.zzb);
        editorEdit.remove(this.zzc);
        editorEdit.putLong(this.zza, jCurrentTimeMillis);
        editorEdit.apply();
    }

    public final void zza(String str, long j) {
        this.zze.zzt();
        if (zzb() == 0) {
            zzc();
        }
        if (str == null) {
            str = "";
        }
        long j2 = this.zze.zzc().getLong(this.zzb, 0L);
        if (j2 <= 0) {
            SharedPreferences.Editor editorEdit = this.zze.zzc().edit();
            editorEdit.putString(this.zzc, str);
            editorEdit.putLong(this.zzb, 1L);
            editorEdit.apply();
            return;
        }
        long j3 = j2 + 1;
        boolean z = (this.zze.zzq().zzv().nextLong() & Long.MAX_VALUE) < Long.MAX_VALUE / j3;
        SharedPreferences.Editor editorEdit2 = this.zze.zzc().edit();
        if (z) {
            editorEdit2.putString(this.zzc, str);
        }
        editorEdit2.putLong(this.zzb, j3);
        editorEdit2.apply();
    }
}
