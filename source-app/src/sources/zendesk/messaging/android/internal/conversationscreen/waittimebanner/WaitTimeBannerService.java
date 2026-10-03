package zendesk.messaging.android.internal.conversationscreen.waittimebanner;

import cz.msebera.android.httpclient.HttpStatus;
import java.util.concurrent.TimeUnit;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.functions.Function3;
import kotlin.jvm.functions.Function4;
import kotlin.jvm.internal.Intrinsics;
import kotlin.ranges.RangesKt;
import kotlin.text.StringsKt;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.DelayKt;
import kotlinx.coroutines.channels.Channel;
import kotlinx.coroutines.channels.ChannelKt;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import kotlinx.coroutines.flow.FlowKt;
import kotlinx.coroutines.flow.MutableStateFlow;
import kotlinx.coroutines.flow.StateFlowKt;
import net.aihelp.data.track.data.TrackType;
import retrofit2.HttpException;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.ConversationKitEventListener;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.internal.faye.WsResponseTimeDto;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.ActivityEvent;
import zendesk.conversationkit.android.model.ConfigKt;
import zendesk.conversationkit.android.model.ConversationRoutingStatus;
import zendesk.conversationkit.android.model.ResponseTimeDto;
import zendesk.conversationkit.android.model.RestRetryPolicy;
import zendesk.conversationkit.android.model.WaitTimeConfig;
import zendesk.conversationkit.android.model.WaitTimeConfigKt;
import zendesk.conversationkit.android.model.WaitTimeData;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationscreen.ConversationScreenEvent;
import zendesk.p026ui.android.conversation.waittimebanner.ResponseTime;
import zendesk.p026ui.android.conversation.waittimebanner.WaitTimeBannerType;

@Metadata(m17d1 = {"\u0000\u0082\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0010\t\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u0000 ;2\u00020\u0001:\u0001;B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0006\u0010\u0019\u001a\u00020\u001aJ\u0016\u0010\u001b\u001a\u00020\u001a2\u0006\u0010\r\u001a\u00020\u000eH\u0082@¢\u0006\u0002\u0010\u001cJ\u001a\u0010\u001d\u001a\u00020\u001a2\u0006\u0010\u001e\u001a\u00020\u001f2\b\u0010 \u001a\u0004\u0018\u00010!H\u0002J\b\u0010\"\u001a\u00020#H\u0002J\b\u0010$\u001a\u00020#H\u0002J\f\u0010%\u001a\b\u0012\u0004\u0012\u00020\u001a0\u0010J\u0010\u0010&\u001a\u00020\u001a2\u0006\u0010'\u001a\u00020\u001fH\u0002J5\u0010(\u001a\u00020\f2\b\u0010)\u001a\u0004\u0018\u00010*2\b\u0010+\u001a\u0004\u0018\u00010*2\b\u0010,\u001a\u0004\u0018\u00010\u00162\b\u0010-\u001a\u0004\u0018\u00010\u0016H\u0002¢\u0006\u0002\u0010.J\u0010\u0010/\u001a\u00020\u001a2\u0006\u0010'\u001a\u000200H\u0002J\u0010\u00101\u001a\u00020\u001a2\u0006\u0010'\u001a\u000202H\u0002J\b\u00103\u001a\u00020\u001aH\u0002J\u000e\u00104\u001a\u00020\u001a2\u0006\u0010\r\u001a\u00020\u000eJ\u0006\u00105\u001a\u00020\u001aJ%\u00106\u001a\u00020#*\u0002072\b\u0010,\u001a\u0004\u0018\u00010\u00162\b\u0010-\u001a\u0004\u0018\u00010\u0016H\u0002¢\u0006\u0002\u00108J%\u00109\u001a\u00020#*\u0002072\b\u0010)\u001a\u0004\u0018\u00010*2\b\u0010+\u001a\u0004\u0018\u00010*H\u0002¢\u0006\u0002\u0010:R\u0014\u0010\u0007\u001a\b\u0012\u0004\u0012\u00020\t0\bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\n\u001a\b\u0012\u0004\u0012\u00020\f0\u000bX\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\r\u001a\u0004\u0018\u00010\u000eX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u0017\u0010\u000f\u001a\b\u0012\u0004\u0012\u00020\t0\u0010¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u000e\u0010\u0013\u001a\u00020\u0014X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0015\u001a\u00020\u0016X\u0082\u000e¢\u0006\u0002\n\u0000R\u0017\u0010\u0017\u001a\b\u0012\u0004\u0012\u00020\f0\u0010¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0012¨\u0006<"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/waittimebanner/WaitTimeBannerService;", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "(Lzendesk/conversationkit/android/ConversationKit;Lkotlinx/coroutines/CoroutineScope;)V", "_eventsChannel", "Lkotlinx/coroutines/channels/Channel;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;", "_waitTimeBannerType", "Lkotlinx/coroutines/flow/MutableStateFlow;", "Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "conversationId", "", "eventsChannel", "Lkotlinx/coroutines/flow/Flow;", "getEventsChannel", "()Lkotlinx/coroutines/flow/Flow;", "listener", "Lzendesk/conversationkit/android/ConversationKitEventListener;", "retries", "", "waitTimeBannerState", "getWaitTimeBannerState", "checkPollingStatus", "", "getWaitTimeForConversation", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handleWaitTimeExpectationEvent", "activityEventReceived", "Lzendesk/conversationkit/android/ConversationKitEvent$ActivityEventReceived;", "activityData", "Lzendesk/conversationkit/android/model/ActivityData;", "isBannerStateQueued", "", "isWaitTimeBannerEnabled", "pollingWithRetries", "processActivityEventReceivedEvent", "event", "processBannerStateUpdate", "lowerResponseTime", "", "upperResponseTime", "queuePosition", "lowestQueuePosition", "(Ljava/lang/Long;Ljava/lang/Long;Ljava/lang/Integer;Ljava/lang/Integer;)Lzendesk/ui/android/conversation/waittimebanner/WaitTimeBannerType;", "processConnectionStatusChangedEvent", "Lzendesk/conversationkit/android/ConversationKitEvent$ConnectionStatusChanged;", "processConversationUpdatedEvent", "Lzendesk/conversationkit/android/ConversationKitEvent$ConversationUpdated;", "processUserAccessRevokedEvent", "subscribe", "unsubscribe", "shouldDisplayQueuePosition", "Lzendesk/conversationkit/android/model/WaitTimeConfig;", "(Lzendesk/conversationkit/android/model/WaitTimeConfig;Ljava/lang/Integer;Ljava/lang/Integer;)Z", "shouldDisplayResponseTime", "(Lzendesk/conversationkit/android/model/WaitTimeConfig;Ljava/lang/Long;Ljava/lang/Long;)Z", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class WaitTimeBannerService {
    private static final String LOG_TAG = "WaitTimeBannerService";
    private static final int MINIMUM_QUEUE_POSITION = 1;
    private static final int TOO_MANY_REQUEST_HTTP_CODE = 429;
    private final Channel<ConversationScreenEvent> _eventsChannel;
    private final MutableStateFlow<WaitTimeBannerType> _waitTimeBannerType;
    private String conversationId;
    private final ConversationKit conversationKit;
    private final CoroutineScope coroutineScope;
    private final Flow<ConversationScreenEvent> eventsChannel;
    private final ConversationKitEventListener listener;
    private int retries;
    private final Flow<WaitTimeBannerType> waitTimeBannerState;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    public class WhenMappings {
        public static final int[] $EnumSwitchMapping$0;
        public static final int[] $EnumSwitchMapping$1;

        static {
            int[] iArr = new int[ConversationRoutingStatus.values().length];
            try {
                iArr[ConversationRoutingStatus.QUEUED.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                iArr[ConversationRoutingStatus.ASSIGNED.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                iArr[ConversationRoutingStatus.UNKNOWN.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            $EnumSwitchMapping$0 = iArr;
            int[] iArr2 = new int[ActivityData.values().length];
            try {
                iArr2[ActivityData.CONVERSATION_ROUTING_QUEUED.ordinal()] = 1;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                iArr2[ActivityData.CONVERSATION_ROUTING_ASSIGNED.ordinal()] = 2;
            } catch (NoSuchFieldError unused5) {
            }
            try {
                iArr2[ActivityData.CONVERSATION_ROUTING_CLEARED.ordinal()] = 3;
            } catch (NoSuchFieldError unused6) {
            }
            $EnumSwitchMapping$1 = iArr2;
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService", m37f = "WaitTimeBannerService.kt", m38i = {0}, m39l = {TrackType.TRACK_FAQ_CHECKED_IN_RPA_BOT}, m40m = "getWaitTimeForConversation", m41n = {"this"}, m42s = {"L$0"})
    static final class C14511 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C14511(Continuation<? super C14511> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return WaitTimeBannerService.this.getWaitTimeForConversation(null, this);
        }
    }

    public WaitTimeBannerService(ConversationKit conversationKit, CoroutineScope coroutineScope) {
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        this.conversationKit = conversationKit;
        this.coroutineScope = coroutineScope;
        MutableStateFlow<WaitTimeBannerType> MutableStateFlow = StateFlowKt.MutableStateFlow(WaitTimeBannerType.Cleared.INSTANCE);
        this._waitTimeBannerType = MutableStateFlow;
        this.waitTimeBannerState = FlowKt.onEach(MutableStateFlow, new WaitTimeBannerService$waitTimeBannerState$1(this, null));
        Channel<ConversationScreenEvent> channelChannel$default = ChannelKt.Channel$default(0, null, null, 7, null);
        this._eventsChannel = channelChannel$default;
        this.eventsChannel = FlowKt.receiveAsFlow(channelChannel$default);
        this.listener = new ConversationKitEventListener() {
            @Override
            public final void onEvent(ConversationKitEvent conversationKitEvent) {
                WaitTimeBannerService.listener$lambda$0(this.f$0, conversationKitEvent);
            }
        };
    }

    public final Flow<WaitTimeBannerType> getWaitTimeBannerState() {
        return this.waitTimeBannerState;
    }

    public final Flow<ConversationScreenEvent> getEventsChannel() {
        return this.eventsChannel;
    }

    public static final void listener$lambda$0(WaitTimeBannerService this$0, ConversationKitEvent event) {
        Intrinsics.checkNotNullParameter(this$0, "this$0");
        Intrinsics.checkNotNullParameter(event, "event");
        if (event instanceof ConversationKitEvent.ActivityEventReceived) {
            this$0.processActivityEventReceivedEvent((ConversationKitEvent.ActivityEventReceived) event);
            return;
        }
        if (event instanceof ConversationKitEvent.ConversationUpdated) {
            this$0.processConversationUpdatedEvent((ConversationKitEvent.ConversationUpdated) event);
        } else if (event instanceof ConversationKitEvent.ConnectionStatusChanged) {
            this$0.processConnectionStatusChangedEvent((ConversationKitEvent.ConnectionStatusChanged) event);
        } else if (event instanceof ConversationKitEvent.UserAccessRevoked) {
            this$0.processUserAccessRevokedEvent();
        }
    }

    private final void processActivityEventReceivedEvent(ConversationKitEvent.ActivityEventReceived event) {
        if (Intrinsics.areEqual(event.getActivityEvent().getConversationId(), this.conversationId)) {
            handleWaitTimeExpectationEvent(event, event.getActivityEvent().getActivityData());
        }
    }

    private final void processConversationUpdatedEvent(ConversationKitEvent.ConversationUpdated event) {
        if (Intrinsics.areEqual(event.getConversation().getId(), this.conversationId)) {
            int i = WhenMappings.$EnumSwitchMapping$0[event.getConversation().getRoutingStatus().ordinal()];
            if (i == 1) {
                if (isBannerStateQueued()) {
                    return;
                }
                BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C14571(null), 3, null);
            } else if (i == 2) {
                MutableStateFlow<WaitTimeBannerType> mutableStateFlow = this._waitTimeBannerType;
                while (!mutableStateFlow.compareAndSet(mutableStateFlow.getValue(), WaitTimeBannerType.Assigned.INSTANCE)) {
                }
            } else {
                if (i != 3) {
                    return;
                }
                MutableStateFlow<WaitTimeBannerType> mutableStateFlow2 = this._waitTimeBannerType;
                while (!mutableStateFlow2.compareAndSet(mutableStateFlow2.getValue(), WaitTimeBannerType.Cleared.INSTANCE)) {
                }
            }
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$processConversationUpdatedEvent$1", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {129}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14571 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14571(Continuation<? super C14571> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return WaitTimeBannerService.this.new C14571(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14571) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (WaitTimeBannerService.this._eventsChannel.send(ConversationScreenEvent.StartPolling.INSTANCE, this) == coroutine_suspended) {
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$processConnectionStatusChangedEvent$1", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {TrackType.TRACK_FAQ_MARKED_UNHELPFUL}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14561 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14561(Continuation<? super C14561> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return WaitTimeBannerService.this.new C14561(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14561) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (WaitTimeBannerService.this._eventsChannel.send(ConversationScreenEvent.StopPolling.INSTANCE, this) == coroutine_suspended) {
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

    private final void processConnectionStatusChangedEvent(ConversationKitEvent.ConnectionStatusChanged event) {
        if (event.getConnectionStatus() == ConnectionStatus.DISCONNECTED) {
            BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C14561(null), 3, null);
        } else {
            checkPollingStatus();
        }
    }

    private final void processUserAccessRevokedEvent() {
        MutableStateFlow<WaitTimeBannerType> mutableStateFlow = this._waitTimeBannerType;
        while (!mutableStateFlow.compareAndSet(mutableStateFlow.getValue(), WaitTimeBannerType.Cleared.INSTANCE)) {
        }
    }

    public final void subscribe(String conversationId) {
        Intrinsics.checkNotNullParameter(conversationId, "conversationId");
        if (isWaitTimeBannerEnabled()) {
            this.conversationId = conversationId;
            this.conversationKit.addEventListener(this.listener);
        }
    }

    public final void unsubscribe() {
        if (isWaitTimeBannerEnabled()) {
            this.conversationId = null;
            this.retries = 0;
            MutableStateFlow<WaitTimeBannerType> mutableStateFlow = this._waitTimeBannerType;
            while (!mutableStateFlow.compareAndSet(mutableStateFlow.getValue(), WaitTimeBannerType.Cleared.INSTANCE)) {
            }
            this.conversationKit.removeEventListener(this.listener);
        }
    }

    private final void handleWaitTimeExpectationEvent(ConversationKitEvent.ActivityEventReceived activityEventReceived, ActivityData activityData) {
        WaitTimeBannerType value;
        Long lValueOf;
        Long lValueOf2;
        Integer numValueOf;
        Long lowestQueuePosition;
        int i = activityData == null ? -1 : WhenMappings.$EnumSwitchMapping$1[activityData.ordinal()];
        if (i != 1) {
            if (i == 2) {
                MutableStateFlow<WaitTimeBannerType> mutableStateFlow = this._waitTimeBannerType;
                while (!mutableStateFlow.compareAndSet(mutableStateFlow.getValue(), WaitTimeBannerType.Assigned.INSTANCE)) {
                }
                return;
            } else {
                if (i != 3) {
                    return;
                }
                MutableStateFlow<WaitTimeBannerType> mutableStateFlow2 = this._waitTimeBannerType;
                while (!mutableStateFlow2.compareAndSet(mutableStateFlow2.getValue(), WaitTimeBannerType.Cleared.INSTANCE)) {
                }
                return;
            }
        }
        MutableStateFlow<WaitTimeBannerType> mutableStateFlow3 = this._waitTimeBannerType;
        do {
            value = mutableStateFlow3.getValue();
            ActivityEvent activityEvent = activityEventReceived.getActivityEvent();
            WsResponseTimeDto responseTime = activityEvent.getResponseTime();
            lValueOf = responseTime != null ? Long.valueOf(responseTime.getLower()) : null;
            WsResponseTimeDto responseTime2 = activityEvent.getResponseTime();
            lValueOf2 = responseTime2 != null ? Long.valueOf(responseTime2.getUpper()) : null;
            Long queuePosition = activityEvent.getQueuePosition();
            numValueOf = queuePosition != null ? Integer.valueOf((int) queuePosition.longValue()) : null;
            lowestQueuePosition = activityEvent.getLowestQueuePosition();
        } while (!mutableStateFlow3.compareAndSet(value, processBannerStateUpdate(lValueOf, lValueOf2, numValueOf, lowestQueuePosition != null ? Integer.valueOf((int) lowestQueuePosition.longValue()) : null)));
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00010\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/flow/FlowCollector;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$pollingWithRetries$1", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {259, 260}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14521 extends SuspendLambda implements Function2<FlowCollector<? super Unit>, Continuation<? super Unit>, Object> {
        int label;

        C14521(Continuation<? super C14521> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return WaitTimeBannerService.this.new C14521(continuation);
        }

        @Override
        public final Object invoke(FlowCollector<? super Unit> flowCollector, Continuation<? super Unit> continuation) {
            return ((C14521) create(flowCollector, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final java.lang.Object invokeSuspend(java.lang.Object r7) {
            throw new UnsupportedOperationException("Method not decompiled: zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService.C14521.invokeSuspend(java.lang.Object):java.lang.Object");
        }
    }

    public final Flow<Unit> pollingWithRetries() {
        return FlowKt.onCompletion(FlowKt.onStart(FlowKt.retryWhen(FlowKt.flow(new C14521(null)), new C14532(null)), new C14543(null)), new C14554(null));
    }

    @Metadata(m17d1 = {"\u0000\u001a\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u0003\n\u0000\n\u0002\u0010\t\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00030\u00022\u0006\u0010\u0004\u001a\u00020\u00052\u0006\u0010\u0006\u001a\u00020\u0007H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/flow/FlowCollector;", "", "cause", "", "<anonymous parameter 1>", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$pollingWithRetries$2", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {285}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14532 extends SuspendLambda implements Function4<FlowCollector<? super Unit>, Throwable, Long, Continuation<? super Boolean>, Object> {
        Object L$0;
        int label;

        C14532(Continuation<? super C14532> continuation) {
            super(4, continuation);
        }

        @Override
        public Object invoke(FlowCollector<? super Unit> flowCollector, Throwable th, Long l, Continuation<? super Boolean> continuation) {
            return invoke(flowCollector, th, l.longValue(), continuation);
        }

        public final Object invoke(FlowCollector<? super Unit> flowCollector, Throwable th, long j, Continuation<? super Boolean> continuation) {
            C14532 c14532 = WaitTimeBannerService.this.new C14532(continuation);
            c14532.L$0 = th;
            return c14532.invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object value;
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Throwable th = (Throwable) this.L$0;
                Logger.m220i(WaitTimeBannerService.LOG_TAG, "Polling failed for conversation ID: " + WaitTimeBannerService.this.conversationId, th, new Object[0]);
                if (th instanceof HttpException) {
                    RestRetryPolicy restRetryPolicy = WaitTimeBannerService.this.conversationKit.getConfig().getRestRetryPolicy();
                    HttpException httpException = (HttpException) th;
                    if ((httpException.code() == WaitTimeBannerService.TOO_MANY_REQUEST_HTTP_CODE || httpException.code() == 500) && WaitTimeBannerService.this.retries < restRetryPolicy.getMaxRetries()) {
                        long jExponentialBackoffInterval = ConfigKt.exponentialBackoffInterval(WaitTimeBannerService.this.conversationKit.getConfig(), WaitTimeBannerService.this.retries);
                        Logger.m221i(WaitTimeBannerService.LOG_TAG, StringsKt.trimMargin$default("Retrying in " + jExponentialBackoffInterval + " seconds for\n                                |conversation ID: " + WaitTimeBannerService.this.conversationId + ", retry: " + WaitTimeBannerService.this.retries, null, 1, null), new Object[0]);
                        this.label = 1;
                        if (DelayKt.delay(TimeUnit.SECONDS.toMillis(jExponentialBackoffInterval), this) == coroutine_suspended) {
                            return coroutine_suspended;
                        }
                    }
                }
                MutableStateFlow mutableStateFlow = WaitTimeBannerService.this._waitTimeBannerType;
                do {
                    value = mutableStateFlow.getValue();
                } while (!mutableStateFlow.compareAndSet(value, WaitTimeBannerType.Cleared.INSTANCE));
                return Boxing.boxBoolean(false);
            }
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            WaitTimeBannerService.this.retries++;
            return Boxing.boxBoolean(true);
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00010\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/flow/FlowCollector;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$pollingWithRetries$3", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14543 extends SuspendLambda implements Function2<FlowCollector<? super Unit>, Continuation<? super Unit>, Object> {
        int label;

        C14543(Continuation<? super C14543> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return WaitTimeBannerService.this.new C14543(continuation);
        }

        @Override
        public final Object invoke(FlowCollector<? super Unit> flowCollector, Continuation<? super Unit> continuation) {
            return ((C14543) create(flowCollector, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            Logger.m221i(WaitTimeBannerService.LOG_TAG, "Polling started for conversation ID: " + WaitTimeBannerService.this.conversationId, new Object[0]);
            return Unit.INSTANCE;
        }
    }

    @Metadata(m17d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\u0010\u0000\u001a\u00020\u0001*\b\u0012\u0004\u0012\u00020\u00010\u00022\b\u0010\u0003\u001a\u0004\u0018\u00010\u0004H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/flow/FlowCollector;", "it", ""}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$pollingWithRetries$4", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14554 extends SuspendLambda implements Function3<FlowCollector<? super Unit>, Throwable, Continuation<? super Unit>, Object> {
        int label;

        C14554(Continuation<? super C14554> continuation) {
            super(3, continuation);
        }

        @Override
        public final Object invoke(FlowCollector<? super Unit> flowCollector, Throwable th, Continuation<? super Unit> continuation) {
            return WaitTimeBannerService.this.new C14554(continuation).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            Logger.m221i(WaitTimeBannerService.LOG_TAG, "Polling stopped for conversation ID: " + WaitTimeBannerService.this.conversationId, new Object[0]);
            return Unit.INSTANCE;
        }
    }

    public final Object getWaitTimeForConversation(String str, Continuation<? super Unit> continuation) throws Throwable {
        C14511 c14511;
        WaitTimeBannerService waitTimeBannerService;
        WaitTimeBannerType value;
        ConversationKitResult.Success success;
        Long lBoxLong;
        ResponseTimeDto responseTimeDto;
        if (continuation instanceof C14511) {
            c14511 = (C14511) continuation;
            if ((c14511.label & Integer.MIN_VALUE) != 0) {
                c14511.label -= Integer.MIN_VALUE;
            } else {
                c14511 = new C14511(continuation);
            }
        } else {
            c14511 = new C14511(continuation);
        }
        Object waitTimeForConversation = c14511.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c14511.label;
        if (i == 0) {
            ResultKt.throwOnFailure(waitTimeForConversation);
            ConversationKit conversationKit = this.conversationKit;
            c14511.L$0 = this;
            c14511.label = 1;
            waitTimeForConversation = conversationKit.getWaitTimeForConversation(str, c14511);
            if (waitTimeForConversation == coroutine_suspended) {
                return coroutine_suspended;
            }
            waitTimeBannerService = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            waitTimeBannerService = (WaitTimeBannerService) c14511.L$0;
            ResultKt.throwOnFailure(waitTimeForConversation);
        }
        ConversationKitResult conversationKitResult = (ConversationKitResult) waitTimeForConversation;
        if (conversationKitResult instanceof ConversationKitResult.Failure) {
            throw ((ConversationKitResult.Failure) conversationKitResult).getCause();
        }
        if (conversationKitResult instanceof ConversationKitResult.Success) {
            MutableStateFlow<WaitTimeBannerType> mutableStateFlow = waitTimeBannerService._waitTimeBannerType;
            do {
                value = mutableStateFlow.getValue();
                success = (ConversationKitResult.Success) conversationKitResult;
                ResponseTimeDto responseTimeDto2 = ((WaitTimeData) success.getValue()).getResponseTimeDto();
                lBoxLong = responseTimeDto2 != null ? Boxing.boxLong(responseTimeDto2.getLower()) : null;
                responseTimeDto = ((WaitTimeData) success.getValue()).getResponseTimeDto();
            } while (!mutableStateFlow.compareAndSet(value, waitTimeBannerService.processBannerStateUpdate(lBoxLong, responseTimeDto != null ? Boxing.boxLong(responseTimeDto.getUpper()) : null, Boxing.boxInt(((WaitTimeData) success.getValue()).getQueuePosition()), Boxing.boxInt(((WaitTimeData) success.getValue()).getLowestQueuePosition()))));
        }
        return Unit.INSTANCE;
    }

    private final WaitTimeBannerType processBannerStateUpdate(Long lowerResponseTime, Long upperResponseTime, Integer queuePosition, Integer lowestQueuePosition) {
        WaitTimeConfig waitTimeConfig = this.conversationKit.getConfig().getIntegration().getWaitTimeConfig();
        if (!WaitTimeConfigKt.shouldShowBanner(waitTimeConfig, lowerResponseTime, upperResponseTime, queuePosition, lowestQueuePosition)) {
            return WaitTimeBannerType.Cleared.INSTANCE;
        }
        return new WaitTimeBannerType.Queued(shouldDisplayResponseTime(waitTimeConfig, lowerResponseTime, upperResponseTime), new ResponseTime(lowerResponseTime != null ? lowerResponseTime.longValue() : 0L, upperResponseTime != null ? upperResponseTime.longValue() : 0L), shouldDisplayQueuePosition(waitTimeConfig, queuePosition, lowestQueuePosition), queuePosition != null ? RangesKt.coerceAtLeast(queuePosition.intValue(), 1) : 1, lowestQueuePosition != null ? RangesKt.coerceAtLeast(lowestQueuePosition.intValue(), 1) : 1);
    }

    private final boolean shouldDisplayResponseTime(WaitTimeConfig waitTimeConfig, Long l, Long l2) {
        return (!waitTimeConfig.getWaitTimeEnabled() || l == null || l2 == null) ? false : true;
    }

    private final boolean shouldDisplayQueuePosition(WaitTimeConfig waitTimeConfig, Integer num, Integer num2) {
        return (!waitTimeConfig.getQueuePositionEnabled() || num == null || num2 == null) ? false : true;
    }

    private final boolean isBannerStateQueued() {
        return this._waitTimeBannerType.getValue() instanceof WaitTimeBannerType.Queued;
    }

    public final void checkPollingStatus() {
        if (isWaitTimeBannerEnabled()) {
            String str = this.conversationId;
            if (str == null) {
                Logger.m219e(LOG_TAG, "Conversation ID should not be null", new Object[0]);
            }
            boolean zShouldContinuePoll = WaitTimeConfigKt.shouldContinuePoll(this.conversationKit.getConfig().getIntegration().getWaitTimeConfig());
            if (!isBannerStateQueued() || str == null || !zShouldContinuePoll) {
                BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C14502(null), 3, null);
            } else {
                BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C14491(null), 3, null);
            }
        }
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$checkPollingStatus$1", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {HttpStatus.SC_FAILED_DEPENDENCY}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14491 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14491(Continuation<? super C14491> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return WaitTimeBannerService.this.new C14491(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14491) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (WaitTimeBannerService.this._eventsChannel.send(ConversationScreenEvent.StartPolling.INSTANCE, this) == coroutine_suspended) {
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.conversationscreen.waittimebanner.WaitTimeBannerService$checkPollingStatus$2", m37f = "WaitTimeBannerService.kt", m38i = {}, m39l = {426}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C14502 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C14502(Continuation<? super C14502> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return WaitTimeBannerService.this.new C14502(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C14502) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (WaitTimeBannerService.this._eventsChannel.send(ConversationScreenEvent.StopPolling.INSTANCE, this) == coroutine_suspended) {
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

    public final boolean isWaitTimeBannerEnabled() {
        WaitTimeConfig waitTimeConfig = this.conversationKit.getConfig().getIntegration().getWaitTimeConfig();
        return waitTimeConfig.getWaitTimeEnabled() || waitTimeConfig.getQueuePositionEnabled();
    }
}
