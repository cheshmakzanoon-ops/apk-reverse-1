package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.internal.Ref;
import net.aihelp.data.model.p005cs.ConversationMsg;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__TransformKt$runningFold$$inlined$unsafeFlow$1<R> implements Flow<R> {
    final Object $initial$inlined;
    final Function3 $operation$inlined;
    final Flow $this_runningFold$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__TransformKt$runningFold$$inlined$unsafeFlow$1", m37f = "Transform.kt", m38i = {0, 0, 0}, m39l = {110, ConversationMsg.TYPE_ADMIN_TYPING}, m40m = "collect", m41n = {"this", "$this$runningFold_u24lambda_u249", "accumulator"}, m42s = {"L$0", "L$1", "L$2"})
    public static final class C03451 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        public C03451(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__TransformKt$runningFold$$inlined$unsafeFlow$1.this.collect(null, this);
        }
    }

    public FlowKt__TransformKt$runningFold$$inlined$unsafeFlow$1(Object obj, Flow flow, Function3 function3) {
        this.$initial$inlined = obj;
        this.$this_runningFold$inlined = flow;
        this.$operation$inlined = function3;
    }

    @Override
    public Object collect(FlowCollector<? super R> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C03451 c03451;
        FlowKt__TransformKt$runningFold$$inlined$unsafeFlow$1<R> flowKt__TransformKt$runningFold$$inlined$unsafeFlow$1;
        FlowCollector flowCollector2;
        Ref.ObjectRef objectRef;
        if (continuation instanceof C03451) {
            c03451 = (C03451) continuation;
            if ((c03451.label & Integer.MIN_VALUE) != 0) {
                c03451.label -= Integer.MIN_VALUE;
            } else {
                c03451 = new C03451(continuation);
            }
        } else {
            c03451 = new C03451(continuation);
        }
        Object obj = c03451.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03451.label;
        if (i != 0) {
            if (i == 1) {
                objectRef = (Ref.ObjectRef) c03451.L$2;
                FlowCollector flowCollector3 = (FlowCollector) c03451.L$1;
                flowKt__TransformKt$runningFold$$inlined$unsafeFlow$1 = (FlowKt__TransformKt$runningFold$$inlined$unsafeFlow$1) c03451.L$0;
                ResultKt.throwOnFailure(obj);
                flowCollector2 = flowCollector3;
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
        objectRef2.element = this.$initial$inlined;
        T t = objectRef2.element;
        c03451.L$0 = this;
        c03451.L$1 = flowCollector;
        c03451.L$2 = objectRef2;
        c03451.label = 1;
        if (flowCollector.emit(t, c03451) == coroutine_suspended) {
            return coroutine_suspended;
        }
        flowKt__TransformKt$runningFold$$inlined$unsafeFlow$1 = this;
        flowCollector2 = flowCollector;
        objectRef = objectRef2;
        Flow flow = flowKt__TransformKt$runningFold$$inlined$unsafeFlow$1.$this_runningFold$inlined;
        FlowKt__TransformKt$runningFold$1$1 flowKt__TransformKt$runningFold$1$1 = new FlowKt__TransformKt$runningFold$1$1(objectRef, flowKt__TransformKt$runningFold$$inlined$unsafeFlow$1.$operation$inlined, flowCollector2);
        c03451.L$0 = null;
        c03451.L$1 = null;
        c03451.L$2 = null;
        c03451.label = 2;
        if (flow.collect(flowKt__TransformKt$runningFold$1$1, c03451) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }
}
