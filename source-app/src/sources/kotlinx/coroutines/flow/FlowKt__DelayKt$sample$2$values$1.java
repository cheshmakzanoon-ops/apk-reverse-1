package kotlinx.coroutines.flow;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.channels.ProducerScope;
import kotlinx.coroutines.flow.internal.NullSurrogateKt;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00030\u0002H\n"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/channels/ProducerScope;", ""}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.FlowKt__DelayKt$sample$2$values$1", m37f = "Delay.kt", m38i = {}, m39l = {273}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class FlowKt__DelayKt$sample$2$values$1 extends SuspendLambda implements Function2<ProducerScope<? super Object>, Continuation<? super Unit>, Object> {
    final Flow<T> $this_sample;
    private Object L$0;
    int label;

    FlowKt__DelayKt$sample$2$values$1(Flow<? extends T> flow, Continuation<? super FlowKt__DelayKt$sample$2$values$1> continuation) {
        super(2, continuation);
        this.$this_sample = flow;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        FlowKt__DelayKt$sample$2$values$1 flowKt__DelayKt$sample$2$values$1 = new FlowKt__DelayKt$sample$2$values$1(this.$this_sample, continuation);
        flowKt__DelayKt$sample$2$values$1.L$0 = obj;
        return flowKt__DelayKt$sample$2$values$1;
    }

    @Override
    public Object invoke(ProducerScope<? super Object> producerScope, Continuation<? super Unit> continuation) {
        return invoke2((ProducerScope<Object>) producerScope, continuation);
    }

    public final Object invoke2(ProducerScope<Object> producerScope, Continuation<? super Unit> continuation) {
        return ((FlowKt__DelayKt$sample$2$values$1) create(producerScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Metadata(m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
    static final class C02861<T> implements FlowCollector {
        final ProducerScope<Object> $$this$produce;

        C02861(ProducerScope<Object> producerScope) {
            this.$$this$produce = producerScope;
        }

        @Override
        public final Object emit(T t, Continuation<? super Unit> continuation) throws Throwable {
            FlowKt__DelayKt$sample$2$values$1$1$emit$1 flowKt__DelayKt$sample$2$values$1$1$emit$1;
            if (continuation instanceof FlowKt__DelayKt$sample$2$values$1$1$emit$1) {
                flowKt__DelayKt$sample$2$values$1$1$emit$1 = (FlowKt__DelayKt$sample$2$values$1$1$emit$1) continuation;
                if ((flowKt__DelayKt$sample$2$values$1$1$emit$1.label & Integer.MIN_VALUE) != 0) {
                    flowKt__DelayKt$sample$2$values$1$1$emit$1.label -= Integer.MIN_VALUE;
                } else {
                    flowKt__DelayKt$sample$2$values$1$1$emit$1 = new FlowKt__DelayKt$sample$2$values$1$1$emit$1(this, continuation);
                }
            } else {
                flowKt__DelayKt$sample$2$values$1$1$emit$1 = new FlowKt__DelayKt$sample$2$values$1$1$emit$1(this, continuation);
            }
            Object obj = flowKt__DelayKt$sample$2$values$1$1$emit$1.result;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = flowKt__DelayKt$sample$2$values$1$1$emit$1.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ProducerScope<Object> producerScope = this.$$this$produce;
                if (t == null) {
                    t = (T) NullSurrogateKt.NULL;
                }
                flowKt__DelayKt$sample$2$values$1$1$emit$1.label = 1;
                if (producerScope.send(t, flowKt__DelayKt$sample$2$values$1$1$emit$1) == coroutine_suspended) {
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

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ProducerScope producerScope = (ProducerScope) this.L$0;
            Flow<T> flow = this.$this_sample;
            C02861 c02861 = new C02861(producerScope);
            this.label = 1;
            if (flow.collect(c02861, this) == coroutine_suspended) {
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
