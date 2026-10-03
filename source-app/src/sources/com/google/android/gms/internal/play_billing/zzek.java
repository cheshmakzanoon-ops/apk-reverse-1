package com.google.android.gms.internal.play_billing;

import com.google.common.base.Ascii;
import com.google.common.primitives.UnsignedBytes;
import java.io.IOException;

final class zzek {
    public static final int zza = 0;
    private static volatile int zzb = 100;

    static int zza(byte[] bArr, int i, zzej zzejVar) throws zzgc {
        int iZzi = zzi(bArr, i, zzejVar);
        int i2 = zzejVar.zza;
        if (i2 < 0) {
            throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
        }
        if (i2 > bArr.length - iZzi) {
            throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
        }
        if (i2 == 0) {
            zzejVar.zzc = zzev.zza;
            return iZzi;
        }
        zzejVar.zzc = zzev.zzk(bArr, iZzi, i2);
        return iZzi + i2;
    }

    static int zzb(byte[] bArr, int i) {
        int i2 = bArr[i] & UnsignedBytes.MAX_VALUE;
        int i3 = bArr[i + 1] & UnsignedBytes.MAX_VALUE;
        int i4 = bArr[i + 2] & UnsignedBytes.MAX_VALUE;
        return ((bArr[i + 3] & UnsignedBytes.MAX_VALUE) << 24) | (i3 << 8) | i2 | (i4 << 16);
    }

    static int zzc(zzhl zzhlVar, byte[] bArr, int i, int i2, int i3, zzej zzejVar) throws IOException {
        Object objZze = zzhlVar.zze();
        int iZzm = zzm(objZze, zzhlVar, bArr, i, i2, i3, zzejVar);
        zzhlVar.zzf(objZze);
        zzejVar.zzc = objZze;
        return iZzm;
    }

    static int zzd(zzhl zzhlVar, byte[] bArr, int i, int i2, zzej zzejVar) throws IOException {
        Object objZze = zzhlVar.zze();
        int iZzn = zzn(objZze, zzhlVar, bArr, i, i2, zzejVar);
        zzhlVar.zzf(objZze);
        zzejVar.zzc = objZze;
        return iZzn;
    }

    static int zze(zzhl zzhlVar, int i, byte[] bArr, int i2, int i3, zzfz zzfzVar, zzej zzejVar) throws IOException {
        int iZzd = zzd(zzhlVar, bArr, i2, i3, zzejVar);
        zzfzVar.add(zzejVar.zzc);
        while (iZzd < i3) {
            int iZzi = zzi(bArr, iZzd, zzejVar);
            if (i != zzejVar.zza) {
                break;
            }
            iZzd = zzd(zzhlVar, bArr, iZzi, i3, zzejVar);
            zzfzVar.add(zzejVar.zzc);
        }
        return iZzd;
    }

    static int zzf(byte[] bArr, int i, zzfz zzfzVar, zzej zzejVar) throws IOException {
        zzfv zzfvVar = (zzfv) zzfzVar;
        int iZzi = zzi(bArr, i, zzejVar);
        int i2 = zzejVar.zza + iZzi;
        while (iZzi < i2) {
            iZzi = zzi(bArr, iZzi, zzejVar);
            zzfvVar.zzg(zzejVar.zza);
        }
        if (iZzi == i2) {
            return iZzi;
        }
        throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
    }

    static int zzg(byte[] bArr, int i, zzej zzejVar) throws zzgc {
        int i2;
        int iZzi = zzi(bArr, i, zzejVar);
        int i3 = zzejVar.zza;
        if (i3 < 0) {
            throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
        }
        if (i3 == 0) {
            zzejVar.zzc = "";
            return iZzi;
        }
        int i4 = zzin.zza;
        int length = bArr.length;
        if ((((length - iZzi) - i3) | iZzi | i3) < 0) {
            throw new ArrayIndexOutOfBoundsException(String.format("buffer length=%d, index=%d, size=%d", Integer.valueOf(length), Integer.valueOf(iZzi), Integer.valueOf(i3)));
        }
        int i5 = iZzi + i3;
        char[] cArr = new char[i3];
        int i6 = 0;
        while (iZzi < i5) {
            byte b = bArr[iZzi];
            if (!zzij.zzd(b)) {
                break;
            }
            iZzi++;
            cArr[i6] = (char) b;
            i6++;
        }
        while (iZzi < i5) {
            int i7 = iZzi + 1;
            byte b2 = bArr[iZzi];
            if (zzij.zzd(b2)) {
                cArr[i6] = (char) b2;
                i6++;
                iZzi = i7;
                while (iZzi < i5) {
                    byte b3 = bArr[iZzi];
                    if (!zzij.zzd(b3)) {
                        break;
                    }
                    iZzi++;
                    cArr[i6] = (char) b3;
                    i6++;
                }
            } else {
                if (b2 < -32) {
                    if (i7 >= i5) {
                        throw new zzgc("Protocol message had invalid UTF-8.");
                    }
                    i2 = i6 + 1;
                    iZzi += 2;
                    zzij.zzc(b2, bArr[i7], cArr, i6);
                } else if (b2 < -16) {
                    if (i7 >= i5 - 1) {
                        throw new zzgc("Protocol message had invalid UTF-8.");
                    }
                    i2 = i6 + 1;
                    int i8 = iZzi + 2;
                    iZzi += 3;
                    zzij.zzb(b2, bArr[i7], bArr[i8], cArr, i6);
                } else {
                    if (i7 >= i5 - 2) {
                        throw new zzgc("Protocol message had invalid UTF-8.");
                    }
                    byte b4 = bArr[i7];
                    int i9 = iZzi + 3;
                    byte b5 = bArr[iZzi + 2];
                    iZzi += 4;
                    zzij.zza(b2, b4, b5, bArr[i9], cArr, i6);
                    i6 += 2;
                }
                i6 = i2;
            }
        }
        zzejVar.zzc = new String(cArr, 0, i6);
        return i5;
    }

    static int zzh(int i, byte[] bArr, int i2, int i3, zzic zzicVar, zzej zzejVar) throws zzgc {
        if ((i >>> 3) == 0) {
            throw new zzgc("Protocol message contained an invalid tag (zero).");
        }
        int i4 = i & 7;
        if (i4 == 0) {
            int iZzl = zzl(bArr, i2, zzejVar);
            zzicVar.zzj(i, Long.valueOf(zzejVar.zzb));
            return iZzl;
        }
        if (i4 == 1) {
            zzicVar.zzj(i, Long.valueOf(zzp(bArr, i2)));
            return i2 + 8;
        }
        if (i4 == 2) {
            int iZzi = zzi(bArr, i2, zzejVar);
            int i5 = zzejVar.zza;
            if (i5 < 0) {
                throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
            }
            if (i5 > bArr.length - iZzi) {
                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
            }
            if (i5 == 0) {
                zzicVar.zzj(i, zzev.zza);
            } else {
                zzicVar.zzj(i, zzev.zzk(bArr, iZzi, i5));
            }
            return iZzi + i5;
        }
        if (i4 != 3) {
            if (i4 != 5) {
                throw new zzgc("Protocol message contained an invalid tag (zero).");
            }
            zzicVar.zzj(i, Integer.valueOf(zzb(bArr, i2)));
            return i2 + 4;
        }
        int i6 = (i & (-8)) | 4;
        zzic zzicVarZzf = zzic.zzf();
        int i7 = zzejVar.zze + 1;
        zzejVar.zze = i7;
        zzq(i7);
        int i8 = 0;
        while (i2 < i3) {
            int iZzi2 = zzi(bArr, i2, zzejVar);
            i8 = zzejVar.zza;
            if (i8 == i6) {
                i2 = iZzi2;
                break;
            }
            i2 = zzh(i8, bArr, iZzi2, i3, zzicVarZzf, zzejVar);
        }
        zzejVar.zze--;
        if (i2 > i3 || i8 != i6) {
            throw new zzgc("Failed to parse the message.");
        }
        zzicVar.zzj(i, zzicVarZzf);
        return i2;
    }

    static int zzi(byte[] bArr, int i, zzej zzejVar) {
        int i2 = i + 1;
        byte b = bArr[i];
        if (b < 0) {
            return zzj(b, bArr, i2, zzejVar);
        }
        zzejVar.zza = b;
        return i2;
    }

    static int zzj(int i, byte[] bArr, int i2, zzej zzejVar) {
        byte b = bArr[i2];
        int i3 = i2 + 1;
        int i4 = i & 127;
        if (b >= 0) {
            zzejVar.zza = i4 | (b << 7);
            return i3;
        }
        int i5 = i4 | ((b & Ascii.DEL) << 7);
        int i6 = i2 + 2;
        byte b2 = bArr[i3];
        if (b2 >= 0) {
            zzejVar.zza = i5 | (b2 << Ascii.f90SO);
            return i6;
        }
        int i7 = i5 | ((b2 & Ascii.DEL) << 14);
        int i8 = i2 + 3;
        byte b3 = bArr[i6];
        if (b3 >= 0) {
            zzejVar.zza = i7 | (b3 << Ascii.NAK);
            return i8;
        }
        int i9 = i7 | ((b3 & Ascii.DEL) << 21);
        int i10 = i2 + 4;
        byte b4 = bArr[i8];
        if (b4 >= 0) {
            zzejVar.zza = i9 | (b4 << Ascii.f83FS);
            return i10;
        }
        int i11 = i9 | ((b4 & Ascii.DEL) << 28);
        while (true) {
            int i12 = i10 + 1;
            if (bArr[i10] >= 0) {
                zzejVar.zza = i11;
                return i12;
            }
            i10 = i12;
        }
    }

    static int zzk(int i, byte[] bArr, int i2, int i3, zzfz zzfzVar, zzej zzejVar) {
        zzfv zzfvVar = (zzfv) zzfzVar;
        int iZzi = zzi(bArr, i2, zzejVar);
        zzfvVar.zzg(zzejVar.zza);
        while (iZzi < i3) {
            int iZzi2 = zzi(bArr, iZzi, zzejVar);
            if (i != zzejVar.zza) {
                break;
            }
            iZzi = zzi(bArr, iZzi2, zzejVar);
            zzfvVar.zzg(zzejVar.zza);
        }
        return iZzi;
    }

    static int zzl(byte[] bArr, int i, zzej zzejVar) {
        long j = bArr[i];
        int i2 = i + 1;
        if (j >= 0) {
            zzejVar.zzb = j;
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
        zzejVar.zzb = j2;
        return i3;
    }

    static int zzm(Object obj, zzhl zzhlVar, byte[] bArr, int i, int i2, int i3, zzej zzejVar) throws IOException {
        zzhe zzheVar = (zzhe) zzhlVar;
        int i4 = zzejVar.zze + 1;
        zzejVar.zze = i4;
        zzq(i4);
        int iZzc = zzheVar.zzc(obj, bArr, i, i2, i3, zzejVar);
        zzejVar.zze--;
        zzejVar.zzc = obj;
        return iZzc;
    }

    static int zzn(Object obj, zzhl zzhlVar, byte[] bArr, int i, int i2, zzej zzejVar) throws IOException {
        int iZzj = i + 1;
        int i3 = bArr[i];
        if (i3 < 0) {
            iZzj = zzj(i3, bArr, iZzj, zzejVar);
            i3 = zzejVar.zza;
        }
        int i4 = iZzj;
        if (i3 < 0 || i3 > i2 - i4) {
            throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
        }
        int i5 = zzejVar.zze + 1;
        zzejVar.zze = i5;
        zzq(i5);
        int i6 = i3 + i4;
        zzhlVar.zzh(obj, bArr, i4, i6, zzejVar);
        zzejVar.zze--;
        zzejVar.zzc = obj;
        return i6;
    }

    static int zzo(int i, byte[] bArr, int i2, int i3, zzej zzejVar) throws zzgc {
        if ((i >>> 3) == 0) {
            throw new zzgc("Protocol message contained an invalid tag (zero).");
        }
        int i4 = i & 7;
        if (i4 == 0) {
            return zzl(bArr, i2, zzejVar);
        }
        if (i4 == 1) {
            return i2 + 8;
        }
        if (i4 == 2) {
            return zzi(bArr, i2, zzejVar) + zzejVar.zza;
        }
        if (i4 != 3) {
            if (i4 == 5) {
                return i2 + 4;
            }
            throw new zzgc("Protocol message contained an invalid tag (zero).");
        }
        int i5 = (i & (-8)) | 4;
        int i6 = 0;
        while (i2 < i3) {
            i2 = zzi(bArr, i2, zzejVar);
            i6 = zzejVar.zza;
            if (i6 == i5) {
                break;
            }
            i2 = zzo(i6, bArr, i2, i3, zzejVar);
        }
        if (i2 > i3 || i6 != i5) {
            throw new zzgc("Failed to parse the message.");
        }
        return i2;
    }

    static long zzp(byte[] bArr, int i) {
        return (((long) bArr[i]) & 255) | ((((long) bArr[i + 1]) & 255) << 8) | ((((long) bArr[i + 2]) & 255) << 16) | ((((long) bArr[i + 3]) & 255) << 24) | ((((long) bArr[i + 4]) & 255) << 32) | ((((long) bArr[i + 5]) & 255) << 40) | ((((long) bArr[i + 6]) & 255) << 48) | ((((long) bArr[i + 7]) & 255) << 56);
    }

    private static void zzq(int i) throws zzgc {
        if (i >= zzb) {
            throw new zzgc("Protocol message had too many levels of nesting.  May be malicious.  Use setRecursionLimit() to increase the recursion depth limit.");
        }
    }
}
