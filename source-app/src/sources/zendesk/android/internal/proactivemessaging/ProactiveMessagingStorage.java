package zendesk.android.internal.proactivemessaging;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.inject.Inject;
import javax.inject.Named;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
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
import zendesk.android.internal.p013di.ZendeskInitializedComponentScope;
import zendesk.android.internal.proactivemessaging.p015di.ProactiveMessagingModule;
import zendesk.core.android.internal.p016di.CoroutineDispatchersModule;
import zendesk.storage.android.Storage;

@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0004\b\u0001\u0018\u0000 \u00102\u00020\u0001:\u0001\u0010B\u001b\b\u0001\u0012\b\b\u0001\u0010\u0002\u001a\u00020\u0003\u0012\b\b\u0001\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0016\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0086@¢\u0006\u0002\u0010\u000bJ\u0014\u0010\f\u001a\b\u0012\u0004\u0012\u00020\n0\rH\u0086@¢\u0006\u0002\u0010\u000eJ\u0016\u0010\u000f\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0086@¢\u0006\u0002\u0010\u000bR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/ProactiveMessagingStorage;", "", "storage", "Lzendesk/storage/android/Storage;", "persistenceDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "(Lzendesk/storage/android/Storage;Lkotlinx/coroutines/CoroutineDispatcher;)V", "addSendOnceCampaign", "", "campaignId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getSendOnceCampaignIds", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeSendOnceCampaign", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ProactiveMessagingStorage {
    private static final Companion Companion = new Companion(null);

    @Deprecated
    public static final String KEY_SEND_ONCE_CAMPAIGN_IDS = "ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS";
    private final CoroutineDispatcher persistenceDispatcher;
    private final Storage storage;

    @Inject
    public ProactiveMessagingStorage(@Named(ProactiveMessagingModule.PROACTIVE_MESSAGING_STORAGE) Storage storage, @Named(CoroutineDispatchersModule.PERSISTENCE_DISPATCHER) CoroutineDispatcher persistenceDispatcher) {
        Intrinsics.checkNotNullParameter(storage, "storage");
        Intrinsics.checkNotNullParameter(persistenceDispatcher, "persistenceDispatcher");
        this.storage = storage;
        this.persistenceDispatcher = persistenceDispatcher;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingStorage$addSendOnceCampaign$2", m37f = "ProactiveMessagingStorage.kt", m38i = {}, m39l = {32}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09712 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $campaignId;
        int label;

        C09712(String str, Continuation<? super C09712> continuation) {
            super(2, continuation);
            this.$campaignId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ProactiveMessagingStorage.this.new C09712(this.$campaignId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09712) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = ProactiveMessagingStorage.this.getSendOnceCampaignIds(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            List mutableList = CollectionsKt.toMutableList((Collection) obj);
            mutableList.add(this.$campaignId);
            ProactiveMessagingStorage.this.storage.set(ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS, new SendOnceCampaignsStorage(mutableList), SendOnceCampaignsStorage.class);
            return Unit.INSTANCE;
        }
    }

    public final Object addSendOnceCampaign(String str, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C09712(str, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingStorage$removeSendOnceCampaign$2", m37f = "ProactiveMessagingStorage.kt", m38i = {}, m39l = {39}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09732 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $campaignId;
        int label;

        C09732(String str, Continuation<? super C09732> continuation) {
            super(2, continuation);
            this.$campaignId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ProactiveMessagingStorage.this.new C09732(this.$campaignId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C09732) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                obj = ProactiveMessagingStorage.this.getSendOnceCampaignIds(this);
                if (obj == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            String str = this.$campaignId;
            ArrayList arrayList = new ArrayList();
            for (Object obj2 : (Iterable) obj) {
                if (!Intrinsics.areEqual((String) obj2, str)) {
                    arrayList.add(obj2);
                }
            }
            ProactiveMessagingStorage.this.storage.set(ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS, new SendOnceCampaignsStorage(arrayList), SendOnceCampaignsStorage.class);
            return Unit.INSTANCE;
        }
    }

    public final Object removeSendOnceCampaign(String str, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C09732(str, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\u0018\u0002\u0010\u0000\u001a\b\u0012\u0004\u0012\u00020\u00020\u0001*\u00020\u0003H\u008a@"}, m18d2 = {"<anonymous>", "", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.android.internal.proactivemessaging.ProactiveMessagingStorage$getSendOnceCampaignIds$2", m37f = "ProactiveMessagingStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C09722 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super List<? extends String>>, Object> {
        int label;

        C09722(Continuation<? super C09722> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ProactiveMessagingStorage.this.new C09722(continuation);
        }

        @Override
        public Object invoke(CoroutineScope coroutineScope, Continuation<? super List<? extends String>> continuation) {
            return invoke2(coroutineScope, (Continuation<? super List<String>>) continuation);
        }

        public final Object invoke2(CoroutineScope coroutineScope, Continuation<? super List<String>> continuation) {
            return ((C09722) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object obj2;
            List<String> campaignIds;
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            Storage storage = ProactiveMessagingStorage.this.storage;
            String name = SendOnceCampaignsStorage.class.getName();
            if (name != null) {
                switch (name) {
                    case "java.lang.Integer":
                        obj2 = (SendOnceCampaignsStorage) storage.get(ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS, Integer.TYPE);
                        break;
                    case "java.lang.Float":
                        obj2 = (SendOnceCampaignsStorage) storage.get(ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS, Float.TYPE);
                        break;
                    case "java.lang.Boolean":
                        obj2 = (SendOnceCampaignsStorage) storage.get(ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS, Boolean.TYPE);
                        break;
                    case "java.lang.Long":
                        obj2 = (SendOnceCampaignsStorage) storage.get(ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS, Long.TYPE);
                        break;
                    default:
                        obj2 = storage.get(ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS, SendOnceCampaignsStorage.class);
                        break;
                }
            } else {
                obj2 = storage.get(ProactiveMessagingStorage.KEY_SEND_ONCE_CAMPAIGN_IDS, SendOnceCampaignsStorage.class);
            }
            SendOnceCampaignsStorage sendOnceCampaignsStorage = (SendOnceCampaignsStorage) obj2;
            return (sendOnceCampaignsStorage == null || (campaignIds = sendOnceCampaignsStorage.getCampaignIds()) == null) ? CollectionsKt.emptyList() : campaignIds;
        }
    }

    public final Object getSendOnceCampaignIds(Continuation<? super List<String>> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C09722(null), continuation);
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0082\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002R\u000e\u0010\u0003\u001a\u00020\u0004X\u0086T¢\u0006\u0002\n\u0000¨\u0006\u0005"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/ProactiveMessagingStorage$Companion;", "", "()V", "KEY_SEND_ONCE_CAMPAIGN_IDS", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    private static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }
    }
}
