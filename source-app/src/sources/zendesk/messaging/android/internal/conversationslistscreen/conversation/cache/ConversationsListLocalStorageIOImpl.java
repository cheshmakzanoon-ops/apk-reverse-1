package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.storage.android.Storage;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0003\b\u0000\u0018\u00002\u00020\u0001B\u001b\b\u0007\u0012\b\b\u0001\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0018\u0010\t\u001a\u0004\u0018\u00010\n2\u0006\u0010\u000b\u001a\u00020\fH\u0096@¢\u0006\u0002\u0010\rJ\u0016\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\u0010\u001a\u00020\nH\u0096@¢\u0006\u0002\u0010\u0011R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIOImpl;", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageIO;", "persistenceDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "storage", "Lzendesk/storage/android/Storage;", "(Lkotlinx/coroutines/CoroutineDispatcher;Lzendesk/storage/android/Storage;)V", "getPersistenceDispatcher", "()Lkotlinx/coroutines/CoroutineDispatcher;", "getConversationsListPersistence", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;", "conversationId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setConversationsListPersistence", "", "conversationUIPersistence", "(Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListLocalStorageIOImpl implements ConversationsListLocalStorageIO {
    private final CoroutineDispatcher persistenceDispatcher;
    private final Storage storage;

    @Inject
    public ConversationsListLocalStorageIOImpl(@Named(CoroutineDispatchersModule.PERSISTENCE_DISPATCHER) CoroutineDispatcher persistenceDispatcher, @Named(ConversationsListLocalStorageIOKt.MULTICONVO_LOCAL_STORAGE) Storage storage) {
        Intrinsics.checkNotNullParameter(persistenceDispatcher, "persistenceDispatcher");
        Intrinsics.checkNotNullParameter(storage, "storage");
        this.persistenceDispatcher = persistenceDispatcher;
        this.storage = storage;
    }

    public final CoroutineDispatcher getPersistenceDispatcher() {
        return this.persistenceDispatcher;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIOImpl$setConversationsListPersistence$2", m37f = "ConversationsListLocalStorageIOImpl.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14972 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final ConversationsListUIPersistenceItem $conversationUIPersistence;
        int label;

        C14972(ConversationsListUIPersistenceItem conversationsListUIPersistenceItem, Continuation<? super C14972> continuation) {
            super(2, continuation);
            this.$conversationUIPersistence = conversationsListUIPersistenceItem;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationsListLocalStorageIOImpl.this.new C14972(this.$conversationUIPersistence, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14972) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            ConversationsListLocalStorageIOImpl.this.storage.set(this.$conversationUIPersistence.getConversationId(), this.$conversationUIPersistence, ConversationsListUIPersistenceItem.class);
            return Unit.INSTANCE;
        }
    }

    @Override
    public Object setConversationsListPersistence(ConversationsListUIPersistenceItem conversationsListUIPersistenceItem, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C14972(conversationsListUIPersistenceItem, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListUIPersistenceItem;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageIOImpl$getConversationsListPersistence$2", m37f = "ConversationsListLocalStorageIOImpl.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14962 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super ConversationsListUIPersistenceItem>, Object> {
        final String $conversationId;
        int label;

        C14962(String str, Continuation<? super C14962> continuation) {
            super(2, continuation);
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationsListLocalStorageIOImpl.this.new C14962(this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super ConversationsListUIPersistenceItem> continuation) {
            return ((C14962) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            Storage storage = ConversationsListLocalStorageIOImpl.this.storage;
            String str = this.$conversationId;
            String name = ConversationsListUIPersistenceItem.class.getName();
            if (name != null) {
                switch (name.hashCode()) {
                    case -2056817302:
                        if (name.equals("java.lang.Integer")) {
                            return (ConversationsListUIPersistenceItem) storage.get(str, Integer.TYPE);
                        }
                        break;
                    case -527879800:
                        if (name.equals("java.lang.Float")) {
                            return (ConversationsListUIPersistenceItem) storage.get(str, Float.TYPE);
                        }
                        break;
                    case 344809556:
                        if (name.equals("java.lang.Boolean")) {
                            return (ConversationsListUIPersistenceItem) storage.get(str, Boolean.TYPE);
                        }
                        break;
                    case 398795216:
                        if (name.equals("java.lang.Long")) {
                            return (ConversationsListUIPersistenceItem) storage.get(str, Long.TYPE);
                        }
                        break;
                }
            }
            return storage.get(str, ConversationsListUIPersistenceItem.class);
        }
    }

    @Override
    public Object getConversationsListPersistence(String str, Continuation<? super ConversationsListUIPersistenceItem> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C14962(str, null), continuation);
    }
}
