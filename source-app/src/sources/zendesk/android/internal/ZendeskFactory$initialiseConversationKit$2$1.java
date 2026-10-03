package zendesk.android.internal;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.events.exception.ZendeskJwtExpiredException;
import zendesk.android.internal.p013di.ZendeskComponent;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.internal.exception.JwtIsExpiredException;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.android.internal.ZendeskFactory$initialiseConversationKit$2$1", m37f = "ZendeskFactory.kt", m38i = {}, m39l = {162, 166}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ZendeskFactory$initialiseConversationKit$2$1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final ConversationKitEvent $conversationKitEvent;
    final ZendeskComponent $zendeskComponent;
    int label;

    ZendeskFactory$initialiseConversationKit$2$1(ConversationKitEvent conversationKitEvent, ZendeskComponent zendeskComponent, Continuation<? super ZendeskFactory$initialiseConversationKit$2$1> continuation) {
        super(2, continuation);
        this.$conversationKitEvent = conversationKitEvent;
        this.$zendeskComponent = zendeskComponent;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ZendeskFactory$initialiseConversationKit$2$1(this.$conversationKitEvent, this.$zendeskComponent, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((ZendeskFactory$initialiseConversationKit$2$1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            if (((ConversationKitEvent.UserAccessRevoked) this.$conversationKitEvent).getCause() instanceof JwtIsExpiredException) {
                this.label = 1;
                if (this.$zendeskComponent.zendeskEventDispatcher().notifyEventListeners(new ZendeskEvent.AuthenticationFailed(new ZendeskJwtExpiredException()), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                this.label = 2;
                if (this.$zendeskComponent.zendeskEventDispatcher().notifyEventListeners(new ZendeskEvent.AuthenticationFailed(((ConversationKitEvent.UserAccessRevoked) this.$conversationKitEvent).getCause()), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
        } else {
            if (i != 1 && i != 2) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        return Unit.INSTANCE;
    }
}
