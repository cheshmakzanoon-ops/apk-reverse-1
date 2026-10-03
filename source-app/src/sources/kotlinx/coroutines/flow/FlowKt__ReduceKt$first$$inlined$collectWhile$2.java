package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.flow.internal.AbortFlowException;

@Metadata(m17d1 = {"\u0000\u0013\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u0016\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00028\u0000H\u0096@¢\u0006\u0002\u0010\u0005¨\u0006\u0006¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/FlowKt__LimitKt$collectWhile$collector$1", "Lkotlinx/coroutines/flow/FlowCollector;", "emit", "", "value", "(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__ReduceKt$first$$inlined$collectWhile$2<T> implements FlowCollector<T> {
    final Function2 $predicate$inlined;
    final Ref.ObjectRef $result$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ReduceKt$first$$inlined$collectWhile$2", m37f = "Reduce.kt", m38i = {0, 0}, m39l = {131}, m40m = "emit", m41n = {"this", "it"}, m42s = {"L$0", "L$1"})
    public static final class C03111 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        public C03111(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__ReduceKt$first$$inlined$collectWhile$2.this.emit(null, this);
        }
    }

    public FlowKt__ReduceKt$first$$inlined$collectWhile$2(Function2 function2, Ref.ObjectRef objectRef) {
        this.$predicate$inlined = function2;
        this.$result$inlined = objectRef;
    }

    @Override
    public Object emit(T t, Continuation<? super Unit> continuation) throws Throwable {
        C03111 c03111;
        FlowKt__ReduceKt$first$$inlined$collectWhile$2<T> flowKt__ReduceKt$first$$inlined$collectWhile$2;
        if (continuation instanceof C03111) {
            c03111 = (C03111) continuation;
            if ((c03111.label & Integer.MIN_VALUE) != 0) {
                c03111.label -= Integer.MIN_VALUE;
            } else {
                c03111 = new C03111(continuation);
            }
        } else {
            c03111 = new C03111(continuation);
        }
        Object objInvoke = c03111.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03111.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objInvoke);
            Function2 function2 = this.$predicate$inlined;
            c03111.L$0 = this;
            c03111.L$1 = t;
            c03111.label = 1;
            objInvoke = function2.invoke(t, c03111);
            if (objInvoke == coroutine_suspended) {
                return coroutine_suspended;
            }
            flowKt__ReduceKt$first$$inlined$collectWhile$2 = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            t = (T) c03111.L$1;
            flowKt__ReduceKt$first$$inlined$collectWhile$2 = (FlowKt__ReduceKt$first$$inlined$collectWhile$2) c03111.L$0;
            ResultKt.throwOnFailure(objInvoke);
        }
        if (!((Boolean) objInvoke).booleanValue()) {
            return Unit.INSTANCE;
        }
        flowKt__ReduceKt$first$$inlined$collectWhile$2.$result$inlined.element = t;
        throw new AbortFlowException(flowKt__ReduceKt$first$$inlined$collectWhile$2);
    }
}
