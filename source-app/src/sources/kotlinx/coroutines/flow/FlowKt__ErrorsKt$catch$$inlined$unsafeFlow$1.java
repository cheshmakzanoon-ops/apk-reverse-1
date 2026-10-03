package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function3;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__ErrorsKt$catch$$inlined$unsafeFlow$1<T> implements Flow<T> {
    final Function3 $action$inlined;
    final Flow $this_catch$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__ErrorsKt$catch$$inlined$unsafeFlow$1", m37f = "Errors.kt", m38i = {0, 0}, m39l = {109, 110}, m40m = "collect", m41n = {"this", "$this$catch_u24lambda_u240"}, m42s = {"L$0", "L$1"})
    public static final class C02921 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        public C02921(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__ErrorsKt$catch$$inlined$unsafeFlow$1.this.collect(null, this);
        }
    }

    public FlowKt__ErrorsKt$catch$$inlined$unsafeFlow$1(Flow flow, Function3 function3) {
        this.$this_catch$inlined = flow;
        this.$action$inlined = function3;
    }

    @Override
    public Object collect(FlowCollector<? super T> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C02921 c02921;
        FlowKt__ErrorsKt$catch$$inlined$unsafeFlow$1<T> flowKt__ErrorsKt$catch$$inlined$unsafeFlow$1;
        if (continuation instanceof C02921) {
            c02921 = (C02921) continuation;
            if ((c02921.label & Integer.MIN_VALUE) != 0) {
                c02921.label -= Integer.MIN_VALUE;
            } else {
                c02921 = new C02921(continuation);
            }
        } else {
            c02921 = new C02921(continuation);
        }
        Object objCatchImpl = c02921.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02921.label;
        if (i != 0) {
            if (i == 1) {
                flowCollector = (FlowCollector) c02921.L$1;
                flowKt__ErrorsKt$catch$$inlined$unsafeFlow$1 = (FlowKt__ErrorsKt$catch$$inlined$unsafeFlow$1) c02921.L$0;
                ResultKt.throwOnFailure(objCatchImpl);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objCatchImpl);
            }
            return Unit.INSTANCE;
        }
        ResultKt.throwOnFailure(objCatchImpl);
        Flow flow = this.$this_catch$inlined;
        c02921.L$0 = this;
        c02921.L$1 = flowCollector;
        c02921.label = 1;
        objCatchImpl = FlowKt.catchImpl(flow, flowCollector, c02921);
        if (objCatchImpl == coroutine_suspended) {
            return coroutine_suspended;
        }
        flowKt__ErrorsKt$catch$$inlined$unsafeFlow$1 = this;
        Throwable th = (Throwable) objCatchImpl;
        if (th != null) {
            Function3 function3 = flowKt__ErrorsKt$catch$$inlined$unsafeFlow$1.$action$inlined;
            c02921.L$0 = null;
            c02921.L$1 = null;
            c02921.label = 2;
            if (function3.invoke(flowCollector, th, c02921) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        return Unit.INSTANCE;
    }
}
