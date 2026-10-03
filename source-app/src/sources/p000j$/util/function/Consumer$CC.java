package p000j$.util.function;

import java.util.function.Consumer;
import p000j$.util.Objects;

public final class Consumer$CC {
    public static Consumer $default$andThen(final Consumer consumer, final Consumer consumer2) {
        Objects.requireNonNull(consumer2);
        return new Consumer() {
            @Override
            public final void accept(Object obj) {
                Consumer$CC.$private$lambda$andThen$0(consumer, consumer2, obj);
            }

            public Consumer andThen(Consumer consumer3) {
                return Consumer$CC.$default$andThen(this, consumer3);
            }
        };
    }

    public static void $private$lambda$andThen$0(Consumer consumer, Consumer consumer2, Object obj) {
        consumer.accept(obj);
        consumer2.accept(obj);
    }
}
