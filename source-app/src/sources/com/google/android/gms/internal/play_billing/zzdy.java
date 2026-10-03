package com.google.android.gms.internal.play_billing;

public final class zzdy extends zzfu implements zzhc {
    private static final zzdy zzb;
    private int zzd;
    private int zze;
    private int zzf;
    private String zzg = "";
    private String zzh = "";
    private String zzi = "";
    private String zzj = "";

    static {
        zzdy zzdyVar = new zzdy();
        zzb = zzdyVar;
        zzfu.zzB(zzdy.class, zzdyVar);
    }

    private zzdy() {
    }

    public static zzdx zza() {
        return (zzdx) zzb.zzp();
    }

    static void zzc(zzdy zzdyVar, String str) {
        zzdyVar.zzd |= 4;
        zzdyVar.zzg = str;
    }

    static void zze(zzdy zzdyVar, String str) {
        str.getClass();
        zzdyVar.zzd |= 16;
        zzdyVar.zzi = str;
    }

    static void zzf(zzdy zzdyVar, String str) {
        str.getClass();
        zzdyVar.zzd |= 32;
        zzdyVar.zzj = str;
    }

    static void zzg(zzdy zzdyVar, String str) {
        str.getClass();
        zzdyVar.zzd |= 8;
        zzdyVar.zzh = str;
    }

    static void zzh(zzdy zzdyVar, int i) {
        zzdyVar.zzd |= 1;
        zzdyVar.zze = 24;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0006\u0000\u0001\u0001\u0006\u0006\u0000\u0000\u0000\u0001င\u0000\u0002င\u0001\u0003ဈ\u0002\u0004ဈ\u0003\u0005ဈ\u0004\u0006ဈ\u0005", new Object[]{"zzd", "zze", "zzf", "zzg", "zzh", "zzi", "zzj"});
        }
        if (i2 == 3) {
            return new zzdy();
        }
        zzdz zzdzVar = null;
        if (i2 == 4) {
            return new zzdx(zzdzVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
