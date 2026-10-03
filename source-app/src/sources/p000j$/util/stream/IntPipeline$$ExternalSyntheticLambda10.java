package p000j$.util.stream;

import java.util.function.IntConsumer;
import p000j$.util.function.IntConsumer$CC;

public final class IntPipeline$$ExternalSyntheticLambda10 implements IntConsumer {
    public final Sink f$0;

    @Override
    public final void accept(int i) {
        this.f$0.accept(i);
    }

    public IntConsumer andThen(IntConsumer intConsumer) {
        return IntConsumer$CC.$default$andThen(this, intConsumer);
    }
}
