package p000j$.util.function;

import java.util.Comparator;
import java.util.function.BiFunction;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import p000j$.util.Objects;

public abstract class BinaryOperator$CC {
    public static BinaryOperator minBy(final Comparator comparator) {
        Objects.requireNonNull(comparator);
        return new BinaryOperator() {
            public BiFunction andThen(Function function) {
                return BiFunction$CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj, Object obj2) {
                return BinaryOperator$CC.lambda$minBy$0(comparator, obj, obj2);
            }
        };
    }

    public static Object lambda$minBy$0(Comparator comparator, Object obj, Object obj2) {
        return comparator.compare(obj, obj2) <= 0 ? obj : obj2;
    }

    public static BinaryOperator maxBy(final Comparator comparator) {
        Objects.requireNonNull(comparator);
        return new BinaryOperator() {
            public BiFunction andThen(Function function) {
                return BiFunction$CC.$default$andThen(this, function);
            }

            @Override
            public final Object apply(Object obj, Object obj2) {
                return BinaryOperator$CC.lambda$maxBy$1(comparator, obj, obj2);
            }
        };
    }

    public static Object lambda$maxBy$1(Comparator comparator, Object obj, Object obj2) {
        return comparator.compare(obj, obj2) >= 0 ? obj : obj2;
    }
}
