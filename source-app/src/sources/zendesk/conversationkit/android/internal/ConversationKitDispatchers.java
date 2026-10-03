package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.Dispatchers;

@Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b`\u0018\u00002\u00020\u0001J\b\u0010\u0002\u001a\u00020\u0003H\u0016J\b\u0010\u0004\u001a\u00020\u0003H\u0016J\b\u0010\u0005\u001a\u00020\u0003H\u0016J\b\u0010\u0006\u001a\u00020\u0003H\u0016¨\u0006\u0007"}, m18d2 = {"Lzendesk/conversationkit/android/internal/ConversationKitDispatchers;", "", "default", "Lkotlinx/coroutines/CoroutineDispatcher;", "io", "main", "unconfined", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationKitDispatchers {
    CoroutineDispatcher mo2103default();

    CoroutineDispatcher mo201io();

    CoroutineDispatcher main();

    CoroutineDispatcher unconfined();

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DefaultImpls {
        public static CoroutineDispatcher main(ConversationKitDispatchers conversationKitDispatchers) {
            return Dispatchers.getMain();
        }

        public static CoroutineDispatcher m2104default(ConversationKitDispatchers conversationKitDispatchers) {
            return Dispatchers.getDefault();
        }

        public static CoroutineDispatcher m202io(ConversationKitDispatchers conversationKitDispatchers) {
            return Dispatchers.getIO();
        }

        public static CoroutineDispatcher unconfined(ConversationKitDispatchers conversationKitDispatchers) {
            return Dispatchers.getUnconfined();
        }
    }
}
