package com.google.android.gms.internal.play_billing;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.Api;
import com.google.android.gms.common.api.CommonStatusCodes;
import com.google.firebase.crashlytics.internal.metadata.UserMetadata;
import com.google.zxing.aztec.encoder.Encoder;
import com.ishumei.smantifraud.l111l11l11Ill;
import com.ishumei.smantifraud.l11l111l11Il;
import com.ishumei.smantifraud.l11l11lI1lll;
import com.ishumei.smantifraud.l1l11lI1l;
import com.ishumei.smantifraud.l1l1l11Il;
import java.io.IOException;
import java.lang.reflect.Field;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.RandomAccess;
import sun.misc.Unsafe;

final class zzhe<T> implements zzhl<T> {
    private static final int[] zza = new int[0];
    private static final Unsafe zzb = zzii.zzg();
    private final int[] zzc;
    private final Object[] zzd;
    private final int zze;
    private final int zzf;
    private final zzhb zzg;
    private final boolean zzh;
    private final int[] zzi;
    private final int zzj;
    private final int zzk;
    private final zzib zzl;
    private final zzfi zzm;

    private zzhe(int[] iArr, Object[] objArr, int i, int i2, zzhb zzhbVar, boolean z, int[] iArr2, int i3, int i4, zzhg zzhgVar, zzgk zzgkVar, zzib zzibVar, zzfi zzfiVar, zzgw zzgwVar) {
        this.zzc = iArr;
        this.zzd = objArr;
        this.zze = i;
        this.zzf = i2;
        boolean z2 = false;
        if (zzfiVar != null && (zzhbVar instanceof zzfr)) {
            z2 = true;
        }
        this.zzh = z2;
        this.zzi = iArr2;
        this.zzj = i3;
        this.zzk = i4;
        this.zzl = zzibVar;
        this.zzm = zzfiVar;
        this.zzg = zzhbVar;
    }

    private static void zzA(Object obj) {
        if (!zzL(obj)) {
            throw new IllegalArgumentException("Mutating immutable message: ".concat(String.valueOf(String.valueOf(obj))));
        }
    }

    private final void zzB(Object obj, Object obj2, int i) {
        if (zzI(obj2, i)) {
            int iZzs = zzs(i) & 1048575;
            Unsafe unsafe = zzb;
            long j = iZzs;
            Object object = unsafe.getObject(obj2, j);
            if (object == null) {
                throw new IllegalStateException("Source subfield " + this.zzc[i] + " is present but null: " + obj2.toString());
            }
            zzhl zzhlVarZzv = zzv(i);
            if (!zzI(obj, i)) {
                if (zzL(object)) {
                    Object objZze = zzhlVarZzv.zze();
                    zzhlVarZzv.zzg(objZze, object);
                    unsafe.putObject(obj, j, objZze);
                } else {
                    unsafe.putObject(obj, j, object);
                }
                zzD(obj, i);
                return;
            }
            Object object2 = unsafe.getObject(obj, j);
            if (!zzL(object2)) {
                Object objZze2 = zzhlVarZzv.zze();
                zzhlVarZzv.zzg(objZze2, object2);
                unsafe.putObject(obj, j, objZze2);
                object2 = objZze2;
            }
            zzhlVarZzv.zzg(object2, object);
        }
    }

    private final void zzC(Object obj, Object obj2, int i) {
        int[] iArr = this.zzc;
        int i2 = iArr[i];
        if (zzM(obj2, i2, i)) {
            int iZzs = zzs(i) & 1048575;
            Unsafe unsafe = zzb;
            long j = iZzs;
            Object object = unsafe.getObject(obj2, j);
            if (object == null) {
                throw new IllegalStateException("Source subfield " + iArr[i] + " is present but null: " + obj2.toString());
            }
            zzhl zzhlVarZzv = zzv(i);
            if (!zzM(obj, i2, i)) {
                if (zzL(object)) {
                    Object objZze = zzhlVarZzv.zze();
                    zzhlVarZzv.zzg(objZze, object);
                    unsafe.putObject(obj, j, objZze);
                } else {
                    unsafe.putObject(obj, j, object);
                }
                zzE(obj, i2, i);
                return;
            }
            Object object2 = unsafe.getObject(obj, j);
            if (!zzL(object2)) {
                Object objZze2 = zzhlVarZzv.zze();
                zzhlVarZzv.zzg(objZze2, object2);
                unsafe.putObject(obj, j, objZze2);
                object2 = objZze2;
            }
            zzhlVarZzv.zzg(object2, object);
        }
    }

    private final void zzD(Object obj, int i) {
        int iZzp = zzp(i);
        long j = 1048575 & iZzp;
        if (j == 1048575) {
            return;
        }
        zzii.zzq(obj, j, (1 << (iZzp >>> 20)) | zzii.zzc(obj, j));
    }

    private final void zzE(Object obj, int i, int i2) {
        zzii.zzq(obj, zzp(i2) & 1048575, i);
    }

    private final void zzF(Object obj, int i, Object obj2) {
        zzb.putObject(obj, zzs(i) & 1048575, obj2);
        zzD(obj, i);
    }

    private final void zzG(Object obj, int i, int i2, Object obj2) {
        zzb.putObject(obj, zzs(i2) & 1048575, obj2);
        zzE(obj, i, i2);
    }

    private final boolean zzH(Object obj, Object obj2, int i) {
        return zzI(obj, i) == zzI(obj2, i);
    }

    private final boolean zzI(Object obj, int i) {
        int iZzp = zzp(i);
        long j = iZzp & 1048575;
        if (j != 1048575) {
            return (zzii.zzc(obj, j) & (1 << (iZzp >>> 20))) != 0;
        }
        int iZzs = zzs(i);
        long j2 = iZzs & 1048575;
        switch (zzr(iZzs)) {
            case 0:
                return Double.doubleToRawLongBits(zzii.zza(obj, j2)) != 0;
            case 1:
                return Float.floatToRawIntBits(zzii.zzb(obj, j2)) != 0;
            case 2:
                return zzii.zzd(obj, j2) != 0;
            case 3:
                return zzii.zzd(obj, j2) != 0;
            case 4:
                return zzii.zzc(obj, j2) != 0;
            case 5:
                return zzii.zzd(obj, j2) != 0;
            case 6:
                return zzii.zzc(obj, j2) != 0;
            case 7:
                return zzii.zzw(obj, j2);
            case 8:
                Object objZzf = zzii.zzf(obj, j2);
                if (objZzf instanceof String) {
                    return !((String) objZzf).isEmpty();
                }
                if (objZzf instanceof zzev) {
                    return !zzev.zza.equals(objZzf);
                }
                throw new IllegalArgumentException();
            case 9:
                return zzii.zzf(obj, j2) != null;
            case 10:
                return !zzev.zza.equals(zzii.zzf(obj, j2));
            case 11:
                return zzii.zzc(obj, j2) != 0;
            case 12:
                return zzii.zzc(obj, j2) != 0;
            case 13:
                return zzii.zzc(obj, j2) != 0;
            case 14:
                return zzii.zzd(obj, j2) != 0;
            case 15:
                return zzii.zzc(obj, j2) != 0;
            case 16:
                return zzii.zzd(obj, j2) != 0;
            case 17:
                return zzii.zzf(obj, j2) != null;
            default:
                throw new IllegalArgumentException();
        }
    }

    private final boolean zzJ(Object obj, int i, int i2, int i3, int i4) {
        if (i2 == 1048575) {
            return zzI(obj, i);
        }
        return (i3 & i4) != 0;
    }

    private static boolean zzK(Object obj, int i, zzhl zzhlVar) {
        return zzhlVar.zzk(zzii.zzf(obj, i & 1048575));
    }

    private static boolean zzL(Object obj) {
        if (obj == null) {
            return false;
        }
        if (obj instanceof zzfu) {
            return ((zzfu) obj).zzF();
        }
        return true;
    }

    private final boolean zzM(Object obj, int i, int i2) {
        return zzii.zzc(obj, (long) (zzp(i2) & 1048575)) == i;
    }

    private static boolean zzN(Object obj, long j) {
        return ((Boolean) zzii.zzf(obj, j)).booleanValue();
    }

    private static final int zzO(byte[] bArr, int i, int i2, zzir zzirVar, Class cls, zzej zzejVar) throws IOException {
        int i3;
        zzir zzirVar2 = zzir.DOUBLE;
        switch (zzirVar) {
            case DOUBLE:
                i3 = i + 8;
                zzejVar.zzc = Double.valueOf(Double.longBitsToDouble(zzek.zzp(bArr, i)));
                break;
            case FLOAT:
                i3 = i + 4;
                zzejVar.zzc = Float.valueOf(Float.intBitsToFloat(zzek.zzb(bArr, i)));
                break;
            case INT64:
            case UINT64:
                int iZzl = zzek.zzl(bArr, i, zzejVar);
                zzejVar.zzc = Long.valueOf(zzejVar.zzb);
                return iZzl;
            case INT32:
            case UINT32:
            case ENUM:
                int iZzi = zzek.zzi(bArr, i, zzejVar);
                zzejVar.zzc = Integer.valueOf(zzejVar.zza);
                return iZzi;
            case FIXED64:
            case SFIXED64:
                i3 = i + 8;
                zzejVar.zzc = Long.valueOf(zzek.zzp(bArr, i));
                break;
            case FIXED32:
            case SFIXED32:
                i3 = i + 4;
                zzejVar.zzc = Integer.valueOf(zzek.zzb(bArr, i));
                break;
            case BOOL:
                int iZzl2 = zzek.zzl(bArr, i, zzejVar);
                zzejVar.zzc = Boolean.valueOf(zzejVar.zzb != 0);
                return iZzl2;
            case STRING:
                return zzek.zzg(bArr, i, zzejVar);
            case GROUP:
            default:
                throw new RuntimeException("unsupported field type.");
            case MESSAGE:
                return zzek.zzd(zzhi.zza().zzb(cls), bArr, i, i2, zzejVar);
            case BYTES:
                return zzek.zza(bArr, i, zzejVar);
            case SINT32:
                int iZzi2 = zzek.zzi(bArr, i, zzejVar);
                zzejVar.zzc = Integer.valueOf(zzey.zzb(zzejVar.zza));
                return iZzi2;
            case SINT64:
                int iZzl3 = zzek.zzl(bArr, i, zzejVar);
                zzejVar.zzc = Long.valueOf(zzey.zzc(zzejVar.zzb));
                return iZzl3;
        }
        return i3;
    }

    private static final void zzP(int i, Object obj, zzit zzitVar) throws IOException {
        if (obj instanceof String) {
            zzitVar.zzH(i, (String) obj);
        } else {
            zzitVar.zzd(i, (zzev) obj);
        }
    }

    static zzic zzd(Object obj) {
        zzfu zzfuVar = (zzfu) obj;
        zzic zzicVar = zzfuVar.zzc;
        if (zzicVar != zzic.zzc()) {
            return zzicVar;
        }
        zzic zzicVarZzf = zzic.zzf();
        zzfuVar.zzc = zzicVarZzf;
        return zzicVarZzf;
    }

    static zzhe zzl(Class cls, zzgy zzgyVar, zzhg zzhgVar, zzgk zzgkVar, zzib zzibVar, zzfi zzfiVar, zzgw zzgwVar) {
        int i;
        int iCharAt;
        int iCharAt2;
        int i2;
        int i3;
        int i4;
        int[] iArr;
        int i5;
        int i6;
        int i7;
        char cCharAt;
        int i8;
        char cCharAt2;
        int i9;
        char cCharAt3;
        int i10;
        char cCharAt4;
        int i11;
        char cCharAt5;
        int i12;
        char cCharAt6;
        int i13;
        char cCharAt7;
        int i14;
        char cCharAt8;
        int i15;
        int i16;
        int i17;
        int i18;
        int iObjectFieldOffset;
        int iObjectFieldOffset2;
        int i19;
        int i20;
        int i21;
        Field fieldZzz;
        int i22;
        char cCharAt9;
        int i23;
        int i24;
        int i25;
        int i26;
        int i27;
        Object obj;
        Field fieldZzz2;
        int i28;
        Object obj2;
        Field fieldZzz3;
        int i29;
        char cCharAt10;
        int i30;
        char cCharAt11;
        int i31;
        char cCharAt12;
        int i32;
        char cCharAt13;
        if (!(zzgyVar instanceof zzhk)) {
            throw null;
        }
        zzhk zzhkVar = (zzhk) zzgyVar;
        String strZzd = zzhkVar.zzd();
        int length = strZzd.length();
        char c = 55296;
        if (strZzd.charAt(0) >= 55296) {
            int i33 = 1;
            while (true) {
                i = i33 + 1;
                if (strZzd.charAt(i33) < 55296) {
                    break;
                }
                i33 = i;
            }
        } else {
            i = 1;
        }
        int i34 = i + 1;
        int iCharAt3 = strZzd.charAt(i);
        if (iCharAt3 >= 55296) {
            int i35 = iCharAt3 & 8191;
            int i36 = 13;
            while (true) {
                i32 = i34 + 1;
                cCharAt13 = strZzd.charAt(i34);
                if (cCharAt13 < 55296) {
                    break;
                }
                i35 |= (cCharAt13 & 8191) << i36;
                i36 += 13;
                i34 = i32;
            }
            iCharAt3 = i35 | (cCharAt13 << i36);
            i34 = i32;
        }
        if (iCharAt3 == 0) {
            i4 = 0;
            iCharAt = 0;
            iCharAt2 = 0;
            i2 = 0;
            i5 = 0;
            i3 = 0;
            iArr = zza;
            i6 = 0;
        } else {
            int i37 = i34 + 1;
            int iCharAt4 = strZzd.charAt(i34);
            if (iCharAt4 >= 55296) {
                int i38 = iCharAt4 & 8191;
                int i39 = 13;
                while (true) {
                    i14 = i37 + 1;
                    cCharAt8 = strZzd.charAt(i37);
                    if (cCharAt8 < 55296) {
                        break;
                    }
                    i38 |= (cCharAt8 & 8191) << i39;
                    i39 += 13;
                    i37 = i14;
                }
                iCharAt4 = i38 | (cCharAt8 << i39);
                i37 = i14;
            }
            int i40 = i37 + 1;
            int iCharAt5 = strZzd.charAt(i37);
            if (iCharAt5 >= 55296) {
                int i41 = iCharAt5 & 8191;
                int i42 = 13;
                while (true) {
                    i13 = i40 + 1;
                    cCharAt7 = strZzd.charAt(i40);
                    if (cCharAt7 < 55296) {
                        break;
                    }
                    i41 |= (cCharAt7 & 8191) << i42;
                    i42 += 13;
                    i40 = i13;
                }
                iCharAt5 = i41 | (cCharAt7 << i42);
                i40 = i13;
            }
            int i43 = i40 + 1;
            int iCharAt6 = strZzd.charAt(i40);
            if (iCharAt6 >= 55296) {
                int i44 = iCharAt6 & 8191;
                int i45 = 13;
                while (true) {
                    i12 = i43 + 1;
                    cCharAt6 = strZzd.charAt(i43);
                    if (cCharAt6 < 55296) {
                        break;
                    }
                    i44 |= (cCharAt6 & 8191) << i45;
                    i45 += 13;
                    i43 = i12;
                }
                iCharAt6 = i44 | (cCharAt6 << i45);
                i43 = i12;
            }
            int i46 = i43 + 1;
            int iCharAt7 = strZzd.charAt(i43);
            if (iCharAt7 >= 55296) {
                int i47 = iCharAt7 & 8191;
                int i48 = 13;
                while (true) {
                    i11 = i46 + 1;
                    cCharAt5 = strZzd.charAt(i46);
                    if (cCharAt5 < 55296) {
                        break;
                    }
                    i47 |= (cCharAt5 & 8191) << i48;
                    i48 += 13;
                    i46 = i11;
                }
                iCharAt7 = i47 | (cCharAt5 << i48);
                i46 = i11;
            }
            int i49 = i46 + 1;
            iCharAt = strZzd.charAt(i46);
            if (iCharAt >= 55296) {
                int i50 = iCharAt & 8191;
                int i51 = 13;
                while (true) {
                    i10 = i49 + 1;
                    cCharAt4 = strZzd.charAt(i49);
                    if (cCharAt4 < 55296) {
                        break;
                    }
                    i50 |= (cCharAt4 & 8191) << i51;
                    i51 += 13;
                    i49 = i10;
                }
                iCharAt = i50 | (cCharAt4 << i51);
                i49 = i10;
            }
            int i52 = i49 + 1;
            iCharAt2 = strZzd.charAt(i49);
            if (iCharAt2 >= 55296) {
                int i53 = iCharAt2 & 8191;
                int i54 = 13;
                while (true) {
                    i9 = i52 + 1;
                    cCharAt3 = strZzd.charAt(i52);
                    if (cCharAt3 < 55296) {
                        break;
                    }
                    i53 |= (cCharAt3 & 8191) << i54;
                    i54 += 13;
                    i52 = i9;
                }
                iCharAt2 = i53 | (cCharAt3 << i54);
                i52 = i9;
            }
            int i55 = i52 + 1;
            int iCharAt8 = strZzd.charAt(i52);
            if (iCharAt8 >= 55296) {
                int i56 = iCharAt8 & 8191;
                int i57 = 13;
                while (true) {
                    i8 = i55 + 1;
                    cCharAt2 = strZzd.charAt(i55);
                    if (cCharAt2 < 55296) {
                        break;
                    }
                    i56 |= (cCharAt2 & 8191) << i57;
                    i57 += 13;
                    i55 = i8;
                }
                iCharAt8 = i56 | (cCharAt2 << i57);
                i55 = i8;
            }
            int i58 = i55 + 1;
            int iCharAt9 = strZzd.charAt(i55);
            if (iCharAt9 >= 55296) {
                int i59 = iCharAt9 & 8191;
                int i60 = 13;
                while (true) {
                    i7 = i58 + 1;
                    cCharAt = strZzd.charAt(i58);
                    if (cCharAt < 55296) {
                        break;
                    }
                    i59 |= (cCharAt & 8191) << i60;
                    i60 += 13;
                    i58 = i7;
                }
                iCharAt9 = i59 | (cCharAt << i60);
                i58 = i7;
            }
            int i61 = iCharAt4 + iCharAt4 + iCharAt5;
            int[] iArr2 = new int[iCharAt9 + iCharAt2 + iCharAt8];
            i2 = iCharAt6;
            i3 = iCharAt9;
            i4 = i61;
            iArr = iArr2;
            i5 = iCharAt7;
            i6 = iCharAt4;
            i34 = i58;
        }
        Unsafe unsafe = zzb;
        Object[] objArrZze = zzhkVar.zze();
        Class<?> cls2 = zzhkVar.zza().getClass();
        int i62 = i3 + iCharAt2;
        int i63 = iCharAt + iCharAt;
        int[] iArr3 = new int[iCharAt * 3];
        Object[] objArr = new Object[i63];
        int i64 = i3;
        int i65 = i62;
        int i66 = 0;
        int i67 = 0;
        while (i34 < length) {
            int i68 = i34 + 1;
            int iCharAt10 = strZzd.charAt(i34);
            if (iCharAt10 >= c) {
                int i69 = iCharAt10 & 8191;
                int i70 = i68;
                int i71 = 13;
                while (true) {
                    i31 = i70 + 1;
                    cCharAt12 = strZzd.charAt(i70);
                    if (cCharAt12 < c) {
                        break;
                    }
                    i69 |= (cCharAt12 & 8191) << i71;
                    i71 += 13;
                    i70 = i31;
                }
                iCharAt10 = i69 | (cCharAt12 << i71);
                i15 = i31;
            } else {
                i15 = i68;
            }
            int i72 = i15 + 1;
            int iCharAt11 = strZzd.charAt(i15);
            if (iCharAt11 >= c) {
                int i73 = iCharAt11 & 8191;
                int i74 = i72;
                int i75 = 13;
                while (true) {
                    i30 = i74 + 1;
                    cCharAt11 = strZzd.charAt(i74);
                    if (cCharAt11 < c) {
                        break;
                    }
                    i73 |= (cCharAt11 & 8191) << i75;
                    i75 += 13;
                    i74 = i30;
                }
                iCharAt11 = i73 | (cCharAt11 << i75);
                i16 = i30;
            } else {
                i16 = i72;
            }
            if ((iCharAt11 & 1024) != 0) {
                iArr[i66] = i67;
                i66++;
            }
            int i76 = iCharAt11 & 255;
            int i77 = length;
            int i78 = iCharAt11 & 2048;
            int i79 = i5;
            if (i76 >= 51) {
                int i80 = i16 + 1;
                int iCharAt12 = strZzd.charAt(i16);
                if (iCharAt12 >= 55296) {
                    int i81 = iCharAt12 & 8191;
                    int i82 = i80;
                    int i83 = 13;
                    while (true) {
                        i29 = i82 + 1;
                        cCharAt10 = strZzd.charAt(i82);
                        i17 = i2;
                        if (cCharAt10 < 55296) {
                            break;
                        }
                        i81 |= (cCharAt10 & 8191) << i83;
                        i83 += 13;
                        i82 = i29;
                        i2 = i17;
                    }
                    iCharAt12 = i81 | (cCharAt10 << i83);
                    i25 = i29;
                } else {
                    i17 = i2;
                    i25 = i80;
                }
                int i84 = i76 - 51;
                int i85 = i25;
                if (i84 == 9 || i84 == 17) {
                    i26 = i4 + 1;
                    int i86 = i67 / 3;
                    objArr[i86 + i86 + 1] = objArrZze[i4];
                } else {
                    if (i84 == 12) {
                        if (zzhkVar.zzc() == 1 || i78 != 0) {
                            i26 = i4 + 1;
                            int i87 = i67 / 3;
                            objArr[i87 + i87 + 1] = objArrZze[i4];
                        } else {
                            i78 = 0;
                        }
                    }
                    i27 = iCharAt12 + iCharAt12;
                    obj = objArrZze[i27];
                    if (obj instanceof Field) {
                        fieldZzz2 = (Field) obj;
                    } else {
                        fieldZzz2 = zzz(cls2, (String) obj);
                        objArrZze[i27] = fieldZzz2;
                    }
                    int iObjectFieldOffset3 = (int) unsafe.objectFieldOffset(fieldZzz2);
                    i28 = i27 + 1;
                    obj2 = objArrZze[i28];
                    int i88 = i78;
                    if (obj2 instanceof Field) {
                        fieldZzz3 = (Field) obj2;
                    } else {
                        fieldZzz3 = zzz(cls2, (String) obj2);
                        objArrZze[i28] = fieldZzz3;
                    }
                    i18 = i4;
                    i19 = i85;
                    iObjectFieldOffset2 = (int) unsafe.objectFieldOffset(fieldZzz3);
                    i20 = 0;
                    strZzd = strZzd;
                    zzhkVar = zzhkVar;
                    iObjectFieldOffset = iObjectFieldOffset3;
                    i21 = i88;
                }
                i4 = i26;
                i27 = iCharAt12 + iCharAt12;
                obj = objArrZze[i27];
                if (obj instanceof Field) {
                    fieldZzz2 = (Field) obj;
                } else {
                    fieldZzz2 = zzz(cls2, (String) obj);
                    objArrZze[i27] = fieldZzz2;
                }
                int iObjectFieldOffset4 = (int) unsafe.objectFieldOffset(fieldZzz2);
                i28 = i27 + 1;
                obj2 = objArrZze[i28];
                int i89 = i78;
                if (obj2 instanceof Field) {
                    fieldZzz3 = (Field) obj2;
                } else {
                    fieldZzz3 = zzz(cls2, (String) obj2);
                    objArrZze[i28] = fieldZzz3;
                }
                i18 = i4;
                i19 = i85;
                iObjectFieldOffset2 = (int) unsafe.objectFieldOffset(fieldZzz3);
                i20 = 0;
                strZzd = strZzd;
                zzhkVar = zzhkVar;
                iObjectFieldOffset = iObjectFieldOffset4;
                i21 = i89;
            } else {
                i17 = i2;
                i18 = i4 + 1;
                Field fieldZzz4 = zzz(cls2, (String) objArrZze[i4]);
                if (i76 == 9 || i76 == 17) {
                    int i90 = i67 / 3;
                    objArr[i90 + i90 + 1] = fieldZzz4.getType();
                } else {
                    if (i76 != 27) {
                        if (i76 == 49) {
                            i24 = i4 + 2;
                            i23 = 1;
                        } else if (i76 == 12 || i76 == 30 || i76 == 44) {
                            zzhkVar = zzhkVar;
                            if (zzhkVar.zzc() == 1 || i78 != 0) {
                                i24 = i4 + 2;
                                int i91 = i67 / 3;
                                objArr[i91 + i91 + 1] = objArrZze[i18];
                                i18 = i24;
                            } else {
                                i78 = 0;
                            }
                        } else if (i76 == 50) {
                            int i92 = i4 + 2;
                            int i93 = i64 + 1;
                            iArr[i64] = i67;
                            int i94 = i67 / 3;
                            int i95 = i94 + i94;
                            objArr[i95] = objArrZze[i18];
                            if (i78 != 0) {
                                i18 = i4 + 3;
                                objArr[i95 + 1] = objArrZze[i92];
                                i64 = i93;
                                zzhkVar = zzhkVar;
                            } else {
                                i18 = i92;
                                i64 = i93;
                                i78 = 0;
                            }
                        }
                        iObjectFieldOffset = (int) unsafe.objectFieldOffset(fieldZzz4);
                        iObjectFieldOffset2 = 1048575;
                        if ((iCharAt11 & l111l11l11Ill.l111l11111lIl) != 0 || i76 > 17) {
                            i19 = i16;
                            i20 = 0;
                        } else {
                            int i96 = i16 + 1;
                            int iCharAt13 = strZzd.charAt(i16);
                            if (iCharAt13 >= 55296) {
                                int i97 = iCharAt13 & 8191;
                                int i98 = 13;
                                while (true) {
                                    i22 = i96 + 1;
                                    cCharAt9 = strZzd.charAt(i96);
                                    if (cCharAt9 < 55296) {
                                        break;
                                    }
                                    i97 |= (cCharAt9 & 8191) << i98;
                                    i98 += 13;
                                    i96 = i22;
                                }
                                iCharAt13 = i97 | (cCharAt9 << i98);
                                i96 = i22;
                            }
                            int i99 = i6 + i6 + (iCharAt13 / 32);
                            Object obj3 = objArrZze[i99];
                            i19 = i96;
                            if (obj3 instanceof Field) {
                                fieldZzz = (Field) obj3;
                            } else {
                                fieldZzz = zzz(cls2, (String) obj3);
                                objArrZze[i99] = fieldZzz;
                            }
                            i20 = iCharAt13 % 32;
                            iObjectFieldOffset2 = (int) unsafe.objectFieldOffset(fieldZzz);
                        }
                        if (i76 >= 18 && i76 <= 49) {
                            iArr[i65] = iObjectFieldOffset;
                            i65++;
                        }
                        i21 = i78;
                    } else {
                        i23 = 1;
                        i24 = i4 + 2;
                    }
                    int i100 = i67 / 3;
                    objArr[i100 + i100 + i23] = objArrZze[i18];
                    i18 = i24;
                    iObjectFieldOffset = (int) unsafe.objectFieldOffset(fieldZzz4);
                    iObjectFieldOffset2 = 1048575;
                    if ((iCharAt11 & l111l11l11Ill.l111l11111lIl) != 0) {
                        i19 = i16;
                        i20 = 0;
                    } else {
                        i19 = i16;
                        i20 = 0;
                    }
                    if (i76 >= 18) {
                        iArr[i65] = iObjectFieldOffset;
                        i65++;
                    }
                    i21 = i78;
                }
                iObjectFieldOffset = (int) unsafe.objectFieldOffset(fieldZzz4);
                iObjectFieldOffset2 = 1048575;
                if ((iCharAt11 & l111l11l11Ill.l111l11111lIl) != 0) {
                    i19 = i16;
                    i20 = 0;
                } else {
                    i19 = i16;
                    i20 = 0;
                }
                if (i76 >= 18) {
                    iArr[i65] = iObjectFieldOffset;
                    i65++;
                }
                i21 = i78;
            }
            int i101 = i67 + 1;
            iArr3[i67] = iCharAt10;
            int i102 = i67 + 2;
            Class<?> cls3 = cls2;
            iArr3[i101] = iObjectFieldOffset | (i21 != 0 ? Integer.MIN_VALUE : 0) | ((iCharAt11 & 512) != 0 ? 536870912 : 0) | ((iCharAt11 & l1l11lI1l.l111l11111lIl) != 0 ? 268435456 : 0) | (i76 << 20);
            i67 += 3;
            iArr3[i102] = (i20 << 20) | iObjectFieldOffset2;
            strZzd = strZzd;
            i4 = i18;
            length = i77;
            i5 = i79;
            cls2 = cls3;
            zzhkVar = zzhkVar;
            i34 = i19;
            i2 = i17;
            c = 55296;
        }
        return new zzhe(iArr3, objArr, i2, i5, zzhkVar.zza(), false, iArr, i3, i62, zzhgVar, zzgkVar, zzibVar, zzfiVar, zzgwVar);
    }

    private static double zzm(Object obj, long j) {
        return ((Double) zzii.zzf(obj, j)).doubleValue();
    }

    private static float zzn(Object obj, long j) {
        return ((Float) zzii.zzf(obj, j)).floatValue();
    }

    private static int zzo(Object obj, long j) {
        return ((Integer) zzii.zzf(obj, j)).intValue();
    }

    private final int zzp(int i) {
        return this.zzc[i + 2];
    }

    private final int zzq(int i, int i2) {
        int[] iArr = this.zzc;
        int length = (iArr.length / 3) - 1;
        while (i2 <= length) {
            int i3 = (length + i2) >>> 1;
            int i4 = i3 * 3;
            int i5 = iArr[i4];
            if (i == i5) {
                return i4;
            }
            if (i < i5) {
                length = i3 - 1;
            } else {
                i2 = i3 + 1;
            }
        }
        return -1;
    }

    private static int zzr(int i) {
        return (i >>> 20) & 255;
    }

    private final int zzs(int i) {
        return this.zzc[i + 1];
    }

    private static long zzt(Object obj, long j) {
        return ((Long) zzii.zzf(obj, j)).longValue();
    }

    private final zzfx zzu(int i) {
        int i2 = i / 3;
        return (zzfx) this.zzd[i2 + i2 + 1];
    }

    private final zzhl zzv(int i) {
        Object[] objArr = this.zzd;
        int i2 = i / 3;
        int i3 = i2 + i2;
        zzhl zzhlVar = (zzhl) objArr[i3];
        if (zzhlVar != null) {
            return zzhlVar;
        }
        zzhl zzhlVarZzb = zzhi.zza().zzb((Class) objArr[i3 + 1]);
        objArr[i3] = zzhlVarZzb;
        return zzhlVarZzb;
    }

    private final Object zzw(int i) {
        int i2 = i / 3;
        return this.zzd[i2 + i2];
    }

    private final Object zzx(Object obj, int i) {
        zzhl zzhlVarZzv = zzv(i);
        int iZzs = zzs(i) & 1048575;
        if (!zzI(obj, i)) {
            return zzhlVarZzv.zze();
        }
        Object object = zzb.getObject(obj, iZzs);
        if (zzL(object)) {
            return object;
        }
        Object objZze = zzhlVarZzv.zze();
        if (object != null) {
            zzhlVarZzv.zzg(objZze, object);
        }
        return objZze;
    }

    private final Object zzy(Object obj, int i, int i2) {
        zzhl zzhlVarZzv = zzv(i2);
        if (!zzM(obj, i, i2)) {
            return zzhlVarZzv.zze();
        }
        Object object = zzb.getObject(obj, zzs(i2) & 1048575);
        if (zzL(object)) {
            return object;
        }
        Object objZze = zzhlVarZzv.zze();
        if (object != null) {
            zzhlVarZzv.zzg(objZze, object);
        }
        return objZze;
    }

    private static Field zzz(Class cls, String str) {
        try {
            return cls.getDeclaredField(str);
        } catch (NoSuchFieldException e) {
            Field[] declaredFields = cls.getDeclaredFields();
            for (Field field : declaredFields) {
                if (str.equals(field.getName())) {
                    return field;
                }
            }
            throw new RuntimeException("Field " + str + " for " + cls.getName() + " not found. Known fields are " + Arrays.toString(declaredFields), e);
        }
    }

    @Override
    public final int zza(Object obj) {
        int i;
        ?? r16;
        ?? r5;
        int iZzy;
        int iZzy2;
        int iZzy3;
        int iZzz;
        int iZzy4;
        int iZzy5;
        int iZzb;
        int iZzy6;
        ?? Zzh;
        int size;
        int iZzy7;
        int iZzb2;
        int iZzy8;
        int iZzb3;
        int iZzy9;
        ?? r3;
        int iZzi;
        int iZzy10;
        ?? Zzy;
        ?? Zzi;
        int iZzf;
        int iZzy11;
        int iZzy12;
        ?? r4;
        ?? r6;
        ?? r1;
        Unsafe unsafe = zzb;
        boolean z = false;
        int i2 = 1048575;
        ?? r2 = 0;
        int i3 = 0;
        int i4 = 0;
        int i5 = 1048575;
        while (true) {
            int[] iArr = this.zzc;
            if (i3 >= iArr.length) {
                int iZza = i4 + ((zzfu) obj).zzc.zza();
                if (!this.zzh) {
                    return iZza;
                }
                zzht zzhtVar = ((zzfr) obj).zzb.zza;
                int iZzc = zzhtVar.zzc();
                int iZzc2 = 0;
                for (int i6 = 0; i6 < iZzc; i6++) {
                    Map.Entry entryZzg = zzhtVar.zzg(i6);
                    iZzc2 += zzfm.zzc((zzfl) ((zzhp) entryZzg).zza(), entryZzg.getValue());
                }
                for (Map.Entry entry : zzhtVar.zzd()) {
                    iZzc2 += zzfm.zzc((zzfl) entry.getKey(), entry.getValue());
                }
                return iZza + iZzc2;
            }
            int iZzs = zzs(i3);
            int iZzr = zzr(iZzs);
            int i7 = iArr[i3];
            int i8 = iArr[i3 + 2];
            int i9 = i8 & i2;
            if (iZzr <= 17) {
                if (i9 != i5) {
                    r1 = i9 == i2 ? z : unsafe.getInt(obj, i9);
                    i5 = i9;
                }
                i = i5;
                r16 = r1;
                r5 = 1 << (i8 >>> 20);
            } else {
                r1 = r2;
                i = i5;
                r16 = r2 == true ? 1 : 0;
                r5 = z;
            }
            int i10 = iZzs & i2;
            if (iZzr >= zzfn.DOUBLE_LIST_PACKED.zza()) {
                zzfn.SINT64_LIST_PACKED.zza();
            }
            long j = i10;
            switch (iZzr) {
                case 0:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        iZzy = zzfc.zzy(i7 << 3);
                        Zzi = iZzy + 8;
                        i4 += Zzi;
                    }
                    break;
                case 1:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        iZzy2 = zzfc.zzy(i7 << 3);
                        Zzi = iZzy2 + 4;
                        i4 += Zzi;
                    }
                    break;
                case 2:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        long j2 = unsafe.getLong(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz(j2);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 3:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        long j3 = unsafe.getLong(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz(j3);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 4:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        long j4 = unsafe.getInt(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz(j4);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 5:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        iZzy = zzfc.zzy(i7 << 3);
                        Zzi = iZzy + 8;
                        i4 += Zzi;
                    }
                    break;
                case 6:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        iZzy2 = zzfc.zzy(i7 << 3);
                        Zzi = iZzy2 + 4;
                        i4 += Zzi;
                    }
                    break;
                case 7:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        iZzy4 = zzfc.zzy(i7 << 3);
                        Zzi = iZzy4 + 1;
                        i4 += Zzi;
                    }
                    break;
                case 8:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        int i11 = i7 << 3;
                        Object object = unsafe.getObject(obj, j);
                        if (object instanceof zzev) {
                            iZzy5 = zzfc.zzy(i11);
                            iZzb = ((zzev) object).zze();
                            iZzy6 = zzfc.zzy(iZzb);
                        } else {
                            iZzy5 = zzfc.zzy(i11);
                            iZzb = zzin.zzb((String) object);
                            iZzy6 = zzfc.zzy(iZzb);
                        }
                        Zzi = iZzy5 + iZzy6 + iZzb;
                        i4 += Zzi;
                    }
                    break;
                case 9:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        Zzi = zzhn.zzi(i7, unsafe.getObject(obj, j), zzv(i3));
                        i4 += Zzi;
                    }
                    break;
                case 10:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        zzev zzevVar = (zzev) unsafe.getObject(obj, j);
                        iZzy5 = zzfc.zzy(i7 << 3);
                        iZzb = zzevVar.zze();
                        iZzy6 = zzfc.zzy(iZzb);
                        Zzi = iZzy5 + iZzy6 + iZzb;
                        i4 += Zzi;
                    }
                    break;
                case 11:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        int i12 = unsafe.getInt(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzy(i12);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 12:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        long j5 = unsafe.getInt(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz(j5);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 13:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        iZzy2 = zzfc.zzy(i7 << 3);
                        Zzi = iZzy2 + 4;
                        i4 += Zzi;
                    }
                    break;
                case 14:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        iZzy = zzfc.zzy(i7 << 3);
                        Zzi = iZzy + 8;
                        i4 += Zzi;
                    }
                    break;
                case 15:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        int i13 = unsafe.getInt(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzy((i13 >> 31) ^ (i13 + i13));
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 16:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        long j6 = unsafe.getLong(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz((j6 >> 63) ^ (j6 + j6));
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 17:
                    if (zzJ(obj, i3, i, r16 == true ? 1 : 0, r5)) {
                        Zzi = zzhn.zza(i7, (zzhb) unsafe.getObject(obj, j), zzv(i3));
                        i4 += Zzi;
                    }
                    break;
                case 18:
                    Zzi = zzhn.zze(i7, (List) unsafe.getObject(obj, j), z);
                    i4 += Zzi;
                    break;
                case 19:
                    Zzi = zzhn.zzc(i7, (List) unsafe.getObject(obj, j), z);
                    i4 += Zzi;
                    break;
                case 20:
                    List list = (List) unsafe.getObject(obj, j);
                    int i14 = zzhn.zza;
                    if (list.size() == 0) {
                        Zzh = z;
                    } else {
                        Zzh = zzhn.zzh(list) + (list.size() * zzfc.zzy(i7 << 3));
                    }
                    i4 += Zzh;
                    break;
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                    List list2 = (List) unsafe.getObject(obj, j);
                    int i15 = zzhn.zza;
                    size = list2.size();
                    if (size == 0) {
                        Zzi = z;
                    } else {
                        iZzy3 = zzhn.zzm(list2);
                        iZzy7 = zzfc.zzy(i7 << 3);
                        iZzz = size * iZzy7;
                        Zzi = iZzy3 + iZzz;
                    }
                    i4 += Zzi;
                    break;
                case 22:
                    List list3 = (List) unsafe.getObject(obj, j);
                    int i16 = zzhn.zza;
                    size = list3.size();
                    if (size == 0) {
                        Zzi = z;
                    } else {
                        iZzy3 = zzhn.zzg(list3);
                        iZzy7 = zzfc.zzy(i7 << 3);
                        iZzz = size * iZzy7;
                        Zzi = iZzy3 + iZzz;
                    }
                    i4 += Zzi;
                    break;
                case ConnectionResult.API_DISABLED:
                    Zzi = zzhn.zze(i7, (List) unsafe.getObject(obj, j), z);
                    i4 += Zzi;
                    break;
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                    Zzi = zzhn.zzc(i7, (List) unsafe.getObject(obj, j), z);
                    i4 += Zzi;
                    break;
                case 25:
                    List list4 = (List) unsafe.getObject(obj, j);
                    int i17 = zzhn.zza;
                    int size2 = list4.size();
                    if (size2 == 0) {
                        Zzi = z;
                    } else {
                        Zzi = size2 * (zzfc.zzy(i7 << 3) + 1);
                    }
                    i4 += Zzi;
                    break;
                case 26:
                    ?? r0 = (List) unsafe.getObject(obj, j);
                    int i18 = zzhn.zza;
                    int size3 = r0.size();
                    if (size3 == 0) {
                        Zzh = z;
                    } else {
                        int iZzy13 = zzfc.zzy(i7 << 3) * size3;
                        if (r0 instanceof zzgj) {
                            zzgj zzgjVar = (zzgj) r0;
                            for (?? r7 = z; r7 < size3; r7++) {
                                Object objZza = zzgjVar.zza();
                                if (objZza instanceof zzev) {
                                    Zzh = iZzy13;
                                    iZzb3 = ((zzev) objZza).zze();
                                    iZzy9 = zzfc.zzy(iZzb3);
                                } else {
                                    Zzh = iZzy13;
                                    iZzb3 = zzin.zzb((String) objZza);
                                    iZzy9 = zzfc.zzy(iZzb3);
                                }
                                Zzh += iZzy9 + iZzb3;
                            }
                            Zzh = iZzy13;
                        } else {
                            for (?? r8 = z; r8 < size3; r8++) {
                                Object obj2 = r0.get(r8);
                                if (obj2 instanceof zzev) {
                                    Zzh = iZzy13;
                                    iZzb2 = ((zzev) obj2).zze();
                                    iZzy8 = zzfc.zzy(iZzb2);
                                } else {
                                    Zzh = iZzy13;
                                    iZzb2 = zzin.zzb((String) obj2);
                                    iZzy8 = zzfc.zzy(iZzb2);
                                }
                                Zzh += iZzy8 + iZzb2;
                            }
                            Zzh = iZzy13;
                        }
                    }
                    i4 += Zzh;
                    break;
                case 27:
                    ?? r9 = (List) unsafe.getObject(obj, j);
                    zzhl zzhlVarZzv = zzv(i3);
                    int i19 = zzhn.zza;
                    int size4 = r9.size();
                    if (size4 == 0) {
                        r3 = z;
                    } else {
                        int iZzy14 = zzfc.zzy(i7 << 3) * size4;
                        for (?? r10 = z; r10 < size4; r10++) {
                            Object obj3 = r9.get(r10);
                            if (obj3 instanceof zzgi) {
                                r3 = iZzy14;
                                iZzi = ((zzgi) obj3).zza();
                                iZzy10 = zzfc.zzy(iZzi);
                            } else {
                                r3 = iZzy14;
                                iZzi = ((zzeg) obj3).zzi(zzhlVarZzv);
                                iZzy10 = zzfc.zzy(iZzi);
                            }
                            r3 = (r3 == true ? 1 : 0) + iZzy10 + iZzi;
                        }
                        r3 = iZzy14;
                    }
                    i4 += r3;
                    break;
                case 28:
                    ?? r11 = (List) unsafe.getObject(obj, j);
                    int i20 = zzhn.zza;
                    int size5 = r11.size();
                    if (size5 == 0) {
                        Zzy = z;
                    } else {
                        Zzy = size5 * zzfc.zzy(i7 << 3);
                        for (?? r12 = z; r12 < r11.size(); r12++) {
                            int iZze = ((zzev) r11.get(r12)).zze();
                            Zzy += zzfc.zzy(iZze) + iZze;
                        }
                    }
                    i4 += Zzy;
                    break;
                case 29:
                    List list5 = (List) unsafe.getObject(obj, j);
                    int i21 = zzhn.zza;
                    size = list5.size();
                    if (size == 0) {
                        Zzi = z;
                    } else {
                        iZzy3 = zzhn.zzl(list5);
                        iZzy7 = zzfc.zzy(i7 << 3);
                        iZzz = size * iZzy7;
                        Zzi = iZzy3 + iZzz;
                    }
                    i4 += Zzi;
                    break;
                case l11l11lI1lll.l11l1111Il1l:
                    List list6 = (List) unsafe.getObject(obj, j);
                    int i22 = zzhn.zza;
                    size = list6.size();
                    if (size == 0) {
                        Zzi = z;
                    } else {
                        iZzy3 = zzhn.zzb(list6);
                        iZzy7 = zzfc.zzy(i7 << 3);
                        iZzz = size * iZzy7;
                        Zzi = iZzy3 + iZzz;
                    }
                    i4 += Zzi;
                    break;
                case 31:
                    Zzi = zzhn.zzc(i7, (List) unsafe.getObject(obj, j), z);
                    i4 += Zzi;
                    break;
                case 32:
                    Zzi = zzhn.zze(i7, (List) unsafe.getObject(obj, j), z);
                    i4 += Zzi;
                    break;
                case Encoder.DEFAULT_EC_PERCENT:
                    List list7 = (List) unsafe.getObject(obj, j);
                    int i23 = zzhn.zza;
                    size = list7.size();
                    if (size == 0) {
                        Zzi = z;
                    } else {
                        iZzy3 = zzhn.zzj(list7);
                        iZzy7 = zzfc.zzy(i7 << 3);
                        iZzz = size * iZzy7;
                        Zzi = iZzy3 + iZzz;
                    }
                    i4 += Zzi;
                    break;
                case 34:
                    List list8 = (List) unsafe.getObject(obj, j);
                    int i24 = zzhn.zza;
                    size = list8.size();
                    if (size == 0) {
                        Zzi = z;
                    } else {
                        iZzy3 = zzhn.zzk(list8);
                        iZzy7 = zzfc.zzy(i7 << 3);
                        iZzz = size * iZzy7;
                        Zzi = iZzy3 + iZzz;
                    }
                    i4 += Zzi;
                    break;
                case 35:
                    iZzf = zzhn.zzf((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 36:
                    iZzf = zzhn.zzd((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 37:
                    iZzf = zzhn.zzh((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 38:
                    iZzf = zzhn.zzm((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 39:
                    iZzf = zzhn.zzg((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 40:
                    iZzf = zzhn.zzf((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 41:
                    iZzf = zzhn.zzd((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 42:
                    List list9 = (List) unsafe.getObject(obj, j);
                    int i25 = zzhn.zza;
                    iZzf = list9.size();
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 43:
                    iZzf = zzhn.zzl((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 44:
                    iZzf = zzhn.zzb((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 45:
                    iZzf = zzhn.zzd((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 46:
                    iZzf = zzhn.zzf((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 47:
                    iZzf = zzhn.zzj((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 48:
                    iZzf = zzhn.zzk((List) unsafe.getObject(obj, j));
                    if (iZzf > 0) {
                        iZzy11 = zzfc.zzy(i7 << 3);
                        iZzy12 = zzfc.zzy(iZzf);
                        Zzy = iZzy11 + iZzy12 + iZzf;
                        i4 += Zzy;
                    }
                    break;
                case 49:
                    ?? r13 = (List) unsafe.getObject(obj, j);
                    zzhl zzhlVarZzv2 = zzv(i3);
                    int i26 = zzhn.zza;
                    int size6 = r13.size();
                    if (size6 == 0) {
                        r4 = z;
                    } else {
                        boolean z2 = z;
                        r4 = z2;
                        while (r6 < size6) {
                            r6 = z2;
                            int iZza2 = zzhn.zza(i7, (zzhb) r13.get(r6), zzhlVarZzv2);
                            r6++;
                            r4 = (r4 == true ? 1 : 0) + iZza2;
                        }
                        r6 = z2;
                    }
                    i4 += r4;
                    break;
                case l1l1l11Il.l11l111I11l:
                    zzgv zzgvVar = (zzgv) unsafe.getObject(obj, j);
                    zzgu zzguVar = (zzgu) zzw(i3);
                    if (zzgvVar.isEmpty()) {
                        Zzh = z;
                    } else {
                        Zzh = z;
                        for (Map.Entry entry2 : zzgvVar.entrySet()) {
                            Zzh += zzguVar.zza(i7, entry2.getKey(), entry2.getValue());
                        }
                    }
                    i4 += Zzh;
                    break;
                case 51:
                    if (zzM(obj, i7, i3)) {
                        iZzy = zzfc.zzy(i7 << 3);
                        Zzi = iZzy + 8;
                        i4 += Zzi;
                    }
                    break;
                case 52:
                    if (zzM(obj, i7, i3)) {
                        iZzy2 = zzfc.zzy(i7 << 3);
                        Zzi = iZzy2 + 4;
                        i4 += Zzi;
                    }
                    break;
                case 53:
                    if (zzM(obj, i7, i3)) {
                        long jZzt = zzt(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz(jZzt);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 54:
                    if (zzM(obj, i7, i3)) {
                        long jZzt2 = zzt(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz(jZzt2);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 55:
                    if (zzM(obj, i7, i3)) {
                        long jZzo = zzo(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz(jZzo);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 56:
                    if (zzM(obj, i7, i3)) {
                        iZzy = zzfc.zzy(i7 << 3);
                        Zzi = iZzy + 8;
                        i4 += Zzi;
                    }
                    break;
                case 57:
                    if (zzM(obj, i7, i3)) {
                        iZzy2 = zzfc.zzy(i7 << 3);
                        Zzi = iZzy2 + 4;
                        i4 += Zzi;
                    }
                    break;
                case 58:
                    if (zzM(obj, i7, i3)) {
                        iZzy4 = zzfc.zzy(i7 << 3);
                        Zzi = iZzy4 + 1;
                        i4 += Zzi;
                    }
                    break;
                case 59:
                    if (zzM(obj, i7, i3)) {
                        int i27 = i7 << 3;
                        Object object2 = unsafe.getObject(obj, j);
                        if (object2 instanceof zzev) {
                            iZzy5 = zzfc.zzy(i27);
                            iZzb = ((zzev) object2).zze();
                            iZzy6 = zzfc.zzy(iZzb);
                        } else {
                            iZzy5 = zzfc.zzy(i27);
                            iZzb = zzin.zzb((String) object2);
                            iZzy6 = zzfc.zzy(iZzb);
                        }
                        Zzi = iZzy5 + iZzy6 + iZzb;
                        i4 += Zzi;
                    }
                    break;
                case l11l111l11Il.l11l11l1llIl:
                    if (zzM(obj, i7, i3)) {
                        Zzi = zzhn.zzi(i7, unsafe.getObject(obj, j), zzv(i3));
                        i4 += Zzi;
                    }
                    break;
                case 61:
                    if (zzM(obj, i7, i3)) {
                        zzev zzevVar2 = (zzev) unsafe.getObject(obj, j);
                        iZzy5 = zzfc.zzy(i7 << 3);
                        iZzb = zzevVar2.zze();
                        iZzy6 = zzfc.zzy(iZzb);
                        Zzi = iZzy5 + iZzy6 + iZzb;
                        i4 += Zzi;
                    }
                    break;
                case 62:
                    if (zzM(obj, i7, i3)) {
                        int iZzo = zzo(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzy(iZzo);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 63:
                    if (zzM(obj, i7, i3)) {
                        long jZzo2 = zzo(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz(jZzo2);
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case UserMetadata.MAX_ATTRIBUTES:
                    if (zzM(obj, i7, i3)) {
                        iZzy2 = zzfc.zzy(i7 << 3);
                        Zzi = iZzy2 + 4;
                        i4 += Zzi;
                    }
                    break;
                case 65:
                    if (zzM(obj, i7, i3)) {
                        iZzy = zzfc.zzy(i7 << 3);
                        Zzi = iZzy + 8;
                        i4 += Zzi;
                    }
                    break;
                case 66:
                    if (zzM(obj, i7, i3)) {
                        int iZzo2 = zzo(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzy((iZzo2 >> 31) ^ (iZzo2 + iZzo2));
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 67:
                    if (zzM(obj, i7, i3)) {
                        long jZzt3 = zzt(obj, j);
                        iZzy3 = zzfc.zzy(i7 << 3);
                        iZzz = zzfc.zzz((jZzt3 >> 63) ^ (jZzt3 + jZzt3));
                        Zzi = iZzy3 + iZzz;
                        i4 += Zzi;
                    }
                    break;
                case 68:
                    if (zzM(obj, i7, i3)) {
                        Zzi = zzhn.zza(i7, (zzhb) unsafe.getObject(obj, j), zzv(i3));
                        i4 += Zzi;
                    }
                    break;
            }
            i3 += 3;
            i5 = i;
            r2 = r16;
            z = false;
            i2 = 1048575;
        }
    }

    @Override
    public final int zzb(Object obj) {
        int i;
        long jDoubleToLongBits;
        int iFloatToIntBits;
        int i2;
        int i3 = 0;
        int i4 = 0;
        while (true) {
            int[] iArr = this.zzc;
            if (i3 >= iArr.length) {
                int iHashCode = (i4 * 53) + ((zzfu) obj).zzc.hashCode();
                return this.zzh ? (iHashCode * 53) + ((zzfr) obj).zzb.zza.hashCode() : iHashCode;
            }
            int iZzs = zzs(i3);
            int i5 = 1048575 & iZzs;
            int iZzr = zzr(iZzs);
            int i6 = iArr[i3];
            long j = i5;
            int iHashCode2 = 37;
            switch (iZzr) {
                case 0:
                    i = i4 * 53;
                    jDoubleToLongBits = Double.doubleToLongBits(zzii.zza(obj, j));
                    byte[] bArr = zzga.zzb;
                    iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                    i4 = i + iFloatToIntBits;
                    break;
                case 1:
                    i = i4 * 53;
                    iFloatToIntBits = Float.floatToIntBits(zzii.zzb(obj, j));
                    i4 = i + iFloatToIntBits;
                    break;
                case 2:
                    i = i4 * 53;
                    jDoubleToLongBits = zzii.zzd(obj, j);
                    byte[] bArr2 = zzga.zzb;
                    iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                    i4 = i + iFloatToIntBits;
                    break;
                case 3:
                    i = i4 * 53;
                    jDoubleToLongBits = zzii.zzd(obj, j);
                    byte[] bArr3 = zzga.zzb;
                    iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                    i4 = i + iFloatToIntBits;
                    break;
                case 4:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzc(obj, j);
                    i4 = i + iFloatToIntBits;
                    break;
                case 5:
                    i = i4 * 53;
                    jDoubleToLongBits = zzii.zzd(obj, j);
                    byte[] bArr4 = zzga.zzb;
                    iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                    i4 = i + iFloatToIntBits;
                    break;
                case 6:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzc(obj, j);
                    i4 = i + iFloatToIntBits;
                    break;
                case 7:
                    i = i4 * 53;
                    iFloatToIntBits = zzga.zza(zzii.zzw(obj, j));
                    i4 = i + iFloatToIntBits;
                    break;
                case 8:
                    i = i4 * 53;
                    iFloatToIntBits = ((String) zzii.zzf(obj, j)).hashCode();
                    i4 = i + iFloatToIntBits;
                    break;
                case 9:
                    i2 = i4 * 53;
                    Object objZzf = zzii.zzf(obj, j);
                    if (objZzf != null) {
                        iHashCode2 = objZzf.hashCode();
                    }
                    i4 = i2 + iHashCode2;
                    break;
                case 10:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzf(obj, j).hashCode();
                    i4 = i + iFloatToIntBits;
                    break;
                case 11:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzc(obj, j);
                    i4 = i + iFloatToIntBits;
                    break;
                case 12:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzc(obj, j);
                    i4 = i + iFloatToIntBits;
                    break;
                case 13:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzc(obj, j);
                    i4 = i + iFloatToIntBits;
                    break;
                case 14:
                    i = i4 * 53;
                    jDoubleToLongBits = zzii.zzd(obj, j);
                    byte[] bArr5 = zzga.zzb;
                    iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                    i4 = i + iFloatToIntBits;
                    break;
                case 15:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzc(obj, j);
                    i4 = i + iFloatToIntBits;
                    break;
                case 16:
                    i = i4 * 53;
                    jDoubleToLongBits = zzii.zzd(obj, j);
                    byte[] bArr6 = zzga.zzb;
                    iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                    i4 = i + iFloatToIntBits;
                    break;
                case 17:
                    i2 = i4 * 53;
                    Object objZzf2 = zzii.zzf(obj, j);
                    if (objZzf2 != null) {
                        iHashCode2 = objZzf2.hashCode();
                    }
                    i4 = i2 + iHashCode2;
                    break;
                case 18:
                case 19:
                case 20:
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                case 22:
                case ConnectionResult.API_DISABLED:
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                case 25:
                case 26:
                case 27:
                case 28:
                case 29:
                case l11l11lI1lll.l11l1111Il1l:
                case 31:
                case 32:
                case Encoder.DEFAULT_EC_PERCENT:
                case 34:
                case 35:
                case 36:
                case 37:
                case 38:
                case 39:
                case 40:
                case 41:
                case 42:
                case 43:
                case 44:
                case 45:
                case 46:
                case 47:
                case 48:
                case 49:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzf(obj, j).hashCode();
                    i4 = i + iFloatToIntBits;
                    break;
                case l1l1l11Il.l11l111I11l:
                    i = i4 * 53;
                    iFloatToIntBits = zzii.zzf(obj, j).hashCode();
                    i4 = i + iFloatToIntBits;
                    break;
                case 51:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        jDoubleToLongBits = Double.doubleToLongBits(zzm(obj, j));
                        byte[] bArr7 = zzga.zzb;
                        iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 52:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = Float.floatToIntBits(zzn(obj, j));
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 53:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        jDoubleToLongBits = zzt(obj, j);
                        byte[] bArr8 = zzga.zzb;
                        iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 54:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        jDoubleToLongBits = zzt(obj, j);
                        byte[] bArr9 = zzga.zzb;
                        iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 55:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzo(obj, j);
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 56:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        jDoubleToLongBits = zzt(obj, j);
                        byte[] bArr10 = zzga.zzb;
                        iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 57:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzo(obj, j);
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 58:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzga.zza(zzN(obj, j));
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 59:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = ((String) zzii.zzf(obj, j)).hashCode();
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case l11l111l11Il.l11l11l1llIl:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzii.zzf(obj, j).hashCode();
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 61:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzii.zzf(obj, j).hashCode();
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 62:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzo(obj, j);
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 63:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzo(obj, j);
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case UserMetadata.MAX_ATTRIBUTES:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzo(obj, j);
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 65:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        jDoubleToLongBits = zzt(obj, j);
                        byte[] bArr11 = zzga.zzb;
                        iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 66:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzo(obj, j);
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 67:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        jDoubleToLongBits = zzt(obj, j);
                        byte[] bArr12 = zzga.zzb;
                        iFloatToIntBits = (int) (jDoubleToLongBits ^ (jDoubleToLongBits >>> 32));
                        i4 = i + iFloatToIntBits;
                    }
                    break;
                case 68:
                    if (zzM(obj, i6, i3)) {
                        i = i4 * 53;
                        iFloatToIntBits = zzii.zzf(obj, j).hashCode();
                        i4 = i + iFloatToIntBits;
                    }
                    break;
            }
            i3 += 3;
        }
    }

    final int zzc(Object obj, byte[] bArr, int i, int i2, int i3, zzej zzejVar) throws IOException {
        Object obj2;
        String str;
        Unsafe unsafe;
        zzfx zzfxVarZzu;
        int i4;
        int iZzj;
        int i5;
        int iZzq;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        zzfh zzfhVar;
        zzhb zzhbVar;
        int i12;
        int[] iArr;
        int i13;
        int i14;
        int iZzr;
        long j;
        int i15;
        int i16;
        int i17;
        int i18;
        int i19;
        int i20;
        int i21;
        int i22;
        zzhe<T> zzheVar;
        int i23;
        int i24;
        int iZzl;
        boolean z;
        int i25;
        int i26;
        zzhe<T> zzheVar2;
        int i27;
        int i28;
        zzhe<T> zzheVar3;
        Unsafe unsafe2;
        int i29;
        String str2;
        int i30;
        zzfz zzfzVarZzd;
        int size;
        int i31;
        long j2;
        boolean z2;
        int i32;
        int i33;
        int i34;
        zzfx zzfxVarZzu2;
        int i35;
        Unsafe unsafe3;
        Object object;
        int i36;
        zzgt zzgtVar;
        zzgv zzgvVar;
        Object obj3;
        long j3;
        zzfz zzfzVar;
        zzfz zzfzVar2;
        int i37;
        Unsafe unsafe4;
        int i38;
        String str3;
        int i39;
        zzhe<T> zzheVar4;
        zzfe zzfeVar;
        int iZzi;
        zzfe zzfeVar2;
        int i40;
        int i41;
        String str4;
        int i42;
        zzfo zzfoVar;
        int iZzi2;
        zzfo zzfoVar2;
        int i43;
        int i44;
        String str5;
        int i45;
        zzgp zzgpVar;
        int iZzi3;
        zzgp zzgpVar2;
        int i46;
        zzgp zzgpVar3;
        int iZzi4;
        zzgp zzgpVar4;
        int i47;
        int i48;
        zzfv zzfvVar;
        int iZzi5;
        zzfv zzfvVar2;
        int i49;
        int i50;
        zzel zzelVar;
        boolean z3;
        int iZzi6;
        boolean z4;
        zzel zzelVar2;
        int i51;
        boolean z5;
        int iZzi7;
        int i52;
        int i53;
        int iZzi8;
        int i54;
        int i55;
        int i56;
        Object obj4;
        int iZzi9;
        int i57;
        int iZzi10;
        int i58;
        int iZzi11;
        int i59;
        int iZzk;
        zzfx zzfxVarZzu3;
        zzib zzibVar;
        int i60;
        int i61;
        Iterator it;
        Object objZzo;
        int iIntValue;
        int size2;
        Object objZzo2;
        int i62;
        int i63;
        Integer num;
        int iIntValue2;
        int i64;
        zzfv zzfvVar3;
        int iZzi12;
        zzfv zzfvVar4;
        int i65;
        zzgp zzgpVar5;
        int iZzi13;
        zzgp zzgpVar6;
        int i66;
        int i67;
        zzhl zzhlVarZzv;
        int iZzi14;
        zzhe<T> zzheVar5 = this;
        Object obj5 = obj;
        i2 = i2;
        i3 = i3;
        zzA(obj);
        Unsafe unsafe5 = zzb;
        int iZzh = i;
        int i68 = -1;
        int i69 = 0;
        int i70 = 0;
        int i71 = 0;
        int i72 = 1048575;
        while (true) {
            if (iZzh < i2) {
                int i73 = iZzh + 1;
                int i74 = bArr[iZzh];
                if (i74 < 0) {
                    iZzj = zzek.zzj(i74, bArr, i73, zzejVar);
                    i4 = zzejVar.zza;
                } else {
                    i4 = i74;
                    iZzj = i73;
                }
                int i75 = i4 >>> 3;
                if (i75 > i68) {
                    iZzq = (i75 < zzheVar5.zze || i75 > zzheVar5.zzf) ? -1 : zzheVar5.zzq(i75, i69 / 3);
                } else {
                    if (i75 < zzheVar5.zze || i75 > zzheVar5.zzf) {
                        i5 = -1;
                        iZzq = -1;
                    } else {
                        iZzq = zzheVar5.zzq(i75, 0);
                    }
                    if (iZzq == i5) {
                        i12 = i4 & 7;
                        iArr = zzheVar5.zzc;
                        i13 = i4;
                        i14 = iArr[iZzq + 1];
                        str = "Failed to parse the message.";
                        iZzr = zzr(i14);
                        j = i14 & 1048575;
                        i15 = i75;
                        if (iZzr <= 17) {
                            int i76 = iArr[iZzq + 2];
                            i16 = 1 << (i76 >>> 20);
                            i17 = 1048575;
                            i18 = i76 & 1048575;
                            i19 = iZzj;
                            if (i18 != i72) {
                                if (i72 != 1048575) {
                                    unsafe5.putInt(obj5, i72, i71);
                                    i17 = 1048575;
                                }
                                if (i18 == i17) {
                                    i71 = 0;
                                } else {
                                    i71 = unsafe5.getInt(obj5, i18);
                                }
                            } else {
                                i18 = i72;
                            }
                            switch (iZzr) {
                                case 0:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 1) {
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        iZzh = i23 + 8;
                                        i71 |= i16;
                                        zzii.zzo(obj5, j, Double.longBitsToDouble(zzek.zzp(bArr, i23)));
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 1:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 5) {
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        iZzh = i23 + 4;
                                        i71 |= i16;
                                        zzii.zzp(obj5, j, Float.intBitsToFloat(zzek.zzb(bArr, i23)));
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 2:
                                case 3:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 0) {
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        i24 = i16 | i71;
                                        iZzl = zzek.zzl(bArr, i23, zzejVar);
                                        unsafe5.putLong(obj, j, zzejVar.zzb);
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i71 = i24;
                                        iZzh = iZzl;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 4:
                                case 11:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 0) {
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        i71 |= i16;
                                        iZzh = zzek.zzi(bArr, i23, zzejVar);
                                        unsafe5.putInt(obj5, j, zzejVar.zza);
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 5:
                                case 14:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 1) {
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        iZzl = i23 + 8;
                                        i24 = i16 | i71;
                                        unsafe5.putLong(obj, j, zzek.zzp(bArr, i23));
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i71 = i24;
                                        iZzh = iZzl;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 6:
                                case 13:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 5) {
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        iZzh = i23 + 4;
                                        i71 |= i16;
                                        unsafe5.putInt(obj5, j, zzek.zzb(bArr, i23));
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 7:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 0) {
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        i71 |= i16;
                                        iZzh = zzek.zzl(bArr, i23, zzejVar);
                                        if (zzejVar.zzb != 0) {
                                            z = true;
                                        } else {
                                            z = false;
                                        }
                                        zzii.zzm(obj5, j, z);
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 8:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 2) {
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        if ((i14 & 536870912) != 0) {
                                            i71 |= i16;
                                            iZzh = zzek.zzg(bArr, i23, zzejVar);
                                        } else {
                                            iZzh = zzek.zzi(bArr, i23, zzejVar);
                                            i25 = zzejVar.zza;
                                            if (i25 >= 0) {
                                                throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                            }
                                            int i77 = i71 | i16;
                                            if (i25 == 0) {
                                                zzejVar.zzc = "";
                                            } else {
                                                zzejVar.zzc = new String(bArr, iZzh, i25, zzga.zza);
                                                iZzh += i25;
                                            }
                                            i71 = i77;
                                        }
                                        unsafe5.putObject(obj5, j, zzejVar.zzc);
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 9:
                                    zzheVar = this;
                                    i20 = i18;
                                    i26 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 2) {
                                        Object objZzx = zzheVar.zzx(obj5, i10);
                                        iZzh = zzek.zzn(objZzx, zzheVar.zzv(i10), bArr, i26, i2, zzejVar);
                                        zzheVar.zzF(obj5, i10, objZzx);
                                        i70 = i22 == true ? 1 : 0;
                                        zzheVar5 = zzheVar;
                                        i71 |= i16;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                        i2 = i2;
                                    }
                                    i23 = i26;
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                    break;
                                case 10:
                                    zzheVar = this;
                                    i20 = i18;
                                    i26 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 2) {
                                        i23 = i26;
                                        zzheVar2 = zzheVar;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        i71 |= i16;
                                        iZzh = zzek.zza(bArr, i26, zzejVar);
                                        unsafe5.putObject(obj5, j, zzejVar.zzc);
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 12:
                                    i20 = i18;
                                    i21 = i19;
                                    i22 = i13 == true ? 1 : 0;
                                    i10 = iZzq;
                                    if (i12 == 0) {
                                        zzheVar2 = this;
                                        i23 = i21;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        iZzh = zzek.zzi(bArr, i21, zzejVar);
                                        i27 = zzejVar.zza;
                                        zzheVar = this;
                                        zzfx zzfxVarZzu4 = zzheVar.zzu(i10);
                                        if ((i14 & Integer.MIN_VALUE) != 0 || zzfxVarZzu4 == null || zzfxVarZzu4.zza(i27)) {
                                            i71 |= i16;
                                            unsafe5.putInt(obj5, j, i27);
                                        } else {
                                            zzd(obj).zzj(i22 == true ? 1 : 0, Long.valueOf(i27));
                                        }
                                        i70 = i22;
                                        zzheVar5 = zzheVar;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                    }
                                    break;
                                case 15:
                                    i20 = i18;
                                    i21 = i19;
                                    i22 = i13 == true ? 1 : 0;
                                    i10 = iZzq;
                                    if (i12 == 0) {
                                        zzheVar2 = this;
                                        i23 = i21;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        i71 |= i16;
                                        iZzh = zzek.zzi(bArr, i21, zzejVar);
                                        unsafe5.putInt(obj5, j, zzey.zzb(zzejVar.zza));
                                        i70 = i22 == true ? 1 : 0;
                                        i69 = i10;
                                        i72 = i20;
                                        i68 = i15;
                                        zzheVar5 = this;
                                    }
                                    break;
                                case 16:
                                    if (i12 == 0) {
                                        i20 = i18;
                                        i21 = i19;
                                        i22 = i13 == true ? 1 : 0;
                                        i10 = iZzq;
                                        zzheVar2 = this;
                                        i23 = i21;
                                        i3 = i3;
                                        obj2 = obj5;
                                        i11 = i22;
                                        i7 = i71;
                                        i6 = i23;
                                        unsafe = unsafe5;
                                        zzheVar5 = zzheVar2;
                                        i8 = i20;
                                        i9 = i15;
                                    } else {
                                        int i78 = i71 | i16;
                                        int iZzl2 = zzek.zzl(bArr, i19, zzejVar);
                                        i20 = i18;
                                        unsafe5.putLong(obj, j, zzey.zzc(zzejVar.zzb));
                                        i70 = i13 == true ? 1 : 0;
                                        i71 = i78;
                                        i69 = iZzq;
                                        iZzh = iZzl2;
                                        i72 = i20;
                                        i68 = i15;
                                        zzheVar5 = this;
                                    }
                                    break;
                                default:
                                    zzheVar = this;
                                    i20 = i18;
                                    i23 = i19;
                                    i10 = iZzq;
                                    i22 = i13 == true ? 1 : 0;
                                    if (i12 == 3) {
                                        Object objZzx2 = zzheVar.zzx(obj5, i10);
                                        iZzh = zzek.zzm(objZzx2, zzheVar.zzv(i10), bArr, i23, i2, (i15 << 3) | 4, zzejVar);
                                        zzheVar.zzF(obj5, i10, objZzx2);
                                        i70 = i22 == true ? 1 : 0;
                                        i71 |= i16;
                                        i69 = i10;
                                        zzheVar5 = zzheVar;
                                        i72 = i20;
                                        i68 = i15;
                                        i2 = i2;
                                    }
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                    break;
                            }
                        } else {
                            i28 = iZzj;
                            i10 = iZzq;
                            i8 = i72;
                            zzheVar3 = zzheVar5;
                            i7 = i71;
                            if (iZzr == 27) {
                                if (iZzr <= 49) {
                                    j3 = i14;
                                    zzfzVar = (zzfz) unsafe5.getObject(obj5, j);
                                    if (zzfzVar.zzc()) {
                                        zzfzVar2 = zzfzVar;
                                    } else {
                                        int size3 = zzfzVar.size();
                                        zzfz zzfzVarZzd2 = zzfzVar.zzd(size3 + size3);
                                        unsafe5.putObject(obj5, j, zzfzVarZzd2);
                                        zzfzVar2 = zzfzVarZzd2;
                                    }
                                    switch (iZzr) {
                                        case 18:
                                        case 35:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            str3 = str;
                                            i39 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                str = str3;
                                                if (i12 == 1) {
                                                    iZzh = i38 + 8;
                                                    int i79 = zzek.zza;
                                                    zzfeVar = (zzfe) zzfzVar2;
                                                    zzfeVar.zzf(Double.longBitsToDouble(zzek.zzp(bArr, i38)));
                                                    while (iZzh < i37) {
                                                        iZzi = zzek.zzi(bArr, iZzh, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            zzfeVar.zzf(Double.longBitsToDouble(zzek.zzp(bArr, iZzi)));
                                                            iZzh = iZzi + 8;
                                                        }
                                                    }
                                                }
                                                i45 = i39;
                                                str5 = str;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                int i80 = zzek.zza;
                                                zzfeVar2 = (zzfe) zzfzVar2;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                i40 = zzejVar.zza;
                                                i41 = iZzh + i40;
                                                if (i41 <= bArr.length) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                                zzfeVar2.zzg(zzfeVar2.size() + (i40 / 8));
                                                while (iZzh < i41) {
                                                    zzfeVar2.zzf(Double.longBitsToDouble(zzek.zzp(bArr, iZzh)));
                                                    iZzh += 8;
                                                    str3 = str3;
                                                }
                                                str = str3;
                                                if (iZzh != i41) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case 19:
                                        case 36:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            str4 = str;
                                            i42 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                if (i12 == 5) {
                                                    iZzh = i38 + 4;
                                                    int i81 = zzek.zza;
                                                    zzfoVar = (zzfo) zzfzVar2;
                                                    zzfoVar.zzf(Float.intBitsToFloat(zzek.zzb(bArr, i38)));
                                                    while (iZzh < i37) {
                                                        iZzi2 = zzek.zzi(bArr, iZzh, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            zzfoVar.zzf(Float.intBitsToFloat(zzek.zzb(bArr, iZzi2)));
                                                            iZzh = iZzi2 + 4;
                                                        }
                                                    }
                                                }
                                                str5 = str4;
                                                i45 = i42;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                int i82 = zzek.zza;
                                                zzfoVar2 = (zzfo) zzfzVar2;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                i43 = zzejVar.zza;
                                                i44 = iZzh + i43;
                                                if (i44 <= bArr.length) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                                zzfoVar2.zzg(zzfoVar2.size() + (i43 / 4));
                                                while (iZzh < i44) {
                                                    zzfoVar2.zzf(Float.intBitsToFloat(zzek.zzb(bArr, iZzh)));
                                                    iZzh += 4;
                                                }
                                                if (iZzh != i44) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                            }
                                            str5 = str4;
                                            i45 = i42;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case 20:
                                        case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                                        case 37:
                                        case 38:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            str4 = str;
                                            i42 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                if (i12 == 0) {
                                                    int i83 = zzek.zza;
                                                    zzgpVar = (zzgp) zzfzVar2;
                                                    iZzh = zzek.zzl(bArr, i38, zzejVar);
                                                    zzgpVar.zzf(zzejVar.zzb);
                                                    while (iZzh < i37) {
                                                        iZzi3 = zzek.zzi(bArr, iZzh, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            iZzh = zzek.zzl(bArr, iZzi3, zzejVar);
                                                            zzgpVar.zzf(zzejVar.zzb);
                                                        }
                                                    }
                                                }
                                                str5 = str4;
                                                i45 = i42;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                int i84 = zzek.zza;
                                                zzgpVar2 = (zzgp) zzfzVar2;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                i46 = zzejVar.zza + iZzh;
                                                while (iZzh < i46) {
                                                    iZzh = zzek.zzl(bArr, iZzh, zzejVar);
                                                    zzgpVar2.zzf(zzejVar.zzb);
                                                }
                                                if (iZzh != i46) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                            }
                                            str5 = str4;
                                            i45 = i42;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case 22:
                                        case 29:
                                        case 39:
                                        case 43:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            i39 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                iZzh = zzek.zzf(bArr, i38, zzfzVar2, zzejVar);
                                                i45 = i39;
                                                str5 = str;
                                            } else if (i12 == 0) {
                                                iZzh = zzek.zzk(i13 == true ? 1 : 0, bArr, i38, i2, zzfzVar2, zzejVar);
                                                i45 = i39;
                                                str5 = str;
                                            } else {
                                                i45 = i39;
                                                str5 = str;
                                                iZzh = i38;
                                            }
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case ConnectionResult.API_DISABLED:
                                        case 32:
                                        case 40:
                                        case 46:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            i39 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                if (i12 == 1) {
                                                    iZzh = i38 + 8;
                                                    int i85 = zzek.zza;
                                                    zzgpVar3 = (zzgp) zzfzVar2;
                                                    zzgpVar3.zzf(zzek.zzp(bArr, i38));
                                                    while (iZzh < i37) {
                                                        iZzi4 = zzek.zzi(bArr, iZzh, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            zzgpVar3.zzf(zzek.zzp(bArr, iZzi4));
                                                            iZzh = iZzi4 + 8;
                                                        }
                                                    }
                                                }
                                                i45 = i39;
                                                str5 = str;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                int i86 = zzek.zza;
                                                zzgpVar4 = (zzgp) zzfzVar2;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                i47 = zzejVar.zza;
                                                i48 = iZzh + i47;
                                                if (i48 <= bArr.length) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                                zzgpVar4.zzg(zzgpVar4.size() + (i47 / 8));
                                                while (iZzh < i48) {
                                                    zzgpVar4.zzf(zzek.zzp(bArr, iZzh));
                                                    iZzh += 8;
                                                }
                                                if (iZzh != i48) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                                        case 31:
                                        case 41:
                                        case 45:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            i39 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                if (i12 == 5) {
                                                    iZzh = i38 + 4;
                                                    int i87 = zzek.zza;
                                                    zzfvVar = (zzfv) zzfzVar2;
                                                    zzfvVar.zzg(zzek.zzb(bArr, i38));
                                                    while (iZzh < i37) {
                                                        iZzi5 = zzek.zzi(bArr, iZzh, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            zzfvVar.zzg(zzek.zzb(bArr, iZzi5));
                                                            iZzh = iZzi5 + 4;
                                                        }
                                                    }
                                                }
                                                i45 = i39;
                                                str5 = str;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                int i88 = zzek.zza;
                                                zzfvVar2 = (zzfv) zzfzVar2;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                i49 = zzejVar.zza;
                                                i50 = iZzh + i49;
                                                if (i50 <= bArr.length) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                                zzfvVar2.zzh(zzfvVar2.size() + (i49 / 4));
                                                while (iZzh < i50) {
                                                    zzfvVar2.zzg(zzek.zzb(bArr, iZzh));
                                                    iZzh += 4;
                                                }
                                                if (iZzh != i50) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case 25:
                                        case 42:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            i39 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                if (i12 == 0) {
                                                    int i89 = zzek.zza;
                                                    zzelVar = (zzel) zzfzVar2;
                                                    iZzh = zzek.zzl(bArr, i38, zzejVar);
                                                    if (zzejVar.zzb != 0) {
                                                        z3 = true;
                                                    } else {
                                                        z3 = false;
                                                    }
                                                    zzelVar.zze(z3);
                                                    while (iZzh < i37) {
                                                        iZzi6 = zzek.zzi(bArr, iZzh, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            iZzh = zzek.zzl(bArr, iZzi6, zzejVar);
                                                            if (zzejVar.zzb != 0) {
                                                                z4 = true;
                                                            } else {
                                                                z4 = false;
                                                            }
                                                            zzelVar.zze(z4);
                                                        }
                                                    }
                                                }
                                                i45 = i39;
                                                str5 = str;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                int i90 = zzek.zza;
                                                zzelVar2 = (zzel) zzfzVar2;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                i51 = zzejVar.zza + iZzh;
                                                while (iZzh < i51) {
                                                    iZzh = zzek.zzl(bArr, iZzh, zzejVar);
                                                    if (zzejVar.zzb != 0) {
                                                        z5 = true;
                                                    } else {
                                                        z5 = false;
                                                    }
                                                    zzelVar2.zze(z5);
                                                }
                                                if (iZzh != i51) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case 26:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            str = str;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                str5 = str;
                                                i45 = i15;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                if ((j3 & 536870912) == 0) {
                                                    iZzi7 = zzek.zzi(bArr, i38, zzejVar);
                                                    i56 = zzejVar.zza;
                                                    if (i56 >= 0) {
                                                        throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                    }
                                                    if (i56 == 0) {
                                                        obj4 = "";
                                                        zzfzVar2.add(obj4);
                                                    } else {
                                                        obj4 = r6;
                                                        zzfzVar2.add(new String(bArr, iZzi7, i56, zzga.zza));
                                                        iZzi7 += i56;
                                                    }
                                                    while (iZzi7 < i37) {
                                                        iZzi9 = zzek.zzi(bArr, iZzi7, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            iZzi7 = zzek.zzi(bArr, iZzi9, zzejVar);
                                                            i57 = zzejVar.zza;
                                                            if (i57 >= 0) {
                                                                throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                            }
                                                            if (i57 == 0) {
                                                                zzfzVar2.add(obj4);
                                                            } else {
                                                                zzfzVar2.add(new String(bArr, iZzi7, i57, zzga.zza));
                                                                iZzi7 += i57;
                                                            }
                                                        }
                                                    }
                                                } else {
                                                    str = str;
                                                    iZzi7 = zzek.zzi(bArr, i38, zzejVar);
                                                    i52 = zzejVar.zza;
                                                    if (i52 >= 0) {
                                                        throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                    }
                                                    if (i52 == 0) {
                                                        zzfzVar2.add(r6);
                                                    } else {
                                                        i53 = iZzi7 + i52;
                                                        if (zzin.zzc(bArr, iZzi7, i53)) {
                                                            throw new zzgc("Protocol message had invalid UTF-8.");
                                                        }
                                                        zzfzVar2.add(new String(bArr, iZzi7, i52, zzga.zza));
                                                        iZzi7 = i53;
                                                    }
                                                    while (iZzi7 < i37) {
                                                        iZzi8 = zzek.zzi(bArr, iZzi7, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            iZzi7 = zzek.zzi(bArr, iZzi8, zzejVar);
                                                            i54 = zzejVar.zza;
                                                            if (i54 >= 0) {
                                                                throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                            }
                                                            if (i54 == 0) {
                                                                zzfzVar2.add(r6);
                                                            } else {
                                                                i55 = iZzi7 + i54;
                                                                if (zzin.zzc(bArr, iZzi7, i55)) {
                                                                    throw new zzgc("Protocol message had invalid UTF-8.");
                                                                }
                                                                zzfzVar2.add(new String(bArr, iZzi7, i54, zzga.zza));
                                                                iZzi7 = i55;
                                                            }
                                                        }
                                                    }
                                                }
                                                iZzh = iZzi7;
                                                i45 = i15;
                                                str5 = str;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            }
                                            break;
                                        case 27:
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            i39 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                iZzh = zzek.zze(zzheVar4.zzv(i10), i13 == true ? 1 : 0, bArr, i38, i2, zzfzVar2, zzejVar);
                                                i37 = i2;
                                                str5 = str;
                                                i45 = i39;
                                            } else {
                                                i37 = i2;
                                                i45 = i39;
                                                str5 = str;
                                                iZzh = i38;
                                            }
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case 28:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            i39 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 2) {
                                                iZzi10 = zzek.zzi(bArr, i38, zzejVar);
                                                i58 = zzejVar.zza;
                                                if (i58 >= 0) {
                                                    throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                }
                                                if (i58 <= bArr.length - iZzi10) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                                if (i58 == 0) {
                                                    zzfzVar2.add(zzev.zza);
                                                } else {
                                                    zzfzVar2.add(zzev.zzk(bArr, iZzi10, i58));
                                                    iZzi10 += i58;
                                                }
                                                while (iZzi10 < i37) {
                                                    iZzi11 = zzek.zzi(bArr, iZzi10, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        iZzh = iZzi10;
                                                        i45 = i39;
                                                        str5 = str;
                                                        if (iZzh != i38) {
                                                            i3 = i3;
                                                            obj2 = obj5;
                                                            i11 = i13 == true ? 1 : 0;
                                                            i6 = iZzh;
                                                            zzheVar5 = zzheVar4;
                                                            unsafe = unsafe4;
                                                            str = str5;
                                                            i9 = i45;
                                                        } else {
                                                            i3 = i3;
                                                            i70 = i13 == true ? 1 : 0;
                                                            i2 = i37;
                                                            zzheVar5 = zzheVar4;
                                                            i69 = i10;
                                                            i71 = i7;
                                                            i72 = i8;
                                                            unsafe5 = unsafe4;
                                                            i68 = i45;
                                                        }
                                                        break;
                                                    } else {
                                                        iZzi10 = zzek.zzi(bArr, iZzi11, zzejVar);
                                                        i59 = zzejVar.zza;
                                                        if (i59 >= 0) {
                                                            throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                        }
                                                        if (i59 <= bArr.length - iZzi10) {
                                                            throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                        }
                                                        if (i59 == 0) {
                                                            zzfzVar2.add(zzev.zza);
                                                        } else {
                                                            zzfzVar2.add(zzev.zzk(bArr, iZzi10, i59));
                                                            iZzi10 += i59;
                                                        }
                                                    }
                                                }
                                                iZzh = iZzi10;
                                                i45 = i39;
                                                str5 = str;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case l11l11lI1lll.l11l1111Il1l:
                                        case 44:
                                            i37 = i2;
                                            i38 = i28;
                                            if (i12 == 2) {
                                                iZzk = zzek.zzf(bArr, i38, zzfzVar2, zzejVar);
                                            } else if (i12 == 0) {
                                                unsafe4 = unsafe5;
                                                zzheVar4 = this;
                                                str5 = str;
                                                i45 = i15;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                iZzk = zzek.zzk(i13 == true ? 1 : 0, bArr, i38, i2, zzfzVar2, zzejVar);
                                            }
                                            zzfxVarZzu3 = zzu(i10);
                                            zzibVar = this.zzl;
                                            int i91 = zzhn.zza;
                                            if (zzfxVarZzu3 != null) {
                                                i60 = iZzk;
                                                unsafe4 = unsafe5;
                                                i61 = i15;
                                            } else if (zzfzVar2 instanceof RandomAccess) {
                                                size2 = zzfzVar2.size();
                                                i60 = iZzk;
                                                objZzo2 = null;
                                                i62 = 0;
                                                i63 = 0;
                                                while (i62 < size2) {
                                                    num = (Integer) zzfzVar2.get(i62);
                                                    Unsafe unsafe6 = unsafe5;
                                                    iIntValue2 = num.intValue();
                                                    if (zzfxVarZzu3.zza(iIntValue2)) {
                                                        if (i62 != i63) {
                                                            zzfzVar2.set(i63, num);
                                                        }
                                                        i63++;
                                                        i64 = i15;
                                                    } else {
                                                        i64 = i15;
                                                        objZzo2 = zzhn.zzo(obj5, i64, iIntValue2, objZzo2, zzibVar);
                                                    }
                                                    i62++;
                                                    i15 = i64;
                                                    unsafe5 = unsafe6;
                                                }
                                                unsafe4 = unsafe5;
                                                i61 = i15;
                                                if (i63 != size2) {
                                                    zzfzVar2.subList(i63, size2).clear();
                                                }
                                            } else {
                                                i60 = iZzk;
                                                unsafe4 = unsafe5;
                                                i61 = i15;
                                                it = zzfzVar2.iterator();
                                                objZzo = null;
                                                while (it.hasNext()) {
                                                    iIntValue = ((Integer) it.next()).intValue();
                                                    if (!zzfxVarZzu3.zza(iIntValue)) {
                                                        objZzo = zzhn.zzo(obj5, i61, iIntValue, objZzo, zzibVar);
                                                        it.remove();
                                                    }
                                                }
                                            }
                                            zzheVar4 = this;
                                            i45 = i61;
                                            iZzh = i60;
                                            str5 = str;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case Encoder.DEFAULT_EC_PERCENT:
                                        case 47:
                                            i37 = i2;
                                            i38 = i28;
                                            if (i12 == 2) {
                                                if (i12 == 0) {
                                                    int i92 = zzek.zza;
                                                    zzfvVar3 = (zzfv) zzfzVar2;
                                                    iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                    zzfvVar3.zzg(zzey.zzb(zzejVar.zza));
                                                    while (iZzh < i37) {
                                                        iZzi12 = zzek.zzi(bArr, iZzh, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            iZzh = zzek.zzi(bArr, iZzi12, zzejVar);
                                                            zzfvVar3.zzg(zzey.zzb(zzejVar.zza));
                                                        }
                                                    }
                                                }
                                                unsafe4 = unsafe5;
                                                str5 = str;
                                                i45 = i15;
                                                zzheVar4 = this;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                            } else {
                                                int i93 = zzek.zza;
                                                zzfvVar4 = (zzfv) zzfzVar2;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                i65 = zzejVar.zza + iZzh;
                                                while (iZzh < i65) {
                                                    iZzh = zzek.zzi(bArr, iZzh, zzejVar);
                                                    zzfvVar4.zzg(zzey.zzb(zzejVar.zza));
                                                }
                                                if (iZzh != i65) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                            }
                                            unsafe4 = unsafe5;
                                            str5 = str;
                                            i45 = i15;
                                            zzheVar4 = this;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        case 34:
                                        case 48:
                                            if (i12 == 2) {
                                                i38 = i28;
                                                if (i12 == 0) {
                                                    i37 = i2;
                                                    unsafe4 = unsafe5;
                                                    str5 = str;
                                                    i45 = i15;
                                                    zzheVar4 = this;
                                                    iZzh = i38;
                                                    if (iZzh != i38) {
                                                        i3 = i3;
                                                        obj2 = obj5;
                                                        i11 = i13 == true ? 1 : 0;
                                                        i6 = iZzh;
                                                        zzheVar5 = zzheVar4;
                                                        unsafe = unsafe4;
                                                        str = str5;
                                                        i9 = i45;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i13 == true ? 1 : 0;
                                                        i2 = i37;
                                                        zzheVar5 = zzheVar4;
                                                        i69 = i10;
                                                        i71 = i7;
                                                        i72 = i8;
                                                        unsafe5 = unsafe4;
                                                        i68 = i45;
                                                    }
                                                    break;
                                                } else {
                                                    int i94 = zzek.zza;
                                                    zzgpVar5 = (zzgp) zzfzVar2;
                                                    iZzh = zzek.zzl(bArr, i38, zzejVar);
                                                    zzgpVar5.zzf(zzey.zzc(zzejVar.zzb));
                                                    i37 = i2;
                                                    while (iZzh < i37) {
                                                        iZzi13 = zzek.zzi(bArr, iZzh, zzejVar);
                                                        if (i13 == zzejVar.zza) {
                                                            iZzh = zzek.zzl(bArr, iZzi13, zzejVar);
                                                            zzgpVar5.zzf(zzey.zzc(zzejVar.zzb));
                                                        }
                                                    }
                                                }
                                            } else {
                                                int i95 = zzek.zza;
                                                zzgpVar6 = (zzgp) zzfzVar2;
                                                i38 = i28;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                i66 = zzejVar.zza + iZzh;
                                                while (iZzh < i66) {
                                                    iZzh = zzek.zzl(bArr, iZzh, zzejVar);
                                                    zzgpVar6.zzf(zzey.zzc(zzejVar.zzb));
                                                }
                                                if (iZzh == i66) {
                                                    throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                }
                                                i37 = i2;
                                            }
                                            unsafe4 = unsafe5;
                                            str5 = str;
                                            i45 = i15;
                                            zzheVar4 = this;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                        default:
                                            i37 = i2;
                                            unsafe4 = unsafe5;
                                            i38 = i28;
                                            i39 = i15;
                                            zzheVar4 = this;
                                            if (i12 == 3) {
                                                i67 = ((i13 == true ? 1 : 0) & (-8)) | 4;
                                                zzhlVarZzv = zzheVar4.zzv(i10);
                                                str5 = str;
                                                i45 = i39;
                                                iZzh = zzek.zzc(zzhlVarZzv, bArr, i38, i2, i67, zzejVar);
                                                zzfzVar2.add(zzejVar.zzc);
                                                while (iZzh < i37) {
                                                    iZzi14 = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        iZzh = zzek.zzc(zzhlVarZzv, bArr, iZzi14, i2, i67, zzejVar);
                                                        zzfzVar2.add(zzejVar.zzc);
                                                    }
                                                }
                                            } else {
                                                i45 = i39;
                                                str5 = str;
                                                iZzh = i38;
                                            }
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                            break;
                                    }
                                } else {
                                    unsafe2 = unsafe5;
                                    i30 = i15;
                                    i29 = i28;
                                    i2 = i2;
                                    if (iZzr == 50) {
                                        unsafe = unsafe2;
                                        j2 = iArr[i10 + 2] & 1048575;
                                        switch (iZzr) {
                                            case 51:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i10 = i10;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 1) {
                                                    iZzh = i29 + 8;
                                                    unsafe.putObject(obj2, j, Double.valueOf(Double.longBitsToDouble(zzek.zzp(bArr, i29))));
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    iZzh = i29;
                                                }
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 52:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i10 = i10;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 5) {
                                                    iZzh = i29 + 4;
                                                    unsafe.putObject(obj2, j, Float.valueOf(Float.intBitsToFloat(zzek.zzb(bArr, i29))));
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    iZzh = i29;
                                                }
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 53:
                                            case 54:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i10 = i10;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 0) {
                                                    iZzh = zzek.zzl(bArr, i29, zzejVar);
                                                    unsafe.putObject(obj2, j, Long.valueOf(zzejVar.zzb));
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    iZzh = i29;
                                                }
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 55:
                                            case 62:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i10 = i10;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 0) {
                                                    iZzh = zzek.zzi(bArr, i29, zzejVar);
                                                    unsafe.putObject(obj2, j, Integer.valueOf(zzejVar.zza));
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    iZzh = i29;
                                                }
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 56:
                                            case 65:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i10 = i10;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 1) {
                                                    iZzh = i29 + 8;
                                                    unsafe.putObject(obj2, j, Long.valueOf(zzek.zzp(bArr, i29)));
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    iZzh = i29;
                                                }
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 57:
                                            case UserMetadata.MAX_ATTRIBUTES:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i10 = i10;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 5) {
                                                    iZzh = i29 + 4;
                                                    unsafe.putObject(obj2, j, Integer.valueOf(zzek.zzb(bArr, i29)));
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    iZzh = i29;
                                                }
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 58:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i10 = i10;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 0) {
                                                    iZzh = zzek.zzl(bArr, i29, zzejVar);
                                                    if (zzejVar.zzb != 0) {
                                                        z2 = true;
                                                    } else {
                                                        z2 = false;
                                                    }
                                                    unsafe.putObject(obj2, j, Boolean.valueOf(z2));
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    iZzh = i29;
                                                }
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 59:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 2) {
                                                    iZzh = zzek.zzi(bArr, i29, zzejVar);
                                                    i32 = zzejVar.zza;
                                                    if (i32 == 0) {
                                                        unsafe.putObject(obj2, j, "");
                                                    } else {
                                                        i33 = iZzh + i32;
                                                        if ((i14 & 536870912) == 0 && !zzin.zzc(bArr, iZzh, i33)) {
                                                            throw new zzgc("Protocol message had invalid UTF-8.");
                                                        }
                                                        unsafe.putObject(obj2, j, new String(bArr, iZzh, i32, zzga.zza));
                                                        iZzh = i33;
                                                    }
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    i10 = i10;
                                                    iZzh = i29;
                                                }
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case l11l111l11Il.l11l11l1llIl:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 2) {
                                                    Object objZzy = zzheVar5.zzy(obj2, i9, i10);
                                                    iZzh = zzek.zzn(objZzy, zzheVar5.zzv(i10), bArr, i29, i2, zzejVar);
                                                    zzheVar5.zzG(obj2, i9, i10, objZzy);
                                                    i10 = i10;
                                                    if (iZzh != i29) {
                                                        i3 = i3;
                                                        i6 = iZzh;
                                                        i10 = i10;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i11 == true ? 1 : 0;
                                                        i68 = i9;
                                                        i69 = i10;
                                                    }
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe;
                                                    obj5 = obj2;
                                                    i2 = i2;
                                                }
                                                i10 = i10;
                                                iZzh = i29;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 61:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 2) {
                                                    int iZza = zzek.zza(bArr, i29, zzejVar);
                                                    unsafe.putObject(obj2, j, zzejVar.zzc);
                                                    unsafe.putInt(obj2, j2, i9);
                                                    iZzh = iZza;
                                                    i10 = i10;
                                                    if (iZzh != i29) {
                                                        i3 = i3;
                                                        i6 = iZzh;
                                                        i10 = i10;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i11 == true ? 1 : 0;
                                                        i68 = i9;
                                                        i69 = i10;
                                                    }
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe;
                                                    obj5 = obj2;
                                                    i2 = i2;
                                                }
                                                i10 = i10;
                                                iZzh = i29;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 63:
                                                obj2 = obj;
                                                str = str;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 0) {
                                                    i11 = i13 == true ? 1 : 0;
                                                    i10 = i10;
                                                    iZzh = i29;
                                                    if (iZzh != i29) {
                                                        i3 = i3;
                                                        i6 = iZzh;
                                                        i10 = i10;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i11 == true ? 1 : 0;
                                                        i68 = i9;
                                                        i69 = i10;
                                                    }
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe;
                                                    obj5 = obj2;
                                                    i2 = i2;
                                                } else {
                                                    iZzh = zzek.zzi(bArr, i29, zzejVar);
                                                    i34 = zzejVar.zza;
                                                    zzfxVarZzu2 = zzheVar5.zzu(i10);
                                                    if (zzfxVarZzu2 != null || zzfxVarZzu2.zza(i34)) {
                                                        i11 = i13 == true ? 1 : 0;
                                                        unsafe.putObject(obj2, j, Integer.valueOf(i34));
                                                        unsafe.putInt(obj2, j2, i9);
                                                    } else {
                                                        zzic zzicVarZzd = zzd(obj);
                                                        Long lValueOf = Long.valueOf(i34);
                                                        i11 = i13 == true ? 1 : 0;
                                                        zzicVarZzd.zzj(i11 == true ? 1 : 0, lValueOf);
                                                    }
                                                    i10 = i10;
                                                    if (iZzh != i29) {
                                                        i3 = i3;
                                                        i6 = iZzh;
                                                        i10 = i10;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i11 == true ? 1 : 0;
                                                        i68 = i9;
                                                        i69 = i10;
                                                    }
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe;
                                                    obj5 = obj2;
                                                    i2 = i2;
                                                }
                                                break;
                                            case 66:
                                                obj2 = obj;
                                                i35 = i13 == true ? 1 : 0;
                                                str = str;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 0) {
                                                    iZzh = zzek.zzi(bArr, i29, zzejVar);
                                                    unsafe.putObject(obj2, j, Integer.valueOf(zzey.zzb(zzejVar.zza)));
                                                    unsafe.putInt(obj2, j2, i9);
                                                    i10 = i10;
                                                    i11 = i35;
                                                    if (iZzh != i29) {
                                                        i3 = i3;
                                                        i6 = iZzh;
                                                        i10 = i10;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i11 == true ? 1 : 0;
                                                        i68 = i9;
                                                        i69 = i10;
                                                    }
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe;
                                                    obj5 = obj2;
                                                    i2 = i2;
                                                }
                                                i10 = i10;
                                                i11 = i35;
                                                iZzh = i29;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 67:
                                                obj2 = obj;
                                                i35 = i13 == true ? 1 : 0;
                                                str = str;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                if (i12 == 0) {
                                                    int iZzl3 = zzek.zzl(bArr, i29, zzejVar);
                                                    unsafe.putObject(obj2, j, Long.valueOf(zzey.zzc(zzejVar.zzb)));
                                                    unsafe.putInt(obj2, j2, i9);
                                                    iZzh = iZzl3;
                                                    i10 = i10;
                                                    i11 = i35;
                                                    if (iZzh != i29) {
                                                        i3 = i3;
                                                        i6 = iZzh;
                                                        i10 = i10;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i11 == true ? 1 : 0;
                                                        i68 = i9;
                                                        i69 = i10;
                                                    }
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe;
                                                    obj5 = obj2;
                                                    i2 = i2;
                                                }
                                                i10 = i10;
                                                i11 = i35;
                                                iZzh = i29;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                            case 68:
                                                if (i12 == 3) {
                                                    obj2 = obj;
                                                    i35 = i13 == true ? 1 : 0;
                                                    str = str;
                                                    i9 = i30;
                                                    zzheVar5 = this;
                                                    i10 = i10;
                                                    i11 = i35;
                                                    iZzh = i29;
                                                    if (iZzh != i29) {
                                                        i3 = i3;
                                                        i6 = iZzh;
                                                        i10 = i10;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i11 == true ? 1 : 0;
                                                        i68 = i9;
                                                        i69 = i10;
                                                    }
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe;
                                                    obj5 = obj2;
                                                    i2 = i2;
                                                } else {
                                                    int i96 = ((i13 == true ? 1 : 0) & (-8)) | 4;
                                                    Object objZzy2 = zzy(obj, i30, i10);
                                                    zzhl zzhlVarZzv2 = zzv(i10);
                                                    str = str;
                                                    i9 = i30;
                                                    obj2 = obj;
                                                    i35 = i13 == true ? 1 : 0;
                                                    zzheVar5 = this;
                                                    iZzh = zzek.zzm(objZzy2, zzhlVarZzv2, bArr, i29, i2, i96, zzejVar);
                                                    zzheVar5.zzG(obj2, i9, i10, objZzy2);
                                                    i10 = i10;
                                                    i11 = i35;
                                                    if (iZzh != i29) {
                                                        i3 = i3;
                                                        i6 = iZzh;
                                                        i10 = i10;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i11 == true ? 1 : 0;
                                                        i68 = i9;
                                                        i69 = i10;
                                                    }
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe;
                                                    obj5 = obj2;
                                                    i2 = i2;
                                                }
                                                break;
                                            default:
                                                obj2 = obj;
                                                i11 = i13 == true ? 1 : 0;
                                                str = str;
                                                i10 = i10;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                iZzh = i29;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                                break;
                                        }
                                    } else if (i12 == 2) {
                                        Object objZzw = zzw(i10);
                                        unsafe3 = unsafe2;
                                        object = unsafe3.getObject(obj5, j);
                                        if (!((zzgv) object).zze()) {
                                            zzgv zzgvVarZzb = zzgv.zza().zzb();
                                            zzgw.zza(zzgvVarZzb, object);
                                            unsafe3.putObject(obj5, j, zzgvVarZzb);
                                            object = zzgvVarZzb;
                                        }
                                        zzgt zzgtVarZzc = ((zzgu) objZzw).zzc();
                                        zzgv zzgvVar2 = (zzgv) object;
                                        int iZzi15 = zzek.zzi(bArr, i29, zzejVar);
                                        i36 = zzejVar.zza;
                                        if (i36 >= 0 || i36 > i2 - iZzi15) {
                                            throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                        }
                                        int i97 = iZzi15 + i36;
                                        Object obj6 = zzgtVarZzc.zzb;
                                        Object obj7 = zzgtVarZzc.zzd;
                                        Object obj8 = obj6;
                                        Object obj9 = obj7;
                                        while (iZzi15 < i97) {
                                            Object obj10 = obj9;
                                            int iZzj2 = iZzi15 + 1;
                                            int i98 = bArr[iZzi15];
                                            if (i98 < 0) {
                                                iZzj2 = zzek.zzj(i98, bArr, iZzj2, zzejVar);
                                                i98 = zzejVar.zza;
                                            }
                                            Object obj11 = obj8;
                                            int i99 = i98 >>> 3;
                                            zzgv zzgvVar3 = zzgvVar2;
                                            int i100 = i98 & 7;
                                            Unsafe unsafe7 = unsafe3;
                                            if (i99 != 1) {
                                                if (i99 == 2) {
                                                    zzir zzirVar = zzgtVarZzc.zzc;
                                                    if (i100 == zzirVar.zza()) {
                                                        obj3 = obj7;
                                                        zzgvVar = zzgvVar3;
                                                        zzgtVar = zzgtVarZzc;
                                                        iZzi15 = zzO(bArr, iZzj2, i2, zzirVar, obj7.getClass(), zzejVar);
                                                        obj9 = zzejVar.zzc;
                                                        obj8 = obj11;
                                                    }
                                                }
                                                zzgtVar = zzgtVarZzc;
                                                zzgvVar = zzgvVar3;
                                                obj3 = obj7;
                                                iZzi15 = zzek.zzo(i98, bArr, iZzj2, i2, zzejVar);
                                                obj8 = obj11;
                                                obj9 = obj10;
                                            } else {
                                                zzgtVar = zzgtVarZzc;
                                                zzgvVar = zzgvVar3;
                                                obj3 = obj7;
                                                zzir zzirVar2 = zzgtVar.zza;
                                                if (i100 == zzirVar2.zza()) {
                                                    iZzi15 = zzO(bArr, iZzj2, i2, zzirVar2, null, zzejVar);
                                                    obj8 = zzejVar.zzc;
                                                    obj9 = obj10;
                                                } else {
                                                    iZzi15 = zzek.zzo(i98, bArr, iZzj2, i2, zzejVar);
                                                    obj8 = obj11;
                                                    obj9 = obj10;
                                                }
                                            }
                                            zzgvVar2 = zzgvVar;
                                            zzgtVarZzc = zzgtVar;
                                            obj7 = obj3;
                                            unsafe3 = unsafe7;
                                        }
                                        Object obj12 = obj9;
                                        Object obj13 = obj8;
                                        Unsafe unsafe8 = unsafe3;
                                        zzgv zzgvVar4 = zzgvVar2;
                                        if (iZzi15 != i97) {
                                            throw new zzgc(str);
                                        }
                                        zzgvVar4.put(obj13, obj12);
                                        if (i97 != i29) {
                                            obj5 = obj;
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i69 = i10;
                                            iZzh = i97;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe8;
                                            i68 = i30;
                                            zzheVar5 = this;
                                        } else {
                                            obj2 = obj;
                                            i3 = i3;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = i97;
                                            unsafe = unsafe8;
                                            str = str;
                                            i9 = i30;
                                            zzheVar5 = this;
                                        }
                                    } else {
                                        str2 = str;
                                        obj2 = obj;
                                        i11 = i13 == true ? 1 : 0;
                                        i6 = i29;
                                        str = str2;
                                        unsafe = unsafe2;
                                        i9 = i30;
                                        zzheVar5 = this;
                                        i3 = i3;
                                    }
                                }
                            } else if (i12 == 2) {
                                zzfzVarZzd = (zzfz) unsafe5.getObject(obj5, j);
                                if (!zzfzVarZzd.zzc()) {
                                    size = zzfzVarZzd.size();
                                    if (size == 0) {
                                        i31 = 10;
                                    } else {
                                        i31 = size + size;
                                    }
                                    zzfzVarZzd = zzfzVarZzd.zzd(i31);
                                    unsafe5.putObject(obj5, j, zzfzVarZzd);
                                }
                                iZzh = zzek.zze(zzheVar3.zzv(i10), i13 == true ? 1 : 0, bArr, i28, i2, zzfzVarZzd, zzejVar);
                                i2 = i2;
                                i3 = i3;
                                i70 = i13 == true ? 1 : 0;
                                i69 = i10;
                                i71 = i7;
                                i68 = i15;
                                i72 = i8;
                                zzheVar5 = this;
                            } else {
                                unsafe2 = unsafe5;
                                i29 = i28;
                                str2 = str;
                                i30 = i15;
                                obj2 = obj;
                                i11 = i13 == true ? 1 : 0;
                                i6 = i29;
                                str = str2;
                                unsafe = unsafe2;
                                i9 = i30;
                                zzheVar5 = this;
                                i3 = i3;
                            }
                        }
                    } else {
                        obj2 = obj5;
                        i6 = iZzj;
                        i7 = i71;
                        i8 = i72;
                        str = "Failed to parse the message.";
                        unsafe = unsafe5;
                        i9 = i75;
                        i10 = 0;
                        i11 = i4;
                    }
                    if (i11 == i3 || i3 == 0) {
                        if (zzheVar5.zzh) {
                            zzfhVar = zzejVar.zzd;
                            int i101 = zzfh.zzb;
                            int i102 = zzei.zza;
                            if (zzfhVar != zzfh.zza) {
                                zzhbVar = zzheVar5.zzg;
                                int i103 = zzek.zza;
                                if (zzfhVar.zza(zzhbVar, i9) == null) {
                                    throw null;
                                }
                                iZzh = zzek.zzh(i11 == true ? 1 : 0, bArr, i6, i2, zzd(obj), zzejVar);
                            } else {
                                iZzh = zzek.zzh(i11 == true ? 1 : 0, bArr, i6, i2, zzd(obj), zzejVar);
                            }
                        } else {
                            iZzh = zzek.zzh(i11 == true ? 1 : 0, bArr, i6, i2, zzd(obj), zzejVar);
                        }
                        i70 = i11;
                        i68 = i9;
                        i69 = i10;
                        i71 = i7;
                        i72 = i8;
                        unsafe5 = unsafe;
                        obj5 = obj2;
                        i2 = i2;
                    } else {
                        iZzh = i6;
                        i70 = i11;
                        i71 = i7;
                        i72 = i8;
                    }
                }
                i5 = -1;
                if (iZzq == i5) {
                    i12 = i4 & 7;
                    iArr = zzheVar5.zzc;
                    i13 = i4;
                    i14 = iArr[iZzq + 1];
                    str = "Failed to parse the message.";
                    iZzr = zzr(i14);
                    j = i14 & 1048575;
                    i15 = i75;
                    if (iZzr <= 17) {
                        int i710 = iArr[iZzq + 2];
                        i16 = 1 << (i710 >>> 20);
                        i17 = 1048575;
                        i18 = i710 & 1048575;
                        i19 = iZzj;
                        if (i18 != i72) {
                            if (i72 != 1048575) {
                                unsafe5.putInt(obj5, i72, i71);
                                i17 = 1048575;
                            }
                            if (i18 == i17) {
                                i71 = 0;
                            } else {
                                i71 = unsafe5.getInt(obj5, i18);
                            }
                        } else {
                            i18 = i72;
                        }
                        switch (iZzr) {
                            case 0:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 1) {
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    iZzh = i23 + 8;
                                    i71 |= i16;
                                    zzii.zzo(obj5, j, Double.longBitsToDouble(zzek.zzp(bArr, i23)));
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 1:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 5) {
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    iZzh = i23 + 4;
                                    i71 |= i16;
                                    zzii.zzp(obj5, j, Float.intBitsToFloat(zzek.zzb(bArr, i23)));
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 2:
                            case 3:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 0) {
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    i24 = i16 | i71;
                                    iZzl = zzek.zzl(bArr, i23, zzejVar);
                                    unsafe5.putLong(obj, j, zzejVar.zzb);
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i71 = i24;
                                    iZzh = iZzl;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 4:
                            case 11:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 0) {
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    i71 |= i16;
                                    iZzh = zzek.zzi(bArr, i23, zzejVar);
                                    unsafe5.putInt(obj5, j, zzejVar.zza);
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 5:
                            case 14:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 1) {
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    iZzl = i23 + 8;
                                    i24 = i16 | i71;
                                    unsafe5.putLong(obj, j, zzek.zzp(bArr, i23));
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i71 = i24;
                                    iZzh = iZzl;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 6:
                            case 13:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 5) {
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    iZzh = i23 + 4;
                                    i71 |= i16;
                                    unsafe5.putInt(obj5, j, zzek.zzb(bArr, i23));
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 7:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 0) {
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    i71 |= i16;
                                    iZzh = zzek.zzl(bArr, i23, zzejVar);
                                    if (zzejVar.zzb != 0) {
                                        z = true;
                                    } else {
                                        z = false;
                                    }
                                    zzii.zzm(obj5, j, z);
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 8:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 2) {
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    if ((i14 & 536870912) != 0) {
                                        i71 |= i16;
                                        iZzh = zzek.zzg(bArr, i23, zzejVar);
                                    } else {
                                        iZzh = zzek.zzi(bArr, i23, zzejVar);
                                        i25 = zzejVar.zza;
                                        if (i25 >= 0) {
                                            throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                        }
                                        int i711 = i71 | i16;
                                        if (i25 == 0) {
                                            zzejVar.zzc = "";
                                        } else {
                                            zzejVar.zzc = new String(bArr, iZzh, i25, zzga.zza);
                                            iZzh += i25;
                                        }
                                        i71 = i711;
                                    }
                                    unsafe5.putObject(obj5, j, zzejVar.zzc);
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 9:
                                zzheVar = this;
                                i20 = i18;
                                i26 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 2) {
                                    Object objZzx3 = zzheVar.zzx(obj5, i10);
                                    iZzh = zzek.zzn(objZzx3, zzheVar.zzv(i10), bArr, i26, i2, zzejVar);
                                    zzheVar.zzF(obj5, i10, objZzx3);
                                    i70 = i22 == true ? 1 : 0;
                                    zzheVar5 = zzheVar;
                                    i71 |= i16;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                    i2 = i2;
                                }
                                i23 = i26;
                                zzheVar2 = zzheVar;
                                i3 = i3;
                                obj2 = obj5;
                                i11 = i22;
                                i7 = i71;
                                i6 = i23;
                                unsafe = unsafe5;
                                zzheVar5 = zzheVar2;
                                i8 = i20;
                                i9 = i15;
                                break;
                            case 10:
                                zzheVar = this;
                                i20 = i18;
                                i26 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 2) {
                                    i23 = i26;
                                    zzheVar2 = zzheVar;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    i71 |= i16;
                                    iZzh = zzek.zza(bArr, i26, zzejVar);
                                    unsafe5.putObject(obj5, j, zzejVar.zzc);
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 12:
                                i20 = i18;
                                i21 = i19;
                                i22 = i13 == true ? 1 : 0;
                                i10 = iZzq;
                                if (i12 == 0) {
                                    zzheVar2 = this;
                                    i23 = i21;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    iZzh = zzek.zzi(bArr, i21, zzejVar);
                                    i27 = zzejVar.zza;
                                    zzheVar = this;
                                    zzfx zzfxVarZzu5 = zzheVar.zzu(i10);
                                    if ((i14 & Integer.MIN_VALUE) != 0) {
                                        i71 |= i16;
                                        unsafe5.putInt(obj5, j, i27);
                                    } else {
                                        i71 |= i16;
                                        unsafe5.putInt(obj5, j, i27);
                                    }
                                    i70 = i22;
                                    zzheVar5 = zzheVar;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                }
                                break;
                            case 15:
                                i20 = i18;
                                i21 = i19;
                                i22 = i13 == true ? 1 : 0;
                                i10 = iZzq;
                                if (i12 == 0) {
                                    zzheVar2 = this;
                                    i23 = i21;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    i71 |= i16;
                                    iZzh = zzek.zzi(bArr, i21, zzejVar);
                                    unsafe5.putInt(obj5, j, zzey.zzb(zzejVar.zza));
                                    i70 = i22 == true ? 1 : 0;
                                    i69 = i10;
                                    i72 = i20;
                                    i68 = i15;
                                    zzheVar5 = this;
                                }
                                break;
                            case 16:
                                if (i12 == 0) {
                                    i20 = i18;
                                    i21 = i19;
                                    i22 = i13 == true ? 1 : 0;
                                    i10 = iZzq;
                                    zzheVar2 = this;
                                    i23 = i21;
                                    i3 = i3;
                                    obj2 = obj5;
                                    i11 = i22;
                                    i7 = i71;
                                    i6 = i23;
                                    unsafe = unsafe5;
                                    zzheVar5 = zzheVar2;
                                    i8 = i20;
                                    i9 = i15;
                                } else {
                                    int i712 = i71 | i16;
                                    int iZzl4 = zzek.zzl(bArr, i19, zzejVar);
                                    i20 = i18;
                                    unsafe5.putLong(obj, j, zzey.zzc(zzejVar.zzb));
                                    i70 = i13 == true ? 1 : 0;
                                    i71 = i712;
                                    i69 = iZzq;
                                    iZzh = iZzl4;
                                    i72 = i20;
                                    i68 = i15;
                                    zzheVar5 = this;
                                }
                                break;
                            default:
                                zzheVar = this;
                                i20 = i18;
                                i23 = i19;
                                i10 = iZzq;
                                i22 = i13 == true ? 1 : 0;
                                if (i12 == 3) {
                                    Object objZzx4 = zzheVar.zzx(obj5, i10);
                                    iZzh = zzek.zzm(objZzx4, zzheVar.zzv(i10), bArr, i23, i2, (i15 << 3) | 4, zzejVar);
                                    zzheVar.zzF(obj5, i10, objZzx4);
                                    i70 = i22 == true ? 1 : 0;
                                    i71 |= i16;
                                    i69 = i10;
                                    zzheVar5 = zzheVar;
                                    i72 = i20;
                                    i68 = i15;
                                    i2 = i2;
                                }
                                zzheVar2 = zzheVar;
                                i3 = i3;
                                obj2 = obj5;
                                i11 = i22;
                                i7 = i71;
                                i6 = i23;
                                unsafe = unsafe5;
                                zzheVar5 = zzheVar2;
                                i8 = i20;
                                i9 = i15;
                                break;
                        }
                    } else {
                        i28 = iZzj;
                        i10 = iZzq;
                        i8 = i72;
                        zzheVar3 = zzheVar5;
                        i7 = i71;
                        if (iZzr == 27) {
                            if (iZzr <= 49) {
                                j3 = i14;
                                zzfzVar = (zzfz) unsafe5.getObject(obj5, j);
                                if (zzfzVar.zzc()) {
                                    int size4 = zzfzVar.size();
                                    zzfz zzfzVarZzd3 = zzfzVar.zzd(size4 + size4);
                                    unsafe5.putObject(obj5, j, zzfzVarZzd3);
                                    zzfzVar2 = zzfzVarZzd3;
                                } else {
                                    zzfzVar2 = zzfzVar;
                                }
                                switch (iZzr) {
                                    case 18:
                                    case 35:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        str3 = str;
                                        i39 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            str = str3;
                                            if (i12 == 1) {
                                                iZzh = i38 + 8;
                                                int i713 = zzek.zza;
                                                zzfeVar = (zzfe) zzfzVar2;
                                                zzfeVar.zzf(Double.longBitsToDouble(zzek.zzp(bArr, i38)));
                                                while (iZzh < i37) {
                                                    iZzi = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        zzfeVar.zzf(Double.longBitsToDouble(zzek.zzp(bArr, iZzi)));
                                                        iZzh = iZzi + 8;
                                                    }
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            int i810 = zzek.zza;
                                            zzfeVar2 = (zzfe) zzfzVar2;
                                            iZzh = zzek.zzi(bArr, i38, zzejVar);
                                            i40 = zzejVar.zza;
                                            i41 = iZzh + i40;
                                            if (i41 <= bArr.length) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                            zzfeVar2.zzg(zzfeVar2.size() + (i40 / 8));
                                            while (iZzh < i41) {
                                                zzfeVar2.zzf(Double.longBitsToDouble(zzek.zzp(bArr, iZzh)));
                                                iZzh += 8;
                                                str3 = str3;
                                            }
                                            str = str3;
                                            if (iZzh != i41) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                        }
                                        i45 = i39;
                                        str5 = str;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case 19:
                                    case 36:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        str4 = str;
                                        i42 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            if (i12 == 5) {
                                                iZzh = i38 + 4;
                                                int i811 = zzek.zza;
                                                zzfoVar = (zzfo) zzfzVar2;
                                                zzfoVar.zzf(Float.intBitsToFloat(zzek.zzb(bArr, i38)));
                                                while (iZzh < i37) {
                                                    iZzi2 = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        zzfoVar.zzf(Float.intBitsToFloat(zzek.zzb(bArr, iZzi2)));
                                                        iZzh = iZzi2 + 4;
                                                    }
                                                }
                                            }
                                            str5 = str4;
                                            i45 = i42;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            int i812 = zzek.zza;
                                            zzfoVar2 = (zzfo) zzfzVar2;
                                            iZzh = zzek.zzi(bArr, i38, zzejVar);
                                            i43 = zzejVar.zza;
                                            i44 = iZzh + i43;
                                            if (i44 <= bArr.length) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                            zzfoVar2.zzg(zzfoVar2.size() + (i43 / 4));
                                            while (iZzh < i44) {
                                                zzfoVar2.zzf(Float.intBitsToFloat(zzek.zzb(bArr, iZzh)));
                                                iZzh += 4;
                                            }
                                            if (iZzh != i44) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                        }
                                        str5 = str4;
                                        i45 = i42;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case 20:
                                    case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                                    case 37:
                                    case 38:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        str4 = str;
                                        i42 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            if (i12 == 0) {
                                                int i813 = zzek.zza;
                                                zzgpVar = (zzgp) zzfzVar2;
                                                iZzh = zzek.zzl(bArr, i38, zzejVar);
                                                zzgpVar.zzf(zzejVar.zzb);
                                                while (iZzh < i37) {
                                                    iZzi3 = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        iZzh = zzek.zzl(bArr, iZzi3, zzejVar);
                                                        zzgpVar.zzf(zzejVar.zzb);
                                                    }
                                                }
                                            }
                                            str5 = str4;
                                            i45 = i42;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            int i814 = zzek.zza;
                                            zzgpVar2 = (zzgp) zzfzVar2;
                                            iZzh = zzek.zzi(bArr, i38, zzejVar);
                                            i46 = zzejVar.zza + iZzh;
                                            while (iZzh < i46) {
                                                iZzh = zzek.zzl(bArr, iZzh, zzejVar);
                                                zzgpVar2.zzf(zzejVar.zzb);
                                            }
                                            if (iZzh != i46) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                        }
                                        str5 = str4;
                                        i45 = i42;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case 22:
                                    case 29:
                                    case 39:
                                    case 43:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        i39 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            iZzh = zzek.zzf(bArr, i38, zzfzVar2, zzejVar);
                                            i45 = i39;
                                            str5 = str;
                                        } else if (i12 == 0) {
                                            iZzh = zzek.zzk(i13 == true ? 1 : 0, bArr, i38, i2, zzfzVar2, zzejVar);
                                            i45 = i39;
                                            str5 = str;
                                        } else {
                                            i45 = i39;
                                            str5 = str;
                                            iZzh = i38;
                                        }
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case ConnectionResult.API_DISABLED:
                                    case 32:
                                    case 40:
                                    case 46:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        i39 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            if (i12 == 1) {
                                                iZzh = i38 + 8;
                                                int i815 = zzek.zza;
                                                zzgpVar3 = (zzgp) zzfzVar2;
                                                zzgpVar3.zzf(zzek.zzp(bArr, i38));
                                                while (iZzh < i37) {
                                                    iZzi4 = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        zzgpVar3.zzf(zzek.zzp(bArr, iZzi4));
                                                        iZzh = iZzi4 + 8;
                                                    }
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            int i816 = zzek.zza;
                                            zzgpVar4 = (zzgp) zzfzVar2;
                                            iZzh = zzek.zzi(bArr, i38, zzejVar);
                                            i47 = zzejVar.zza;
                                            i48 = iZzh + i47;
                                            if (i48 <= bArr.length) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                            zzgpVar4.zzg(zzgpVar4.size() + (i47 / 8));
                                            while (iZzh < i48) {
                                                zzgpVar4.zzf(zzek.zzp(bArr, iZzh));
                                                iZzh += 8;
                                            }
                                            if (iZzh != i48) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                        }
                                        i45 = i39;
                                        str5 = str;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                                    case 31:
                                    case 41:
                                    case 45:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        i39 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            if (i12 == 5) {
                                                iZzh = i38 + 4;
                                                int i817 = zzek.zza;
                                                zzfvVar = (zzfv) zzfzVar2;
                                                zzfvVar.zzg(zzek.zzb(bArr, i38));
                                                while (iZzh < i37) {
                                                    iZzi5 = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        zzfvVar.zzg(zzek.zzb(bArr, iZzi5));
                                                        iZzh = iZzi5 + 4;
                                                    }
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            int i818 = zzek.zza;
                                            zzfvVar2 = (zzfv) zzfzVar2;
                                            iZzh = zzek.zzi(bArr, i38, zzejVar);
                                            i49 = zzejVar.zza;
                                            i50 = iZzh + i49;
                                            if (i50 <= bArr.length) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                            zzfvVar2.zzh(zzfvVar2.size() + (i49 / 4));
                                            while (iZzh < i50) {
                                                zzfvVar2.zzg(zzek.zzb(bArr, iZzh));
                                                iZzh += 4;
                                            }
                                            if (iZzh != i50) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                        }
                                        i45 = i39;
                                        str5 = str;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case 25:
                                    case 42:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        i39 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            if (i12 == 0) {
                                                int i819 = zzek.zza;
                                                zzelVar = (zzel) zzfzVar2;
                                                iZzh = zzek.zzl(bArr, i38, zzejVar);
                                                if (zzejVar.zzb != 0) {
                                                    z3 = true;
                                                } else {
                                                    z3 = false;
                                                }
                                                zzelVar.zze(z3);
                                                while (iZzh < i37) {
                                                    iZzi6 = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        iZzh = zzek.zzl(bArr, iZzi6, zzejVar);
                                                        if (zzejVar.zzb != 0) {
                                                            z4 = true;
                                                        } else {
                                                            z4 = false;
                                                        }
                                                        zzelVar.zze(z4);
                                                    }
                                                }
                                            }
                                            i45 = i39;
                                            str5 = str;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            int i910 = zzek.zza;
                                            zzelVar2 = (zzel) zzfzVar2;
                                            iZzh = zzek.zzi(bArr, i38, zzejVar);
                                            i51 = zzejVar.zza + iZzh;
                                            while (iZzh < i51) {
                                                iZzh = zzek.zzl(bArr, iZzh, zzejVar);
                                                if (zzejVar.zzb != 0) {
                                                    z5 = true;
                                                } else {
                                                    z5 = false;
                                                }
                                                zzelVar2.zze(z5);
                                            }
                                            if (iZzh != i51) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                        }
                                        i45 = i39;
                                        str5 = str;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case 26:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        str = str;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            str5 = str;
                                            i45 = i15;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            if ((j3 & 536870912) == 0) {
                                                iZzi7 = zzek.zzi(bArr, i38, zzejVar);
                                                i56 = zzejVar.zza;
                                                if (i56 >= 0) {
                                                    throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                }
                                                if (i56 == 0) {
                                                    obj4 = "";
                                                    zzfzVar2.add(obj4);
                                                } else {
                                                    obj4 = r6;
                                                    zzfzVar2.add(new String(bArr, iZzi7, i56, zzga.zza));
                                                    iZzi7 += i56;
                                                }
                                                while (iZzi7 < i37) {
                                                    iZzi9 = zzek.zzi(bArr, iZzi7, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        iZzi7 = zzek.zzi(bArr, iZzi9, zzejVar);
                                                        i57 = zzejVar.zza;
                                                        if (i57 >= 0) {
                                                            throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                        }
                                                        if (i57 == 0) {
                                                            zzfzVar2.add(obj4);
                                                        } else {
                                                            zzfzVar2.add(new String(bArr, iZzi7, i57, zzga.zza));
                                                            iZzi7 += i57;
                                                        }
                                                    }
                                                }
                                            } else {
                                                str = str;
                                                iZzi7 = zzek.zzi(bArr, i38, zzejVar);
                                                i52 = zzejVar.zza;
                                                if (i52 >= 0) {
                                                    throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                }
                                                if (i52 == 0) {
                                                    zzfzVar2.add(r6);
                                                } else {
                                                    i53 = iZzi7 + i52;
                                                    if (zzin.zzc(bArr, iZzi7, i53)) {
                                                        throw new zzgc("Protocol message had invalid UTF-8.");
                                                    }
                                                    zzfzVar2.add(new String(bArr, iZzi7, i52, zzga.zza));
                                                    iZzi7 = i53;
                                                }
                                                while (iZzi7 < i37) {
                                                    iZzi8 = zzek.zzi(bArr, iZzi7, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        iZzi7 = zzek.zzi(bArr, iZzi8, zzejVar);
                                                        i54 = zzejVar.zza;
                                                        if (i54 >= 0) {
                                                            throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                        }
                                                        if (i54 == 0) {
                                                            zzfzVar2.add(r6);
                                                        } else {
                                                            i55 = iZzi7 + i54;
                                                            if (zzin.zzc(bArr, iZzi7, i55)) {
                                                                throw new zzgc("Protocol message had invalid UTF-8.");
                                                            }
                                                            zzfzVar2.add(new String(bArr, iZzi7, i54, zzga.zza));
                                                            iZzi7 = i55;
                                                        }
                                                    }
                                                }
                                            }
                                            iZzh = iZzi7;
                                            i45 = i15;
                                            str5 = str;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        }
                                        break;
                                    case 27:
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        i39 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            iZzh = zzek.zze(zzheVar4.zzv(i10), i13 == true ? 1 : 0, bArr, i38, i2, zzfzVar2, zzejVar);
                                            i37 = i2;
                                            str5 = str;
                                            i45 = i39;
                                        } else {
                                            i37 = i2;
                                            i45 = i39;
                                            str5 = str;
                                            iZzh = i38;
                                        }
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case 28:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        i39 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 2) {
                                            iZzi10 = zzek.zzi(bArr, i38, zzejVar);
                                            i58 = zzejVar.zza;
                                            if (i58 >= 0) {
                                                throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                            }
                                            if (i58 <= bArr.length - iZzi10) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                            if (i58 == 0) {
                                                zzfzVar2.add(zzev.zza);
                                            } else {
                                                zzfzVar2.add(zzev.zzk(bArr, iZzi10, i58));
                                                iZzi10 += i58;
                                            }
                                            while (iZzi10 < i37) {
                                                iZzi11 = zzek.zzi(bArr, iZzi10, zzejVar);
                                                if (i13 == zzejVar.zza) {
                                                    iZzh = iZzi10;
                                                    i45 = i39;
                                                    str5 = str;
                                                    if (iZzh != i38) {
                                                        i3 = i3;
                                                        obj2 = obj5;
                                                        i11 = i13 == true ? 1 : 0;
                                                        i6 = iZzh;
                                                        zzheVar5 = zzheVar4;
                                                        unsafe = unsafe4;
                                                        str = str5;
                                                        i9 = i45;
                                                    } else {
                                                        i3 = i3;
                                                        i70 = i13 == true ? 1 : 0;
                                                        i2 = i37;
                                                        zzheVar5 = zzheVar4;
                                                        i69 = i10;
                                                        i71 = i7;
                                                        i72 = i8;
                                                        unsafe5 = unsafe4;
                                                        i68 = i45;
                                                    }
                                                    break;
                                                } else {
                                                    iZzi10 = zzek.zzi(bArr, iZzi11, zzejVar);
                                                    i59 = zzejVar.zza;
                                                    if (i59 >= 0) {
                                                        throw new zzgc("CodedInputStream encountered an embedded string or message which claimed to have negative size.");
                                                    }
                                                    if (i59 <= bArr.length - iZzi10) {
                                                        throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                                    }
                                                    if (i59 == 0) {
                                                        zzfzVar2.add(zzev.zza);
                                                    } else {
                                                        zzfzVar2.add(zzev.zzk(bArr, iZzi10, i59));
                                                        iZzi10 += i59;
                                                    }
                                                }
                                            }
                                            iZzh = iZzi10;
                                            i45 = i39;
                                            str5 = str;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        }
                                        i45 = i39;
                                        str5 = str;
                                        iZzh = i38;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case l11l11lI1lll.l11l1111Il1l:
                                    case 44:
                                        i37 = i2;
                                        i38 = i28;
                                        if (i12 == 2) {
                                            iZzk = zzek.zzf(bArr, i38, zzfzVar2, zzejVar);
                                        } else if (i12 == 0) {
                                            unsafe4 = unsafe5;
                                            zzheVar4 = this;
                                            str5 = str;
                                            i45 = i15;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            iZzk = zzek.zzk(i13 == true ? 1 : 0, bArr, i38, i2, zzfzVar2, zzejVar);
                                        }
                                        zzfxVarZzu3 = zzu(i10);
                                        zzibVar = this.zzl;
                                        int i911 = zzhn.zza;
                                        if (zzfxVarZzu3 != null) {
                                            i60 = iZzk;
                                            unsafe4 = unsafe5;
                                            i61 = i15;
                                        } else if (zzfzVar2 instanceof RandomAccess) {
                                            size2 = zzfzVar2.size();
                                            i60 = iZzk;
                                            objZzo2 = null;
                                            i62 = 0;
                                            i63 = 0;
                                            while (i62 < size2) {
                                                num = (Integer) zzfzVar2.get(i62);
                                                Unsafe unsafe9 = unsafe5;
                                                iIntValue2 = num.intValue();
                                                if (zzfxVarZzu3.zza(iIntValue2)) {
                                                    if (i62 != i63) {
                                                        zzfzVar2.set(i63, num);
                                                    }
                                                    i63++;
                                                    i64 = i15;
                                                } else {
                                                    i64 = i15;
                                                    objZzo2 = zzhn.zzo(obj5, i64, iIntValue2, objZzo2, zzibVar);
                                                }
                                                i62++;
                                                i15 = i64;
                                                unsafe5 = unsafe9;
                                            }
                                            unsafe4 = unsafe5;
                                            i61 = i15;
                                            if (i63 != size2) {
                                                zzfzVar2.subList(i63, size2).clear();
                                            }
                                        } else {
                                            i60 = iZzk;
                                            unsafe4 = unsafe5;
                                            i61 = i15;
                                            it = zzfzVar2.iterator();
                                            objZzo = null;
                                            while (it.hasNext()) {
                                                iIntValue = ((Integer) it.next()).intValue();
                                                if (!zzfxVarZzu3.zza(iIntValue)) {
                                                    objZzo = zzhn.zzo(obj5, i61, iIntValue, objZzo, zzibVar);
                                                    it.remove();
                                                }
                                            }
                                        }
                                        zzheVar4 = this;
                                        i45 = i61;
                                        iZzh = i60;
                                        str5 = str;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case Encoder.DEFAULT_EC_PERCENT:
                                    case 47:
                                        i37 = i2;
                                        i38 = i28;
                                        if (i12 == 2) {
                                            if (i12 == 0) {
                                                int i912 = zzek.zza;
                                                zzfvVar3 = (zzfv) zzfzVar2;
                                                iZzh = zzek.zzi(bArr, i38, zzejVar);
                                                zzfvVar3.zzg(zzey.zzb(zzejVar.zza));
                                                while (iZzh < i37) {
                                                    iZzi12 = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        iZzh = zzek.zzi(bArr, iZzi12, zzejVar);
                                                        zzfvVar3.zzg(zzey.zzb(zzejVar.zza));
                                                    }
                                                }
                                            }
                                            unsafe4 = unsafe5;
                                            str5 = str;
                                            i45 = i15;
                                            zzheVar4 = this;
                                            iZzh = i38;
                                            if (iZzh != i38) {
                                                i3 = i3;
                                                obj2 = obj5;
                                                i11 = i13 == true ? 1 : 0;
                                                i6 = iZzh;
                                                zzheVar5 = zzheVar4;
                                                unsafe = unsafe4;
                                                str = str5;
                                                i9 = i45;
                                            } else {
                                                i3 = i3;
                                                i70 = i13 == true ? 1 : 0;
                                                i2 = i37;
                                                zzheVar5 = zzheVar4;
                                                i69 = i10;
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe4;
                                                i68 = i45;
                                            }
                                        } else {
                                            int i913 = zzek.zza;
                                            zzfvVar4 = (zzfv) zzfzVar2;
                                            iZzh = zzek.zzi(bArr, i38, zzejVar);
                                            i65 = zzejVar.zza + iZzh;
                                            while (iZzh < i65) {
                                                iZzh = zzek.zzi(bArr, iZzh, zzejVar);
                                                zzfvVar4.zzg(zzey.zzb(zzejVar.zza));
                                            }
                                            if (iZzh != i65) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                        }
                                        unsafe4 = unsafe5;
                                        str5 = str;
                                        i45 = i15;
                                        zzheVar4 = this;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    case 34:
                                    case 48:
                                        if (i12 == 2) {
                                            i38 = i28;
                                            if (i12 == 0) {
                                                i37 = i2;
                                                unsafe4 = unsafe5;
                                                str5 = str;
                                                i45 = i15;
                                                zzheVar4 = this;
                                                iZzh = i38;
                                                if (iZzh != i38) {
                                                    i3 = i3;
                                                    obj2 = obj5;
                                                    i11 = i13 == true ? 1 : 0;
                                                    i6 = iZzh;
                                                    zzheVar5 = zzheVar4;
                                                    unsafe = unsafe4;
                                                    str = str5;
                                                    i9 = i45;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i13 == true ? 1 : 0;
                                                    i2 = i37;
                                                    zzheVar5 = zzheVar4;
                                                    i69 = i10;
                                                    i71 = i7;
                                                    i72 = i8;
                                                    unsafe5 = unsafe4;
                                                    i68 = i45;
                                                }
                                                break;
                                            } else {
                                                int i914 = zzek.zza;
                                                zzgpVar5 = (zzgp) zzfzVar2;
                                                iZzh = zzek.zzl(bArr, i38, zzejVar);
                                                zzgpVar5.zzf(zzey.zzc(zzejVar.zzb));
                                                i37 = i2;
                                                while (iZzh < i37) {
                                                    iZzi13 = zzek.zzi(bArr, iZzh, zzejVar);
                                                    if (i13 == zzejVar.zza) {
                                                        iZzh = zzek.zzl(bArr, iZzi13, zzejVar);
                                                        zzgpVar5.zzf(zzey.zzc(zzejVar.zzb));
                                                    }
                                                }
                                            }
                                        } else {
                                            int i915 = zzek.zza;
                                            zzgpVar6 = (zzgp) zzfzVar2;
                                            i38 = i28;
                                            iZzh = zzek.zzi(bArr, i38, zzejVar);
                                            i66 = zzejVar.zza + iZzh;
                                            while (iZzh < i66) {
                                                iZzh = zzek.zzl(bArr, iZzh, zzejVar);
                                                zzgpVar6.zzf(zzey.zzc(zzejVar.zzb));
                                            }
                                            if (iZzh == i66) {
                                                throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                            }
                                            i37 = i2;
                                        }
                                        unsafe4 = unsafe5;
                                        str5 = str;
                                        i45 = i15;
                                        zzheVar4 = this;
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                    default:
                                        i37 = i2;
                                        unsafe4 = unsafe5;
                                        i38 = i28;
                                        i39 = i15;
                                        zzheVar4 = this;
                                        if (i12 == 3) {
                                            i67 = ((i13 == true ? 1 : 0) & (-8)) | 4;
                                            zzhlVarZzv = zzheVar4.zzv(i10);
                                            str5 = str;
                                            i45 = i39;
                                            iZzh = zzek.zzc(zzhlVarZzv, bArr, i38, i2, i67, zzejVar);
                                            zzfzVar2.add(zzejVar.zzc);
                                            while (iZzh < i37) {
                                                iZzi14 = zzek.zzi(bArr, iZzh, zzejVar);
                                                if (i13 == zzejVar.zza) {
                                                    iZzh = zzek.zzc(zzhlVarZzv, bArr, iZzi14, i2, i67, zzejVar);
                                                    zzfzVar2.add(zzejVar.zzc);
                                                }
                                            }
                                        } else {
                                            i45 = i39;
                                            str5 = str;
                                            iZzh = i38;
                                        }
                                        if (iZzh != i38) {
                                            i3 = i3;
                                            obj2 = obj5;
                                            i11 = i13 == true ? 1 : 0;
                                            i6 = iZzh;
                                            zzheVar5 = zzheVar4;
                                            unsafe = unsafe4;
                                            str = str5;
                                            i9 = i45;
                                        } else {
                                            i3 = i3;
                                            i70 = i13 == true ? 1 : 0;
                                            i2 = i37;
                                            zzheVar5 = zzheVar4;
                                            i69 = i10;
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe4;
                                            i68 = i45;
                                        }
                                        break;
                                }
                            } else {
                                unsafe2 = unsafe5;
                                i30 = i15;
                                i29 = i28;
                                i2 = i2;
                                if (iZzr == 50) {
                                    unsafe = unsafe2;
                                    j2 = iArr[i10 + 2] & 1048575;
                                    switch (iZzr) {
                                        case 51:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i10 = i10;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 1) {
                                                iZzh = i29 + 8;
                                                unsafe.putObject(obj2, j, Double.valueOf(Double.longBitsToDouble(zzek.zzp(bArr, i29))));
                                                unsafe.putInt(obj2, j2, i9);
                                            } else {
                                                iZzh = i29;
                                            }
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 52:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i10 = i10;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 5) {
                                                iZzh = i29 + 4;
                                                unsafe.putObject(obj2, j, Float.valueOf(Float.intBitsToFloat(zzek.zzb(bArr, i29))));
                                                unsafe.putInt(obj2, j2, i9);
                                            } else {
                                                iZzh = i29;
                                            }
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 53:
                                        case 54:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i10 = i10;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 0) {
                                                iZzh = zzek.zzl(bArr, i29, zzejVar);
                                                unsafe.putObject(obj2, j, Long.valueOf(zzejVar.zzb));
                                                unsafe.putInt(obj2, j2, i9);
                                            } else {
                                                iZzh = i29;
                                            }
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 55:
                                        case 62:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i10 = i10;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 0) {
                                                iZzh = zzek.zzi(bArr, i29, zzejVar);
                                                unsafe.putObject(obj2, j, Integer.valueOf(zzejVar.zza));
                                                unsafe.putInt(obj2, j2, i9);
                                            } else {
                                                iZzh = i29;
                                            }
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 56:
                                        case 65:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i10 = i10;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 1) {
                                                iZzh = i29 + 8;
                                                unsafe.putObject(obj2, j, Long.valueOf(zzek.zzp(bArr, i29)));
                                                unsafe.putInt(obj2, j2, i9);
                                            } else {
                                                iZzh = i29;
                                            }
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 57:
                                        case UserMetadata.MAX_ATTRIBUTES:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i10 = i10;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 5) {
                                                iZzh = i29 + 4;
                                                unsafe.putObject(obj2, j, Integer.valueOf(zzek.zzb(bArr, i29)));
                                                unsafe.putInt(obj2, j2, i9);
                                            } else {
                                                iZzh = i29;
                                            }
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 58:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i10 = i10;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 0) {
                                                iZzh = zzek.zzl(bArr, i29, zzejVar);
                                                if (zzejVar.zzb != 0) {
                                                    z2 = true;
                                                } else {
                                                    z2 = false;
                                                }
                                                unsafe.putObject(obj2, j, Boolean.valueOf(z2));
                                                unsafe.putInt(obj2, j2, i9);
                                            } else {
                                                iZzh = i29;
                                            }
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 59:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 2) {
                                                iZzh = zzek.zzi(bArr, i29, zzejVar);
                                                i32 = zzejVar.zza;
                                                if (i32 == 0) {
                                                    unsafe.putObject(obj2, j, "");
                                                } else {
                                                    i33 = iZzh + i32;
                                                    if ((i14 & 536870912) == 0) {
                                                    }
                                                    unsafe.putObject(obj2, j, new String(bArr, iZzh, i32, zzga.zza));
                                                    iZzh = i33;
                                                }
                                                unsafe.putInt(obj2, j2, i9);
                                            } else {
                                                i10 = i10;
                                                iZzh = i29;
                                            }
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case l11l111l11Il.l11l11l1llIl:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 2) {
                                                Object objZzy3 = zzheVar5.zzy(obj2, i9, i10);
                                                iZzh = zzek.zzn(objZzy3, zzheVar5.zzv(i10), bArr, i29, i2, zzejVar);
                                                zzheVar5.zzG(obj2, i9, i10, objZzy3);
                                                i10 = i10;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                            }
                                            i10 = i10;
                                            iZzh = i29;
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 61:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 2) {
                                                int iZza2 = zzek.zza(bArr, i29, zzejVar);
                                                unsafe.putObject(obj2, j, zzejVar.zzc);
                                                unsafe.putInt(obj2, j2, i9);
                                                iZzh = iZza2;
                                                i10 = i10;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                            }
                                            i10 = i10;
                                            iZzh = i29;
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 63:
                                            obj2 = obj;
                                            str = str;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 0) {
                                                i11 = i13 == true ? 1 : 0;
                                                i10 = i10;
                                                iZzh = i29;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                            } else {
                                                iZzh = zzek.zzi(bArr, i29, zzejVar);
                                                i34 = zzejVar.zza;
                                                zzfxVarZzu2 = zzheVar5.zzu(i10);
                                                if (zzfxVarZzu2 != null) {
                                                    i11 = i13 == true ? 1 : 0;
                                                    unsafe.putObject(obj2, j, Integer.valueOf(i34));
                                                    unsafe.putInt(obj2, j2, i9);
                                                } else {
                                                    i11 = i13 == true ? 1 : 0;
                                                    unsafe.putObject(obj2, j, Integer.valueOf(i34));
                                                    unsafe.putInt(obj2, j2, i9);
                                                }
                                                i10 = i10;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                            }
                                            break;
                                        case 66:
                                            obj2 = obj;
                                            i35 = i13 == true ? 1 : 0;
                                            str = str;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 0) {
                                                iZzh = zzek.zzi(bArr, i29, zzejVar);
                                                unsafe.putObject(obj2, j, Integer.valueOf(zzey.zzb(zzejVar.zza)));
                                                unsafe.putInt(obj2, j2, i9);
                                                i10 = i10;
                                                i11 = i35;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                            }
                                            i10 = i10;
                                            i11 = i35;
                                            iZzh = i29;
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 67:
                                            obj2 = obj;
                                            i35 = i13 == true ? 1 : 0;
                                            str = str;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            if (i12 == 0) {
                                                int iZzl5 = zzek.zzl(bArr, i29, zzejVar);
                                                unsafe.putObject(obj2, j, Long.valueOf(zzey.zzc(zzejVar.zzb)));
                                                unsafe.putInt(obj2, j2, i9);
                                                iZzh = iZzl5;
                                                i10 = i10;
                                                i11 = i35;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                            }
                                            i10 = i10;
                                            i11 = i35;
                                            iZzh = i29;
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                        case 68:
                                            if (i12 == 3) {
                                                obj2 = obj;
                                                i35 = i13 == true ? 1 : 0;
                                                str = str;
                                                i9 = i30;
                                                zzheVar5 = this;
                                                i10 = i10;
                                                i11 = i35;
                                                iZzh = i29;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                            } else {
                                                int i916 = ((i13 == true ? 1 : 0) & (-8)) | 4;
                                                Object objZzy4 = zzy(obj, i30, i10);
                                                zzhl zzhlVarZzv3 = zzv(i10);
                                                str = str;
                                                i9 = i30;
                                                obj2 = obj;
                                                i35 = i13 == true ? 1 : 0;
                                                zzheVar5 = this;
                                                iZzh = zzek.zzm(objZzy4, zzhlVarZzv3, bArr, i29, i2, i916, zzejVar);
                                                zzheVar5.zzG(obj2, i9, i10, objZzy4);
                                                i10 = i10;
                                                i11 = i35;
                                                if (iZzh != i29) {
                                                    i3 = i3;
                                                    i6 = iZzh;
                                                    i10 = i10;
                                                } else {
                                                    i3 = i3;
                                                    i70 = i11 == true ? 1 : 0;
                                                    i68 = i9;
                                                    i69 = i10;
                                                }
                                                i71 = i7;
                                                i72 = i8;
                                                unsafe5 = unsafe;
                                                obj5 = obj2;
                                                i2 = i2;
                                            }
                                            break;
                                        default:
                                            obj2 = obj;
                                            i11 = i13 == true ? 1 : 0;
                                            str = str;
                                            i10 = i10;
                                            i9 = i30;
                                            zzheVar5 = this;
                                            iZzh = i29;
                                            if (iZzh != i29) {
                                                i3 = i3;
                                                i6 = iZzh;
                                                i10 = i10;
                                            } else {
                                                i3 = i3;
                                                i70 = i11 == true ? 1 : 0;
                                                i68 = i9;
                                                i69 = i10;
                                            }
                                            i71 = i7;
                                            i72 = i8;
                                            unsafe5 = unsafe;
                                            obj5 = obj2;
                                            i2 = i2;
                                            break;
                                    }
                                } else {
                                    if (i12 == 2) {
                                        Object objZzw2 = zzw(i10);
                                        unsafe3 = unsafe2;
                                        object = unsafe3.getObject(obj5, j);
                                        if (!((zzgv) object).zze()) {
                                            zzgv zzgvVarZzb2 = zzgv.zza().zzb();
                                            zzgw.zza(zzgvVarZzb2, object);
                                            unsafe3.putObject(obj5, j, zzgvVarZzb2);
                                            object = zzgvVarZzb2;
                                        }
                                        zzgt zzgtVarZzc2 = ((zzgu) objZzw2).zzc();
                                        zzgv zzgvVar5 = (zzgv) object;
                                        int iZzi16 = zzek.zzi(bArr, i29, zzejVar);
                                        i36 = zzejVar.zza;
                                        if (i36 >= 0) {
                                        }
                                        throw new zzgc("While parsing a protocol message, the input ended unexpectedly in the middle of a field.  This could mean either that the input has been truncated or that an embedded message misreported its own length.");
                                    }
                                    str2 = str;
                                    obj2 = obj;
                                    i11 = i13 == true ? 1 : 0;
                                    i6 = i29;
                                    str = str2;
                                    unsafe = unsafe2;
                                    i9 = i30;
                                    zzheVar5 = this;
                                    i3 = i3;
                                }
                            }
                        } else if (i12 == 2) {
                            zzfzVarZzd = (zzfz) unsafe5.getObject(obj5, j);
                            if (!zzfzVarZzd.zzc()) {
                                size = zzfzVarZzd.size();
                                if (size == 0) {
                                    i31 = 10;
                                } else {
                                    i31 = size + size;
                                }
                                zzfzVarZzd = zzfzVarZzd.zzd(i31);
                                unsafe5.putObject(obj5, j, zzfzVarZzd);
                            }
                            iZzh = zzek.zze(zzheVar3.zzv(i10), i13 == true ? 1 : 0, bArr, i28, i2, zzfzVarZzd, zzejVar);
                            i2 = i2;
                            i3 = i3;
                            i70 = i13 == true ? 1 : 0;
                            i69 = i10;
                            i71 = i7;
                            i68 = i15;
                            i72 = i8;
                            zzheVar5 = this;
                        } else {
                            unsafe2 = unsafe5;
                            i29 = i28;
                            str2 = str;
                            i30 = i15;
                            obj2 = obj;
                            i11 = i13 == true ? 1 : 0;
                            i6 = i29;
                            str = str2;
                            unsafe = unsafe2;
                            i9 = i30;
                            zzheVar5 = this;
                            i3 = i3;
                        }
                    }
                } else {
                    obj2 = obj5;
                    i6 = iZzj;
                    i7 = i71;
                    i8 = i72;
                    str = "Failed to parse the message.";
                    unsafe = unsafe5;
                    i9 = i75;
                    i10 = 0;
                    i11 = i4;
                }
                if (i11 == i3) {
                }
                if (zzheVar5.zzh) {
                    zzfhVar = zzejVar.zzd;
                    int i104 = zzfh.zzb;
                    int i105 = zzei.zza;
                    if (zzfhVar != zzfh.zza) {
                        zzhbVar = zzheVar5.zzg;
                        int i106 = zzek.zza;
                        if (zzfhVar.zza(zzhbVar, i9) == null) {
                            throw null;
                        }
                        iZzh = zzek.zzh(i11 == true ? 1 : 0, bArr, i6, i2, zzd(obj), zzejVar);
                    } else {
                        iZzh = zzek.zzh(i11 == true ? 1 : 0, bArr, i6, i2, zzd(obj), zzejVar);
                    }
                } else {
                    iZzh = zzek.zzh(i11 == true ? 1 : 0, bArr, i6, i2, zzd(obj), zzejVar);
                }
                i70 = i11;
                i68 = i9;
                i69 = i10;
                i71 = i7;
                i72 = i8;
                unsafe5 = unsafe;
                obj5 = obj2;
                i2 = i2;
            } else {
                obj2 = obj5;
                str = "Failed to parse the message.";
                unsafe = unsafe5;
            }
        }
        if (i72 != 1048575) {
            unsafe.putInt(obj2, i72, i71);
        }
        int i107 = zzheVar5.zzj;
        ?? Zza = 0;
        while (i107 < zzheVar5.zzk) {
            int[] iArr2 = zzheVar5.zzi;
            zzib zzibVar2 = zzheVar5.zzl;
            int[] iArr3 = zzheVar5.zzc;
            int i108 = iArr2[i107];
            int i109 = iArr3[i108];
            Object objZzf = zzii.zzf(obj2, zzheVar5.zzs(i108) & 1048575);
            if (objZzf != null && (zzfxVarZzu = zzheVar5.zzu(i108)) != null) {
                zzgt zzgtVarZzc3 = ((zzgu) zzheVar5.zzw(i108)).zzc();
                Iterator it2 = ((zzgv) objZzf).entrySet().iterator();
                Zza = Zza;
                while (it2.hasNext()) {
                    Map.Entry entry = (Map.Entry) it2.next();
                    if (zzfxVarZzu.zza(((Integer) entry.getValue()).intValue())) {
                        Zza = Zza;
                    } else {
                        if (Zza == 0) {
                            Zza = zzibVar2.zza(obj2);
                        }
                        int iZzb = zzgu.zzb(zzgtVarZzc3, entry.getKey(), entry.getValue());
                        zzev zzevVar = zzev.zza;
                        byte[] bArr2 = new byte[iZzb];
                        int i110 = zzfc.zzb;
                        zzez zzezVar = new zzez(bArr2, 0, iZzb);
                        try {
                            zzgu.zze(zzezVar, zzgtVarZzc3, entry.getKey(), entry.getValue());
                            ((zzic) Zza).zzj((i109 << 3) | 2, zzer.zza(zzezVar, bArr2));
                            it2.remove();
                        } catch (IOException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    Zza = Zza;
                }
            }
            i107++;
            zzheVar5 = this;
            Zza = (zzic) Zza;
        }
        if (Zza != 0) {
            ((zzfu) obj2).zzc = Zza;
        }
        if (i3 != 0) {
            String str6 = str;
            if (iZzh > i2 || i70 != i3) {
                throw new zzgc(str6);
            }
        } else if (iZzh != i2) {
            throw new zzgc(str);
        }
        return iZzh;
    }

    @Override
    public final Object zze() {
        return ((zzfu) this.zzg).zzs();
    }

    @Override
    public final void zzf(Object obj) {
        if (zzL(obj)) {
            if (obj instanceof zzfu) {
                zzfu zzfuVar = (zzfu) obj;
                zzfuVar.zzC(Api.BaseClientBuilder.API_PRIORITY_OTHER);
                zzfuVar.zza = 0;
                zzfuVar.zzA();
            }
            int[] iArr = this.zzc;
            for (int i = 0; i < iArr.length; i += 3) {
                int iZzs = zzs(i);
                int i2 = 1048575 & iZzs;
                int iZzr = zzr(iZzs);
                long j = i2;
                if (iZzr != 9) {
                    if (iZzr != 60 && iZzr != 68) {
                        switch (iZzr) {
                            case 17:
                                if (zzI(obj, i)) {
                                    zzv(i).zzf(zzb.getObject(obj, j));
                                }
                                break;
                            case 18:
                            case 19:
                            case 20:
                            case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                            case 22:
                            case ConnectionResult.API_DISABLED:
                            case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                            case 25:
                            case 26:
                            case 27:
                            case 28:
                            case 29:
                            case l11l11lI1lll.l11l1111Il1l:
                            case 31:
                            case 32:
                            case Encoder.DEFAULT_EC_PERCENT:
                            case 34:
                            case 35:
                            case 36:
                            case 37:
                            case 38:
                            case 39:
                            case 40:
                            case 41:
                            case 42:
                            case 43:
                            case 44:
                            case 45:
                            case 46:
                            case 47:
                            case 48:
                            case 49:
                                ((zzfz) zzii.zzf(obj, j)).zzb();
                                break;
                            case l1l1l11Il.l11l111I11l:
                                Unsafe unsafe = zzb;
                                Object object = unsafe.getObject(obj, j);
                                if (object != null) {
                                    ((zzgv) object).zzc();
                                    unsafe.putObject(obj, j, object);
                                }
                                break;
                        }
                    } else if (zzM(obj, iArr[i], i)) {
                        zzv(i).zzf(zzb.getObject(obj, j));
                    }
                } else if (zzI(obj, i)) {
                    zzv(i).zzf(zzb.getObject(obj, j));
                }
            }
            this.zzl.zzb(obj);
            if (this.zzh) {
                this.zzm.zza(obj);
            }
        }
    }

    @Override
    public final void zzg(Object obj, Object obj2) {
        zzA(obj);
        obj2.getClass();
        int i = 0;
        while (true) {
            int[] iArr = this.zzc;
            if (i >= iArr.length) {
                zzhn.zzq(this.zzl, obj, obj2);
                if (this.zzh) {
                    zzhn.zzp(this.zzm, obj, obj2);
                    return;
                }
                return;
            }
            int iZzs = zzs(i);
            int i2 = 1048575 & iZzs;
            int iZzr = zzr(iZzs);
            int i3 = iArr[i];
            long j = i2;
            switch (iZzr) {
                case 0:
                    if (zzI(obj2, i)) {
                        zzii.zzo(obj, j, zzii.zza(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 1:
                    if (zzI(obj2, i)) {
                        zzii.zzp(obj, j, zzii.zzb(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 2:
                    if (zzI(obj2, i)) {
                        zzii.zzr(obj, j, zzii.zzd(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 3:
                    if (zzI(obj2, i)) {
                        zzii.zzr(obj, j, zzii.zzd(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 4:
                    if (zzI(obj2, i)) {
                        zzii.zzq(obj, j, zzii.zzc(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 5:
                    if (zzI(obj2, i)) {
                        zzii.zzr(obj, j, zzii.zzd(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 6:
                    if (zzI(obj2, i)) {
                        zzii.zzq(obj, j, zzii.zzc(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 7:
                    if (zzI(obj2, i)) {
                        zzii.zzm(obj, j, zzii.zzw(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 8:
                    if (zzI(obj2, i)) {
                        zzii.zzs(obj, j, zzii.zzf(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 9:
                    zzB(obj, obj2, i);
                    break;
                case 10:
                    if (zzI(obj2, i)) {
                        zzii.zzs(obj, j, zzii.zzf(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 11:
                    if (zzI(obj2, i)) {
                        zzii.zzq(obj, j, zzii.zzc(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 12:
                    if (zzI(obj2, i)) {
                        zzii.zzq(obj, j, zzii.zzc(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 13:
                    if (zzI(obj2, i)) {
                        zzii.zzq(obj, j, zzii.zzc(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 14:
                    if (zzI(obj2, i)) {
                        zzii.zzr(obj, j, zzii.zzd(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 15:
                    if (zzI(obj2, i)) {
                        zzii.zzq(obj, j, zzii.zzc(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 16:
                    if (zzI(obj2, i)) {
                        zzii.zzr(obj, j, zzii.zzd(obj2, j));
                        zzD(obj, i);
                    }
                    break;
                case 17:
                    zzB(obj, obj2, i);
                    break;
                case 18:
                case 19:
                case 20:
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                case 22:
                case ConnectionResult.API_DISABLED:
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                case 25:
                case 26:
                case 27:
                case 28:
                case 29:
                case l11l11lI1lll.l11l1111Il1l:
                case 31:
                case 32:
                case Encoder.DEFAULT_EC_PERCENT:
                case 34:
                case 35:
                case 36:
                case 37:
                case 38:
                case 39:
                case 40:
                case 41:
                case 42:
                case 43:
                case 44:
                case 45:
                case 46:
                case 47:
                case 48:
                case 49:
                    zzfz zzfzVarZzd = (zzfz) zzii.zzf(obj, j);
                    zzfz zzfzVar = (zzfz) zzii.zzf(obj2, j);
                    int size = zzfzVarZzd.size();
                    int size2 = zzfzVar.size();
                    if (size > 0 && size2 > 0) {
                        if (!zzfzVarZzd.zzc()) {
                            zzfzVarZzd = zzfzVarZzd.zzd(size2 + size);
                        }
                        zzfzVarZzd.addAll(zzfzVar);
                    }
                    if (size > 0) {
                        zzfzVar = zzfzVarZzd;
                    }
                    zzii.zzs(obj, j, zzfzVar);
                    break;
                case l1l1l11Il.l11l111I11l:
                    int i4 = zzhn.zza;
                    zzii.zzs(obj, j, zzgw.zza(zzii.zzf(obj, j), zzii.zzf(obj2, j)));
                    break;
                case 51:
                case 52:
                case 53:
                case 54:
                case 55:
                case 56:
                case 57:
                case 58:
                case 59:
                    if (zzM(obj2, i3, i)) {
                        zzii.zzs(obj, j, zzii.zzf(obj2, j));
                        zzE(obj, i3, i);
                    }
                    break;
                case l11l111l11Il.l11l11l1llIl:
                    zzC(obj, obj2, i);
                    break;
                case 61:
                case 62:
                case 63:
                case UserMetadata.MAX_ATTRIBUTES:
                case 65:
                case 66:
                case 67:
                    if (zzM(obj2, i3, i)) {
                        zzii.zzs(obj, j, zzii.zzf(obj2, j));
                        zzE(obj, i3, i);
                    }
                    break;
                case 68:
                    zzC(obj, obj2, i);
                    break;
            }
            i += 3;
        }
    }

    @Override
    public final void zzh(Object obj, byte[] bArr, int i, int i2, zzej zzejVar) throws IOException {
        zzc(obj, bArr, i, i2, 0, zzejVar);
    }

    @Override
    public final void zzi(Object obj, zzit zzitVar) throws IOException {
        Map.Entry entry;
        int i;
        int i2;
        int i3;
        Map.Entry entry2;
        if (this.zzh) {
            zzfm zzfmVar = ((zzfr) obj).zzb;
            if (zzfmVar.zza.isEmpty()) {
                entry = null;
            } else {
                entry = (Map.Entry) zzfmVar.zzf().next();
            }
        } else {
            entry = null;
        }
        int[] iArr = this.zzc;
        Unsafe unsafe = zzb;
        int i4 = 1048575;
        int i5 = 1048575;
        int i6 = 0;
        int i7 = 0;
        while (i7 < iArr.length) {
            int iZzs = zzs(i7);
            int iZzr = zzr(iZzs);
            int i8 = iArr[i7];
            if (iZzr <= 17) {
                int i9 = iArr[i7 + 2];
                int i10 = i9 & i4;
                if (i10 != i5) {
                    i6 = i10 == i4 ? 0 : unsafe.getInt(obj, i10);
                    i5 = i10;
                }
                i = i5;
                i2 = i6;
                i3 = 1 << (i9 >>> 20);
            } else {
                i = i5;
                i2 = i6;
                i3 = 0;
            }
            if (entry != null) {
                throw null;
            }
            long j = iZzs & i4;
            switch (iZzr) {
                case 0:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzf(i8, zzii.zza(obj, j));
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 1:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzo(i8, zzii.zzb(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 2:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzt(i8, unsafe.getLong(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 3:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzL(i8, unsafe.getLong(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 4:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzr(i8, unsafe.getInt(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 5:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzm(i8, unsafe.getLong(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 6:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzk(i8, unsafe.getInt(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 7:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzb(i8, zzii.zzw(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 8:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzP(i8, unsafe.getObject(obj, j), zzitVar);
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 9:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzw(i8, unsafe.getObject(obj, j), zzv(i7));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 10:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzd(i8, (zzev) unsafe.getObject(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 11:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzJ(i8, unsafe.getInt(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 12:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzi(i8, unsafe.getInt(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 13:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzy(i8, unsafe.getInt(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 14:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzA(i8, unsafe.getLong(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 15:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzC(i8, unsafe.getInt(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 16:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzE(i8, unsafe.getLong(obj, j));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 17:
                    entry2 = entry;
                    if (zzJ(obj, i7, i, i2, i3)) {
                        zzitVar.zzq(i8, unsafe.getObject(obj, j), zzv(i7));
                    } else {
                        continue;
                    }
                    i7 += 3;
                    i5 = i;
                    entry = entry2;
                    i6 = i2;
                    i4 = 1048575;
                    break;
                case 18:
                    zzhn.zzs(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 19:
                    zzhn.zzw(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 20:
                    zzhn.zzy(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                    zzhn.zzE(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 22:
                    zzhn.zzx(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case ConnectionResult.API_DISABLED:
                    zzhn.zzv(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                    zzhn.zzu(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 25:
                    zzhn.zzr(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 26:
                    int i11 = iArr[i7];
                    List list = (List) unsafe.getObject(obj, j);
                    int i12 = zzhn.zza;
                    if (list != null && !list.isEmpty()) {
                        zzitVar.zzI(i11, list);
                    }
                    break;
                case 27:
                    int i13 = iArr[i7];
                    List list2 = (List) unsafe.getObject(obj, j);
                    zzhl zzhlVarZzv = zzv(i7);
                    int i14 = zzhn.zza;
                    if (list2 != null && !list2.isEmpty()) {
                        for (int i15 = 0; i15 < list2.size(); i15++) {
                            ((zzfd) zzitVar).zzw(i13, list2.get(i15), zzhlVarZzv);
                        }
                    }
                    break;
                case 28:
                    int i16 = iArr[i7];
                    List list3 = (List) unsafe.getObject(obj, j);
                    int i17 = zzhn.zza;
                    if (list3 != null && !list3.isEmpty()) {
                        zzitVar.zze(i16, list3);
                    }
                    break;
                case 29:
                    zzhn.zzD(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case l11l11lI1lll.l11l1111Il1l:
                    zzhn.zzt(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 31:
                    zzhn.zzz(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 32:
                    zzhn.zzA(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case Encoder.DEFAULT_EC_PERCENT:
                    zzhn.zzB(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 34:
                    zzhn.zzC(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, false);
                    break;
                case 35:
                    zzhn.zzs(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 36:
                    zzhn.zzw(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 37:
                    zzhn.zzy(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 38:
                    zzhn.zzE(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 39:
                    zzhn.zzx(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 40:
                    zzhn.zzv(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 41:
                    zzhn.zzu(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 42:
                    zzhn.zzr(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 43:
                    zzhn.zzD(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 44:
                    zzhn.zzt(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 45:
                    zzhn.zzz(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 46:
                    zzhn.zzA(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 47:
                    zzhn.zzB(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 48:
                    zzhn.zzC(iArr[i7], (List) unsafe.getObject(obj, j), zzitVar, true);
                    break;
                case 49:
                    int i18 = iArr[i7];
                    List list4 = (List) unsafe.getObject(obj, j);
                    zzhl zzhlVarZzv2 = zzv(i7);
                    int i19 = zzhn.zza;
                    if (list4 != null && !list4.isEmpty()) {
                        for (int i20 = 0; i20 < list4.size(); i20++) {
                            ((zzfd) zzitVar).zzq(i18, list4.get(i20), zzhlVarZzv2);
                        }
                    }
                    break;
                case l1l1l11Il.l11l111I11l:
                    Object object = unsafe.getObject(obj, j);
                    if (object != null) {
                        zzitVar.zzv(i8, ((zzgu) zzw(i7)).zzc(), (zzgv) object);
                    }
                    break;
                case 51:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzf(i8, zzm(obj, j));
                    }
                    break;
                case 52:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzo(i8, zzn(obj, j));
                    }
                    break;
                case 53:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzt(i8, zzt(obj, j));
                    }
                    break;
                case 54:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzL(i8, zzt(obj, j));
                    }
                    break;
                case 55:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzr(i8, zzo(obj, j));
                    }
                    break;
                case 56:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzm(i8, zzt(obj, j));
                    }
                    break;
                case 57:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzk(i8, zzo(obj, j));
                    }
                    break;
                case 58:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzb(i8, zzN(obj, j));
                    }
                    break;
                case 59:
                    if (zzM(obj, i8, i7)) {
                        zzP(i8, unsafe.getObject(obj, j), zzitVar);
                    }
                    break;
                case l11l111l11Il.l11l11l1llIl:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzw(i8, unsafe.getObject(obj, j), zzv(i7));
                    }
                    break;
                case 61:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzd(i8, (zzev) unsafe.getObject(obj, j));
                    }
                    break;
                case 62:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzJ(i8, zzo(obj, j));
                    }
                    break;
                case 63:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzi(i8, zzo(obj, j));
                    }
                    break;
                case UserMetadata.MAX_ATTRIBUTES:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzy(i8, zzo(obj, j));
                    }
                    break;
                case 65:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzA(i8, zzt(obj, j));
                    }
                    break;
                case 66:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzC(i8, zzo(obj, j));
                    }
                    break;
                case 67:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzE(i8, zzt(obj, j));
                    }
                    break;
                case 68:
                    if (zzM(obj, i8, i7)) {
                        zzitVar.zzq(i8, unsafe.getObject(obj, j), zzv(i7));
                    }
                    break;
            }
            entry2 = entry;
            i7 += 3;
            i5 = i;
            entry = entry2;
            i6 = i2;
            i4 = 1048575;
        }
        Map.Entry entry3 = entry;
        if (entry3 != null) {
            throw null;
        }
        ((zzfu) obj).zzc.zzl(zzitVar);
    }

    @Override
    public final boolean zzj(Object obj, Object obj2) {
        boolean zZzF;
        for (int i = 0; i < this.zzc.length; i += 3) {
            int iZzs = zzs(i);
            long j = iZzs & 1048575;
            switch (zzr(iZzs)) {
                case 0:
                    if (!zzH(obj, obj2, i) || Double.doubleToLongBits(zzii.zza(obj, j)) != Double.doubleToLongBits(zzii.zza(obj2, j))) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 1:
                    if (!zzH(obj, obj2, i) || Float.floatToIntBits(zzii.zzb(obj, j)) != Float.floatToIntBits(zzii.zzb(obj2, j))) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 2:
                    if (!zzH(obj, obj2, i) || zzii.zzd(obj, j) != zzii.zzd(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 3:
                    if (!zzH(obj, obj2, i) || zzii.zzd(obj, j) != zzii.zzd(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 4:
                    if (!zzH(obj, obj2, i) || zzii.zzc(obj, j) != zzii.zzc(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 5:
                    if (!zzH(obj, obj2, i) || zzii.zzd(obj, j) != zzii.zzd(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 6:
                    if (!zzH(obj, obj2, i) || zzii.zzc(obj, j) != zzii.zzc(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 7:
                    if (!zzH(obj, obj2, i) || zzii.zzw(obj, j) != zzii.zzw(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 8:
                    if (!zzH(obj, obj2, i) || !zzhn.zzF(zzii.zzf(obj, j), zzii.zzf(obj2, j))) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 9:
                    if (!zzH(obj, obj2, i) || !zzhn.zzF(zzii.zzf(obj, j), zzii.zzf(obj2, j))) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 10:
                    if (!zzH(obj, obj2, i) || !zzhn.zzF(zzii.zzf(obj, j), zzii.zzf(obj2, j))) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 11:
                    if (!zzH(obj, obj2, i) || zzii.zzc(obj, j) != zzii.zzc(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 12:
                    if (!zzH(obj, obj2, i) || zzii.zzc(obj, j) != zzii.zzc(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 13:
                    if (!zzH(obj, obj2, i) || zzii.zzc(obj, j) != zzii.zzc(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 14:
                    if (!zzH(obj, obj2, i) || zzii.zzd(obj, j) != zzii.zzd(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 15:
                    if (!zzH(obj, obj2, i) || zzii.zzc(obj, j) != zzii.zzc(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 16:
                    if (!zzH(obj, obj2, i) || zzii.zzd(obj, j) != zzii.zzd(obj2, j)) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 17:
                    if (!zzH(obj, obj2, i) || !zzhn.zzF(zzii.zzf(obj, j), zzii.zzf(obj2, j))) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                case 18:
                case 19:
                case 20:
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                case 22:
                case ConnectionResult.API_DISABLED:
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                case 25:
                case 26:
                case 27:
                case 28:
                case 29:
                case l11l11lI1lll.l11l1111Il1l:
                case 31:
                case 32:
                case Encoder.DEFAULT_EC_PERCENT:
                case 34:
                case 35:
                case 36:
                case 37:
                case 38:
                case 39:
                case 40:
                case 41:
                case 42:
                case 43:
                case 44:
                case 45:
                case 46:
                case 47:
                case 48:
                case 49:
                    zZzF = zzhn.zzF(zzii.zzf(obj, j), zzii.zzf(obj2, j));
                    break;
                case l1l1l11Il.l11l111I11l:
                    zZzF = zzhn.zzF(zzii.zzf(obj, j), zzii.zzf(obj2, j));
                    break;
                case 51:
                case 52:
                case 53:
                case 54:
                case 55:
                case 56:
                case 57:
                case 58:
                case 59:
                case l11l111l11Il.l11l11l1llIl:
                case 61:
                case 62:
                case 63:
                case UserMetadata.MAX_ATTRIBUTES:
                case 65:
                case 66:
                case 67:
                case 68:
                    long jZzp = zzp(i) & 1048575;
                    if (zzii.zzc(obj, jZzp) != zzii.zzc(obj2, jZzp) || !zzhn.zzF(zzii.zzf(obj, j), zzii.zzf(obj2, j))) {
                        return false;
                    }
                    continue;
                    break;
                    break;
                default:
                    continue;
                    break;
            }
            if (!zZzF) {
                return false;
            }
        }
        if (!((zzfu) obj).zzc.equals(((zzfu) obj2).zzc)) {
            return false;
        }
        if (this.zzh) {
            return ((zzfr) obj).zzb.equals(((zzfr) obj2).zzb);
        }
        return true;
    }

    @Override
    public final boolean zzk(Object obj) {
        int i;
        int i2;
        List list;
        zzhl zzhlVarZzv;
        int i3;
        int i4 = 0;
        int i5 = 0;
        int i6 = 1048575;
        while (i5 < this.zzj) {
            int[] iArr = this.zzi;
            int[] iArr2 = this.zzc;
            int i7 = iArr[i5];
            int i8 = iArr2[i7];
            int iZzs = zzs(i7);
            int i9 = iArr2[i7 + 2];
            int i10 = i9 & 1048575;
            int i11 = 1 << (i9 >>> 20);
            if (i10 != i6) {
                if (i10 != 1048575) {
                    i4 = zzb.getInt(obj, i10);
                }
                i2 = i4;
                i = i10;
            } else {
                i = i6;
                i2 = i4;
            }
            if ((268435456 & iZzs) != 0 && !zzJ(obj, i7, i, i2, i11)) {
                return false;
            }
            int iZzr = zzr(iZzs);
            if (iZzr == 9 || iZzr == 17) {
                if (zzJ(obj, i7, i, i2, i11) && !zzK(obj, iZzs, zzv(i7))) {
                    return false;
                }
            } else if (iZzr == 27) {
                list = (List) zzii.zzf(obj, iZzs & 1048575);
                if (list.isEmpty()) {
                    continue;
                } else {
                    zzhlVarZzv = zzv(i7);
                    for (i3 = 0; i3 < list.size(); i3++) {
                        if (!zzhlVarZzv.zzk(list.get(i3))) {
                            return false;
                        }
                    }
                }
            } else if (iZzr == 60 || iZzr == 68) {
                if (zzM(obj, i8, i7) && !zzK(obj, iZzs, zzv(i7))) {
                    return false;
                }
            } else if (iZzr == 49) {
                list = (List) zzii.zzf(obj, iZzs & 1048575);
                if (list.isEmpty()) {
                    zzhlVarZzv = zzv(i7);
                    while (i3 < list.size()) {
                        if (!zzhlVarZzv.zzk(list.get(i3))) {
                            return false;
                        }
                    }
                } else {
                    continue;
                }
            } else if (iZzr != 50) {
                continue;
            } else {
                zzgv zzgvVar = (zzgv) zzii.zzf(obj, iZzs & 1048575);
                if (!zzgvVar.isEmpty() && ((zzgu) zzw(i7)).zzc().zzc.zzb() == zzis.MESSAGE) {
                    zzhl zzhlVarZzb = null;
                    for (Object obj2 : zzgvVar.values()) {
                        if (zzhlVarZzb == null) {
                            zzhlVarZzb = zzhi.zza().zzb(obj2.getClass());
                        }
                        if (!zzhlVarZzb.zzk(obj2)) {
                            return false;
                        }
                    }
                }
            }
            i5++;
            i6 = i;
            i4 = i2;
        }
        return !this.zzh || ((zzfr) obj).zzb.zzj();
    }
}
