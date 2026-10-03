package zendesk.conversationkit.android.internal.faye;

import cz.msebera.android.httpclient.HttpStatus;
import java.util.Map;
import java.util.concurrent.CancellationException;
import kotlin.Metadata;
import kotlin.Result;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.DebugProbesKt;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CancellableContinuation;
import kotlinx.coroutines.CancellableContinuationImpl;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.DelayKt;
import kotlinx.coroutines.JobKt__JobKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerializationException;
import kotlinx.serialization.json.Json;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.internal.ActionDispatcher;
import zendesk.conversationkit.android.internal.extension.SafeResumeWithExceptionKt;
import zendesk.conversationkit.android.internal.rest.model.MessageDto;
import zendesk.conversationkit.android.internal.rest.model.UserMergeDataDTO;
import zendesk.conversationkit.android.model.ActivityDataKt;
import zendesk.conversationkit.android.model.AuthenticationType;
import zendesk.conversationkit.android.model.ConversationStatus;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageKt;
import zendesk.conversationkit.android.model.RealtimeSettings;
import zendesk.conversationkit.android.model.UserMerge;
import zendesk.conversationkit.android.model.UserMergeKt;
import zendesk.faye.BayeuxOptionalFields;
import zendesk.faye.ConnectMessage;
import zendesk.faye.DisconnectMessage;
import zendesk.faye.FayeClient;
import zendesk.faye.FayeClientError;
import zendesk.faye.FayeClientListener;
import zendesk.faye.SubscribeMessage;
import zendesk.faye.internal.Bayeux;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationscreen.MessageContainerFactory;

@Metadata(m17d1 = {"\u0000\u009e\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u000b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0000\u0018\u0000 B2\u00020\u00012\u00020\u0002:\u0001BB5\u0012\u0006\u0010\u0003\u001a\u00020\u0004\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\u0006\u0010\r\u001a\u00020\u000e¢\u0006\u0002\u0010\u000fJ\u000e\u0010\u0015\u001a\u00020\u0016H\u0096@¢\u0006\u0002\u0010\u0017J\u0016\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001bH\u0096@¢\u0006\u0002\u0010\u001cJ\b\u0010\u001d\u001a\u00020\u0016H\u0016J\b\u0010\u0010\u001a\u00020\u0012H\u0016J\b\u0010\u001e\u001a\u00020\u0016H\u0016J\u001a\u0010\u001f\u001a\u00020\u00162\u0006\u0010 \u001a\u00020!2\b\u0010\"\u001a\u0004\u0018\u00010#H\u0016J\b\u0010$\u001a\u00020\u0016H\u0016J\b\u0010%\u001a\u00020\u0016H\u0016J\u0018\u0010&\u001a\u00020\u00162\u0006\u0010'\u001a\u00020\u001b2\u0006\u0010(\u001a\u00020\u001bH\u0016J\u0018\u0010)\u001a\u00020\u00162\u0006\u0010'\u001a\u00020\u001b2\u0006\u0010(\u001a\u00020\u001bH\u0016J\u0010\u0010*\u001a\u00020\u00162\u0006\u0010'\u001a\u00020\u001bH\u0016J\u0010\u0010+\u001a\u00020\u00162\u0006\u0010'\u001a\u00020\u001bH\u0016J \u0010,\u001a\u00020\u00162\u0006\u0010-\u001a\u00020\u001b2\u0006\u0010.\u001a\u00020/2\u0006\u00100\u001a\u000201H\u0002J\u0010\u00102\u001a\u00020\u00162\u0006\u0010-\u001a\u00020\u001bH\u0002J\u0010\u00103\u001a\u00020\u00162\u0006\u0010-\u001a\u00020\u001bH\u0002J.\u00104\u001a\u00020\u00162\u0006\u0010-\u001a\u00020\u001b2\u0006\u00105\u001a\u0002062\u0014\u00107\u001a\u0010\u0012\u0004\u0012\u00020\u001b\u0012\u0004\u0012\u000209\u0018\u000108H\u0002J\u0010\u0010:\u001a\u00020\u00162\u0006\u0010;\u001a\u00020<H\u0002J\u0018\u0010=\u001a\u00020\u00162\u0006\u0010-\u001a\u00020\u001b2\u0006\u0010(\u001a\u00020>H\u0002J\u0010\u0010?\u001a\u00020\u00162\u0006\u0010@\u001a\u00020AH\u0002R\u000e\u0010\t\u001a\u00020\nX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u00120\u0011X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u000b\u001a\u00020\fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\r\u001a\u00020\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0005\u001a\u00020\u0006X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006C"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/DefaultSunCoFayeClient;", "Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;", "Lzendesk/faye/FayeClientListener;", "fayeClient", "Lzendesk/faye/FayeClient;", "realtimeSettings", "Lzendesk/conversationkit/android/model/RealtimeSettings;", "authenticationType", "Lzendesk/conversationkit/android/model/AuthenticationType;", "actionDispatcher", "Lzendesk/conversationkit/android/internal/ActionDispatcher;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "json", "Lkotlinx/serialization/json/Json;", "(Lzendesk/faye/FayeClient;Lzendesk/conversationkit/android/model/RealtimeSettings;Lzendesk/conversationkit/android/model/AuthenticationType;Lzendesk/conversationkit/android/internal/ActionDispatcher;Lkotlinx/coroutines/CoroutineScope;Lkotlinx/serialization/json/Json;)V", "connectionStatus", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lzendesk/conversationkit/android/ConnectionStatus;", "currentConnectionAttempts", "", "awaitClientConnected", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitFileUploadResult", "Lzendesk/conversationkit/android/model/Message;", "messageId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "connect", "disconnect", "onClientError", "fayeClientError", "Lzendesk/faye/FayeClientError;", "throwable", "", "onConnectedToServer", "onDisconnectedFromServer", "onMessagePublished", Bayeux.KEY_CHANNEL, "message", "onMessageReceived", "onSubscribedToChannel", "onUnsubscribedFromChannel", "processActivityEvent", "conversationId", "activity", "Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;", "conversation", "Lzendesk/conversationkit/android/internal/faye/WsConversationDto;", "processConversationAddedEvent", "processConversationRemovedEvent", "processConversationUpdatedEvent", "status", "Lzendesk/conversationkit/android/model/ConversationStatus;", "metadata", "", "", "processEvent", "event", "Lorg/json/JSONObject;", "processMessageEvent", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "processUserMergeEvent", "userMerge", "Lzendesk/conversationkit/android/model/UserMerge;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultSunCoFayeClient implements SunCoFayeClient, FayeClientListener {
    private static final String JSON_EVENTS = "events";
    private static final String LOG_TAG = "SunCoFayeClient";
    private static final String SUBSCRIBE_EXT_FIELD_APP_ID = "appId";
    private static final String SUBSCRIBE_EXT_FIELD_APP_USER_ID = "appUserId";
    private static final String SUBSCRIBE_EXT_FIELD_JWT = "jwt";
    private static final String SUBSCRIBE_EXT_FIELD_SESSION_TOKEN = "sessionToken";
    private final ActionDispatcher actionDispatcher;
    private final AuthenticationType authenticationType;
    private MutableStateFlow<ConnectionStatus> connectionStatus;
    private final CoroutineScope coroutineScope;
    private int currentConnectionAttempts;
    private final FayeClient fayeClient;
    private final Json json;
    private final RealtimeSettings realtimeSettings;

    @Override
    public void onMessagePublished(String channel, String message) {
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(message, "message");
    }

    public DefaultSunCoFayeClient(FayeClient fayeClient, RealtimeSettings realtimeSettings, AuthenticationType authenticationType, ActionDispatcher actionDispatcher, CoroutineScope coroutineScope, Json json) {
        Intrinsics.checkNotNullParameter(fayeClient, "fayeClient");
        Intrinsics.checkNotNullParameter(realtimeSettings, "realtimeSettings");
        Intrinsics.checkNotNullParameter(authenticationType, "authenticationType");
        Intrinsics.checkNotNullParameter(actionDispatcher, "actionDispatcher");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        Intrinsics.checkNotNullParameter(json, "json");
        this.fayeClient = fayeClient;
        this.realtimeSettings = realtimeSettings;
        this.authenticationType = authenticationType;
        this.actionDispatcher = actionDispatcher;
        this.coroutineScope = coroutineScope;
        this.json = json;
        fayeClient.addListener(this);
        this.connectionStatus = StateFlowKt.MutableStateFlow(ConnectionStatus.DISCONNECTED);
    }

    @Override
    public void connect() {
        if (this.realtimeSettings.getEnabled()) {
            BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10621(null), 3, null);
            return;
        }
        Logger.m225w(LOG_TAG, "Realtime is not enabled for the user with id " + this.realtimeSettings.getUserId(), new Object[0]);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$connect$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {120, 123, 128}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10621 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10621(Continuation<? super C10621> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10621(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10621) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            MutableStateFlow mutableStateFlow;
            Object value2;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DelayKt.delay(DefaultSunCoFayeClient.this.realtimeSettings.getTimeUnit().toMillis(DefaultSunCoFayeClient.this.realtimeSettings.getConnectionDelay()), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i == 1) {
                    ResultKt.throwOnFailure(obj);
                } else if (i == 2) {
                    ResultKt.throwOnFailure(obj);
                    if (DefaultSunCoFayeClient.this.fayeClient.isConnected()) {
                        mutableStateFlow = DefaultSunCoFayeClient.this.connectionStatus;
                        do {
                            value2 = mutableStateFlow.getValue();
                        } while (!mutableStateFlow.compareAndSet(value2, ConnectionStatus.CONNECTED_REALTIME));
                        this.label = 3;
                        if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.RealtimeConnectionStatusUpdate(ConnectionStatus.CONNECTED_REALTIME), this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    }
                } else {
                    if (i != 3) {
                        throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                    ResultKt.throwOnFailure(obj);
                }
                return Unit.INSTANCE;
            }
            DefaultSunCoFayeClient.this.fayeClient.send(ConnectMessage.INSTANCE.builder().build());
            MutableStateFlow mutableStateFlow2 = DefaultSunCoFayeClient.this.connectionStatus;
            do {
                value = mutableStateFlow2.getValue();
            } while (!mutableStateFlow2.compareAndSet(value, ConnectionStatus.CONNECTING_REALTIME));
            this.label = 2;
            if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.RealtimeConnectionStatusUpdate(ConnectionStatus.CONNECTING_REALTIME), this) == coroutine_suspended) {
                return coroutine_suspended;
            }
            if (DefaultSunCoFayeClient.this.fayeClient.isConnected()) {
                mutableStateFlow = DefaultSunCoFayeClient.this.connectionStatus;
                do {
                    value2 = mutableStateFlow.getValue();
                } while (!mutableStateFlow.compareAndSet(value2, ConnectionStatus.CONNECTED_REALTIME));
                this.label = 3;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.RealtimeConnectionStatusUpdate(ConnectionStatus.CONNECTED_REALTIME), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            }
            return Unit.INSTANCE;
        }
    }

    @Override
    public void disconnect() {
        if (!this.realtimeSettings.getEnabled()) {
            Logger.m225w(LOG_TAG, "Realtime is not enabled for the user with id " + this.realtimeSettings.getUserId(), new Object[0]);
        } else {
            this.fayeClient.send(DisconnectMessage.INSTANCE.builder().build());
            JobKt__JobKt.cancelChildren$default(this.coroutineScope.getCoroutineContext(), (CancellationException) null, 1, (Object) null);
        }
    }

    @Override
    public void onClientError(FayeClientError fayeClientError, Throwable throwable) {
        Intrinsics.checkNotNullParameter(fayeClientError, "fayeClientError");
        Logger.m218e(LOG_TAG, fayeClientError.name(), throwable, new Object[0]);
        if (this.connectionStatus.getValue() != ConnectionStatus.CONNECTING_REALTIME && this.currentConnectionAttempts < this.realtimeSettings.getMaxConnectionAttempts()) {
            Logger.m217d(LOG_TAG, "Reconnecting in %d seconds... [%d/%d]", Long.valueOf(this.realtimeSettings.getRetryInterval()), Integer.valueOf(this.currentConnectionAttempts), Integer.valueOf(this.realtimeSettings.getMaxConnectionAttempts()));
            BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10631(null), 3, null);
        }
        if (this.currentConnectionAttempts > this.realtimeSettings.getMaxConnectionAttempts()) {
            Logger.m219e(LOG_TAG, "Failed to reconnect. Attempts exhausted.", new Object[0]);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$onClientError$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {173}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10631 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10631(Continuation<? super C10631> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10631(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10631) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DelayKt.delay(DefaultSunCoFayeClient.this.realtimeSettings.getTimeUnit().toMillis(DefaultSunCoFayeClient.this.realtimeSettings.getRetryInterval()), this) == coroutine_suspended) {
                    return coroutine_suspended;
                }
            } else {
                if (i != 1) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(obj);
            }
            DefaultSunCoFayeClient.this.currentConnectionAttempts++;
            DefaultSunCoFayeClient.this.fayeClient.send(ConnectMessage.INSTANCE.builder().build());
            return Unit.INSTANCE;
        }
    }

    @Override
    public void onConnectedToServer() {
        this.currentConnectionAttempts = 0;
        RealtimeSettings realtimeSettings = this.realtimeSettings;
        String str = "/sdk/apps/" + realtimeSettings.getAppId() + "/appusers/" + realtimeSettings.getUserId();
        RealtimeSettings realtimeSettings2 = this.realtimeSettings;
        JSONObject jSONObject = new JSONObject();
        try {
            jSONObject.put("appId", realtimeSettings2.getAppId());
            jSONObject.put("appUserId", realtimeSettings2.getUserId());
            AuthenticationType authenticationType = this.authenticationType;
            if (authenticationType instanceof AuthenticationType.SessionToken) {
                jSONObject.put(SUBSCRIBE_EXT_FIELD_SESSION_TOKEN, ((AuthenticationType.SessionToken) authenticationType).getValue());
            } else if (authenticationType instanceof AuthenticationType.Jwt) {
                jSONObject.put(SUBSCRIBE_EXT_FIELD_JWT, ((AuthenticationType.Jwt) authenticationType).getValue());
            } else {
                Intrinsics.areEqual(authenticationType, AuthenticationType.Unauthenticated.INSTANCE);
            }
        } catch (JSONException unused) {
        }
        String string = jSONObject.toString();
        Intrinsics.checkNotNullExpressionValue(string, "with(...)");
        this.fayeClient.send(SubscribeMessage.INSTANCE.builder(str).withOptionalFields(BayeuxOptionalFields.INSTANCE.builder().withExt(string).build()).build());
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$onDisconnectedFromServer$2", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {236}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10642 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10642(Continuation<? super C10642> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10642(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10642) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.RealtimeConnectionStatusUpdate(ConnectionStatus.DISCONNECTED), this) == coroutine_suspended) {
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

    @Override
    public void onDisconnectedFromServer() {
        MutableStateFlow<ConnectionStatus> mutableStateFlow = this.connectionStatus;
        while (!mutableStateFlow.compareAndSet(mutableStateFlow.getValue(), ConnectionStatus.DISCONNECTED)) {
        }
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10642(null), 3, null);
    }

    @Override
    public void onMessageReceived(String channel, String message) {
        Intrinsics.checkNotNullParameter(channel, "channel");
        Intrinsics.checkNotNullParameter(message, "message");
        try {
            JSONArray jSONArray = new JSONObject(message).getJSONArray(JSON_EVENTS);
            Intrinsics.checkNotNullExpressionValue(jSONArray, "getJSONArray(...)");
            int length = jSONArray.length();
            for (int i = 0; i < length; i++) {
                try {
                    JSONObject jSONObject = jSONArray.getJSONObject(i);
                    Intrinsics.checkNotNullExpressionValue(jSONObject, "getJSONObject(...)");
                    processEvent(jSONObject);
                } catch (JSONException e) {
                    Logger.m218e(LOG_TAG, "Unable to processed events: " + jSONArray, e, new Object[0]);
                }
            }
        } catch (JSONException e2) {
            Logger.m218e(LOG_TAG, "Unable to processed message: " + message, e2, new Object[0]);
        }
    }

    private final void processEvent(JSONObject event) {
        UserMergeDataDTO userMergeDataDTO;
        String string = event.toString();
        Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
        try {
            WsFayeMessageDto wsFayeMessageDto = (WsFayeMessageDto) this.json.decodeFromString(WsFayeMessageDto.INSTANCE.serializer(), string);
            String type = wsFayeMessageDto.getType();
            String id = wsFayeMessageDto.getConversation().getId();
            if (Intrinsics.areEqual(type, WsFayeMessageType.MESSAGE.getValue()) && wsFayeMessageDto.getMessage() != null) {
                if (id != null) {
                    processMessageEvent(id, wsFayeMessageDto.getMessage());
                    return;
                }
                return;
            }
            if (Intrinsics.areEqual(type, WsFayeMessageType.ACTIVITY.getValue()) && wsFayeMessageDto.getActivity() != null) {
                if (id != null) {
                    processActivityEvent(id, wsFayeMessageDto.getActivity(), wsFayeMessageDto.getConversation());
                    return;
                }
                return;
            }
            if (Intrinsics.areEqual(type, WsFayeMessageType.CONVERSATION_ADDED.getValue())) {
                if (id != null) {
                    processConversationAddedEvent(id);
                    return;
                }
                return;
            }
            if (Intrinsics.areEqual(type, WsFayeMessageType.CONVERSATION_REMOVED.getValue())) {
                if (id != null) {
                    processConversationRemovedEvent(id);
                    return;
                }
                return;
            }
            if (Intrinsics.areEqual(type, WsFayeMessageType.CONVERSATION_UPDATE.getValue())) {
                if (id == null || wsFayeMessageDto.getConversation().getStatus() == null) {
                    return;
                }
                processConversationUpdatedEvent(id, wsFayeMessageDto.getConversation().getStatus(), wsFayeMessageDto.getConversation().getMetadata());
                return;
            }
            if (Intrinsics.areEqual(type, WsFayeMessageType.USER_MERGE.getValue())) {
                try {
                    Json json = this.json;
                    KSerializer<UserMergeDataDTO> kSerializerSerializer = UserMergeDataDTO.INSTANCE.serializer();
                    String string2 = event.getJSONObject(Bayeux.KEY_DATA).toString();
                    Intrinsics.checkNotNullExpressionValue(string2, "toString(...)");
                    userMergeDataDTO = (UserMergeDataDTO) json.decodeFromString(kSerializerSerializer, string2);
                } catch (SerializationException unused) {
                    userMergeDataDTO = null;
                }
                if (userMergeDataDTO != null) {
                    processUserMergeEvent(UserMergeKt.toUserMerge(userMergeDataDTO));
                    return;
                }
                return;
            }
            Logger.m225w(LOG_TAG, "The message has a type which cannot be processed: " + wsFayeMessageDto, new Object[0]);
        } catch (SerializationException e) {
            Logger.m218e(LOG_TAG, "Failed to deserialize: " + string, e, new Object[0]);
        }
    }

    @Override
    public Object awaitClientConnected(Continuation<? super Unit> continuation) {
        if (this.connectionStatus.getValue() == ConnectionStatus.CONNECTED_REALTIME) {
            return Unit.INSTANCE;
        }
        final MutableStateFlow<ConnectionStatus> mutableStateFlow = this.connectionStatus;
        Object objCollect = FlowKt.collect(FlowKt.take(new Flow<ConnectionStatus>() {

            @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            public static final class C10602<T> implements FlowCollector {
                final FlowCollector $this_unsafeFlow;

                @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$awaitClientConnected$$inlined$filter$1$2", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {MessageContainerFactory.MAXIMUM_FILE_SIZE_IN_MB}, m40m = "emit", m41n = {}, m42s = {})
                public static final class AnonymousClass1 extends ContinuationImpl {
                    Object L$0;
                    Object L$1;
                    int label;
                    Object result;

                    public AnonymousClass1(Continuation continuation) {
                        super(continuation);
                    }

                    @Override
                    public final Object invokeSuspend(Object obj) {
                        this.result = obj;
                        this.label |= Integer.MIN_VALUE;
                        return C10602.this.emit(null, this);
                    }
                }

                public C10602(FlowCollector flowCollector) {
                    this.$this_unsafeFlow = flowCollector;
                }

                @Override
                public final Object emit(Object obj, Continuation continuation) throws Throwable {
                    AnonymousClass1 anonymousClass1;
                    if (continuation instanceof AnonymousClass1) {
                        anonymousClass1 = (AnonymousClass1) continuation;
                        if ((anonymousClass1.label & Integer.MIN_VALUE) != 0) {
                            anonymousClass1.label -= Integer.MIN_VALUE;
                        } else {
                            anonymousClass1 = new AnonymousClass1(continuation);
                        }
                    } else {
                        anonymousClass1 = new AnonymousClass1(continuation);
                    }
                    Object obj2 = anonymousClass1.result;
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    int i = anonymousClass1.label;
                    if (i == 0) {
                        ResultKt.throwOnFailure(obj2);
                        FlowCollector flowCollector = this.$this_unsafeFlow;
                        if (((ConnectionStatus) obj) == ConnectionStatus.CONNECTED_REALTIME) {
                            anonymousClass1.label = 1;
                            if (flowCollector.emit(obj, anonymousClass1) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                        }
                    } else {
                        if (i != 1) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj2);
                    }
                    return Unit.INSTANCE;
                }
            }

            @Override
            public Object collect(FlowCollector<? super ConnectionStatus> flowCollector, Continuation continuation2) {
                Object objCollect2 = mutableStateFlow.collect(new C10602(flowCollector), continuation2);
                return objCollect2 == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect2 : Unit.INSTANCE;
            }
        }, 1), continuation);
        return objCollect == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objCollect : Unit.INSTANCE;
    }

    @Override
    public ConnectionStatus connectionStatus() {
        return this.connectionStatus.getValue();
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$processMessageEvent$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {HttpStatus.SC_METHOD_FAILURE}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10711 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final MessageDto $message;
        int label;

        C10711(String str, MessageDto messageDto, Continuation<? super C10711> continuation) {
            super(2, continuation);
            this.$conversationId = str;
            this.$message = messageDto;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10711(this.$conversationId, this.$message, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10711) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.MessageReceived(this.$conversationId, MessageKt.toMessage$default(this.$message, null, null, 3, null)), this) == coroutine_suspended) {
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

    private final void processMessageEvent(String conversationId, MessageDto message) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10711(conversationId, message, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$processActivityEvent$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {443}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10671 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final WsActivityEventDto $activity;
        final WsConversationDto $conversation;
        final String $conversationId;
        int label;

        C10671(WsActivityEventDto wsActivityEventDto, String str, WsConversationDto wsConversationDto, Continuation<? super C10671> continuation) {
            super(2, continuation);
            this.$activity = wsActivityEventDto;
            this.$conversationId = str;
            this.$conversation = wsConversationDto;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10671(this.$activity, this.$conversationId, this.$conversation, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10671) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.ActivityEventReceived(ActivityDataKt.toActivityEvent(this.$activity, this.$conversationId, this.$conversation.getAppMakerLastRead())), this) == coroutine_suspended) {
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

    private final void processActivityEvent(String conversationId, WsActivityEventDto activity, WsConversationDto conversation) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10671(activity, conversationId, conversation, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$processConversationAddedEvent$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {456}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10681 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        int label;

        C10681(String str, Continuation<? super C10681> continuation) {
            super(2, continuation);
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10681(this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10681) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.ConversationAdded(this.$conversationId), this) == coroutine_suspended) {
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

    private final void processConversationAddedEvent(String conversationId) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10681(conversationId, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$processConversationRemovedEvent$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {469}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10691 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        int label;

        C10691(String str, Continuation<? super C10691> continuation) {
            super(2, continuation);
            this.$conversationId = str;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10691(this.$conversationId, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10691) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.ConversationRemoved(this.$conversationId), this) == coroutine_suspended) {
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

    private final void processConversationRemovedEvent(String conversationId) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10691(conversationId, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$processConversationUpdatedEvent$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {489}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10701 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final String $conversationId;
        final Map<String, Object> $metadata;
        final ConversationStatus $status;
        int label;

        C10701(String str, ConversationStatus conversationStatus, Map<String, ? extends Object> map, Continuation<? super C10701> continuation) {
            super(2, continuation);
            this.$conversationId = str;
            this.$status = conversationStatus;
            this.$metadata = map;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10701(this.$conversationId, this.$status, this.$metadata, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10701) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.ConversationUpdate(this.$conversationId, this.$status, this.$metadata), this) == coroutine_suspended) {
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

    private final void processConversationUpdatedEvent(String conversationId, ConversationStatus status, Map<String, ? extends Object> metadata) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10701(conversationId, status, metadata, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$processUserMergeEvent$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {HttpStatus.SC_HTTP_VERSION_NOT_SUPPORTED}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10721 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final UserMerge $userMerge;
        int label;

        C10721(UserMerge userMerge, Continuation<? super C10721> continuation) {
            super(2, continuation);
            this.$userMerge = userMerge;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10721(this.$userMerge, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10721) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.UserMergeReceived(this.$userMerge), this) == coroutine_suspended) {
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

    private final void processUserMergeEvent(UserMerge userMerge) {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10721(userMerge, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$onSubscribedToChannel$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {520}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10651 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10651(Continuation<? super C10651> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10651(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10651) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                MutableStateFlow mutableStateFlow = DefaultSunCoFayeClient.this.connectionStatus;
                do {
                    value = mutableStateFlow.getValue();
                } while (!mutableStateFlow.compareAndSet(value, ConnectionStatus.CONNECTED_REALTIME));
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.RealtimeConnectionStatusUpdate(ConnectionStatus.CONNECTED_REALTIME), this) == coroutine_suspended) {
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

    @Override
    public void onSubscribedToChannel(String channel) {
        Intrinsics.checkNotNullParameter(channel, "channel");
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10651(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.faye.DefaultSunCoFayeClient$onUnsubscribedFromChannel$1", m37f = "SunCoFayeClient.kt", m38i = {}, m39l = {534}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10661 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10661(Continuation<? super C10661> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultSunCoFayeClient.this.new C10661(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10661) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                MutableStateFlow mutableStateFlow = DefaultSunCoFayeClient.this.connectionStatus;
                do {
                    value = mutableStateFlow.getValue();
                } while (!mutableStateFlow.compareAndSet(value, ConnectionStatus.DISCONNECTED));
                this.label = 1;
                if (DefaultSunCoFayeClient.this.actionDispatcher.dispatch(new Action.RealtimeConnectionStatusUpdate(ConnectionStatus.DISCONNECTED), this) == coroutine_suspended) {
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

    @Override
    public void onUnsubscribedFromChannel(String channel) {
        Intrinsics.checkNotNullParameter(channel, "channel");
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C10661(null), 3, null);
    }

    @Override
    public Object awaitFileUploadResult(final String str, Continuation<? super Message> continuation) {
        CancellableContinuationImpl cancellableContinuationImpl = new CancellableContinuationImpl(IntrinsicsKt.intercepted(continuation), 1);
        cancellableContinuationImpl.initCancellability();
        final CancellableContinuationImpl cancellableContinuationImpl2 = cancellableContinuationImpl;
        final ?? r2 = new FayeClientListener() {
            @Override
            public void onConnectedToServer() {
            }

            @Override
            public void onMessagePublished(String channel, String message) {
                Intrinsics.checkNotNullParameter(channel, "channel");
                Intrinsics.checkNotNullParameter(message, "message");
            }

            @Override
            public void onSubscribedToChannel(String channel) {
                Intrinsics.checkNotNullParameter(channel, "channel");
            }

            @Override
            public void onDisconnectedFromServer() {
                this.this$0.fayeClient.removeListener(this);
                SafeResumeWithExceptionKt.safeResumeWithException(cancellableContinuationImpl2, new IllegalStateException("Faye disconnected from server"));
            }

            @Override
            public void onUnsubscribedFromChannel(String channel) {
                Intrinsics.checkNotNullParameter(channel, "channel");
                this.this$0.fayeClient.removeListener(this);
                SafeResumeWithExceptionKt.safeResumeWithException(cancellableContinuationImpl2, new IllegalStateException("Faye client unsubscribed from channel"));
            }

            @Override
            public void onMessageReceived(String channel, String message) {
                Intrinsics.checkNotNullParameter(channel, "channel");
                Intrinsics.checkNotNullParameter(message, "message");
                JSONArray jSONArray = new JSONObject(message).getJSONArray("events");
                Intrinsics.checkNotNullExpressionValue(jSONArray, "getJSONArray(...)");
                try {
                    JSONObject jSONObject = jSONArray.getJSONObject(0);
                    Json json = this.this$0.json;
                    KSerializer<WsFayeMessageDto> kSerializerSerializer = WsFayeMessageDto.INSTANCE.serializer();
                    String string = jSONObject.toString();
                    Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
                    WsFayeMessageDto wsFayeMessageDto = (WsFayeMessageDto) json.decodeFromString(kSerializerSerializer, string);
                    String type = wsFayeMessageDto.getType();
                    String string2 = null;
                    if (Intrinsics.areEqual(type, WsFayeMessageType.MESSAGE.getValue())) {
                        MessageDto message2 = wsFayeMessageDto.getMessage();
                        if (Intrinsics.areEqual(message2 != null ? message2.getId() : null, str)) {
                            this.this$0.fayeClient.removeListener(this);
                            CancellableContinuation<Message> cancellableContinuation = cancellableContinuationImpl2;
                            Result.Companion companion = Result.INSTANCE;
                            cancellableContinuation.resumeWith(Result.m296constructorimpl(MessageKt.toMessage$default(wsFayeMessageDto.getMessage(), null, null, 3, null)));
                            return;
                        }
                    }
                    if (Intrinsics.areEqual(type, WsFayeMessageType.UPLOAD_FAILED.getValue())) {
                        try {
                            string2 = jSONObject.getJSONObject(Bayeux.KEY_DATA).getString("messageId");
                        } catch (SerializationException unused) {
                        }
                        if (Intrinsics.areEqual(string2, str)) {
                            this.this$0.fayeClient.removeListener(this);
                            SafeResumeWithExceptionKt.safeResumeWithException(cancellableContinuationImpl2, new UnsupportedOperationException("Failed to upload file"));
                        }
                    }
                } catch (Exception e) {
                    Exception exc = e;
                    Logger.m218e("SunCoFayeClient", "Unable to processed events for file upload: " + jSONArray, exc, new Object[0]);
                    this.this$0.fayeClient.removeListener(this);
                    SafeResumeWithExceptionKt.safeResumeWithException(cancellableContinuationImpl2, exc);
                }
            }

            @Override
            public void onClientError(FayeClientError fayeClientError, Throwable throwable) {
                Intrinsics.checkNotNullParameter(fayeClientError, "fayeClientError");
                Logger.m218e("SunCoFayeClient", fayeClientError.name(), throwable, new Object[0]);
                this.this$0.fayeClient.removeListener(this);
                SafeResumeWithExceptionKt.safeResumeWithException(cancellableContinuationImpl2, new IllegalStateException("Faye client listener error"));
            }
        };
        this.fayeClient.addListener((FayeClientListener) r2);
        cancellableContinuationImpl2.invokeOnCancellation(new Function1<Throwable, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(Throwable th) {
                invoke2(th);
                return Unit.INSTANCE;
            }

            public final void invoke2(Throwable th) {
                this.this$0.fayeClient.removeListener(r2);
            }
        });
        Object result = cancellableContinuationImpl.getResult();
        if (result == IntrinsicsKt.getCOROUTINE_SUSPENDED()) {
            DebugProbesKt.probeCoroutineSuspended(continuation);
        }
        return result;
    }
}
