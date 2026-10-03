package com.google.android.gms.internal.play_billing;

public final class zzjf extends zzfu implements zzhc {
    private static final zzjf zzb;
    private int zzd;
    private int zze;
    private int zzg;
    private int zzi;
    private int zzj;
    private String zzf = "";
    private String zzh = "";

    static {
        zzjf zzjfVar = new zzjf();
        zzb = zzjfVar;
        zzfu.zzB(zzjf.class, zzjfVar);
    }

    private zzjf() {
    }

    static void zzG(zzjf zzjfVar, int i) {
        zzjfVar.zzd |= 1;
        zzjfVar.zze = i;
    }

    public static zzjb zza() {
        return (zzjb) zzb.zzp();
    }

    static void zzc(zzjf zzjfVar, String str) {
        zzjfVar.zzd |= 8;
        zzjfVar.zzh = str;
    }

    static void zze(zzjf zzjfVar, String str) {
        str.getClass();
        zzjfVar.zzd |= 2;
        zzjfVar.zzf = str;
    }

    static void zzf(zzjf zzjfVar, int i) {
        zzjfVar.zzd |= 32;
        zzjfVar.zzj = 0;
    }

    static void zzg(zzjf zzjfVar, int i) {
        zzjfVar.zzd |= 16;
        zzjfVar.zzi = i;
    }

    static void zzh(zzjf zzjfVar, zzjd zzjdVar) {
        zzjfVar.zzg = zzjdVar.zza();
        zzjfVar.zzd |= 4;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0006\u0000\u0001\u0001\b\u0006\u0000\u0000\u0000\u0001င\u0000\u0002ဈ\u0001\u0004᠌\u0002\u0005ဈ\u0003\u0007င\u0004\bင\u0005", new Object[]{"zzd", "zze", "zzf", "zzg", zzjc.zza, "zzh", "zzi", "zzj"});
        }
        if (i2 == 3) {
            return new zzjf();
        }
        zzje zzjeVar = null;
        if (i2 == 4) {
            return new zzjb(zzjeVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
