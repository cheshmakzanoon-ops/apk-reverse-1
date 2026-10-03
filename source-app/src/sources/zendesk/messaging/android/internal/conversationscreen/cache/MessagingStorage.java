package zendesk.messaging.android.internal.conversationscreen.cache;

import java.util.Map;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.storage.android.Storage;

@Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u0019\b\u0007\u0012\b\b\u0001\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u0007\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010\tJ\u0016\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\rH\u0086@¢\u0006\u0002\u0010\u000eJ\u0016\u0010\u000f\u001a\u00020\b2\u0006\u0010\u0010\u001a\u00020\u000bH\u0086@¢\u0006\u0002\u0010\u0011J*\u0010\u0012\u001a\u00020\b2\u0006\u0010\f\u001a\u00020\r2\u0012\u0010\u0013\u001a\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\u000b0\u0014H\u0086@¢\u0006\u0002\u0010\u0015R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingStorage;", "", "persistenceDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "storage", "Lzendesk/storage/android/Storage;", "(Lkotlinx/coroutines/CoroutineDispatcher;Lzendesk/storage/android/Storage;)V", "clear", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getMessagingPersistence", "Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingUIPersistence;", "conversationId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "setMessagingPersistence", "messagingUIPersistence", "(Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingUIPersistence;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "updateMessagingUIPersistence", "block", "Lkotlin/Function1;", "(Ljava/lang/String;Lkotlin/jvm/functions/Function1;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MessagingStorage {
    private final CoroutineDispatcher persistenceDispatcher;
    private final Storage storage;

    @Inject
    public MessagingStorage(@Named(CoroutineDispatchersModule.PERSISTENCE_DISPATCHER) CoroutineDispatcher persistenceDispatcher, Storage storage) {
        Intrinsics.checkNotNullParameter(persistenceDispatcher, "persistenceDispatcher");
        Intrinsics.checkNotNullParameter(storage, "storage");
        this.persistenceDispatcher = persistenceDispatcher;
        this.storage = storage;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorage$setMessagingPersistence$2", m37f = "MessagingStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13762 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final MessagingUIPersistence $messagingUIPersistence;
        int label;

        C13762(MessagingUIPersistence messagingUIPersistence, Continuation<? super C13762> continuation) {
            super(2, continuation);
            this.$messagingUIPersistence = messagingUIPersistence;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MessagingStorage.this.new C13762(this.$messagingUIPersistence, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13762) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            MessagingStorage.this.storage.set(this.$messagingUIPersistence.getConversationId(), this.$messagingUIPersistence, MessagingUIPersistence.class);
            return Unit.INSTANCE;
        }
    }

    public final Object setMessagingPersistence(MessagingUIPersistence messagingUIPersistence, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C13762(messagingUIPersistence, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/messaging/android/internal/conversationscreen/cache/MessagingUIPersistence;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorage$getMessagingPersistence$2", m37f = "MessagingStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13752 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super MessagingUIPersistence>, Object> {
        final String $conversationId;
        int label;

        C13752(String str, Continuation<? super C13752> continuation) {
            super(2, continuation);
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MessagingStorage.this.new C13752(this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super MessagingUIPersistence> continuation) {
            return ((C13752) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object obj2;
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            Storage storage = MessagingStorage.this.storage;
            String str = this.$conversationId;
            String name = MessagingUIPersistence.class.getName();
            if (name != null) {
                switch (name) {
                    case "java.lang.Integer":
                        obj2 = (MessagingUIPersistence) storage.get(str, Integer.TYPE);
                        break;
                    case "java.lang.Float":
                        obj2 = (MessagingUIPersistence) storage.get(str, Float.TYPE);
                        break;
                    case "java.lang.Boolean":
                        obj2 = (MessagingUIPersistence) storage.get(str, Boolean.TYPE);
                        break;
                    case "java.lang.Long":
                        obj2 = (MessagingUIPersistence) storage.get(str, Long.TYPE);
                        break;
                    default:
                        obj2 = storage.get(str, MessagingUIPersistence.class);
                        break;
                }
            } else {
                obj2 = storage.get(str, MessagingUIPersistence.class);
            }
            MessagingUIPersistence messagingUIPersistence = (MessagingUIPersistence) obj2;
            if (messagingUIPersistence != null) {
                return messagingUIPersistence;
            }
            return new MessagingUIPersistence(this.$conversationId, (String) null, (Map) null, 6, (DefaultConstructorMarker) null);
        }
    }

    public final Object getMessagingPersistence(String str, Continuation<? super MessagingUIPersistence> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C13752(str, null), continuation);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorage$clear$2", m37f = "MessagingStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13742 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C13742(Continuation<? super C13742> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MessagingStorage.this.new C13742(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13742) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                MessagingStorage.this.storage.clear();
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object clear(Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C13742(null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorage$updateMessagingUIPersistence$2", m37f = "MessagingStorage.kt", m38i = {}, m39l = {68, 69}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C13772 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Function1<MessagingUIPersistence, MessagingUIPersistence> $block;
        final String $conversationId;
        int label;

        C13772(String str, Function1<? super MessagingUIPersistence, MessagingUIPersistence> function1, Continuation<? super C13772> continuation) {
            super(2, continuation);
            this.$conversationId = str;
            this.$block = function1;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MessagingStorage.this.new C13772(this.$conversationId, this.$block, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C13772) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = MessagingStorage.this.getMessagingPersistence(this.$conversationId, this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else {
                    if (i != 2) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            MessagingStorage messagingStorage = MessagingStorage.this;
            Function1<MessagingUIPersistence, MessagingUIPersistence> function1 = this.$block;
            this.label = 2;
            if (messagingStorage.setMessagingPersistence(function1.invoke((MessagingUIPersistence) obj), this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            return Unit.INSTANCE;
        }
    }

    public final Object updateMessagingUIPersistence(String str, Function1<? super MessagingUIPersistence, MessagingUIPersistence> function1, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C13772(str, function1, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }
}
