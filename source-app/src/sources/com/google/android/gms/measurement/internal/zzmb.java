package com.google.android.gms.measurement.internal;

import android.os.Bundle;
import com.google.android.gms.internal.measurement.zzpm;

final class zzmb implements Runnable {
    long zza;
    long zzb;
    final zzmc zzc;

    zzmb(zzmc zzmcVar, long j, long j2) {
        this.zzc = zzmcVar;
        this.zza = j;
        this.zzb = j2;
    }

    @Override
    public final void run() {
        this.zzc.zza.zzl().zzb(new Runnable() {
            @Override
            public final void run() {
                zzmb zzmbVar = this.zza;
                zzmc zzmcVar = zzmbVar.zzc;
                long j = zzmbVar.zza;
                long j2 = zzmbVar.zzb;
                zzmcVar.zza.zzt();
                zzmcVar.zza.zzj().zzc().zza("Application going to the background");
                zzmcVar.zza.zzk().zzn.zza(true);
                zzmcVar.zza.zza(true);
                if (!zzmcVar.zza.zze().zzu()) {
                    zzmcVar.zza.zzb.zzb(j2);
                    zzmcVar.zza.zza(false, false, j2);
                }
                if (zzpm.zza() && zzmcVar.zza.zze().zza(zzbi.zzce)) {
                    zzmcVar.zza.zzj().zzn().zza("Application backgrounded at: timestamp_millis", Long.valueOf(j));
                } else {
                    zzmcVar.zza.zzm().zza("auto", "_ab", j, new Bundle());
                }
            }
        });
    }
}
