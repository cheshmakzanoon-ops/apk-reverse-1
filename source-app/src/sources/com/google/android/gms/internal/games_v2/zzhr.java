package com.google.android.gms.internal.games_v2;

import java.io.Serializable;

final class zzhr extends zzht implements Serializable {
    static final zzhr zza = new zzhr();

    private zzhr() {
    }

    @Override
    public final int compare(Object obj, Object obj2) {
        Comparable comparable = (Comparable) obj;
        Comparable comparable2 = (Comparable) obj2;
        comparable.getClass();
        comparable2.getClass();
        return comparable.compareTo(comparable2);
    }

    public final String toString() {
        return "Ordering.natural()";
    }
}
