package com.google.android.gms.internal.play_billing;

public final class zzeb extends zzfu implements zzhc {
    private static final zzeb zzb;
    private int zzd;
    private String zze = "";

    static {
        zzeb zzebVar = new zzeb();
        zzb = zzebVar;
        zzfu.zzB(zzeb.class, zzebVar);
    }

    private zzeb() {
    }

    public static zzea zza() {
        return (zzea) zzb.zzp();
    }

    static void zzc(zzeb zzebVar, String str) {
        zzebVar.zzd |= 1;
        zzebVar.zze = str;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0001\u0000\u0001\u0001\u0001\u0001\u0000\u0000\u0000\u0001ဈ\u0000", new Object[]{"zzd", "zze"});
        }
        if (i2 == 3) {
            return new zzeb();
        }
        zzec zzecVar = null;
        if (i2 == 4) {
            return new zzea(zzecVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
