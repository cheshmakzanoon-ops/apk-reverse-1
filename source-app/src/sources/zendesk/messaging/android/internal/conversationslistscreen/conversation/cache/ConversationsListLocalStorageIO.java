package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;

@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u0000 \u000b2\u00020\u0001:\u0001\u000bJ\u0018\u0010\u0002\u001a\u0004\u0018\u00010\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0096@¢\u0006\u0002\u0010\u0006J\u0016\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\u0003H\u0096@¢\u0006\u0002\u0010\n\u0082\u0001\u0002\f\r¨\u0006\u000e"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO;", "", "getConversationsListPersistence", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;", "conversationId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setConversationsListPersistence", "", "conversationUIPersistence", "(Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "EMPTY", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO$EMPTY;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIOImpl;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationsListLocalStorageIO {

    public static final Companion INSTANCE = Companion.$$INSTANCE;

    Object getConversationsListPersistence(String str, Continuation<? super ConversationsListUIPersistenceItem> continuation);

    Object setConversationsListPersistence(ConversationsListUIPersistenceItem conversationsListUIPersistenceItem, Continuation<? super Unit> continuation);

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DefaultImpls {
        public static Object setConversationsListPersistence(ConversationsListLocalStorageIO conversationsListLocalStorageIO, ConversationsListUIPersistenceItem conversationsListUIPersistenceItem, Continuation<? super Unit> continuation) {
            Object conversationsListPersistence = ConversationsListLocalStorageIO.INSTANCE.setConversationsListPersistence(conversationsListUIPersistenceItem, continuation);
            return conversationsListPersistence == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? conversationsListPersistence : Unit.INSTANCE;
        }

        public static Object getConversationsListPersistence(ConversationsListLocalStorageIO conversationsListLocalStorageIO, String str, Continuation<? super ConversationsListUIPersistenceItem> continuation) {
            return ConversationsListLocalStorageIO.INSTANCE.getConversationsListPersistence(str, continuation);
        }
    }

    @Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u0004\u0018\u00010\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0096@¢\u0006\u0002\u0010\u0007J\u0016\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u0004H\u0096@¢\u0006\u0002\u0010\u000b¨\u0006\f"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO$EMPTY;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO;", "()V", "getConversationsListPersistence", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;", "conversationId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setConversationsListPersistence", "", "conversationUIPersistence", "(Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion implements ConversationsListLocalStorageIO {
        static final Companion $$INSTANCE = new Companion();

        @Override
        public Object getConversationsListPersistence(String str, Continuation<? super ConversationsListUIPersistenceItem> continuation) {
            return null;
        }

        private Companion() {
        }

        @Override
        public Object setConversationsListPersistence(ConversationsListUIPersistenceItem conversationsListUIPersistenceItem, Continuation<? super Unit> continuation) {
            return Unit.INSTANCE;
        }
    }
}
