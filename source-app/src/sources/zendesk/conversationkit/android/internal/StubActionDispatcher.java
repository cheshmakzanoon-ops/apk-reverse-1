package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import zendesk.conversationkit.android.ConversationKitResult;

@Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\"\u0010\u0003\u001a\b\u0012\u0004\u0012\u0002H\u00050\u0004\"\u0004\b\u0000\u0010\u00052\u0006\u0010\u0006\u001a\u00020\u0007H\u0096@¢\u0006\u0002\u0010\b¨\u0006\t"}, m18d2 = {"Lzendesk/conversationkit/android/internal/StubActionDispatcher;", "Lzendesk/conversationkit/android/internal/ActionDispatcher;", "()V", "dispatch", "Lzendesk/conversationkit/android/ConversationKitResult;", "T", "action", "Lzendesk/conversationkit/android/internal/Action;", "(Lzendesk/conversationkit/android/internal/Action;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class StubActionDispatcher implements ActionDispatcher {
    @Override
    public <T> Object dispatch(Action action, Continuation<? super ConversationKitResult<? extends T>> continuation) {
        return new ConversationKitResult.Success(Unit.INSTANCE);
    }
}
