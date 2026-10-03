package com.google.android.gms.internal.games_v2;

import com.google.firebase.analytics.FirebaseAnalytics;
import j$.util.stream.Collector;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.RandomAccess;
import java.util.function.UnaryOperator;

public abstract class zzhd extends zzgy implements List, RandomAccess, j$.util.List {
    private static final zzim zza = new zzha(zzhz.zza, 0);
    public static final int zzd = 0;

    zzhd() {
    }

    public static Collector zzh() {
        return zzgm.zza();
    }

    public static zzhd zzi() {
        return zzhz.zza;
    }

    public static zzhd zzj(Object obj) {
        Object[] objArr = {obj};
        zzhs.zza(objArr, 1);
        return zzk(objArr, 1);
    }

    static zzhd zzk(Object[] objArr, int i) {
        return i == 0 ? zzhz.zza : new zzhz(objArr, i);
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
    public boolean contains(Object obj) {
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
                        if (zzft.zza(get(i), list.get(i))) {
                        }
                    }
                    return true;
                }
                Iterator it = iterator();
                Iterator it2 = list.iterator();
                while (it.hasNext()) {
                    if (it2.hasNext() && zzft.zza(it.next(), it2.next())) {
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

    public int indexOf(Object obj) {
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

    public int lastIndexOf(Object obj) {
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
    public final zzil iterator() {
        return listIterator(0);
    }

    @Override
    int zze(Object[] objArr, int i) {
        int size = size();
        for (int i2 = 0; i2 < size; i2++) {
            objArr[i2] = get(i2);
        }
        return size;
    }

    public zzhd zzf() {
        return size() <= 1 ? this : new zzhb(this);
    }

    @Override
    public zzhd subList(int i, int i2) {
        zzfu.zzd(i, i2, size());
        int i3 = i2 - i;
        if (i3 == size()) {
            return this;
        }
        return i3 == 0 ? zzhz.zza : new zzhc(this, i, i3);
    }

    @Override
    public final zzim listIterator(int i) {
        zzfu.zzc(i, size(), FirebaseAnalytics.Param.INDEX);
        return isEmpty() ? zza : new zzha(this, i);
    }
}
