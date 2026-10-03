package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import cz.msebera.android.httpclient.HttpStatus;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenState;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository$handleConversationReadReceived$2", m37f = "ConversationsListRepository.kt", m38i = {}, m39l = {300, HttpStatus.SC_NOT_MODIFIED}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ConversationsListRepository$handleConversationReadReceived$2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ConversationsListScreenState>, Object> {
    final String $conversationId;
    final ConversationsListScreenState $state;
    int label;
    final ConversationsListRepository this$0;

    ConversationsListRepository$handleConversationReadReceived$2(ConversationsListRepository conversationsListRepository, String str, ConversationsListScreenState conversationsListScreenState, Continuation<? super ConversationsListRepository$handleConversationReadReceived$2> continuation) {
        super(2, continuation);
        this.this$0 = conversationsListRepository;
        this.$conversationId = str;
        this.$state = conversationsListScreenState;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ConversationsListRepository$handleConversationReadReceived$2(this.this$0, this.$conversationId, this.$state, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super ConversationsListScreenState> continuation) {
        return ((ConversationsListRepository$handleConversationReadReceived$2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                ConversationEntry conversationEntry = (ConversationEntry) obj;
                StringBuilder sb = new StringBuilder("Reset counter this ");
                Intrinsics.checkNotNull(conversationEntry, "null cannot be cast to non-null type zendesk.core.ui.android.internal.model.ConversationEntry.ConversationItem");
                sb.append(((ConversationEntry.ConversationItem) conversationEntry).getUnreadMessages());
                sb.append(" .Event. Id = ");
                sb.append(this.$conversationId);
                Logger.m217d("ConversationsListRepository", sb.toString(), new Object[0]);
                ConversationsListScreenState conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent = this.this$0.updateStateWithNewConversationEntryFromWebSocketEvent(this.this$0.resetUnreadCounter(conversationEntry), this.$state, this.this$0.conversationsListInMemoryCache.conversations().values());
                this.this$0.updateInMemoryConversations(conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent.getConversations());
                return conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent;
            }
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            obj = this.this$0.fetchConversation(this.$conversationId, this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            ConversationKitResult conversationKitResult = (ConversationKitResult) obj;
            if (!(conversationKitResult instanceof ConversationKitResult.Success)) {
                if (!(conversationKitResult instanceof ConversationKitResult.Failure)) {
                    throw new NoWhenBranchMatchedException();
                }
                Logger.m219e("ConversationsListRepository", "Failure when ConversationReadReceived and fetching conversation " + this.$conversationId, new Object[0]);
                return this.$state;
            }
            Conversation conversation = (Conversation) ((ConversationKitResult.Success) conversationKitResult).getValue();
            this.label = 2;
            obj = this.this$0.mapper.mapToConversationEntry$zendesk_messaging_messaging_android(conversation, this.$state.getMessagingTheme(), this);
            if (obj == coroutine_suspended) {
                return coroutine_suspended;
            }
            ConversationEntry conversationEntry2 = (ConversationEntry) obj;
            StringBuilder sb2 = new StringBuilder("Reset counter this ");
            Intrinsics.checkNotNull(conversationEntry2, "null cannot be cast to non-null type zendesk.core.ui.android.internal.model.ConversationEntry.ConversationItem");
            sb2.append(((ConversationEntry.ConversationItem) conversationEntry2).getUnreadMessages());
            sb2.append(" .Event. Id = ");
            sb2.append(this.$conversationId);
            Logger.m217d("ConversationsListRepository", sb2.toString(), new Object[0]);
            ConversationsListScreenState conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent2 = this.this$0.updateStateWithNewConversationEntryFromWebSocketEvent(this.this$0.resetUnreadCounter(conversationEntry2), this.$state, this.this$0.conversationsListInMemoryCache.conversations().values());
            this.this$0.updateInMemoryConversations(conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent2.getConversations());
            return conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent2;
        } catch (Exception e) {
            Logger.m219e("ConversationsListRepository", "Failure when ConversationReadReceived id: " + this.$conversationId + "and fetching conversation unexpected exception " + e.getMessage(), new Object[0]);
            return this.$state;
        }
    }
}
