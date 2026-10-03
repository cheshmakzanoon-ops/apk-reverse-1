package p000j$.util;

import java.io.Serializable;
import java.util.Comparator;

public final class Comparator$$ExternalSyntheticLambda1 implements Comparator, Serializable {
    public final Comparator f$0;
    public final Comparator f$1;

    public Comparator$$ExternalSyntheticLambda1(Comparator comparator, Comparator comparator2) {
        this.f$0 = comparator;
        this.f$1 = comparator2;
    }

    @Override
    public final int compare(Object obj, Object obj2) {
        return Comparator.CC.$private$lambda$thenComparing$36697e65$1(this.f$0, this.f$1, obj, obj2);
    }
}
