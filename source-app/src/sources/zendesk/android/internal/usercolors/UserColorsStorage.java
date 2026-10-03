package zendesk.android.internal.usercolors;

import android.content.Context;
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
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.ExecutorCoroutineDispatcher;
import kotlinx.coroutines.ExecutorsKt;
import zendesk.android.internal.storage.ZendeskStorageSerializer;
import zendesk.core.android.internal.p016di.KotlinxSerializationModule;
import zendesk.storage.android.Storage;
import zendesk.storage.android.StorageFactory;
import zendesk.storage.android.StorageType;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0000\u0018\u0000 \u000f2\u00020\u0001:\u0002\u000f\u0010B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0007\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010\tJ\u0010\u0010\n\u001a\u0004\u0018\u00010\u000bH\u0086@¢\u0006\u0002\u0010\tJ\u0016\u0010\f\u001a\u00020\b2\u0006\u0010\r\u001a\u00020\u000bH\u0086@¢\u0006\u0002\u0010\u000eR\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lzendesk/android/internal/usercolors/UserColorsStorage;", "", "storage", "Lzendesk/storage/android/Storage;", "(Lzendesk/storage/android/Storage;)V", "persistenceDispatcher", "Lkotlinx/coroutines/ExecutorCoroutineDispatcher;", "clear", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUserColors", "Lzendesk/android/internal/usercolors/UserColorsSchemePersistence;", "setUserColors", "userColors", "(Lzendesk/android/internal/usercolors/UserColorsSchemePersistence;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "StorageProvider", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class UserColorsStorage {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String KEY_USER_COLORS = "UserColorsStorage.KEY_COLORS";
    private static final String USER_COLORS_STORAGE_NAMESPACE = "zendesk.android.internal.usercolors";
    private final ExecutorCoroutineDispatcher persistenceDispatcher;
    private final Storage storage;

    public UserColorsStorage(Storage storage) {
        Intrinsics.checkNotNullParameter(storage, "storage");
        this.storage = storage;
        ExecutorService executorServiceNewSingleThreadExecutor = Executors.newSingleThreadExecutor();
        Intrinsics.checkNotNullExpressionValue(executorServiceNewSingleThreadExecutor, "newSingleThreadExecutor(...)");
        this.persistenceDispatcher = ExecutorsKt.from(executorServiceNewSingleThreadExecutor);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.usercolors.UserColorsStorage$setUserColors$2", m37f = "UserColorsStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09892 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final UserColorsSchemePersistence $userColors;
        int label;

        C09892(UserColorsSchemePersistence userColorsSchemePersistence, Continuation<? super C09892> continuation) {
            super(2, continuation);
            this.$userColors = userColorsSchemePersistence;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return UserColorsStorage.this.new C09892(this.$userColors, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09892) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            UserColorsStorage.this.storage.set(UserColorsStorage.KEY_USER_COLORS, this.$userColors, UserColorsSchemePersistence.class);
            return Unit.INSTANCE;
        }
    }

    public final Object setUserColors(UserColorsSchemePersistence userColorsSchemePersistence, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C09892(userColorsSchemePersistence, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "Lzendesk/android/internal/usercolors/UserColorsSchemePersistence;", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.usercolors.UserColorsStorage$getUserColors$2", m37f = "UserColorsStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09882 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super UserColorsSchemePersistence>, Object> {
        int label;

        C09882(Continuation<? super C09882> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return UserColorsStorage.this.new C09882(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super UserColorsSchemePersistence> continuation) {
            return ((C09882) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            Storage storage = UserColorsStorage.this.storage;
            String name = UserColorsSchemePersistence.class.getName();
            if (name != null) {
                switch (name.hashCode()) {
                    case -2056817302:
                        if (name.equals("java.lang.Integer")) {
                            return (UserColorsSchemePersistence) storage.get(UserColorsStorage.KEY_USER_COLORS, Integer.TYPE);
                        }
                        break;
                    case -527879800:
                        if (name.equals("java.lang.Float")) {
                            return (UserColorsSchemePersistence) storage.get(UserColorsStorage.KEY_USER_COLORS, Float.TYPE);
                        }
                        break;
                    case 344809556:
                        if (name.equals("java.lang.Boolean")) {
                            return (UserColorsSchemePersistence) storage.get(UserColorsStorage.KEY_USER_COLORS, Boolean.TYPE);
                        }
                        break;
                    case 398795216:
                        if (name.equals("java.lang.Long")) {
                            return (UserColorsSchemePersistence) storage.get(UserColorsStorage.KEY_USER_COLORS, Long.TYPE);
                        }
                        break;
                }
            }
            return storage.get(UserColorsStorage.KEY_USER_COLORS, UserColorsSchemePersistence.class);
        }
    }

    public final Object getUserColors(Continuation<? super UserColorsSchemePersistence> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C09882(null), continuation);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.usercolors.UserColorsStorage$clear$2", m37f = "UserColorsStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09872 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C09872(Continuation<? super C09872> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return UserColorsStorage.this.new C09872(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09872) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                UserColorsStorage.this.storage.clear();
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object clear(Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C09872(null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\bÀ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0018\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\b¨\u0006\t"}, m18d2 = {"Lzendesk/android/internal/usercolors/UserColorsStorage$StorageProvider;", "", "()V", "createStorage", "Lzendesk/storage/android/Storage;", "context", "Landroid/content/Context;", "integrationId", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class StorageProvider {
        public static final StorageProvider INSTANCE = new StorageProvider();

        private StorageProvider() {
        }

        public final Storage createStorage(Context context, String integrationId) {
            Intrinsics.checkNotNullParameter(context, "context");
            return StorageFactory.INSTANCE.create(UserColorsStorage.USER_COLORS_STORAGE_NAMESPACE, context, new StorageType.Complex(new ZendeskStorageSerializer(KotlinxSerializationModule.INSTANCE.provideJson())), integrationId);
        }
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0082T¢\u0006\u0002\n\u0000¨\u0006\u0006"}, m18d2 = {"Lzendesk/android/internal/usercolors/UserColorsStorage$Companion;", "", "()V", "KEY_USER_COLORS", "", "USER_COLORS_STORAGE_NAMESPACE", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
