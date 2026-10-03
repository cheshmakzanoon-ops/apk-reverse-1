package com.google.android.gms.measurement.internal;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import com.google.android.gms.common.util.Clock;
import org.checkerframework.dataflow.qual.Pure;

public final class zzlx extends zze {
    protected final zzmf zza;
    protected final zzmd zzb;
    private Handler zzc;
    private boolean zzd;
    private final zzmc zze;

    @Override
    @Pure
    public final Context zza() {
        return super.zza();
    }

    @Override
    protected final boolean zzz() {
        return false;
    }

    @Override
    @Pure
    public final Clock zzb() {
        return super.zzb();
    }

    @Override
    public final zzb zzc() {
        return super.zzc();
    }

    @Override
    @Pure
    public final zzae zzd() {
        return super.zzd();
    }

    @Override
    @Pure
    public final zzaf zze() {
        return super.zze();
    }

    @Override
    @Pure
    public final zzba zzf() {
        return super.zzf();
    }

    @Override
    public final zzfl zzg() {
        return super.zzg();
    }

    @Override
    public final zzfo zzh() {
        return super.zzh();
    }

    @Override
    @Pure
    public final zzfq zzi() {
        return super.zzi();
    }

    @Override
    @Pure
    public final zzfr zzj() {
        return super.zzj();
    }

    @Override
    @Pure
    public final zzgd zzk() {
        return super.zzk();
    }

    @Override
    @Pure
    public final zzgy zzl() {
        return super.zzl();
    }

    @Override
    public final zziq zzm() {
        return super.zzm();
    }

    @Override
    public final zzkh zzn() {
        return super.zzn();
    }

    @Override
    public final zzkp zzo() {
        return super.zzo();
    }

    @Override
    public final zzlx zzp() {
        return super.zzp();
    }

    @Override
    @Pure
    public final zznd zzq() {
        return super.zzq();
    }

    static void zza(zzlx zzlxVar, long j) {
        zzlxVar.zzt();
        zzlxVar.zzab();
        zzlxVar.zzj().zzp().zza("Activity paused, time", Long.valueOf(j));
        zzlxVar.zze.zza(j);
        if (zzlxVar.zze().zzu()) {
            zzlxVar.zzb.zzb(j);
        }
    }

    static void zzb(zzlx zzlxVar, long j) {
        zzlxVar.zzt();
        zzlxVar.zzab();
        zzlxVar.zzj().zzp().zza("Activity resumed, time", Long.valueOf(j));
        if (zzlxVar.zze().zza(zzbi.zzcj)) {
            if (zzlxVar.zze().zzu() || zzlxVar.zzd) {
                zzlxVar.zzb.zzc(j);
            }
        } else if (zzlxVar.zze().zzu() || zzlxVar.zzk().zzn.zza()) {
            zzlxVar.zzb.zzc(j);
        }
        zzlxVar.zze.zza();
        zzmf zzmfVar = zzlxVar.zza;
        zzmfVar.zza.zzt();
        if (zzmfVar.zza.zzu.zzac()) {
            zzmfVar.zza(zzmfVar.zza.zzb().currentTimeMillis(), false);
        }
    }

    zzlx(zzhf zzhfVar) {
        super(zzhfVar);
        this.zzd = true;
        this.zza = new zzmf(this);
        this.zzb = new zzmd(this);
        this.zze = new zzmc(this);
    }

    @Override
    public final void zzr() {
        super.zzr();
    }

    @Override
    public final void zzs() {
        super.zzs();
    }

    @Override
    public final void zzt() {
        super.zzt();
    }

    public final void zzab() {
        zzt();
        if (this.zzc == null) {
            this.zzc = new com.google.android.gms.internal.measurement.zzcp(Looper.getMainLooper());
        }
    }

    final void zza(boolean z) {
        zzt();
        this.zzd = z;
    }

    final boolean zzaa() {
        zzt();
        return this.zzd;
    }

    public final boolean zza(boolean z, boolean z2, long j) {
        return this.zzb.zza(z, z2, j);
    }
}
