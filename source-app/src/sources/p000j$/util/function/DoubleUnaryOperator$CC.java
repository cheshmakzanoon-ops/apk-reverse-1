package p000j$.util.function;

import java.util.function.DoubleUnaryOperator;
import p000j$.util.Objects;

public final class DoubleUnaryOperator$CC {
    public static DoubleUnaryOperator $default$compose(final DoubleUnaryOperator doubleUnaryOperator, final DoubleUnaryOperator doubleUnaryOperator2) {
        Objects.requireNonNull(doubleUnaryOperator2);
        return new DoubleUnaryOperator() {
            public DoubleUnaryOperator andThen(DoubleUnaryOperator doubleUnaryOperator3) {
                return DoubleUnaryOperator$CC.$default$andThen(this, doubleUnaryOperator3);
            }

            @Override
            public final double applyAsDouble(double d) {
                return doubleUnaryOperator.applyAsDouble(doubleUnaryOperator2.applyAsDouble(d));
            }

            public DoubleUnaryOperator compose(DoubleUnaryOperator doubleUnaryOperator3) {
                return DoubleUnaryOperator$CC.$default$compose(this, doubleUnaryOperator3);
            }
        };
    }

    public static DoubleUnaryOperator $default$andThen(final DoubleUnaryOperator doubleUnaryOperator, final DoubleUnaryOperator doubleUnaryOperator2) {
        Objects.requireNonNull(doubleUnaryOperator2);
        return new DoubleUnaryOperator() {
            public DoubleUnaryOperator andThen(DoubleUnaryOperator doubleUnaryOperator3) {
                return DoubleUnaryOperator$CC.$default$andThen(this, doubleUnaryOperator3);
            }

            @Override
            public final double applyAsDouble(double d) {
                return doubleUnaryOperator2.applyAsDouble(doubleUnaryOperator.applyAsDouble(d));
            }

            public DoubleUnaryOperator compose(DoubleUnaryOperator doubleUnaryOperator3) {
                return DoubleUnaryOperator$CC.$default$compose(this, doubleUnaryOperator3);
            }
        };
    }
}
