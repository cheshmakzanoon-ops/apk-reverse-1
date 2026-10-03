package com.google.android.gms.measurement.internal;

import android.os.Bundle;
import com.google.android.gms.internal.measurement.zzoh;

final class zzmd {
    protected long zza;
    final zzlx zzb;
    private long zzc;
    private final zzaw zzd;

    final long zza(long j) {
        long j2 = j - this.zza;
        this.zza = j;
        return j2;
    }

    static void zza(zzmd zzmdVar) {
        zzmdVar.zzb.zzt();
        zzmdVar.zza(false, false, zzmdVar.zzb.zzb().elapsedRealtime());
        zzmdVar.zzb.zzc().zza(zzmdVar.zzb.zzb().elapsedRealtime());
    }

    public zzmd(zzlx zzlxVar) {
        this.zzb = zzlxVar;
        this.zzd = new zzmg(this, zzlxVar.zzu);
        long jElapsedRealtime = zzlxVar.zzb().elapsedRealtime();
        this.zzc = jElapsedRealtime;
        this.zza = jElapsedRealtime;
    }

    final void zza() {
        this.zzd.zza();
        this.zzc = 0L;
        this.zza = 0L;
    }

    final void zzb(long j) {
        this.zzd.zza();
    }

    final void zzc(long j) {
        this.zzb.zzt();
        this.zzd.zza();
        this.zzc = j;
        this.zza = j;
    }

    public final boolean zza(boolean z, boolean z2, long j) {
        this.zzb.zzt();
        this.zzb.zzu();
        if (!zzoh.zza() || !this.zzb.zze().zza(zzbi.zzbn) || this.zzb.zzu.zzac()) {
            this.zzb.zzk().zzk.zza(this.zzb.zzb().currentTimeMillis());
        }
        long jZza = j - this.zzc;
        if (!z && jZza < 1000) {
            this.zzb.zzj().zzp().zza("Screen exposed for less than 1000 ms. Event not sent. time", Long.valueOf(jZza));
            return false;
        }
        if (!z2) {
            jZza = zza(j);
        }
        this.zzb.zzj().zzp().zza("Recording user engagement, ms", Long.valueOf(jZza));
        Bundle bundle = new Bundle();
        bundle.putLong("_et", jZza);
        zznd.zza(this.zzb.zzn().zza(!this.zzb.zze().zzu()), bundle, true);
        if (!z2) {
            this.zzb.zzm().zzc("auto", "_e", bundle);
        }
        this.zzc = j;
        this.zzd.zza();
        this.zzd.zza(3600000L);
        return true;
    }
}
