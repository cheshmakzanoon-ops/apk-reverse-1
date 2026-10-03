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
import kotlinx.coroutines.flow.internal.SafeCollector;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1<T> implements Flow<T> {
    final Function2 $action$inlined;
    final Flow $this_onEmpty$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1", m37f = "Emitters.kt", m38i = {0, 0, 0, 1}, m39l = {110, 118}, m40m = "collect", m41n = {"this", "$this$onEmpty_u24lambda_u243", "isEmpty", "collector"}, m42s = {"L$0", "L$1", "L$2", "L$0"})
    public static final class C02881 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        public C02881(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1.this.collect(null, this);
        }
    }

    public FlowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1(Flow flow, Function2 function2) {
        this.$this_onEmpty$inlined = flow;
        this.$action$inlined = function2;
    }

    @Override
    public Object collect(FlowCollector<? super T> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C02881 c02881;
        FlowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1<T> flowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1;
        ?? r2;
        Ref.BooleanRef booleanRef;
        if (continuation instanceof C02881) {
            c02881 = (C02881) continuation;
            if ((c02881.label & Integer.MIN_VALUE) != 0) {
                c02881.label -= Integer.MIN_VALUE;
            } else {
                c02881 = new C02881(continuation);
            }
        } else {
            c02881 = new C02881(continuation);
        }
        Object obj = c02881.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02881.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    booleanRef = (Ref.BooleanRef) c02881.L$2;
                    FlowCollector flowCollector2 = (FlowCollector) c02881.L$1;
                    flowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1 = (FlowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1) c02881.L$0;
                    ResultKt.throwOnFailure(obj);
                    r2 = flowCollector2;
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    SafeCollector safeCollector = (SafeCollector) c02881.L$0;
                    ResultKt.throwOnFailure(obj);
                    flowCollector = safeCollector;
                }
                ((SafeCollector) flowCollector).releaseIntercepted();
                return Unit.INSTANCE;
            }
            ResultKt.throwOnFailure(obj);
            Ref.BooleanRef booleanRef2 = new Ref.BooleanRef();
            booleanRef2.element = true;
            Flow flow = this.$this_onEmpty$inlined;
            FlowKt__EmittersKt$onEmpty$1$1 flowKt__EmittersKt$onEmpty$1$1 = new FlowKt__EmittersKt$onEmpty$1$1(booleanRef2, flowCollector);
            c02881.L$0 = this;
            c02881.L$1 = flowCollector;
            c02881.L$2 = booleanRef2;
            c02881.label = 1;
            if (flow.collect(flowKt__EmittersKt$onEmpty$1$1, c02881) == coroutine_suspended) {
                return coroutine_suspended;
            }
            flowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1 = this;
            r2 = flowCollector;
            booleanRef = booleanRef2;
            if (booleanRef.element) {
                SafeCollector safeCollector2 = new SafeCollector(r2, c02881.getContext());
                Function2 function2 = flowKt__EmittersKt$onEmpty$$inlined$unsafeFlow$1.$action$inlined;
                c02881.L$0 = safeCollector2;
                c02881.L$1 = null;
                c02881.L$2 = null;
                c02881.label = 2;
                Object objInvoke = function2.invoke(safeCollector2, c02881);
                flowCollector = safeCollector2;
                if (objInvoke == coroutine_suspended) {
                    return coroutine_suspended;
                }
                ((SafeCollector) flowCollector).releaseIntercepted();
            }
            return Unit.INSTANCE;
        } catch (Throwable th) {
            flowCollector.releaseIntercepted();
            throw th;
        }
    }
}
