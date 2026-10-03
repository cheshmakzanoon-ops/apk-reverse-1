package androidx.core.content;

import androidx.core.util.Predicate;

public final class IntentSanitizer$Builder$$ExternalSyntheticLambda1 implements Predicate {
    public final String f$0;

    @Override
    public Predicate and(Predicate predicate) {
        return Predicate.CC.$default$and(this, predicate);
    }

    @Override
    public Predicate negate() {
        return Predicate.CC.$default$negate(this);
    }

    @Override
    public Predicate mo76or(Predicate predicate) {
        return Predicate.CC.$default$or(this, predicate);
    }

    @Override
    public final boolean test(Object obj) {
        return this.f$0.equals((String) obj);
    }
}
