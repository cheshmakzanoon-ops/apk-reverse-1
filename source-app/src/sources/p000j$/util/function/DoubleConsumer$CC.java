package p000j$.util.function;

import java.util.function.DoubleConsumer;
import p000j$.util.Objects;

public abstract class DoubleConsumer$CC {
    public static DoubleConsumer $default$andThen(final DoubleConsumer doubleConsumer, final DoubleConsumer doubleConsumer2) {
        Objects.requireNonNull(doubleConsumer2);
        return new DoubleConsumer() {
            @Override
            public final void accept(double d) {
                DoubleConsumer$CC.$private$lambda$andThen$0(doubleConsumer, doubleConsumer2, d);
            }

            public DoubleConsumer andThen(DoubleConsumer doubleConsumer3) {
                return DoubleConsumer$CC.$default$andThen(this, doubleConsumer3);
            }
        };
    }

    public static void $private$lambda$andThen$0(DoubleConsumer doubleConsumer, DoubleConsumer doubleConsumer2, double d) {
        doubleConsumer.accept(d);
        doubleConsumer2.accept(d);
    }
}
