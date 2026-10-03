package zendesk.messaging.android.internal.messagingscreen;

import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;

public final class BackNavigationResolver_Factory implements Factory<BackNavigationResolver> {
    private final Provider<ConversationKit> conversationKitProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;

    public BackNavigationResolver_Factory(Provider<ConversationKit> provider, Provider<MessagingSettings> provider2) {
        this.conversationKitProvider = provider;
        this.messagingSettingsProvider = provider2;
    }

    @Override
    public BackNavigationResolver get() {
        return newInstance(this.conversationKitProvider.get(), this.messagingSettingsProvider.get());
    }

    public static BackNavigationResolver_Factory create(Provider<ConversationKit> provider, Provider<MessagingSettings> provider2) {
        return new BackNavigationResolver_Factory(provider, provider2);
    }

    public static BackNavigationResolver newInstance(ConversationKit conversationKit, MessagingSettings messagingSettings) {
        return new BackNavigationResolver(conversationKit, messagingSettings);
    }
}
