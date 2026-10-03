package androidx.compose.runtime;

import kotlin.Metadata;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;

@Metadata(d1 = {"\u00004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b'\u0018\u0000*\u0004\b\u0000\u0010\u00012\b\u0012\u0004\u0012\u0002H\u00010\u0002B\u0015\b\u0000\u0012\f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0004¢\u0006\u0002\u0010\u0005J\u001d\u0010\u0006\u001a\b\u0012\u0004\u0012\u00028\u00000\u00072\u0006\u0010\b\u001a\u00028\u0000H ¢\u0006\u0004\b\t\u0010\nJ\u001c\u0010\u000b\u001a\b\u0012\u0004\u0012\u00028\u00000\u00072\u0006\u0010\b\u001a\u00028\u0000H\u0086\u0004¢\u0006\u0002\u0010\nJ(\u0010\f\u001a\b\u0012\u0004\u0012\u00028\u00000\u00072\u0017\u0010\r\u001a\u0013\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00028\u00000\u000e¢\u0006\u0002\b\u0010H\u0086\u0004J\u001c\u0010\u0011\u001a\b\u0012\u0004\u0012\u00028\u00000\u00072\u0006\u0010\b\u001a\u00028\u0000H\u0086\u0004¢\u0006\u0002\u0010\nJ1\u0010\u0012\u001a\b\u0012\u0004\u0012\u00028\u00000\u00132\f\u0010\b\u001a\b\u0012\u0004\u0012\u00028\u00000\u00072\u000e\u0010\u0014\u001a\n\u0012\u0004\u0012\u00028\u0000\u0018\u00010\u0013H\u0010¢\u0006\u0002\b\u0015J\u001c\u0010\u0016\u001a\b\u0012\u0004\u0012\u00028\u00000\u00132\f\u0010\b\u001a\b\u0012\u0004\u0012\u00028\u00000\u0007H\u0002¨\u0006\u0017"}, d2 = {"Landroidx/compose/runtime/ProvidableCompositionLocal;", "T", "Landroidx/compose/runtime/CompositionLocal;", "defaultFactory", "Lkotlin/Function0;", "(Lkotlin/jvm/functions/Function0;)V", "defaultProvidedValue", "Landroidx/compose/runtime/ProvidedValue;", "value", "defaultProvidedValue$runtime_release", "(Ljava/lang/Object;)Landroidx/compose/runtime/ProvidedValue;", "provides", "providesComputed", "compute", "Lkotlin/Function1;", "Landroidx/compose/runtime/CompositionLocalAccessorScope;", "Lkotlin/ExtensionFunctionType;", "providesDefault", "updatedStateOf", "Landroidx/compose/runtime/ValueHolder;", "previous", "updatedStateOf$runtime_release", "valueHolderOf", "runtime_release"}, k = 1, mv = {1, 8, 0}, xi = 48)
public abstract class ProvidableCompositionLocal<T> extends CompositionLocal<T> {
    public static final int $stable = 0;

    public abstract ProvidedValue<T> defaultProvidedValue$runtime_release(T value);

    public ProvidableCompositionLocal(Function0<? extends T> function0) {
        super(function0, null);
    }

    public final ProvidedValue<T> provides(T value) {
        return defaultProvidedValue$runtime_release(value);
    }

    public final ProvidedValue<T> providesDefault(T value) {
        return defaultProvidedValue$runtime_release(value).ifNotAlreadyProvided$runtime_release();
    }

    public final ProvidedValue<T> providesComputed(Function1<? super CompositionLocalAccessorScope, ? extends T> compute) {
        return new ProvidedValue<>(this, null, false, null, null, compute, false);
    }

    @Override
    public ValueHolder<T> updatedStateOf$runtime_release(ProvidedValue<T> value, ValueHolder<T> previous) {
        DynamicValueHolder dynamicValueHolder = null;
        if (previous instanceof DynamicValueHolder) {
            if (value.getIsDynamic()) {
                dynamicValueHolder = (DynamicValueHolder) previous;
                dynamicValueHolder.getState().setValue(value.getEffectiveValue$runtime_release());
            }
            dynamicValueHolder = dynamicValueHolder;
        } else if (previous instanceof StaticValueHolder) {
            if (value.isStatic$runtime_release()) {
                StaticValueHolder staticValueHolder = (StaticValueHolder) previous;
                if (Intrinsics.areEqual(value.getEffectiveValue$runtime_release(), staticValueHolder.getValue())) {
                    dynamicValueHolder = staticValueHolder;
                }
            }
            dynamicValueHolder = dynamicValueHolder;
        } else if (previous instanceof ComputedValueHolder) {
            ComputedValueHolder computedValueHolder = (ComputedValueHolder) previous;
            if (value.getCompute$runtime_release() == computedValueHolder.getCompute()) {
                dynamicValueHolder = computedValueHolder;
            }
            dynamicValueHolder = dynamicValueHolder;
        }
        return dynamicValueHolder == null ? valueHolderOf(value) : dynamicValueHolder;
    }

    private final ValueHolder<T> valueHolderOf(ProvidedValue<T> value) {
        if (value.getIsDynamic()) {
            MutableState<T> state$runtime_release = value.getState$runtime_release();
            if (state$runtime_release == null) {
                T value2 = value.getValue();
                SnapshotMutationPolicy<T> mutationPolicy$runtime_release = value.getMutationPolicy$runtime_release();
                if (mutationPolicy$runtime_release == null) {
                    mutationPolicy$runtime_release = SnapshotStateKt.structuralEqualityPolicy();
                }
                state$runtime_release = SnapshotStateKt.mutableStateOf(value2, mutationPolicy$runtime_release);
            }
            return new DynamicValueHolder(state$runtime_release);
        }
        if (value.getCompute$runtime_release() != null) {
            return new ComputedValueHolder(value.getCompute$runtime_release());
        }
        return value.getState$runtime_release() != null ? new DynamicValueHolder(value.getState$runtime_release()) : new StaticValueHolder(value.getEffectiveValue$runtime_release());
    }
}
