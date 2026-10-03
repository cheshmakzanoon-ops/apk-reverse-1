package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import okhttp3.internal.p011ws.WebSocketProtocol;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenState;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository$handleMessageChanged$2", m37f = "ConversationsListRepository.kt", m38i = {1}, m39l = {122, WebSocketProtocol.PAYLOAD_SHORT, 131}, m40m = "invokeSuspend", m41n = {"conversation"}, m42s = {"L$0"})
final class ConversationsListRepository$handleMessageChanged$2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ConversationsListScreenState>, Object> {
    final String $conversationId;
    final Message $message;
    final boolean $shouldIncreaseCount;
    final boolean $shouldResetCount;
    final ConversationsListScreenState $state;
    Object L$0;
    int label;
    final ConversationsListRepository this$0;

    ConversationsListRepository$handleMessageChanged$2(ConversationsListRepository conversationsListRepository, String str, ConversationsListScreenState conversationsListScreenState, Message message, boolean z, boolean z2, Continuation<? super ConversationsListRepository$handleMessageChanged$2> continuation) {
        super(2, continuation);
        this.this$0 = conversationsListRepository;
        this.$conversationId = str;
        this.$state = conversationsListScreenState;
        this.$message = message;
        this.$shouldIncreaseCount = z;
        this.$shouldResetCount = z2;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ConversationsListRepository$handleMessageChanged$2(this.this$0, this.$conversationId, this.$state, this.$message, this.$shouldIncreaseCount, this.$shouldResetCount, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super ConversationsListScreenState> continuation) {
        return ((ConversationsListRepository$handleMessageChanged$2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        Object objFetchConversation;
        Conversation conversation;
        Object objMapToConversationEntry$zendesk_messaging_messaging_android;
        Object objM279xc143eec5;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = this.label;
        try {
            if (i != 0) {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                    objFetchConversation = obj;
                } else if (i == 2) {
                    conversation = (Conversation) this.L$0;
                    ResultKt.throwOnFailure(obj);
                    objMapToConversationEntry$zendesk_messaging_messaging_android = obj;
                    Conversation conversation2 = conversation;
                    ConversationLogEntryMapper conversationLogEntryMapper = this.this$0.mapper;
                    this.L$0 = null;
                    this.label = 3;
                    objM279xc143eec5 = conversationLogEntryMapper.m279xc143eec5(conversation2, (ConversationEntry) objMapToConversationEntry$zendesk_messaging_messaging_android, this.$message, conversation2.getMyself(), this.$shouldIncreaseCount, this.this$0.getConversationsUnreadCounterCurrentNumber(this.$conversationId), this.$state.getMessagingTheme(), this);
                    if (objM279xc143eec5 == coroutine_suspended) {
                        return coroutine_suspended;
                    }
                } else {
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                    objM279xc143eec5 = obj;
                }
                ConversationsListScreenState conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent = this.this$0.updateStateWithNewConversationEntryFromWebSocketEvent(this.this$0.getLatestConversationEntryUpdateWhetherShouldResetCount(this.$shouldResetCount, (ConversationEntry) objM279xc143eec5), this.$state, this.this$0.conversationsListInMemoryCache.conversations().values());
                this.this$0.updateInMemoryConversations(conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent.getConversations());
                return conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent;
            }
            ResultKt.throwOnFailure(obj);
            this.label = 1;
            objFetchConversation = this.this$0.fetchConversation(this.$conversationId, this);
            if (objFetchConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            ConversationKitResult conversationKitResult = (ConversationKitResult) objFetchConversation;
            if (!(conversationKitResult instanceof ConversationKitResult.Success)) {
                if (!(conversationKitResult instanceof ConversationKitResult.Failure)) {
                    throw new NoWhenBranchMatchedException();
                }
                Logger.m219e("ConversationsListRepository", "Failure when Message Changed and fetching conversation " + this.$conversationId, new Object[0]);
                return this.$state;
            }
            conversation = (Conversation) ((ConversationKitResult.Success) conversationKitResult).getValue();
            this.L$0 = conversation;
            this.label = 2;
            objMapToConversationEntry$zendesk_messaging_messaging_android = this.this$0.mapper.mapToConversationEntry$zendesk_messaging_messaging_android(conversation, this.$state.getMessagingTheme(), this);
            if (objMapToConversationEntry$zendesk_messaging_messaging_android == coroutine_suspended) {
                return coroutine_suspended;
            }
            Conversation conversation3 = conversation;
            ConversationLogEntryMapper conversationLogEntryMapper2 = this.this$0.mapper;
            this.L$0 = null;
            this.label = 3;
            objM279xc143eec5 = conversationLogEntryMapper2.m279xc143eec5(conversation3, (ConversationEntry) objMapToConversationEntry$zendesk_messaging_messaging_android, this.$message, conversation3.getMyself(), this.$shouldIncreaseCount, this.this$0.getConversationsUnreadCounterCurrentNumber(this.$conversationId), this.$state.getMessagingTheme(), this);
            if (objM279xc143eec5 == coroutine_suspended) {
                return coroutine_suspended;
            }
            ConversationsListScreenState conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent2 = this.this$0.updateStateWithNewConversationEntryFromWebSocketEvent(this.this$0.getLatestConversationEntryUpdateWhetherShouldResetCount(this.$shouldResetCount, (ConversationEntry) objM279xc143eec5), this.$state, this.this$0.conversationsListInMemoryCache.conversations().values());
            this.this$0.updateInMemoryConversations(conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent2.getConversations());
            return conversationsListScreenStateUpdateStateWithNewConversationEntryFromWebSocketEvent2;
        } catch (Exception e) {
            Logger.m219e("ConversationsListRepository", "Failure when Message Changed id: " + this.$conversationId + "and fetching conversation unexpected exception " + e.getMessage(), new Object[0]);
            return this.$state;
        }
    }
}
