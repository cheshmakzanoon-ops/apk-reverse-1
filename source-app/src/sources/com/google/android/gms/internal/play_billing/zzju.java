package com.google.android.gms.internal.play_billing;

public final class zzju extends zzfu implements zzhc {
    private static final zzju zzb;
    private int zzd;
    private boolean zze;
    private boolean zzf;

    static {
        zzju zzjuVar = new zzju();
        zzb = zzjuVar;
        zzfu.zzB(zzju.class, zzjuVar);
    }

    private zzju() {
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0002\u0000\u0001\u0001\u0002\u0002\u0000\u0000\u0000\u0001ဇ\u0000\u0002ဇ\u0001", new Object[]{"zzd", "zze", "zzf"});
        }
        if (i2 == 3) {
            return new zzju();
        }
        zzjt zzjtVar = null;
        if (i2 == 4) {
            return new zzjs(zzjtVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
