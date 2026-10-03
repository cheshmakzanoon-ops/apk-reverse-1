package p000j$.util;

import java.util.function.Consumer;
import java.util.function.DoubleConsumer;
import p000j$.util.function.DoubleConsumer$CC;

public final class PrimitiveIterator$OfDouble$$ExternalSyntheticLambda0 implements DoubleConsumer {
    public final Consumer f$0;

    @Override
    public final void accept(double d) {
        this.f$0.accept(Double.valueOf(d));
    }

    public DoubleConsumer andThen(DoubleConsumer doubleConsumer) {
        return DoubleConsumer$CC.$default$andThen(this, doubleConsumer);
    }
}
