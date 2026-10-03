package com.google.android.gms.measurement.internal;

import com.ishumei.smantifraud.l1l11llIl;

final class zzmc {
    final zzlx zza;
    private zzmb zzb;

    zzmc(zzlx zzlxVar) {
        this.zza = zzlxVar;
    }

    final void zza(long j) {
        this.zzb = new zzmb(this, this.zza.zzb().currentTimeMillis(), j);
        this.zza.zzc.postDelayed(this.zzb, l1l11llIl.l111l11111I1l);
    }

    final void zza() {
        this.zza.zzt();
        if (this.zzb != null) {
            this.zza.zzc.removeCallbacks(this.zzb);
        }
        this.zza.zzk().zzn.zza(false);
        this.zza.zza(false);
    }
}
