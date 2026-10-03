package zendesk.android.internal.p013di;

import dagger.Subcomponent;
import kotlin.Metadata;
import zendesk.android.Zendesk;
import zendesk.android.internal.frontendevents.p014di.FrontendEventsModule;
import zendesk.android.internal.proactivemessaging.p015di.ProactiveMessagingModule;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;

@Subcomponent(modules = {ZendeskInitializedModule.class, ProactiveMessagingModule.class, FrontendEventsModule.class})
@ZendeskInitializedComponentScope
@Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\ba\u0018\u00002\u00020\u0001:\u0001\fJ\b\u0010\u0002\u001a\u00020\u0003H&J\b\u0010\u0004\u001a\u00020\u0005H&J\b\u0010\u0006\u001a\u00020\u0007H&J\b\u0010\b\u001a\u00020\tH&J\b\u0010\n\u001a\u00020\u000bH&¨\u0006\r"}, m18d2 = {"Lzendesk/android/internal/di/ZendeskInitializedComponent;", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "messaging", "Lzendesk/android/messaging/Messaging;", "settings", "Lzendesk/android/messaging/model/MessagingSettings;", "zendesk", "Lzendesk/android/Zendesk;", "Builder", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ZendeskInitializedComponent {

    @Subcomponent.Builder
    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\bg\u0018\u00002\u00020\u0001J\b\u0010\u0002\u001a\u00020\u0003H&J\u0010\u0010\u0004\u001a\u00020\u00002\u0006\u0010\u0005\u001a\u00020\u0006H&¨\u0006\u0007"}, m18d2 = {"Lzendesk/android/internal/di/ZendeskInitializedComponent$Builder;", "", "build", "Lzendesk/android/internal/di/ZendeskInitializedComponent;", "zendeskInitializedModule", "module", "Lzendesk/android/internal/di/ZendeskInitializedModule;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public interface Builder {
        ZendeskInitializedComponent build();

        Builder zendeskInitializedModule(ZendeskInitializedModule module);
    }

    ConversationKit conversationKit();

    FeatureFlagManager featureFlagManager();

    Messaging messaging();

    MessagingSettings settings();

    Zendesk zendesk();
}
