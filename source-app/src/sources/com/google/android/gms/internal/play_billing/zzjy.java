package com.google.android.gms.internal.play_billing;

public final class zzjy extends zzfu implements zzhc {
    private static final zzjy zzb;
    private int zzd;
    private int zze;

    static {
        zzjy zzjyVar = new zzjy();
        zzb = zzjyVar;
        zzfu.zzB(zzjy.class, zzjyVar);
    }

    private zzjy() {
    }

    public static zzjv zza() {
        return (zzjv) zzb.zzp();
    }

    static void zzc(zzjy zzjyVar, int i) {
        zzjyVar.zze = i - 1;
        zzjyVar.zzd |= 1;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0001\u0000\u0001\u0001\u0001\u0001\u0000\u0000\u0000\u0001᠌\u0000", new Object[]{"zzd", "zze", zzjw.zza});
        }
        if (i2 == 3) {
            return new zzjy();
        }
        zzjx zzjxVar = null;
        if (i2 == 4) {
            return new zzjv(zzjxVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
