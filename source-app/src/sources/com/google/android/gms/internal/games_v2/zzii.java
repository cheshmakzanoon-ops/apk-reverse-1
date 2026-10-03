package com.google.android.gms.internal.games_v2;

import java.util.Iterator;

final class zzii extends zzhk {
    final transient Object zza;

    zzii(Object obj) {
        obj.getClass();
        this.zza = obj;
    }

    @Override
    public final boolean contains(Object obj) {
        return this.zza.equals(obj);
    }

    @Override
    public final int hashCode() {
        return this.zza.hashCode();
    }

    @Override
    public final Iterator iterator() {
        return new zzho(this.zza);
    }

    @Override
    public final int size() {
        return 1;
    }

    @Override
    public final String toString() {
        String string = this.zza.toString();
        StringBuilder sb = new StringBuilder(String.valueOf(string).length() + 2);
        sb.append("[");
        sb.append(string);
        sb.append("]");
        return sb.toString();
    }

    @Override
    public final zzil iterator() {
        return new zzho(this.zza);
    }

    @Override
    final int zze(Object[] objArr, int i) {
        objArr[0] = this.zza;
        return 1;
    }
}
