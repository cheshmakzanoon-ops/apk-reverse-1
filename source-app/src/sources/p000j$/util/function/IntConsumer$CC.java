package p000j$.util.function;

import java.util.function.IntConsumer;
import p000j$.util.Objects;

public abstract class IntConsumer$CC {
    public static IntConsumer $default$andThen(final IntConsumer intConsumer, final IntConsumer intConsumer2) {
        Objects.requireNonNull(intConsumer2);
        return new IntConsumer() {
            @Override
            public final void accept(int i) {
                IntConsumer$CC.$private$lambda$andThen$0(intConsumer, intConsumer2, i);
            }

            public IntConsumer andThen(IntConsumer intConsumer3) {
                return IntConsumer$CC.$default$andThen(this, intConsumer3);
            }
        };
    }

    public static void $private$lambda$andThen$0(IntConsumer intConsumer, IntConsumer intConsumer2, int i) {
        intConsumer.accept(i);
        intConsumer2.accept(i);
    }
}
