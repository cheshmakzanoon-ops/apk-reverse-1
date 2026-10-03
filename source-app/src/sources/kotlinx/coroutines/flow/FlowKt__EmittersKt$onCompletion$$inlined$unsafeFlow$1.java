package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function3;
import kotlinx.coroutines.flow.internal.SafeCollector;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1<T> implements Flow<T> {
    final Function3 $action$inlined;
    final Flow $this_onCompletion$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1", m37f = "Emitters.kt", m38i = {0, 0, 1, 2}, m39l = {110, 117, 124}, m40m = "collect", m41n = {"this", "$this$onCompletion_u24lambda_u242", "e", "sc"}, m42s = {"L$0", "L$1", "L$0", "L$0"})
    public static final class C02871 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        public C02871(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1.this.collect(null, this);
        }
    }

    public FlowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1(Flow flow, Function3 function3) {
        this.$this_onCompletion$inlined = flow;
        this.$action$inlined = function3;
    }

    @Override
    public Object collect(FlowCollector<? super T> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C02871 c02871;
        FlowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1<T> flowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1;
        ThrowingCollector throwingCollector;
        Function3 function3;
        SafeCollector safeCollector;
        Throwable th;
        SafeCollector safeCollector2;
        Function3 function4;
        if (continuation instanceof C02871) {
            c02871 = (C02871) continuation;
            if ((c02871.label & Integer.MIN_VALUE) != 0) {
                c02871.label -= Integer.MIN_VALUE;
            } else {
                c02871 = new C02871(continuation);
            }
        } else {
            c02871 = new C02871(continuation);
        }
        Object obj = c02871.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02871.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            try {
                Flow flow = this.$this_onCompletion$inlined;
                c02871.L$0 = this;
                c02871.L$1 = flowCollector;
                c02871.label = 1;
                if (flow.collect(flowCollector, c02871) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                flowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1 = this;
                safeCollector = new SafeCollector(flowCollector, c02871.getContext());
                function4 = flowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1.$action$inlined;
                c02871.L$0 = safeCollector;
                c02871.L$1 = null;
                c02871.label = 3;
                if (function4.invoke(safeCollector, null, c02871) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                safeCollector2 = safeCollector;
                safeCollector2.releaseIntercepted();
                return Unit.INSTANCE;
            } catch (Throwable th2) {
                th = th2;
                flowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1 = this;
                throwingCollector = new ThrowingCollector(th);
                function3 = flowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1.$action$inlined;
                c02871.L$0 = th;
                c02871.L$1 = null;
                c02871.label = 2;
                if (FlowKt__EmittersKt.invokeSafely$FlowKt__EmittersKt(throwingCollector, function3, th, c02871) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                throw th;
            }
        }
        if (i != 1) {
            if (i == 2) {
                Throwable th3 = (Throwable) c02871.L$0;
                ResultKt.throwOnFailure(obj);
                throw th3;
            }
            if (i != 3) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            safeCollector2 = (SafeCollector) c02871.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                safeCollector2.releaseIntercepted();
                return Unit.INSTANCE;
            } catch (Throwable th4) {
                th = th4;
                safeCollector2.releaseIntercepted();
                throw th;
            }
        }
        flowCollector = (FlowCollector) c02871.L$1;
        flowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1 = (FlowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1) c02871.L$0;
        try {
            ResultKt.throwOnFailure(obj);
            safeCollector = new SafeCollector(flowCollector, c02871.getContext());
            try {
                function4 = flowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1.$action$inlined;
                c02871.L$0 = safeCollector;
                c02871.L$1 = null;
                c02871.label = 3;
                if (function4.invoke(safeCollector, null, c02871) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                safeCollector2 = safeCollector;
                safeCollector2.releaseIntercepted();
                return Unit.INSTANCE;
            } catch (Throwable th5) {
                th = th5;
                safeCollector2 = safeCollector;
                safeCollector2.releaseIntercepted();
                throw th;
            }
        } catch (Throwable th6) {
            th = th6;
            throwingCollector = new ThrowingCollector(th);
            function3 = flowKt__EmittersKt$onCompletion$$inlined$unsafeFlow$1.$action$inlined;
            c02871.L$0 = th;
            c02871.L$1 = null;
            c02871.label = 2;
            if (FlowKt__EmittersKt.invokeSafely$FlowKt__EmittersKt(throwingCollector, function3, th, c02871) == coroutine_suspended) {
                return coroutine_suspended;
            }
            throw th;
        }
    }
}
