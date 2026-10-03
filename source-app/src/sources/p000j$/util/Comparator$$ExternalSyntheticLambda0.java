package p000j$.util;

import java.io.Serializable;
import java.util.Comparator;
import java.util.function.ToIntFunction;

public final class Comparator$$ExternalSyntheticLambda0 implements Comparator, Serializable {
    public final ToIntFunction f$0;

    public Comparator$$ExternalSyntheticLambda0(ToIntFunction toIntFunction) {
        this.f$0 = toIntFunction;
    }

    @Override
    public final int compare(Object obj, Object obj2) {
        ToIntFunction toIntFunction = this.f$0;
        return Integer.compare(toIntFunction.applyAsInt(obj), toIntFunction.applyAsInt(obj2));
    }
}
