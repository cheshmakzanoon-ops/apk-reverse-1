package kotlinx.coroutines.flow;

import java.util.ArrayList;
import java.util.List;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Ref;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__TransformKt$chunked$$inlined$unsafeFlow$1<T> implements Flow<List<? extends T>> {
    final int $size$inlined;
    final Flow $this_chunked$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__TransformKt$chunked$$inlined$unsafeFlow$1", m37f = "Transform.kt", m38i = {0, 0}, m39l = {110, 120}, m40m = "collect", m41n = {"$this$chunked_u24lambda_u2413", "result"}, m42s = {"L$0", "L$1"})
    public static final class C03311 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        public C03311(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__TransformKt$chunked$$inlined$unsafeFlow$1.this.collect(null, this);
        }
    }

    public FlowKt__TransformKt$chunked$$inlined$unsafeFlow$1(Flow flow, int i) {
        this.$this_chunked$inlined = flow;
        this.$size$inlined = i;
    }

    @Override
    public Object collect(FlowCollector<? super List<? extends T>> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C03311 c03311;
        FlowCollector flowCollector2;
        Ref.ObjectRef objectRef;
        if (continuation instanceof C03311) {
            c03311 = (C03311) continuation;
            if ((c03311.label & Integer.MIN_VALUE) != 0) {
                c03311.label -= Integer.MIN_VALUE;
            } else {
                c03311 = new C03311(continuation);
            }
        } else {
            c03311 = new C03311(continuation);
        }
        Object obj = c03311.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03311.label;
        if (i != 0) {
            if (i == 1) {
                objectRef = (Ref.ObjectRef) c03311.L$1;
                flowCollector2 = (FlowCollector) c03311.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        ResultKt.throwOnFailure(obj);
        Ref.ObjectRef objectRef2 = new Ref.ObjectRef();
        Flow flow = this.$this_chunked$inlined;
        FlowKt__TransformKt$chunked$2$1 flowKt__TransformKt$chunked$2$1 = new FlowKt__TransformKt$chunked$2$1(objectRef2, this.$size$inlined, flowCollector);
        c03311.L$0 = flowCollector;
        c03311.L$1 = objectRef2;
        c03311.label = 1;
        if (flow.collect(flowKt__TransformKt$chunked$2$1, c03311) == coroutine_suspended) {
            return coroutine_suspended;
        }
        flowCollector2 = flowCollector;
        objectRef = objectRef2;
        ArrayList arrayList = (ArrayList) objectRef.element;
        if (arrayList != null) {
            c03311.L$0 = null;
            c03311.L$1 = null;
            c03311.label = 2;
            if (flowCollector2.emit(arrayList, c03311) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        return Unit.INSTANCE;
    }
}
