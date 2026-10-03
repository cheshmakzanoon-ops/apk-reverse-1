package zendesk.messaging.android.internal.conversationslistscreen.conversation;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.coroutines.CoroutineDispatcher;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListInMemoryCache;

public final class ConversationsListRepository_Factory implements Factory<ConversationsListRepository> {
    private final Provider<ConversationKit> conversationKitProvider;
    private final Provider<ConversationsListInMemoryCache> conversationsListInMemoryCacheProvider;
    private final Provider<CoroutineDispatcher> defaultDispatcherProvider;
    private final Provider<ConversationLogEntryMapper> mapperProvider;

    public ConversationsListRepository_Factory(Provider<ConversationKit> provider, Provider<CoroutineDispatcher> provider2, Provider<ConversationLogEntryMapper> provider3, Provider<ConversationsListInMemoryCache> provider4) {
        this.conversationKitProvider = provider;
        this.defaultDispatcherProvider = provider2;
        this.mapperProvider = provider3;
        this.conversationsListInMemoryCacheProvider = provider4;
    }

    @Override
    public ConversationsListRepository get() {
        return newInstance(this.conversationKitProvider.get(), this.defaultDispatcherProvider.get(), this.mapperProvider.get(), this.conversationsListInMemoryCacheProvider.get());
    }

    public static ConversationsListRepository_Factory create(Provider<ConversationKit> provider, Provider<CoroutineDispatcher> provider2, Provider<ConversationLogEntryMapper> provider3, Provider<ConversationsListInMemoryCache> provider4) {
        return new ConversationsListRepository_Factory(provider, provider2, provider3, provider4);
    }

    public static ConversationsListRepository newInstance(ConversationKit conversationKit, CoroutineDispatcher coroutineDispatcher, ConversationLogEntryMapper conversationLogEntryMapper, ConversationsListInMemoryCache conversationsListInMemoryCache) {
        return new ConversationsListRepository(conversationKit, coroutineDispatcher, conversationLogEntryMapper, conversationsListInMemoryCache);
    }
}
