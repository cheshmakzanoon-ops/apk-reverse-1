package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationLogEntryMapper", m37f = "ConversationLogEntryMapper.kt", m38i = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, m39l = {293}, m40m = "updateConversationEntryWithNewMessage$zendesk_messaging_messaging_android", m41n = {"this", "conversation", "conversationEntry", "message", "timeStamp", "shouldIncreaseCount", "conversationUnreadCurrentNumber", "colorFromTheming", "onBackgroundColorFromTheming", "isMyself"}, m42s = {"L$0", "L$1", "L$2", "L$3", "L$4", "Z$0", "I$0", "I$1", "I$2", "Z$1"})
final class C1489x2507a54e extends ContinuationImpl {
    int I$0;
    int I$1;
    int I$2;
    Object L$0;
    Object L$1;
    Object L$2;
    Object L$3;
    Object L$4;
    boolean Z$0;
    boolean Z$1;
    int label;
    Object result;
    final ConversationLogEntryMapper this$0;

    C1489x2507a54e(ConversationLogEntryMapper conversationLogEntryMapper, Continuation<? super C1489x2507a54e> continuation) {
        super(continuation);
        this.this$0 = conversationLogEntryMapper;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.m279xc143eec5(null, null, null, null, false, 0, null, this);
    }
}
