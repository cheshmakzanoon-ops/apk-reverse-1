package p000j$.util;

import java.util.function.Consumer;
import java.util.function.IntConsumer;
import p000j$.util.function.IntConsumer$CC;

public final class PrimitiveIterator$OfInt$$ExternalSyntheticLambda0 implements IntConsumer {
    public final Consumer f$0;

    @Override
    public final void accept(int i) {
        this.f$0.accept(Integer.valueOf(i));
    }

    public IntConsumer andThen(IntConsumer intConsumer) {
        return IntConsumer$CC.$default$andThen(this, intConsumer);
    }
}
