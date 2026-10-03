package com.google.android.gms.internal.measurement;

import java.util.ListIterator;

final class zzme implements ListIterator<String> {
    private ListIterator<String> zza;
    private final int zzb;
    private final zzmb zzc;

    @Override
    public final int nextIndex() {
        return this.zza.nextIndex();
    }

    @Override
    public final int previousIndex() {
        return this.zza.previousIndex();
    }

    @Override
    public final Object next() {
        return this.zza.next();
    }

    @Override
    public final String previous() {
        return this.zza.previous();
    }

    zzme(zzmb zzmbVar, int i) {
        this.zzc = zzmbVar;
        this.zzb = i;
        this.zza = zzmbVar.zza.listIterator(i);
    }

    @Override
    public final void add(String str) {
        throw new UnsupportedOperationException();
    }

    @Override
    public final void remove() {
        throw new UnsupportedOperationException();
    }

    @Override
    public final void set(String str) {
        throw new UnsupportedOperationException();
    }

    @Override
    public final boolean hasNext() {
        return this.zza.hasNext();
    }

    @Override
    public final boolean hasPrevious() {
        return this.zza.hasPrevious();
    }
}
