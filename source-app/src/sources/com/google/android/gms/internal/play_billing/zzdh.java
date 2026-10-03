package com.google.android.gms.internal.play_billing;

import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.TimeUnit;

final class zzdh extends zzct {
    private zzdc zzd;
    private ScheduledFuture zze;

    private zzdh(zzdc zzdcVar) {
        this.zzd = zzdcVar;
    }

    static zzdc zzs(zzdc zzdcVar, long j, TimeUnit timeUnit, ScheduledExecutorService scheduledExecutorService) {
        zzdh zzdhVar = new zzdh(zzdcVar);
        zzde zzdeVar = new zzde(zzdhVar);
        zzdhVar.zze = scheduledExecutorService.schedule(zzdeVar, 28500L, timeUnit);
        zzdcVar.zzb(zzdeVar, zzcs.INSTANCE);
        return zzdhVar;
    }

    @Override
    protected final String zzd() {
        zzdc zzdcVar = this.zzd;
        ScheduledFuture scheduledFuture = this.zze;
        if (zzdcVar == null) {
            return null;
        }
        String str = "inputFuture=[" + zzdcVar.toString() + "]";
        if (scheduledFuture == null) {
            return str;
        }
        long delay = scheduledFuture.getDelay(TimeUnit.MILLISECONDS);
        if (delay <= 0) {
            return str;
        }
        return str + ", remaining delay=[" + delay + " ms]";
    }

    @Override
    protected final void zzg() {
        zzdc zzdcVar = this.zzd;
        if ((this.valueField instanceof zzcm.zza) & (zzdcVar != null)) {
            Object obj = this.valueField;
            zzdcVar.cancel((obj instanceof zzcm.zza) && ((zzcm.zza) obj).zzc);
        }
        ScheduledFuture scheduledFuture = this.zze;
        if (scheduledFuture != null) {
            scheduledFuture.cancel(false);
        }
        this.zzd = null;
        this.zze = null;
    }
}
