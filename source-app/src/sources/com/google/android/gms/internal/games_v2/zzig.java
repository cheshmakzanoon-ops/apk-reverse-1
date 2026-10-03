package com.google.android.gms.internal.games_v2;

import java.util.Collection;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Set;

final class zzig extends zzhl {
    static final zzig zzc;
    final transient zzhd zzd;

    static {
        int i = zzhd.zzd;
        zzc = new zzig(zzhz.zza, zzhr.zza);
    }

    zzig(zzhd zzhdVar, Comparator comparator) {
        super(comparator);
        this.zzd = zzhdVar;
    }

    @Override
    public final Object ceiling(Object obj) {
        zzhd zzhdVar = this.zzd;
        int iZzs = zzs(obj, true);
        if (iZzs == zzhdVar.size()) {
            return null;
        }
        return zzhdVar.get(iZzs);
    }

    @Override
    public final boolean contains(Object obj) {
        if (obj != null) {
            try {
                if (Collections.binarySearch(this.zzd, obj, this.zza) >= 0) {
                    return true;
                }
            } catch (ClassCastException unused) {
            }
        }
        return false;
    }

    @Override
    public final boolean containsAll(Collection collection) {
        if (collection instanceof zzhq) {
            collection = ((zzhq) collection).zza();
        }
        Comparator comparator = ((zzhl) this).zza;
        if (!zzik.zza(comparator, collection) || collection.size() <= 1) {
            return super.containsAll(collection);
        }
        zzim zzimVarListIterator = this.zzd.listIterator(0);
        Iterator it = collection.iterator();
        if (!zzimVarListIterator.hasNext()) {
            return false;
        }
        Object next = it.next();
        E next2 = zzimVarListIterator.next();
        while (true) {
            try {
                int iCompare = comparator.compare(next2, next);
                if (iCompare < 0) {
                    if (!zzimVarListIterator.hasNext()) {
                        return false;
                    }
                    next2 = zzimVarListIterator.next();
                } else {
                    if (iCompare != 0) {
                        return false;
                    }
                    if (!it.hasNext()) {
                        return true;
                    }
                    next = it.next();
                }
            } catch (ClassCastException | NullPointerException unused) {
            }
        }
    }

    @Override
    public final boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }
        if (!(obj instanceof Set)) {
            return false;
        }
        Set set = (Set) obj;
        zzhd zzhdVar = this.zzd;
        if (zzhdVar.size() != set.size()) {
            return false;
        }
        if (isEmpty()) {
            return true;
        }
        if (!zzik.zza(this.zza, set)) {
            return containsAll(set);
        }
        Iterator it = set.iterator();
        try {
            zzim zzimVarListIterator = zzhdVar.listIterator(0);
            while (zzimVarListIterator.hasNext()) {
                E next = zzimVarListIterator.next();
                Object next2 = it.next();
                if (next2 == null || ((zzhl) this).zza.compare(next, next2) != 0) {
                    return false;
                }
            }
            return true;
        } catch (ClassCastException | NoSuchElementException unused) {
            return false;
        }
    }

    @Override
    public final Object first() {
        if (isEmpty()) {
            throw new NoSuchElementException();
        }
        return this.zzd.get(0);
    }

    @Override
    public final Object floor(Object obj) {
        int iZzr = zzr(obj, true) - 1;
        if (iZzr == -1) {
            return null;
        }
        return this.zzd.get(iZzr);
    }

    @Override
    public final Object higher(Object obj) {
        zzhd zzhdVar = this.zzd;
        int iZzs = zzs(obj, false);
        if (iZzs == zzhdVar.size()) {
            return null;
        }
        return zzhdVar.get(iZzs);
    }

    @Override
    public final Iterator iterator() {
        return this.zzd.listIterator(0);
    }

    @Override
    public final Object last() {
        if (isEmpty()) {
            throw new NoSuchElementException();
        }
        zzhd zzhdVar = this.zzd;
        return zzhdVar.get(zzhdVar.size() - 1);
    }

    @Override
    public final Object lower(Object obj) {
        int iZzr = zzr(obj, false) - 1;
        if (iZzr == -1) {
            return null;
        }
        return this.zzd.get(iZzr);
    }

    @Override
    public final int size() {
        return this.zzd.size();
    }

    @Override
    public final zzil iterator() {
        return this.zzd.listIterator(0);
    }

    @Override
    final Object[] zzb() {
        return this.zzd.zzb();
    }

    @Override
    final int zzc() {
        return this.zzd.zzc();
    }

    @Override
    final int zzd() {
        return this.zzd.zzd();
    }

    @Override
    final int zze(Object[] objArr, int i) {
        return this.zzd.zze(objArr, 0);
    }

    @Override
    final zzhl zzm(Object obj, boolean z) {
        return zzt(0, zzr(obj, z));
    }

    @Override
    final zzhl zzn(Object obj, boolean z, Object obj2, boolean z2) {
        return zzo(obj, z).zzm(obj2, z2);
    }

    @Override
    final zzhl zzo(Object obj, boolean z) {
        return zzt(zzs(obj, z), this.zzd.size());
    }

    @Override
    final zzhl zzp() {
        Comparator comparatorReverseOrder = Collections.reverseOrder(this.zza);
        return isEmpty() ? zzk(comparatorReverseOrder) : new zzig(this.zzd.zzf(), comparatorReverseOrder);
    }

    @Override
    public final zzil descendingIterator() {
        return this.zzd.zzf().listIterator(0);
    }

    final zzig zzt(int i, int i2) {
        if (i == 0) {
            if (i2 == this.zzd.size()) {
                return this;
            }
            i = 0;
        }
        if (i >= i2) {
            return zzk(this.zza);
        }
        zzhd zzhdVar = this.zzd;
        return new zzig(zzhdVar.subList(i, i2), this.zza);
    }

    final int zzr(Object obj, boolean z) {
        obj.getClass();
        int iBinarySearch = Collections.binarySearch(this.zzd, obj, ((zzhl) this).zza);
        if (iBinarySearch >= 0) {
            return z ? iBinarySearch + 1 : iBinarySearch;
        }
        return ~iBinarySearch;
    }

    final int zzs(Object obj, boolean z) {
        obj.getClass();
        int iBinarySearch = Collections.binarySearch(this.zzd, obj, ((zzhl) this).zza);
        if (iBinarySearch >= 0) {
            return z ? iBinarySearch : iBinarySearch + 1;
        }
        return ~iBinarySearch;
    }
}
