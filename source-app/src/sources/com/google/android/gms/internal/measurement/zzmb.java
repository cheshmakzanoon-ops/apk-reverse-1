package com.google.android.gms.internal.measurement;

import java.util.AbstractList;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.RandomAccess;

@Deprecated
public final class zzmb extends AbstractList<String> implements zzjp, RandomAccess {
    private final zzjp zza;

    @Override
    public final zzjp mo25h_() {
        return this;
    }

    @Override
    public final int size() {
        return this.zza.size();
    }

    @Override
    public final Object get(int i) {
        return (String) this.zza.get(i);
    }

    @Override
    public final Object zzb(int i) {
        return this.zza.zzb(i);
    }

    @Override
    public final Iterator<String> iterator() {
        return new zzmd(this);
    }

    @Override
    public final List<?> zzb() {
        return this.zza.zzb();
    }

    @Override
    public final ListIterator<String> listIterator(int i) {
        return new zzme(this, i);
    }

    public zzmb(zzjp zzjpVar) {
        this.zza = zzjpVar;
    }

    @Override
    public final void zza(zzhm zzhmVar) {
        throw new UnsupportedOperationException();
    }
}
