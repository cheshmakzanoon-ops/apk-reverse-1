package com.google.android.gms.internal.games_v2;

import j$.util.SortedSet;
import java.util.Comparator;
import java.util.NavigableSet;

public abstract class zzhl extends zzhk implements NavigableSet, zzij, SortedSet {
    final transient Comparator zza;
    transient zzhl zzb;

    zzhl(Comparator comparator) {
        this.zza = comparator;
    }

    static zzig zzk(Comparator comparator) {
        if (zzhr.zza.equals(comparator)) {
            return zzig.zzc;
        }
        int i = zzhd.zzd;
        return new zzig(zzhz.zza, comparator);
    }

    @Deprecated
    public final void addFirst(Object obj) {
        throw new UnsupportedOperationException();
    }

    @Deprecated
    public final void addLast(Object obj) {
        throw new UnsupportedOperationException();
    }

    @Override
    public final Comparator comparator() {
        return this.zza;
    }

    @Override
    public final NavigableSet descendingSet() {
        zzhl zzhlVar = this.zzb;
        if (zzhlVar != null) {
            return zzhlVar;
        }
        zzhl zzhlVarZzp = zzp();
        this.zzb = zzhlVarZzp;
        zzhlVarZzp.zzb = this;
        return zzhlVarZzp;
    }

    @Override
    public Object first() {
        return iterator().next();
    }

    public final Object getFirst() {
        return first();
    }

    public final Object getLast() {
        return last();
    }

    @Override
    public Object last() {
        return descendingIterator().next();
    }

    @Override
    @Deprecated
    public final Object pollFirst() {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final Object pollLast() {
        throw new UnsupportedOperationException();
    }

    @Deprecated
    public final Object removeFirst() {
        throw new UnsupportedOperationException();
    }

    @Deprecated
    public final Object removeLast() {
        throw new UnsupportedOperationException();
    }

    @Override
    public final java.util.SortedSet subSet(Object obj, Object obj2) {
        return subSet(obj, true, obj2, false);
    }

    @Override
    public abstract zzil iterator();

    abstract zzhl zzm(Object obj, boolean z);

    abstract zzhl zzn(Object obj, boolean z, Object obj2, boolean z2);

    abstract zzhl zzo(Object obj, boolean z);

    abstract zzhl zzp();

    @Override
    public abstract zzil descendingIterator();

    @Override
    public final java.util.SortedSet headSet(Object obj) {
        obj.getClass();
        return zzm(obj, false);
    }

    @Override
    public final java.util.SortedSet tailSet(Object obj) {
        obj.getClass();
        return zzo(obj, true);
    }

    @Override
    public Object ceiling(Object obj) {
        obj.getClass();
        return zzhm.zza(zzo(obj, true), null);
    }

    @Override
    public Object floor(Object obj) {
        obj.getClass();
        return zzhp.zza(zzm(obj, true).descendingIterator(), null);
    }

    @Override
    public Object higher(Object obj) {
        obj.getClass();
        return zzhm.zza(zzo(obj, false), null);
    }

    @Override
    public Object lower(Object obj) {
        obj.getClass();
        return zzhp.zza(zzm(obj, false).descendingIterator(), null);
    }

    @Override
    public final NavigableSet headSet(Object obj, boolean z) {
        obj.getClass();
        return zzm(obj, z);
    }

    @Override
    public final NavigableSet tailSet(Object obj, boolean z) {
        obj.getClass();
        return zzo(obj, z);
    }

    @Override
    public final zzhl subSet(Object obj, boolean z, Object obj2, boolean z2) {
        obj.getClass();
        obj2.getClass();
        if (this.zza.compare(obj, obj2) <= 0) {
            return zzn(obj, z, obj2, z2);
        }
        throw new IllegalArgumentException();
    }
}
