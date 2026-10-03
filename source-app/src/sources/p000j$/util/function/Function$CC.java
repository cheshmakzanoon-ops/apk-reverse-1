package p000j$.util.function;

import java.util.function.Function;
import p000j$.util.Objects;

public final class Function$CC {
    public static Function $default$compose(final Function function, final Function function2) {
        Objects.requireNonNull(function2);
        return new Function() {
            public Function andThen(Function function3) {
                return Function$CC.$default$andThen(this, function3);
            }

            @Override
            public final Object apply(Object obj) {
                return function.apply(function2.apply(obj));
            }

            public Function compose(Function function3) {
                return Function$CC.$default$compose(this, function3);
            }
        };
    }

    public static Function $default$andThen(final Function function, final Function function2) {
        Objects.requireNonNull(function2);
        return new Function() {
            public Function andThen(Function function3) {
                return Function$CC.$default$andThen(this, function3);
            }

            @Override
            public final Object apply(Object obj) {
                return function2.apply(function.apply(obj));
            }

            public Function compose(Function function3) {
                return Function$CC.$default$compose(this, function3);
            }
        };
    }
}
