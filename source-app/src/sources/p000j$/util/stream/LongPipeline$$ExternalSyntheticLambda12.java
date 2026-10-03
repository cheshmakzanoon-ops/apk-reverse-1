package p000j$.util.stream;

import java.util.function.LongConsumer;
import p000j$.util.function.LongConsumer$CC;

public final class LongPipeline$$ExternalSyntheticLambda12 implements LongConsumer {
    public final Sink f$0;

    @Override
    public final void accept(long j) {
        this.f$0.accept(j);
    }

    public LongConsumer andThen(LongConsumer longConsumer) {
        return LongConsumer$CC.$default$andThen(this, longConsumer);
    }
}
