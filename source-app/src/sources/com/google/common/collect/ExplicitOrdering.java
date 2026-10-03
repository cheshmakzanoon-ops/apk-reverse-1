package com.google.common.collect;

import java.io.Serializable;
import java.util.List;
import javax.annotation.CheckForNull;

@ElementTypesAreNonnullByDefault
final class ExplicitOrdering<T> extends Ordering<T> implements Serializable {
    private static final long serialVersionUID = 0;
    final ImmutableMap<T, Integer> rankMap;

    ExplicitOrdering(List<T> list) {
        this(Maps.indexMap(list));
    }

    ExplicitOrdering(ImmutableMap<T, Integer> immutableMap) {
        this.rankMap = immutableMap;
    }

    @Override
    public int compare(T t, T t2) {
        return rank(t) - rank(t2);
    }

    private int rank(T t) {
        Integer num = this.rankMap.get(t);
        if (num == null) {
            throw new Ordering.IncomparableValueException(t);
        }
        return num.intValue();
    }

    @Override
    public boolean equals(@CheckForNull Object obj) {
        if (obj instanceof ExplicitOrdering) {
            return this.rankMap.equals(((ExplicitOrdering) obj).rankMap);
        }
        return false;
    }

    public int hashCode() {
        return this.rankMap.hashCode();
    }

    public String toString() {
        String strValueOf = String.valueOf(this.rankMap.keySet());
        StringBuilder sb = new StringBuilder(String.valueOf(strValueOf).length() + 19);
        sb.append("Ordering.explicit(");
        sb.append(strValueOf);
        sb.append(")");
        return sb.toString();
    }
}
