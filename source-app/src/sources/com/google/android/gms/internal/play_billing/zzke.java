package com.google.android.gms.internal.play_billing;

public final class zzke extends zzfu implements zzhc {
    private static final zzke zzb;
    private int zzd;
    private zzfz zze = zzv();
    private String zzf = "";
    private boolean zzg;

    static {
        zzke zzkeVar = new zzke();
        zzb = zzkeVar;
        zzfu.zzB(zzke.class, zzkeVar);
    }

    private zzke() {
    }

    public static zzke zzb() {
        return zzb;
    }

    static void zzc(zzke zzkeVar, boolean z) {
        zzkeVar.zzd |= 2;
        zzkeVar.zzg = z;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0003\u0000\u0001\u0001\u0003\u0003\u0000\u0001\u0000\u0001\u001b\u0002ဈ\u0000\u0003ဇ\u0001", new Object[]{"zzd", "zze", zzkc.class, "zzf", "zzg"});
        }
        if (i2 == 3) {
            return new zzke();
        }
        zzkd zzkdVar = null;
        if (i2 == 4) {
            return new zzjz(zzkdVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
