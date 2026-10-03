package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import java.util.Collection;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenState;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository$handleConversationAdded$2", m37f = "ConversationsListRepository.kt", m38i = {}, m39l = {86}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ConversationsListRepository$handleConversationAdded$2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ConversationsListScreenState>, Object> {
    final Conversation $conversation;
    final ConversationsListScreenState $state;
    int label;
    final ConversationsListRepository this$0;

    ConversationsListRepository$handleConversationAdded$2(ConversationsListRepository conversationsListRepository, Conversation conversation, ConversationsListScreenState conversationsListScreenState, Continuation<? super ConversationsListRepository$handleConversationAdded$2> continuation) {
        super(2, continuation);
        this.this$0 = conversationsListRepository;
        this.$conversation = conversation;
        this.$state = conversationsListScreenState;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ConversationsListRepository$handleConversationAdded$2(this.this$0, this.$conversation, this.$state, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super ConversationsListScreenState> continuation) {
        return ((ConversationsListRepository$handleConversationAdded$2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            obj = this.this$0.mapper.mapToConversationEntry$zendesk_messaging_messaging_android(this.$conversation, this.$state.getMessagingTheme(), this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
        }
        Collection<ConversationEntry> collectionValues = this.this$0.conversationsListInMemoryCache.conversations().values();
        ConversationsListScreenState conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent = this.this$0.updateStateWithNewConversationEntryFromWebSocketEvent((ConversationEntry) obj, this.$state, collectionValues);
        this.this$0.updateInMemoryConversations(conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent.getConversations());
        return conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent;
    }
}
