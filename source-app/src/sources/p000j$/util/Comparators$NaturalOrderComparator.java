package p000j$.util;

import java.util.Comparator;
import java.util.function.Function;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;

enum Comparators$NaturalOrderComparator implements Comparator, Comparator {
    INSTANCE;

    @Override
    public Comparator thenComparing(Comparator comparator) {
        return Comparator.CC.$default$thenComparing(this, comparator);
    }

    @Override
    public Comparator thenComparing(Function function) {
        return Comparator.EL.thenComparing(this, Comparator.CC.comparing(function));
    }

    @Override
    public Comparator thenComparing(Function function, Comparator comparator) {
        return Comparator.EL.thenComparing(this, Comparator.CC.comparing(function, comparator));
    }

    @Override
    public Comparator thenComparingDouble(ToDoubleFunction toDoubleFunction) {
        return Comparator.EL.thenComparing(this, Comparator.CC.comparingDouble(toDoubleFunction));
    }

    @Override
    public Comparator thenComparingInt(ToIntFunction toIntFunction) {
        return Comparator.EL.thenComparing(this, Comparator.CC.comparingInt(toIntFunction));
    }

    @Override
    public Comparator thenComparingLong(ToLongFunction toLongFunction) {
        return Comparator.EL.thenComparing(this, Comparator.CC.comparingLong(toLongFunction));
    }

    @Override
    public int compare(Comparable comparable, Comparable comparable2) {
        return comparable.compareTo(comparable2);
    }

    @Override
    public Comparator reversed() {
        return Comparator.CC.reverseOrder();
    }
}
