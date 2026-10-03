package p000j$.lang;

import java.util.Iterator;
import java.util.function.Consumer;
import p000j$.util.Objects;

public final class Iterable$CC {
    public static void $default$forEach(Iterable iterable, Consumer consumer) {
        Objects.requireNonNull(consumer);
        Iterator it = iterable.iterator();
        while (it.hasNext()) {
            consumer.accept(it.next());
        }
    }
}
