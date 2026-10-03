package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;

@Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u0000 \u00052\u00020\u0001:\u0001\u0005J\u000e\u0010\u0002\u001a\u00020\u0003H\u0096@¢\u0006\u0002\u0010\u0004\u0082\u0001\u0002\u0006\u0007¨\u0006\b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageCleaner;", "", "clear", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "EMPTY", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageCleaner$EMPTY;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageCleanerImpl;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationsListLocalStorageCleaner {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    Object clear(Continuation<? super Unit> continuation);

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DefaultImpls {
        public static Object clear(ConversationsListLocalStorageCleaner conversationsListLocalStorageCleaner, Continuation<? super Unit> continuation) {
            Object objClear = ConversationsListLocalStorageCleaner.INSTANCE.clear(continuation);
            return objClear == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClear : Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000e\u0010\u0003\u001a\u00020\u0004H\u0096@¢\u0006\u0002\u0010\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageCleaner$EMPTY;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageCleaner;", "()V", "clear", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion implements ConversationsListLocalStorageCleaner {
        static final Companion $$INSTANCE = new Companion();

        private Companion() {
        }

        @Override
        public Object clear(Continuation<? super Unit> continuation) {
            return Unit.INSTANCE;
        }
    }
}
