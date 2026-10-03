package p000j$.util;

import java.io.Serializable;
import java.util.Comparator;
import java.util.function.ToDoubleFunction;

public final class Comparator$$ExternalSyntheticLambda2 implements Comparator, Serializable {
    public final ToDoubleFunction f$0;

    public Comparator$$ExternalSyntheticLambda2(ToDoubleFunction toDoubleFunction) {
        this.f$0 = toDoubleFunction;
    }

    @Override
    public final int compare(Object obj, Object obj2) {
        ToDoubleFunction toDoubleFunction = this.f$0;
        return Double.compare(toDoubleFunction.applyAsDouble(obj), toDoubleFunction.applyAsDouble(obj2));
    }
}
