package com.google.android.gms.internal.play_billing;

public final class zzjo extends zzfu implements zzhc {
    private static final zzjo zzb;
    private int zzd;
    private int zzf;
    private zzjf zzi;
    private boolean zzj;
    private boolean zzk;
    private String zze = "";
    private zzfy zzg = zzu();
    private zzfz zzh = zzv();

    static {
        zzjo zzjoVar = new zzjo();
        zzb = zzjoVar;
        zzfu.zzB(zzjo.class, zzjoVar);
    }

    private zzjo() {
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0007\u0000\u0001\u0001\u0007\u0007\u0000\u0002\u0000\u0001ဈ\u0000\u0002᠌\u0001\u0003ࠬ\u0004\u001b\u0005ဉ\u0002\u0006ဇ\u0003\u0007ဇ\u0004", new Object[]{"zzd", "zze", "zzf", zzjm.zza, "zzg", zzjj.zza, "zzh", zzkk.class, "zzi", "zzj", "zzk"});
        }
        if (i2 == 3) {
            return new zzjo();
        }
        zzjn zzjnVar = null;
        if (i2 == 4) {
            return new zzjl(zzjnVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
