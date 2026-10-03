package p000j$.util.function;

import java.util.function.BiConsumer;
import p000j$.util.Objects;

public final class BiConsumer$CC {
    public static BiConsumer $default$andThen(final BiConsumer biConsumer, final BiConsumer biConsumer2) {
        Objects.requireNonNull(biConsumer2);
        return new BiConsumer() {
            @Override
            public final void accept(Object obj, Object obj2) {
                BiConsumer$CC.$private$lambda$andThen$0(biConsumer, biConsumer2, obj, obj2);
            }

            public BiConsumer andThen(BiConsumer biConsumer3) {
                return BiConsumer$CC.$default$andThen(this, biConsumer3);
            }
        };
    }

    public static void $private$lambda$andThen$0(BiConsumer biConsumer, BiConsumer biConsumer2, Object obj, Object obj2) {
        biConsumer.accept(obj, obj2);
        biConsumer2.accept(obj, obj2);
    }
}
