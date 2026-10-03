package com.google.android.gms.measurement.internal;

import com.google.android.gms.common.internal.Preconditions;
import java.util.concurrent.Callable;

final class zzmt implements Callable<String> {
    private final zzo zza;
    private final zzmp zzb;

    @Override
    public final String call() throws Exception {
        if (!this.zzb.zzb((String) Preconditions.checkNotNull(this.zza.zza)).zzh() || !zzih.zza(this.zza.zzt).zzh()) {
            this.zzb.zzj().zzp().zza("Analytics storage consent denied. Returning null app instance id");
            return null;
        }
        zzh zzhVarZza = this.zzb.zza(this.zza);
        if (zzhVarZza != null) {
            return zzhVarZza.zzy();
        }
        this.zzb.zzj().zzu().zza("App info was null when attempting to get app instance id");
        return null;
    }

    zzmt(zzmp zzmpVar, zzo zzoVar) {
        this.zzb = zzmpVar;
        this.zza = zzoVar;
    }
}
