package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.flow.internal.AbortFlowException;

@Metadata(m17d1 = {"\u0000\u0013\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0003*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u0016\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00028\u0000H\u0096@¢\u0006\u0002\u0010\u0005¨\u0006\u0006¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/FlowKt__LimitKt$collectWhile$collector$1", "Lkotlinx/coroutines/flow/FlowCollector;", "emit", "", "value", "(Ljava/lang/Object;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1<T> implements FlowCollector<T> {
    final Function2 $predicate$inlined;
    final FlowCollector $this_flow$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1", m37f = "Limit.kt", m38i = {0, 0, 1}, m39l = {131, 132}, m40m = "emit", m41n = {"this", "value", "this"}, m42s = {"L$0", "L$1", "L$0"})
    public static final class C03011 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        public C03011(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1.this.emit(null, this);
        }
    }

    public FlowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1(Function2 function2, FlowCollector flowCollector) {
        this.$predicate$inlined = function2;
        this.$this_flow$inlined = flowCollector;
    }

    @Override
    public Object emit(T t, Continuation<? super Unit> continuation) throws Throwable {
        C03011 c03011;
        Object obj;
        Object obj2;
        FlowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1<T> flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1;
        if (continuation instanceof C03011) {
            c03011 = (C03011) continuation;
            if ((c03011.label & Integer.MIN_VALUE) != 0) {
                c03011.label -= Integer.MIN_VALUE;
            } else {
                c03011 = new C03011(continuation);
            }
        } else {
            c03011 = new C03011(continuation);
        }
        Object obj3 = c03011.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c03011.label;
        boolean z = true;
        if (i != 0) {
            if (i == 1) {
                Object obj4 = c03011.L$1;
                FlowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1<T> flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$2 = (FlowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1) c03011.L$0;
                ResultKt.throwOnFailure(obj3);
                obj2 = obj4;
                flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1 = flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$2;
                obj = obj3;
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1 = (FlowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1) c03011.L$0;
                ResultKt.throwOnFailure(obj3);
            }
            if (z) {
                return Unit.INSTANCE;
            }
            throw new AbortFlowException(flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1);
        }
        ResultKt.throwOnFailure(obj3);
        Function2 function2 = this.$predicate$inlined;
        c03011.L$0 = this;
        c03011.L$1 = t;
        c03011.label = 1;
        Object objInvoke = function2.invoke(t, c03011);
        if (objInvoke == coroutine_suspended) {
            return coroutine_suspended;
        }
        obj = objInvoke;
        obj2 = t;
        flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1 = this;
        if (((Boolean) obj).booleanValue()) {
            FlowCollector flowCollector = flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1.$this_flow$inlined;
            c03011.L$0 = flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1;
            c03011.L$1 = null;
            c03011.label = 2;
            if (flowCollector.emit(obj2, c03011) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            z = false;
        }
        if (z) {
            return Unit.INSTANCE;
        }
        throw new AbortFlowException(flowKt__LimitKt$takeWhile$lambda$6$$inlined$collectWhile$1);
    }
}
