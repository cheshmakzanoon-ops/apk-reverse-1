package zendesk.messaging.android.internal.conversationscreen;

import android.net.Uri;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.core.android.internal.FileKtxKt;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModel$eventListener$1$3", m37f = "ConversationScreenViewModel.kt", m38i = {}, m39l = {157, 158}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ConversationScreenViewModel$eventListener$1$3 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
    final ConversationKitEvent $conversationKitEvent;
    Object L$0;
    int label;
    final ConversationScreenViewModel this$0;

    ConversationScreenViewModel$eventListener$1$3(ConversationKitEvent conversationKitEvent, ConversationScreenViewModel conversationScreenViewModel, Continuation<? super ConversationScreenViewModel$eventListener$1$3> continuation) {
        super(2, continuation);
        this.$conversationKitEvent = conversationKitEvent;
        this.this$0 = conversationScreenViewModel;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ConversationScreenViewModel$eventListener$1$3(this.$conversationKitEvent, this.this$0, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
        return ((ConversationScreenViewModel$eventListener$1$3) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        String conversationId;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            conversationId = ((ConversationKitEvent.OpenFileAttachment) this.$conversationKitEvent).getConversationId();
            this.L$0 = conversationId;
            this.label = 1;
            obj = this.this$0.conversationId$zendesk_messaging_messaging_android(this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i == 1) {
                conversationId = (String) this.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
        if (Intrinsics.areEqual(conversationId, obj)) {
            this.L$0 = null;
            this.label = 2;
            if (this.this$0._eventsChannel.send(new ConversationScreenEvent.OpenFileAttachment(((ConversationKitEvent.OpenFileAttachment) this.$conversationKitEvent).getFile(), FileKtxKt.getMimeType(Uri.fromFile(((ConversationKitEvent.OpenFileAttachment) this.$conversationKitEvent).getFile()))), this) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        return Unit.INSTANCE;
    }
}
