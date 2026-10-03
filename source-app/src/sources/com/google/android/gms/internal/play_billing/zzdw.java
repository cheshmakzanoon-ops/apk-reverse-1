package com.google.android.gms.internal.play_billing;

public final class zzdw extends zzfu implements zzhc {
    private static final zzdw zzb;
    private int zzd;
    private int zze;
    private String zzf = "";

    static {
        zzdw zzdwVar = new zzdw();
        zzb = zzdwVar;
        zzfu.zzB(zzdw.class, zzdwVar);
    }

    private zzdw() {
    }

    public static zzdw zzc(byte[] bArr) throws zzgc {
        return (zzdw) zzfu.zzt(zzb, bArr);
    }

    public final int zza() {
        return this.zze;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0002\u0000\u0001\u0001\u0002\u0002\u0000\u0000\u0000\u0001င\u0000\u0002ဈ\u0001", new Object[]{"zzd", "zze", "zzf"});
        }
        if (i2 == 3) {
            return new zzdw();
        }
        zzdz zzdzVar = null;
        if (i2 == 4) {
            return new zzdv(zzdzVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }

    public final String zze() {
        return this.zzf;
    }
}
