package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlin.coroutines.Continuation;

@Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\b`\u0018\u00002\u00020\u0001J\u0016\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H¦@¢\u0006\u0002\u0010\u0006¨\u0006\u0007"}, m18d2 = {"Lzendesk/conversationkit/android/internal/ActionProcessor;", "", "process", "Lzendesk/conversationkit/android/internal/Effect;", "action", "Lzendesk/conversationkit/android/internal/Action;", "(Lzendesk/conversationkit/android/internal/Action;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ActionProcessor {
    Object process(Action action, Continuation<? super Effect> continuation);
}
