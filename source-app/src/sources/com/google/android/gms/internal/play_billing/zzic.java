package com.google.android.gms.internal.play_billing;

import java.io.IOException;
import java.util.Arrays;

public final class zzic {
    private static final zzic zza = new zzic(0, new int[0], new Object[0], false);
    private int zzb;
    private int[] zzc;
    private Object[] zzd;
    private int zze;
    private boolean zzf;

    private zzic() {
        this(0, new int[8], new Object[8], true);
    }

    private zzic(int i, int[] iArr, Object[] objArr, boolean z) {
        this.zze = -1;
        this.zzb = i;
        this.zzc = iArr;
        this.zzd = objArr;
        this.zzf = z;
    }

    public static zzic zzc() {
        return zza;
    }

    static zzic zze(zzic zzicVar, zzic zzicVar2) {
        int i = zzicVar.zzb + zzicVar2.zzb;
        int[] iArrCopyOf = Arrays.copyOf(zzicVar.zzc, i);
        System.arraycopy(zzicVar2.zzc, 0, iArrCopyOf, zzicVar.zzb, zzicVar2.zzb);
        Object[] objArrCopyOf = Arrays.copyOf(zzicVar.zzd, i);
        System.arraycopy(zzicVar2.zzd, 0, objArrCopyOf, zzicVar.zzb, zzicVar2.zzb);
        return new zzic(i, iArrCopyOf, objArrCopyOf, true);
    }

    static zzic zzf() {
        return new zzic(0, new int[8], new Object[8], true);
    }

    private final void zzm(int i) {
        int[] iArr = this.zzc;
        if (i > iArr.length) {
            int i2 = this.zzb;
            int i3 = i2 + (i2 / 2);
            if (i3 >= i) {
                i = i3;
            }
            if (i < 8) {
                i = 8;
            }
            this.zzc = Arrays.copyOf(iArr, i);
            this.zzd = Arrays.copyOf(this.zzd, i);
        }
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || !(obj instanceof zzic)) {
            return false;
        }
        zzic zzicVar = (zzic) obj;
        int i = this.zzb;
        if (i == zzicVar.zzb) {
            int[] iArr = this.zzc;
            int[] iArr2 = zzicVar.zzc;
            for (int i2 = 0; i2 < i; i2++) {
                if (iArr[i2] == iArr2[i2]) {
                }
            }
            Object[] objArr = this.zzd;
            Object[] objArr2 = zzicVar.zzd;
            int i3 = this.zzb;
            for (int i4 = 0; i4 < i3; i4++) {
                if (objArr[i4].equals(objArr2[i4])) {
                }
            }
            return true;
        }
        return false;
    }

    public final int hashCode() {
        int i = this.zzb;
        int i2 = i + 527;
        int[] iArr = this.zzc;
        int iHashCode = 17;
        int i3 = 17;
        for (int i4 = 0; i4 < i; i4++) {
            i3 = (i3 * 31) + iArr[i4];
        }
        int i5 = ((i2 * 31) + i3) * 31;
        Object[] objArr = this.zzd;
        int i6 = this.zzb;
        for (int i7 = 0; i7 < i6; i7++) {
            iHashCode = (iHashCode * 31) + objArr[i7].hashCode();
        }
        return i5 + iHashCode;
    }

    public final int zza() {
        int iZzy;
        int iZzz;
        int iZzy2;
        int i = this.zze;
        if (i != -1) {
            return i;
        }
        int i2 = 0;
        for (int i3 = 0; i3 < this.zzb; i3++) {
            int i4 = this.zzc[i3];
            int i5 = i4 >>> 3;
            int i6 = i4 & 7;
            if (i6 != 0) {
                if (i6 == 1) {
                    ((Long) this.zzd[i3]).longValue();
                    iZzy2 = zzfc.zzy(i5 << 3) + 8;
                } else if (i6 == 2) {
                    int i7 = i5 << 3;
                    zzev zzevVar = (zzev) this.zzd[i3];
                    int iZzy3 = zzfc.zzy(i7);
                    int iZze = zzevVar.zze();
                    iZzy2 = iZzy3 + zzfc.zzy(iZze) + iZze;
                } else if (i6 == 3) {
                    int iZzy4 = zzfc.zzy(i5 << 3);
                    iZzy = iZzy4 + iZzy4;
                    iZzz = ((zzic) this.zzd[i3]).zza();
                } else {
                    if (i6 != 5) {
                        throw new IllegalStateException(new zzgb("Protocol message tag had invalid wire type."));
                    }
                    ((Integer) this.zzd[i3]).intValue();
                    iZzy2 = zzfc.zzy(i5 << 3) + 4;
                }
                i2 += iZzy2;
            } else {
                int i8 = i5 << 3;
                long jLongValue = ((Long) this.zzd[i3]).longValue();
                iZzy = zzfc.zzy(i8);
                iZzz = zzfc.zzz(jLongValue);
            }
            iZzy2 = iZzy + iZzz;
            i2 += iZzy2;
        }
        this.zze = i2;
        return i2;
    }

    public final int zzb() {
        int i = this.zze;
        if (i != -1) {
            return i;
        }
        int iZzy = 0;
        for (int i2 = 0; i2 < this.zzb; i2++) {
            int i3 = this.zzc[i2] >>> 3;
            zzev zzevVar = (zzev) this.zzd[i2];
            int iZzy2 = zzfc.zzy(8);
            int iZzy3 = zzfc.zzy(16) + zzfc.zzy(i3);
            int iZzy4 = zzfc.zzy(24);
            int iZze = zzevVar.zze();
            iZzy += iZzy2 + iZzy2 + iZzy3 + iZzy4 + zzfc.zzy(iZze) + iZze;
        }
        this.zze = iZzy;
        return iZzy;
    }

    final zzic zzd(zzic zzicVar) {
        if (zzicVar.equals(zza)) {
            return this;
        }
        zzg();
        int i = this.zzb + zzicVar.zzb;
        zzm(i);
        System.arraycopy(zzicVar.zzc, 0, this.zzc, this.zzb, zzicVar.zzb);
        System.arraycopy(zzicVar.zzd, 0, this.zzd, this.zzb, zzicVar.zzb);
        this.zzb = i;
        return this;
    }

    final void zzg() {
        if (!this.zzf) {
            throw new UnsupportedOperationException();
        }
    }

    public final void zzh() {
        if (this.zzf) {
            this.zzf = false;
        }
    }

    final void zzi(StringBuilder sb, int i) {
        for (int i2 = 0; i2 < this.zzb; i2++) {
            zzhd.zzb(sb, i, String.valueOf(this.zzc[i2] >>> 3), this.zzd[i2]);
        }
    }

    final void zzj(int i, Object obj) {
        zzg();
        zzm(this.zzb + 1);
        int[] iArr = this.zzc;
        int i2 = this.zzb;
        iArr[i2] = i;
        this.zzd[i2] = obj;
        this.zzb = i2 + 1;
    }

    final void zzk(zzit zzitVar) throws IOException {
        for (int i = 0; i < this.zzb; i++) {
            zzitVar.zzx(this.zzc[i] >>> 3, this.zzd[i]);
        }
    }

    public final void zzl(zzit zzitVar) throws IOException {
        if (this.zzb != 0) {
            for (int i = 0; i < this.zzb; i++) {
                int i2 = this.zzc[i];
                Object obj = this.zzd[i];
                int i3 = i2 & 7;
                int i4 = i2 >>> 3;
                if (i3 == 0) {
                    zzitVar.zzt(i4, ((Long) obj).longValue());
                } else if (i3 == 1) {
                    zzitVar.zzm(i4, ((Long) obj).longValue());
                } else if (i3 == 2) {
                    zzitVar.zzd(i4, (zzev) obj);
                } else if (i3 == 3) {
                    zzitVar.zzG(i4);
                    ((zzic) obj).zzl(zzitVar);
                    zzitVar.zzh(i4);
                } else {
                    if (i3 != 5) {
                        throw new RuntimeException(new zzgb("Protocol message tag had invalid wire type."));
                    }
                    zzitVar.zzk(i4, ((Integer) obj).intValue());
                }
            }
        }
    }
}
