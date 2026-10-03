package p000j$.util.function;

import java.util.function.LongConsumer;
import p000j$.util.Objects;

public abstract class LongConsumer$CC {
    public static LongConsumer $default$andThen(final LongConsumer longConsumer, final LongConsumer longConsumer2) {
        Objects.requireNonNull(longConsumer2);
        return new LongConsumer() {
            @Override
            public final void accept(long j) {
                LongConsumer$CC.$private$lambda$andThen$0(longConsumer, longConsumer2, j);
            }

            public LongConsumer andThen(LongConsumer longConsumer3) {
                return LongConsumer$CC.$default$andThen(this, longConsumer3);
            }
        };
    }

    public static void $private$lambda$andThen$0(LongConsumer longConsumer, LongConsumer longConsumer2, long j) {
        longConsumer.accept(j);
        longConsumer2.accept(j);
    }
}
