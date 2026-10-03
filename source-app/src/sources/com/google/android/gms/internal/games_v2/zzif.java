package com.google.android.gms.internal.games_v2;

import java.util.Iterator;

final class zzif extends zzhk {
    static final zzif zza;
    private static final Object[] zzd;
    final transient Object[] zzb;
    final transient Object[] zzc;
    private final transient int zze;
    private final transient int zzf;
    private final transient int zzg;

    static {
        Object[] objArr = new Object[0];
        zzd = objArr;
        zza = new zzif(objArr, 0, objArr, 0, 0);
    }

    zzif(Object[] objArr, int i, Object[] objArr2, int i2, int i3) {
        this.zzb = objArr;
        this.zze = i;
        this.zzc = objArr2;
        this.zzf = i2;
        this.zzg = i3;
    }

    @Override
    public final boolean contains(Object obj) {
        if (obj != null) {
            Object[] objArr = this.zzc;
            if (objArr.length != 0) {
                int iZza = zzgv.zza(obj.hashCode());
                while (true) {
                    int i = iZza & this.zzf;
                    Object obj2 = objArr[i];
                    if (obj2 == null) {
                        return false;
                    }
                    if (obj2.equals(obj)) {
                        return true;
                    }
                    iZza = i + 1;
                }
            }
        }
        return false;
    }

    @Override
    public final int hashCode() {
        return this.zze;
    }

    @Override
    public final Iterator iterator() {
        return zzh().listIterator(0);
    }

    @Override
    public final int size() {
        return this.zzg;
    }

    @Override
    public final zzil iterator() {
        return zzh().listIterator(0);
    }

    @Override
    final Object[] zzb() {
        return this.zzb;
    }

    @Override
    final int zzc() {
        return 0;
    }

    @Override
    final int zzd() {
        return this.zzg;
    }

    @Override
    final int zze(Object[] objArr, int i) {
        Object[] objArr2 = this.zzb;
        int i2 = this.zzg;
        System.arraycopy(objArr2, 0, objArr, 0, i2);
        return i2;
    }

    @Override
    final boolean zzg() {
        return true;
    }

    @Override
    final zzhd zzi() {
        return zzhd.zzk(this.zzb, this.zzg);
    }
}
