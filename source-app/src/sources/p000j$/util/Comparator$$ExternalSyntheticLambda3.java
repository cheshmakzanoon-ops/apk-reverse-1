package p000j$.util;

import java.io.Serializable;
import java.util.Comparator;
import java.util.function.Function;

public final class Comparator$$ExternalSyntheticLambda3 implements Comparator, Serializable {
    public final Function f$0;

    public Comparator$$ExternalSyntheticLambda3(Function function) {
        this.f$0 = function;
    }

    @Override
    public final int compare(Object obj, Object obj2) {
        Function function = this.f$0;
        return ((Comparable) function.apply(obj)).compareTo(function.apply(obj2));
    }
}
