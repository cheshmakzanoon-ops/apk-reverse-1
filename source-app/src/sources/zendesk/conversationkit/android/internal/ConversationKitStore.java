package zendesk.conversationkit.android.internal;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.ConcurrentLinkedQueue;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.collections.CollectionsKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import net.aihelp.data.track.data.TrackType;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitEventListener;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.ConversationKitSettings;
import zendesk.conversationkit.android.internal.attachments.AttachmentDownloader;
import zendesk.conversationkit.android.internal.user.UserActionProcessor;
import zendesk.conversationkit.android.model.Config;
import zendesk.conversationkit.android.model.User;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000\u0096\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 =2\u00020\u0001:\u0001=BG\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011¢\u0006\u0002\u0010\u0012J\u000e\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020 J\u0015\u0010$\u001a\u00020\"2\u0006\u0010%\u001a\u00020\rH\u0000¢\u0006\u0002\b&J\"\u0010'\u001a\b\u0012\u0004\u0012\u0002H)0(\"\u0004\b\u0000\u0010)2\u0006\u0010*\u001a\u00020+H\u0096@¢\u0006\u0002\u0010,J\u000e\u0010-\u001a\u00020.H\u0086@¢\u0006\u0002\u0010/J\u0006\u00100\u001a\u00020\u0005J\u0010\u00101\u001a\u0004\u0018\u000102H\u0086@¢\u0006\u0002\u0010/J\u0006\u00103\u001a\u00020\u0003J\u001b\u00104\u001a\u00020\"2\f\u00105\u001a\b\u0012\u0004\u0012\u00020706H\u0000¢\u0006\u0002\b8J\u000e\u00109\u001a\u00020\"2\u0006\u0010#\u001a\u00020 J\u0016\u0010:\u001a\u00020\"2\f\u00105\u001a\b\u0012\u0004\u0012\u00020;06H\u0002J\u0012\u0010<\u001a\u00020\"*\b\u0012\u0004\u0012\u00020+06H\u0002R\u0014\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00150\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010\u0017\u001a\u00020\r2\u0006\u0010\u0016\u001a\u00020\r@BX\u0080\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\u001a\u001a\b\u0012\u0004\u0012\u00020\u00150\u001b¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\f\u001a\u00020\rX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u001e\u001a\b\u0012\u0004\u0012\u00020 0\u001fX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006>"}, m18d2 = {"Lzendesk/conversationkit/android/internal/ConversationKitStore;", "Lzendesk/conversationkit/android/internal/ActionDispatcher;", "conversationKitSettings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "config", "Lzendesk/conversationkit/android/model/Config;", "effectProcessor", "Lzendesk/conversationkit/android/internal/EffectProcessor;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "conversationKitDispatchers", "Lzendesk/conversationkit/android/internal/ConversationKitDispatchers;", "initialAccessLevel", "Lzendesk/conversationkit/android/internal/AccessLevel;", "connectivityObserver", "Lzendesk/conversationkit/android/internal/ConnectivityObserver;", "attachmentDownloader", "Lzendesk/conversationkit/android/internal/attachments/AttachmentDownloader;", "(Lzendesk/conversationkit/android/ConversationKitSettings;Lzendesk/conversationkit/android/model/Config;Lzendesk/conversationkit/android/internal/EffectProcessor;Lkotlinx/coroutines/CoroutineScope;Lzendesk/conversationkit/android/internal/ConversationKitDispatchers;Lzendesk/conversationkit/android/internal/AccessLevel;Lzendesk/conversationkit/android/internal/ConnectivityObserver;Lzendesk/conversationkit/android/internal/attachments/AttachmentDownloader;)V", "_connectionStatusFlow", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lzendesk/conversationkit/android/ConnectionStatus;", "<set-?>", "accessLevel", "getAccessLevel$zendesk_conversationkit_conversationkit_android", "()Lzendesk/conversationkit/android/internal/AccessLevel;", "connectionStatusFlow", "Lkotlinx/coroutines/flow/StateFlow;", "getConnectionStatusFlow", "()Lkotlinx/coroutines/flow/StateFlow;", "listeners", "Ljava/util/concurrent/ConcurrentLinkedQueue;", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "addEventListener", "", "listener", "changeAccessLevel", "newAccessLevel", "changeAccessLevel$zendesk_conversationkit_conversationkit_android", "dispatch", "Lzendesk/conversationkit/android/ConversationKitResult;", "T", "action", "Lzendesk/conversationkit/android/internal/Action;", "(Lzendesk/conversationkit/android/internal/Action;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getClientId", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getConfig", "getCurrentUser", "Lzendesk/conversationkit/android/model/User;", "getSettings", "notifyAllEventListeners", "events", "", "Lzendesk/conversationkit/android/ConversationKitEvent;", "notifyAllEventListeners$zendesk_conversationkit_conversationkit_android", "removeEventListener", "updateConnectionStatus", "Lzendesk/conversationkit/android/ConversationKitEvent$ConnectionStatusChanged;", "launchAll", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationKitStore implements ActionDispatcher {
    private static final String LOG_TAG = "ConversationKitStore";
    private final MutableStateFlow<ConnectionStatus> _connectionStatusFlow;
    private AccessLevel accessLevel;
    private final AttachmentDownloader attachmentDownloader;
    private final Config config;
    private final StateFlow<ConnectionStatus> connectionStatusFlow;
    private final ConnectivityObserver connectivityObserver;
    private final ConversationKitDispatchers conversationKitDispatchers;
    private final ConversationKitSettings conversationKitSettings;
    private final CoroutineScope coroutineScope;
    private final EffectProcessor effectProcessor;
    private final AccessLevel initialAccessLevel;
    private final ConcurrentLinkedQueue<ConversationKitEventListener> listeners;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStore", m37f = "ConversationKitStore.kt", m38i = {0, 1, 2, 2}, m39l = {145, 147, TrackType.TRACK_FAQ_CLICK_CUSTOMER_SERVICE, 162}, m40m = "dispatch", m41n = {"this", "this", "this", "effectResult"}, m42s = {"L$0", "L$0", "L$0", "L$1"})
    static final class C10091<T> extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C10091(Continuation<? super C10091> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationKitStore.this.dispatch(null, this);
        }
    }

    public ConversationKitStore(ConversationKitSettings conversationKitSettings, Config config, EffectProcessor effectProcessor, CoroutineScope coroutineScope, ConversationKitDispatchers conversationKitDispatchers, AccessLevel initialAccessLevel, ConnectivityObserver connectivityObserver, AttachmentDownloader attachmentDownloader) {
        Intrinsics.checkNotNullParameter(conversationKitSettings, "conversationKitSettings");
        Intrinsics.checkNotNullParameter(config, "config");
        Intrinsics.checkNotNullParameter(effectProcessor, "effectProcessor");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        Intrinsics.checkNotNullParameter(conversationKitDispatchers, "conversationKitDispatchers");
        Intrinsics.checkNotNullParameter(initialAccessLevel, "initialAccessLevel");
        Intrinsics.checkNotNullParameter(connectivityObserver, "connectivityObserver");
        Intrinsics.checkNotNullParameter(attachmentDownloader, "attachmentDownloader");
        this.conversationKitSettings = conversationKitSettings;
        this.config = config;
        this.effectProcessor = effectProcessor;
        this.coroutineScope = coroutineScope;
        this.conversationKitDispatchers = conversationKitDispatchers;
        this.initialAccessLevel = initialAccessLevel;
        this.connectivityObserver = connectivityObserver;
        this.attachmentDownloader = attachmentDownloader;
        this.accessLevel = initialAccessLevel;
        this.listeners = new ConcurrentLinkedQueue<>();
        MutableStateFlow<ConnectionStatus> MutableStateFlow = StateFlowKt.MutableStateFlow(ConnectionStatus.DISCONNECTED);
        this._connectionStatusFlow = MutableStateFlow;
        this.connectionStatusFlow = MutableStateFlow;
        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C10071(null), 3, null);
        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C10082(null), 3, null);
    }

    public ConversationKitStore(ConversationKitSettings conversationKitSettings, Config config, EffectProcessor effectProcessor, CoroutineScope coroutineScope, ConversationKitDispatchers conversationKitDispatchers, AccessLevel accessLevel, ConnectivityObserver connectivityObserver, AttachmentDownloader attachmentDownloader, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(conversationKitSettings, config, effectProcessor, coroutineScope, (i & 16) != 0 ? new DefaultConversationKitDispatchers() : conversationKitDispatchers, accessLevel, connectivityObserver, attachmentDownloader);
    }

    public final AccessLevel getAccessLevel() {
        return this.accessLevel;
    }

    public final StateFlow<ConnectionStatus> getConnectionStatusFlow() {
        return this.connectionStatusFlow;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStore$1", m37f = "ConversationKitStore.kt", m38i = {}, m39l = {63}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10071 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10071(Continuation<? super C10071> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStore.this.new C10071(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10071) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<ConnectionStatus> flowObserveNetworkState = ConversationKitStore.this.connectivityObserver.observeNetworkState();
                final ConversationKitStore conversationKitStore = ConversationKitStore.this;
                this.label = 1;
                if (flowObserveNetworkState.collect(new FlowCollector() {
                    @Override
                    public Object emit(Object obj2, Continuation continuation) {
                        return emit((ConnectionStatus) obj2, (Continuation<? super Unit>) continuation);
                    }

                    public final Object emit(ConnectionStatus connectionStatus, Continuation<? super Unit> continuation) throws Throwable {
                        Object objDispatch = conversationKitStore.dispatch(new Action.NetworkConnectionStatusUpdate(connectionStatus), continuation);
                        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
                    }
                }, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStore$2", m37f = "ConversationKitStore.kt", m38i = {}, m39l = {68}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10082 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10082(Continuation<? super C10082> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStore.this.new C10082(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10082) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<Action> attachmentChannel = ConversationKitStore.this.attachmentDownloader.getAttachmentChannel();
                final ConversationKitStore conversationKitStore = ConversationKitStore.this;
                this.label = 1;
                if (attachmentChannel.collect(new FlowCollector() {
                    @Override
                    public Object emit(Object obj2, Continuation continuation) {
                        return emit((Action) obj2, (Continuation<? super Unit>) continuation);
                    }

                    public final Object emit(Action action, Continuation<? super Unit> continuation) throws Throwable {
                        Object objDispatch = conversationKitStore.dispatch(action, continuation);
                        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
                    }
                }, this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            return Unit.INSTANCE;
        }
    }

    public final void addEventListener(ConversationKitEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        this.listeners.add(listener);
    }

    public final void removeEventListener(final ConversationKitEventListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        CollectionsKt.removeAll(this.listeners, new Function1<ConversationKitEventListener, Boolean>() {
            {
                super(1);
            }

            @Override
            public final Boolean invoke(ConversationKitEventListener conversationKitEventListener) {
                return Boolean.valueOf(Intrinsics.areEqual(conversationKitEventListener, listener));
            }
        });
    }

    public final ConversationKitSettings getConversationKitSettings() {
        return this.conversationKitSettings;
    }

    public final Config getConfig() {
        return this.config;
    }

    public final Object getClientId(Continuation<? super String> continuation) {
        return this.accessLevel.getClientId(continuation);
    }

    public final Object getCurrentUser(Continuation<? super User> continuation) {
        return this.accessLevel.getCurrentUser(continuation);
    }

    @Override
    public <T> Object dispatch(Action action, Continuation<? super ConversationKitResult<? extends T>> continuation) throws Throwable {
        C10091 c10091;
        UserActionProcessor userProcessor;
        ConversationKitStore conversationKitStore;
        ConversationKitStore conversationKitStore2;
        EffectProcessorResult effectProcessorResult;
        AccessLevel newAccessLevel;
        ArrayList arrayList;
        CoroutineDispatcher coroutineDispatcherMain;
        C10103 c10103;
        if (continuation instanceof C10091) {
            c10091 = (C10091) continuation;
            if ((c10091.label & Integer.MIN_VALUE) != 0) {
                c10091.label -= Integer.MIN_VALUE;
            } else {
                c10091 = new C10091(continuation);
            }
        } else {
            c10091 = new C10091(continuation);
        }
        Object objProcess = c10091.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10091.label;
        if (i != 0) {
            if (i == 1) {
                conversationKitStore = (ConversationKitStore) c10091.L$0;
                ResultKt.throwOnFailure(objProcess);
            } else if (i == 2) {
                conversationKitStore = (ConversationKitStore) c10091.L$0;
                ResultKt.throwOnFailure(objProcess);
                conversationKitStore2 = conversationKitStore;
                effectProcessorResult = (EffectProcessorResult) objProcess;
                newAccessLevel = effectProcessorResult.getNewAccessLevel();
                if (newAccessLevel != null) {
                    conversationKitStore2.m203xa8237560(newAccessLevel);
                }
                List<ConversationKitEvent> events = effectProcessorResult.getEvents();
                arrayList = new ArrayList();
                for (T t : events) {
                    if (t instanceof ConversationKitEvent.ConnectionStatusChanged) {
                        arrayList.add(t);
                    }
                }
                conversationKitStore2.updateConnectionStatus(arrayList);
                coroutineDispatcherMain = conversationKitStore2.conversationKitDispatchers.main();
                c10103 = conversationKitStore2.new C10103(effectProcessorResult, null);
                c10091.L$0 = conversationKitStore2;
                c10091.L$1 = effectProcessorResult;
                c10091.label = 3;
                if (BuildersKt.withContext(coroutineDispatcherMain, c10103, c10091) == coroutine_suspended) {
                    return coroutine_suspended;
                }
                conversationKitStore2.launchAll(effectProcessorResult.getSupplementaryActions());
                if (!(effectProcessorResult instanceof EffectProcessorResult.Continues)) {
                    if (!(effectProcessorResult instanceof EffectProcessorResult.Ends)) {
                        throw new NoWhenBranchMatchedException();
                    }
                    ConversationKitResult<Object> result = ((EffectProcessorResult.Ends) effectProcessorResult).getResult();
                    Intrinsics.checkNotNull(result, "null cannot be cast to non-null type zendesk.conversationkit.android.ConversationKitResult<T of zendesk.conversationkit.android.internal.ConversationKitStore.dispatch>");
                    return result;
                }
                Action followingAction = ((EffectProcessorResult.Continues) effectProcessorResult).getFollowingAction();
                c10091.L$0 = null;
                c10091.L$1 = null;
                c10091.label = 4;
                objProcess = conversationKitStore2.dispatch(followingAction, c10091);
                if (objProcess == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else if (i == 3) {
                effectProcessorResult = (EffectProcessorResult) c10091.L$1;
                conversationKitStore2 = (ConversationKitStore) c10091.L$0;
                ResultKt.throwOnFailure(objProcess);
                conversationKitStore2.launchAll(effectProcessorResult.getSupplementaryActions());
                if (!(effectProcessorResult instanceof EffectProcessorResult.Continues)) {
                    if (!(effectProcessorResult instanceof EffectProcessorResult.Ends)) {
                        throw new NoWhenBranchMatchedException();
                    }
                    ConversationKitResult<Object> result2 = ((EffectProcessorResult.Ends) effectProcessorResult).getResult();
                    Intrinsics.checkNotNull(result2, "null cannot be cast to non-null type zendesk.conversationkit.android.ConversationKitResult<T of zendesk.conversationkit.android.internal.ConversationKitStore.dispatch>");
                    return result2;
                }
                Action followingAction2 = ((EffectProcessorResult.Continues) effectProcessorResult).getFollowingAction();
                c10091.L$0 = null;
                c10091.L$1 = null;
                c10091.label = 4;
                objProcess = conversationKitStore2.dispatch(followingAction2, c10091);
                if (objProcess == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 4) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(objProcess);
            }
            return objProcess;
        }
        ResultKt.throwOnFailure(objProcess);
        AccessLevel accessLevel = this.accessLevel;
        if (accessLevel instanceof AppAccess) {
            userProcessor = ((AppAccess) accessLevel).getAppProcessor();
        } else {
            if (!(accessLevel instanceof UserAccess)) {
                throw new NoWhenBranchMatchedException();
            }
            userProcessor = ((UserAccess) accessLevel).getUserProcessor();
        }
        c10091.L$0 = this;
        c10091.label = 1;
        objProcess = userProcessor.process(action, c10091);
        if (objProcess == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversationKitStore = this;
        EffectProcessor effectProcessor = conversationKitStore.effectProcessor;
        c10091.L$0 = conversationKitStore;
        c10091.label = 2;
        objProcess = effectProcessor.process((Effect) objProcess, c10091);
        if (objProcess == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversationKitStore2 = conversationKitStore;
        effectProcessorResult = (EffectProcessorResult) objProcess;
        newAccessLevel = effectProcessorResult.getNewAccessLevel();
        if (newAccessLevel != null) {
            conversationKitStore2.m203xa8237560(newAccessLevel);
        }
        List<ConversationKitEvent> events2 = effectProcessorResult.getEvents();
        arrayList = new ArrayList();
        while (r11.hasNext()) {
            if (t instanceof ConversationKitEvent.ConnectionStatusChanged) {
                arrayList.add(t);
            }
        }
        conversationKitStore2.updateConnectionStatus(arrayList);
        coroutineDispatcherMain = conversationKitStore2.conversationKitDispatchers.main();
        c10103 = conversationKitStore2.new C10103(effectProcessorResult, null);
        c10091.L$0 = conversationKitStore2;
        c10091.L$1 = effectProcessorResult;
        c10091.label = 3;
        if (BuildersKt.withContext(coroutineDispatcherMain, c10103, c10091) == coroutine_suspended) {
            return coroutine_suspended;
        }
        conversationKitStore2.launchAll(effectProcessorResult.getSupplementaryActions());
        if (!(effectProcessorResult instanceof EffectProcessorResult.Continues)) {
            if (!(effectProcessorResult instanceof EffectProcessorResult.Ends)) {
                throw new NoWhenBranchMatchedException();
            }
            ConversationKitResult<Object> result3 = ((EffectProcessorResult.Ends) effectProcessorResult).getResult();
            Intrinsics.checkNotNull(result3, "null cannot be cast to non-null type zendesk.conversationkit.android.ConversationKitResult<T of zendesk.conversationkit.android.internal.ConversationKitStore.dispatch>");
            return result3;
        }
        Action followingAction3 = ((EffectProcessorResult.Continues) effectProcessorResult).getFollowingAction();
        c10091.L$0 = null;
        c10091.L$1 = null;
        c10091.label = 4;
        objProcess = conversationKitStore2.dispatch(followingAction3, c10091);
        if (objProcess == coroutine_suspended) {
            return coroutine_suspended;
        }
        return objProcess;
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\u00020\u0003H\u008a@"}, m18d2 = {"<anonymous>", "", "T", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.ConversationKitStore$dispatch$3", m37f = "ConversationKitStore.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10103 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final EffectProcessorResult $effectResult;
        int label;

        C10103(EffectProcessorResult effectProcessorResult, Continuation<? super C10103> continuation) {
            super(2, continuation);
            this.$effectResult = effectProcessorResult;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return ConversationKitStore.this.new C10103(this.$effectResult, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10103) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            ConversationKitStore.this.m204xb3d1d52d(this.$effectResult.getEvents());
            return Unit.INSTANCE;
        }
    }

    private final void updateConnectionStatus(List<ConversationKitEvent.ConnectionStatusChanged> events) {
        Iterator<T> it = events.iterator();
        while (it.hasNext()) {
            this._connectionStatusFlow.setValue(((ConversationKitEvent.ConnectionStatusChanged) it.next()).getConnectionStatus());
        }
    }

    public final void m203xa8237560(AccessLevel newAccessLevel) {
        Intrinsics.checkNotNullParameter(newAccessLevel, "newAccessLevel");
        Logger.m217d(LOG_TAG, "Changing access level to " + newAccessLevel.getLogName(), new Object[0]);
        this.accessLevel = newAccessLevel;
    }

    public final void m204xb3d1d52d(List<? extends ConversationKitEvent> events) {
        Intrinsics.checkNotNullParameter(events, "events");
        for (ConversationKitEvent conversationKitEvent : events) {
            Iterator<ConversationKitEventListener> it = this.listeners.iterator();
            while (it.hasNext()) {
                it.next().onEvent(conversationKitEvent);
            }
        }
    }

    private final void launchAll(List<? extends Action> list) {
        Iterator<T> it = list.iterator();
        while (it.hasNext()) {
            BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new ConversationKitStore$launchAll$1$1(this, (Action) it.next(), null), 3, null);
        }
    }
}
