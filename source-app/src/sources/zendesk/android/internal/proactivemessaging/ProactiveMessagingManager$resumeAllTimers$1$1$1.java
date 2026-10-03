package zendesk.android.internal.proactivemessaging;

import java.util.concurrent.TimeUnit;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.DelayKt;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingManager$resumeAllTimers$1$1$1", m37f = "ProactiveMessagingManager.kt", m38i = {}, m39l = {192, 194}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ProactiveMessagingManager$resumeAllTimers$1$1$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final EvaluationState $state;
    int label;
    final ProactiveMessagingManager this$0;

    ProactiveMessagingManager$resumeAllTimers$1$1$1(EvaluationState evaluationState, ProactiveMessagingManager proactiveMessagingManager, Continuation<? super ProactiveMessagingManager$resumeAllTimers$1$1$1> continuation) {
        super(2, continuation);
        this.$state = evaluationState;
        this.this$0 = proactiveMessagingManager;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ProactiveMessagingManager$resumeAllTimers$1$1$1(this.$state, this.this$0, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((ProactiveMessagingManager$resumeAllTimers$1$1$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            if (DelayKt.delay(TimeUnit.SECONDS.toMillis(this.$state.getRemainingSeconds()), this) == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i == 1) {
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        Logger.m217d("PM-Manager", "From resumed Timer", new Object[0]);
        this.label = 2;
        if (this.this$0.reportToCts(this.$state.getEvaluationResults(), this) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }
}
