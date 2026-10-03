package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.flow.internal.SafeCollector;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__EmittersKt$onStart$$inlined$unsafeFlow$1<T> implements Flow<T> {
    final Function2 $action$inlined;
    final Flow $this_onStart$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__EmittersKt$onStart$$inlined$unsafeFlow$1", m37f = "Emitters.kt", m38i = {0, 0, 0}, m39l = {112, 116}, m40m = "collect", m41n = {"this", "$this$onStart_u24lambda_u241", "safeCollector"}, m42s = {"L$0", "L$1", "L$2"})
    public static final class C02891 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        public C02891(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__EmittersKt$onStart$$inlined$unsafeFlow$1.this.collect(null, this);
        }
    }

    public FlowKt__EmittersKt$onStart$$inlined$unsafeFlow$1(Function2 function2, Flow flow) {
        this.$action$inlined = function2;
        this.$this_onStart$inlined = flow;
    }

    @Override
    public Object collect(FlowCollector<? super T> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C02891 c02891;
        Throwable th;
        SafeCollector safeCollector;
        FlowKt__EmittersKt$onStart$$inlined$unsafeFlow$1<T> flowKt__EmittersKt$onStart$$inlined$unsafeFlow$1;
        FlowCollector<? super T> flowCollector2;
        Flow flow;
        if (continuation instanceof C02891) {
            c02891 = (C02891) continuation;
            if ((c02891.label & Integer.MIN_VALUE) != 0) {
                c02891.label -= Integer.MIN_VALUE;
            } else {
                c02891 = new C02891(continuation);
            }
        } else {
            c02891 = new C02891(continuation);
        }
        Object obj = c02891.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02891.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            SafeCollector safeCollector2 = new SafeCollector(flowCollector, c02891.getContext());
            try {
                Function2 function2 = this.$action$inlined;
                c02891.L$0 = this;
                c02891.L$1 = flowCollector;
                c02891.L$2 = safeCollector2;
                c02891.label = 1;
                if (function2.invoke(safeCollector2, c02891) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                flowKt__EmittersKt$onStart$$inlined$unsafeFlow$1 = this;
                flowCollector2 = flowCollector;
                safeCollector = safeCollector2;
                safeCollector.releaseIntercepted();
                flow = flowKt__EmittersKt$onStart$$inlined$unsafeFlow$1.$this_onStart$inlined;
                c02891.L$0 = null;
                c02891.L$1 = null;
                c02891.L$2 = null;
                c02891.label = 2;
                if (flow.collect(flowCollector2, c02891) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (Throwable th2) {
                th = th2;
                safeCollector = safeCollector2;
                safeCollector.releaseIntercepted();
                throw th;
            }
        } else if (i == 1) {
            safeCollector = (SafeCollector) c02891.L$2;
            flowCollector2 = (FlowCollector) c02891.L$1;
            flowKt__EmittersKt$onStart$$inlined$unsafeFlow$1 = (FlowKt__EmittersKt$onStart$$inlined$unsafeFlow$1) c02891.L$0;
            try {
                ResultKt.throwOnFailure(obj);
                safeCollector.releaseIntercepted();
                flow = flowKt__EmittersKt$onStart$$inlined$unsafeFlow$1.$this_onStart$inlined;
                c02891.L$0 = null;
                c02891.L$1 = null;
                c02891.L$2 = null;
                c02891.label = 2;
                if (flow.collect(flowCollector2, c02891) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } catch (Throwable th3) {
                th = th3;
                safeCollector.releaseIntercepted();
                throw th;
            }
        } else {
            if (i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }
}
