package zendesk.android.internal.frontendevents;

import java.util.UUID;
import java.util.concurrent.TimeUnit;
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
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.internal.frontendevents.p014di.FrontendEventsModule;
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.storage.android.Storage;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\b\u0001\u0018\u0000 \u00112\u00020\u0001:\u0001\u0011B\u001b\b\u0001\u0012\b\b\u0001\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\b\u0010\u0007\u001a\u00020\bH\u0002J\u000e\u0010\t\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010\nJ\u0010\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000eH\u0002J\b\u0010\u000f\u001a\u00020\u0010H\u0002R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0012"}, m18d2 = {"Lzendesk/android/internal/frontendevents/FrontendEventsStorage;", "", "storage", "Lzendesk/storage/android/Storage;", "persistenceDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "(Lzendesk/storage/android/Storage;Lkotlinx/coroutines/CoroutineDispatcher;)V", "createNewSUID", "", "getSUID", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "isOutOfDate", "", "storedTimestamp", "", "resetSUIDTimestamp", "", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FrontendEventsStorage {

    @Deprecated
    public static final String KEY_SUID = "suid";

    @Deprecated
    public static final String KEY_SUID_TIMESTAMP = "suid_timestamp";
    private final CoroutineDispatcher persistenceDispatcher;
    private final Storage storage;
    private static final Companion Companion = new Companion(null);
    private static final long OUT_OF_DATE_DURATION = TimeUnit.MINUTES.toMillis(30);

    @Inject
    public FrontendEventsStorage(@Named(FrontendEventsModule.FRONTEND_EVENTS_STORAGE) Storage storage, @Named(CoroutineDispatchersModule.PERSISTENCE_DISPATCHER) CoroutineDispatcher persistenceDispatcher) {
        Intrinsics.checkNotNullParameter(storage, "storage");
        Intrinsics.checkNotNullParameter(persistenceDispatcher, "persistenceDispatcher");
        this.storage = storage;
        this.persistenceDispatcher = persistenceDispatcher;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u000e\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.frontendevents.FrontendEventsStorage$getSUID$2", m37f = "FrontendEventsStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09532 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super String>, Object> {
        int label;

        C09532(Continuation<? super C09532> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return FrontendEventsStorage.this.new C09532(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super String> continuation) {
            return ((C09532) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                String str = (String) FrontendEventsStorage.this.storage.get(FrontendEventsStorage.KEY_SUID, String.class);
                Long l = (Long) FrontendEventsStorage.this.storage.get(FrontendEventsStorage.KEY_SUID_TIMESTAMP, Long.TYPE);
                long jLongValue = l != null ? l.longValue() : 0L;
                if (str == null) {
                    String strCreateNewSUID = FrontendEventsStorage.this.createNewSUID();
                    FrontendEventsStorage.this.resetSUIDTimestamp();
                    return strCreateNewSUID;
                }
                if (FrontendEventsStorage.this.isOutOfDate(jLongValue)) {
                    String strCreateNewSUID2 = FrontendEventsStorage.this.createNewSUID();
                    FrontendEventsStorage.this.resetSUIDTimestamp();
                    return strCreateNewSUID2;
                }
                FrontendEventsStorage.this.resetSUIDTimestamp();
                return str;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object getSUID(Continuation<? super String> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C09532(null), continuation);
    }

    public final String createNewSUID() {
        String string = UUID.randomUUID().toString();
        Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
        this.storage.set(KEY_SUID, string, String.class);
        return string;
    }

    public final void resetSUIDTimestamp() {
        this.storage.set(KEY_SUID_TIMESTAMP, Long.valueOf(System.currentTimeMillis()), Long.TYPE);
    }

    public final boolean isOutOfDate(long storedTimestamp) {
        return System.currentTimeMillis() - storedTimestamp > OUT_OF_DATE_DURATION;
    }

    @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0003\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\t¨\u0006\n"}, m18d2 = {"Lzendesk/android/internal/frontendevents/FrontendEventsStorage$Companion;", "", "()V", "KEY_SUID", "", "KEY_SUID_TIMESTAMP", "OUT_OF_DATE_DURATION", "", "getOUT_OF_DATE_DURATION", "()J", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final long getOUT_OF_DATE_DURATION() {
            return FrontendEventsStorage.OUT_OF_DATE_DURATION;
        }
    }
}
