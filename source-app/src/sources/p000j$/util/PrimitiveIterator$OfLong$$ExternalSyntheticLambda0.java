package p000j$.util;

import java.util.function.Consumer;
import java.util.function.LongConsumer;
import p000j$.util.function.LongConsumer$CC;

public final class PrimitiveIterator$OfLong$$ExternalSyntheticLambda0 implements LongConsumer {
    public final Consumer f$0;

    @Override
    public final void accept(long j) {
        this.f$0.accept(Long.valueOf(j));
    }

    public LongConsumer andThen(LongConsumer longConsumer) {
        return LongConsumer$CC.$default$andThen(this, longConsumer);
    }
}
