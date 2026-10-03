package com.google.android.gms.internal.play_billing;

public final class zzkn extends zzfu implements zzhc {
    private static final zzkn zzb;
    private int zzd;
    private zzjf zze;
    private long zzf;

    static {
        zzkn zzknVar = new zzkn();
        zzb = zzknVar;
        zzfu.zzB(zzkn.class, zzknVar);
    }

    private zzkn() {
    }

    public static zzkl zza() {
        return (zzkl) zzb.zzp();
    }

    static void zzc(zzkn zzknVar, zzjf zzjfVar) {
        zzjfVar.getClass();
        zzknVar.zze = zzjfVar;
        zzknVar.zzd |= 1;
    }

    static void zze(zzkn zzknVar, long j) {
        zzknVar.zzd |= 2;
        zzknVar.zzf = j;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0002\u0000\u0001\u0001\u0002\u0002\u0000\u0000\u0000\u0001ဉ\u0000\u0002ဂ\u0001", new Object[]{"zzd", "zze", "zzf"});
        }
        if (i2 == 3) {
            return new zzkn();
        }
        zzkm zzkmVar = null;
        if (i2 == 4) {
            return new zzkl(zzkmVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
