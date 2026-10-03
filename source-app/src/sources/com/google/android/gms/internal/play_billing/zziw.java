package com.google.android.gms.internal.play_billing;

public final class zziw extends zzfu implements zzhc {
    private static final zziw zzb;
    private int zzd;
    private int zze = 0;
    private Object zzf;
    private int zzg;
    private zzjf zzh;
    private int zzi;

    static {
        zziw zziwVar = new zziw();
        zzb = zziwVar;
        zzfu.zzB(zziw.class, zziwVar);
    }

    private zziw() {
    }

    static void zzG(zziw zziwVar, zzke zzkeVar) {
        zzkeVar.getClass();
        zziwVar.zzf = zzkeVar;
        zziwVar.zze = 7;
    }

    static void zzH(zziw zziwVar, zzku zzkuVar) {
        zzkuVar.getClass();
        zziwVar.zzf = zzkuVar;
        zziwVar.zze = 6;
    }

    static void zzI(zziw zziwVar, int i) {
        zziwVar.zzg = i - 1;
        zziwVar.zzd |= 1;
    }

    public static zziu zza() {
        return (zziu) zzb.zzp();
    }

    public static zziw zzc(byte[] bArr) throws zzgc {
        return (zziw) zzfu.zzt(zzb, bArr);
    }

    static void zzf(zziw zziwVar, zzjk zzjkVar) {
        zziwVar.zzi = zzjkVar.zza();
        zziwVar.zzd |= 4;
    }

    static void zzg(zziw zziwVar, zzjf zzjfVar) {
        zzjfVar.getClass();
        zziwVar.zzh = zzjfVar;
        zziwVar.zzd |= 2;
    }

    static void zzh(zziw zziwVar, zzjy zzjyVar) {
        zzjyVar.getClass();
        zziwVar.zzf = zzjyVar;
        zziwVar.zze = 4;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0006\u0001\u0001\u0001\u0007\u0006\u0000\u0000\u0000\u0001᠌\u0000\u0002ဉ\u0001\u0004<\u0000\u0005᠌\u0002\u0006<\u0000\u0007<\u0000", new Object[]{"zzf", "zze", "zzd", "zzg", zzix.zza, "zzh", zzjy.class, "zzi", zzjj.zza, zzku.class, zzke.class});
        }
        if (i2 == 3) {
            return new zziw();
        }
        zziv zzivVar = null;
        if (i2 == 4) {
            return new zziu(zzivVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }

    public final zzke zze() {
        return this.zze == 7 ? (zzke) this.zzf : zzke.zzb();
    }
}
