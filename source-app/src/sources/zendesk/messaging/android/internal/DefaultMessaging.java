package zendesk.messaging.android.internal;

import android.content.Context;
import android.content.Intent;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.BuildersKt__Builders_commonKt;
import kotlinx.coroutines.CoroutineDispatcher;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.flow.Flow;
import kotlinx.coroutines.flow.FlowCollector;
import zendesk.android.ZendeskCredentials;
import zendesk.android.events.ConnectionStatus;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.conversationkit.android.ConversationKitEvent;
import zendesk.conversationkit.android.internal.extension.ConversationKitKt;
import zendesk.conversationkit.android.internal.metadata.ConversationMetadataService;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.Participant;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.ProactiveMessageStatus;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.UserKt;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;
import zendesk.logger.Logger;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageCleaner;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListStorageBuilder;
import zendesk.messaging.android.internal.messagingscreen.MessagingActivityIntentBuilder;
import zendesk.messaging.android.internal.p023di.MessagingComponent;
import zendesk.messaging.android.internal.proactivemessaging.LocalNotificationHandler;
import zendesk.messaging.android.internal.proactivemessaging.ProactiveMessageEvent;
import zendesk.messaging.android.internal.validation.ConversationFieldManager;
import zendesk.messaging.android.push.PushNotifications;

@Metadata(m17d1 = {"\u0000Ê\u0001\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\b\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0007\n\u0002\u0010$\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\u0003\b\u0000\u0018\u0000 ]2\u00020\u0001:\u0001]B\u008f\u0001\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\"\u0010\b\u001a\u001e\b\u0001\u0012\u0004\u0012\u00020\n\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u000b\u0012\u0006\u0012\u0004\u0018\u00010\r0\t\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\b\b\u0002\u0010\u0012\u001a\u00020\u0013\u0012\u0006\u0010\u0014\u001a\u00020\u0015\u0012\u0006\u0010\u0016\u001a\u00020\u0017\u0012\n\b\u0002\u0010\u0018\u001a\u0004\u0018\u00010\u0019\u0012\u0006\u0010\u001a\u001a\u00020\u001b\u0012\u0006\u0010\u001c\u001a\u00020\u001d\u0012\u0006\u0010\u001e\u001a\u00020\u001f¢\u0006\u0002\u0010 J\b\u0010,\u001a\u00020\fH\u0016J\b\u0010-\u001a\u00020\fH\u0016J\u001a\u0010.\u001a\u00020\f2\n\b\u0002\u0010/\u001a\u0004\u0018\u000100H\u0082@¢\u0006\u0002\u00101J\b\u00102\u001a\u000200H\u0016J\u0016\u00103\u001a\u00020\f2\u0006\u00104\u001a\u000205H\u0082@¢\u0006\u0002\u00106J\u001e\u00107\u001a\u00020\f2\u0006\u00108\u001a\u0002092\u0006\u0010:\u001a\u00020;H\u0082@¢\u0006\u0002\u0010<J\u0016\u0010=\u001a\u00020\f2\u0006\u00104\u001a\u00020>H\u0082@¢\u0006\u0002\u0010?J\u0010\u0010@\u001a\u00020\f2\u0006\u0010A\u001a\u00020BH\u0002J!\u0010C\u001a\u00020\f2\b\u0010/\u001a\u0004\u0018\u0001002\u0006\u00104\u001a\u00020DH\u0000¢\u0006\u0004\bE\u0010FJ\u0010\u0010G\u001a\u00020\f2\u0006\u0010H\u001a\u00020IH\u0002J\u0016\u0010J\u001a\u00020\f2\u0006\u00104\u001a\u00020KH\u0082@¢\u0006\u0002\u0010LJ\u001f\u0010M\u001a\u00020N2\u0006\u0010O\u001a\u00020P2\b\b\u0002\u0010Q\u001a\u000200H\u0000¢\u0006\u0002\bRJ\u000e\u0010S\u001a\u00020\fH\u0082@¢\u0006\u0002\u0010TJ\u000e\u0010U\u001a\u00020\fH\u0082@¢\u0006\u0002\u0010TJ\u001c\u0010V\u001a\u00020\f2\u0012\u0010W\u001a\u000e\u0012\u0004\u0012\u000209\u0012\u0004\u0012\u00020\r0XH\u0016J\u0016\u0010Y\u001a\u00020\f2\f\u0010Z\u001a\b\u0012\u0004\u0012\u0002090[H\u0016J\u0010\u0010\\\u001a\u00020\f2\u0006\u0010O\u001a\u00020PH\u0016J\u0018\u0010\\\u001a\u00020\f2\u0006\u0010O\u001a\u00020P2\u0006\u0010Q\u001a\u000200H\u0016R\u0014\u0010\u001a\u001a\u00020\u001bX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0010\u0010\u0006\u001a\u00020\u00078\u0000X\u0081\u0004¢\u0006\u0002\n\u0000R\u0016\u0010\u0018\u001a\u0004\u0018\u00010\u0019X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0002\u001a\u00020\u00038\u0000X\u0081\u0004¢\u0006\u0002\n\u0000R,\u0010\b\u001a\u001e\b\u0001\u0012\u0004\u0012\u00020\n\u0012\n\u0012\b\u0012\u0004\u0012\u00020\f0\u000b\u0012\u0006\u0012\u0004\u0018\u00010\r0\tX\u0082\u0004¢\u0006\u0004\n\u0002\u0010%R\u0014\u0010\u001c\u001a\u00020\u001dX\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b&\u0010'R\u000e\u0010\u0014\u001a\u00020\u0015X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u001e\u001a\u00020\u001fX\u0082\u0004¢\u0006\u0002\n\u0000R\u0014\u0010\u0016\u001a\u00020\u0017X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b(\u0010)R\u0014\u0010\u0004\u001a\u00020\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b*\u0010+R\u000e\u0010\u000e\u001a\u00020\u000fX\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0012\u001a\u00020\u0013X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006^"}, m18d2 = {"Lzendesk/messaging/android/internal/DefaultMessaging;", "Lzendesk/android/messaging/Messaging;", "credentials", "Lzendesk/android/ZendeskCredentials;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "dispatchEvent", "Lkotlin/Function2;", "Lzendesk/android/events/ZendeskEvent;", "Lkotlin/coroutines/Continuation;", "", "", "processLifecycleObserver", "Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "unreadMessageCounter", "Lzendesk/messaging/android/internal/UnreadMessageCounter;", "localNotificationHandler", "Lzendesk/messaging/android/internal/proactivemessaging/LocalNotificationHandler;", "messagingComponent", "Lzendesk/messaging/android/internal/di/MessagingComponent;", "conversationsListStorageBuilder", "Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListStorageBuilder;", "conversationFieldManager", "Lzendesk/messaging/android/internal/validation/ConversationFieldManager;", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "mainCoroutineDispatcher", "Lkotlinx/coroutines/CoroutineDispatcher;", "(Lzendesk/android/ZendeskCredentials;Lzendesk/android/messaging/model/MessagingSettings;Lzendesk/conversationkit/android/ConversationKit;Lkotlin/jvm/functions/Function2;Lzendesk/core/ui/android/internal/app/ProcessLifecycleEventObserver;Lkotlinx/coroutines/CoroutineScope;Lzendesk/messaging/android/internal/UnreadMessageCounter;Lzendesk/messaging/android/internal/proactivemessaging/LocalNotificationHandler;Lzendesk/messaging/android/internal/di/MessagingComponent;Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListStorageBuilder;Lzendesk/messaging/android/internal/validation/ConversationFieldManager;Lzendesk/core/android/internal/app/FeatureFlagManager;Lkotlinx/coroutines/CoroutineDispatcher;)V", "getConversationFieldManager$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/validation/ConversationFieldManager;", "getConversationsListStorageBuilder$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListStorageBuilder;", "Lkotlin/jvm/functions/Function2;", "getFeatureFlagManager$zendesk_messaging_messaging_android", "()Lzendesk/core/android/internal/app/FeatureFlagManager;", "getMessagingComponent$zendesk_messaging_messaging_android", "()Lzendesk/messaging/android/internal/di/MessagingComponent;", "getMessagingSettings$zendesk_messaging_messaging_android", "()Lzendesk/android/messaging/model/MessagingSettings;", "clearConversationFields", "clearConversationTags", "clearRemainingProactiveMessages", "proactiveMessageId", "", "(Ljava/lang/Integer;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "getUnreadMessageCount", "handleActivityEventReceived", "event", "Lzendesk/conversationkit/android/ConversationKitEvent$ActivityEventReceived;", "(Lzendesk/conversationkit/android/ConversationKitEvent$ActivityEventReceived;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handleMessageReceivedEvent", "conversationId", "", "message", "Lzendesk/conversationkit/android/model/Message;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handlePersistedUserReceivedEvent", "Lzendesk/conversationkit/android/ConversationKitEvent$PersistedUserReceived;", "(Lzendesk/conversationkit/android/ConversationKitEvent$PersistedUserReceived;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "handleProactiveMessageCannotBeDisplayed", "throwable", "", "handleProactiveMessageEvent", "Lzendesk/messaging/android/internal/proactivemessaging/ProactiveMessageEvent;", "handleProactiveMessageEvent$zendesk_messaging_messaging_android", "(Ljava/lang/Integer;Lzendesk/messaging/android/internal/proactivemessaging/ProactiveMessageEvent;)V", "handleProactiveMessageHasBeenDisplayed", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "handleUserUpdatedEvent", "Lzendesk/conversationkit/android/ConversationKitEvent$UserUpdated;", "(Lzendesk/conversationkit/android/ConversationKitEvent$UserUpdated;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "messagingScreenIntent", "Landroid/content/Intent;", "context", "Landroid/content/Context;", "intentFlags", "messagingScreenIntent$zendesk_messaging_messaging_android", "resetConversationsListStorage", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "resetUnreadMessageCounter", "setConversationFields", "fields", "", "setConversationTags", "tags", "", "showMessaging", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultMessaging implements Messaging {
    public static final String LOG_TAG = "DefaultMessaging";
    public static final String MESSAGING_NAMESPACE = "zendesk.messaging.android";
    private final ConversationFieldManager conversationFieldManager;
    public final ConversationKit conversationKit;
    private final ConversationsListStorageBuilder conversationsListStorageBuilder;
    private final CoroutineScope coroutineScope;
    public final ZendeskCredentials credentials;
    private final Function2<ZendeskEvent, Continuation<? super Unit>, Object> dispatchEvent;
    private final FeatureFlagManager featureFlagManager;
    private final LocalNotificationHandler localNotificationHandler;
    private final CoroutineDispatcher mainCoroutineDispatcher;
    private final MessagingComponent messagingComponent;
    private final MessagingSettings messagingSettings;
    private final ProcessLifecycleEventObserver processLifecycleObserver;
    private final UnreadMessageCounter unreadMessageCounter;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging", m37f = "DefaultMessaging.kt", m38i = {0}, m39l = {345}, m40m = "clearRemainingProactiveMessages", m41n = {"this"}, m42s = {"L$0"})
    static final class C12641 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C12641(Continuation<? super C12641> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return DefaultMessaging.this.clearRemainingProactiveMessages(null, this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging", m37f = "DefaultMessaging.kt", m38i = {0, 0, 0}, m39l = {193, 197}, m40m = "handleMessageReceivedEvent", m41n = {"this", "conversationId", "message"}, m42s = {"L$0", "L$1", "L$2"})
    static final class C12651 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        Object L$2;
        int label;
        Object result;

        C12651(Continuation<? super C12651> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return DefaultMessaging.this.handleMessageReceivedEvent(null, null, this);
        }
    }

    public DefaultMessaging(ZendeskCredentials credentials, MessagingSettings messagingSettings, ConversationKit conversationKit, Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ? extends Object> dispatchEvent, ProcessLifecycleEventObserver processLifecycleObserver, CoroutineScope coroutineScope, UnreadMessageCounter unreadMessageCounter, LocalNotificationHandler localNotificationHandler, MessagingComponent messagingComponent, ConversationsListStorageBuilder conversationsListStorageBuilder, ConversationFieldManager conversationFieldManager, FeatureFlagManager featureFlagManager, CoroutineDispatcher mainCoroutineDispatcher) {
        Intrinsics.checkNotNullParameter(credentials, "credentials");
        Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(dispatchEvent, "dispatchEvent");
        Intrinsics.checkNotNullParameter(processLifecycleObserver, "processLifecycleObserver");
        Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
        Intrinsics.checkNotNullParameter(unreadMessageCounter, "unreadMessageCounter");
        Intrinsics.checkNotNullParameter(localNotificationHandler, "localNotificationHandler");
        Intrinsics.checkNotNullParameter(messagingComponent, "messagingComponent");
        Intrinsics.checkNotNullParameter(conversationFieldManager, "conversationFieldManager");
        Intrinsics.checkNotNullParameter(featureFlagManager, "featureFlagManager");
        Intrinsics.checkNotNullParameter(mainCoroutineDispatcher, "mainCoroutineDispatcher");
        this.credentials = credentials;
        this.messagingSettings = messagingSettings;
        this.conversationKit = conversationKit;
        this.dispatchEvent = dispatchEvent;
        this.processLifecycleObserver = processLifecycleObserver;
        this.coroutineScope = coroutineScope;
        this.unreadMessageCounter = unreadMessageCounter;
        this.localNotificationHandler = localNotificationHandler;
        this.messagingComponent = messagingComponent;
        this.conversationsListStorageBuilder = conversationsListStorageBuilder;
        this.conversationFieldManager = conversationFieldManager;
        this.featureFlagManager = featureFlagManager;
        this.mainCoroutineDispatcher = mainCoroutineDispatcher;
        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C12591(null), 3, null);
        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C12602(null), 3, null);
        BuildersKt__Builders_commonKt.launch$default(coroutineScope, null, null, new C12613(null), 3, null);
    }

    public final MessagingSettings getMessagingSettings() {
        return this.messagingSettings;
    }

    public DefaultMessaging(ZendeskCredentials zendeskCredentials, MessagingSettings messagingSettings, ConversationKit conversationKit, Function2 function2, ProcessLifecycleEventObserver processLifecycleEventObserver, CoroutineScope coroutineScope, UnreadMessageCounter unreadMessageCounter, LocalNotificationHandler localNotificationHandler, MessagingComponent messagingComponent, ConversationsListStorageBuilder conversationsListStorageBuilder, ConversationFieldManager conversationFieldManager, FeatureFlagManager featureFlagManager, CoroutineDispatcher coroutineDispatcher, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(zendeskCredentials, messagingSettings, conversationKit, function2, processLifecycleEventObserver, coroutineScope, (i & 64) != 0 ? UnreadMessageCounter.INSTANCE : unreadMessageCounter, localNotificationHandler, messagingComponent, (i & 512) != 0 ? null : conversationsListStorageBuilder, conversationFieldManager, featureFlagManager, coroutineDispatcher);
    }

    public final MessagingComponent getMessagingComponent() {
        return this.messagingComponent;
    }

    public final ConversationsListStorageBuilder getConversationsListStorageBuilder() {
        return this.conversationsListStorageBuilder;
    }

    public final ConversationFieldManager getConversationFieldManager() {
        return this.conversationFieldManager;
    }

    public final FeatureFlagManager getFeatureFlagManager() {
        return this.featureFlagManager;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$1", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {75}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12591 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C12591(Continuation<? super C12591> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultMessaging.this.new C12591(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12591) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<Boolean> flowIsInForeground = DefaultMessaging.this.processLifecycleObserver.isInForeground();
                final DefaultMessaging defaultMessaging = DefaultMessaging.this;
                this.label = 1;
                if (flowIsInForeground.collect(new FlowCollector() {
                    @Override
                    public Object emit(Object obj2, Continuation continuation) {
                        return emit(((Boolean) obj2).booleanValue(), (Continuation<? super Unit>) continuation);
                    }

                    public final Object emit(boolean z, Continuation<? super Unit> continuation) {
                        if (z) {
                            Logger.m217d(DefaultMessaging.LOG_TAG, "App is in the foreground, resuming ConversationKit", new Object[0]);
                            Object objResume = defaultMessaging.conversationKit.resume(continuation);
                            return objResume == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objResume : Unit.INSTANCE;
                        }
                        Logger.m217d(DefaultMessaging.LOG_TAG, "App is in the background, pausing ConversationKit", new Object[0]);
                        Object objPause = defaultMessaging.conversationKit.pause(continuation);
                        return objPause == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objPause : Unit.INSTANCE;
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$2", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {86}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12602 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C12602(Continuation<? super C12602> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultMessaging.this.new C12602(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12602) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                Flow<String> pushNotificationToken$zendesk_messaging_messaging_android = PushNotifications.INSTANCE.getPushNotificationToken$zendesk_messaging_messaging_android();
                final DefaultMessaging defaultMessaging = DefaultMessaging.this;
                this.label = 1;
                if (pushNotificationToken$zendesk_messaging_messaging_android.collect(new FlowCollector() {
                    @Override
                    public Object emit(Object obj2, Continuation continuation) {
                        return emit((String) obj2, (Continuation<? super Unit>) continuation);
                    }

                    public final Object emit(String str, Continuation<? super Unit> continuation) {
                        Object objUpdatePushNotificationToken = defaultMessaging.conversationKit.updatePushNotificationToken(str, continuation);
                        return objUpdatePushNotificationToken == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objUpdatePushNotificationToken : Unit.INSTANCE;
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
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$3", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {92}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12613 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C12613(Continuation<? super C12613> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultMessaging.this.new C12613(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12613) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
        @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$3$1", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {93}, m40m = "invokeSuspend", m41n = {}, m42s = {})
        static final class AnonymousClass1 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
            int label;
            final DefaultMessaging this$0;

            AnonymousClass1(DefaultMessaging defaultMessaging, Continuation<? super AnonymousClass1> continuation) {
                super(2, continuation);
                this.this$0 = defaultMessaging;
            }

            @Override
            public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                return new AnonymousClass1(this.this$0, continuation);
            }

            @Override
            public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                return ((AnonymousClass1) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
            }

            @Metadata(m17d1 = {"\u0000\u0010\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u0010\u0000\u001a\u00020\u00012\u0006\u0010\u0002\u001a\u00020\u0003H\u008a@¢\u0006\u0004\b\u0004\u0010\u0005"}, m18d2 = {"<anonymous>", "", "conversationKitEvent", "Lzendesk/conversationkit/android/ConversationKitEvent;", "emit", "(Lzendesk/conversationkit/android/ConversationKitEvent;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
            static final class C16671<T> implements FlowCollector {
                final DefaultMessaging this$0;

                C16671(DefaultMessaging defaultMessaging) {
                    this.this$0 = defaultMessaging;
                }

                @Override
                public Object emit(Object obj, Continuation continuation) {
                    return emit((ConversationKitEvent) obj, (Continuation<? super Unit>) continuation);
                }

                public final Object emit(ConversationKitEvent conversationKitEvent, Continuation<? super Unit> continuation) throws Throwable {
                    DefaultMessaging$3$1$1$emit$1 defaultMessaging$3$1$1$emit$1;
                    C16671<T> c16671;
                    DefaultMessaging defaultMessaging;
                    if (continuation instanceof DefaultMessaging$3$1$1$emit$1) {
                        defaultMessaging$3$1$1$emit$1 = (DefaultMessaging$3$1$1$emit$1) continuation;
                        if ((defaultMessaging$3$1$1$emit$1.label & Integer.MIN_VALUE) != 0) {
                            defaultMessaging$3$1$1$emit$1.label -= Integer.MIN_VALUE;
                        } else {
                            defaultMessaging$3$1$1$emit$1 = new DefaultMessaging$3$1$1$emit$1(this, continuation);
                        }
                    } else {
                        defaultMessaging$3$1$1$emit$1 = new DefaultMessaging$3$1$1$emit$1(this, continuation);
                    }
                    Object obj = defaultMessaging$3$1$1$emit$1.result;
                    Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                    switch (defaultMessaging$3$1$1$emit$1.label) {
                        case 0:
                            ResultKt.throwOnFailure(obj);
                            if (conversationKitEvent instanceof ConversationKitEvent.MessageReceived) {
                                DefaultMessaging defaultMessaging2 = this.this$0;
                                ConversationKitEvent.MessageReceived messageReceived = (ConversationKitEvent.MessageReceived) conversationKitEvent;
                                String conversationId = messageReceived.getConversationId();
                                Message message = messageReceived.getMessage();
                                defaultMessaging$3$1$1$emit$1.label = 1;
                                if (defaultMessaging2.handleMessageReceivedEvent(conversationId, message, defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                return Unit.INSTANCE;
                            }
                            if (conversationKitEvent instanceof ConversationKitEvent.ActivityEventReceived) {
                                defaultMessaging$3$1$1$emit$1.label = 2;
                                if (this.this$0.handleActivityEventReceived((ConversationKitEvent.ActivityEventReceived) conversationKitEvent, defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                return Unit.INSTANCE;
                            }
                            if (conversationKitEvent instanceof ConversationKitEvent.UserUpdated) {
                                defaultMessaging$3$1$1$emit$1.label = 3;
                                if (this.this$0.handleUserUpdatedEvent((ConversationKitEvent.UserUpdated) conversationKitEvent, defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                return Unit.INSTANCE;
                            }
                            if (conversationKitEvent instanceof ConversationKitEvent.PersistedUserReceived) {
                                defaultMessaging$3$1$1$emit$1.label = 4;
                                if (this.this$0.handlePersistedUserReceivedEvent((ConversationKitEvent.PersistedUserReceived) conversationKitEvent, defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                return Unit.INSTANCE;
                            }
                            if (conversationKitEvent instanceof ConversationKitEvent.LogoutUserCompleted ? true : conversationKitEvent instanceof ConversationKitEvent.UserAccessRevoked) {
                                DefaultMessaging defaultMessaging3 = this.this$0;
                                defaultMessaging$3$1$1$emit$1.L$0 = this;
                                defaultMessaging$3$1$1$emit$1.label = 5;
                                if (defaultMessaging3.resetUnreadMessageCounter(defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                c16671 = this;
                                defaultMessaging = c16671.this$0;
                                defaultMessaging$3$1$1$emit$1.L$0 = null;
                                defaultMessaging$3$1$1$emit$1.label = 6;
                                if (defaultMessaging.resetConversationsListStorage(defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                    return coroutine_suspended;
                                }
                                return Unit.INSTANCE;
                            }
                            if (conversationKitEvent instanceof ConversationKitEvent.ProactiveMessageStatusChanged) {
                                ConversationKitEvent.ProactiveMessageStatusChanged proactiveMessageStatusChanged = (ConversationKitEvent.ProactiveMessageStatusChanged) conversationKitEvent;
                                if (proactiveMessageStatusChanged.getStatus() instanceof ProactiveMessageStatus.NotificationWillDisplay) {
                                    ProactiveMessageStatus status = proactiveMessageStatusChanged.getStatus();
                                    Intrinsics.checkNotNull(status, "null cannot be cast to non-null type zendesk.conversationkit.android.model.ProactiveMessageStatus.NotificationWillDisplay");
                                    ProactiveMessage proactiveMessage = ((ProactiveMessageStatus.NotificationWillDisplay) status).getProactiveMessage();
                                    BuildersKt__Builders_commonKt.launch$default(this.this$0.coroutineScope, null, null, new C16681(this.this$0, proactiveMessage.getId(), proactiveMessage.getTitle(), proactiveMessage.getBody(), proactiveMessage, null), 3, null);
                                }
                            } else {
                                if (conversationKitEvent instanceof ConversationKitEvent.ConnectionStatusChanged) {
                                    Function2 function2 = this.this$0.dispatchEvent;
                                    ZendeskEvent.ConnectionStatusChanged connectionStatusChanged = new ZendeskEvent.ConnectionStatusChanged(ConnectionStatus.valueOf(((ConversationKitEvent.ConnectionStatusChanged) conversationKitEvent).getConnectionStatus().name()));
                                    defaultMessaging$3$1$1$emit$1.label = 7;
                                    if (function2.invoke(connectionStatusChanged, defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    return Unit.INSTANCE;
                                }
                                if (conversationKitEvent instanceof ConversationKitEvent.SendMessageFailed) {
                                    Function2 function3 = this.this$0.dispatchEvent;
                                    ZendeskEvent.SendMessageFailed sendMessageFailed = new ZendeskEvent.SendMessageFailed(((ConversationKitEvent.SendMessageFailed) conversationKitEvent).getCause());
                                    defaultMessaging$3$1$1$emit$1.label = 8;
                                    if (function3.invoke(sendMessageFailed, defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    return Unit.INSTANCE;
                                }
                                if (conversationKitEvent instanceof ConversationKitEvent.ConversationAddedSuccess) {
                                    Function2 function4 = this.this$0.dispatchEvent;
                                    ZendeskEvent.ConversationAdded conversationAdded = new ZendeskEvent.ConversationAdded(((ConversationKitEvent.ConversationAddedSuccess) conversationKitEvent).getConversation().getId());
                                    defaultMessaging$3$1$1$emit$1.label = 9;
                                    if (function4.invoke(conversationAdded, defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                        return coroutine_suspended;
                                    }
                                    return Unit.INSTANCE;
                                }
                            }
                            return Unit.INSTANCE;
                        case 1:
                            ResultKt.throwOnFailure(obj);
                            return Unit.INSTANCE;
                        case 2:
                            ResultKt.throwOnFailure(obj);
                            return Unit.INSTANCE;
                        case 3:
                            ResultKt.throwOnFailure(obj);
                            return Unit.INSTANCE;
                        case 4:
                            ResultKt.throwOnFailure(obj);
                            return Unit.INSTANCE;
                        case 5:
                            c16671 = (C16671) defaultMessaging$3$1$1$emit$1.L$0;
                            ResultKt.throwOnFailure(obj);
                            defaultMessaging = c16671.this$0;
                            defaultMessaging$3$1$1$emit$1.L$0 = null;
                            defaultMessaging$3$1$1$emit$1.label = 6;
                            if (defaultMessaging.resetConversationsListStorage(defaultMessaging$3$1$1$emit$1) == coroutine_suspended) {
                                return coroutine_suspended;
                            }
                            return Unit.INSTANCE;
                        case 6:
                            ResultKt.throwOnFailure(obj);
                            return Unit.INSTANCE;
                        case 7:
                            ResultKt.throwOnFailure(obj);
                            return Unit.INSTANCE;
                        case 8:
                            ResultKt.throwOnFailure(obj);
                            return Unit.INSTANCE;
                        case 9:
                            ResultKt.throwOnFailure(obj);
                            return Unit.INSTANCE;
                        default:
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                    }
                }

                @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
                @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$3$1$1$1", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
                static final class C16681 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
                    final String $body;
                    final int $id;
                    final ProactiveMessage $localNotification;
                    final String $title;
                    int label;
                    final DefaultMessaging this$0;

                    C16681(DefaultMessaging defaultMessaging, int i, String str, String str2, ProactiveMessage proactiveMessage, Continuation<? super C16681> continuation) {
                        super(2, continuation);
                        this.this$0 = defaultMessaging;
                        this.$id = i;
                        this.$title = str;
                        this.$body = str2;
                        this.$localNotification = proactiveMessage;
                    }

                    @Override
                    public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
                        return new C16681(this.this$0, this.$id, this.$title, this.$body, this.$localNotification, continuation);
                    }

                    @Override
                    public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
                        return ((C16681) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
                    }

                    @Override
                    public final Object invokeSuspend(Object obj) throws Throwable {
                        IntrinsicsKt.getCOROUTINE_SUSPENDED();
                        if (this.label != 0) {
                            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                        }
                        ResultKt.throwOnFailure(obj);
                        try {
                            this.this$0.localNotificationHandler.displayLocalNotification(this.$id, this.$title, this.$body);
                            this.this$0.handleProactiveMessageHasBeenDisplayed(this.$localNotification);
                        } catch (Throwable th) {
                            this.this$0.handleProactiveMessageCannotBeDisplayed(th);
                        }
                        return Unit.INSTANCE;
                    }
                }
            }

            @Override
            public final Object invokeSuspend(Object obj) throws Throwable {
                Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
                int i = this.label;
                if (i == 0) {
                    ResultKt.throwOnFailure(obj);
                    this.label = 1;
                    if (ConversationKitKt.getEventFlow(this.this$0.conversationKit).collect(new C16671(this.this$0), this) == coroutine_suspended) {
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
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (BuildersKt.withContext(DefaultMessaging.this.mainCoroutineDispatcher, new AnonymousClass1(DefaultMessaging.this, null), this) == coroutine_suspended) {
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

    public final Object resetConversationsListStorage(Continuation<? super Unit> continuation) {
        ConversationsListLocalStorageCleaner conversationsListLocalStorageCleanerBuild;
        if (this.messagingSettings.isMultiConversationsEnabled()) {
            Logger.m217d(LOG_TAG, "Conversations list cache cleaned up", new Object[0]);
            ConversationsListStorageBuilder conversationsListStorageBuilder = this.conversationsListStorageBuilder;
            if (conversationsListStorageBuilder != null && (conversationsListLocalStorageCleanerBuild = conversationsListStorageBuilder.build()) != null) {
                Object objClear = conversationsListLocalStorageCleanerBuild.clear(continuation);
                return objClear == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClear : Unit.INSTANCE;
            }
        }
        return Unit.INSTANCE;
    }

    public final void handleProactiveMessageHasBeenDisplayed(ProactiveMessage proactiveMessage) {
        this.conversationKit.dispatchEvent(new ConversationKitEvent.ProactiveMessageStatusChanged(new ProactiveMessageStatus.NotificationHasBeenDisplayed(proactiveMessage)));
    }

    public final void handleProactiveMessageCannotBeDisplayed(Throwable throwable) {
        this.conversationKit.dispatchEvent(new ConversationKitEvent.ProactiveMessageStatusChanged(new ProactiveMessageStatus.NotificationCannotBeDisplayed(throwable)));
    }

    public final Object handleMessageReceivedEvent(String str, Message message, Continuation<? super Unit> continuation) throws Throwable {
        C12651 c12651;
        DefaultMessaging defaultMessaging;
        if (continuation instanceof C12651) {
            c12651 = (C12651) continuation;
            if ((c12651.label & Integer.MIN_VALUE) != 0) {
                c12651.label -= Integer.MIN_VALUE;
            } else {
                c12651 = new C12651(continuation);
            }
        } else {
            c12651 = new C12651(continuation);
        }
        Object currentUser = c12651.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12651.label;
        if (i == 0) {
            ResultKt.throwOnFailure(currentUser);
            ConversationKit conversationKit = this.conversationKit;
            c12651.L$0 = this;
            c12651.L$1 = str;
            c12651.L$2 = message;
            c12651.label = 1;
            currentUser = conversationKit.getCurrentUser(c12651);
            if (currentUser == coroutine_suspended) {
                return coroutine_suspended;
            }
            defaultMessaging = this;
        } else {
            if (i == 1) {
                message = (Message) c12651.L$2;
                str = (String) c12651.L$1;
                defaultMessaging = (DefaultMessaging) c12651.L$0;
                ResultKt.throwOnFailure(currentUser);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                ResultKt.throwOnFailure(currentUser);
            }
            return Unit.INSTANCE;
        }
        User user = (User) currentUser;
        if (!(user != null ? UserKt.isNotAuthoredBySameUser(user, message.getAuthor()) : false)) {
            return Unit.INSTANCE;
        }
        defaultMessaging.unreadMessageCounter.increase(str);
        Function2<ZendeskEvent, Continuation<? super Unit>, Object> function2 = defaultMessaging.dispatchEvent;
        ZendeskEvent.UnreadMessageCountChanged unreadMessageCountChanged = new ZendeskEvent.UnreadMessageCountChanged(defaultMessaging.getUnreadMessageCount());
        c12651.L$0 = null;
        c12651.L$1 = null;
        c12651.L$2 = null;
        c12651.label = 2;
        if (function2.invoke(unreadMessageCountChanged, c12651) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return Unit.INSTANCE;
    }

    public final Object handleUserUpdatedEvent(ConversationKitEvent.UserUpdated userUpdated, Continuation<? super Unit> continuation) {
        for (Conversation conversation : userUpdated.getUser().getConversations()) {
            UnreadMessageCounter unreadMessageCounter = this.unreadMessageCounter;
            String id = conversation.getId();
            Participant myself = conversation.getMyself();
            unreadMessageCounter.update(id, myself != null ? myself.getUnreadCount() : 0);
        }
        Object objInvoke = this.dispatchEvent.invoke(new ZendeskEvent.UnreadMessageCountChanged(this.unreadMessageCounter.getTotalUnreadMessageCount()), continuation);
        return objInvoke == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objInvoke : Unit.INSTANCE;
    }

    public final Object handleActivityEventReceived(ConversationKitEvent.ActivityEventReceived activityEventReceived, Continuation<? super Unit> continuation) {
        if (activityEventReceived.getActivityEvent().getActivityData() == ActivityData.CONVERSATION_READ) {
            this.unreadMessageCounter.resetConversationUnread(activityEventReceived.getActivityEvent().getConversationId());
            Object objInvoke = this.dispatchEvent.invoke(new ZendeskEvent.UnreadMessageCountChanged(this.unreadMessageCounter.getTotalUnreadMessageCount()), continuation);
            return objInvoke == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objInvoke : Unit.INSTANCE;
        }
        return Unit.INSTANCE;
    }

    public final Object resetUnreadMessageCounter(Continuation<? super Unit> continuation) {
        this.unreadMessageCounter.reset();
        Object objInvoke = this.dispatchEvent.invoke(new ZendeskEvent.UnreadMessageCountChanged(0), continuation);
        return objInvoke == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objInvoke : Unit.INSTANCE;
    }

    public final Object handlePersistedUserReceivedEvent(ConversationKitEvent.PersistedUserReceived persistedUserReceived, Continuation<? super Unit> continuation) {
        for (Conversation conversation : persistedUserReceived.getUser().getConversations()) {
            UnreadMessageCounter unreadMessageCounter = this.unreadMessageCounter;
            String id = conversation.getId();
            Participant myself = conversation.getMyself();
            unreadMessageCounter.update(id, myself != null ? myself.getUnreadCount() : 0);
        }
        Object objInvoke = this.dispatchEvent.invoke(new ZendeskEvent.UnreadMessageCountChanged(this.unreadMessageCounter.getTotalUnreadMessageCount()), continuation);
        return objInvoke == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objInvoke : Unit.INSTANCE;
    }

    @Override
    public void showMessaging(Context context) {
        Intrinsics.checkNotNullParameter(context, "context");
        showMessaging(context, 0);
    }

    @Override
    public void showMessaging(Context context, int intentFlags) {
        Intrinsics.checkNotNullParameter(context, "context");
        Logger.m221i(LOG_TAG, "Showing the messaging Screen", new Object[0]);
        context.startActivity(new MessagingActivityIntentBuilder(context, this.credentials, null, 4, null).withFlags(intentFlags).getIntent());
    }

    public static Intent m226x8c0ab3fb(DefaultMessaging defaultMessaging, Context context, int i, int i2, Object obj) {
        if ((i2 & 2) != 0) {
            i = 0;
        }
        return defaultMessaging.messagingScreenIntent$zendesk_messaging_messaging_android(context, i);
    }

    public final Intent messagingScreenIntent$zendesk_messaging_messaging_android(Context context, int intentFlags) {
        Intrinsics.checkNotNullParameter(context, "context");
        return new MessagingActivityIntentBuilder(context, this.credentials, null, 4, null).withFlags(intentFlags).getIntent();
    }

    @Override
    public int getUnreadMessageCount() {
        return this.unreadMessageCounter.getTotalUnreadMessageCount();
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$setConversationFields$1", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {275}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12661 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Map<String, Object> $fields;
        int label;

        C12661(Map<String, ? extends Object> map, Continuation<? super C12661> continuation) {
            super(2, continuation);
            this.$fields = map;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultMessaging.this.new C12661(this.$fields, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12661) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                this.label = 1;
                if (DefaultMessaging.this.getConversationFieldManager().handleConversationFields(this.$fields, this) == coroutine_suspended) {
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
    public void setConversationFields(Map<String, ? extends Object> fields) {
        Intrinsics.checkNotNullParameter(fields, "fields");
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C12661(fields, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$setConversationTags$1", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {282}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12671 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final List<String> $tags;
        Object L$0;
        int label;

        C12671(List<String> list, Continuation<? super C12671> continuation) {
            super(2, continuation);
            this.$tags = list;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultMessaging.this.new C12671(this.$tags, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12671) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationMetadataService conversationMetadataService = DefaultMessaging.this.conversationKit.conversationMetadataService();
                List<String> list = this.$tags;
                this.L$0 = conversationMetadataService;
                this.label = 1;
                if (conversationMetadataService.addConversationTags(list, this) == coroutine_suspended) {
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
    public void setConversationTags(List<String> tags) {
        Intrinsics.checkNotNullParameter(tags, "tags");
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C12671(tags, null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$clearConversationFields$1", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {290}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12621 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        Object L$0;
        int label;

        C12621(Continuation<? super C12621> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultMessaging.this.new C12621(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12621) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationMetadataService conversationMetadataService = DefaultMessaging.this.conversationKit.conversationMetadataService();
                this.L$0 = conversationMetadataService;
                this.label = 1;
                if (conversationMetadataService.removeConversationFields(this) == coroutine_suspended) {
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
    public void clearConversationFields() {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C12621(null), 3, null);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.DefaultMessaging$clearConversationTags$1", m37f = "DefaultMessaging.kt", m38i = {}, m39l = {298}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C12631 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        Object L$0;
        int label;

        C12631(Continuation<? super C12631> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return DefaultMessaging.this.new C12631(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C12631) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
            int i = this.label;
            if (i == 0) {
                ResultKt.throwOnFailure(obj);
                ConversationMetadataService conversationMetadataService = DefaultMessaging.this.conversationKit.conversationMetadataService();
                this.L$0 = conversationMetadataService;
                this.label = 1;
                if (conversationMetadataService.removeConversationTags(this) == coroutine_suspended) {
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
    public void clearConversationTags() {
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new C12631(null), 3, null);
    }

    public final void handleProactiveMessageEvent$zendesk_messaging_messaging_android(Integer proactiveMessageId, ProactiveMessageEvent event) {
        Intrinsics.checkNotNullParameter(event, "event");
        BuildersKt__Builders_commonKt.launch$default(this.coroutineScope, null, null, new DefaultMessaging$handleProactiveMessageEvent$1(proactiveMessageId, this, event, null), 3, null);
    }

    public final Object clearRemainingProactiveMessages(Integer num, Continuation<? super Unit> continuation) throws Throwable {
        C12641 c12641;
        Iterator it;
        DefaultMessaging defaultMessaging;
        if (continuation instanceof C12641) {
            c12641 = (C12641) continuation;
            if ((c12641.label & Integer.MIN_VALUE) != 0) {
                c12641.label -= Integer.MIN_VALUE;
            } else {
                c12641 = new C12641(continuation);
            }
        } else {
            c12641 = new C12641(continuation);
        }
        Object obj = c12641.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c12641.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            List<Integer> localNotificationsIds = this.localNotificationHandler.getLocalNotificationsIds();
            ArrayList arrayList = new ArrayList();
            for (Object obj2 : localNotificationsIds) {
                int iIntValue = ((Number) obj2).intValue();
                if (num == null || iIntValue != num.intValue()) {
                    arrayList.add(obj2);
                }
            }
            it = arrayList.iterator();
            defaultMessaging = this;
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            it = (Iterator) c12641.L$1;
            defaultMessaging = (DefaultMessaging) c12641.L$0;
            ResultKt.throwOnFailure(obj);
        }
        while (it.hasNext()) {
            int iIntValue2 = ((Number) it.next()).intValue();
            ConversationKit conversationKit = defaultMessaging.conversationKit;
            c12641.L$0 = defaultMessaging;
            c12641.L$1 = it;
            c12641.label = 1;
            if (conversationKit.clearProactiveMessage(iIntValue2, c12641) == coroutine_suspended) {
                return coroutine_suspended;
            }
        }
        defaultMessaging.localNotificationHandler.clearLocalNotifications();
        return Unit.INSTANCE;
    }

    static Object clearRemainingProactiveMessages$default(DefaultMessaging defaultMessaging, Integer num, Continuation continuation, int i, Object obj) {
        if ((i & 1) != 0) {
            num = null;
        }
        return defaultMessaging.clearRemainingProactiveMessages(num, continuation);
    }
}
