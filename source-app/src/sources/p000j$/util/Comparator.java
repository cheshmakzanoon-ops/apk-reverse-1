package p000j$.util;

import java.util.Collections;
import java.util.function.Function;
import java.util.function.ToDoubleFunction;
import java.util.function.ToIntFunction;
import java.util.function.ToLongFunction;

public interface Comparator<T> {

    public abstract class EL {
        public static java.util.Comparator thenComparing(java.util.Comparator comparator, java.util.Comparator comparator2) {
            return comparator instanceof Comparator ? ((Comparator) comparator).thenComparing(comparator2) : CC.$default$thenComparing(comparator, comparator2);
        }
    }

    java.util.Comparator<T> reversed();

    java.util.Comparator<T> thenComparing(java.util.Comparator<? super T> comparator);

    <U extends Comparable<? super U>> java.util.Comparator<T> thenComparing(Function<? super T, ? extends U> function);

    <U> java.util.Comparator<T> thenComparing(Function<? super T, ? extends U> function, java.util.Comparator<? super U> comparator);

    java.util.Comparator<T> thenComparingDouble(ToDoubleFunction<? super T> toDoubleFunction);

    java.util.Comparator<T> thenComparingInt(ToIntFunction<? super T> toIntFunction);

    java.util.Comparator<T> thenComparingLong(ToLongFunction<? super T> toLongFunction);

    public final class CC {
        public static java.util.Comparator $default$thenComparing(java.util.Comparator comparator, java.util.Comparator comparator2) {
            Objects.requireNonNull(comparator2);
            return new Comparator$$ExternalSyntheticLambda1(comparator, comparator2);
        }

        public static int $private$lambda$thenComparing$36697e65$1(java.util.Comparator comparator, java.util.Comparator comparator2, Object obj, Object obj2) {
            int iCompare = comparator.compare(obj, obj2);
            return iCompare != 0 ? iCompare : comparator2.compare(obj, obj2);
        }

        public static java.util.Comparator reverseOrder() {
            return Collections.reverseOrder();
        }

        public static java.util.Comparator naturalOrder() {
            return Comparators$NaturalOrderComparator.INSTANCE;
        }

        public static <T, U> java.util.Comparator<T> comparing(Function<? super T, ? extends U> function, java.util.Comparator<? super U> comparator) {
            Objects.requireNonNull(function);
            Objects.requireNonNull(comparator);
            return new Comparator$$ExternalSyntheticLambda5(comparator, function);
        }

        public static java.util.Comparator comparing(Function function) {
            Objects.requireNonNull(function);
            return new Comparator$$ExternalSyntheticLambda3(function);
        }

        public static java.util.Comparator comparingInt(ToIntFunction toIntFunction) {
            Objects.requireNonNull(toIntFunction);
            return new Comparator$$ExternalSyntheticLambda0(toIntFunction);
        }

        public static java.util.Comparator comparingLong(ToLongFunction toLongFunction) {
            Objects.requireNonNull(toLongFunction);
            return new Comparator$$ExternalSyntheticLambda4(toLongFunction);
        }

        public static java.util.Comparator comparingDouble(ToDoubleFunction toDoubleFunction) {
            Objects.requireNonNull(toDoubleFunction);
            return new Comparator$$ExternalSyntheticLambda2(toDoubleFunction);
        }
    }
}
