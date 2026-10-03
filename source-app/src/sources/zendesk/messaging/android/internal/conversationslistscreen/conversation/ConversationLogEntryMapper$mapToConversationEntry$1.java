package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogEntryMapper", m37f = "ConversationLogEntryMapper.kt", m38i = {0, 0, 0, 0, 0, 0, 0}, m39l = {63}, m40m = "mapToConversationEntry$zendesk_messaging_messaging_android", m41n = {"this", "conversation", "conversationId", "participantMyself", "latestMessageToShow", "colorFromTheming", "onBackgroundColorFromTheming"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4", "I$0", "I$1"})
final class ConversationLogEntryMapper$mapToConversationEntry$1 extends ContinuationImpl {
    int I$0;
    int I$1;
    Object L$0;
    Object L$1;
    Object L$2;
    Object L$3;
    Object L$4;
    int label;
    Object result;
    final ConversationLogEntryMapper this$0;

    ConversationLogEntryMapper$mapToConversationEntry$1(ConversationLogEntryMapper conversationLogEntryMapper, Continuation<? super ConversationLogEntryMapper$mapToConversationEntry$1> continuation) {
        super(continuation);
        this.this$0 = conversationLogEntryMapper;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.mapToConversationEntry$zendesk_messaging_messaging_android(null, null, this);
    }
}
