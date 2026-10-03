package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.flow.internal.NullSurrogateKt;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
final class FlowKt__TransformKt$runningReduce$1$1<T> implements FlowCollector {
    final Ref.ObjectRef<Object> $accumulator;
    final Function3<T, T, Continuation<? super T>, Object> $operation;
    final FlowCollector<T> $this_flow;

    FlowKt__TransformKt$runningReduce$1$1(Ref.ObjectRef<Object> objectRef, Function3<? super T, ? super T, ? super Continuation<? super T>, ? extends Object> function3, FlowCollector<? super T> flowCollector) {
        this.$accumulator = objectRef;
        this.$operation = function3;
        this.$this_flow = flowCollector;
    }

    @Override
    public final Object emit(T t, Continuation<? super Unit> continuation) throws Throwable {
        FlowKt__TransformKt$runningReduce$1$1$emit$1 flowKt__TransformKt$runningReduce$1$1$emit$1;
        Ref.ObjectRef<Object> objectRef;
        FlowKt__TransformKt$runningReduce$1$1<T> flowKt__TransformKt$runningReduce$1$1;
        Ref.ObjectRef<Object> objectRef2;
        FlowCollector<T> flowCollector;
        T t2;
        if (continuation instanceof FlowKt__TransformKt$runningReduce$1$1$emit$1) {
            flowKt__TransformKt$runningReduce$1$1$emit$1 = (FlowKt__TransformKt$runningReduce$1$1$emit$1) continuation;
            if ((flowKt__TransformKt$runningReduce$1$1$emit$1.label & Integer.MIN_VALUE) != 0) {
                flowKt__TransformKt$runningReduce$1$1$emit$1.label -= Integer.MIN_VALUE;
            } else {
                flowKt__TransformKt$runningReduce$1$1$emit$1 = new FlowKt__TransformKt$runningReduce$1$1$emit$1(this, continuation);
            }
        } else {
            flowKt__TransformKt$runningReduce$1$1$emit$1 = new FlowKt__TransformKt$runningReduce$1$1$emit$1(this, continuation);
        }
        Object obj = flowKt__TransformKt$runningReduce$1$1$emit$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = flowKt__TransformKt$runningReduce$1$1$emit$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            objectRef = this.$accumulator;
            if (objectRef.element == NullSurrogateKt.NULL) {
                flowKt__TransformKt$runningReduce$1$1 = this;
            } else {
                Function3<T, T, Continuation<? super T>, Object> function3 = this.$operation;
                T t3 = this.$accumulator.element;
                flowKt__TransformKt$runningReduce$1$1$emit$1.L$0 = this;
                flowKt__TransformKt$runningReduce$1$1$emit$1.L$1 = objectRef;
                flowKt__TransformKt$runningReduce$1$1$emit$1.label = 1;
                Object objInvoke = function3.invoke(t3, t, flowKt__TransformKt$runningReduce$1$1$emit$1);
                if (objInvoke == coroutine_suspended) {
                    return coroutine_suspended;
                }
                flowKt__TransformKt$runningReduce$1$1 = this;
                obj = objInvoke;
                objectRef2 = objectRef;
            }
            objectRef.element = t;
            flowCollector = flowKt__TransformKt$runningReduce$1$1.$this_flow;
            t2 = flowKt__TransformKt$runningReduce$1$1.$accumulator.element;
            flowKt__TransformKt$runningReduce$1$1$emit$1.L$0 = null;
            flowKt__TransformKt$runningReduce$1$1$emit$1.L$1 = null;
            flowKt__TransformKt$runningReduce$1$1$emit$1.label = 2;
            if (flowCollector.emit(t2, flowKt__TransformKt$runningReduce$1$1$emit$1) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
        if (i == 1) {
            objectRef2 = (Ref.ObjectRef) flowKt__TransformKt$runningReduce$1$1$emit$1.L$1;
            flowKt__TransformKt$runningReduce$1$1 = (FlowKt__TransformKt$runningReduce$1$1) flowKt__TransformKt$runningReduce$1$1$emit$1.L$0;
            ResultKt.throwOnFailure(obj);
        } else {
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
        Object obj2 = obj;
        objectRef = objectRef2;
        t = (T) obj2;
        objectRef.element = t;
        flowCollector = flowKt__TransformKt$runningReduce$1$1.$this_flow;
        t2 = flowKt__TransformKt$runningReduce$1$1.$accumulator.element;
        flowKt__TransformKt$runningReduce$1$1$emit$1.L$0 = null;
        flowKt__TransformKt$runningReduce$1$1$emit$1.L$1 = null;
        flowKt__TransformKt$runningReduce$1$1$emit$1.label = 2;
        if (flowCollector.emit(t2, flowKt__TransformKt$runningReduce$1$1$emit$1) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }
}
