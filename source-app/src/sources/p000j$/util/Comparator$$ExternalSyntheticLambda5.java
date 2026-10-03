package p000j$.util;

import java.io.Serializable;
import java.util.Comparator;
import java.util.function.Function;

public final class Comparator$$ExternalSyntheticLambda5 implements Comparator, Serializable {
    public final Comparator f$0;
    public final Function f$1;

    public Comparator$$ExternalSyntheticLambda5(Comparator comparator, Function function) {
        this.f$0 = comparator;
        this.f$1 = function;
    }

    @Override
    public final int compare(Object obj, Object obj2) {
        Comparator comparator = this.f$0;
        Function function = this.f$1;
        return comparator.compare(function.apply(obj), function.apply(obj2));
    }
}
