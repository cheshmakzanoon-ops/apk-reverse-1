package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.coroutines.CoroutineDispatcher;
import zendesk.storage.android.Storage;

public final class ConversationsListLocalStorageIOImpl_Factory implements Factory<ConversationsListLocalStorageIOImpl> {
    private final Provider<CoroutineDispatcher> persistenceDispatcherProvider;
    private final Provider<Storage> storageProvider;

    public ConversationsListLocalStorageIOImpl_Factory(Provider<CoroutineDispatcher> provider, Provider<Storage> provider2) {
        this.persistenceDispatcherProvider = provider;
        this.storageProvider = provider2;
    }

    @Override
    public ConversationsListLocalStorageIOImpl get() {
        return newInstance(this.persistenceDispatcherProvider.get(), this.storageProvider.get());
    }

    public static ConversationsListLocalStorageIOImpl_Factory create(Provider<CoroutineDispatcher> provider, Provider<Storage> provider2) {
        return new ConversationsListLocalStorageIOImpl_Factory(provider, provider2);
    }

    public static ConversationsListLocalStorageIOImpl newInstance(CoroutineDispatcher coroutineDispatcher, Storage storage) {
        return new ConversationsListLocalStorageIOImpl(coroutineDispatcher, storage);
    }
}
