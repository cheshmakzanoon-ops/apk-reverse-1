package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlinx.coroutines.CoroutineScope;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.core.p017ui.android.internal.model.ConversationEntry;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenState;

@Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001*\u00020\u0003H\u008a@"}, m18d2 = {"<anonymous>", "", "Lzendesk/core/ui/android/internal/model/ConversationEntry;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
@DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository$refreshConversationsList$conversationsEntry$1", m37f = "ConversationsListRepository.kt", m38i = {0}, m39l = {229}, m40m = "invokeSuspend", m41n = {"destination$iv$iv"}, m42s = {"L$2"})
final class C1492xcfd255d4 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super List<? extends ConversationEntry>>, Object> {
    final List<Conversation> $conversations;
    final ConversationsListScreenState $conversationsListScreenState;
    Object L$0;
    Object L$1;
    Object L$2;
    Object L$3;
    Object L$4;
    int label;
    final ConversationsListRepository this$0;

    C1492xcfd255d4(List<Conversation> list, ConversationsListRepository conversationsListRepository, ConversationsListScreenState conversationsListScreenState, Continuation<? super C1492xcfd255d4> continuation) {
        super(2, continuation);
        this.$conversations = list;
        this.this$0 = conversationsListRepository;
        this.$conversationsListScreenState = conversationsListScreenState;
    }

    @Override
    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
        return new C1492xcfd255d4(this.$conversations, this.this$0, this.$conversationsListScreenState, continuation);
    }

    @Override
    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super List<? extends ConversationEntry>> continuation) {
        return ((C1492xcfd255d4) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
    }

    @Override
    public final java.lang.Object invokeSuspend(java.lang.Object r9) {
        throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationslistscreen.conversation.C1492xcfd255d4.invokeSuspend(java.lang.Object):java.lang.Object");
    }
}
