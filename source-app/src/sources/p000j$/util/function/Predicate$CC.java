package p000j$.util.function;

import java.util.function.Predicate;
import p000j$.util.Objects;

public abstract class Predicate$CC {
    public static Predicate $default$and(final Predicate predicate, final Predicate predicate2) {
        Objects.requireNonNull(predicate2);
        return new Predicate() {
            public Predicate and(Predicate predicate3) {
                return Predicate$CC.$default$and(this, predicate3);
            }

            public Predicate negate() {
                return Predicate$CC.$default$negate(this);
            }

            public Predicate m1727or(Predicate predicate3) {
                return Predicate$CC.$default$or(this, predicate3);
            }

            @Override
            public final boolean test(Object obj) {
                return Predicate$CC.$private$lambda$and$0(predicate, predicate2, obj);
            }
        };
    }

    public static boolean $private$lambda$and$0(Predicate predicate, Predicate predicate2, Object obj) {
        return predicate.test(obj) && predicate2.test(obj);
    }

    public static Predicate $default$negate(final Predicate predicate) {
        return new Predicate() {
            public Predicate and(Predicate predicate2) {
                return Predicate$CC.$default$and(this, predicate2);
            }

            public Predicate negate() {
                return Predicate$CC.$default$negate(this);
            }

            public Predicate m1728or(Predicate predicate2) {
                return Predicate$CC.$default$or(this, predicate2);
            }

            @Override
            public final boolean test(Object obj) {
                return Predicate$CC.$private$lambda$negate$1(predicate, obj);
            }
        };
    }

    public static boolean $private$lambda$negate$1(Predicate predicate, Object obj) {
        return !predicate.test(obj);
    }

    public static Predicate $default$or(final Predicate predicate, final Predicate predicate2) {
        Objects.requireNonNull(predicate2);
        return new Predicate() {
            public Predicate and(Predicate predicate3) {
                return Predicate$CC.$default$and(this, predicate3);
            }

            public Predicate negate() {
                return Predicate$CC.$default$negate(this);
            }

            public Predicate m1729or(Predicate predicate3) {
                return Predicate$CC.$default$or(this, predicate3);
            }

            @Override
            public final boolean test(Object obj) {
                return Predicate$CC.$private$lambda$or$2(predicate, predicate2, obj);
            }
        };
    }

    public static boolean $private$lambda$or$2(Predicate predicate, Predicate predicate2, Object obj) {
        return predicate.test(obj) || predicate2.test(obj);
    }
}
