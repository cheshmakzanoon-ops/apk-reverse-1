package zendesk.messaging.android;

import android.content.Context;
import j$.time.LocalDateTime;
import java.util.UUID;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.ZendeskCredentials;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.messaging.MessagingFactory;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.core.android.internal.p016di.KotlinxSerializationModule;
import zendesk.core.p017ui.android.internal.app.ProcessLifecycleEventObserver;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.UnreadMessageCounter;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListStorageBuilder;
import zendesk.messaging.android.internal.p023di.DaggerMessagingComponent;
import zendesk.messaging.android.internal.p023di.MessagingComponent;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;
import zendesk.messaging.android.internal.proactivemessaging.LocalNotificationHandler;
import zendesk.messaging.android.push.internal.NotificationProcessor;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u0018\u00002\u00020\u0001B\u001f\b\u0007\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0005J\u0010\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fH\u0016R\u0016\u0010\u0004\u001a\u0004\u0018\u00010\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0016\u0010\u0002\u001a\u0004\u0018\u00010\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/DefaultMessagingFactory;", "Lzendesk/android/messaging/MessagingFactory;", MessagingComponentKt.USER_LIGHT_COLORS, "Lzendesk/android/messaging/model/UserColors;", MessagingComponentKt.USER_DARK_COLORS, "(Lzendesk/android/messaging/model/UserColors;Lzendesk/android/messaging/model/UserColors;)V", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", "getUserLightColors", "create", "Lzendesk/android/messaging/Messaging;", "params", "Lzendesk/android/messaging/MessagingFactory$CreateParams;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultMessagingFactory implements MessagingFactory {
    private final UserColors userDarkColors;
    private final UserColors userLightColors;

    public DefaultMessagingFactory() {
        this(null, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0);
    }

    public DefaultMessagingFactory(UserColors userColors) {
        this(userColors, null, 2, 0 == true ? 1 : 0);
    }

    public DefaultMessagingFactory(UserColors userColors, UserColors userColors2) {
        this.userLightColors = userColors;
        this.userDarkColors = userColors2;
    }

    public DefaultMessagingFactory(UserColors userColors, UserColors userColors2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : userColors, (i & 2) != 0 ? null : userColors2);
    }

    @Override
    public UserColors getUserLightColors() {
        return this.userLightColors;
    }

    @Override
    public UserColors getUserDarkColors() {
        return this.userDarkColors;
    }

    @Override
    public zendesk.android.messaging.Messaging create(MessagingFactory.CreateParams params) {
        Intrinsics.checkNotNullParameter(params, "params");
        MessagingComponent.Factory factory = DaggerMessagingComponent.factory();
        Context applicationContext = params.getContext().getApplicationContext();
        ZendeskCredentials credentials = params.getCredentials();
        String baseUrl = params.getBaseUrl();
        MessagingSettings messagingSettings = params.getMessagingSettings();
        Function2<ZendeskEvent, Continuation<? super Unit>, Object> dispatchEvent = params.getDispatchEvent();
        CoroutineScope coroutineScope = params.getCoroutineScope();
        ConversationKit conversationKit = params.getConversationKit();
        UserColors userLightColors = params.getUserLightColors();
        UserColors userColors = userLightColors == null ? new UserColors(null, null, null, 7, null) : userLightColors;
        UserColors userDarkColors = params.getUserDarkColors();
        UserColors userColors2 = userDarkColors == null ? new UserColors(null, null, null, 7, null) : userDarkColors;
        FeatureFlagManager featureFlagManager = params.getFeatureFlagManager();
        Intrinsics.checkNotNull(applicationContext);
        MessagingComponent messagingComponentCreate = factory.create(applicationContext, credentials, baseUrl, messagingSettings, conversationKit, dispatchEvent, coroutineScope, userColors, userColors2, featureFlagManager, new Function0<LocalDateTime>() {
            @Override
            public final LocalDateTime invoke() {
                LocalDateTime localDateTimeNow = LocalDateTime.now();
                Intrinsics.checkNotNullExpressionValue(localDateTimeNow, "now(...)");
                return localDateTimeNow;
            }
        }, new Function0<String>() {
            @Override
            public final String invoke() {
                String string = UUID.randomUUID().toString();
                Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
                return string;
            }
        });
        ZendeskCredentials credentials2 = params.getCredentials();
        MessagingSettings messagingSettings2 = params.getMessagingSettings();
        ConversationKit conversationKit2 = params.getConversationKit();
        Function2<ZendeskEvent, Continuation<? super Unit>, Object> dispatchEvent2 = params.getDispatchEvent();
        ProcessLifecycleEventObserver processLifecycleEventObserverNewInstance = ProcessLifecycleEventObserver.INSTANCE.newInstance();
        CoroutineScope coroutineScope2 = params.getCoroutineScope();
        UnreadMessageCounter unreadMessageCounter = UnreadMessageCounter.INSTANCE;
        LocalNotificationHandler localNotificationHandler = new LocalNotificationHandler(new NotificationProcessor(null, KotlinxSerializationModule.INSTANCE.provideJson(), 1, 0 == true ? 1 : 0), params.getContext());
        Context applicationContext2 = params.getContext().getApplicationContext();
        Intrinsics.checkNotNullExpressionValue(applicationContext2, "getApplicationContext(...)");
        return new DefaultMessaging(credentials2, messagingSettings2, conversationKit2, dispatchEvent2, processLifecycleEventObserverNewInstance, coroutineScope2, unreadMessageCounter, localNotificationHandler, messagingComponentCreate, new ConversationsListStorageBuilder(applicationContext2, null, params.getConversationKit().getConfig().getIntegration().getId(), KotlinxSerializationModule.INSTANCE.provideJson(), 2, null), messagingComponentCreate.conversationFieldManager(), params.getFeatureFlagManager(), messagingComponentCreate.mainDispatcher());
    }
}
