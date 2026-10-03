package kotlinx.coroutines.flow.internal;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.flow.FlowCollector;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u00022\u0006\u0010\u0003\u001a\u0002H\u0002H\n"}, m18d2 = {"<anonymous>", "", "T", "it"}, m19k = 3, m20mv = {2, 0, 0}, m22xi = 48)
@DebugMetadata(m36c = "kotlinx.coroutines.flow.internal.UndispatchedContextCollector$emitRef$1", m37f = "ChannelFlow.kt", m38i = {}, m39l = {208}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class UndispatchedContextCollector$emitRef$1<T> extends SuspendLambda implements Function2<T, Continuation<? super Unit>, Object> {
    final FlowCollector<T> $downstream;
    Object L$0;
    int label;

    UndispatchedContextCollector$emitRef$1(FlowCollector<? super T> flowCollector, Continuation<? super UndispatchedContextCollector$emitRef$1> continuation) {
        super(2, continuation);
        this.$downstream = flowCollector;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        UndispatchedContextCollector$emitRef$1 undispatchedContextCollector$emitRef$1 = new UndispatchedContextCollector$emitRef$1(this.$downstream, continuation);
        undispatchedContextCollector$emitRef$1.L$0 = obj;
        return undispatchedContextCollector$emitRef$1;
    }

    @Override
    public final Object invoke(T t, Continuation<? super Unit> continuation) {
        return ((UndispatchedContextCollector$emitRef$1) create(t, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            Object obj2 = this.L$0;
            FlowCollector<T> flowCollector = this.$downstream;
            this.label = 1;
            if (flowCollector.emit((T) obj2, this) == coroutine_suspended) {
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
