package com.google.android.gms.internal.play_billing;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.Objects;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.RandomAccess;
import java.util.function.UnaryOperator;

public abstract class zzbw extends zzbt implements List, RandomAccess, j$.util.List {
    private static final zzcl zza = new zzbu(zzcd.zza, 0);
    public static final int zzd = 0;

    zzbw() {
    }

    static zzbw zzi(Object[] objArr, int i) {
        return i == 0 ? zzcd.zza : new zzcd(objArr, i);
    }

    public static zzbw zzj(Collection collection) {
        if (!(collection instanceof zzbt)) {
            Object[] array = collection.toArray();
            int length = array.length;
            zzcc.zza(array, length);
            return zzi(array, length);
        }
        zzbw zzbwVarZzd = ((zzbt) collection).zzd();
        if (!zzbwVarZzd.zzf()) {
            return zzbwVarZzd;
        }
        Object[] array2 = zzbwVarZzd.toArray();
        return zzi(array2, array2.length);
    }

    public static zzbw zzk() {
        return zzcd.zza;
    }

    public static zzbw zzl(Object obj) {
        Object[] objArr = {"inapp"};
        zzcc.zza(objArr, 1);
        return zzi(objArr, 1);
    }

    public static zzbw zzm(Object obj, Object obj2) {
        Object[] objArr = {"subs", "inapp"};
        zzcc.zza(objArr, 2);
        return zzi(objArr, 2);
    }

    @Override
    @Deprecated
    public final void add(int i, Object obj) {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final boolean addAll(int i, Collection collection) {
        throw new UnsupportedOperationException();
    }

    @Override
    public final boolean contains(Object obj) {
        return indexOf(obj) >= 0;
    }

    @Override
    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (obj instanceof List) {
            List list = (List) obj;
            int size = size();
            if (size == list.size()) {
                if (list instanceof RandomAccess) {
                    for (int i = 0; i < size; i++) {
                        if (Objects.equals(get(i), list.get(i))) {
                        }
                    }
                    return true;
                }
                Iterator it = iterator();
                Iterator it2 = list.iterator();
                while (it.hasNext()) {
                    if (it2.hasNext() && Objects.equals(it.next(), it2.next())) {
                    }
                }
                if (!it2.hasNext()) {
                    return true;
                }
            }
        }
        return false;
    }

    @Override
    public final int hashCode() {
        int size = size();
        int iHashCode = 1;
        for (int i = 0; i < size; i++) {
            iHashCode = (iHashCode * 31) + get(i).hashCode();
        }
        return iHashCode;
    }

    @Override
    public final int indexOf(Object obj) {
        if (obj == null) {
            return -1;
        }
        int size = size();
        for (int i = 0; i < size; i++) {
            if (obj.equals(get(i))) {
                return i;
            }
        }
        return -1;
    }

    @Override
    public final Iterator iterator() {
        return listIterator(0);
    }

    @Override
    public final int lastIndexOf(Object obj) {
        if (obj == null) {
            return -1;
        }
        for (int size = size() - 1; size >= 0; size--) {
            if (obj.equals(get(size))) {
                return size;
            }
        }
        return -1;
    }

    @Override
    public final ListIterator listIterator() {
        return listIterator(0);
    }

    @Override
    @Deprecated
    public final Object remove(int i) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void replaceAll(UnaryOperator unaryOperator) {
        j$.util.List.-CC.$default$replaceAll(this, unaryOperator);
    }

    @Override
    @Deprecated
    public final Object set(int i, Object obj) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void sort(Comparator comparator) {
        j$.util.List.-CC.$default$sort(this, comparator);
    }

    @Override
    int zza(Object[] objArr, int i) {
        int size = size();
        for (int i2 = 0; i2 < size; i2++) {
            objArr[i2] = get(i2);
        }
        return size;
    }

    @Override
    @Deprecated
    public final zzbw zzd() {
        return this;
    }

    @Override
    public final zzck iterator() {
        return listIterator(0);
    }

    @Override
    public zzbw subList(int i, int i2) {
        zzbj.zzd(i, i2, size());
        int i3 = i2 - i;
        if (i3 == size()) {
            return this;
        }
        return i3 == 0 ? zzcd.zza : new zzbv(this, i, i3);
    }

    @Override
    public final zzcl listIterator(int i) {
        zzbj.zzb(i, size(), FirebaseAnalytics.Param.INDEX);
        return isEmpty() ? zza : new zzbu(this, i);
    }
}
