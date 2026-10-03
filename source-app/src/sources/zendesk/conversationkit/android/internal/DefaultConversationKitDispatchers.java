package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlinx.coroutines.CoroutineDispatcher;

@Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/DefaultConversationKitDispatchers;", "Lzendesk/conversationkit/android/internal/ConversationKitDispatchers;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultConversationKitDispatchers implements ConversationKitDispatchers {
    @Override
    public CoroutineDispatcher mo2103default() {
        return ConversationKitDispatchers.DefaultImpls.m2104default(this);
    }

    @Override
    public CoroutineDispatcher mo201io() {
        return ConversationKitDispatchers.DefaultImpls.m202io(this);
    }

    @Override
    public CoroutineDispatcher main() {
        return ConversationKitDispatchers.DefaultImpls.main(this);
    }

    @Override
    public CoroutineDispatcher unconfined() {
        return ConversationKitDispatchers.DefaultImpls.unconfined(this);
    }
}
