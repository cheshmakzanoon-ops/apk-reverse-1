package zendesk.messaging.android.internal.p023di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.messaging.android.internal.conversationscreen.cache.MessagingStorageSerializer;
import zendesk.storage.android.StorageType;

public final class StorageModule_ProvidesStorageTypeFactory implements Factory<StorageType> {
    private final Provider<MessagingStorageSerializer> messagingStorageSerializerProvider;
    private final StorageModule module;

    public StorageModule_ProvidesStorageTypeFactory(StorageModule storageModule, Provider<MessagingStorageSerializer> provider) {
        this.module = storageModule;
        this.messagingStorageSerializerProvider = provider;
    }

    @Override
    public StorageType get() {
        return providesStorageType(this.module, this.messagingStorageSerializerProvider.get());
    }

    public static StorageModule_ProvidesStorageTypeFactory create(StorageModule storageModule, Provider<MessagingStorageSerializer> provider) {
        return new StorageModule_ProvidesStorageTypeFactory(storageModule, provider);
    }

    public static StorageType providesStorageType(StorageModule storageModule, MessagingStorageSerializer messagingStorageSerializer) {
        return (StorageType) Preconditions.checkNotNullFromProvides(storageModule.providesStorageType(messagingStorageSerializer));
    }
}
