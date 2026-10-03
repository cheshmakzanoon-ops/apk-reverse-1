package com.google.android.gms.internal.play_billing;

public final class zzji extends zzfu implements zzhc {
    private static final zzji zzb;

    static {
        zzji zzjiVar = new zzji();
        zzb = zzjiVar;
        zzfu.zzB(zzji.class, zzjiVar);
    }

    private zzji() {
    }

    public static zzji zzb() {
        return zzb;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        zzjh zzjhVar = null;
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0000", null);
        }
        if (i2 == 3) {
            return new zzji();
        }
        if (i2 == 4) {
            return new zzjg(zzjhVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
