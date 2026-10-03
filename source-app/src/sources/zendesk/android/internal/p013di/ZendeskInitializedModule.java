package zendesk.android.internal.p013di;

import dagger.Module;
import dagger.Provides;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;

@Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\b\u0001\u0018\u00002\u00020\u0001B%\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\nJ\b\u0010\u000b\u001a\u00020\u0003H\u0007J\b\u0010\f\u001a\u00020\u0007H\u0007J\b\u0010\r\u001a\u00020\u0005H\u0007J\b\u0010\u000e\u001a\u00020\tH\u0007R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0007X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\b\u001a\u00020\tX\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000f"}, m18d2 = {"Lzendesk/android/internal/di/ZendeskInitializedModule;", "", "conversationKit", "Lzendesk/conversationkit/android/ConversationKit;", "messaging", "Lzendesk/android/messaging/Messaging;", "featureFlagManager", "Lzendesk/core/android/internal/app/FeatureFlagManager;", "settings", "Lzendesk/android/messaging/model/MessagingSettings;", "(Lzendesk/conversationkit/android/ConversationKit;Lzendesk/android/messaging/Messaging;Lzendesk/core/android/internal/app/FeatureFlagManager;Lzendesk/android/messaging/model/MessagingSettings;)V", "providesConversationKit", "providesFeatureFlagManager", "providesMessaging", "providesSettings", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Module
public final class ZendeskInitializedModule {
    private final ConversationKit conversationKit;
    private final FeatureFlagManager featureFlagManager;
    private final Messaging messaging;
    private final MessagingSettings settings;

    public ZendeskInitializedModule(ConversationKit conversationKit, Messaging messaging, FeatureFlagManager featureFlagManager, MessagingSettings settings) {
        Intrinsics.checkNotNullParameter(conversationKit, "conversationKit");
        Intrinsics.checkNotNullParameter(messaging, "messaging");
        Intrinsics.checkNotNullParameter(featureFlagManager, "featureFlagManager");
        Intrinsics.checkNotNullParameter(settings, "settings");
        this.conversationKit = conversationKit;
        this.messaging = messaging;
        this.featureFlagManager = featureFlagManager;
        this.settings = settings;
    }

    @Provides
    @ZendeskInitializedComponentScope
    public final Messaging getMessaging() {
        return this.messaging;
    }

    @Provides
    @ZendeskInitializedComponentScope
    public final ConversationKit getConversationKit() {
        return this.conversationKit;
    }

    @Provides
    @ZendeskInitializedComponentScope
    public final FeatureFlagManager getFeatureFlagManager() {
        return this.featureFlagManager;
    }

    @Provides
    @ZendeskInitializedComponentScope
    public final MessagingSettings getSettings() {
        return this.settings;
    }
}
