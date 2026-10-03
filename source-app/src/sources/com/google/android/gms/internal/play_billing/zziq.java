package com.google.android.gms.internal.play_billing;

public final class zziq extends zzfu implements zzhc {
    private static final zziq zzb;
    private int zzd = 0;
    private Object zze;

    static {
        zziq zziqVar = new zziq();
        zzb = zziqVar;
        zzfu.zzB(zziq.class, zziqVar);
    }

    private zziq() {
    }

    public static zzio zza() {
        return (zzio) zzb.zzp();
    }

    public static zziq zzc() {
        return zzb;
    }

    static void zze(zziq zziqVar, String str) {
        str.getClass();
        zziqVar.zzd = 3;
        zziqVar.zze = str;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return new zzhk(zzb, "\u0000\u0006\u0001\u0000\u0001\u0006\u0006\u0000\u0000\u0000\u0001?\u0000\u00023\u0000\u0003Ȼ\u0000\u0004:\u0000\u0005<\u0000\u0006<\u0000", new Object[]{"zze", "zzd", zzhx.class, zzgo.class});
        }
        if (i2 == 3) {
            return new zziq();
        }
        zzip zzipVar = null;
        if (i2 == 4) {
            return new zzio(zzipVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
