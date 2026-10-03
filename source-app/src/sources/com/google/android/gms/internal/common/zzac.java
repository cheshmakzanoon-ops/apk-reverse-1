package com.google.android.gms.internal.common;

import j$.lang.Iterable;
import j$.util.Collection;
import j$.util.Spliterator;
import j$.util.Spliterators;
import j$.util.stream.Stream;
import java.io.Serializable;
import java.util.AbstractCollection;
import java.util.Arrays;
import java.util.function.Consumer;
import java.util.function.IntFunction;
import java.util.function.Predicate;

public abstract class zzac extends AbstractCollection implements Serializable, Collection {
    private static final Object[] zza = new Object[0];

    zzac() {
    }

    @Override
    @Deprecated
    public final boolean add(Object obj) {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final boolean addAll(java.util.Collection collection) {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final void clear() {
        throw new UnsupportedOperationException();
    }

    @Override
    public void forEach(Consumer consumer) {
        Iterable.-CC.$default$forEach(this, consumer);
    }

    @Override
    public Stream parallelStream() {
        return Collection.-CC.$default$parallelStream(this);
    }

    @Override
    public java.util.stream.Stream parallelStream() {
        return Stream.Wrapper.convert(parallelStream());
    }

    @Override
    @Deprecated
    public final boolean remove(Object obj) {
        throw new UnsupportedOperationException();
    }

    @Override
    @Deprecated
    public final boolean removeAll(java.util.Collection collection) {
        throw new UnsupportedOperationException();
    }

    @Override
    public boolean removeIf(Predicate predicate) {
        return Collection.-CC.$default$removeIf(this, predicate);
    }

    @Override
    @Deprecated
    public final boolean retainAll(java.util.Collection collection) {
        throw new UnsupportedOperationException();
    }

    @Override
    public final Spliterator spliterator() {
        return Spliterators.spliterator(this, 1296);
    }

    @Override
    public java.util.Spliterator spliterator() {
        return Spliterator.Wrapper.convert(spliterator());
    }

    @Override
    public Stream stream() {
        return Collection.-CC.$default$stream(this);
    }

    @Override
    public java.util.stream.Stream stream() {
        return Stream.Wrapper.convert(stream());
    }

    @Override
    public final Object[] toArray() {
        return toArray(zza);
    }

    @Override
    public Object[] toArray(IntFunction intFunction) {
        return Collection.-CC.$default$toArray(this, intFunction);
    }

    @Override
    public abstract zzak iterator();

    Object[] zzb() {
        return null;
    }

    int zzc() {
        throw new UnsupportedOperationException();
    }

    int zzd() {
        throw new UnsupportedOperationException();
    }

    public zzah zze() {
        throw null;
    }

    abstract boolean zzf();

    int zzg(Object[] objArr, int i) {
        throw null;
    }

    @Override
    public final Object[] toArray(Object[] objArr) {
        objArr.getClass();
        int size = size();
        int length = objArr.length;
        if (length < size) {
            Object[] objArrZzb = zzb();
            if (objArrZzb != null) {
                return Arrays.copyOfRange(objArrZzb, zzc(), zzd(), objArr.getClass());
            }
            if (length != 0) {
                objArr = Arrays.copyOf(objArr, 0);
            }
            objArr = Arrays.copyOf(objArr, size);
        } else if (length > size) {
            objArr[size] = null;
        }
        zzg(objArr, 0);
        return objArr;
    }
}
