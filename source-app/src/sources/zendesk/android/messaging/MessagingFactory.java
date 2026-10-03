package zendesk.android.messaging;

import android.content.Context;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.ZendeskCredentials;
import zendesk.android.events.ZendeskEvent;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bf\u0018\u00002\u00020\u0001:\u0001\fJ\u0010\u0010\b\u001a\u00020\t2\u0006\u0010\n\u001a\u00020\u000bH&R\u0014\u0010\u0002\u001a\u0004\u0018\u00010\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005R\u0014\u0010\u0006\u001a\u0004\u0018\u00010\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0007\u0010\u0005¨\u0006\r"}, m18d2 = {"Lzendesk/android/messaging/MessagingFactory;", "", MessagingComponentKt.USER_DARK_COLORS, "Lzendesk/android/messaging/model/UserColors;", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", MessagingComponentKt.USER_LIGHT_COLORS, "getUserLightColors", "create", "Lzendesk/android/messaging/Messaging;", "params", "Lzendesk/android/messaging/MessagingFactory$CreateParams;", "CreateParams", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface MessagingFactory {
    Messaging create(CreateParams params);

    UserColors getUserDarkColors();

    UserColors getUserLightColors();

    @Metadata(m17d1 = {"\u0000N\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0017\u0018\u00002\u00020\u0001B{\b\u0000\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\"\u0010\u000e\u001a\u001e\b\u0001\u0012\u0004\u0012\u00020\u0010\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00120\u0011\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u000f\u0012\u0006\u0010\u0013\u001a\u00020\u0014\u0012\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u0016\u0012\n\b\u0002\u0010\u0017\u001a\u0004\u0018\u00010\u0016¢\u0006\u0002\u0010\u0018R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R/\u0010\u000e\u001a\u001e\b\u0001\u0012\u0004\u0012\u00020\u0010\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u00120\u0011\u0012\u0006\u0012\u0004\u0018\u00010\u00010\u000f¢\u0006\n\n\u0002\u0010%\u001a\u0004\b#\u0010$R\u0011\u0010\u0013\u001a\u00020\u0014¢\u0006\b\n\u0000\u001a\u0004\b&\u0010'R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b(\u0010)R\u0013\u0010\u0017\u001a\u0004\u0018\u00010\u0016¢\u0006\b\n\u0000\u001a\u0004\b*\u0010+R\u0013\u0010\u0015\u001a\u0004\u0018\u00010\u0016¢\u0006\b\n\u0000\u001a\u0004\b,\u0010+¨\u0006-"}, m18d2 = {"Lzendesk/android/messaging/MessagingFactory$CreateParams;", "", "context", "Landroid/content/Context;", "credentials", "Lzendesk/android/ZendeskCredentials;", "baseUrl", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "messagingSettings", "Lzendesk/android/messaging/model/MessagingSettings;", "coroutineScope", "Lkotlinx/coroutines/CoroutineScope;", "dispatchEvent", "Lkotlin/Function2;", "Lzendesk/android/events/ZendeskEvent;", "Lkotlin/coroutines/Continuation;", "", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", MessagingComponentKt.USER_LIGHT_COLORS, "Lzendesk/android/messaging/model/UserColors;", MessagingComponentKt.USER_DARK_COLORS, "(Landroid/content/Context;Lzendesk/android/ZendeskCredentials;Ljava/lang/String;Lzendesk/conversationkit/android/ConversationKit;Lzendesk/android/messaging/model/MessagingSettings;Lkotlinx/coroutines/CoroutineScope;Lkotlin/jvm/functions/Function2;Lzendesk/core/android/internal/app/FeatureFlagManager;Lzendesk/android/messaging/model/UserColors;Lzendesk/android/messaging/model/UserColors;)V", "getBaseUrl", "()Ljava/lang/String;", "getContext", "()Landroid/content/Context;", "getConversationKit", "()Lzendesk/conversationkit/android/ConversationKit;", "getCoroutineScope", "()Lkotlinx/coroutines/CoroutineScope;", "getCredentials", "()Lzendesk/android/ZendeskCredentials;", "getDispatchEvent", "()Lkotlin/jvm/functions/Function2;", "Lkotlin/jvm/functions/Function2;", "getFeatureFlagManager", "()Lzendesk/core/android/internal/app/FeatureFlagManager;", "getMessagingSettings", "()Lzendesk/android/messaging/model/MessagingSettings;", "getUserDarkColors", "()Lzendesk/android/messaging/model/UserColors;", "getUserLightColors", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CreateParams {
        private final String baseUrl;
        private final Context context;
        private final ConversationKit conversationKit;
        private final CoroutineScope coroutineScope;
        private final ZendeskCredentials credentials;
        private final Function2<ZendeskEvent, Continuation<? super Unit>, Object> dispatchEvent;
        private final FeatureFlagManager featureFlagManager;
        private final MessagingSettings messagingSettings;
        private final UserColors userDarkColors;
        private final UserColors userLightColors;

        public CreateParams(Context context, ZendeskCredentials credentials, String baseUrl, ConversationKit conversationKit, MessagingSettings messagingSettings, CoroutineScope coroutineScope, Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ? extends Object> dispatchEvent, FeatureFlagManager featureFlagManager, UserColors userColors, UserColors userColors2) {
            Intrinsics.checkNotNullParameter(context, "context");
            Intrinsics.checkNotNullParameter(credentials, "credentials");
            Intrinsics.checkNotNullParameter(baseUrl, "baseUrl");
            Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
            Intrinsics.checkNotNullParameter(messagingSettings, "messagingSettings");
            Intrinsics.checkNotNullParameter(coroutineScope, "coroutineScope");
            Intrinsics.checkNotNullParameter(dispatchEvent, "dispatchEvent");
            Intrinsics.checkNotNullParameter(featureFlagManager, "featureFlagManager");
            this.context = context;
            this.credentials = credentials;
            this.baseUrl = baseUrl;
            this.conversationKit = conversationKit;
            this.messagingSettings = messagingSettings;
            this.coroutineScope = coroutineScope;
            this.dispatchEvent = dispatchEvent;
            this.featureFlagManager = featureFlagManager;
            this.userLightColors = userColors;
            this.userDarkColors = userColors2;
        }

        public CreateParams(Context context, ZendeskCredentials zendeskCredentials, String str, ConversationKit conversationKit, MessagingSettings messagingSettings, CoroutineScope coroutineScope, Function2 function2, FeatureFlagManager featureFlagManager, UserColors userColors, UserColors userColors2, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(context, zendeskCredentials, str, conversationKit, messagingSettings, coroutineScope, function2, featureFlagManager, (i & 256) != 0 ? null : userColors, (i & 512) != 0 ? null : userColors2);
        }

        public final Context getContext() {
            return this.context;
        }

        public final ZendeskCredentials getCredentials() {
            return this.credentials;
        }

        public final String getBaseUrl() {
            return this.baseUrl;
        }

        public final ConversationKit getConversationKit() {
            return this.conversationKit;
        }

        public final MessagingSettings getMessagingSettings() {
            return this.messagingSettings;
        }

        public final CoroutineScope getCoroutineScope() {
            return this.coroutineScope;
        }

        public final Function2<ZendeskEvent, Continuation<? super Unit>, Object> getDispatchEvent() {
            return this.dispatchEvent;
        }

        public final FeatureFlagManager getFeatureFlagManager() {
            return this.featureFlagManager;
        }

        public final UserColors getUserLightColors() {
            return this.userLightColors;
        }

        public final UserColors getUserDarkColors() {
            return this.userDarkColors;
        }
    }
}
