package zendesk.messaging.android.internal.validation;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.validation.ConversationFieldRepository", m37f = "ConversationFieldRepository.kt", m38i = {}, m39l = {23}, m40m = "fetchConversationFields$zendesk_messaging_messaging_android", m41n = {}, m42s = {})
final class ConversationFieldRepository$fetchConversationFields$1 extends ContinuationImpl {
    int label;
    Object result;
    final ConversationFieldRepository this$0;

    ConversationFieldRepository$fetchConversationFields$1(ConversationFieldRepository conversationFieldRepository, Continuation<? super ConversationFieldRepository$fetchConversationFields$1> continuation) {
        super(continuation);
        this.this$0 = conversationFieldRepository;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.fetchConversationFields$zendesk_messaging_messaging_android(this);
    }
}
