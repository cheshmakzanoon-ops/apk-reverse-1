package com.google.android.gms.measurement.internal;

import com.google.android.gms.internal.measurement.zzob;

final class zzab extends zzac {
    private com.google.android.gms.internal.measurement.zzew.zze zzg;
    private final zzt zzh;

    @Override
    final int zza() {
        return this.zzg.zza();
    }

    @Override
    final boolean zzb() {
        return false;
    }

    @Override
    final boolean zzc() {
        return true;
    }

    zzab(zzt zztVar, String str, int i, com.google.android.gms.internal.measurement.zzew.zze zzeVar) {
        super(str, i);
        this.zzh = zztVar;
        this.zzg = zzeVar;
    }

    final boolean zza(Long l, Long l2, com.google.android.gms.internal.measurement.zzfi.zzn zznVar, boolean z) {
        Object[] objArr = zzob.zza() && this.zzh.zze().zzf(this.zza, zzbi.zzbe);
        boolean zZzf = this.zzg.zzf();
        boolean zZzg = this.zzg.zzg();
        boolean zZzh = this.zzg.zzh();
        Object[] objArr2 = zZzf || zZzg || zZzh;
        Boolean boolZza = null;
        boolZza = null;
        boolZza = null;
        boolZza = null;
        boolZza = null;
        if (z && objArr2 == false) {
            this.zzh.zzj().zzp().zza("Property filter already evaluated true and it is not associated with an enhanced audience. audience ID, filter ID", Integer.valueOf(this.zzb), this.zzg.zzi() ? Integer.valueOf(this.zzg.zza()) : null);
            return true;
        }
        com.google.android.gms.internal.measurement.zzew.zzc zzcVarZzb = this.zzg.zzb();
        boolean zZzf2 = zzcVarZzb.zzf();
        if (zznVar.zzk()) {
            if (!zzcVarZzb.zzh()) {
                this.zzh.zzj().zzu().zza("No number filter for long property. property", this.zzh.zzi().zzc(zznVar.zzg()));
            } else {
                boolZza = zza(zza(zznVar.zzc(), zzcVarZzb.zzc()), zZzf2);
            }
        } else if (zznVar.zzi()) {
            if (!zzcVarZzb.zzh()) {
                this.zzh.zzj().zzu().zza("No number filter for double property. property", this.zzh.zzi().zzc(zznVar.zzg()));
            } else {
                boolZza = zza(zza(zznVar.zza(), zzcVarZzb.zzc()), zZzf2);
            }
        } else if (zznVar.zzm()) {
            if (!zzcVarZzb.zzj()) {
                if (!zzcVarZzb.zzh()) {
                    this.zzh.zzj().zzu().zza("No string or number filter defined. property", this.zzh.zzi().zzc(zznVar.zzg()));
                } else if (zzmz.zzb(zznVar.zzh())) {
                    boolZza = zza(zza(zznVar.zzh(), zzcVarZzb.zzc()), zZzf2);
                } else {
                    this.zzh.zzj().zzu().zza("Invalid user property value for Numeric number filter. property, value", this.zzh.zzi().zzc(zznVar.zzg()), zznVar.zzh());
                }
            } else {
                boolZza = zza(zza(zznVar.zzh(), zzcVarZzb.zzd(), this.zzh.zzj()), zZzf2);
            }
        } else {
            this.zzh.zzj().zzu().zza("User property has no value, property", this.zzh.zzi().zzc(zznVar.zzg()));
        }
        this.zzh.zzj().zzp().zza("Property filter result", boolZza == null ? "null" : boolZza);
        if (boolZza == null) {
            return false;
        }
        this.zzc = true;
        if (zZzh && !boolZza.booleanValue()) {
            return true;
        }
        if (!z || this.zzg.zzf()) {
            this.zzd = boolZza;
        }
        if (boolZza.booleanValue() && objArr2 != false && zznVar.zzl()) {
            long jZzd = zznVar.zzd();
            if (l != null) {
                jZzd = l.longValue();
            }
            if (objArr != false && this.zzg.zzf() && !this.zzg.zzg() && l2 != null) {
                jZzd = l2.longValue();
            }
            if (this.zzg.zzg()) {
                this.zzf = Long.valueOf(jZzd);
            } else {
                this.zze = Long.valueOf(jZzd);
            }
        }
        return true;
    }
}
