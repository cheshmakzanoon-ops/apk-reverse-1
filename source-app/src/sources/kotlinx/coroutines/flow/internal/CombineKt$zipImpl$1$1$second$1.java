package kotlinx.coroutines.flow.internal;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.channels.ProducerScope;
import kotlinx.coroutines.channels.SendChannel;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00030\u0002H\n"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/channels/ProducerScope;", ""}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.internal.CombineKt$zipImpl$1$1$second$1", m37f = "Combine.kt", m38i = {}, m39l = {86}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class CombineKt$zipImpl$1$1$second$1 extends SuspendLambda implements Function2<ProducerScope<? super Object>, Continuation<? super Unit>, Object> {
    final Flow<T2> $flow2;
    private Object L$0;
    int label;

    CombineKt$zipImpl$1$1$second$1(Flow<? extends T2> flow, Continuation<? super CombineKt$zipImpl$1$1$second$1> continuation) {
        super(2, continuation);
        this.$flow2 = flow;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        CombineKt$zipImpl$1$1$second$1 combineKt$zipImpl$1$1$second$1 = new CombineKt$zipImpl$1$1$second$1(this.$flow2, continuation);
        combineKt$zipImpl$1$1$second$1.L$0 = obj;
        return combineKt$zipImpl$1$1$second$1;
    }

    @Override
    public Object invoke(ProducerScope<? super Object> producerScope, Continuation<? super Unit> continuation) {
        return invoke2((ProducerScope<Object>) producerScope, continuation);
    }

    public final Object invoke2(ProducerScope<Object> producerScope, Continuation<? super Unit> continuation) {
        return ((CombineKt$zipImpl$1$1$second$1) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    static final class C03751<T> implements FlowCollector {
        final ProducerScope<Object> $$this$produce;

        C03751(ProducerScope<Object> producerScope) {
            this.$$this$produce = producerScope;
        }

        @Override
        public final Object emit(T2 t2, Continuation<? super Unit> continuation) throws Throwable {
            CombineKt$zipImpl$1$1$second$1$1$emit$1 combineKt$zipImpl$1$1$second$1$1$emit$1;
            Object obj;
            if (continuation instanceof CombineKt$zipImpl$1$1$second$1$1$emit$1) {
                combineKt$zipImpl$1$1$second$1$1$emit$1 = (CombineKt$zipImpl$1$1$second$1$1$emit$1) continuation;
                if ((combineKt$zipImpl$1$1$second$1$1$emit$1.label & Integer.MIN_VALUE) != 0) {
                    combineKt$zipImpl$1$1$second$1$1$emit$1.label -= Integer.MIN_VALUE;
                } else {
                    combineKt$zipImpl$1$1$second$1$1$emit$1 = new CombineKt$zipImpl$1$1$second$1$1$emit$1(this, continuation);
                }
            } else {
                combineKt$zipImpl$1$1$second$1$1$emit$1 = new CombineKt$zipImpl$1$1$second$1$1$emit$1(this, continuation);
            }
            Object obj2 = combineKt$zipImpl$1$1$second$1$1$emit$1.result;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = combineKt$zipImpl$1$1$second$1$1$emit$1.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj2);
                SendChannel<Object> channel = this.$$this$produce.getChannel();
                if (t2 == 0) {
                    obj = t2;
                    obj = NullSurrogateKt.NULL;
                }
                obj = t2;
                combineKt$zipImpl$1$1$second$1$1$emit$1.label = 1;
                if (channel.send(obj, combineKt$zipImpl$1$1$second$1$1$emit$1) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj2);
            }
            return Unit.INSTANCE;
        }
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ProducerScope producerScope = (ProducerScope) this.L$0;
            Flow<T2> flow = this.$flow2;
            C03751 c03751 = new C03751(producerScope);
            this.label = 1;
            if (flow.collect(c03751, this) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }
}
