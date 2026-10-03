package com.google.android.gms.internal.play_billing;

import java.util.Map;

public final class zzhx extends zzfu implements zzhc {
    private static final zzhx zzb;
    private zzgv zzd = zzgv.zza();

    static {
        zzhx zzhxVar = new zzhx();
        zzb = zzhxVar;
        zzfu.zzB(zzhx.class, zzhxVar);
    }

    private zzhx() {
    }

    public static zzhu zza() {
        return (zzhu) zzb.zzp();
    }

    static Map zzc(zzhx zzhxVar) {
        if (!zzhxVar.zzd.zze()) {
            zzhxVar.zzd = zzhxVar.zzd.zzb();
        }
        return zzhxVar.zzd;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return new zzhk(zzb, "\u0000\u0001\u0000\u0000\u0001\u0001\u0001\u0001\u0000\u0000\u00012", new Object[]{"zzd", zzhv.zza});
        }
        if (i2 == 3) {
            return new zzhx();
        }
        zzhw zzhwVar = null;
        if (i2 == 4) {
            return new zzhu(zzhwVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
