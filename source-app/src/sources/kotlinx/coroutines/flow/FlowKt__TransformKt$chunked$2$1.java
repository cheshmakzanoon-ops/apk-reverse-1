package kotlinx.coroutines.flow;

import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.Ref;

@Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
final class FlowKt__TransformKt$chunked$2$1<T> implements FlowCollector {
    final Ref.ObjectRef<ArrayList<T>> $result;
    final int $size;
    final FlowCollector<List<? extends T>> $this_flow;

    FlowKt__TransformKt$chunked$2$1(Ref.ObjectRef<ArrayList<T>> objectRef, int i, FlowCollector<? super List<? extends T>> flowCollector) {
        this.$result = objectRef;
        this.$size = i;
        this.$this_flow = flowCollector;
    }

    @Override
    public final Object emit(T t, Continuation<? super Unit> continuation) throws Throwable {
        FlowKt__TransformKt$chunked$2$1$emit$1 flowKt__TransformKt$chunked$2$1$emit$1;
        ArrayList arrayList;
        FlowKt__TransformKt$chunked$2$1<T> flowKt__TransformKt$chunked$2$1;
        if (continuation instanceof FlowKt__TransformKt$chunked$2$1$emit$1) {
            flowKt__TransformKt$chunked$2$1$emit$1 = (FlowKt__TransformKt$chunked$2$1$emit$1) continuation;
            if ((flowKt__TransformKt$chunked$2$1$emit$1.label & Integer.MIN_VALUE) != 0) {
                flowKt__TransformKt$chunked$2$1$emit$1.label -= Integer.MIN_VALUE;
            } else {
                flowKt__TransformKt$chunked$2$1$emit$1 = new FlowKt__TransformKt$chunked$2$1$emit$1(this, continuation);
            }
        } else {
            flowKt__TransformKt$chunked$2$1$emit$1 = new FlowKt__TransformKt$chunked$2$1$emit$1(this, continuation);
        }
        Object obj = flowKt__TransformKt$chunked$2$1$emit$1.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = flowKt__TransformKt$chunked$2$1$emit$1.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            boolean z = (T) ((ArrayList) ((ArrayList<T>) this.$result.element));
            if (!z) {
                arrayList = z;
                T t2 = (T) new ArrayList(this.$size);
                this.$result.element = t2;
                arrayList = t2;
            }
            arrayList = z;
            arrayList.add(t);
            if (arrayList.size() == this.$size) {
                FlowCollector<List<? extends T>> flowCollector = this.$this_flow;
                flowKt__TransformKt$chunked$2$1$emit$1.L$0 = this;
                flowKt__TransformKt$chunked$2$1$emit$1.label = 1;
                if (flowCollector.emit(arrayList, flowKt__TransformKt$chunked$2$1$emit$1) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                flowKt__TransformKt$chunked$2$1 = this;
            }
            return Unit.INSTANCE;
        }
        if (i != 1) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        flowKt__TransformKt$chunked$2$1 = (FlowKt__TransformKt$chunked$2$1) flowKt__TransformKt$chunked$2$1$emit$1.L$0;
        ResultKt.throwOnFailure(obj);
        flowKt__TransformKt$chunked$2$1.$result.element = null;
        return Unit.INSTANCE;
    }
}
