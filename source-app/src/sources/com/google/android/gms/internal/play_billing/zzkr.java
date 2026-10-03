package com.google.android.gms.internal.play_billing;

public final class zzkr extends zzfu implements zzhc {
    private static final zzkr zzb;
    private int zzd;
    private int zze;

    static {
        zzkr zzkrVar = new zzkr();
        zzb = zzkrVar;
        zzfu.zzB(zzkr.class, zzkrVar);
    }

    private zzkr() {
    }

    public static zzkr zzb() {
        return zzb;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0001\u0000\u0001\u0001\u0001\u0001\u0000\u0000\u0000\u0001᠌\u0000", new Object[]{"zzd", "zze", zzkp.zza});
        }
        if (i2 == 3) {
            return new zzkr();
        }
        zzkq zzkqVar = null;
        if (i2 == 4) {
            return new zzko(zzkqVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
