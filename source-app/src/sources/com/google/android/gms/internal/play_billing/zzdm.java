package com.google.android.gms.internal.play_billing;

public final class zzdm extends zzfu implements zzhc {
    private static final zzdm zzb;
    private int zzd = 0;
    private Object zze;

    static {
        zzdm zzdmVar = new zzdm();
        zzb = zzdmVar;
        zzfu.zzB(zzdm.class, zzdmVar);
    }

    private zzdm() {
    }

    public static zzdm zzb(byte[] bArr) throws zzgc {
        return (zzdm) zzfu.zzt(zzb, bArr);
    }

    public final zzdp zzc() {
        return this.zzd == 2 ? (zzdp) this.zze : zzdp.zzb();
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0002\u0001\u0000\u0001\u0002\u0002\u0000\u0000\u0000\u0001;\u0000\u0002<\u0000", new Object[]{"zze", "zzd", zzdp.class});
        }
        if (i2 == 3) {
            return new zzdm();
        }
        zzdl zzdlVar = null;
        if (i2 == 4) {
            return new zzdk(zzdlVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
