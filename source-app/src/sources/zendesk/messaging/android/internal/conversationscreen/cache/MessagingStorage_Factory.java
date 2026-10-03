package zendesk.messaging.android.internal.conversationscreen.cache;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.coroutines.CoroutineDispatcher;
import zendesk.storage.android.Storage;

public final class MessagingStorage_Factory implements Factory<MessagingStorage> {
    private final Provider<CoroutineDispatcher> persistenceDispatcherProvider;
    private final Provider<Storage> storageProvider;

    public MessagingStorage_Factory(Provider<CoroutineDispatcher> provider, Provider<Storage> provider2) {
        this.persistenceDispatcherProvider = provider;
        this.storageProvider = provider2;
    }

    @Override
    public MessagingStorage get() {
        return newInstance(this.persistenceDispatcherProvider.get(), this.storageProvider.get());
    }

    public static MessagingStorage_Factory create(Provider<CoroutineDispatcher> provider, Provider<Storage> provider2) {
        return new MessagingStorage_Factory(provider, provider2);
    }

    public static MessagingStorage newInstance(CoroutineDispatcher coroutineDispatcher, Storage storage) {
        return new MessagingStorage(coroutineDispatcher, storage);
    }
}
