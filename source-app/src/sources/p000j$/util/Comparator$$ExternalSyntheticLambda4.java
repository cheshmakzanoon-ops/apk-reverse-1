package p000j$.util;

import java.io.Serializable;
import java.util.Comparator;
import java.util.function.ToLongFunction;

public final class Comparator$$ExternalSyntheticLambda4 implements Comparator, Serializable {
    public final ToLongFunction f$0;

    public Comparator$$ExternalSyntheticLambda4(ToLongFunction toLongFunction) {
        this.f$0 = toLongFunction;
    }

    @Override
    public final int compare(Object obj, Object obj2) {
        ToLongFunction toLongFunction = this.f$0;
        return Long.compare(toLongFunction.applyAsLong(obj), toLongFunction.applyAsLong(obj2));
    }
}
