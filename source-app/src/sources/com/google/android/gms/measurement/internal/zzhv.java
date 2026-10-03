package com.google.android.gms.measurement.internal;

import com.google.android.gms.common.internal.Preconditions;
import com.google.android.gms.internal.measurement.zznp;

final class zzhv implements Runnable {
    private final zzo zza;
    private final zzhj zzb;

    zzhv(zzhj zzhjVar, zzo zzoVar) {
        this.zzb = zzhjVar;
        this.zza = zzoVar;
    }

    @Override
    public final void run() {
        this.zzb.zza.zzr();
        zzmp zzmpVar = this.zzb.zza;
        zzo zzoVar = this.zza;
        zzmpVar.zzl().zzt();
        zzmpVar.zzs();
        Preconditions.checkNotEmpty(zzoVar.zza);
        zzih zzihVarZza = zzih.zza(zzoVar.zzt, (zznp.zza() && zzmpVar.zze().zza(zzbi.zzcm)) ? zzoVar.zzy : 100);
        zzih zzihVarZzb = zzmpVar.zzb(zzoVar.zza);
        zzmpVar.zzj().zzp().zza("Setting consent, package, consent", zzoVar.zza, zzihVarZza);
        zzmpVar.zza(zzoVar.zza, zzihVarZza);
        if (zzihVarZza.zzc(zzihVarZzb)) {
            zzmpVar.zzd(zzoVar);
        }
        if (zznp.zza() && zzmpVar.zze().zza(zzbi.zzcm)) {
            zzay zzayVarZza = zzay.zza(zzoVar.zzz);
            if (zzay.zza.equals(zzayVarZza)) {
                return;
            }
            zzmpVar.zzj().zzp().zza("Setting DMA consent. package, consent", zzoVar.zza, zzayVarZza);
            zzmpVar.zza(zzoVar.zza, zzayVarZza);
        }
    }
}
