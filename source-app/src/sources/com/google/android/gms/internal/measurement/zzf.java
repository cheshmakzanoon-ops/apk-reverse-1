package com.google.android.gms.internal.measurement;

import java.util.concurrent.Callable;

public final class zzf {
    final zzh zza;
    final zzh zzb;
    private final zzbb zzc;
    private final zzl zzd;

    public final zzaq zza(zzh zzhVar, zzfp.zzd... zzdVarArr) {
        zzaq zzaqVarZza = zzaq.zzc;
        for (zzfp.zzd zzdVar : zzdVarArr) {
            zzaqVarZza = zzj.zza(zzdVar);
            zzg.zza(this.zzb);
            if ((zzaqVarZza instanceof zzat) || (zzaqVarZza instanceof zzar)) {
                zzaqVarZza = this.zzc.zza(zzhVar, zzaqVarZza);
            }
        }
        return zzaqVarZza;
    }

    public zzf() {
        zzbb zzbbVar = new zzbb();
        this.zzc = zzbbVar;
        zzh zzhVar = new zzh(null, zzbbVar);
        this.zzb = zzhVar;
        this.zza = zzhVar.zza();
        zzl zzlVar = new zzl();
        this.zzd = zzlVar;
        zzhVar.zzc("require", new zzz(zzlVar));
        zzlVar.zza("internal.platform", new Callable() {
            @Override
            public final Object call() {
                return new zzy();
            }
        });
        zzhVar.zzc("runtime.counter", new zzai(Double.valueOf(0.0d)));
    }

    public final void zza(String str, Callable<? extends zzal> callable) {
        this.zzd.zza(str, callable);
    }
}
