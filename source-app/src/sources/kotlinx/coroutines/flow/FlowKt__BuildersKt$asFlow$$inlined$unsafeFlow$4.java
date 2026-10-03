package kotlinx.coroutines.flow;

import java.util.Iterator;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import net.aihelp.data.model.p005cs.ConversationMsg;

@Metadata(m17d1 = {"\u0000\u0019\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002*\u0001\u0000\b\n\u0018\u00002\b\u0012\u0004\u0012\u00028\u00000\u0001J\u001c\u0010\u0002\u001a\u00020\u00032\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00028\u00000\u0005H\u0096@¢\u0006\u0002\u0010\u0006¨\u0006\u0007¸\u0006\u0000"}, m18d2 = {"kotlinx/coroutines/flow/internal/SafeCollector_commonKt$unsafeFlow$1", "Lkotlinx/coroutines/flow/Flow;", "collect", "", "collector", "Lkotlinx/coroutines/flow/FlowCollector;", "(Lkotlinx/coroutines/flow/FlowCollector;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
public final class FlowKt__BuildersKt$asFlow$$inlined$unsafeFlow$4<T> implements Flow<T> {
    final Iterator $this_asFlow$inlined;

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    @DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__BuildersKt$asFlow$$inlined$unsafeFlow$4", m37f = "Builders.kt", m38i = {0}, m39l = {ConversationMsg.TYPE_ADMIN_TYPING}, m40m = "collect", m41n = {"$this$asFlow_u24lambda_u245"}, m42s = {"L$0"})
    public static final class C02671 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        public C02671(Continuation continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return FlowKt__BuildersKt$asFlow$$inlined$unsafeFlow$4.this.collect(null, this);
        }
    }

    public FlowKt__BuildersKt$asFlow$$inlined$unsafeFlow$4(Iterator it) {
        this.$this_asFlow$inlined = it;
    }

    @Override
    public Object collect(FlowCollector<? super T> flowCollector, Continuation<? super Unit> continuation) throws Throwable {
        C02671 c02671;
        FlowCollector flowCollector2;
        Iterator it;
        if (continuation instanceof C02671) {
            c02671 = (C02671) continuation;
            if ((c02671.label & Integer.MIN_VALUE) != 0) {
                c02671.label -= Integer.MIN_VALUE;
            } else {
                c02671 = new C02671(continuation);
            }
        } else {
            c02671 = new C02671(continuation);
        }
        Object obj = c02671.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c02671.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            flowCollector2 = flowCollector;
            it = this.$this_asFlow$inlined;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            it = (Iterator) c02671.L$1;
            FlowCollector flowCollector3 = (FlowCollector) c02671.L$0;
            ResultKt.throwOnFailure(obj);
            flowCollector2 = flowCollector3;
        }
        while (it.hasNext()) {
            Object next = it.next();
            c02671.L$0 = flowCollector2;
            c02671.L$1 = it;
            c02671.label = 1;
            if (flowCollector2.emit(next, c02671) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        return Unit.INSTANCE;
    }
}
