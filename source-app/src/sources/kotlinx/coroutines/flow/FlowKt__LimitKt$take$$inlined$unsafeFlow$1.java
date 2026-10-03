package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Ref;
import kotlinx.coroutines.flow.internal.AbortFlowException;
import kotlinx.coroutines.flow.internal.FlowExceptions_commonKt;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__LimitKt$take$$inlined$unsafeFlow$1<T> implements Flow<T> {
    final int $count$inlined;
    final Flow $this_take$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__LimitKt$take$$inlined$unsafeFlow$1", m37f = "Limit.kt", m38i = {0}, m39l = {112}, m40m = "collect", m41n = {"ownershipMarker"}, m42s = {"L$0"})
    public static final class C02991 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        public C02991(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__LimitKt$take$$inlined$unsafeFlow$1.this.collect(null, this);
        }
    }

    public FlowKt__LimitKt$take$$inlined$unsafeFlow$1(Flow flow, int i) {
        this.$this_take$inlined = flow;
        this.$count$inlined = i;
    }

    @Override
    public Object collect(FlowCollector<? super T> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C02991 c02991;
        AbortFlowException e;
        Object obj;
        if (continuation instanceof C02991) {
            c02991 = (C02991) continuation;
            if ((c02991.label & Integer.MIN_VALUE) != 0) {
                c02991.label -= Integer.MIN_VALUE;
            } else {
                c02991 = new C02991(continuation);
            }
        } else {
            c02991 = new C02991(continuation);
        }
        Object obj2 = c02991.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02991.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj2);
            Object obj3 = new Object();
            Ref.IntRef intRef = new Ref.IntRef();
            try {
                Flow flow = this.$this_take$inlined;
                FlowKt__LimitKt$take$2$1 flowKt__LimitKt$take$2$1 = new FlowKt__LimitKt$take$2$1(intRef, this.$count$inlined, flowCollector, obj3);
                c02991.L$0 = obj3;
                c02991.label = 1;
                if (flow.collect(flowKt__LimitKt$take$2$1, c02991) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (AbortFlowException e2) {
                e = e2;
                obj = obj3;
                FlowExceptions_commonKt.checkOwnership(e, obj);
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            obj = c02991.L$0;
            try {
                ResultKt.throwOnFailure(obj2);
            } catch (AbortFlowException e3) {
                e = e3;
                FlowExceptions_commonKt.checkOwnership(e, obj);
            }
        }
        return Unit.INSTANCE;
    }
}
