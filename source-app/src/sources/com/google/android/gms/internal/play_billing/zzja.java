package com.google.android.gms.internal.play_billing;

public final class zzja extends zzfu implements zzhc {
    private static final zzja zzb;
    private int zzd;
    private int zze = 0;
    private Object zzf;
    private int zzg;
    private int zzh;

    static {
        zzja zzjaVar = new zzja();
        zzb = zzjaVar;
        zzfu.zzB(zzja.class, zzjaVar);
    }

    private zzja() {
    }

    static void zzG(zzja zzjaVar, int i) {
        zzjaVar.zzg = i - 1;
        zzjaVar.zzd |= 1;
    }

    public static zziy zza() {
        return (zziy) zzb.zzp();
    }

    static void zze(zzja zzjaVar, zzjk zzjkVar) {
        zzjaVar.zzh = zzjkVar.zza();
        zzjaVar.zzd |= 2;
    }

    static void zzf(zzja zzjaVar, zzjy zzjyVar) {
        zzjyVar.getClass();
        zzjaVar.zzf = zzjyVar;
        zzjaVar.zze = 2;
    }

    static void zzg(zzja zzjaVar, zzke zzkeVar) {
        zzkeVar.getClass();
        zzjaVar.zzf = zzkeVar;
        zzjaVar.zze = 4;
    }

    static void zzh(zzja zzjaVar, zzku zzkuVar) {
        zzkuVar.getClass();
        zzjaVar.zzf = zzkuVar;
        zzjaVar.zze = 3;
    }

    public final zzke zzc() {
        return this.zze == 4 ? (zzke) this.zzf : zzke.zzb();
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u0005\u0001\u0001\u0001\u0005\u0005\u0000\u0000\u0000\u0001᠌\u0000\u0002<\u0000\u0003<\u0000\u0004<\u0000\u0005᠌\u0001", new Object[]{"zzf", "zze", "zzd", "zzg", zzix.zza, zzjy.class, zzku.class, zzke.class, "zzh", zzjj.zza});
        }
        if (i2 == 3) {
            return new zzja();
        }
        zziz zzizVar = null;
        if (i2 == 4) {
            return new zziy(zzizVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
