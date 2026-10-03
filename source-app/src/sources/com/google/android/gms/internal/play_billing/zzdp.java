package com.google.android.gms.internal.play_billing;

public final class zzdp extends zzfu implements zzhc {
    private static final zzdp zzb;
    private int zzd;
    private String zze = "";

    static {
        zzdp zzdpVar = new zzdp();
        zzb = zzdpVar;
        zzfu.zzB(zzdp.class, zzdpVar);
    }

    private zzdp() {
    }

    public static zzdp zzb() {
        return zzb;
    }

    public final String zzc() {
        return this.zze;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0001\u0000\u0001\u0002\u0002\u0001\u0000\u0000\u0000\u0002ဈ\u0000", new Object[]{"zzd", "zze"});
        }
        if (i2 == 3) {
            return new zzdp();
        }
        zzdo zzdoVar = null;
        if (i2 == 4) {
            return new zzdn(zzdoVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
