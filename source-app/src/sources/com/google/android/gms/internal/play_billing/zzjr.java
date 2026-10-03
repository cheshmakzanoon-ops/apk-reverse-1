package com.google.android.gms.internal.play_billing;

import com.ishumei.smantifraud.l111l11l11Ill;
import com.ishumei.smantifraud.l1l11lI1l;

public final class zzjr extends zzfu implements zzhc {
    private static final zzjr zzb;
    private int zzd;
    private int zzh;
    private long zzi;
    private long zzj;
    private boolean zzk;
    private int zzl;
    private int zzm;
    private long zzn;
    private int zzs;
    private String zze = "";
    private String zzf = "";
    private String zzg = "";
    private String zzo = "";
    private String zzp = "";
    private String zzq = "";
    private String zzr = "";

    static {
        zzjr zzjrVar = new zzjr();
        zzb = zzjrVar;
        zzfu.zzB(zzjr.class, zzjrVar);
    }

    private zzjr() {
    }

    static void zzG(zzjr zzjrVar, long j) {
        zzjrVar.zzd |= 512;
        zzjrVar.zzn = 846465066L;
    }

    static void zzH(zzjr zzjrVar, String str) {
        str.getClass();
        zzjrVar.zzd |= 4;
        zzjrVar.zzg = str;
    }

    static void zzI(zzjr zzjrVar, String str) {
        str.getClass();
        zzjrVar.zzd |= 1024;
        zzjrVar.zzo = str;
    }

    static void zzJ(zzjr zzjrVar, String str) {
        str.getClass();
        zzjrVar.zzd |= 8192;
        zzjrVar.zzr = str;
    }

    static void zzK(zzjr zzjrVar, String str) {
        str.getClass();
        zzjrVar.zzd |= l111l11l11Ill.l111l11111lIl;
        zzjrVar.zzq = str;
    }

    static void zzL(zzjr zzjrVar, String str) {
        str.getClass();
        zzjrVar.zzd |= 2048;
        zzjrVar.zzp = str;
    }

    static void zzM(zzjr zzjrVar, int i) {
        zzjrVar.zzd |= 16384;
        zzjrVar.zzs = i;
    }

    static void zzN(zzjr zzjrVar, boolean z) {
        zzjrVar.zzd |= 64;
        zzjrVar.zzk = z;
    }

    static void zzO(zzjr zzjrVar, String str) {
        str.getClass();
        zzjrVar.zzd |= 1;
        zzjrVar.zze = str;
    }

    static void zzP(zzjr zzjrVar, String str) {
        zzjrVar.zzd |= 2;
        zzjrVar.zzf = str;
    }

    public static zzjp zza() {
        return (zzjp) zzb.zzp();
    }

    static void zzc(zzjr zzjrVar, int i) {
        zzjrVar.zzd |= 128;
        zzjrVar.zzl = i;
    }

    static void zze(zzjr zzjrVar, int i) {
        zzjrVar.zzd |= l1l11lI1l.l111l11111lIl;
        zzjrVar.zzm = i;
    }

    static void zzf(zzjr zzjrVar, int i) {
        zzjrVar.zzd |= 8;
        zzjrVar.zzh = i;
    }

    static void zzg(zzjr zzjrVar, long j) {
        zzjrVar.zzd |= 16;
        zzjrVar.zzi = j;
    }

    static void zzh(zzjr zzjrVar, long j) {
        zzjrVar.zzd |= 32;
        zzjrVar.zzj = j;
    }

    @Override
    protected final Object zzd(int i, Object obj, Object obj2) {
        int i2 = i - 1;
        if (i2 == 0) {
            return (byte) 1;
        }
        if (i2 == 2) {
            return zzy(zzb, "\u0004\u000f\u0000\u0001\u0001\u000f\u000f\u0000\u0000\u0000\u0001ဈ\u0000\u0002ဈ\u0002\u0003င\u0003\u0004ဂ\u0004\u0005ဈ\u0001\u0006ဂ\u0005\u0007ဇ\u0006\bင\u0007\tင\b\nဂ\t\u000bဈ\n\fဈ\u000b\rဈ\f\u000eဈ\r\u000fင\u000e", new Object[]{"zzd", "zze", "zzg", "zzh", "zzi", "zzf", "zzj", "zzk", "zzl", "zzm", "zzn", "zzo", "zzp", "zzq", "zzr", "zzs"});
        }
        if (i2 == 3) {
            return new zzjr();
        }
        zzjq zzjqVar = null;
        if (i2 == 4) {
            return new zzjp(zzjqVar);
        }
        if (i2 == 5) {
            return zzb;
        }
        throw null;
    }
}
