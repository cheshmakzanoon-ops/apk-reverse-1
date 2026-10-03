package zendesk.conversationkit.android.internal;

import java.util.UUID;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
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
import zendesk.conversationkit.android.model.VisitType;
import zendesk.faye.internal.Bayeux;
import zendesk.storage.android.PersistedProperty;
import zendesk.storage.android.Storage;

@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000 \u001f2\u00020\u0001:\u0001\u001fB\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u000e\u0010\u0019\u001a\u00020\u0006H\u0086@¢\u0006\u0002\u0010\u001aJ\u0010\u0010\u0012\u001a\u0004\u0018\u00010\u0006H\u0086@¢\u0006\u0002\u0010\u001aJ\u000e\u0010\u0016\u001a\u00020\u001bH\u0086@¢\u0006\u0002\u0010\u001aJ\u0018\u0010\u000b\u001a\u00020\u001c2\b\u0010\b\u001a\u0004\u0018\u00010\u0006H\u0086@¢\u0006\u0002\u0010\u001dJ\u0018\u0010\u0013\u001a\u00020\u001c2\b\u0010\u0011\u001a\u0004\u0018\u00010\u0006H\u0086@¢\u0006\u0002\u0010\u001dJ\u0016\u0010\u0017\u001a\u00020\u001c2\u0006\u0010\u0015\u001a\u00020\u001bH\u0086@¢\u0006\u0002\u0010\u001eR\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R/\u0010\b\u001a\u0004\u0018\u00010\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\u00068B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\r\u0010\u000e\u001a\u0004\b\t\u0010\n\"\u0004\b\u000b\u0010\fR\u000e\u0010\u000f\u001a\u00020\u0010X\u0082\u0004¢\u0006\u0002\n\u0000R/\u0010\u0011\u001a\u0004\u0018\u00010\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\u00068B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u0014\u0010\u000e\u001a\u0004\b\u0012\u0010\n\"\u0004\b\u0013\u0010\fR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R/\u0010\u0015\u001a\u0004\u0018\u00010\u00062\b\u0010\u0007\u001a\u0004\u0018\u00010\u00068B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u0018\u0010\u000e\u001a\u0004\b\u0016\u0010\n\"\u0004\b\u0017\u0010\f¨\u0006 "}, m18d2 = {"Lzendesk/conversationkit/android/internal/ConversationKitStorage;", "", "storage", "Lzendesk/storage/android/Storage;", "(Lzendesk/storage/android/Storage;)V", Bayeux.KEY_CLIENT_ID, "", "<set-?>", "integrationId", "getIntegrationId", "()Ljava/lang/String;", "setIntegrationId", "(Ljava/lang/String;)V", "integrationId$delegate", "Lzendesk/storage/android/PersistedProperty;", "persistenceDispatcher", "Lkotlinx/coroutines/ExecutorCoroutineDispatcher;", "pushToken", "getPushToken", "setPushToken", "pushToken$delegate", "visitType", "getVisitType", "setVisitType", "visitType$delegate", "getClientId", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Lzendesk/conversationkit/android/model/VisitType;", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "(Lzendesk/conversationkit/android/model/VisitType;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationKitStorage {
    static final KProperty<Object>[] $$delegatedProperties = {Reflection.mutableProperty1(new MutablePropertyReference1Impl(ConversationKitStorage.class, "pushToken", "getPushToken()Ljava/lang/String;", 0)), Reflection.mutableProperty1(new MutablePropertyReference1Impl(ConversationKitStorage.class, "integrationId", "getIntegrationId()Ljava/lang/String;", 0)), Reflection.mutableProperty1(new MutablePropertyReference1Impl(ConversationKitStorage.class, "visitType", "getVisitType()Ljava/lang/String;", 0))};
    private static final String KEY_CLIENT_ID = "CLIENT_ID";
    private static final String KEY_INTEGRATION_ID = "INTEGRATION_ID";
    private static final String KEY_PUSH_TOKEN = "PUSH_TOKEN";
    private static final String KEY_VISIT_TYPE = "VISIT_TYPE";
    private String clientId;

    private final PersistedProperty integrationId;
    private final ExecutorCoroutineDispatcher persistenceDispatcher;

    private final PersistedProperty pushToken;
    private final Storage storage;

    private final PersistedProperty visitType;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStorage", m37f = "ConversationKitStorage.kt", m38i = {0}, m39l = {86}, m40m = "getClientId", m41n = {"newClientId"}, m42s = {"L$0"})
    static final class C09991 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C09991(Continuation<? super C09991> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationKitStorage.this.getClientId(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStorage", m37f = "ConversationKitStorage.kt", m38i = {0}, m39l = {104}, m40m = "getVisitType", m41n = {"newVisit"}, m42s = {"L$0"})
    static final class C10021 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10021(Continuation<? super C10021> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationKitStorage.this.getVisitType(this);
        }
    }

    public ConversationKitStorage(Storage storage) {
        Object obj;
        Intrinsics.checkNotNullParameter(storage, "storage");
        this.storage = storage;
        ExecutorService executorServiceNewSingleThreadExecutor = Executors.newSingleThreadExecutor();
        Intrinsics.checkNotNullExpressionValue(executorServiceNewSingleThreadExecutor, "newSingleThreadExecutor(...)");
        this.persistenceDispatcher = ExecutorsKt.from(executorServiceNewSingleThreadExecutor);
        String name = String.class.getName();
        if (name != null) {
            switch (name) {
                case "java.lang.Integer":
                    obj = (String) storage.get(KEY_CLIENT_ID, Integer.TYPE);
                    break;
                case "java.lang.Float":
                    obj = (String) storage.get(KEY_CLIENT_ID, Float.TYPE);
                    break;
                case "java.lang.Boolean":
                    obj = (String) storage.get(KEY_CLIENT_ID, Boolean.TYPE);
                    break;
                case "java.lang.Long":
                    obj = (String) storage.get(KEY_CLIENT_ID, Long.TYPE);
                    break;
                default:
                    obj = storage.get(KEY_CLIENT_ID, String.class);
                    break;
            }
        } else {
            obj = storage.get(KEY_CLIENT_ID, String.class);
        }
        this.clientId = (String) obj;
        this.pushToken = new PersistedProperty(storage, KEY_PUSH_TOKEN, String.class);
        this.integrationId = new PersistedProperty(storage, KEY_INTEGRATION_ID, String.class);
        this.visitType = new PersistedProperty(storage, KEY_VISIT_TYPE, String.class);
    }

    public final String getPushToken() {
        return (String) this.pushToken.getValue(this, $$delegatedProperties[0]);
    }

    public final void setPushToken(String str) {
        this.pushToken.setValue(this, $$delegatedProperties[0], str);
    }

    private final String getIntegrationId() {
        return (String) this.integrationId.getValue(this, $$delegatedProperties[1]);
    }

    public final void setIntegrationId(String str) {
        this.integrationId.setValue(this, $$delegatedProperties[1], str);
    }

    private final String getVisitType() {
        return (String) this.visitType.getValue(this, $$delegatedProperties[2]);
    }

    public final void setVisitType(String str) {
        this.visitType.setValue(this, $$delegatedProperties[2], str);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u000e\n\u0002\u0018\u0002\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStorage$getPushToken$2", m37f = "ConversationKitStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10012 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super String>, Object> {
        int label;

        C10012(Continuation<? super C10012> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStorage.this.new C10012(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super String> continuation) {
            return ((C10012) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                return ConversationKitStorage.this.getPushToken();
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object getPushToken(Continuation<? super String> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C10012(null), continuation);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStorage$setPushToken$2", m37f = "ConversationKitStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10052 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $pushToken;
        int label;

        C10052(String str, Continuation<? super C10052> continuation) {
            super(2, continuation);
            this.$pushToken = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStorage.this.new C10052(this.$pushToken, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10052) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationKitStorage.this.setPushToken(this.$pushToken);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object setPushToken(String str, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10052(str, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStorage$setIntegrationId$2", m37f = "ConversationKitStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10042 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $integrationId;
        int label;

        C10042(String str, Continuation<? super C10042> continuation) {
            super(2, continuation);
            this.$integrationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStorage.this.new C10042(this.$integrationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10042) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationKitStorage.this.setIntegrationId(this.$integrationId);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object setIntegrationId(String str, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10042(str, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    public final Object getClientId(Continuation<? super String> continuation) throws Throwable {
        C09991 c09991;
        if (continuation instanceof C09991) {
            c09991 = (C09991) continuation;
            if ((c09991.label & Integer.MIN_VALUE) != 0) {
                c09991.label -= Integer.MIN_VALUE;
            } else {
                c09991 = new C09991(continuation);
            }
        } else {
            c09991 = new C09991(continuation);
        }
        Object obj = c09991.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09991.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            String str = (String) c09991.L$0;
            ResultKt.throwOnFailure(obj);
            return str;
        }
        ResultKt.throwOnFailure(obj);
        String str2 = this.clientId;
        if (str2 != null) {
            return str2;
        }
        String string = UUID.randomUUID().toString();
        Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
        this.clientId = string;
        ExecutorCoroutineDispatcher executorCoroutineDispatcher = this.persistenceDispatcher;
        C10003 c10003 = new C10003(string, null);
        c09991.L$0 = string;
        c09991.label = 1;
        return BuildersKt.withContext(executorCoroutineDispatcher, c10003, c09991) == coroutine_suspended ? coroutine_suspended : string;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStorage$getClientId$3", m37f = "ConversationKitStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10003 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $newClientId;
        int label;

        C10003(String str, Continuation<? super C10003> continuation) {
            super(2, continuation);
            this.$newClientId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStorage.this.new C10003(this.$newClientId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10003) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            ConversationKitStorage.this.storage.set(ConversationKitStorage.KEY_CLIENT_ID, this.$newClientId, String.class);
            return Unit.INSTANCE;
        }
    }

    public final Object getVisitType(Continuation<? super VisitType> continuation) throws Throwable {
        C10021 c10021;
        if (continuation instanceof C10021) {
            c10021 = (C10021) continuation;
            if ((c10021.label & Integer.MIN_VALUE) != 0) {
                c10021.label -= Integer.MIN_VALUE;
            } else {
                c10021 = new C10021(continuation);
            }
        } else {
            c10021 = new C10021(continuation);
        }
        Object obj = c10021.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10021.label;
        if (i != 0) {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            VisitType visitType = (VisitType) c10021.L$0;
            ResultKt.throwOnFailure(obj);
            return visitType;
        }
        ResultKt.throwOnFailure(obj);
        String visitType2 = getVisitType();
        if (visitType2 != null) {
            return VisitType.valueOf(visitType2);
        }
        VisitType visitType3 = VisitType.NEW;
        setVisitType(visitType3.name());
        ExecutorCoroutineDispatcher executorCoroutineDispatcher = this.persistenceDispatcher;
        C10033 c10033 = new C10033(null);
        c10021.L$0 = visitType3;
        c10021.label = 1;
        return BuildersKt.withContext(executorCoroutineDispatcher, c10033, c10021) == coroutine_suspended ? coroutine_suspended : visitType3;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStorage$getVisitType$3", m37f = "ConversationKitStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10033 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10033(Continuation<? super C10033> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStorage.this.new C10033(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10033) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            ConversationKitStorage.this.storage.set(ConversationKitStorage.KEY_VISIT_TYPE, "NEW", String.class);
            return Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStorage$setVisitType$2", m37f = "ConversationKitStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10062 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final VisitType $visitType;
        int label;

        C10062(VisitType visitType, Continuation<? super C10062> continuation) {
            super(2, continuation);
            this.$visitType = visitType;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStorage.this.new C10062(this.$visitType, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10062) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationKitStorage.this.setVisitType(this.$visitType.name());
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object setVisitType(VisitType visitType, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10062(visitType, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }
}
