package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import cz.msebera.android.httpclient.HttpStatus;
import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository", m37f = "ConversationsListRepository.kt", m38i = {0, 0, 0}, m39l = {HttpStatus.SC_NOT_IMPLEMENTED}, m40m = "handlePaginationUpdate$zendesk_messaging_messaging_android", m41n = {"this", "state", "shouldLoadMore"}, m42s = {"L$0", "L$1", "Z$0"})
final class ConversationsListRepository$handlePaginationUpdate$1 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    boolean Z$0;
    int label;
    Object result;
    final ConversationsListRepository this$0;

    ConversationsListRepository$handlePaginationUpdate$1(ConversationsListRepository conversationsListRepository, Continuation<? super ConversationsListRepository$handlePaginationUpdate$1> continuation) {
        super(continuation);
        this.this$0 = conversationsListRepository;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.handlePaginationUpdate$zendesk_messaging_messaging_android(null, null, false, this);
    }
}
