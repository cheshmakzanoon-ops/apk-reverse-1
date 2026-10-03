package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.collections.immutable.ExtensionsKt;
import kotlinx.coroutines.CoroutineScope;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenState;

@Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenState;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository$handleConversationRemoved$2", m37f = "ConversationsListRepository.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
final class ConversationsListRepository$handleConversationRemoved$2 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ConversationsListScreenState>, Object> {
    final String $conversationId;
    final ConversationsListScreenState $state;
    int label;
    final ConversationsListRepository this$0;

    ConversationsListRepository$handleConversationRemoved$2(ConversationsListScreenState conversationsListScreenState, ConversationsListRepository conversationsListRepository, String str, Continuation<? super ConversationsListRepository$handleConversationRemoved$2> continuation) {
        super(2, continuation);
        this.$state = conversationsListScreenState;
        this.this$0 = conversationsListRepository;
        this.$conversationId = str;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new ConversationsListRepository$handleConversationRemoved$2(this.$state, this.this$0, this.$conversationId, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super ConversationsListScreenState> continuation) {
        return ((ConversationsListRepository$handleConversationRemoved$2) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final Object invokeSuspend(Object obj) throws Throwable {
        IntrinsicsKt.getCOROUTINE_SUSPENDED();
        if (this.label != 0) {
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
        ResultKt.throwOnFailure(obj);
        ConversationsListScreenState conversationsListScreenState = this.$state;
        ConversationsListRepository conversationsListRepository = this.this$0;
        ConversationsListScreenState conversationsListScreenStateConversationsList = ConversationsListStateHelperKt.conversationsList(conversationsListScreenState, ExtensionsKt.toImmutableList(conversationsListRepository.removeExistingConversationEntryFromWebSocketEvent(this.$conversationId, conversationsListRepository.conversationsListInMemoryCache.conversations().values(), this.$state)));
        this.this$0.updateInMemoryConversations(conversationsListScreenStateConversationsList.getConversations());
        return conversationsListScreenStateConversationsList;
    }
}
