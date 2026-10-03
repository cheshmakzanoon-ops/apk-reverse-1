package zendesk.messaging.android.internal.conversationscreen;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.coroutines.CoroutineDispatcher;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorage;

public final class ConversationScreenRepository_Factory implements Factory<ConversationScreenRepository> {
    private final Provider<ConversationKit> conversationKitProvider;
    private final Provider<CoroutineDispatcher> defaultDispatcherProvider;
    private final Provider<MessagingStorage> messagingStorageProvider;

    public ConversationScreenRepository_Factory(Provider<ConversationKit> provider, Provider<MessagingStorage> provider2, Provider<CoroutineDispatcher> provider3) {
        this.conversationKitProvider = provider;
        this.messagingStorageProvider = provider2;
        this.defaultDispatcherProvider = provider3;
    }

    @Override
    public ConversationScreenRepository get() {
        return newInstance(this.conversationKitProvider.get(), this.messagingStorageProvider.get(), this.defaultDispatcherProvider.get());
    }

    public static ConversationScreenRepository_Factory create(Provider<ConversationKit> provider, Provider<MessagingStorage> provider2, Provider<CoroutineDispatcher> provider3) {
        return new ConversationScreenRepository_Factory(provider, provider2, provider3);
    }

    public static ConversationScreenRepository newInstance(ConversationKit conversationKit, MessagingStorage messagingStorage, CoroutineDispatcher coroutineDispatcher) {
        return new ConversationScreenRepository(conversationKit, messagingStorage, coroutineDispatcher);
    }
}
