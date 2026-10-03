package com.google.android.gms.measurement.internal;

final class zzfu implements Runnable {
    private final int zza;
    private final String zzb;
    private final Object zzc;
    private final Object zzd;
    private final Object zze;
    private final zzfr zzf;

    zzfu(zzfr zzfrVar, int i, String str, Object obj, Object obj2, Object obj3) {
        this.zzf = zzfrVar;
        this.zza = i;
        this.zzb = str;
        this.zzc = obj;
        this.zzd = obj2;
        this.zze = obj3;
    }

    @Override
    public final void run() {
        zzgd zzgdVarZzn = this.zzf.zzu.zzn();
        if (!zzgdVarZzn.zzae()) {
            this.zzf.zza(6, "Persisted config not initialized. Not logging error/warn");
            return;
        }
        if (this.zzf.zza == 0) {
            if (this.zzf.zze().zzx()) {
                this.zzf.zza = 'C';
            } else {
                this.zzf.zza = 'c';
            }
        }
        if (this.zzf.zzb < 0) {
            this.zzf.zzb = 82001L;
        }
        String strSubstring = "2" + "01VDIWEA?".charAt(this.zza) + this.zzf.zza + this.zzf.zzb + ":" + zzfr.zza(true, this.zzb, this.zzc, this.zzd, this.zze);
        if (strSubstring.length() > 1024) {
            strSubstring = this.zzb.substring(0, 1024);
        }
        if (zzgdVarZzn.zzb != null) {
            zzgdVarZzn.zzb.zza(strSubstring, 1L);
        }
    }
}
