package com.google.android.gms.internal.games_v2;

import com.google.common.primitives.Ints;
import j$.util.Objects;
import java.util.Arrays;
import java.util.Set;

public abstract class zzhk extends zzgy implements Set, j$.util.Set {
    private transient zzhd zza;

    zzhk() {
    }

    static int zzf(int i) {
        int iMax = Math.max(i, 2);
        if (iMax >= 751619276) {
            if (iMax < 1073741824) {
                return Ints.MAX_POWER_OF_TWO;
            }
            throw new IllegalArgumentException("collection too large");
        }
        int iHighestOneBit = Integer.highestOneBit(iMax - 1);
        do {
            iHighestOneBit += iHighestOneBit;
        } while (((double) iHighestOneBit) * 0.7d < iMax);
        return iHighestOneBit;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if ((obj instanceof zzhk) && zzg() && ((zzhk) obj).zzg() && hashCode() != obj.hashCode()) {
            return false;
        }
        if (obj == this) {
            return true;
        }
        if (obj instanceof Set) {
            Set set = (Set) obj;
            try {
                if (size() == set.size() && containsAll(set)) {
                    return true;
                }
            } catch (ClassCastException | NullPointerException unused) {
            }
        }
        return false;
    }

    @Override
    public int hashCode() {
        return zzih.zza(this);
    }

    @Override
    public abstract zzil iterator();

    boolean zzg() {
        return false;
    }

    public final zzhd zzh() {
        zzhd zzhdVar = this.zza;
        if (zzhdVar != null) {
            return zzhdVar;
        }
        zzhd zzhdVarZzi = zzi();
        this.zza = zzhdVarZzi;
        return zzhdVarZzi;
    }

    zzhd zzi() {
        Object[] array = toArray();
        int i = zzhd.zzd;
        return zzhd.zzk(array, array.length);
    }

    public static zzhk zzk(int i, Object... objArr) {
        if (i == 0) {
            return zzif.zza;
        }
        if (i == 1) {
            return new zzii(Objects.requireNonNull(objArr[0]));
        }
        int iZzf = zzf(i);
        Object[] objArr2 = new Object[iZzf];
        int i2 = iZzf - 1;
        int i3 = 0;
        int i4 = 0;
        for (int i5 = 0; i5 < i; i5++) {
            Object obj = objArr[i5];
            zzhs.zzb(obj, i5);
            int iHashCode = obj.hashCode();
            int iZza = zzgv.zza(iHashCode);
            while (true) {
                int i6 = iZza & i2;
                Object obj2 = objArr2[i6];
                if (obj2 == null) {
                    objArr[i4] = obj;
                    objArr2[i6] = obj;
                    i3 += iHashCode;
                    i4++;
                    break;
                }
                if (obj2.equals(obj)) {
                    break;
                }
                iZza++;
            }
        }
        Arrays.fill(objArr, i4, i, (Object) null);
        if (i4 == 1) {
            return new zzii(Objects.requireNonNull(objArr[0]));
        }
        if (zzf(i4) < iZzf / 2) {
            return zzk(i4, objArr);
        }
        int length = objArr.length;
        if (i4 < (length >> 1) + (length >> 2)) {
            objArr = Arrays.copyOf(objArr, i4);
        }
        return new zzif(objArr, i3, objArr2, i2, i4);
    }
}
