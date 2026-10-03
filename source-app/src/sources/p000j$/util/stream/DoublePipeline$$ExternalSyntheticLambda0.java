package p000j$.util.stream;

import java.util.function.DoubleConsumer;
import p000j$.util.function.DoubleConsumer$CC;

public final class DoublePipeline$$ExternalSyntheticLambda0 implements DoubleConsumer {
    public final Sink f$0;

    @Override
    public final void accept(double d) {
        this.f$0.accept(d);
    }

    public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
        return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
    }
}
