package com.google.android.gms.internal.play_billing;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

final class zzfm {
    private static final zzfm zzd = new zzfm(true);
    final zzht zza = new zzho();
    boolean zzb;
    boolean zzc;

    private zzfm() {
    }

    static int zza(zzir zzirVar, int i, Object obj) {
        int iZzy = zzfc.zzy(i << 3);
        if (zzirVar == zzir.GROUP) {
            iZzy += iZzy;
        }
        return iZzy + zzb(zzirVar, obj);
    }

    static int zzb(zzir zzirVar, Object obj) {
        int iZzb;
        int iZzy;
        zzir zzirVar2 = zzir.DOUBLE;
        zzis zzisVar = zzis.INT;
        switch (zzirVar) {
            case DOUBLE:
                ((Double) obj).doubleValue();
                int i = zzfc.zzb;
                return 8;
            case FLOAT:
                ((Float) obj).floatValue();
                int i2 = zzfc.zzb;
                return 4;
            case INT64:
                return zzfc.zzz(((Long) obj).longValue());
            case UINT64:
                return zzfc.zzz(((Long) obj).longValue());
            case INT32:
                return zzfc.zzz(((Integer) obj).intValue());
            case FIXED64:
                ((Long) obj).longValue();
                int i3 = zzfc.zzb;
                return 8;
            case FIXED32:
                ((Integer) obj).intValue();
                int i4 = zzfc.zzb;
                return 4;
            case BOOL:
                ((Boolean) obj).booleanValue();
                int i5 = zzfc.zzb;
                return 1;
            case STRING:
                if (!(obj instanceof zzev)) {
                    int i6 = zzfc.zzb;
                    iZzb = zzin.zzb((String) obj);
                    iZzy = zzfc.zzy(iZzb);
                } else {
                    int i7 = zzfc.zzb;
                    iZzb = ((zzev) obj).zze();
                    iZzy = zzfc.zzy(iZzb);
                }
                break;
            case GROUP:
                return ((zzhb) obj).zzn();
            case MESSAGE:
                if (!(obj instanceof zzgh)) {
                    return zzfc.zzx((zzhb) obj);
                }
                iZzb = ((zzgh) obj).zza();
                iZzy = zzfc.zzy(iZzb);
                break;
                break;
            case BYTES:
                if (!(obj instanceof zzev)) {
                    int i8 = zzfc.zzb;
                    iZzb = ((byte[]) obj).length;
                    iZzy = zzfc.zzy(iZzb);
                } else {
                    int i9 = zzfc.zzb;
                    iZzb = ((zzev) obj).zze();
                    iZzy = zzfc.zzy(iZzb);
                }
                break;
            case UINT32:
                return zzfc.zzy(((Integer) obj).intValue());
            case ENUM:
                return obj instanceof zzfw ? zzfc.zzz(((zzfw) obj).zza()) : zzfc.zzz(((Integer) obj).intValue());
            case SFIXED32:
                ((Integer) obj).intValue();
                int i10 = zzfc.zzb;
                return 4;
            case SFIXED64:
                ((Long) obj).longValue();
                int i11 = zzfc.zzb;
                return 8;
            case SINT32:
                int iIntValue = ((Integer) obj).intValue();
                return zzfc.zzy((iIntValue >> 31) ^ (iIntValue + iIntValue));
            case SINT64:
                long jLongValue = ((Long) obj).longValue();
                return zzfc.zzz((jLongValue >> 63) ^ (jLongValue + jLongValue));
            default:
                throw new RuntimeException("There is no way to get here, but the compiler thinks otherwise.");
        }
        return iZzy + iZzb;
    }

    public static int zzc(zzfl zzflVar, Object obj) {
        zzir zzirVarZzb = zzflVar.zzb();
        int iZza = zzflVar.zza();
        if (!zzflVar.zze()) {
            return zza(zzirVarZzb, iZza, obj);
        }
        List list = (List) obj;
        int size = list.size();
        int i = 0;
        if (!zzflVar.zzd()) {
            int iZza2 = 0;
            while (i < size) {
                iZza2 += zza(zzirVarZzb, iZza, list.get(i));
                i++;
            }
            return iZza2;
        }
        if (list.isEmpty()) {
            return 0;
        }
        int iZzb = 0;
        while (i < size) {
            iZzb += zzb(zzirVarZzb, list.get(i));
            i++;
        }
        return zzfc.zzy(iZza << 3) + iZzb + zzfc.zzy(iZzb);
    }

    public static zzfm zze() {
        return zzd;
    }

    static void zzi(zzfc zzfcVar, zzir zzirVar, int i, Object obj) throws IOException {
        if (zzirVar == zzir.GROUP) {
            zzfcVar.zzs(i, 3);
            ((zzhb) obj).zzD(zzfcVar);
            zzfcVar.zzs(i, 4);
            return;
        }
        zzfcVar.zzs(i, zzirVar.zza());
        zzis zzisVar = zzis.INT;
        switch (zzirVar) {
            case DOUBLE:
                zzfcVar.zzk(Double.doubleToRawLongBits(((Double) obj).doubleValue()));
                break;
            case FLOAT:
                zzfcVar.zzi(Float.floatToRawIntBits(((Float) obj).floatValue()));
                break;
            case INT64:
                zzfcVar.zzw(((Long) obj).longValue());
                break;
            case UINT64:
                zzfcVar.zzw(((Long) obj).longValue());
                break;
            case INT32:
                zzfcVar.zzm(((Integer) obj).intValue());
                break;
            case FIXED64:
                zzfcVar.zzk(((Long) obj).longValue());
                break;
            case FIXED32:
                zzfcVar.zzi(((Integer) obj).intValue());
                break;
            case BOOL:
                zzfcVar.zzb(((Boolean) obj).booleanValue() ? (byte) 1 : (byte) 0);
                break;
            case STRING:
                if (!(obj instanceof zzev)) {
                    zzfcVar.zzr((String) obj);
                } else {
                    zzfcVar.zzg((zzev) obj);
                }
                break;
            case GROUP:
                ((zzhb) obj).zzD(zzfcVar);
                break;
            case MESSAGE:
                zzfcVar.zzn((zzhb) obj);
                break;
            case BYTES:
                if (!(obj instanceof zzev)) {
                    byte[] bArr = (byte[]) obj;
                    zzfcVar.zze(bArr, 0, bArr.length);
                } else {
                    zzfcVar.zzg((zzev) obj);
                }
                break;
            case UINT32:
                zzfcVar.zzu(((Integer) obj).intValue());
                break;
            case ENUM:
                if (!(obj instanceof zzfw)) {
                    zzfcVar.zzm(((Integer) obj).intValue());
                } else {
                    zzfcVar.zzm(((zzfw) obj).zza());
                }
                break;
            case SFIXED32:
                zzfcVar.zzi(((Integer) obj).intValue());
                break;
            case SFIXED64:
                zzfcVar.zzk(((Long) obj).longValue());
                break;
            case SINT32:
                int iIntValue = ((Integer) obj).intValue();
                zzfcVar.zzu((iIntValue >> 31) ^ (iIntValue + iIntValue));
                break;
            case SINT64:
                long jLongValue = ((Long) obj).longValue();
                zzfcVar.zzw((jLongValue >> 63) ^ (jLongValue + jLongValue));
                break;
        }
    }

    private static boolean zzk(Map.Entry entry) {
        zzfl zzflVar = (zzfl) entry.getKey();
        if (zzflVar.zzc() != zzis.MESSAGE) {
            return true;
        }
        if (!zzflVar.zze()) {
            return zzl(entry.getValue());
        }
        List list = (List) entry.getValue();
        int size = list.size();
        for (int i = 0; i < size; i++) {
            if (!zzl(list.get(i))) {
                return false;
            }
        }
        return true;
    }

    private static boolean zzl(Object obj) {
        if (obj instanceof zzhc) {
            return ((zzhc) obj).zzo();
        }
        if (obj instanceof zzgh) {
            return true;
        }
        throw new IllegalArgumentException("Wrong object type used with protocol message reflection.");
    }

    private static final int zzm(Map.Entry entry) {
        int i;
        int iZzy;
        int iZzy2;
        zzfl zzflVar = (zzfl) entry.getKey();
        Object value = entry.getValue();
        if (zzflVar.zzc() != zzis.MESSAGE || zzflVar.zze() || zzflVar.zzd()) {
            return zzc(zzflVar, value);
        }
        if (value instanceof zzgh) {
            int iZza = ((zzfl) entry.getKey()).zza();
            int iZzy3 = zzfc.zzy(8);
            i = iZzy3 + iZzy3;
            iZzy = zzfc.zzy(16) + zzfc.zzy(iZza);
            int iZzy4 = zzfc.zzy(24);
            int iZza2 = ((zzgh) value).zza();
            iZzy2 = iZzy4 + zzfc.zzy(iZza2) + iZza2;
        } else {
            int iZza3 = ((zzfl) entry.getKey()).zza();
            int iZzy5 = zzfc.zzy(8);
            i = iZzy5 + iZzy5;
            iZzy = zzfc.zzy(16) + zzfc.zzy(iZza3);
            iZzy2 = zzfc.zzy(24) + zzfc.zzx((zzhb) value);
        }
        return i + iZzy + iZzy2;
    }

    private static final void zzn(zzfl zzflVar, Object obj) {
        boolean z;
        zzflVar.zzb();
        byte[] bArr = zzga.zzb;
        obj.getClass();
        zzir zzirVar = zzir.DOUBLE;
        zzis zzisVar = zzis.INT;
        switch (r0.zzb()) {
            case INT:
                z = obj instanceof Integer;
                if (z) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            case LONG:
                z = obj instanceof Long;
                if (z) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            case FLOAT:
                z = obj instanceof Float;
                if (z) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            case DOUBLE:
                z = obj instanceof Double;
                if (z) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            case BOOLEAN:
                z = obj instanceof Boolean;
                if (z) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            case STRING:
                z = obj instanceof String;
                if (z) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            case BYTE_STRING:
                if ((obj instanceof zzev) || (obj instanceof byte[])) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            case ENUM:
                if ((obj instanceof Integer) || (obj instanceof zzfw)) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            case MESSAGE:
                if ((obj instanceof zzhb) || (obj instanceof zzgh)) {
                    return;
                }
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
            default:
                throw new IllegalArgumentException(String.format("Wrong object type used with protocol message reflection.\nField number: %d, field java type: %s, value type: %s\n", Integer.valueOf(zzflVar.zza()), zzflVar.zzb().zzb(), obj.getClass().getName()));
        }
    }

    public final Object clone() throws CloneNotSupportedException {
        zzfm zzfmVar = new zzfm();
        zzht zzhtVar = this.zza;
        int iZzc = zzhtVar.zzc();
        for (int i = 0; i < iZzc; i++) {
            Map.Entry entryZzg = zzhtVar.zzg(i);
            zzfmVar.zzh((zzfl) ((zzhp) entryZzg).zza(), entryZzg.getValue());
        }
        for (Map.Entry entry : zzhtVar.zzd()) {
            zzfmVar.zzh((zzfl) entry.getKey(), entry.getValue());
        }
        zzfmVar.zzc = this.zzc;
        return zzfmVar;
    }

    public final boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj instanceof zzfm) {
            return this.zza.equals(((zzfm) obj).zza);
        }
        return false;
    }

    public final int hashCode() {
        return this.zza.hashCode();
    }

    public final int zzd() {
        zzht zzhtVar = this.zza;
        int iZzc = zzhtVar.zzc();
        int iZzm = 0;
        for (int i = 0; i < iZzc; i++) {
            iZzm += zzm(zzhtVar.zzg(i));
        }
        Iterator it = zzhtVar.zzd().iterator();
        while (it.hasNext()) {
            iZzm += zzm((Map.Entry) it.next());
        }
        return iZzm;
    }

    public final Iterator zzf() {
        zzht zzhtVar = this.zza;
        if (zzhtVar.isEmpty()) {
            return Collections.emptyIterator();
        }
        return this.zzc ? new zzgf(zzhtVar.entrySet().iterator()) : zzhtVar.entrySet().iterator();
    }

    public final void zzg() {
        if (this.zzb) {
            return;
        }
        zzht zzhtVar = this.zza;
        int iZzc = zzhtVar.zzc();
        for (int i = 0; i < iZzc; i++) {
            Object value = zzhtVar.zzg(i).getValue();
            if (value instanceof zzfu) {
                ((zzfu) value).zzz();
            }
        }
        Iterator it = zzhtVar.zzd().iterator();
        while (it.hasNext()) {
            Object value2 = ((Map.Entry) it.next()).getValue();
            if (value2 instanceof zzfu) {
                ((zzfu) value2).zzz();
            }
        }
        zzhtVar.zza();
        this.zzb = true;
    }

    public final void zzh(zzfl zzflVar, Object obj) {
        if (!zzflVar.zze()) {
            zzn(zzflVar, obj);
        } else {
            if (!(obj instanceof List)) {
                throw new IllegalArgumentException("Wrong object type used with protocol message reflection.");
            }
            List list = (List) obj;
            int size = list.size();
            ArrayList arrayList = new ArrayList(size);
            for (int i = 0; i < size; i++) {
                Object obj2 = list.get(i);
                zzn(zzflVar, obj2);
                arrayList.add(obj2);
            }
            obj = arrayList;
        }
        if (obj instanceof zzgh) {
            this.zzc = true;
        }
        this.zza.put(zzflVar, obj);
    }

    public final boolean zzj() {
        zzht zzhtVar = this.zza;
        int iZzc = zzhtVar.zzc();
        for (int i = 0; i < iZzc; i++) {
            if (!zzk(zzhtVar.zzg(i))) {
                return false;
            }
        }
        Iterator it = zzhtVar.zzd().iterator();
        while (it.hasNext()) {
            if (!zzk((Map.Entry) it.next())) {
                return false;
            }
        }
        return true;
    }

    private zzfm(boolean z) {
        zzg();
        zzg();
    }
}
