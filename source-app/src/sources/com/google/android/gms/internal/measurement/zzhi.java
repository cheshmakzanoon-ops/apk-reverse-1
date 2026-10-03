package com.google.android.gms.internal.measurement;

import com.google.common.base.Ascii;
import com.google.common.primitives.UnsignedBytes;
import java.io.IOException;

final class zzhi {
    static double zza(byte[] bArr, int i) {
        return Double.longBitsToDouble(zzd(bArr, i));
    }

    static float zzb(byte[] bArr, int i) {
        return Float.intBitsToFloat(zzc(bArr, i));
    }

    static int zza(byte[] bArr, int i, zzhl zzhlVar) throws zzji {
        int iZzc = zzc(bArr, i, zzhlVar);
        int i2 = zzhlVar.zza;
        if (i2 < 0) {
            throw zzji.zzf();
        }
        if (i2 > bArr.length - iZzc) {
            throw zzji.zzh();
        }
        if (i2 == 0) {
            zzhlVar.zzc = zzhm.zza;
            return iZzc;
        }
        zzhlVar.zzc = zzhm.zza(bArr, iZzc, i2);
        return iZzc + i2;
    }

    static int zzc(byte[] bArr, int i) {
        return ((bArr[i + 3] & UnsignedBytes.MAX_VALUE) << 24) | (bArr[i] & UnsignedBytes.MAX_VALUE) | ((bArr[i + 1] & UnsignedBytes.MAX_VALUE) << 8) | ((bArr[i + 2] & UnsignedBytes.MAX_VALUE) << 16);
    }

    static int zza(zzlb zzlbVar, byte[] bArr, int i, int i2, int i3, zzhl zzhlVar) throws IOException {
        Object objZza = zzlbVar.zza();
        int iZza = zza(objZza, zzlbVar, bArr, i, i2, i3, zzhlVar);
        zzlbVar.zzc(objZza);
        zzhlVar.zzc = objZza;
        return iZza;
    }

    static int zza(zzlb zzlbVar, byte[] bArr, int i, int i2, zzhl zzhlVar) throws IOException {
        Object objZza = zzlbVar.zza();
        int iZza = zza(objZza, zzlbVar, bArr, i, i2, zzhlVar);
        zzlbVar.zzc(objZza);
        zzhlVar.zzc = objZza;
        return iZza;
    }

    static int zza(zzlb<?> zzlbVar, int i, byte[] bArr, int i2, int i3, zzjf<?> zzjfVar, zzhl zzhlVar) throws IOException {
        int iZza = zza(zzlbVar, bArr, i2, i3, zzhlVar);
        zzjfVar.add(zzhlVar.zzc);
        while (iZza < i3) {
            int iZzc = zzc(bArr, iZza, zzhlVar);
            if (i != zzhlVar.zza) {
                break;
            }
            iZza = zza(zzlbVar, bArr, iZzc, i3, zzhlVar);
            zzjfVar.add(zzhlVar.zzc);
        }
        return iZza;
    }

    static int zza(byte[] bArr, int i, zzjf<?> zzjfVar, zzhl zzhlVar) throws IOException {
        zzja zzjaVar = (zzja) zzjfVar;
        int iZzc = zzc(bArr, i, zzhlVar);
        int i2 = zzhlVar.zza + iZzc;
        while (iZzc < i2) {
            iZzc = zzc(bArr, iZzc, zzhlVar);
            zzjaVar.zzd(zzhlVar.zza);
        }
        if (iZzc == i2) {
            return iZzc;
        }
        throw zzji.zzh();
    }

    static int zzb(byte[] bArr, int i, zzhl zzhlVar) throws zzji {
        int iZzc = zzc(bArr, i, zzhlVar);
        int i2 = zzhlVar.zza;
        if (i2 < 0) {
            throw zzji.zzf();
        }
        if (i2 == 0) {
            zzhlVar.zzc = "";
            return iZzc;
        }
        zzhlVar.zzc = zzmh.zzb(bArr, iZzc, i2);
        return iZzc + i2;
    }

    static int zza(int i, byte[] bArr, int i2, int i3, zzlz zzlzVar, zzhl zzhlVar) throws zzji {
        if ((i >>> 3) == 0) {
            throw zzji.zzc();
        }
        int i4 = i & 7;
        if (i4 == 0) {
            int iZzd = zzd(bArr, i2, zzhlVar);
            zzlzVar.zza(i, Long.valueOf(zzhlVar.zzb));
            return iZzd;
        }
        if (i4 == 1) {
            zzlzVar.zza(i, Long.valueOf(zzd(bArr, i2)));
            return i2 + 8;
        }
        if (i4 == 2) {
            int iZzc = zzc(bArr, i2, zzhlVar);
            int i5 = zzhlVar.zza;
            if (i5 < 0) {
                throw zzji.zzf();
            }
            if (i5 > bArr.length - iZzc) {
                throw zzji.zzh();
            }
            if (i5 == 0) {
                zzlzVar.zza(i, zzhm.zza);
            } else {
                zzlzVar.zza(i, zzhm.zza(bArr, iZzc, i5));
            }
            return iZzc + i5;
        }
        if (i4 != 3) {
            if (i4 == 5) {
                zzlzVar.zza(i, Integer.valueOf(zzc(bArr, i2)));
                return i2 + 4;
            }
            throw zzji.zzc();
        }
        zzlz zzlzVarZzd = zzlz.zzd();
        int i6 = (i & (-8)) | 4;
        int i7 = 0;
        while (i2 < i3) {
            int iZzc2 = zzc(bArr, i2, zzhlVar);
            int i8 = zzhlVar.zza;
            i7 = i8;
            if (i8 == i6) {
                i2 = iZzc2;
                break;
            }
            int iZza = zza(i7, bArr, iZzc2, i3, zzlzVarZzd, zzhlVar);
            i7 = i8;
            i2 = iZza;
        }
        if (i2 > i3 || i7 != i6) {
            throw zzji.zzg();
        }
        zzlzVar.zza(i, zzlzVarZzd);
        return i2;
    }

    static int zzc(byte[] bArr, int i, zzhl zzhlVar) {
        int i2 = i + 1;
        byte b = bArr[i];
        if (b >= 0) {
            zzhlVar.zza = b;
            return i2;
        }
        return zza(b, bArr, i2, zzhlVar);
    }

    static int zza(int i, byte[] bArr, int i2, zzhl zzhlVar) {
        int i3 = i & 127;
        int i4 = i2 + 1;
        byte b = bArr[i2];
        if (b >= 0) {
            zzhlVar.zza = i3 | (b << 7);
            return i4;
        }
        int i5 = i3 | ((b & Ascii.DEL) << 7);
        int i6 = i2 + 2;
        byte b2 = bArr[i4];
        if (b2 >= 0) {
            zzhlVar.zza = i5 | (b2 << Ascii.f90SO);
            return i6;
        }
        int i7 = i5 | ((b2 & Ascii.DEL) << 14);
        int i8 = i2 + 3;
        byte b3 = bArr[i6];
        if (b3 >= 0) {
            zzhlVar.zza = i7 | (b3 << Ascii.NAK);
            return i8;
        }
        int i9 = i7 | ((b3 & Ascii.DEL) << 21);
        int i10 = i2 + 4;
        byte b4 = bArr[i8];
        if (b4 >= 0) {
            zzhlVar.zza = i9 | (b4 << Ascii.f83FS);
            return i10;
        }
        int i11 = i9 | ((b4 & Ascii.DEL) << 28);
        while (true) {
            int i12 = i10 + 1;
            if (bArr[i10] >= 0) {
                zzhlVar.zza = i11;
                return i12;
            }
            i10 = i12;
        }
    }

    static int zza(int i, byte[] bArr, int i2, int i3, zzjf<?> zzjfVar, zzhl zzhlVar) {
        zzja zzjaVar = (zzja) zzjfVar;
        int iZzc = zzc(bArr, i2, zzhlVar);
        zzjaVar.zzd(zzhlVar.zza);
        while (iZzc < i3) {
            int iZzc2 = zzc(bArr, iZzc, zzhlVar);
            if (i != zzhlVar.zza) {
                break;
            }
            iZzc = zzc(bArr, iZzc2, zzhlVar);
            zzjaVar.zzd(zzhlVar.zza);
        }
        return iZzc;
    }

    static int zzd(byte[] bArr, int i, zzhl zzhlVar) {
        int i2 = i + 1;
        long j = bArr[i];
        if (j >= 0) {
            zzhlVar.zzb = j;
            return i2;
        }
        int i3 = i + 2;
        byte b = bArr[i2];
        long j2 = (j & 127) | (((long) (b & Ascii.DEL)) << 7);
        int i4 = 7;
        while (b < 0) {
            int i5 = i3 + 1;
            byte b2 = bArr[i3];
            i4 += 7;
            j2 |= ((long) (b2 & Ascii.DEL)) << i4;
            b = b2;
            i3 = i5;
        }
        zzhlVar.zzb = j2;
        return i3;
    }

    static int zza(Object obj, zzlb zzlbVar, byte[] bArr, int i, int i2, int i3, zzhl zzhlVar) throws IOException {
        int iZza = ((zzkn) zzlbVar).zza(obj, bArr, i, i2, i3, zzhlVar);
        zzhlVar.zzc = obj;
        return iZza;
    }

    static int zza(Object obj, zzlb zzlbVar, byte[] bArr, int i, int i2, zzhl zzhlVar) throws IOException {
        int iZza = i + 1;
        int i3 = bArr[i];
        if (i3 < 0) {
            iZza = zza(i3, bArr, iZza, zzhlVar);
            i3 = zzhlVar.zza;
        }
        int i4 = iZza;
        if (i3 < 0 || i3 > i2 - i4) {
            throw zzji.zzh();
        }
        int i5 = i3 + i4;
        zzlbVar.zza(obj, bArr, i4, i5, zzhlVar);
        zzhlVar.zzc = obj;
        return i5;
    }

    static int zza(int i, byte[] bArr, int i2, int i3, zzhl zzhlVar) throws zzji {
        if ((i >>> 3) == 0) {
            throw zzji.zzc();
        }
        int i4 = i & 7;
        if (i4 == 0) {
            return zzd(bArr, i2, zzhlVar);
        }
        if (i4 == 1) {
            return i2 + 8;
        }
        if (i4 == 2) {
            return zzc(bArr, i2, zzhlVar) + zzhlVar.zza;
        }
        if (i4 != 3) {
            if (i4 == 5) {
                return i2 + 4;
            }
            throw zzji.zzc();
        }
        int i5 = (i & (-8)) | 4;
        int i6 = 0;
        while (i2 < i3) {
            i2 = zzc(bArr, i2, zzhlVar);
            i6 = zzhlVar.zza;
            if (i6 == i5) {
                break;
            }
            i2 = zza(i6, bArr, i2, i3, zzhlVar);
        }
        if (i2 > i3 || i6 != i5) {
            throw zzji.zzg();
        }
        return i2;
    }

    static long zzd(byte[] bArr, int i) {
        return ((((long) bArr[i + 7]) & 255) << 56) | (((long) bArr[i]) & 255) | ((((long) bArr[i + 1]) & 255) << 8) | ((((long) bArr[i + 2]) & 255) << 16) | ((((long) bArr[i + 3]) & 255) << 24) | ((((long) bArr[i + 4]) & 255) << 32) | ((((long) bArr[i + 5]) & 255) << 40) | ((((long) bArr[i + 6]) & 255) << 48);
    }
}
