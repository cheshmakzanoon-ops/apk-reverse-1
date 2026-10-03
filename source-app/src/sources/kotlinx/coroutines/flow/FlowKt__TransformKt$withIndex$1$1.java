package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.IndexedValue;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.Ref;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
final class FlowKt__TransformKt$withIndex$1$1<T> implements FlowCollector {
    final Ref.IntRef $index;
    final FlowCollector<IndexedValue<? extends T>> $this_flow;

    FlowKt__TransformKt$withIndex$1$1(FlowCollector<? super IndexedValue<? extends T>> flowCollector, Ref.IntRef intRef) {
        this.$this_flow = flowCollector;
        this.$index = intRef;
    }

    @Override
    public final Object emit(T t, Continuation<? super Unit> continuation) throws Throwable {
        FlowKt__TransformKt$withIndex$1$1$emit$1 flowKt__TransformKt$withIndex$1$1$emit$1;
        if (continuation instanceof FlowKt__TransformKt$withIndex$1$1$emit$1) {
            flowKt__TransformKt$withIndex$1$1$emit$1 = (FlowKt__TransformKt$withIndex$1$1$emit$1) continuation;
            if ((flowKt__TransformKt$withIndex$1$1$emit$1.label & Integer.MIN_VALUE) != 0) {
                flowKt__TransformKt$withIndex$1$1$emit$1.label -= Integer.MIN_VALUE;
            } else {
                flowKt__TransformKt$withIndex$1$1$emit$1 = new FlowKt__TransformKt$withIndex$1$1$emit$1(this, continuation);
            }
        } else {
            flowKt__TransformKt$withIndex$1$1$emit$1 = new FlowKt__TransformKt$withIndex$1$1$emit$1(this, continuation);
        }
        Object obj = flowKt__TransformKt$withIndex$1$1$emit$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = flowKt__TransformKt$withIndex$1$1$emit$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            FlowCollector<IndexedValue<? extends T>> flowCollector = this.$this_flow;
            int i2 = this.$index.element;
            this.$index.element = i2 + 1;
            if (i2 < 0) {
                throw new ArithmeticException("Index overflow has happened");
            }
            IndexedValue<? extends T> indexedValue = new IndexedValue<>(i2, t);
            flowKt__TransformKt$withIndex$1$1$emit$1.label = 1;
            if (flowCollector.emit(indexedValue, flowKt__TransformKt$withIndex$1$1$emit$1) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }
}
