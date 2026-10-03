package zendesk.messaging.android.internal;

import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;

public final class MessagingEntryPointHandler_Factory implements Factory<MessagingEntryPointHandler> {
    private final Provider<ConversationKit> conversationKitProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;

    public MessagingEntryPointHandler_Factory(Provider<ConversationKit> provider, Provider<MessagingSettings> provider2) {
        this.conversationKitProvider = provider;
        this.messagingSettingsProvider = provider2;
    }

    @Override
    public MessagingEntryPointHandler get() {
        return newInstance(this.conversationKitProvider.get(), this.messagingSettingsProvider.get());
    }

    public static MessagingEntryPointHandler_Factory create(Provider<ConversationKit> provider, Provider<MessagingSettings> provider2) {
        return new MessagingEntryPointHandler_Factory(provider, provider2);
    }

    public static MessagingEntryPointHandler newInstance(ConversationKit conversationKit, MessagingSettings messagingSettings) {
        return new MessagingEntryPointHandler(conversationKit, messagingSettings);
    }
}
