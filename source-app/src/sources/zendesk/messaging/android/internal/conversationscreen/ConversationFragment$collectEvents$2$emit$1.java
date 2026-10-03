package zendesk.messaging.android.internal.conversationscreen;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;

@Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.ConversationFragment$collectEvents$2", m37f = "ConversationFragment.kt", m38i = {0, 0}, m39l = {455}, m40m = "emit", m41n = {"this", "it"}, m42s = {"L$0", "L$1"})
final class ConversationFragment$collectEvents$2$emit$1 extends ContinuationImpl {
    Object L$0;
    Object L$1;
    Object L$2;
    int label;
    Object result;
    final ConversationFragment.C12702<T> this$0;

    ConversationFragment$collectEvents$2$emit$1(ConversationFragment.C12702<? super T> c12702, Continuation<? super ConversationFragment$collectEvents$2$emit$1> continuation) {
        super(continuation);
        this.this$0 = c12702;
    }

    @Override
    public final Object invokeSuspend(Object obj) {
        this.result = obj;
        this.label |= Integer.MIN_VALUE;
        return this.this$0.emit((ConversationScreenEvent) null, (Continuation<? super Unit>) this);
    }
}
