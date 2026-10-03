package com.google.android.gms.internal.games_v2;

import java.util.Comparator;
import java.util.SortedSet;

final class zzik {
    public static boolean zza(Comparator comparator, Iterable iterable) {
        Comparator comparator2;
        comparator.getClass();
        iterable.getClass();
        if (iterable instanceof SortedSet) {
            comparator2 = ((SortedSet) iterable).comparator();
            if (comparator2 == null) {
                comparator2 = zzhr.zza;
            }
        } else {
            if (!(iterable instanceof zzij)) {
                return false;
            }
            comparator2 = ((zzij) iterable).comparator();
        }
        return comparator.equals(comparator2);
    }
}
