package com.google.android.gms.internal.play_billing;

public final class zzku extends zzfu implements zzhc {
    private static final zzku zzb;
    private int zzd;
    private int zze;
    private boolean zzf;
    private long zzg;
    private boolean zzh;
    private int zzi;
    private int zzj;

    static {
        zzku zzkuVar = new zzku();
        zzb = zzkuVar;
        zzfu.zzB(zzku.class, zzkuVar);
    }

    private zzku() {
    }

    public static zzks zza() {
        return (zzks) zzb.zzp();
    }

    static void zzc(zzku zzkuVar, boolean z) {
        zzkuVar.zzd |= 8;
        zzkuVar.zzh = z;
    }

    static void zze(zzku zzkuVar, int i) {
        zzkuVar.zzd |= 16;
        zzkuVar.zzi = i;
    }

    static void zzf(zzku zzkuVar, long j) {
        zzkuVar.zzd |= 4;
        zzkuVar.zzg = j;
    }

    static void zzg(zzku zzkuVar, int i) {
        zzkuVar.zzd |= 32;
        zzkuVar.zzj = 0;
    }

    static void zzh(zzku zzkuVar, boolean z) {
        zzkuVar.zzd |= 2;
        zzkuVar.zzf = true;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0006\u0000\u0001\u0001\u0006\u0006\u0000\u0000\u0000\u0001င\u0000\u0002ဇ\u0001\u0003ဂ\u0002\u0004ဇ\u0003\u0005င\u0004\u0006င\u0005", new Object[]{"zzd", "zze", "zzf", "zzg", "zzh", "zzi", "zzj"});
        }
        if (i2 == 3) {
            return new zzku();
        }
        zzkt zzktVar = null;
        if (i2 == 4) {
            return new zzks(zzktVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
