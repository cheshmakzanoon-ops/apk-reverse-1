package com.google.android.gms.internal.play_billing;

import com.ishumei.smantifraud.l111l111lIlll;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

public final class zzbl {
    private final zzbo zza;
    private boolean zzb;
    private long zzc;
    private long zzd;

    zzbl() {
        this.zza = zzbo.zzb();
    }

    public static zzbl zzb(zzbo zzboVar) {
        zzbl zzblVar = new zzbl(zzboVar);
        zzblVar.zze();
        return zzblVar;
    }

    public static zzbl zzc(zzbo zzboVar) {
        return new zzbl(zzboVar);
    }

    private final long zzh() {
        return this.zzb ? (this.zza.zza() - this.zzd) + this.zzc : this.zzc;
    }

    public final String toString() {
        TimeUnit timeUnit;
        String str;
        long jZzh = zzh();
        if (TimeUnit.DAYS.convert(jZzh, TimeUnit.NANOSECONDS) > 0) {
            timeUnit = TimeUnit.DAYS;
        } else if (TimeUnit.HOURS.convert(jZzh, TimeUnit.NANOSECONDS) > 0) {
            timeUnit = TimeUnit.HOURS;
        } else if (TimeUnit.MINUTES.convert(jZzh, TimeUnit.NANOSECONDS) > 0) {
            timeUnit = TimeUnit.MINUTES;
        } else if (TimeUnit.SECONDS.convert(jZzh, TimeUnit.NANOSECONDS) > 0) {
            timeUnit = TimeUnit.SECONDS;
        } else if (TimeUnit.MILLISECONDS.convert(jZzh, TimeUnit.NANOSECONDS) > 0) {
            timeUnit = TimeUnit.MILLISECONDS;
        } else {
            timeUnit = TimeUnit.MICROSECONDS.convert(jZzh, TimeUnit.NANOSECONDS) > 0 ? TimeUnit.MICROSECONDS : TimeUnit.NANOSECONDS;
        }
        String str2 = String.format(Locale.ROOT, "%.4g", Double.valueOf(jZzh / TimeUnit.NANOSECONDS.convert(1L, timeUnit)));
        switch (zzbk.zza[timeUnit.ordinal()]) {
            case 1:
                str = "ns";
                break;
            case 2:
                str = "μs";
                break;
            case 3:
                str = "ms";
                break;
            case 4:
                str = l111l111lIlll.l11l111l1Il;
                break;
            case 5:
                str = "min";
                break;
            case 6:
                str = "h";
                break;
            case 7:
                str = "d";
                break;
            default:
                throw new AssertionError();
        }
        return str2 + " " + str;
    }

    public final long zza(TimeUnit timeUnit) {
        return timeUnit.convert(zzh(), TimeUnit.NANOSECONDS);
    }

    public final zzbl zzd() {
        this.zzc = 0L;
        this.zzb = false;
        return this;
    }

    public final zzbl zze() {
        zzbj.zze(!this.zzb, "This stopwatch is already running.");
        this.zzb = true;
        this.zzd = this.zza.zza();
        return this;
    }

    public final zzbl zzf() {
        long jZza = this.zza.zza();
        zzbj.zze(this.zzb, "This stopwatch is already stopped.");
        this.zzb = false;
        this.zzc += jZza - this.zzd;
        return this;
    }

    public final boolean zzg() {
        return this.zzb;
    }

    zzbl(zzbo zzboVar) {
        zzbj.zzc(zzboVar, "ticker");
        this.zza = zzboVar;
    }
}
