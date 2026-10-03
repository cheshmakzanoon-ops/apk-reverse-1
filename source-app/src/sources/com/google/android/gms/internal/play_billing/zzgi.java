package com.google.android.gms.internal.play_billing;

public class zzgi {
    protected volatile zzhb zza;
    private volatile zzev zzb;
    private volatile boolean zzc;

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof zzgi)) {
            return false;
        }
        zzgi zzgiVar = (zzgi) obj;
        zzhb zzhbVar = this.zza;
        zzhb zzhbVar2 = zzgiVar.zza;
        if (zzhbVar == null && zzhbVar2 == null) {
            return zzb().equals(zzgiVar.zzb());
        }
        if (zzhbVar != null && zzhbVar2 != null) {
            return zzhbVar.equals(zzhbVar2);
        }
        if (zzhbVar != null) {
            zzgiVar.zzd(zzhbVar.zzl());
            return zzhbVar.equals(zzgiVar.zza);
        }
        zzd(zzhbVar2.zzl());
        return this.zza.equals(zzhbVar2);
    }

    public int hashCode() {
        return 1;
    }

    public final int zza() {
        if (this.zzb != null) {
            return this.zzb.zze();
        }
        if (this.zza != null) {
            return this.zza.zzn();
        }
        return 0;
    }

    public final zzev zzb() {
        if (this.zzb != null) {
            return this.zzb;
        }
        synchronized (this) {
            if (this.zzb != null) {
                return this.zzb;
            }
            if (this.zza == null) {
                this.zzb = zzev.zza;
            } else {
                this.zzb = this.zza.zzj();
            }
            return this.zzb;
        }
    }

    public final zzhb zzc(zzhb zzhbVar) {
        zzhb zzhbVar2 = this.zza;
        this.zzb = null;
        this.zza = zzhbVar;
        return zzhbVar2;
    }

    protected final void zzd(zzhb zzhbVar) {
        if (this.zza != null) {
            return;
        }
        synchronized (this) {
            if (this.zza != null) {
                return;
            }
            try {
                this.zza = zzhbVar;
                this.zzb = zzev.zza;
            } catch (zzgc unused) {
                this.zzc = true;
                this.zza = zzhbVar;
                this.zzb = zzev.zza;
            }
        }
    }
}
