package com.google.android.gms.internal.measurement;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.RandomAccess;

public final class zzjq extends zzhg<String> implements zzjp, RandomAccess {
    private static final zzjq zza;

    @Deprecated
    private static final zzjp zzb;
    private final List<Object> zzc;

    @Override
    public final int hashCode() {
        return super.hashCode();
    }

    @Override
    public final int size() {
        return this.zzc.size();
    }

    @Override
    public final zzjf zza(int i) {
        if (i < size()) {
            throw new IllegalArgumentException();
        }
        ArrayList arrayList = new ArrayList(i);
        arrayList.addAll(this.zzc);
        return new zzjq((ArrayList<Object>) arrayList);
    }

    @Override
    public final zzjp mo25h_() {
        return zzc() ? new zzmb(this) : this;
    }

    @Override
    public final Object get(int i) {
        Object obj = this.zzc.get(i);
        if (obj instanceof String) {
            return (String) obj;
        }
        if (obj instanceof zzhm) {
            zzhm zzhmVar = (zzhm) obj;
            String strZzc = zzhmVar.zzc();
            if (zzhmVar.zzd()) {
                this.zzc.set(i, strZzc);
            }
            return strZzc;
        }
        byte[] bArr = (byte[]) obj;
        String strZzb = zziz.zzb(bArr);
        if (zziz.zzc(bArr)) {
            this.zzc.set(i, strZzb);
        }
        return strZzb;
    }

    @Override
    public final Object zzb(int i) {
        return this.zzc.get(i);
    }

    @Override
    public final Object remove(int i) {
        zza();
        Object objRemove = this.zzc.remove(i);
        this.modCount++;
        return zza(objRemove);
    }

    @Override
    public final Object set(int i, Object obj) {
        zza();
        return zza(this.zzc.set(i, (String) obj));
    }

    private static String zza(Object obj) {
        if (obj instanceof String) {
            return (String) obj;
        }
        if (obj instanceof zzhm) {
            return ((zzhm) obj).zzc();
        }
        return zziz.zzb((byte[]) obj);
    }

    @Override
    public final List<?> zzb() {
        return Collections.unmodifiableList(this.zzc);
    }

    static {
        zzjq zzjqVar = new zzjq(false);
        zza = zzjqVar;
        zzb = zzjqVar;
    }

    public zzjq() {
        this(10);
    }

    public zzjq(int i) {
        this((ArrayList<Object>) new ArrayList(i));
    }

    private zzjq(ArrayList<Object> arrayList) {
        this.zzc = arrayList;
    }

    private zzjq(boolean z) {
        super(false);
        this.zzc = Collections.emptyList();
    }

    @Override
    public final void zza(zzhm zzhmVar) {
        zza();
        this.zzc.add(zzhmVar);
        this.modCount++;
    }

    @Override
    public final void add(int i, Object obj) {
        zza();
        this.zzc.add(i, (String) obj);
        this.modCount++;
    }

    @Override
    public final void clear() {
        zza();
        this.zzc.clear();
        this.modCount++;
    }

    @Override
    public final boolean add(Object obj) {
        return super.add(obj);
    }

    @Override
    public final boolean addAll(Collection<? extends String> collection) {
        return addAll(size(), collection);
    }

    @Override
    public final boolean addAll(int i, Collection<? extends String> collection) {
        zza();
        if (collection instanceof zzjp) {
            collection = ((zzjp) collection).zzb();
        }
        boolean zAddAll = this.zzc.addAll(i, collection);
        this.modCount++;
        return zAddAll;
    }

    @Override
    public final boolean equals(Object obj) {
        return super.equals(obj);
    }

    @Override
    public final boolean zzc() {
        return super.zzc();
    }

    @Override
    public final boolean remove(Object obj) {
        return super.remove(obj);
    }

    @Override
    public final boolean removeAll(Collection collection) {
        return super.removeAll(collection);
    }

    @Override
    public final boolean retainAll(Collection collection) {
        return super.retainAll(collection);
    }
}
