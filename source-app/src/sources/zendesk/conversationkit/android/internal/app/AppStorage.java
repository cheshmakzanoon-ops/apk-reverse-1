package zendesk.conversationkit.android.internal.app;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.MutablePropertyReference1Impl;
import kotlin.jvm.internal.Reflection;
import kotlin.reflect.KProperty;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.ExecutorCoroutineDispatcher;
import kotlinx.coroutines.ExecutorsKt;
import zendesk.conversationkit.android.model.User;
import zendesk.storage.android.PersistedProperty;
import zendesk.storage.android.Storage;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0007\b\u0000\u0018\u0000 \u00172\u00020\u0001:\u0001\u0017B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0010\u001a\u00020\u0011H\u0086@¢\u0006\u0002\u0010\u0012J\u0010\u0010\u0013\u001a\u0004\u0018\u00010\u0006H\u0086@¢\u0006\u0002\u0010\u0012J\u0016\u0010\u0014\u001a\u00020\u00112\u0006\u0010\u0015\u001a\u00020\u0006H\u0086@¢\u0006\u0002\u0010\u0016R/\u0010\u0007\u001a\u0004\u0018\u00010\u00062\b\u0010\u0005\u001a\u0004\u0018\u00010\u00068B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\f\u0010\r\u001a\u0004\b\b\u0010\t\"\u0004\b\n\u0010\u000bR\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0018"}, m18d2 = {"Lzendesk/conversationkit/android/internal/app/AppStorage;", "", "storage", "Lzendesk/storage/android/Storage;", "(Lzendesk/storage/android/Storage;)V", "<set-?>", "Lzendesk/conversationkit/android/model/User;", "persistedUser", "getPersistedUser", "()Lzendesk/conversationkit/android/model/User;", "setPersistedUser", "(Lzendesk/conversationkit/android/model/User;)V", "persistedUser$delegate", "Lzendesk/storage/android/PersistedProperty;", "persistenceDispatcher", "Lkotlinx/coroutines/ExecutorCoroutineDispatcher;", "clearUser", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUser", "setUser", "user", "(Lzendesk/conversationkit/android/model/User;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AppStorage {
    static final KProperty<Object>[] $$delegatedProperties = {Reflection.mutableProperty1(new MutablePropertyReference1Impl(AppStorage.class, "persistedUser", "getPersistedUser()Lzendesk/conversationkit/android/model/User;", 0))};
    private static final String KEY_PERSISTED_USER = "PERSISTED_USER";

    private final PersistedProperty persistedUser;
    private final ExecutorCoroutineDispatcher persistenceDispatcher;

    public AppStorage(Storage storage) {
        Intrinsics.checkNotNullParameter(storage, "storage");
        ExecutorService executorServiceNewSingleThreadExecutor = Executors.newSingleThreadExecutor();
        Intrinsics.checkNotNullExpressionValue(executorServiceNewSingleThreadExecutor, "newSingleThreadExecutor(...)");
        this.persistenceDispatcher = ExecutorsKt.from(executorServiceNewSingleThreadExecutor);
        this.persistedUser = new PersistedProperty(storage, KEY_PERSISTED_USER, User.class);
    }

    public final User getPersistedUser() {
        return (User) this.persistedUser.getValue(this, $$delegatedProperties[0]);
    }

    public final void setPersistedUser(User user) {
        this.persistedUser.setValue(this, $$delegatedProperties[0], user);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/conversationkit/android/model/User;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppStorage$getUser$2", m37f = "AppStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10552 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super User>, Object> {
        int label;

        C10552(Continuation<? super C10552> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return AppStorage.this.new C10552(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super User> continuation) {
            return ((C10552) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                return AppStorage.this.getPersistedUser();
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object getUser(Continuation<? super User> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C10552(null), continuation);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppStorage$setUser$2", m37f = "AppStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10562 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final User $user;
        int label;

        C10562(User user, Continuation<? super C10562> continuation) {
            super(2, continuation);
            this.$user = user;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return AppStorage.this.new C10562(this.$user, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10562) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                AppStorage.this.setPersistedUser(this.$user);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object setUser(User user, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10562(user, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.app.AppStorage$clearUser$2", m37f = "AppStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10542 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10542(Continuation<? super C10542> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return AppStorage.this.new C10542(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10542) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                AppStorage.this.setPersistedUser(null);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object clearUser(Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10542(null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }
}
