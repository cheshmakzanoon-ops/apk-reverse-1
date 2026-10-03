package p000j$.util.function;

import java.util.function.BiFunction;
import java.util.function.Function;
import p000j$.util.Objects;

public final class BiFunction$CC {
    public static BiFunction $default$andThen(final BiFunction biFunction, final Function function) {
        Objects.requireNonNull(function);
        return new BiFunction() {
            public BiFunction andThen(Function function2) {
                return BiFunction$CC.$default$andThen(this, function2);
            }

            @Override
            public final Object apply(Object obj, Object obj2) {
                return function.apply(biFunction.apply(obj, obj2));
            }
        };
    }
}
