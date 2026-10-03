package com.google.android.gms.measurement.internal;

import java.util.List;

final class zzgu implements com.google.android.gms.internal.measurement.zzv {
    private final zzgp zza;

    zzgu(zzgp zzgpVar) {
        this.zza = zzgpVar;
    }

    @Override
    public final void zza(com.google.android.gms.internal.measurement.zzs zzsVar, String str, List<String> list, boolean z, boolean z2) {
        zzft zzftVarZzc;
        int i = zzgw.zza[zzsVar.ordinal()];
        if (i == 1) {
            zzftVarZzc = this.zza.zzj().zzc();
        } else if (i != 2) {
            if (i != 3) {
                zzftVarZzc = i != 4 ? this.zza.zzj().zzn() : this.zza.zzj().zzp();
            } else if (z) {
                zzftVarZzc = this.zza.zzj().zzw();
            } else {
                zzftVarZzc = !z2 ? this.zza.zzj().zzv() : this.zza.zzj().zzu();
            }
        } else if (z) {
            zzftVarZzc = this.zza.zzj().zzm();
        } else {
            zzftVarZzc = !z2 ? this.zza.zzj().zzh() : this.zza.zzj().zzg();
        }
        int size = list.size();
        if (size == 1) {
            zzftVarZzc.zza(str, list.get(0));
            return;
        }
        if (size == 2) {
            zzftVarZzc.zza(str, list.get(0), list.get(1));
        } else if (size != 3) {
            zzftVarZzc.zza(str);
        } else {
            zzftVarZzc.zza(str, list.get(0), list.get(1), list.get(2));
        }
    }
}
