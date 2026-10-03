package androidx.compose.runtime;

import kotlin.KotlinNothingValueException;
import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;

@Metadata(d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B\u001e\u0012\u0017\u0010\u0003\u001a\u0013\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00028\u00000\u0004¢\u0006\u0002\b\u0006¢\u0006\u0002\u0010\u0007J\u001d\u0010\f\u001a\b\u0012\u0004\u0012\u00028\u00000\r2\u0006\u0010\u000e\u001a\u00028\u0000H\u0010¢\u0006\u0004\b\u000f\u0010\u0010R\u001a\u0010\b\u001a\b\u0012\u0004\u0012\u00028\u00000\tX\u0090\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0011"}, d2 = {"Landroidx/compose/runtime/ComputedProvidableCompositionLocal;", "T", "Landroidx/compose/runtime/ProvidableCompositionLocal;", "defaultComputation", "Lkotlin/Function1;", "Landroidx/compose/runtime/CompositionLocalAccessorScope;", "Lkotlin/ExtensionFunctionType;", "(Lkotlin/jvm/functions/Function1;)V", "defaultValueHolder", "Landroidx/compose/runtime/ComputedValueHolder;", "getDefaultValueHolder$runtime_release", "()Landroidx/compose/runtime/ComputedValueHolder;", "defaultProvidedValue", "Landroidx/compose/runtime/ProvidedValue;", "value", "defaultProvidedValue$runtime_release", "(Ljava/lang/Object;)Landroidx/compose/runtime/ProvidedValue;", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public final class ComputedProvidableCompositionLocal<T> extends ProvidableCompositionLocal<T> {
    public static final int $stable = 0;
    private final ComputedValueHolder<T> defaultValueHolder;

    public ComputedProvidableCompositionLocal(Function1<? super CompositionLocalAccessorScope, ? extends T> function1) {
        super(new Function0<T>() {
            public final T invoke() throws KotlinNothingValueException {
                ComposerKt.composeRuntimeError("Unexpected call to default provider");
                throw new KotlinNothingValueException();
            }
        });
        this.defaultValueHolder = new ComputedValueHolder<>(function1);
    }

    @Override
    public ComputedValueHolder<T> getDefaultValueHolder$runtime_release() {
        return this.defaultValueHolder;
    }

    @Override
    public ProvidedValue<T> defaultProvidedValue$runtime_release(T value) {
        return new ProvidedValue<>(this, value, value == null, null, null, null, true);
    }
}
