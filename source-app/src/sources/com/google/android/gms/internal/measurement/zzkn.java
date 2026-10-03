package com.google.android.gms.internal.measurement;

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
import sun.misc.Unsafe;

final class zzkn<T> implements zzlb<T> {
    private static final int[] zza = new int[0];
    private static final Unsafe zzb = zzmg.zzb();
    private final int[] zzc;
    private final Object[] zzd;
    private final int zze;
    private final int zzf;
    private final zzkj zzg;
    private final boolean zzh;
    private final boolean zzi;
    private final zzky zzj;
    private final boolean zzk;
    private final int[] zzl;
    private final int zzm;
    private final int zzn;
    private final zzkr zzo;
    private final zzjs zzp;
    private final zzma<?, ?> zzq;
    private final zzim<?> zzr;
    private final zzkg zzs;

    private static <T> double zza(T t, long j) {
        return ((Double) zzmg.zze(t, j)).doubleValue();
    }

    private static boolean zzg(int i) {
        return (i & 536870912) != 0;
    }

    private static <T> float zzb(T t, long j) {
        return ((Float) zzmg.zze(t, j)).floatValue();
    }

    private static int zza(byte[] bArr, int i, int i2, zzmn zzmnVar, Class<?> cls, zzhl zzhlVar) throws IOException {
        switch (zzkq.zza[zzmnVar.ordinal()]) {
            case 1:
                int iZzd = zzhi.zzd(bArr, i, zzhlVar);
                zzhlVar.zzc = Boolean.valueOf(zzhlVar.zzb != 0);
                return iZzd;
            case 2:
                return zzhi.zza(bArr, i, zzhlVar);
            case 3:
                zzhlVar.zzc = Double.valueOf(zzhi.zza(bArr, i));
                return i + 8;
            case 4:
            case 5:
                zzhlVar.zzc = Integer.valueOf(zzhi.zzc(bArr, i));
                return i + 4;
            case 6:
            case 7:
                zzhlVar.zzc = Long.valueOf(zzhi.zzd(bArr, i));
                return i + 8;
            case 8:
                zzhlVar.zzc = Float.valueOf(zzhi.zzb(bArr, i));
                return i + 4;
            case 9:
            case 10:
            case 11:
                int iZzc = zzhi.zzc(bArr, i, zzhlVar);
                zzhlVar.zzc = Integer.valueOf(zzhlVar.zza);
                return iZzc;
            case 12:
            case 13:
                int iZzd2 = zzhi.zzd(bArr, i, zzhlVar);
                zzhlVar.zzc = Long.valueOf(zzhlVar.zzb);
                return iZzd2;
            case 14:
                return zzhi.zza(zzkx.zza().zza((Class) cls), bArr, i, i2, zzhlVar);
            case 15:
                int iZzc2 = zzhi.zzc(bArr, i, zzhlVar);
                zzhlVar.zzc = Integer.valueOf(zzib.zze(zzhlVar.zza));
                return iZzc2;
            case 16:
                int iZzd3 = zzhi.zzd(bArr, i, zzhlVar);
                zzhlVar.zzc = Long.valueOf(zzib.zza(zzhlVar.zzb));
                return iZzd3;
            case 17:
                return zzhi.zzb(bArr, i, zzhlVar);
            default:
                throw new RuntimeException("unsupported field type.");
        }
    }

    @Override
    public final int zza(T t) {
        int i;
        ?? r16;
        ?? r5;
        ?? r15;
        int iZza;
        int iZzb;
        int iZzd;
        int iZzd2;
        int iZzi;
        int iZzj;
        ?? r1;
        Unsafe unsafe = zzb;
        ?? r9 = 0;
        int i2 = 1048575;
        ?? r2 = 0;
        int i3 = 0;
        int iZzh = 0;
        int i4 = 1048575;
        while (i3 < this.zzc.length) {
            int iZzc = zzc(i3);
            int i5 = (267386880 & iZzc) >>> 20;
            int[] iArr = this.zzc;
            int i6 = iArr[i3];
            int i7 = iArr[i3 + 2];
            int i8 = i7 & i2;
            if (i5 <= 17) {
                if (i8 != i4) {
                    r1 = i8 == i2 ? r9 : unsafe.getInt(t, i8);
                    i4 = i8;
                }
                i = i4;
                r16 = r1;
                r5 = 1 << (i7 >>> 20);
            } else {
                r1 = r2;
                i = i4;
                r16 = r2 == true ? 1 : 0;
                r5 = r9;
            }
            long j = iZzc & i2;
            if (i5 >= zzir.DOUBLE_LIST_PACKED.zza()) {
                zzir.SINT64_LIST_PACKED.zza();
            }
            ?? r17 = r5;
            switch (i5) {
                case 0:
                    r15 = r9;
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZza = zzig.zza(i6, 0.0d);
                        r15 = r15;
                        iZzh += iZza;
                    }
                    break;
                case 1:
                    r15 = r9;
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZza = zzig.zza(i6, 0.0f);
                        r15 = r15;
                        iZzh += iZza;
                    }
                    break;
                case 2:
                    r15 = r9;
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZza = zzig.zzd(i6, unsafe.getLong(t, j));
                        r15 = r15;
                        iZzh += iZza;
                    }
                    break;
                case 3:
                    r15 = r9;
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZza = zzig.zzg(i6, unsafe.getLong(t, j));
                        r15 = r15;
                        iZzh += iZza;
                    }
                    break;
                case 4:
                    r15 = r9;
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZza = zzig.zzg(i6, unsafe.getInt(t, j));
                        r15 = r15;
                        iZzh += iZza;
                    }
                    break;
                case 5:
                    r15 = r9;
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZza = zzig.zzc(i6, 0L);
                        r15 = r15;
                        iZzh += iZza;
                    }
                    break;
                case 6:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        r15 = 0;
                        iZza = zzig.zzf(i6, 0);
                        iZzh += iZza;
                    } else {
                        r15 = 0;
                    }
                    break;
                case 7:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzig.zzb(i6, true);
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 8:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        Object object = unsafe.getObject(t, j);
                        if (object instanceof zzhm) {
                            iZzb = zzig.zzc(i6, (zzhm) object);
                        } else {
                            iZzb = zzig.zzb(i6, (String) object);
                        }
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 9:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzld.zza(i6, unsafe.getObject(t, j), zze(i3));
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 10:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzig.zzc(i6, (zzhm) unsafe.getObject(t, j));
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 11:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzig.zzj(i6, unsafe.getInt(t, j));
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 12:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzig.zze(i6, unsafe.getInt(t, j));
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 13:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzh += zzig.zzh(i6, 0);
                    }
                    r15 = 0;
                    break;
                case 14:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzig.zze(i6, 0L);
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 15:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzig.zzi(i6, unsafe.getInt(t, j));
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 16:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzig.zzf(i6, unsafe.getLong(t, j));
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 17:
                    if (zza(t, i3, i, r16 == true ? 1 : 0, r17 == true ? 1 : 0)) {
                        iZzb = zzig.zzb(i6, (zzkj) unsafe.getObject(t, j), zze(i3));
                        iZzh += iZzb;
                    }
                    r15 = 0;
                    break;
                case 18:
                    iZzd = zzld.zzd(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 19:
                    iZzd = zzld.zzc(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 20:
                    iZzd = zzld.zzf(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                    iZzd = zzld.zzj(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 22:
                    iZzd = zzld.zze(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case ConnectionResult.API_DISABLED:
                    iZzd = zzld.zzd(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                    iZzd = zzld.zzc(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 25:
                    iZzd = zzld.zza(i6, (List<?>) unsafe.getObject(t, j), (boolean) r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 26:
                    iZzd = zzld.zzb(i6, (List) unsafe.getObject(t, j));
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 27:
                    iZzd = zzld.zzb(i6, (List<?>) unsafe.getObject(t, j), zze(i3));
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 28:
                    iZzd = zzld.zza(i6, (List<zzhm>) unsafe.getObject(t, j));
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 29:
                    iZzd = zzld.zzi(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case l11l11lI1lll.l11l1111Il1l:
                    iZzd = zzld.zzb(i6, (List<Integer>) unsafe.getObject(t, j), (boolean) r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 31:
                    iZzd = zzld.zzc(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 32:
                    iZzd = zzld.zzd(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case Encoder.DEFAULT_EC_PERCENT:
                    iZzd = zzld.zzg(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 34:
                    iZzd = zzld.zzh(i6, (List) unsafe.getObject(t, j), r9);
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 35:
                    iZzd2 = zzld.zzd((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 36:
                    iZzd2 = zzld.zzc((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 37:
                    iZzd2 = zzld.zzf((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 38:
                    iZzd2 = zzld.zzj((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 39:
                    iZzd2 = zzld.zze((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 40:
                    iZzd2 = zzld.zzd((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 41:
                    iZzd2 = zzld.zzc((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 42:
                    iZzd2 = zzld.zza((List<?>) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 43:
                    iZzd2 = zzld.zzi((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 44:
                    iZzd2 = zzld.zzb((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 45:
                    iZzd2 = zzld.zzc((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 46:
                    iZzd2 = zzld.zzd((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 47:
                    iZzd2 = zzld.zzg((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 48:
                    iZzd2 = zzld.zzh((List) unsafe.getObject(t, j));
                    if (iZzd2 > 0) {
                        iZzi = zzig.zzi(i6);
                        iZzj = zzig.zzj(iZzd2);
                        iZzh += iZzi + iZzj + iZzd2;
                    }
                    r15 = r9;
                    break;
                case 49:
                    iZzd = zzld.zza(i6, (List<zzkj>) unsafe.getObject(t, j), zze(i3));
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case l1l1l11Il.l11l111I11l:
                    iZzd = this.zzs.zza(i6, unsafe.getObject(t, j), zzf(i3));
                    iZzh += iZzd;
                    r15 = r9;
                    break;
                case 51:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zza(i6, 0.0d);
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 52:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zza(i6, 0.0f);
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 53:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzd(i6, zzd(t, j));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 54:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzg(i6, zzd(t, j));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 55:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzg(i6, zzc(t, j));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 56:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzc(i6, 0L);
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 57:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzf(i6, (int) r9);
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 58:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzb(i6, true);
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 59:
                    if (zzc(t, i6, i3)) {
                        Object object2 = unsafe.getObject(t, j);
                        if (object2 instanceof zzhm) {
                            iZzd = zzig.zzc(i6, (zzhm) object2);
                        } else {
                            iZzd = zzig.zzb(i6, (String) object2);
                        }
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case l11l111l11Il.l11l11l1llIl:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzld.zza(i6, unsafe.getObject(t, j), zze(i3));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 61:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzc(i6, (zzhm) unsafe.getObject(t, j));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 62:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzj(i6, zzc(t, j));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 63:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zze(i6, zzc(t, j));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case UserMetadata.MAX_ATTRIBUTES:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzh(i6, (int) r9);
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 65:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zze(i6, 0L);
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 66:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzi(i6, zzc(t, j));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 67:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzf(i6, zzd(t, j));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                case 68:
                    if (zzc(t, i6, i3)) {
                        iZzd = zzig.zzb(i6, (zzkj) unsafe.getObject(t, j), zze(i3));
                        iZzh += iZzd;
                    }
                    r15 = r9;
                    break;
                default:
                    r15 = r9;
                    break;
            }
            i3 += 3;
            i4 = i;
            r9 = r15;
            r2 = r16;
            i2 = 1048575;
        }
        ?? r18 = r9;
        zzma<?, ?> zzmaVar = this.zzq;
        int iZza2 = iZzh + zzmaVar.zza(zzmaVar.zzd(t));
        if (!this.zzh) {
            return iZza2;
        }
        zziq zziqVarZza = this.zzr.zza(t);
        ?? r10 = r18;
        ?? Zza = r18;
        while (r10 < zziqVarZza.zza.zzb()) {
            Map.Entry entryZzb = zziqVarZza.zza.zzb(r10);
            r10++;
            Zza += zziq.zza((zzis<?>) entryZzb.getKey(), entryZzb.getValue());
        }
        ?? Zza2 = Zza;
        for (Map.Entry entry : zziqVarZza.zza.zzc()) {
            Zza2 += zziq.zza((zzis<?>) entry.getKey(), entry.getValue());
        }
        return iZza2 + Zza2;
    }

    @Override
    public final int zzb(T t) {
        int i;
        int iZza;
        int length = this.zzc.length;
        int i2 = 0;
        for (int i3 = 0; i3 < length; i3 += 3) {
            int iZzc = zzc(i3);
            int i4 = this.zzc[i3];
            long j = 1048575 & iZzc;
            int iHashCode = 37;
            switch ((iZzc & 267386880) >>> 20) {
                case 0:
                    i = i2 * 53;
                    iZza = zziz.zza(Double.doubleToLongBits(zzmg.zza(t, j)));
                    i2 = i + iZza;
                    break;
                case 1:
                    i = i2 * 53;
                    iZza = Float.floatToIntBits(zzmg.zzb(t, j));
                    i2 = i + iZza;
                    break;
                case 2:
                    i = i2 * 53;
                    iZza = zziz.zza(zzmg.zzd(t, j));
                    i2 = i + iZza;
                    break;
                case 3:
                    i = i2 * 53;
                    iZza = zziz.zza(zzmg.zzd(t, j));
                    i2 = i + iZza;
                    break;
                case 4:
                    i = i2 * 53;
                    iZza = zzmg.zzc(t, j);
                    i2 = i + iZza;
                    break;
                case 5:
                    i = i2 * 53;
                    iZza = zziz.zza(zzmg.zzd(t, j));
                    i2 = i + iZza;
                    break;
                case 6:
                    i = i2 * 53;
                    iZza = zzmg.zzc(t, j);
                    i2 = i + iZza;
                    break;
                case 7:
                    i = i2 * 53;
                    iZza = zziz.zza(zzmg.zzh(t, j));
                    i2 = i + iZza;
                    break;
                case 8:
                    i = i2 * 53;
                    iZza = ((String) zzmg.zze(t, j)).hashCode();
                    i2 = i + iZza;
                    break;
                case 9:
                    Object objZze = zzmg.zze(t, j);
                    if (objZze != null) {
                        iHashCode = objZze.hashCode();
                    }
                    i2 = (i2 * 53) + iHashCode;
                    break;
                case 10:
                    i = i2 * 53;
                    iZza = zzmg.zze(t, j).hashCode();
                    i2 = i + iZza;
                    break;
                case 11:
                    i = i2 * 53;
                    iZza = zzmg.zzc(t, j);
                    i2 = i + iZza;
                    break;
                case 12:
                    i = i2 * 53;
                    iZza = zzmg.zzc(t, j);
                    i2 = i + iZza;
                    break;
                case 13:
                    i = i2 * 53;
                    iZza = zzmg.zzc(t, j);
                    i2 = i + iZza;
                    break;
                case 14:
                    i = i2 * 53;
                    iZza = zziz.zza(zzmg.zzd(t, j));
                    i2 = i + iZza;
                    break;
                case 15:
                    i = i2 * 53;
                    iZza = zzmg.zzc(t, j);
                    i2 = i + iZza;
                    break;
                case 16:
                    i = i2 * 53;
                    iZza = zziz.zza(zzmg.zzd(t, j));
                    i2 = i + iZza;
                    break;
                case 17:
                    Object objZze2 = zzmg.zze(t, j);
                    if (objZze2 != null) {
                        iHashCode = objZze2.hashCode();
                    }
                    i2 = (i2 * 53) + iHashCode;
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
                    i = i2 * 53;
                    iZza = zzmg.zze(t, j).hashCode();
                    i2 = i + iZza;
                    break;
                case l1l1l11Il.l11l111I11l:
                    i = i2 * 53;
                    iZza = zzmg.zze(t, j).hashCode();
                    i2 = i + iZza;
                    break;
                case 51:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zziz.zza(Double.doubleToLongBits(zza(t, j)));
                        i2 = i + iZza;
                    }
                    break;
                case 52:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = Float.floatToIntBits(zzb(t, j));
                        i2 = i + iZza;
                    }
                    break;
                case 53:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zziz.zza(zzd(t, j));
                        i2 = i + iZza;
                    }
                    break;
                case 54:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zziz.zza(zzd(t, j));
                        i2 = i + iZza;
                    }
                    break;
                case 55:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzc(t, j);
                        i2 = i + iZza;
                    }
                    break;
                case 56:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zziz.zza(zzd(t, j));
                        i2 = i + iZza;
                    }
                    break;
                case 57:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzc(t, j);
                        i2 = i + iZza;
                    }
                    break;
                case 58:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zziz.zza(zze(t, j));
                        i2 = i + iZza;
                    }
                    break;
                case 59:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = ((String) zzmg.zze(t, j)).hashCode();
                        i2 = i + iZza;
                    }
                    break;
                case l11l111l11Il.l11l11l1llIl:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzmg.zze(t, j).hashCode();
                        i2 = i + iZza;
                    }
                    break;
                case 61:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzmg.zze(t, j).hashCode();
                        i2 = i + iZza;
                    }
                    break;
                case 62:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzc(t, j);
                        i2 = i + iZza;
                    }
                    break;
                case 63:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzc(t, j);
                        i2 = i + iZza;
                    }
                    break;
                case UserMetadata.MAX_ATTRIBUTES:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzc(t, j);
                        i2 = i + iZza;
                    }
                    break;
                case 65:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zziz.zza(zzd(t, j));
                        i2 = i + iZza;
                    }
                    break;
                case 66:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzc(t, j);
                        i2 = i + iZza;
                    }
                    break;
                case 67:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zziz.zza(zzd(t, j));
                        i2 = i + iZza;
                    }
                    break;
                case 68:
                    if (zzc(t, i4, i3)) {
                        i = i2 * 53;
                        iZza = zzmg.zze(t, j).hashCode();
                        i2 = i + iZza;
                    }
                    break;
            }
        }
        int iHashCode2 = (i2 * 53) + this.zzq.zzd(t).hashCode();
        return this.zzh ? (iHashCode2 * 53) + this.zzr.zza(t).hashCode() : iHashCode2;
    }

    private static <T> int zzc(T t, long j) {
        return ((Integer) zzmg.zze(t, j)).intValue();
    }

    final int zza(T t, byte[] bArr, int i, int i2, int i3, zzhl zzhlVar) throws IOException {
        Unsafe unsafe;
        zzkn<T> zzknVar;
        int i4;
        int iZza;
        int iZza2;
        int i5;
        zzhl zzhlVar2;
        int i6;
        int i7;
        int i8;
        int i9;
        int i10;
        int i11;
        int i12;
        int i13;
        int i14;
        zzhl zzhlVar3;
        int i15;
        zzjf zzjfVar;
        int i16;
        int i17;
        int i18;
        int i19;
        int i20;
        zzhl zzhlVar4;
        char c;
        int iZza3;
        int i21;
        int iZzc;
        ?? r11;
        int i22;
        int iZza4;
        int i23;
        int i24;
        int iZzd;
        int i25;
        int i26;
        int iZza5;
        int iZzc2;
        int i27;
        int i28;
        int i29;
        zzkn<T> zzknVar2 = this;
        T t2 = t;
        i2 = i2;
        zzhl zzhlVar5 = zzhlVar;
        zzf(t);
        Unsafe unsafe2 = zzb;
        int i30 = -1;
        int iZza6 = i;
        int i31 = -1;
        int i32 = 0;
        int i33 = 0;
        int i34 = 0;
        int i35 = 1048575;
        while (true) {
            if (iZza6 < i2) {
                int i36 = iZza6 + 1;
                int i37 = bArr[iZza6];
                if (i37 < 0) {
                    iZza = zzhi.zza(i37, bArr, i36, zzhlVar5);
                    i37 = zzhlVar5.zza;
                } else {
                    iZza = i36;
                }
                int i38 = i37 >>> 3;
                int i39 = i37 & 7;
                if (i38 > i31) {
                    iZza2 = (i38 < zzknVar2.zze || i38 > zzknVar2.zzf) ? i30 : zzknVar2.zza(i38, i32 / 3);
                } else {
                    iZza2 = zzknVar2.zza(i38);
                }
                int i40 = iZza2;
                if (i40 != i30) {
                    int[] iArr = zzknVar2.zzc;
                    int i41 = iArr[i40 + 1];
                    int i42 = (i41 & 267386880) >>> 20;
                    int i43 = i37;
                    long j = i41 & 1048575;
                    if (i42 <= 17) {
                        int i44 = iArr[i40 + 2];
                        int i45 = 1 << (i44 >>> 20);
                        int i46 = 1048575;
                        int i47 = i44 & 1048575;
                        if (i47 != i35) {
                            if (i35 != 1048575) {
                                unsafe2.putInt(t2, i35, i34);
                                i46 = 1048575;
                            }
                            i8 = i47;
                            i7 = i47 == i46 ? 0 : unsafe2.getInt(t2, i47);
                        } else {
                            i7 = i34;
                            i8 = i35;
                        }
                        switch (i42) {
                            case 0:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 1) {
                                    zzmg.zza(t2, j, zzhi.zza(bArr, iZza));
                                    iZza6 = iZza + 8;
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 1:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 5) {
                                    zzmg.zza((Object) t2, j, zzhi.zzb(bArr, iZza));
                                    iZza6 = iZza + 4;
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 2:
                            case 3:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 0) {
                                    int iZzd2 = zzhi.zzd(bArr, iZza, zzhlVar5);
                                    unsafe2.putLong(t, j, zzhlVar5.zzb);
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i30 = -1;
                                    i35 = i8;
                                    i34 = i7 | i45;
                                    iZza6 = iZzd2;
                                    i33 = i13 == true ? 1 : 0;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 4:
                            case 11:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 0) {
                                    iZza6 = zzhi.zzc(bArr, iZza, zzhlVar5);
                                    unsafe2.putInt(t2, j, zzhlVar5.zza);
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 5:
                            case 14:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 1) {
                                    unsafe2.putLong(t, j, zzhi.zzd(bArr, iZza));
                                    iZza6 = iZza + 8;
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 6:
                            case 13:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 5) {
                                    unsafe2.putInt(t2, j, zzhi.zzc(bArr, iZza));
                                    iZza6 = iZza + 4;
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 7:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 0) {
                                    iZza6 = zzhi.zzd(bArr, iZza, zzhlVar5);
                                    zzmg.zzc(t2, j, zzhlVar5.zzb != 0);
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 8:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 2) {
                                    if (zzg(i41)) {
                                        iZza6 = zzhi.zzb(bArr, iZza, zzhlVar5);
                                    } else {
                                        iZza6 = zzhi.zzc(bArr, iZza, zzhlVar5);
                                        int i48 = zzhlVar5.zza;
                                        if (i48 < 0) {
                                            throw zzji.zzf();
                                        }
                                        if (i48 == 0) {
                                            zzhlVar5.zzc = "";
                                        } else {
                                            zzhlVar5.zzc = new String(bArr, iZza6, i48, zziz.zza);
                                            iZza6 += i48;
                                        }
                                    }
                                    unsafe2.putObject(t2, j, zzhlVar5.zzc);
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 9:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 2) {
                                    Object objZza = zzknVar2.zza((Object) t2, i9);
                                    i2 = i2;
                                    iZza6 = zzhi.zza(objZza, zzknVar2.zze(i9), bArr, iZza, i2, zzhlVar);
                                    zzknVar2.zza(t2, i9, objZza);
                                    i14 = i7 | i45;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 10:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 2) {
                                    iZza6 = zzhi.zza(bArr, iZza, zzhlVar5);
                                    unsafe2.putObject(t2, j, zzhlVar5.zzc);
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 12:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 0) {
                                    iZza6 = zzhi.zzc(bArr, iZza, zzhlVar5);
                                    int i49 = zzhlVar5.zza;
                                    zzje zzjeVarZzd = zzknVar2.zzd(i9);
                                    if ((i41 & Integer.MIN_VALUE) == 0 || zzjeVarZzd == null || zzjeVarZzd.zza(i49)) {
                                        unsafe2.putInt(t2, j, i49);
                                        i14 = i7 | i45;
                                        i2 = i2;
                                        zzhlVar5 = zzhlVar5;
                                        i33 = i13;
                                        i32 = i9;
                                        unsafe2 = unsafe2;
                                        i31 = i12;
                                        i35 = i8;
                                        i34 = i14;
                                        i30 = i5;
                                    } else {
                                        zze(t).zza(i13 == true ? 1 : 0, Long.valueOf(i49));
                                        i2 = i2;
                                        zzhlVar5 = zzhlVar5;
                                        i33 = i13 == true ? 1 : 0;
                                        i32 = i9;
                                        unsafe2 = unsafe2;
                                        i31 = i12;
                                        i30 = -1;
                                        i34 = i7;
                                        i35 = i8;
                                    }
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 15:
                                unsafe2 = unsafe2;
                                i9 = i40;
                                zzhlVar5 = zzhlVar5;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                if (i39 == 0) {
                                    iZza6 = zzhi.zzc(bArr, iZza, zzhlVar5);
                                    unsafe2.putInt(t2, j, zzib.zze(zzhlVar5.zza));
                                    i14 = i7 | i45;
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i13;
                                    i32 = i9;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i35 = i8;
                                    i34 = i14;
                                    i30 = i5;
                                } else {
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 16:
                                i12 = i38;
                                if (i39 == 0) {
                                    int iZzd3 = zzhi.zzd(bArr, iZza, zzhlVar5);
                                    unsafe2.putLong(t, j, zzib.zza(zzhlVar5.zzb));
                                    i2 = i2;
                                    zzhlVar5 = zzhlVar5;
                                    i33 = i43 == true ? 1 : 0;
                                    i32 = i40;
                                    unsafe2 = unsafe2;
                                    i31 = i12;
                                    i30 = -1;
                                    i35 = i8;
                                    i34 = i7 | i45;
                                    iZza6 = iZzd3;
                                } else {
                                    i9 = i40;
                                    i13 = i43 == true ? 1 : 0;
                                    i5 = -1;
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            case 17:
                                if (i39 == 3) {
                                    Object objZza2 = zzknVar2.zza((Object) t2, i40);
                                    int iZza7 = zzhi.zza(objZza2, zzknVar2.zze(i40), bArr, iZza, i2, (i38 << 3) | 4, zzhlVar);
                                    zzknVar2.zza(t2, i40, objZza2);
                                    i34 = i7 | i45;
                                    i32 = i40;
                                    iZza6 = iZza7;
                                    i31 = i38;
                                    i33 = i43 == true ? 1 : 0;
                                    i35 = i8;
                                    i30 = -1;
                                } else {
                                    i12 = i38;
                                    i9 = i40;
                                    unsafe2 = unsafe2;
                                    i13 = i43 == true ? 1 : 0;
                                    i5 = -1;
                                    zzhlVar5 = zzhlVar5;
                                    this = zzknVar2;
                                    zzhlVar2 = zzhlVar5;
                                    i6 = iZza;
                                    unsafe = unsafe2;
                                    i11 = i12;
                                    i10 = i13;
                                }
                                break;
                            default:
                                i9 = i40;
                                i12 = i38;
                                i13 = i43 == true ? 1 : 0;
                                i5 = -1;
                                this = zzknVar2;
                                zzhlVar2 = zzhlVar5;
                                i6 = iZza;
                                unsafe = unsafe2;
                                i11 = i12;
                                i10 = i13;
                                break;
                        }
                    } else {
                        i5 = -1;
                        zzhl zzhlVar6 = zzhlVar5;
                        if (i42 != 27) {
                            i7 = i34;
                            i8 = i35;
                            zzhlVar3 = zzhlVar6;
                            int i50 = i43 == true ? 1 : 0;
                            if (i42 <= 49) {
                                long j2 = i41;
                                Unsafe unsafe3 = zzb;
                                Unsafe unsafe4 = unsafe2;
                                zzjf zzjfVar2 = (zzjf) unsafe3.getObject(t2, j);
                                if (zzjfVar2.zzc()) {
                                    zzjfVar = zzjfVar2;
                                } else {
                                    int size = zzjfVar2.size();
                                    zzjf zzjfVarZza = zzjfVar2.zza(size != 0 ? size << 1 : 10);
                                    unsafe3.putObject(t2, j, zzjfVarZza);
                                    zzjfVar = zzjfVarZza;
                                }
                                switch (i42) {
                                    case 18:
                                    case 35:
                                        i16 = i2;
                                        i17 = i40;
                                        zzjf zzjfVar3 = zzjfVar;
                                        unsafe = unsafe4;
                                        if (i39 == 2) {
                                            zzii zziiVar = (zzii) zzjfVar3;
                                            iZza6 = zzhi.zzc(bArr, iZza, zzhlVar3);
                                            int i51 = zzhlVar3.zza + iZza6;
                                            while (iZza6 < i51) {
                                                zziiVar.zza(zzhi.zza(bArr, iZza6));
                                                iZza6 += 8;
                                            }
                                            if (iZza6 != i51) {
                                                throw zzji.zzh();
                                            }
                                        } else if (i39 == 1) {
                                            zzii zziiVar2 = (zzii) zzjfVar3;
                                            zziiVar2.zza(zzhi.zza(bArr, iZza));
                                            iZza6 = iZza + 8;
                                            while (iZza6 < i16) {
                                                int iZzc3 = zzhi.zzc(bArr, iZza6, zzhlVar3);
                                                if (i50 == zzhlVar3.zza) {
                                                    zziiVar2.zza(zzhi.zza(bArr, iZzc3));
                                                    iZza6 = iZzc3 + 8;
                                                }
                                            }
                                        } else {
                                            iZza6 = iZza;
                                        }
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case 19:
                                    case 36:
                                        i16 = i2;
                                        i17 = i40;
                                        zzjf zzjfVar4 = zzjfVar;
                                        unsafe = unsafe4;
                                        if (i39 == 2) {
                                            zziw zziwVar = (zziw) zzjfVar4;
                                            iZza6 = zzhi.zzc(bArr, iZza, zzhlVar3);
                                            int i52 = zzhlVar3.zza + iZza6;
                                            while (iZza6 < i52) {
                                                zziwVar.zza(zzhi.zzb(bArr, iZza6));
                                                iZza6 += 4;
                                            }
                                            if (iZza6 != i52) {
                                                throw zzji.zzh();
                                            }
                                        } else if (i39 == 5) {
                                            zziw zziwVar2 = (zziw) zzjfVar4;
                                            zziwVar2.zza(zzhi.zzb(bArr, iZza));
                                            iZza6 = iZza + 4;
                                            while (iZza6 < i16) {
                                                int iZzc4 = zzhi.zzc(bArr, iZza6, zzhlVar3);
                                                if (i50 == zzhlVar3.zza) {
                                                    zziwVar2.zza(zzhi.zzb(bArr, iZzc4));
                                                    iZza6 = iZzc4 + 4;
                                                }
                                            }
                                        } else {
                                            iZza6 = iZza;
                                        }
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case 20:
                                    case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                                    case 37:
                                    case 38:
                                        i16 = i2;
                                        i17 = i40;
                                        zzjf zzjfVar5 = zzjfVar;
                                        unsafe = unsafe4;
                                        if (i39 == 2) {
                                            zzjy zzjyVar = (zzjy) zzjfVar5;
                                            iZza6 = zzhi.zzc(bArr, iZza, zzhlVar3);
                                            int i53 = zzhlVar3.zza + iZza6;
                                            while (iZza6 < i53) {
                                                iZza6 = zzhi.zzd(bArr, iZza6, zzhlVar3);
                                                zzjyVar.zza(zzhlVar3.zzb);
                                            }
                                            if (iZza6 != i53) {
                                                throw zzji.zzh();
                                            }
                                        } else if (i39 == 0) {
                                            zzjy zzjyVar2 = (zzjy) zzjfVar5;
                                            iZza6 = zzhi.zzd(bArr, iZza, zzhlVar3);
                                            zzjyVar2.zza(zzhlVar3.zzb);
                                            while (iZza6 < i16) {
                                                int iZzc5 = zzhi.zzc(bArr, iZza6, zzhlVar3);
                                                if (i50 == zzhlVar3.zza) {
                                                    iZza6 = zzhi.zzd(bArr, iZzc5, zzhlVar3);
                                                    zzjyVar2.zza(zzhlVar3.zzb);
                                                }
                                            }
                                        } else {
                                            iZza6 = iZza;
                                        }
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case 22:
                                    case 29:
                                    case 39:
                                    case 43:
                                        i16 = i2;
                                        i18 = i40;
                                        zzjf zzjfVar6 = zzjfVar;
                                        i19 = iZza;
                                        i20 = i50 == true ? 1 : 0;
                                        zzhlVar4 = zzhlVar3;
                                        unsafe = unsafe4;
                                        c = 65535;
                                        if (i39 == 2) {
                                            iZza3 = zzhi.zza(bArr, i19, (zzjf<?>) zzjfVar6, zzhlVar4);
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20;
                                            iZza = i19;
                                            iZza6 = iZza3;
                                            i17 = i18;
                                        } else if (i39 == 0) {
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20 == true ? 1 : 0;
                                            iZza = i19;
                                            i17 = i18;
                                            iZza6 = zzhi.zza(i20 == true ? 1 : 0, bArr, i19, i2, (zzjf<?>) zzjfVar6, zzhlVar);
                                        } else {
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20;
                                            iZza = i19;
                                            i17 = i18;
                                            iZza6 = iZza;
                                        }
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case ConnectionResult.API_DISABLED:
                                    case 32:
                                    case 40:
                                    case 46:
                                        i16 = i2;
                                        i18 = i40;
                                        zzjf zzjfVar7 = zzjfVar;
                                        i19 = iZza;
                                        i20 = i50 == true ? 1 : 0;
                                        zzhlVar4 = zzhlVar3;
                                        unsafe = unsafe4;
                                        c = 65535;
                                        if (i39 != 2) {
                                            if (i39 == 1) {
                                                zzjy zzjyVar3 = (zzjy) zzjfVar7;
                                                zzjyVar3.zza(zzhi.zzd(bArr, i19));
                                                i21 = i19 + 8;
                                                while (i21 < i16) {
                                                    int iZzc6 = zzhi.zzc(bArr, i21, zzhlVar4);
                                                    if (i20 != zzhlVar4.zza) {
                                                        zzhlVar3 = zzhlVar4;
                                                        i50 = i20;
                                                        i17 = i18;
                                                        iZza6 = i21;
                                                        iZza = i19;
                                                        if (iZza6 == iZza) {
                                                            t2 = t;
                                                            i6 = iZza6;
                                                            this = zzknVar2;
                                                            zzhlVar2 = zzhlVar3;
                                                            i11 = i38;
                                                            i10 = i50;
                                                            i9 = i17;
                                                        } else {
                                                            i2 = i16;
                                                            i32 = i17;
                                                            i33 = i50;
                                                            zzhlVar5 = zzhlVar3;
                                                            i31 = i38;
                                                            i30 = -1;
                                                            i34 = i7;
                                                            i35 = i8;
                                                            unsafe2 = unsafe;
                                                            t2 = t;
                                                        }
                                                    } else {
                                                        zzjyVar3.zza(zzhi.zzd(bArr, iZzc6));
                                                        i21 = iZzc6 + 8;
                                                    }
                                                    break;
                                                }
                                                zzhlVar3 = zzhlVar4;
                                                i50 = i20;
                                                i17 = i18;
                                                iZza6 = i21;
                                                iZza = i19;
                                                if (iZza6 == iZza) {
                                                    t2 = t;
                                                    i6 = iZza6;
                                                    this = zzknVar2;
                                                    zzhlVar2 = zzhlVar3;
                                                    i11 = i38;
                                                    i10 = i50;
                                                    i9 = i17;
                                                } else {
                                                    i2 = i16;
                                                    i32 = i17;
                                                    i33 = i50;
                                                    zzhlVar5 = zzhlVar3;
                                                    i31 = i38;
                                                    i30 = -1;
                                                    i34 = i7;
                                                    i35 = i8;
                                                    unsafe2 = unsafe;
                                                    t2 = t;
                                                }
                                            }
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20;
                                            iZza = i19;
                                            i17 = i18;
                                            iZza6 = iZza;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                            break;
                                        } else {
                                            zzjy zzjyVar4 = (zzjy) zzjfVar7;
                                            iZza3 = zzhi.zzc(bArr, i19, zzhlVar4);
                                            int i54 = zzhlVar4.zza + iZza3;
                                            while (iZza3 < i54) {
                                                zzjyVar4.zza(zzhi.zzd(bArr, iZza3));
                                                iZza3 += 8;
                                            }
                                            if (iZza3 != i54) {
                                                throw zzji.zzh();
                                            }
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20;
                                            iZza = i19;
                                            iZza6 = iZza3;
                                            i17 = i18;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        }
                                        break;
                                    case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                                    case 31:
                                    case 41:
                                    case 45:
                                        i16 = i2;
                                        i18 = i40;
                                        zzjf zzjfVar8 = zzjfVar;
                                        i19 = iZza;
                                        i20 = i50 == true ? 1 : 0;
                                        zzhlVar4 = zzhlVar3;
                                        unsafe = unsafe4;
                                        c = 65535;
                                        if (i39 != 2) {
                                            if (i39 == 5) {
                                                zzja zzjaVar = (zzja) zzjfVar8;
                                                zzjaVar.zzd(zzhi.zzc(bArr, i19));
                                                i21 = i19 + 4;
                                                while (i21 < i16) {
                                                    int iZzc7 = zzhi.zzc(bArr, i21, zzhlVar4);
                                                    if (i20 != zzhlVar4.zza) {
                                                        zzhlVar3 = zzhlVar4;
                                                        i50 = i20;
                                                        i17 = i18;
                                                        iZza6 = i21;
                                                        iZza = i19;
                                                        if (iZza6 == iZza) {
                                                            t2 = t;
                                                            i6 = iZza6;
                                                            this = zzknVar2;
                                                            zzhlVar2 = zzhlVar3;
                                                            i11 = i38;
                                                            i10 = i50;
                                                            i9 = i17;
                                                        } else {
                                                            i2 = i16;
                                                            i32 = i17;
                                                            i33 = i50;
                                                            zzhlVar5 = zzhlVar3;
                                                            i31 = i38;
                                                            i30 = -1;
                                                            i34 = i7;
                                                            i35 = i8;
                                                            unsafe2 = unsafe;
                                                            t2 = t;
                                                        }
                                                    } else {
                                                        zzjaVar.zzd(zzhi.zzc(bArr, iZzc7));
                                                        i21 = iZzc7 + 4;
                                                    }
                                                    break;
                                                }
                                                zzhlVar3 = zzhlVar4;
                                                i50 = i20;
                                                i17 = i18;
                                                iZza6 = i21;
                                                iZza = i19;
                                                if (iZza6 == iZza) {
                                                    t2 = t;
                                                    i6 = iZza6;
                                                    this = zzknVar2;
                                                    zzhlVar2 = zzhlVar3;
                                                    i11 = i38;
                                                    i10 = i50;
                                                    i9 = i17;
                                                } else {
                                                    i2 = i16;
                                                    i32 = i17;
                                                    i33 = i50;
                                                    zzhlVar5 = zzhlVar3;
                                                    i31 = i38;
                                                    i30 = -1;
                                                    i34 = i7;
                                                    i35 = i8;
                                                    unsafe2 = unsafe;
                                                    t2 = t;
                                                }
                                            }
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20;
                                            iZza = i19;
                                            i17 = i18;
                                            iZza6 = iZza;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                            break;
                                        } else {
                                            zzja zzjaVar2 = (zzja) zzjfVar8;
                                            iZza3 = zzhi.zzc(bArr, i19, zzhlVar4);
                                            int i55 = zzhlVar4.zza + iZza3;
                                            while (iZza3 < i55) {
                                                zzjaVar2.zzd(zzhi.zzc(bArr, iZza3));
                                                iZza3 += 4;
                                            }
                                            if (iZza3 != i55) {
                                                throw zzji.zzh();
                                            }
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20;
                                            iZza = i19;
                                            iZza6 = iZza3;
                                            i17 = i18;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        }
                                        break;
                                    case 25:
                                    case 42:
                                        i16 = i2;
                                        i18 = i40;
                                        zzjf zzjfVar9 = zzjfVar;
                                        i19 = iZza;
                                        i20 = i50 == true ? 1 : 0;
                                        zzhlVar4 = zzhlVar3;
                                        unsafe = unsafe4;
                                        c = 65535;
                                        if (i39 != 2) {
                                            if (i39 == 0) {
                                                zzhk zzhkVar = (zzhk) zzjfVar9;
                                                iZza3 = zzhi.zzd(bArr, i19, zzhlVar4);
                                                zzhkVar.zza(zzhlVar4.zzb != 0);
                                                while (iZza3 < i16) {
                                                    int iZzc8 = zzhi.zzc(bArr, iZza3, zzhlVar4);
                                                    if (i20 == zzhlVar4.zza) {
                                                        iZza3 = zzhi.zzd(bArr, iZzc8, zzhlVar4);
                                                        zzhkVar.zza(zzhlVar4.zzb != 0);
                                                    }
                                                }
                                            }
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20;
                                            iZza = i19;
                                            i17 = i18;
                                            iZza6 = iZza;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        } else {
                                            zzhk zzhkVar2 = (zzhk) zzjfVar9;
                                            iZza3 = zzhi.zzc(bArr, i19, zzhlVar4);
                                            int i56 = zzhlVar4.zza + iZza3;
                                            while (iZza3 < i56) {
                                                iZza3 = zzhi.zzd(bArr, iZza3, zzhlVar4);
                                                zzhkVar2.zza(zzhlVar4.zzb != 0);
                                            }
                                            if (iZza3 != i56) {
                                                throw zzji.zzh();
                                            }
                                        }
                                        zzhlVar3 = zzhlVar4;
                                        i50 = i20;
                                        iZza = i19;
                                        iZza6 = iZza3;
                                        i17 = i18;
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case 26:
                                        i16 = i2;
                                        i18 = i40;
                                        zzjf zzjfVar10 = zzjfVar;
                                        i19 = iZza;
                                        i20 = i50 == true ? 1 : 0;
                                        zzhlVar4 = zzhlVar3;
                                        unsafe = unsafe4;
                                        c = 65535;
                                        if (i39 == 2) {
                                            if ((j2 & 536870912) == 0) {
                                                iZzc = zzhi.zzc(bArr, i19, zzhlVar4);
                                                int i57 = zzhlVar4.zza;
                                                if (i57 < 0) {
                                                    throw zzji.zzf();
                                                }
                                                if (i57 == 0) {
                                                    r11 = r1;
                                                    zzjfVar10.add(r11);
                                                } else {
                                                    r11 = r1;
                                                    zzjfVar10.add(new String(bArr, iZzc, i57, zziz.zza));
                                                    iZzc += i57;
                                                }
                                                while (iZzc < i16) {
                                                    int iZzc9 = zzhi.zzc(bArr, iZzc, zzhlVar4);
                                                    if (i20 == zzhlVar4.zza) {
                                                        iZzc = zzhi.zzc(bArr, iZzc9, zzhlVar4);
                                                        int i58 = zzhlVar4.zza;
                                                        if (i58 < 0) {
                                                            throw zzji.zzf();
                                                        }
                                                        if (i58 == 0) {
                                                            zzjfVar10.add(r11);
                                                        } else {
                                                            zzjfVar10.add(new String(bArr, iZzc, i58, zziz.zza));
                                                            iZzc += i58;
                                                        }
                                                    }
                                                }
                                            } else {
                                                iZzc = zzhi.zzc(bArr, i19, zzhlVar4);
                                                int i59 = zzhlVar4.zza;
                                                if (i59 < 0) {
                                                    throw zzji.zzf();
                                                }
                                                if (i59 == 0) {
                                                    zzjfVar10.add("");
                                                } else {
                                                    int i60 = iZzc + i59;
                                                    if (!zzmh.zzc(bArr, iZzc, i60)) {
                                                        throw zzji.zzd();
                                                    }
                                                    zzjfVar10.add(new String(bArr, iZzc, i59, zziz.zza));
                                                    iZzc = i60;
                                                }
                                                while (iZzc < i16) {
                                                    int iZzc10 = zzhi.zzc(bArr, iZzc, zzhlVar4);
                                                    if (i20 == zzhlVar4.zza) {
                                                        iZzc = zzhi.zzc(bArr, iZzc10, zzhlVar4);
                                                        int i61 = zzhlVar4.zza;
                                                        if (i61 < 0) {
                                                            throw zzji.zzf();
                                                        }
                                                        if (i61 == 0) {
                                                            zzjfVar10.add("");
                                                        } else {
                                                            int i62 = iZzc + i61;
                                                            if (!zzmh.zzc(bArr, iZzc, i62)) {
                                                                throw zzji.zzd();
                                                            }
                                                            zzjfVar10.add(new String(bArr, iZzc, i61, zziz.zza));
                                                            iZzc = i62;
                                                        }
                                                    }
                                                }
                                            }
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20 == true ? 1 : 0;
                                            iZza = i19;
                                            iZza6 = iZzc;
                                            i17 = i18;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        }
                                        zzhlVar3 = zzhlVar4;
                                        i50 = i20;
                                        iZza = i19;
                                        i17 = i18;
                                        iZza6 = iZza;
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case 27:
                                        i16 = i2;
                                        i22 = i40;
                                        unsafe = unsafe4;
                                        if (i39 == 2) {
                                            i18 = i22;
                                            c = 65535;
                                            i19 = iZza;
                                            i20 = i50 == true ? 1 : 0;
                                            zzhlVar4 = zzhlVar3;
                                            iZza3 = zzhi.zza((zzlb<?>) zzknVar2.zze(i22), i50 == true ? 1 : 0, bArr, iZza, i2, (zzjf<?>) zzjfVar, zzhlVar);
                                            zzhlVar3 = zzhlVar4;
                                            i50 = i20;
                                            iZza = i19;
                                            iZza6 = iZza3;
                                            i17 = i18;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        }
                                        i17 = i22;
                                        iZza6 = iZza;
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case 28:
                                        i16 = i2;
                                        i22 = i40;
                                        unsafe = unsafe4;
                                        if (i39 == 2) {
                                            iZza6 = zzhi.zzc(bArr, iZza, zzhlVar3);
                                            int i63 = zzhlVar3.zza;
                                            if (i63 < 0) {
                                                throw zzji.zzf();
                                            }
                                            if (i63 > bArr.length - iZza6) {
                                                throw zzji.zzh();
                                            }
                                            if (i63 == 0) {
                                                zzjfVar.add(zzhm.zza);
                                            } else {
                                                zzjfVar.add(zzhm.zza(bArr, iZza6, i63));
                                                iZza6 += i63;
                                            }
                                            while (iZza6 < i16) {
                                                int iZzc11 = zzhi.zzc(bArr, iZza6, zzhlVar3);
                                                if (i50 != zzhlVar3.zza) {
                                                    i17 = i22;
                                                    if (iZza6 == iZza) {
                                                        t2 = t;
                                                        i6 = iZza6;
                                                        this = zzknVar2;
                                                        zzhlVar2 = zzhlVar3;
                                                        i11 = i38;
                                                        i10 = i50;
                                                        i9 = i17;
                                                    } else {
                                                        i2 = i16;
                                                        i32 = i17;
                                                        i33 = i50;
                                                        zzhlVar5 = zzhlVar3;
                                                        i31 = i38;
                                                        i30 = -1;
                                                        i34 = i7;
                                                        i35 = i8;
                                                        unsafe2 = unsafe;
                                                        t2 = t;
                                                    }
                                                    break;
                                                } else {
                                                    iZza6 = zzhi.zzc(bArr, iZzc11, zzhlVar3);
                                                    int i64 = zzhlVar3.zza;
                                                    if (i64 < 0) {
                                                        throw zzji.zzf();
                                                    }
                                                    if (i64 > bArr.length - iZza6) {
                                                        throw zzji.zzh();
                                                    }
                                                    if (i64 == 0) {
                                                        zzjfVar.add(zzhm.zza);
                                                    } else {
                                                        zzjfVar.add(zzhm.zza(bArr, iZza6, i64));
                                                        iZza6 += i64;
                                                    }
                                                }
                                            }
                                            i17 = i22;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        }
                                        i17 = i22;
                                        iZza6 = iZza;
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case l11l11lI1lll.l11l1111Il1l:
                                    case 44:
                                        i16 = i2;
                                        i22 = i40;
                                        unsafe = unsafe4;
                                        if (i39 != 2) {
                                            if (i39 == 0) {
                                                iZza4 = zzhi.zza(i50 == true ? 1 : 0, bArr, iZza, i2, (zzjf<?>) zzjfVar, zzhlVar);
                                            }
                                            i17 = i22;
                                            iZza6 = iZza;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        } else {
                                            iZza4 = zzhi.zza(bArr, iZza, (zzjf<?>) zzjfVar, zzhlVar3);
                                        }
                                        int i65 = iZza4;
                                        zzld.zza(t, i38, zzjfVar, zzknVar2.zzd(i22), null, zzknVar2.zzq);
                                        iZza6 = i65;
                                        i17 = i22;
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case Encoder.DEFAULT_EC_PERCENT:
                                    case 47:
                                        i16 = i2;
                                        i22 = i40;
                                        unsafe = unsafe4;
                                        if (i39 != 2) {
                                            if (i39 == 0) {
                                                zzja zzjaVar3 = (zzja) zzjfVar;
                                                iZza6 = zzhi.zzc(bArr, iZza, zzhlVar3);
                                                zzjaVar3.zzd(zzib.zze(zzhlVar3.zza));
                                                while (iZza6 < i16) {
                                                    int iZzc12 = zzhi.zzc(bArr, iZza6, zzhlVar3);
                                                    if (i50 == zzhlVar3.zza) {
                                                        iZza6 = zzhi.zzc(bArr, iZzc12, zzhlVar3);
                                                        zzjaVar3.zzd(zzib.zze(zzhlVar3.zza));
                                                    }
                                                }
                                            }
                                            i17 = i22;
                                            iZza6 = iZza;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        } else {
                                            zzja zzjaVar4 = (zzja) zzjfVar;
                                            iZza6 = zzhi.zzc(bArr, iZza, zzhlVar3);
                                            int i66 = zzhlVar3.zza + iZza6;
                                            while (iZza6 < i66) {
                                                iZza6 = zzhi.zzc(bArr, iZza6, zzhlVar3);
                                                zzjaVar4.zzd(zzib.zze(zzhlVar3.zza));
                                            }
                                            if (iZza6 != i66) {
                                                throw zzji.zzh();
                                            }
                                        }
                                        i17 = i22;
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case 34:
                                    case 48:
                                        i16 = i2;
                                        i22 = i40;
                                        unsafe = unsafe4;
                                        if (i39 != 2) {
                                            if (i39 == 0) {
                                                zzjy zzjyVar5 = (zzjy) zzjfVar;
                                                iZza6 = zzhi.zzd(bArr, iZza, zzhlVar3);
                                                zzjyVar5.zza(zzib.zza(zzhlVar3.zzb));
                                                while (iZza6 < i16) {
                                                    int iZzc13 = zzhi.zzc(bArr, iZza6, zzhlVar3);
                                                    if (i50 == zzhlVar3.zza) {
                                                        iZza6 = zzhi.zzd(bArr, iZzc13, zzhlVar3);
                                                        zzjyVar5.zza(zzib.zza(zzhlVar3.zzb));
                                                    }
                                                }
                                            }
                                            i17 = i22;
                                            iZza6 = iZza;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        } else {
                                            zzjy zzjyVar6 = (zzjy) zzjfVar;
                                            iZza6 = zzhi.zzc(bArr, iZza, zzhlVar3);
                                            int i67 = zzhlVar3.zza + iZza6;
                                            while (iZza6 < i67) {
                                                iZza6 = zzhi.zzd(bArr, iZza6, zzhlVar3);
                                                zzjyVar6.zza(zzib.zza(zzhlVar3.zzb));
                                            }
                                            if (iZza6 != i67) {
                                                throw zzji.zzh();
                                            }
                                        }
                                        i17 = i22;
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                    case 49:
                                        if (i39 == 3) {
                                            zzlb zzlbVarZze = zzknVar2.zze(i40);
                                            int i68 = ((i50 == true ? 1 : 0) & (-8)) | 4;
                                            unsafe = unsafe4;
                                            iZza6 = zzhi.zza(zzlbVarZze, bArr, iZza, i2, i68, zzhlVar);
                                            zzjfVar.add(zzhlVar3.zzc);
                                            for (int i69 = i2; iZza6 < i69; i69 = i69) {
                                                int iZzc14 = zzhi.zzc(bArr, iZza6, zzhlVar3);
                                                if (i50 != zzhlVar3.zza) {
                                                    i16 = i69;
                                                    i17 = i40;
                                                    if (iZza6 == iZza) {
                                                        t2 = t;
                                                        i6 = iZza6;
                                                        this = zzknVar2;
                                                        zzhlVar2 = zzhlVar3;
                                                        i11 = i38;
                                                        i10 = i50;
                                                        i9 = i17;
                                                    } else {
                                                        i2 = i16;
                                                        i32 = i17;
                                                        i33 = i50;
                                                        zzhlVar5 = zzhlVar3;
                                                        i31 = i38;
                                                        i30 = -1;
                                                        i34 = i7;
                                                        i35 = i8;
                                                        unsafe2 = unsafe;
                                                        t2 = t;
                                                    }
                                                } else {
                                                    iZza6 = zzhi.zza(zzlbVarZze, bArr, iZzc14, i2, i68, zzhlVar);
                                                    zzjfVar.add(zzhlVar3.zzc);
                                                }
                                                break;
                                            }
                                            i16 = i69;
                                            i17 = i40;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        } else {
                                            i16 = i2;
                                            unsafe = unsafe4;
                                            i17 = i40;
                                            iZza6 = iZza;
                                            if (iZza6 == iZza) {
                                                t2 = t;
                                                i6 = iZza6;
                                                this = zzknVar2;
                                                zzhlVar2 = zzhlVar3;
                                                i11 = i38;
                                                i10 = i50;
                                                i9 = i17;
                                            } else {
                                                i2 = i16;
                                                i32 = i17;
                                                i33 = i50;
                                                zzhlVar5 = zzhlVar3;
                                                i31 = i38;
                                                i30 = -1;
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                                t2 = t;
                                            }
                                        }
                                        break;
                                    default:
                                        i16 = i2;
                                        i17 = i40;
                                        unsafe = unsafe4;
                                        iZza6 = iZza;
                                        if (iZza6 == iZza) {
                                            t2 = t;
                                            i6 = iZza6;
                                            this = zzknVar2;
                                            zzhlVar2 = zzhlVar3;
                                            i11 = i38;
                                            i10 = i50;
                                            i9 = i17;
                                        } else {
                                            i2 = i16;
                                            i32 = i17;
                                            i33 = i50;
                                            zzhlVar5 = zzhlVar3;
                                            i31 = i38;
                                            i30 = -1;
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            t2 = t;
                                        }
                                        break;
                                }
                            } else {
                                unsafe = unsafe2;
                                int i70 = i40;
                                if (i42 != 50) {
                                    t2 = t;
                                    int i71 = i70;
                                    Unsafe unsafe5 = zzb;
                                    long j3 = iArr[i71 + 2] & 1048575;
                                    switch (i42) {
                                        case 51:
                                            this = this;
                                            i71 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 1) {
                                                unsafe5.putObject(t2, j, Double.valueOf(zzhi.zza(bArr, i23)));
                                                i24 = i23 + 8;
                                                unsafe5.putInt(t2, j3, i11);
                                                iZza6 = i24;
                                            } else {
                                                iZza6 = i23;
                                            }
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 52:
                                            this = this;
                                            i71 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 5) {
                                                unsafe5.putObject(t2, j, Float.valueOf(zzhi.zzb(bArr, i23)));
                                                i24 = i23 + 4;
                                                unsafe5.putInt(t2, j3, i11);
                                                iZza6 = i24;
                                            } else {
                                                iZza6 = i23;
                                            }
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 53:
                                        case 54:
                                            this = this;
                                            i71 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 0) {
                                                iZzd = zzhi.zzd(bArr, i23, zzhlVar2);
                                                unsafe5.putObject(t2, j, Long.valueOf(zzhlVar2.zzb));
                                                unsafe5.putInt(t2, j3, i11);
                                                iZza6 = iZzd;
                                            } else {
                                                iZza6 = i23;
                                            }
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 55:
                                        case 62:
                                            this = this;
                                            i71 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 0) {
                                                iZzd = zzhi.zzc(bArr, i23, zzhlVar2);
                                                unsafe5.putObject(t2, j, Integer.valueOf(zzhlVar2.zza));
                                                unsafe5.putInt(t2, j3, i11);
                                                iZza6 = iZzd;
                                            } else {
                                                iZza6 = i23;
                                            }
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 56:
                                        case 65:
                                            this = this;
                                            i71 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 1) {
                                                unsafe5.putObject(t2, j, Long.valueOf(zzhi.zzd(bArr, i23)));
                                                i24 = i23 + 8;
                                                unsafe5.putInt(t2, j3, i11);
                                                iZza6 = i24;
                                            } else {
                                                iZza6 = i23;
                                            }
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 57:
                                        case UserMetadata.MAX_ATTRIBUTES:
                                            this = this;
                                            i71 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 5) {
                                                unsafe5.putObject(t2, j, Integer.valueOf(zzhi.zzc(bArr, i23)));
                                                i24 = i23 + 4;
                                                unsafe5.putInt(t2, j3, i11);
                                                iZza6 = i24;
                                            } else {
                                                iZza6 = i23;
                                            }
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 58:
                                            this = this;
                                            i71 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 0) {
                                                iZzd = zzhi.zzd(bArr, i23, zzhlVar2);
                                                unsafe5.putObject(t2, j, Boolean.valueOf(zzhlVar2.zzb != 0));
                                                unsafe5.putInt(t2, j3, i11);
                                                iZza6 = iZzd;
                                            } else {
                                                iZza6 = i23;
                                            }
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 59:
                                            this = this;
                                            i71 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 2) {
                                                iZzd = zzhi.zzc(bArr, i23, zzhlVar2);
                                                int i72 = zzhlVar2.zza;
                                                if (i72 == 0) {
                                                    unsafe5.putObject(t2, j, "");
                                                } else {
                                                    if ((i41 & 536870912) != 0 && !zzmh.zzc(bArr, iZzd, iZzd + i72)) {
                                                        throw zzji.zzd();
                                                    }
                                                    unsafe5.putObject(t2, j, new String(bArr, iZzd, i72, zziz.zza));
                                                    iZzd += i72;
                                                }
                                                unsafe5.putInt(t2, j3, i11);
                                                iZza6 = iZzd;
                                            } else {
                                                iZza6 = i23;
                                            }
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case l11l111l11Il.l11l11l1llIl:
                                            this = this;
                                            i25 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i26 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 2) {
                                                Object objZza3 = this.zza(t2, i11, i25);
                                                iZza6 = zzhi.zza(objZza3, this.zze(i25), bArr, i23, i2, zzhlVar);
                                                this.zza(t2, i11, i25, objZza3);
                                                i71 = i25;
                                                this = this;
                                                i10 = i26;
                                                if (iZza6 == i23) {
                                                    i6 = iZza6;
                                                    i9 = i71;
                                                } else {
                                                    zzknVar2 = this;
                                                    zzhlVar5 = zzhlVar2;
                                                    i31 = i11;
                                                    i33 = i10 == true ? 1 : 0;
                                                    i30 = -1;
                                                    i32 = i71;
                                                }
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                            }
                                            i71 = i25;
                                            i10 = i26;
                                            iZza6 = i23;
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 61:
                                            this = this;
                                            i25 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i26 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 2) {
                                                iZza5 = zzhi.zza(bArr, i23, zzhlVar2);
                                                unsafe5.putObject(t2, j, zzhlVar2.zzc);
                                                unsafe5.putInt(t2, j3, i11);
                                                i71 = i25;
                                                iZza6 = iZza5;
                                                i10 = i26;
                                                if (iZza6 == i23) {
                                                    i6 = iZza6;
                                                    i9 = i71;
                                                } else {
                                                    zzknVar2 = this;
                                                    zzhlVar5 = zzhlVar2;
                                                    i31 = i11;
                                                    i33 = i10 == true ? 1 : 0;
                                                    i30 = -1;
                                                    i32 = i71;
                                                }
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                            }
                                            i71 = i25;
                                            i10 = i26;
                                            iZza6 = i23;
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 63:
                                            this = this;
                                            i25 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 0) {
                                                iZza5 = zzhi.zzc(bArr, i23, zzhlVar2);
                                                int i73 = zzhlVar2.zza;
                                                zzje zzjeVarZzd2 = this.zzd(i25);
                                                if (zzjeVarZzd2 == null || zzjeVarZzd2.zza(i73)) {
                                                    i26 = i50 == true ? 1 : 0;
                                                    unsafe5.putObject(t2, j, Integer.valueOf(i73));
                                                    unsafe5.putInt(t2, j3, i11);
                                                } else {
                                                    zzlz zzlzVarZze = zze(t);
                                                    Long lValueOf = Long.valueOf(i73);
                                                    i26 = i50 == true ? 1 : 0;
                                                    zzlzVarZze.zza(i26 == true ? 1 : 0, lValueOf);
                                                }
                                                i71 = i25;
                                                iZza6 = iZza5;
                                                i10 = i26;
                                                if (iZza6 == i23) {
                                                    i6 = iZza6;
                                                    i9 = i71;
                                                } else {
                                                    zzknVar2 = this;
                                                    zzhlVar5 = zzhlVar2;
                                                    i31 = i11;
                                                    i33 = i10 == true ? 1 : 0;
                                                    i30 = -1;
                                                    i32 = i71;
                                                }
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                            }
                                            i71 = i25;
                                            i10 = i50 == true ? 1 : 0;
                                            iZza6 = i23;
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 66:
                                            this = this;
                                            i25 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 0) {
                                                iZzc2 = zzhi.zzc(bArr, i23, zzhlVar2);
                                                unsafe5.putObject(t2, j, Integer.valueOf(zzib.zze(zzhlVar2.zza)));
                                                unsafe5.putInt(t2, j3, i11);
                                                i71 = i25;
                                                iZza6 = iZzc2;
                                                i10 = i50 == true ? 1 : 0;
                                                if (iZza6 == i23) {
                                                    i6 = iZza6;
                                                    i9 = i71;
                                                } else {
                                                    zzknVar2 = this;
                                                    zzhlVar5 = zzhlVar2;
                                                    i31 = i11;
                                                    i33 = i10 == true ? 1 : 0;
                                                    i30 = -1;
                                                    i32 = i71;
                                                }
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                            }
                                            i71 = i25;
                                            i10 = i50 == true ? 1 : 0;
                                            iZza6 = i23;
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 67:
                                            this = this;
                                            i25 = i71;
                                            zzhlVar2 = zzhlVar3;
                                            i23 = iZza;
                                            i11 = i38;
                                            if (i39 == 0) {
                                                iZzc2 = zzhi.zzd(bArr, i23, zzhlVar2);
                                                unsafe5.putObject(t2, j, Long.valueOf(zzib.zza(zzhlVar2.zzb)));
                                                unsafe5.putInt(t2, j3, i11);
                                                i71 = i25;
                                                iZza6 = iZzc2;
                                                i10 = i50 == true ? 1 : 0;
                                                if (iZza6 == i23) {
                                                    i6 = iZza6;
                                                    i9 = i71;
                                                } else {
                                                    zzknVar2 = this;
                                                    zzhlVar5 = zzhlVar2;
                                                    i31 = i11;
                                                    i33 = i10 == true ? 1 : 0;
                                                    i30 = -1;
                                                    i32 = i71;
                                                }
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                            }
                                            i71 = i25;
                                            i10 = i50 == true ? 1 : 0;
                                            iZza6 = i23;
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                        case 68:
                                            if (i39 == 3) {
                                                this = this;
                                                Object objZza4 = this.zza(t2, i38, i71);
                                                int i74 = iZza;
                                                int iZza8 = zzhi.zza(objZza4, this.zze(i71), bArr, iZza, i2, ((i50 == true ? 1 : 0) & (-8)) | 4, zzhlVar);
                                                this.zza(t2, i38, i71, objZza4);
                                                zzhlVar2 = zzhlVar;
                                                i11 = i38;
                                                iZza6 = iZza8;
                                                i23 = i74;
                                                i71 = i71;
                                                i10 = i50 == true ? 1 : 0;
                                                if (iZza6 == i23) {
                                                    i6 = iZza6;
                                                    i9 = i71;
                                                } else {
                                                    zzknVar2 = this;
                                                    zzhlVar5 = zzhlVar2;
                                                    i31 = i11;
                                                    i33 = i10 == true ? 1 : 0;
                                                    i30 = -1;
                                                    i32 = i71;
                                                }
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                            } else {
                                                zzhlVar2 = zzhlVar;
                                                i10 = i50 == true ? 1 : 0;
                                                i23 = iZza;
                                                i11 = i38;
                                                iZza6 = i23;
                                                if (iZza6 == i23) {
                                                    i6 = iZza6;
                                                    i9 = i71;
                                                } else {
                                                    zzknVar2 = this;
                                                    zzhlVar5 = zzhlVar2;
                                                    i31 = i11;
                                                    i33 = i10 == true ? 1 : 0;
                                                    i30 = -1;
                                                    i32 = i71;
                                                }
                                                i34 = i7;
                                                i35 = i8;
                                                unsafe2 = unsafe;
                                            }
                                            break;
                                        default:
                                            zzhlVar2 = zzhlVar3;
                                            i10 = i50 == true ? 1 : 0;
                                            i23 = iZza;
                                            i11 = i38;
                                            iZza6 = i23;
                                            if (iZza6 == i23) {
                                                i6 = iZza6;
                                                i9 = i71;
                                            } else {
                                                zzknVar2 = this;
                                                zzhlVar5 = zzhlVar2;
                                                i31 = i11;
                                                i33 = i10 == true ? 1 : 0;
                                                i30 = -1;
                                                i32 = i71;
                                            }
                                            i34 = i7;
                                            i35 = i8;
                                            unsafe2 = unsafe;
                                            break;
                                    }
                                } else if (i39 == 2) {
                                    Unsafe unsafe6 = zzb;
                                    Object objZzf = zzknVar2.zzf(i70);
                                    t2 = t;
                                    Object object = unsafe6.getObject(t2, j);
                                    if (zzknVar2.zzs.zzf(object)) {
                                        Object objZzb = zzknVar2.zzs.zzb(objZzf);
                                        zzknVar2.zzs.zza(objZzb, object);
                                        unsafe6.putObject(t2, j, objZzb);
                                        object = objZzb;
                                    }
                                    zzke<?, ?> zzkeVarZza = zzknVar2.zzs.zza(objZzf);
                                    Map<?, ?> mapZze = zzknVar2.zzs.zze(object);
                                    int iZzc15 = zzhi.zzc(bArr, iZza, zzhlVar3);
                                    int i75 = zzhlVar3.zza;
                                    if (i75 < 0 || i75 > i2 - iZzc15) {
                                        throw zzji.zzh();
                                    }
                                    int i76 = iZzc15 + i75;
                                    Object obj = zzkeVarZza.zzb;
                                    Object obj2 = zzkeVarZza.zzd;
                                    Object obj3 = obj;
                                    while (iZzc15 < i76) {
                                        int iZza9 = iZzc15 + 1;
                                        int i77 = bArr[iZzc15];
                                        if (i77 < 0) {
                                            iZza9 = zzhi.zza(i77, bArr, iZza9, zzhlVar3);
                                            i77 = zzhlVar3.zza;
                                        }
                                        int i78 = i77 >>> 3;
                                        int i79 = i70;
                                        int i80 = i77 & 7;
                                        obj2 = obj2;
                                        if (i78 != 1) {
                                            if (i78 == 2) {
                                                if (i80 == zzkeVarZza.zzc.zza()) {
                                                    i28 = i50;
                                                    i29 = i79;
                                                    obj3 = obj3;
                                                    i27 = i76;
                                                    iZzc15 = zza(bArr, iZza9, i2, zzkeVarZza.zzc, zzkeVarZza.zzd.getClass(), zzhlVar);
                                                    obj2 = zzhlVar3.zzc;
                                                } else {
                                                    i27 = i76;
                                                    i28 = i50;
                                                    i29 = i79;
                                                }
                                            } else {
                                                obj3 = obj3;
                                                i27 = i76;
                                                i28 = i50;
                                                i29 = i79;
                                                iZzc15 = zzhi.zza(i77, bArr, iZza9, i2, zzhlVar3);
                                            }
                                            i76 = i27;
                                            obj3 = obj3;
                                            i70 = i29;
                                            i50 = i28;
                                        } else {
                                            i27 = i76;
                                            i28 = i50;
                                            i29 = i79;
                                            if (i80 == zzkeVarZza.zza.zza()) {
                                                iZzc15 = zza(bArr, iZza9, i2, zzkeVarZza.zza, (Class<?>) null, zzhlVar);
                                                obj3 = zzhlVar3.zzc;
                                                i76 = i27;
                                                obj2 = obj2;
                                            }
                                            i70 = i29;
                                            i50 = i28;
                                        }
                                        iZzc15 = zzhi.zza(i77, bArr, iZza9, i2, zzhlVar3);
                                        i76 = i27;
                                        obj3 = obj3;
                                        i70 = i29;
                                        i50 = i28;
                                    }
                                    Object obj4 = obj3;
                                    int i81 = i76;
                                    int i82 = i50;
                                    i9 = i70;
                                    if (iZzc15 != i81) {
                                        throw zzji.zzg();
                                    }
                                    mapZze.put(obj4, obj2);
                                    if (i81 == iZza) {
                                        this = this;
                                        i6 = i81;
                                        zzhlVar2 = zzhlVar3;
                                        i11 = i38;
                                        i10 = i82 == true ? 1 : 0;
                                    } else {
                                        iZza6 = i81;
                                        i2 = i2;
                                        i32 = i9;
                                        zzhlVar5 = zzhlVar3;
                                        i31 = i38;
                                        i30 = -1;
                                        i33 = i82 == true ? 1 : 0;
                                        i34 = i7;
                                        i35 = i8;
                                        unsafe2 = unsafe;
                                        zzknVar2 = this;
                                    }
                                } else {
                                    i15 = i50 == true ? 1 : 0;
                                    t2 = t;
                                    i9 = i70;
                                    this = this;
                                    i6 = iZza;
                                    zzhlVar2 = zzhlVar3;
                                    i11 = i38;
                                    i10 = i15;
                                }
                            }
                        } else if (i39 == 2) {
                            zzjf zzjfVarZza2 = (zzjf) unsafe2.getObject(t2, j);
                            if (!zzjfVarZza2.zzc()) {
                                int size2 = zzjfVarZza2.size();
                                zzjfVarZza2 = zzjfVarZza2.zza(size2 != 0 ? size2 << 1 : 10);
                                unsafe2.putObject(t2, j, zzjfVarZza2);
                            }
                            int iZza10 = zzhi.zza((zzlb<?>) zzknVar2.zze(i40), i43 == true ? 1 : 0, bArr, iZza, i2, (zzjf<?>) zzjfVarZza2, zzhlVar);
                            zzhlVar5 = zzhlVar;
                            i32 = i40;
                            iZza6 = iZza10;
                            i33 = i43 == true ? 1 : 0;
                            i31 = i38;
                            i30 = -1;
                            i34 = i34;
                            i35 = i35;
                            i2 = i2;
                        } else {
                            i7 = i34;
                            i8 = i35;
                            zzhlVar3 = zzhlVar;
                            i9 = i40;
                            unsafe = unsafe2;
                            i15 = i43 == true ? 1 : 0;
                            this = this;
                            i6 = iZza;
                            zzhlVar2 = zzhlVar3;
                            i11 = i38;
                            i10 = i15;
                        }
                    }
                } else {
                    i5 = i30;
                    unsafe = unsafe2;
                    zzhlVar2 = zzhlVar5;
                    this = zzknVar2;
                    i6 = iZza;
                    i7 = i34;
                    i8 = i35;
                    i9 = 0;
                    i10 = i37;
                    i11 = i38;
                }
                if (i10 != i3 || i3 == 0) {
                    if (this.zzh && zzhlVar2.zzd != zzik.zza) {
                        if (zzhlVar2.zzd.zza(this.zzg, i11) == null) {
                            iZza6 = zzhi.zza(i10 == true ? 1 : 0, bArr, i6, i2, zze(t), zzhlVar);
                        } else {
                            zzix.zzd zzdVar = (zzix.zzd) t2;
                            zzdVar.zza();
                            zziq<zzix.zzc> zziqVar = zzdVar.zzc;
                            throw new NoSuchMethodError();
                        }
                    } else {
                        iZza6 = zzhi.zza(i10 == true ? 1 : 0, bArr, i6, i2, zze(t), zzhlVar);
                    }
                    zzknVar2 = this;
                    zzhlVar5 = zzhlVar2;
                    i31 = i11;
                    i32 = i9;
                    i33 = i10;
                    i30 = i5;
                    i34 = i7;
                    i35 = i8;
                    unsafe2 = unsafe;
                } else {
                    i4 = i6;
                    zzknVar = this;
                    i33 = i10;
                    i34 = i7;
                    i35 = i8;
                }
            } else {
                unsafe = unsafe2;
                zzknVar = zzknVar2;
                i3 = i3;
                i4 = iZza6;
            }
        }
        if (i35 != 1048575) {
            unsafe.putInt(t2, i35, i34);
        }
        zzlz zzlzVar = null;
        for (int i83 = zzknVar.zzm; i83 < zzknVar.zzn; i83++) {
            zzlzVar = (zzlz) zza(t, zzknVar.zzl[i83], zzlzVar, (zzma<UT, zzlz>) zzknVar.zzq, t);
        }
        if (zzlzVar != null) {
            zzknVar.zzq.zzb(t2, zzlzVar);
        }
        if (i3 == 0) {
            if (i4 != i2) {
                throw zzji.zzg();
            }
        } else if (i4 > i2 || i33 != i3) {
            throw zzji.zzg();
        }
        return i4;
    }

    private final int zza(int i) {
        if (i < this.zze || i > this.zzf) {
            return -1;
        }
        return zza(i, 0);
    }

    private final int zzb(int i) {
        return this.zzc[i + 2];
    }

    private final int zza(int i, int i2) {
        int length = (this.zzc.length / 3) - 1;
        while (i2 <= length) {
            int i3 = (length + i2) >>> 1;
            int i4 = i3 * 3;
            int i5 = this.zzc[i4];
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

    private final int zzc(int i) {
        return this.zzc[i + 1];
    }

    private static <T> long zzd(T t, long j) {
        return ((Long) zzmg.zze(t, j)).longValue();
    }

    private final zzje zzd(int i) {
        return (zzje) this.zzd[((i / 3) << 1) + 1];
    }

    static <T> zzkn<T> zza(Class<T> cls, zzkh zzkhVar, zzkr zzkrVar, zzjs zzjsVar, zzma<?, ?> zzmaVar, zzim<?> zzimVar, zzkg zzkgVar) {
        int i;
        int iCharAt;
        int iCharAt2;
        int i2;
        int i3;
        int[] iArr;
        int i4;
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
        zzkz zzkzVar;
        boolean z;
        int iObjectFieldOffset;
        int i18;
        int i19;
        int iObjectFieldOffset2;
        int i20;
        Field fieldZza;
        int i21;
        char cCharAt9;
        int i22;
        int i23;
        int i24;
        Object obj;
        Field fieldZza2;
        int i25;
        Object obj2;
        Field fieldZza3;
        int i26;
        char cCharAt10;
        int i27;
        char cCharAt11;
        int i28;
        char cCharAt12;
        int i29;
        char cCharAt13;
        if (zzkhVar instanceof zzkz) {
            zzkz zzkzVar2 = (zzkz) zzkhVar;
            String strZzd = zzkzVar2.zzd();
            int length = strZzd.length();
            char c = 55296;
            if (strZzd.charAt(0) >= 55296) {
                int i30 = 1;
                while (true) {
                    i = i30 + 1;
                    if (strZzd.charAt(i30) < 55296) {
                        break;
                    }
                    i30 = i;
                }
            } else {
                i = 1;
            }
            int i31 = i + 1;
            int iCharAt3 = strZzd.charAt(i);
            if (iCharAt3 >= 55296) {
                int i32 = iCharAt3 & 8191;
                int i33 = 13;
                while (true) {
                    i29 = i31 + 1;
                    cCharAt13 = strZzd.charAt(i31);
                    if (cCharAt13 < 55296) {
                        break;
                    }
                    i32 |= (cCharAt13 & 8191) << i33;
                    i33 += 13;
                    i31 = i29;
                }
                iCharAt3 = i32 | (cCharAt13 << i33);
                i31 = i29;
            }
            if (iCharAt3 == 0) {
                iCharAt = 0;
                iCharAt2 = 0;
                i5 = 0;
                i6 = 0;
                i2 = 0;
                i4 = 0;
                iArr = zza;
                i3 = 0;
            } else {
                int i34 = i31 + 1;
                int iCharAt4 = strZzd.charAt(i31);
                if (iCharAt4 >= 55296) {
                    int i35 = iCharAt4 & 8191;
                    int i36 = 13;
                    while (true) {
                        i14 = i34 + 1;
                        cCharAt8 = strZzd.charAt(i34);
                        if (cCharAt8 < 55296) {
                            break;
                        }
                        i35 |= (cCharAt8 & 8191) << i36;
                        i36 += 13;
                        i34 = i14;
                    }
                    iCharAt4 = i35 | (cCharAt8 << i36);
                    i34 = i14;
                }
                int i37 = i34 + 1;
                int iCharAt5 = strZzd.charAt(i34);
                if (iCharAt5 >= 55296) {
                    int i38 = iCharAt5 & 8191;
                    int i39 = 13;
                    while (true) {
                        i13 = i37 + 1;
                        cCharAt7 = strZzd.charAt(i37);
                        if (cCharAt7 < 55296) {
                            break;
                        }
                        i38 |= (cCharAt7 & 8191) << i39;
                        i39 += 13;
                        i37 = i13;
                    }
                    iCharAt5 = i38 | (cCharAt7 << i39);
                    i37 = i13;
                }
                int i40 = i37 + 1;
                int iCharAt6 = strZzd.charAt(i37);
                if (iCharAt6 >= 55296) {
                    int i41 = iCharAt6 & 8191;
                    int i42 = 13;
                    while (true) {
                        i12 = i40 + 1;
                        cCharAt6 = strZzd.charAt(i40);
                        if (cCharAt6 < 55296) {
                            break;
                        }
                        i41 |= (cCharAt6 & 8191) << i42;
                        i42 += 13;
                        i40 = i12;
                    }
                    iCharAt6 = i41 | (cCharAt6 << i42);
                    i40 = i12;
                }
                int i43 = i40 + 1;
                int iCharAt7 = strZzd.charAt(i40);
                if (iCharAt7 >= 55296) {
                    int i44 = iCharAt7 & 8191;
                    int i45 = 13;
                    while (true) {
                        i11 = i43 + 1;
                        cCharAt5 = strZzd.charAt(i43);
                        if (cCharAt5 < 55296) {
                            break;
                        }
                        i44 |= (cCharAt5 & 8191) << i45;
                        i45 += 13;
                        i43 = i11;
                    }
                    iCharAt7 = i44 | (cCharAt5 << i45);
                    i43 = i11;
                }
                int i46 = i43 + 1;
                iCharAt = strZzd.charAt(i43);
                if (iCharAt >= 55296) {
                    int i47 = iCharAt & 8191;
                    int i48 = 13;
                    while (true) {
                        i10 = i46 + 1;
                        cCharAt4 = strZzd.charAt(i46);
                        if (cCharAt4 < 55296) {
                            break;
                        }
                        i47 |= (cCharAt4 & 8191) << i48;
                        i48 += 13;
                        i46 = i10;
                    }
                    iCharAt = i47 | (cCharAt4 << i48);
                    i46 = i10;
                }
                int i49 = i46 + 1;
                iCharAt2 = strZzd.charAt(i46);
                if (iCharAt2 >= 55296) {
                    int i50 = iCharAt2 & 8191;
                    int i51 = 13;
                    while (true) {
                        i9 = i49 + 1;
                        cCharAt3 = strZzd.charAt(i49);
                        if (cCharAt3 < 55296) {
                            break;
                        }
                        i50 |= (cCharAt3 & 8191) << i51;
                        i51 += 13;
                        i49 = i9;
                    }
                    iCharAt2 = i50 | (cCharAt3 << i51);
                    i49 = i9;
                }
                int i52 = i49 + 1;
                int iCharAt8 = strZzd.charAt(i49);
                if (iCharAt8 >= 55296) {
                    int i53 = iCharAt8 & 8191;
                    int i54 = 13;
                    while (true) {
                        i8 = i52 + 1;
                        cCharAt2 = strZzd.charAt(i52);
                        if (cCharAt2 < 55296) {
                            break;
                        }
                        i53 |= (cCharAt2 & 8191) << i54;
                        i54 += 13;
                        i52 = i8;
                    }
                    iCharAt8 = i53 | (cCharAt2 << i54);
                    i52 = i8;
                }
                int i55 = i52 + 1;
                int iCharAt9 = strZzd.charAt(i52);
                if (iCharAt9 >= 55296) {
                    int i56 = iCharAt9 & 8191;
                    int i57 = 13;
                    while (true) {
                        i7 = i55 + 1;
                        cCharAt = strZzd.charAt(i55);
                        if (cCharAt < 55296) {
                            break;
                        }
                        i56 |= (cCharAt & 8191) << i57;
                        i57 += 13;
                        i55 = i7;
                    }
                    iCharAt9 = i56 | (cCharAt << i57);
                    i55 = i7;
                }
                i2 = (iCharAt4 << 1) + iCharAt5;
                i3 = iCharAt4;
                iArr = new int[iCharAt9 + iCharAt2 + iCharAt8];
                i4 = iCharAt9;
                i31 = i55;
                i5 = iCharAt6;
                i6 = iCharAt7;
            }
            Unsafe unsafe = zzb;
            Object[] objArrZze = zzkzVar2.zze();
            Class<?> cls2 = zzkzVar2.zza().getClass();
            int[] iArr2 = new int[iCharAt * 3];
            Object[] objArr = new Object[iCharAt << 1];
            int i58 = i4 + iCharAt2;
            int i59 = i4;
            int i60 = i58;
            int i61 = 0;
            int i62 = 0;
            while (i31 < length) {
                int i63 = i31 + 1;
                int iCharAt10 = strZzd.charAt(i31);
                if (iCharAt10 >= c) {
                    int i64 = iCharAt10 & 8191;
                    int i65 = i63;
                    int i66 = 13;
                    while (true) {
                        i28 = i65 + 1;
                        cCharAt12 = strZzd.charAt(i65);
                        if (cCharAt12 < c) {
                            break;
                        }
                        i64 |= (cCharAt12 & 8191) << i66;
                        i66 += 13;
                        i65 = i28;
                    }
                    iCharAt10 = i64 | (cCharAt12 << i66);
                    i15 = i28;
                } else {
                    i15 = i63;
                }
                int i67 = i15 + 1;
                int iCharAt11 = strZzd.charAt(i15);
                if (iCharAt11 >= c) {
                    int i68 = iCharAt11 & 8191;
                    int i69 = i67;
                    int i70 = 13;
                    while (true) {
                        i27 = i69 + 1;
                        cCharAt11 = strZzd.charAt(i69);
                        if (cCharAt11 < c) {
                            break;
                        }
                        i68 |= (cCharAt11 & 8191) << i70;
                        i70 += 13;
                        i69 = i27;
                    }
                    iCharAt11 = i68 | (cCharAt11 << i70);
                    i16 = i27;
                } else {
                    i16 = i67;
                }
                int i71 = iCharAt11 & 255;
                int i72 = length;
                if ((iCharAt11 & 1024) != 0) {
                    iArr[i62] = i61;
                    i62++;
                }
                int i73 = i6;
                if (i71 >= 51) {
                    int i74 = i16 + 1;
                    int iCharAt12 = strZzd.charAt(i16);
                    char c2 = 55296;
                    if (iCharAt12 >= 55296) {
                        int i75 = iCharAt12 & 8191;
                        int i76 = 13;
                        while (true) {
                            i26 = i74 + 1;
                            cCharAt10 = strZzd.charAt(i74);
                            if (cCharAt10 < c2) {
                                break;
                            }
                            i75 |= (cCharAt10 & 8191) << i76;
                            i76 += 13;
                            i74 = i26;
                            c2 = 55296;
                        }
                        iCharAt12 = i75 | (cCharAt10 << i76);
                        i74 = i26;
                    }
                    int i77 = i71 - 51;
                    int i78 = i74;
                    if (i77 == 9 || i77 == 17) {
                        i23 = i2 + 1;
                        objArr[((i61 / 3) << 1) + 1] = objArrZze[i2];
                    } else {
                        if (i77 == 12 && (zzkzVar2.zzb().equals(zzky.PROTO2) || (iCharAt11 & 2048) != 0)) {
                            i23 = i2 + 1;
                            objArr[((i61 / 3) << 1) + 1] = objArrZze[i2];
                        }
                        i24 = iCharAt12 << 1;
                        obj = objArrZze[i24];
                        if (obj instanceof Field) {
                            fieldZza2 = (Field) obj;
                        } else {
                            fieldZza2 = zza(cls2, (String) obj);
                            objArrZze[i24] = fieldZza2;
                        }
                        iObjectFieldOffset2 = (int) unsafe.objectFieldOffset(fieldZza2);
                        i25 = i24 + 1;
                        obj2 = objArrZze[i25];
                        if (obj2 instanceof Field) {
                            fieldZza3 = (Field) obj2;
                        } else {
                            fieldZza3 = zza(cls2, (String) obj2);
                            objArrZze[i25] = fieldZza3;
                        }
                        iObjectFieldOffset = (int) unsafe.objectFieldOffset(fieldZza3);
                        zzkzVar = zzkzVar2;
                        strZzd = strZzd;
                        i17 = i2;
                        i18 = i78;
                        i20 = 0;
                        z = true;
                    }
                    i2 = i23;
                    i24 = iCharAt12 << 1;
                    obj = objArrZze[i24];
                    if (obj instanceof Field) {
                        fieldZza2 = (Field) obj;
                    } else {
                        fieldZza2 = zza(cls2, (String) obj);
                        objArrZze[i24] = fieldZza2;
                    }
                    iObjectFieldOffset2 = (int) unsafe.objectFieldOffset(fieldZza2);
                    i25 = i24 + 1;
                    obj2 = objArrZze[i25];
                    if (obj2 instanceof Field) {
                        fieldZza3 = (Field) obj2;
                    } else {
                        fieldZza3 = zza(cls2, (String) obj2);
                        objArrZze[i25] = fieldZza3;
                    }
                    iObjectFieldOffset = (int) unsafe.objectFieldOffset(fieldZza3);
                    zzkzVar = zzkzVar2;
                    strZzd = strZzd;
                    i17 = i2;
                    i18 = i78;
                    i20 = 0;
                    z = true;
                } else {
                    i17 = i2 + 1;
                    Field fieldZza4 = zza(cls2, (String) objArrZze[i2]);
                    if (i71 == 9 || i71 == 17) {
                        zzkzVar = zzkzVar2;
                        objArr[((i61 / 3) << 1) + 1] = fieldZza4.getType();
                    } else {
                        if (i71 == 27 || i71 == 49) {
                            zzkzVar = zzkzVar2;
                            i22 = i2 + 2;
                            objArr[((i61 / 3) << 1) + 1] = objArrZze[i17];
                        } else if (i71 == 12 || i71 == 30 || i71 == 44) {
                            zzkzVar = zzkzVar2;
                            if (zzkzVar2.zzb() == zzky.PROTO2 || (iCharAt11 & 2048) != 0) {
                                i22 = i2 + 2;
                                objArr[((i61 / 3) << 1) + 1] = objArrZze[i17];
                            }
                        } else if (i71 == 50) {
                            int i79 = i59 + 1;
                            iArr[i59] = i61;
                            int i80 = (i61 / 3) << 1;
                            int i81 = i2 + 2;
                            objArr[i80] = objArrZze[i17];
                            if ((iCharAt11 & 2048) != 0) {
                                i17 = i2 + 3;
                                objArr[i80 + 1] = objArrZze[i81];
                                zzkzVar = zzkzVar2;
                                i59 = i79;
                            } else {
                                i59 = i79;
                                i17 = i81;
                                zzkzVar = zzkzVar2;
                            }
                        } else {
                            zzkzVar = zzkzVar2;
                        }
                        i17 = i22;
                    }
                    int iObjectFieldOffset3 = (int) unsafe.objectFieldOffset(fieldZza4);
                    if ((iCharAt11 & l111l11l11Ill.l111l11111lIl) == 0 || i71 > 17) {
                        z = true;
                        iObjectFieldOffset = 1048575;
                        i18 = i16;
                        i19 = 0;
                    } else {
                        i18 = i16 + 1;
                        int iCharAt13 = strZzd.charAt(i16);
                        if (iCharAt13 >= 55296) {
                            int i82 = iCharAt13 & 8191;
                            int i83 = 13;
                            while (true) {
                                i21 = i18 + 1;
                                cCharAt9 = strZzd.charAt(i18);
                                if (cCharAt9 < 55296) {
                                    break;
                                }
                                i82 |= (cCharAt9 & 8191) << i83;
                                i83 += 13;
                                i18 = i21;
                            }
                            iCharAt13 = i82 | (cCharAt9 << i83);
                            i18 = i21;
                        }
                        z = true;
                        int i84 = (i3 << 1) + (iCharAt13 / 32);
                        Object obj3 = objArrZze[i84];
                        if (obj3 instanceof Field) {
                            fieldZza = (Field) obj3;
                        } else {
                            fieldZza = zza(cls2, (String) obj3);
                            objArrZze[i84] = fieldZza;
                        }
                        i19 = iCharAt13 % 32;
                        iObjectFieldOffset = (int) unsafe.objectFieldOffset(fieldZza);
                    }
                    if (i71 >= 18 && i71 <= 49) {
                        iArr[i60] = iObjectFieldOffset3;
                        i60++;
                    }
                    int i85 = i19;
                    iObjectFieldOffset2 = iObjectFieldOffset3;
                    i20 = i85;
                }
                int i86 = i61 + 1;
                iArr2[i61] = iCharAt10;
                int i87 = i61 + 2;
                int i88 = i3;
                iArr2[i86] = (i71 << 20) | ((iCharAt11 & l1l11lI1l.l111l11111lIl) != 0 ? 268435456 : 0) | ((iCharAt11 & 512) != 0 ? 536870912 : 0) | ((iCharAt11 & 2048) != 0 ? Integer.MIN_VALUE : 0) | iObjectFieldOffset2;
                i61 += 3;
                iArr2[i87] = (i20 << 20) | iObjectFieldOffset;
                i31 = i18;
                i2 = i17;
                length = i72;
                zzkzVar2 = zzkzVar;
                strZzd = strZzd;
                i6 = i73;
                i3 = i88;
                i5 = i5;
                c = 55296;
            }
            zzkz zzkzVar3 = zzkzVar2;
            return new zzkn<>(iArr2, objArr, i5, i6, zzkzVar3.zza(), zzkzVar3.zzb(), false, iArr, i4, i58, zzkrVar, zzjsVar, zzmaVar, zzimVar, zzkgVar);
        }
        throw new NoSuchMethodError();
    }

    private final zzlb zze(int i) {
        int i2 = (i / 3) << 1;
        zzlb zzlbVar = (zzlb) this.zzd[i2];
        if (zzlbVar != null) {
            return zzlbVar;
        }
        zzlb<T> zzlbVarZza = zzkx.zza().zza((Class) this.zzd[i2 + 1]);
        this.zzd[i2] = zzlbVarZza;
        return zzlbVarZza;
    }

    private static zzlz zze(Object obj) {
        zzix zzixVar = (zzix) obj;
        zzlz zzlzVar = zzixVar.zzb;
        if (zzlzVar != zzlz.zzc()) {
            return zzlzVar;
        }
        zzlz zzlzVarZzd = zzlz.zzd();
        zzixVar.zzb = zzlzVarZzd;
        return zzlzVarZzd;
    }

    private final <UT, UB> UB zza(Object obj, int i, UB ub, zzma<UT, UB> zzmaVar, Object obj2) {
        zzje zzjeVarZzd;
        int i2 = this.zzc[i];
        Object objZze = zzmg.zze(obj, zzc(i) & 1048575);
        return (objZze == null || (zzjeVarZzd = zzd(i)) == null) ? ub : (UB) zza(i, i2, this.zzs.zze(objZze), zzjeVarZzd, ub, zzmaVar, obj2);
    }

    private final <K, V, UT, UB> UB zza(int i, int i2, Map<K, V> map, zzje zzjeVar, UB ub, zzma<UT, UB> zzmaVar, Object obj) {
        zzke<?, ?> zzkeVarZza = this.zzs.zza(zzf(i));
        Iterator<Map.Entry<K, V>> it = map.entrySet().iterator();
        while (it.hasNext()) {
            Map.Entry<K, V> next = it.next();
            if (!zzjeVar.zza(((Integer) next.getValue()).intValue())) {
                if (ub == null) {
                    ub = zzmaVar.zzc(obj);
                }
                zzhv zzhvVarZzc = zzhm.zzc(zzkb.zza(zzkeVarZza, next.getKey(), next.getValue()));
                try {
                    zzkb.zza(zzhvVarZzc.zzb(), zzkeVarZza, next.getKey(), next.getValue());
                    zzmaVar.zza(ub, i2, zzhvVarZzc.zza());
                    it.remove();
                } catch (IOException e) {
                    throw new RuntimeException(e);
                }
            }
        }
        return ub;
    }

    private final Object zzf(int i) {
        return this.zzd[(i / 3) << 1];
    }

    private final Object zza(T t, int i) {
        zzlb zzlbVarZze = zze(i);
        long jZzc = zzc(i) & 1048575;
        if (!zzc((Object) t, i)) {
            return zzlbVarZze.zza();
        }
        Object object = zzb.getObject(t, jZzc);
        if (zzg(object)) {
            return object;
        }
        Object objZza = zzlbVarZze.zza();
        if (object != null) {
            zzlbVarZze.zza(objZza, object);
        }
        return objZza;
    }

    private final Object zza(T t, int i, int i2) {
        zzlb zzlbVarZze = zze(i2);
        if (!zzc(t, i, i2)) {
            return zzlbVarZze.zza();
        }
        Object object = zzb.getObject(t, zzc(i2) & 1048575);
        if (zzg(object)) {
            return object;
        }
        Object objZza = zzlbVarZze.zza();
        if (object != null) {
            zzlbVarZze.zza(objZza, object);
        }
        return objZza;
    }

    @Override
    public final T zza() {
        return (T) this.zzo.zza(this.zzg);
    }

    private static Field zza(Class<?> cls, String str) {
        try {
            return cls.getDeclaredField(str);
        } catch (NoSuchFieldException unused) {
            Field[] declaredFields = cls.getDeclaredFields();
            for (Field field : declaredFields) {
                if (str.equals(field.getName())) {
                    return field;
                }
            }
            throw new RuntimeException("Field " + str + " for " + cls.getName() + " not found. Known fields are " + Arrays.toString(declaredFields));
        }
    }

    private zzkn(int[] iArr, Object[] objArr, int i, int i2, zzkj zzkjVar, zzky zzkyVar, boolean z, int[] iArr2, int i3, int i4, zzkr zzkrVar, zzjs zzjsVar, zzma<?, ?> zzmaVar, zzim<?> zzimVar, zzkg zzkgVar) {
        this.zzc = iArr;
        this.zzd = objArr;
        this.zze = i;
        this.zzf = i2;
        this.zzi = zzkjVar instanceof zzix;
        this.zzj = zzkyVar;
        this.zzh = zzimVar != null && zzimVar.zza(zzkjVar);
        this.zzk = false;
        this.zzl = iArr2;
        this.zzm = i3;
        this.zzn = i4;
        this.zzo = zzkrVar;
        this.zzp = zzjsVar;
        this.zzq = zzmaVar;
        this.zzr = zzimVar;
        this.zzg = zzkjVar;
        this.zzs = zzkgVar;
    }

    private static void zzf(Object obj) {
        if (zzg(obj)) {
            return;
        }
        throw new IllegalArgumentException("Mutating immutable message: " + String.valueOf(obj));
    }

    @Override
    public final void zzc(T t) {
        if (zzg(t)) {
            if (t instanceof zzix) {
                zzix zzixVar = (zzix) t;
                zzixVar.zzc(Api.BaseClientBuilder.API_PRIORITY_OTHER);
                zzixVar.zza = 0;
                zzixVar.zzch();
            }
            int length = this.zzc.length;
            for (int i = 0; i < length; i += 3) {
                int iZzc = zzc(i);
                long j = 1048575 & iZzc;
                int i2 = (iZzc & 267386880) >>> 20;
                if (i2 != 9) {
                    if (i2 != 60 && i2 != 68) {
                        switch (i2) {
                            case 17:
                                if (zzc((Object) t, i)) {
                                    zze(i).zzc(zzb.getObject(t, j));
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
                                this.zzp.zzb(t, j);
                                break;
                            case l1l1l11Il.l11l111I11l:
                                Unsafe unsafe = zzb;
                                Object object = unsafe.getObject(t, j);
                                if (object != null) {
                                    unsafe.putObject(t, j, this.zzs.zzc(object));
                                }
                                break;
                        }
                    } else if (zzc(t, this.zzc[i], i)) {
                        zze(i).zzc(zzb.getObject(t, j));
                    }
                } else if (zzc((Object) t, i)) {
                    zze(i).zzc(zzb.getObject(t, j));
                }
            }
            this.zzq.zzf(t);
            if (this.zzh) {
                this.zzr.zzc(t);
            }
        }
    }

    @Override
    public final void zza(T t, T t2) {
        zzf(t);
        t2.getClass();
        for (int i = 0; i < this.zzc.length; i += 3) {
            int iZzc = zzc(i);
            long j = 1048575 & iZzc;
            int i2 = this.zzc[i];
            switch ((iZzc & 267386880) >>> 20) {
                case 0:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza(t, j, zzmg.zza(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 1:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzb(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 2:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzd(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 3:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzd(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 4:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzc(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 5:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzd(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 6:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzc(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 7:
                    if (zzc((Object) t2, i)) {
                        zzmg.zzc(t, j, zzmg.zzh(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 8:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza(t, j, zzmg.zze(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 9:
                    zza(t, t2, i);
                    break;
                case 10:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza(t, j, zzmg.zze(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 11:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzc(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 12:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzc(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 13:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzc(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 14:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzd(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 15:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzc(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 16:
                    if (zzc((Object) t2, i)) {
                        zzmg.zza((Object) t, j, zzmg.zzd(t2, j));
                        zzb((Object) t, i);
                    }
                    break;
                case 17:
                    zza(t, t2, i);
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
                    this.zzp.zza(t, t2, j);
                    break;
                case l1l1l11Il.l11l111I11l:
                    zzld.zza(this.zzs, t, t2, j);
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
                    if (zzc(t2, i2, i)) {
                        zzmg.zza(t, j, zzmg.zze(t2, j));
                        zzb(t, i2, i);
                    }
                    break;
                case l11l111l11Il.l11l11l1llIl:
                    zzb(t, t2, i);
                    break;
                case 61:
                case 62:
                case 63:
                case UserMetadata.MAX_ATTRIBUTES:
                case 65:
                case 66:
                case 67:
                    if (zzc(t2, i2, i)) {
                        zzmg.zza(t, j, zzmg.zze(t2, j));
                        zzb(t, i2, i);
                    }
                    break;
                case 68:
                    zzb(t, t2, i);
                    break;
            }
        }
        zzld.zza(this.zzq, t, t2);
        if (this.zzh) {
            zzld.zza(this.zzr, t, t2);
        }
    }

    @Override
    public final void zza(T t, zzlc zzlcVar, zzik zzikVar) throws Throwable {
        zzma zzmaVar;
        int i;
        zzma zzmaVar2;
        T t2;
        Object obj;
        zzim<?> zzimVar;
        zzik zzikVar2;
        Object obj2;
        int i2;
        T t3 = t;
        zzik zzikVar3 = zzikVar;
        zzikVar.getClass();
        zzf(t);
        zzma zzmaVar3 = this.zzq;
        zzim<?> zzimVar2 = this.zzr;
        Object objZza = null;
        zziq zziqVarZzb = null;
        while (true) {
            try {
                int iZzc = zzlcVar.zzc();
                int iZza = zza(iZzc);
                if (iZza < 0) {
                    if (iZzc == Integer.MAX_VALUE) {
                        for (int i3 = this.zzm; i3 < this.zzn; i3++) {
                            objZza = zza(t, this.zzl[i3], objZza, (zzma<UT, Object>) zzmaVar3, t);
                        }
                        if (objZza != null) {
                            zzmaVar3.zzb(t3, objZza);
                            return;
                        }
                        return;
                    }
                    try {
                        Object objZza2 = !this.zzh ? null : zzimVar2.zza(zzikVar3, this.zzg, iZzc);
                        if (objZza2 != null) {
                            if (zziqVarZzb == null) {
                                zziqVarZzb = zzimVar2.zzb(t3);
                            }
                            zziq zziqVar = zziqVarZzb;
                            zzmaVar2 = zzmaVar3;
                            t2 = t3;
                            try {
                                objZza = zzimVar2.zza(t, zzlcVar, objZza2, zzikVar, zziqVar, objZza, zzmaVar2);
                                zziqVarZzb = zziqVar;
                            } catch (Throwable th) {
                                th = th;
                                t3 = t2;
                                zzmaVar = zzmaVar2;
                                while (i < this.zzn) {
                                    objZza = zza(t, this.zzl[i], objZza, (zzma<UT, Object>) zzmaVar, t);
                                }
                                if (objZza != null) {
                                    zzmaVar.zzb(t3, objZza);
                                }
                                throw th;
                            }
                        } else {
                            zzmaVar2 = zzmaVar3;
                            t2 = t3;
                            zzmaVar2.zza((zzlc) zzlcVar);
                            if (objZza == null) {
                                objZza = zzmaVar2.zzc(t2);
                            }
                            zziqVarZzb = zziqVarZzb;
                            if (!zzmaVar2.zza(objZza, (zzlc) zzlcVar)) {
                                int i4 = this.zzm;
                                while (i4 < this.zzn) {
                                    zzma zzmaVar4 = zzmaVar2;
                                    objZza = zza(t, this.zzl[i4], objZza, (zzma<UT, Object>) zzmaVar4, t);
                                    i4++;
                                    t2 = t2;
                                    zzmaVar2 = zzmaVar4;
                                }
                                T t4 = t2;
                                zzma zzmaVar5 = zzmaVar2;
                                if (objZza != null) {
                                    zzmaVar5.zzb(t4, objZza);
                                    return;
                                }
                                return;
                            }
                        }
                        t3 = t2;
                        zzmaVar3 = zzmaVar2;
                    } catch (Throwable th2) {
                        th = th2;
                        zzmaVar = zzmaVar3;
                        t3 = t3;
                        while (i < this.zzn) {
                            objZza = zza(t, this.zzl[i], objZza, (zzma<UT, Object>) zzmaVar, t);
                        }
                        if (objZza != null) {
                            zzmaVar.zzb(t3, objZza);
                        }
                        throw th;
                    }
                } else {
                    zzmaVar = zzmaVar3;
                    t3 = t3;
                    try {
                        int iZzc2 = zzc(iZza);
                        switch ((267386880 & iZzc2) >>> 20) {
                            case 0:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza(t3, iZzc2 & 1048575, zzlcVar.zza());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 1:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzb());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 2:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzl());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 3:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzo());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 4:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzg());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 5:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzk());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 6:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzf());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 7:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zzc(t3, iZzc2 & 1048575, zzlcVar.zzs());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 8:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zza((Object) t3, iZzc2, (zzlc) zzlcVar);
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 9:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzkj zzkjVar = (zzkj) zza((Object) t3, iZza);
                                zzlcVar.zzb(zzkjVar, zze(iZza), zzikVar2);
                                zza(t3, iZza, zzkjVar);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 10:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza(t3, iZzc2 & 1048575, zzlcVar.zzp());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 11:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzj());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 12:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                int iZze = zzlcVar.zze();
                                zzje zzjeVarZzd = zzd(iZza);
                                if (zzjeVarZzd != null && !zzjeVarZzd.zza(iZze)) {
                                    objZza = zzld.zza(t3, iZzc, iZze, obj2, zzmaVar);
                                    zzimVar2 = zzimVar;
                                    zzikVar3 = zzikVar2;
                                    zzmaVar3 = zzmaVar;
                                }
                                zzmg.zza((Object) t3, iZzc2 & 1048575, iZze);
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 13:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzh());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 14:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzm());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 15:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzi());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 16:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzmg.zza((Object) t3, iZzc2 & 1048575, zzlcVar.zzn());
                                zzb((Object) t3, iZza);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 17:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzkj zzkjVar2 = (zzkj) zza((Object) t3, iZza);
                                zzlcVar.zza(zzkjVar2, zze(iZza), zzikVar2);
                                zza(t3, iZza, zzkjVar2);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 18:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzc(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 19:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzg(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 20:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzi(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzq(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 22:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzh(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case ConnectionResult.API_DISABLED:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzf(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zze(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 25:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zza(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 26:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                if (zzg(iZzc2)) {
                                    zzlcVar.zzo(this.zzp.zza(t3, iZzc2 & 1048575));
                                } else {
                                    zzlcVar.zzn(this.zzp.zza(t3, iZzc2 & 1048575));
                                }
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 27:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzb(this.zzp.zza(t3, iZzc2 & 1048575), zze(iZza), zzikVar2);
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 28:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzb(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 29:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzp(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case l11l11lI1lll.l11l1111Il1l:
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                List listZza = this.zzp.zza(t3, iZzc2 & 1048575);
                                zzlcVar.zzd(listZza);
                                objZza = zzld.zza(t, iZzc, listZza, zzd(iZza), objZza, zzmaVar);
                                zzimVar2 = zzimVar;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 31:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzj(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 32:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzk(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case Encoder.DEFAULT_EC_PERCENT:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzl(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 34:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzm(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 35:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzc(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 36:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzg(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 37:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzi(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 38:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzq(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 39:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzh(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 40:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzf(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 41:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zze(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 42:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zza(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 43:
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzlcVar.zzp(this.zzp.zza(t3, iZzc2 & 1048575));
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 44:
                                List listZza2 = this.zzp.zza(t3, iZzc2 & 1048575);
                                zzlcVar.zzd(listZza2);
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                objZza = zzld.zza(t, iZzc, listZza2, zzd(iZza), objZza, zzmaVar);
                                zzimVar2 = zzimVar;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 45:
                                zzlcVar.zzj(this.zzp.zza(t3, iZzc2 & 1048575));
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 46:
                                zzlcVar.zzk(this.zzp.zza(t3, iZzc2 & 1048575));
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 47:
                                zzlcVar.zzl(this.zzp.zza(t3, iZzc2 & 1048575));
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 48:
                                zzlcVar.zzm(this.zzp.zza(t3, iZzc2 & 1048575));
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 49:
                                zzlcVar.zza(this.zzp.zza(t3, iZzc2 & 1048575), zze(iZza), zzikVar3);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case l1l1l11Il.l11l111I11l:
                                Object objZzf = zzf(iZza);
                                long jZzc = zzc(iZza) & 1048575;
                                Object objZze = zzmg.zze(t3, jZzc);
                                if (objZze == null) {
                                    objZze = this.zzs.zzb(objZzf);
                                    zzmg.zza(t3, jZzc, objZze);
                                } else if (this.zzs.zzf(objZze)) {
                                    Object objZzb = this.zzs.zzb(objZzf);
                                    this.zzs.zza(objZzb, objZze);
                                    zzmg.zza(t3, jZzc, objZzb);
                                    objZze = objZzb;
                                }
                                zzlcVar.zza(this.zzs.zze(objZze), this.zzs.zza(objZzf), zzikVar3);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 51:
                                zzmg.zza(t3, iZzc2 & 1048575, Double.valueOf(zzlcVar.zza()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 52:
                                zzmg.zza(t3, iZzc2 & 1048575, Float.valueOf(zzlcVar.zzb()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 53:
                                zzmg.zza(t3, iZzc2 & 1048575, Long.valueOf(zzlcVar.zzl()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 54:
                                zzmg.zza(t3, iZzc2 & 1048575, Long.valueOf(zzlcVar.zzo()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 55:
                                zzmg.zza(t3, iZzc2 & 1048575, Integer.valueOf(zzlcVar.zzg()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 56:
                                zzmg.zza(t3, iZzc2 & 1048575, Long.valueOf(zzlcVar.zzk()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 57:
                                zzmg.zza(t3, iZzc2 & 1048575, Integer.valueOf(zzlcVar.zzf()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 58:
                                zzmg.zza(t3, iZzc2 & 1048575, Boolean.valueOf(zzlcVar.zzs()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 59:
                                zza((Object) t3, iZzc2, (zzlc) zzlcVar);
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case l11l111l11Il.l11l11l1llIl:
                                zzkj zzkjVar3 = (zzkj) zza(t3, iZzc, iZza);
                                zzlcVar.zzb(zzkjVar3, zze(iZza), zzikVar3);
                                zza(t3, iZzc, iZza, zzkjVar3);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 61:
                                zzmg.zza(t3, iZzc2 & 1048575, zzlcVar.zzp());
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 62:
                                zzmg.zza(t3, iZzc2 & 1048575, Integer.valueOf(zzlcVar.zzj()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 63:
                                int iZze2 = zzlcVar.zze();
                                zzje zzjeVarZzd2 = zzd(iZza);
                                if (zzjeVarZzd2 == null || zzjeVarZzd2.zza(iZze2)) {
                                    zzmg.zza(t3, iZzc2 & 1048575, Integer.valueOf(iZze2));
                                    zzb(t3, iZzc, iZza);
                                    obj2 = objZza;
                                    zzimVar = zzimVar2;
                                    zzikVar2 = zzikVar3;
                                    zzimVar2 = zzimVar;
                                    objZza = obj2;
                                    zzikVar3 = zzikVar2;
                                } else {
                                    objZza = zzld.zza(t3, iZzc, iZze2, objZza, zzmaVar);
                                    t3 = t3;
                                }
                                zzmaVar3 = zzmaVar;
                                break;
                            case UserMetadata.MAX_ATTRIBUTES:
                                zzmg.zza(t3, iZzc2 & 1048575, Integer.valueOf(zzlcVar.zzh()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 65:
                                zzmg.zza(t3, iZzc2 & 1048575, Long.valueOf(zzlcVar.zzm()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 66:
                                zzmg.zza(t3, iZzc2 & 1048575, Integer.valueOf(zzlcVar.zzi()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 67:
                                zzmg.zza(t3, iZzc2 & 1048575, Long.valueOf(zzlcVar.zzn()));
                                zzb(t3, iZzc, iZza);
                                obj2 = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                zzimVar2 = zzimVar;
                                objZza = obj2;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            case 68:
                                try {
                                    zzkj zzkjVar4 = (zzkj) zza(t3, iZzc, iZza);
                                    zzlcVar.zza(zzkjVar4, zze(iZza), zzikVar3);
                                    zza(t3, iZzc, iZza, zzkjVar4);
                                    obj2 = objZza;
                                    zzimVar = zzimVar2;
                                    zzikVar2 = zzikVar3;
                                    zzimVar2 = zzimVar;
                                    objZza = obj2;
                                } catch (zzjh unused) {
                                    obj = objZza;
                                    zzimVar = zzimVar2;
                                    zzikVar2 = zzikVar3;
                                    objZza = obj;
                                    zzmaVar.zza((zzlc) zzlcVar);
                                    if (objZza == null) {
                                        objZza = zzmaVar.zzc(t3);
                                    }
                                    if (!zzmaVar.zza(objZza, (zzlc) zzlcVar)) {
                                        for (i2 = this.zzm; i2 < this.zzn; i2++) {
                                            objZza = zza(t, this.zzl[i2], objZza, (zzma<UT, Object>) zzmaVar, t);
                                        }
                                        if (objZza != null) {
                                            zzmaVar.zzb(t3, objZza);
                                            return;
                                        }
                                        return;
                                    }
                                    zzimVar2 = zzimVar;
                                }
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                            default:
                                obj = objZza;
                                zzimVar = zzimVar2;
                                zzikVar2 = zzikVar3;
                                if (obj == null) {
                                    try {
                                        objZza = zzmaVar.zzc(t3);
                                    } catch (zzjh unused2) {
                                        objZza = obj;
                                        zzmaVar.zza((zzlc) zzlcVar);
                                        if (objZza == null) {
                                            objZza = zzmaVar.zzc(t3);
                                        }
                                        if (!zzmaVar.zza(objZza, (zzlc) zzlcVar)) {
                                            while (i2 < this.zzn) {
                                                objZza = zza(t, this.zzl[i2], objZza, (zzma<UT, Object>) zzmaVar, t);
                                            }
                                            if (objZza != null) {
                                                zzmaVar.zzb(t3, objZza);
                                                return;
                                            }
                                            return;
                                        }
                                        zzimVar2 = zzimVar;
                                        zzikVar3 = zzikVar2;
                                        zzmaVar3 = zzmaVar;
                                    } catch (Throwable th3) {
                                        th = th3;
                                        objZza = obj;
                                        for (i = this.zzm; i < this.zzn; i++) {
                                            objZza = zza(t, this.zzl[i], objZza, (zzma<UT, Object>) zzmaVar, t);
                                        }
                                        if (objZza != null) {
                                            zzmaVar.zzb(t3, objZza);
                                        }
                                        throw th;
                                    }
                                } else {
                                    objZza = obj;
                                }
                                try {
                                    try {
                                        if (!zzmaVar.zza(objZza, (zzlc) zzlcVar)) {
                                            for (int i5 = this.zzm; i5 < this.zzn; i5++) {
                                                objZza = zza(t, this.zzl[i5], objZza, (zzma<UT, Object>) zzmaVar, t);
                                            }
                                            if (objZza != null) {
                                                zzmaVar.zzb(t3, objZza);
                                                return;
                                            }
                                            return;
                                        }
                                    } catch (Throwable th4) {
                                        th = th4;
                                        while (i < this.zzn) {
                                            objZza = zza(t, this.zzl[i], objZza, (zzma<UT, Object>) zzmaVar, t);
                                        }
                                        if (objZza != null) {
                                            zzmaVar.zzb(t3, objZza);
                                        }
                                        throw th;
                                    }
                                } catch (zzjh unused3) {
                                    zzmaVar.zza((zzlc) zzlcVar);
                                    if (objZza == null) {
                                        objZza = zzmaVar.zzc(t3);
                                    }
                                    if (!zzmaVar.zza(objZza, (zzlc) zzlcVar)) {
                                        while (i2 < this.zzn) {
                                            objZza = zza(t, this.zzl[i2], objZza, (zzma<UT, Object>) zzmaVar, t);
                                        }
                                        if (objZza != null) {
                                            zzmaVar.zzb(t3, objZza);
                                            return;
                                        }
                                        return;
                                    }
                                }
                                zzimVar2 = zzimVar;
                                zzikVar3 = zzikVar2;
                                zzmaVar3 = zzmaVar;
                                break;
                        }
                    } catch (Throwable th5) {
                        th = th5;
                    }
                }
            } catch (Throwable th6) {
                th = th6;
            }
        }
    }

    @Override
    public final void zza(T t, byte[] bArr, int i, int i2, zzhl zzhlVar) throws IOException {
        zza(t, bArr, i, i2, 0, zzhlVar);
    }

    private final void zza(T t, T t2, int i) {
        if (zzc((Object) t2, i)) {
            long jZzc = zzc(i) & 1048575;
            Unsafe unsafe = zzb;
            Object object = unsafe.getObject(t2, jZzc);
            if (object == null) {
                throw new IllegalStateException("Source subfield " + this.zzc[i] + " is present but null: " + String.valueOf(t2));
            }
            zzlb zzlbVarZze = zze(i);
            if (!zzc((Object) t, i)) {
                if (!zzg(object)) {
                    unsafe.putObject(t, jZzc, object);
                } else {
                    Object objZza = zzlbVarZze.zza();
                    zzlbVarZze.zza(objZza, object);
                    unsafe.putObject(t, jZzc, objZza);
                }
                zzb((Object) t, i);
                return;
            }
            Object object2 = unsafe.getObject(t, jZzc);
            if (!zzg(object2)) {
                Object objZza2 = zzlbVarZze.zza();
                zzlbVarZze.zza(objZza2, object2);
                unsafe.putObject(t, jZzc, objZza2);
                object2 = objZza2;
            }
            zzlbVarZze.zza(object2, object);
        }
    }

    private final void zzb(T t, T t2, int i) {
        int i2 = this.zzc[i];
        if (zzc(t2, i2, i)) {
            long jZzc = zzc(i) & 1048575;
            Unsafe unsafe = zzb;
            Object object = unsafe.getObject(t2, jZzc);
            if (object == null) {
                throw new IllegalStateException("Source subfield " + this.zzc[i] + " is present but null: " + String.valueOf(t2));
            }
            zzlb zzlbVarZze = zze(i);
            if (!zzc(t, i2, i)) {
                if (!zzg(object)) {
                    unsafe.putObject(t, jZzc, object);
                } else {
                    Object objZza = zzlbVarZze.zza();
                    zzlbVarZze.zza(objZza, object);
                    unsafe.putObject(t, jZzc, objZza);
                }
                zzb(t, i2, i);
                return;
            }
            Object object2 = unsafe.getObject(t, jZzc);
            if (!zzg(object2)) {
                Object objZza2 = zzlbVarZze.zza();
                zzlbVarZze.zza(objZza2, object2);
                unsafe.putObject(t, jZzc, objZza2);
                object2 = objZza2;
            }
            zzlbVarZze.zza(object2, object);
        }
    }

    private final void zza(Object obj, int i, zzlc zzlcVar) throws IOException {
        if (zzg(i)) {
            zzmg.zza(obj, i & 1048575, zzlcVar.zzr());
        } else if (this.zzi) {
            zzmg.zza(obj, i & 1048575, zzlcVar.zzq());
        } else {
            zzmg.zza(obj, i & 1048575, zzlcVar.zzp());
        }
    }

    private final void zzb(T t, int i) {
        int iZzb = zzb(i);
        long j = 1048575 & iZzb;
        if (j == 1048575) {
            return;
        }
        zzmg.zza((Object) t, j, (1 << (iZzb >>> 20)) | zzmg.zzc(t, j));
    }

    private final void zzb(T t, int i, int i2) {
        zzmg.zza((Object) t, zzb(i2) & 1048575, i);
    }

    private final void zza(T t, int i, Object obj) {
        zzb.putObject(t, zzc(i) & 1048575, obj);
        zzb((Object) t, i);
    }

    private final void zza(T t, int i, int i2, Object obj) {
        zzb.putObject(t, zzc(i2) & 1048575, obj);
        zzb(t, i, i2);
    }

    private final <K, V> void zza(zzmw zzmwVar, int i, Object obj, int i2) throws IOException {
        if (obj != null) {
            zzmwVar.zza(i, this.zzs.zza(zzf(i2)), this.zzs.zzd(obj));
        }
    }

    private static void zza(int i, Object obj, zzmw zzmwVar) throws IOException {
        if (obj instanceof String) {
            zzmwVar.zza(i, (String) obj);
        } else {
            zzmwVar.zza(i, (zzhm) obj);
        }
    }

    @Override
    public final void zza(T t, zzmw zzmwVar) throws IOException {
        Map.Entry<?, ?> entry;
        Iterator it;
        int i;
        int i2;
        int i3;
        boolean z;
        int i4;
        Unsafe unsafe;
        boolean z2;
        Iterator itZzc;
        Map.Entry<?, ?> entry2;
        zzmw zzmwVar2 = zzmwVar;
        int i5 = 267386880;
        int i6 = 1048575;
        if (zzmwVar.zza() == zzmz.zzb) {
            zza(this.zzq, t, zzmwVar2);
            if (this.zzh) {
                zziq<T> zziqVarZza = this.zzr.zza(t);
                if (zziqVarZza.zza.isEmpty()) {
                    itZzc = null;
                    entry2 = null;
                } else {
                    itZzc = zziqVarZza.zzc();
                    entry2 = (Map.Entry) itZzc.next();
                }
            } else {
                itZzc = null;
                entry2 = null;
            }
            for (int length = this.zzc.length - 3; length >= 0; length -= 3) {
                int iZzc = zzc(length);
                int i7 = this.zzc[length];
                while (entry2 != null && this.zzr.zza(entry2) > i7) {
                    this.zzr.zza(zzmwVar2, entry2);
                    entry2 = itZzc.hasNext() ? (Map.Entry) itZzc.next() : null;
                }
                switch ((iZzc & 267386880) >>> 20) {
                    case 0:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zza(i7, zzmg.zza(t, iZzc & 1048575));
                        }
                        break;
                    case 1:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zza(i7, zzmg.zzb(t, iZzc & 1048575));
                        }
                        break;
                    case 2:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zzb(i7, zzmg.zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 3:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zze(i7, zzmg.zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 4:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zzc(i7, zzmg.zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 5:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zza(i7, zzmg.zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 6:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zzb(i7, zzmg.zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 7:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zza(i7, zzmg.zzh(t, iZzc & 1048575));
                        }
                        break;
                    case 8:
                        if (zzc((Object) t, length)) {
                            zza(i7, zzmg.zze(t, iZzc & 1048575), zzmwVar2);
                        }
                        break;
                    case 9:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zzb(i7, zzmg.zze(t, iZzc & 1048575), zze(length));
                        }
                        break;
                    case 10:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zza(i7, (zzhm) zzmg.zze(t, iZzc & 1048575));
                        }
                        break;
                    case 11:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zzf(i7, zzmg.zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 12:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zza(i7, zzmg.zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 13:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zzd(i7, zzmg.zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 14:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zzc(i7, zzmg.zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 15:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zze(i7, zzmg.zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 16:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zzd(i7, zzmg.zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 17:
                        if (zzc((Object) t, length)) {
                            zzmwVar2.zza(i7, zzmg.zze(t, iZzc & 1048575), zze(length));
                        }
                        break;
                    case 18:
                        zzld.zzb(this.zzc[length], (List<Double>) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 19:
                        zzld.zzf(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 20:
                        zzld.zzh(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                        zzld.zzn(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 22:
                        zzld.zzg(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case ConnectionResult.API_DISABLED:
                        zzld.zze(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                        zzld.zzd(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 25:
                        zzld.zza(this.zzc[length], (List<Boolean>) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 26:
                        zzld.zzb(this.zzc[length], (List<String>) zzmg.zze(t, iZzc & 1048575), zzmwVar2);
                        break;
                    case 27:
                        zzld.zzb(this.zzc[length], (List<?>) zzmg.zze(t, iZzc & 1048575), zzmwVar2, zze(length));
                        break;
                    case 28:
                        zzld.zza(this.zzc[length], (List<zzhm>) zzmg.zze(t, iZzc & 1048575), zzmwVar2);
                        break;
                    case 29:
                        zzld.zzm(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case l11l11lI1lll.l11l1111Il1l:
                        zzld.zzc(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 31:
                        zzld.zzi(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 32:
                        zzld.zzj(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case Encoder.DEFAULT_EC_PERCENT:
                        zzld.zzk(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 34:
                        zzld.zzl(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, false);
                        break;
                    case 35:
                        zzld.zzb(this.zzc[length], (List<Double>) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 36:
                        zzld.zzf(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 37:
                        zzld.zzh(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 38:
                        zzld.zzn(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 39:
                        zzld.zzg(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 40:
                        zzld.zze(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 41:
                        zzld.zzd(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 42:
                        zzld.zza(this.zzc[length], (List<Boolean>) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 43:
                        zzld.zzm(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 44:
                        zzld.zzc(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 45:
                        zzld.zzi(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 46:
                        zzld.zzj(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 47:
                        zzld.zzk(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 48:
                        zzld.zzl(this.zzc[length], (List) zzmg.zze(t, iZzc & 1048575), zzmwVar2, true);
                        break;
                    case 49:
                        zzld.zza(this.zzc[length], (List<?>) zzmg.zze(t, iZzc & 1048575), zzmwVar2, zze(length));
                        break;
                    case l1l1l11Il.l11l111I11l:
                        zza(zzmwVar2, i7, zzmg.zze(t, iZzc & 1048575), length);
                        break;
                    case 51:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zza(i7, zza(t, iZzc & 1048575));
                        }
                        break;
                    case 52:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zza(i7, zzb(t, iZzc & 1048575));
                        }
                        break;
                    case 53:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zzb(i7, zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 54:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zze(i7, zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 55:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zzc(i7, zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 56:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zza(i7, zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 57:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zzb(i7, zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 58:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zza(i7, zze(t, iZzc & 1048575));
                        }
                        break;
                    case 59:
                        if (zzc(t, i7, length)) {
                            zza(i7, zzmg.zze(t, iZzc & 1048575), zzmwVar2);
                        }
                        break;
                    case l11l111l11Il.l11l11l1llIl:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zzb(i7, zzmg.zze(t, iZzc & 1048575), zze(length));
                        }
                        break;
                    case 61:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zza(i7, (zzhm) zzmg.zze(t, iZzc & 1048575));
                        }
                        break;
                    case 62:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zzf(i7, zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 63:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zza(i7, zzc(t, iZzc & 1048575));
                        }
                        break;
                    case UserMetadata.MAX_ATTRIBUTES:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zzd(i7, zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 65:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zzc(i7, zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 66:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zze(i7, zzc(t, iZzc & 1048575));
                        }
                        break;
                    case 67:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zzd(i7, zzd(t, iZzc & 1048575));
                        }
                        break;
                    case 68:
                        if (zzc(t, i7, length)) {
                            zzmwVar2.zza(i7, zzmg.zze(t, iZzc & 1048575), zze(length));
                        }
                        break;
                }
            }
            while (entry2 != null) {
                this.zzr.zza(zzmwVar2, entry2);
                entry2 = itZzc.hasNext() ? (Map.Entry) itZzc.next() : null;
            }
            return;
        }
        if (this.zzh) {
            zziq<T> zziqVarZza2 = this.zzr.zza(t);
            if (zziqVarZza2.zza.isEmpty()) {
                entry = null;
                it = null;
            } else {
                Iterator itZzd = zziqVarZza2.zzd();
                entry = (Map.Entry) itZzd.next();
                it = itZzd;
            }
        } else {
            entry = null;
            it = null;
        }
        int length2 = this.zzc.length;
        Unsafe unsafe2 = zzb;
        int i8 = 0;
        int i9 = 0;
        int i10 = 1048575;
        while (i9 < length2) {
            int iZzc2 = zzc(i9);
            int[] iArr = this.zzc;
            int i11 = iArr[i9];
            int i12 = (iZzc2 & i5) >>> 20;
            if (i12 <= 17) {
                int i13 = iArr[i9 + 2];
                int i14 = i13 & i6;
                if (i14 != i10) {
                    i8 = i14 == i6 ? 0 : unsafe2.getInt(t, i14);
                    i10 = i14;
                } else {
                    it = it;
                }
                i2 = i8;
                i3 = 1 << (i13 >>> 20);
                i = i10;
            } else {
                it = it;
                i = i10;
                i2 = i8;
                i3 = 0;
            }
            while (entry != null && this.zzr.zza(entry) <= i11) {
                this.zzr.zza(zzmwVar2, entry);
                entry = it.hasNext() ? (Map.Entry) it.next() : null;
            }
            long j = iZzc2 & 1048575;
            switch (i12) {
                case 0:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zza(i11, zzmg.zza(t, j));
                    }
                    break;
                case 1:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zza(i11, zzmg.zzb(t, j));
                    }
                    break;
                case 2:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zzb(i11, unsafe.getLong(t, j));
                    }
                    break;
                case 3:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zze(i11, unsafe.getLong(t, j));
                    }
                    break;
                case 4:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zzc(i11, unsafe.getInt(t, j));
                    }
                    break;
                case 5:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zza(i11, unsafe.getLong(t, j));
                    }
                    break;
                case 6:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zzb(i11, unsafe.getInt(t, j));
                    }
                    break;
                case 7:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zza(i11, zzmg.zzh(t, j));
                    }
                    break;
                case 8:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zza(i11, unsafe.getObject(t, j), zzmwVar2);
                    }
                    break;
                case 9:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zzb(i11, unsafe.getObject(t, j), zze(i4));
                    }
                    break;
                case 10:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zza(i11, (zzhm) unsafe.getObject(t, j));
                    }
                    break;
                case 11:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zzf(i11, unsafe.getInt(t, j));
                    }
                    break;
                case 12:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zza(i11, unsafe.getInt(t, j));
                    }
                    break;
                case 13:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zzd(i11, unsafe.getInt(t, j));
                    }
                    break;
                case 14:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zzc(i11, unsafe.getLong(t, j));
                    }
                    break;
                case 15:
                    i = i;
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zze(i11, unsafe.getInt(t, j));
                    }
                    break;
                case 16:
                    entry = entry;
                    length2 = length2;
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    i = i;
                    if (zza(t, i4, i, i2, i3)) {
                        zzmwVar2.zzd(i11, unsafe.getLong(t, j));
                    }
                    break;
                case 17:
                    z = false;
                    entry = entry;
                    i4 = i9;
                    length2 = length2;
                    unsafe = unsafe2;
                    if (zza(t, i9, i, i2, i3)) {
                        zzmwVar2 = zzmwVar;
                        zzmwVar2.zza(i11, unsafe.getObject(t, j), zze(i4));
                    } else {
                        zzmwVar2 = zzmwVar;
                    }
                    i = i;
                    break;
                case 18:
                    z2 = false;
                    zzld.zzb(this.zzc[i9], (List<Double>) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 19:
                    z2 = false;
                    zzld.zzf(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 20:
                    z2 = false;
                    zzld.zzh(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case CommonStatusCodes.RECONNECTION_TIMED_OUT_DURING_UPDATE:
                    z2 = false;
                    zzld.zzn(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 22:
                    z2 = false;
                    zzld.zzg(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case ConnectionResult.API_DISABLED:
                    z2 = false;
                    zzld.zze(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case ConnectionResult.API_DISABLED_FOR_CONNECTION:
                    z2 = false;
                    zzld.zzd(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 25:
                    z2 = false;
                    zzld.zza(this.zzc[i9], (List<Boolean>) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 26:
                    zzld.zzb(this.zzc[i9], (List<String>) unsafe2.getObject(t, j), zzmwVar2);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 27:
                    zzld.zzb(this.zzc[i9], (List<?>) unsafe2.getObject(t, j), zzmwVar2, zze(i9));
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 28:
                    zzld.zza(this.zzc[i9], (List<zzhm>) unsafe2.getObject(t, j), zzmwVar2);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 29:
                    z2 = false;
                    zzld.zzm(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case l11l11lI1lll.l11l1111Il1l:
                    z2 = false;
                    zzld.zzc(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 31:
                    z2 = false;
                    zzld.zzi(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 32:
                    z2 = false;
                    zzld.zzj(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case Encoder.DEFAULT_EC_PERCENT:
                    z2 = false;
                    zzld.zzk(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 34:
                    z2 = false;
                    zzld.zzl(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, false);
                    z = z2;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 35:
                    zzld.zzb(this.zzc[i9], (List<Double>) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 36:
                    zzld.zzf(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 37:
                    zzld.zzh(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 38:
                    zzld.zzn(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 39:
                    zzld.zzg(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 40:
                    zzld.zze(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 41:
                    zzld.zzd(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 42:
                    zzld.zza(this.zzc[i9], (List<Boolean>) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 43:
                    zzld.zzm(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 44:
                    zzld.zzc(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 45:
                    zzld.zzi(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 46:
                    zzld.zzj(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 47:
                    zzld.zzk(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 48:
                    zzld.zzl(this.zzc[i9], (List) unsafe2.getObject(t, j), zzmwVar2, true);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 49:
                    zzld.zza(this.zzc[i9], (List<?>) unsafe2.getObject(t, j), zzmwVar2, zze(i9));
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case l1l1l11Il.l11l111I11l:
                    zza(zzmwVar2, i11, unsafe2.getObject(t, j), i9);
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 51:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zza(i11, zza(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 52:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zza(i11, zzb(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 53:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zzb(i11, zzd(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 54:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zze(i11, zzd(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 55:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zzc(i11, zzc(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 56:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zza(i11, zzd(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 57:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zzb(i11, zzc(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 58:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zza(i11, zze(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 59:
                    if (zzc(t, i11, i9)) {
                        zza(i11, unsafe2.getObject(t, j), zzmwVar2);
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case l11l111l11Il.l11l11l1llIl:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zzb(i11, unsafe2.getObject(t, j), zze(i9));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 61:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zza(i11, (zzhm) unsafe2.getObject(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 62:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zzf(i11, zzc(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 63:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zza(i11, zzc(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case UserMetadata.MAX_ATTRIBUTES:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zzd(i11, zzc(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 65:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zzc(i11, zzd(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 66:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zze(i11, zzc(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 67:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zzd(i11, zzd(t, j));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                case 68:
                    if (zzc(t, i11, i9)) {
                        zzmwVar2.zza(i11, unsafe2.getObject(t, j), zze(i9));
                    }
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
                default:
                    z = false;
                    i4 = i9;
                    unsafe = unsafe2;
                    break;
            }
            i9 = i4 + 3;
            i8 = i2;
            unsafe2 = unsafe;
            i6 = 1048575;
            it = it;
            entry = entry;
            length2 = length2;
            i10 = i;
            i5 = 267386880;
        }
        Iterator it2 = it;
        while (entry != null) {
            this.zzr.zza(zzmwVar2, entry);
            entry = it2.hasNext() ? (Map.Entry) it2.next() : null;
        }
        zza(this.zzq, t, zzmwVar2);
    }

    private static <UT, UB> void zza(zzma<UT, UB> zzmaVar, T t, zzmw zzmwVar) throws IOException {
        zzmaVar.zzb(zzmaVar.zzd(t), zzmwVar);
    }

    private final boolean zzc(T t, T t2, int i) {
        return zzc((Object) t, i) == zzc((Object) t2, i);
    }

    @Override
    public final boolean zzb(T t, T t2) {
        int length = this.zzc.length;
        int i = 0;
        while (true) {
            boolean zZza = true;
            if (i < length) {
                int iZzc = zzc(i);
                long j = iZzc & 1048575;
                switch ((iZzc & 267386880) >>> 20) {
                    case 0:
                        if (!zzc(t, t2, i) || Double.doubleToLongBits(zzmg.zza(t, j)) != Double.doubleToLongBits(zzmg.zza(t2, j))) {
                            zZza = false;
                        }
                        break;
                    case 1:
                        if (!zzc(t, t2, i) || Float.floatToIntBits(zzmg.zzb(t, j)) != Float.floatToIntBits(zzmg.zzb(t2, j))) {
                            zZza = false;
                        }
                        break;
                    case 2:
                        if (!zzc(t, t2, i) || zzmg.zzd(t, j) != zzmg.zzd(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 3:
                        if (!zzc(t, t2, i) || zzmg.zzd(t, j) != zzmg.zzd(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 4:
                        if (!zzc(t, t2, i) || zzmg.zzc(t, j) != zzmg.zzc(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 5:
                        if (!zzc(t, t2, i) || zzmg.zzd(t, j) != zzmg.zzd(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 6:
                        if (!zzc(t, t2, i) || zzmg.zzc(t, j) != zzmg.zzc(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 7:
                        if (!zzc(t, t2, i) || zzmg.zzh(t, j) != zzmg.zzh(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 8:
                        if (!zzc(t, t2, i) || !zzld.zza(zzmg.zze(t, j), zzmg.zze(t2, j))) {
                            zZza = false;
                        }
                        break;
                    case 9:
                        if (!zzc(t, t2, i) || !zzld.zza(zzmg.zze(t, j), zzmg.zze(t2, j))) {
                            zZza = false;
                        }
                        break;
                    case 10:
                        if (!zzc(t, t2, i) || !zzld.zza(zzmg.zze(t, j), zzmg.zze(t2, j))) {
                            zZza = false;
                        }
                        break;
                    case 11:
                        if (!zzc(t, t2, i) || zzmg.zzc(t, j) != zzmg.zzc(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 12:
                        if (!zzc(t, t2, i) || zzmg.zzc(t, j) != zzmg.zzc(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 13:
                        if (!zzc(t, t2, i) || zzmg.zzc(t, j) != zzmg.zzc(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 14:
                        if (!zzc(t, t2, i) || zzmg.zzd(t, j) != zzmg.zzd(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 15:
                        if (!zzc(t, t2, i) || zzmg.zzc(t, j) != zzmg.zzc(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 16:
                        if (!zzc(t, t2, i) || zzmg.zzd(t, j) != zzmg.zzd(t2, j)) {
                            zZza = false;
                        }
                        break;
                    case 17:
                        if (!zzc(t, t2, i) || !zzld.zza(zzmg.zze(t, j), zzmg.zze(t2, j))) {
                            zZza = false;
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
                        zZza = zzld.zza(zzmg.zze(t, j), zzmg.zze(t2, j));
                        break;
                    case l1l1l11Il.l11l111I11l:
                        zZza = zzld.zza(zzmg.zze(t, j), zzmg.zze(t2, j));
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
                        long jZzb = zzb(i) & 1048575;
                        if (zzmg.zzc(t, jZzb) != zzmg.zzc(t2, jZzb) || !zzld.zza(zzmg.zze(t, j), zzmg.zze(t2, j))) {
                            zZza = false;
                        }
                        break;
                }
                if (!zZza) {
                    return false;
                }
                i += 3;
            } else {
                if (!this.zzq.zzd(t).equals(this.zzq.zzd(t2))) {
                    return false;
                }
                if (this.zzh) {
                    return this.zzr.zza(t).equals(this.zzr.zza(t2));
                }
                return true;
            }
        }
    }

    private final boolean zzc(T t, int i) {
        int iZzb = zzb(i);
        long j = iZzb & 1048575;
        if (j != 1048575) {
            return (zzmg.zzc(t, j) & (1 << (iZzb >>> 20))) != 0;
        }
        int iZzc = zzc(i);
        long j2 = iZzc & 1048575;
        switch ((iZzc & 267386880) >>> 20) {
            case 0:
                return Double.doubleToRawLongBits(zzmg.zza(t, j2)) != 0;
            case 1:
                return Float.floatToRawIntBits(zzmg.zzb(t, j2)) != 0;
            case 2:
                return zzmg.zzd(t, j2) != 0;
            case 3:
                return zzmg.zzd(t, j2) != 0;
            case 4:
                return zzmg.zzc(t, j2) != 0;
            case 5:
                return zzmg.zzd(t, j2) != 0;
            case 6:
                return zzmg.zzc(t, j2) != 0;
            case 7:
                return zzmg.zzh(t, j2);
            case 8:
                Object objZze = zzmg.zze(t, j2);
                if (objZze instanceof String) {
                    return !((String) objZze).isEmpty();
                }
                if (objZze instanceof zzhm) {
                    return !zzhm.zza.equals(objZze);
                }
                throw new IllegalArgumentException();
            case 9:
                return zzmg.zze(t, j2) != null;
            case 10:
                return !zzhm.zza.equals(zzmg.zze(t, j2));
            case 11:
                return zzmg.zzc(t, j2) != 0;
            case 12:
                return zzmg.zzc(t, j2) != 0;
            case 13:
                return zzmg.zzc(t, j2) != 0;
            case 14:
                return zzmg.zzd(t, j2) != 0;
            case 15:
                return zzmg.zzc(t, j2) != 0;
            case 16:
                return zzmg.zzd(t, j2) != 0;
            case 17:
                return zzmg.zze(t, j2) != null;
            default:
                throw new IllegalArgumentException();
        }
    }

    private final boolean zza(T t, int i, int i2, int i3, int i4) {
        if (i2 == 1048575) {
            return zzc((Object) t, i);
        }
        return (i3 & i4) != 0;
    }

    @Override
    public final boolean zzd(T t) {
        int i;
        int i2;
        List list;
        ?? Zze;
        int i3;
        int i4 = 1048575;
        int i5 = 0;
        int i6 = 0;
        while (i6 < this.zzm) {
            int i7 = this.zzl[i6];
            int i8 = this.zzc[i7];
            int iZzc = zzc(i7);
            int i9 = this.zzc[i7 + 2];
            int i10 = i9 & 1048575;
            int i11 = 1 << (i9 >>> 20);
            if (i10 != i4) {
                if (i10 != 1048575) {
                    i5 = zzb.getInt(t, i10);
                }
                i2 = i5;
                i = i10;
            } else {
                i = i4;
                i2 = i5;
            }
            if ((268435456 & iZzc) != 0 && !zza(t, i7, i, i2, i11)) {
                return false;
            }
            int i12 = (267386880 & iZzc) >>> 20;
            if (i12 == 9 || i12 == 17) {
                if (zza(t, i7, i, i2, i11) && !zza((Object) t, iZzc, zze(i7))) {
                    return false;
                }
            } else if (i12 == 27) {
                list = (List) zzmg.zze(t, iZzc & 1048575);
                if (list.isEmpty()) {
                    continue;
                } else {
                    Zze = zze(i7);
                    for (i3 = 0; i3 < list.size(); i3++) {
                        if (!Zze.zzd(list.get(i3))) {
                            return false;
                        }
                    }
                }
            } else if (i12 == 60 || i12 == 68) {
                if (zzc(t, i8, i7) && !zza((Object) t, iZzc, zze(i7))) {
                    return false;
                }
            } else if (i12 == 49) {
                list = (List) zzmg.zze(t, iZzc & 1048575);
                if (list.isEmpty()) {
                    Zze = zze(i7);
                    while (i3 < list.size()) {
                        if (!Zze.zzd(list.get(i3))) {
                            return false;
                        }
                    }
                } else {
                    continue;
                }
            } else if (i12 != 50) {
                continue;
            } else {
                Map<?, ?> mapZzd = this.zzs.zzd(zzmg.zze(t, iZzc & 1048575));
                if (mapZzd.isEmpty()) {
                    continue;
                } else if (this.zzs.zza(zzf(i7)).zzc.zzb() == zzmx.MESSAGE) {
                    ?? Zza = 0;
                    for (Object obj : mapZzd.values()) {
                        if (Zza == 0) {
                            Zza = Zza;
                            Zza = zzkx.zza().zza((Class) obj.getClass());
                        }
                        Zza = Zza;
                        if (!Zza.zzd(obj)) {
                            return false;
                        }
                    }
                } else {
                    continue;
                }
            }
            i6++;
            i4 = i;
            i5 = i2;
        }
        return !this.zzh || this.zzr.zza(t).zzg();
    }

    private static boolean zza(Object obj, int i, zzlb zzlbVar) {
        return zzlbVar.zzd(zzmg.zze(obj, i & 1048575));
    }

    private static boolean zzg(Object obj) {
        if (obj == null) {
            return false;
        }
        if (obj instanceof zzix) {
            return ((zzix) obj).zzcj();
        }
        return true;
    }

    private final boolean zzc(T t, int i, int i2) {
        return zzmg.zzc(t, (long) (zzb(i2) & 1048575)) == i;
    }

    private static <T> boolean zze(T t, long j) {
        return ((Boolean) zzmg.zze(t, j)).booleanValue();
    }
}
