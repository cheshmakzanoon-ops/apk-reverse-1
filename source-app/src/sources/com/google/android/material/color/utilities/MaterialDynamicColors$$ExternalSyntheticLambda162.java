package com.google.android.material.color.utilities;

import java.util.function.Function;

public final class MaterialDynamicColors$$ExternalSyntheticLambda162 implements Function {
    public final MaterialDynamicColors f$0;

    @Override
    public Function andThen(Function function) {
        return j$.util.function.Function.-CC.$default$andThen(this, function);
    }

    @Override
    public final Object apply(Object obj) {
        return this.f$0.highestSurface((DynamicScheme) obj);
    }

    @Override
    public Function compose(Function function) {
        return j$.util.function.Function.-CC.$default$compose(this, function);
    }
}
