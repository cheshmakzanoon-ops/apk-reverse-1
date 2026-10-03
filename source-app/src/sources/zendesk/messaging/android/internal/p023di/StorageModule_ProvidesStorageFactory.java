package zendesk.messaging.android.internal.p023di;

import android.content.Context;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.storage.android.Storage;
import zendesk.storage.android.StorageType;

public final class StorageModule_ProvidesStorageFactory implements Factory<Storage> {
    private final Provider<Context> contextProvider;
    private final Provider<String> identifierProvider;
    private final StorageModule module;
    private final Provider<StorageType> storageTypeProvider;

    public StorageModule_ProvidesStorageFactory(StorageModule storageModule, Provider<Context> provider, Provider<StorageType> provider2, Provider<String> provider3) {
        this.module = storageModule;
        this.contextProvider = provider;
        this.storageTypeProvider = provider2;
        this.identifierProvider = provider3;
    }

    @Override
    public Storage get() {
        return providesStorage(this.module, this.contextProvider.get(), this.storageTypeProvider.get(), this.identifierProvider.get());
    }

    public static StorageModule_ProvidesStorageFactory create(StorageModule storageModule, Provider<Context> provider, Provider<StorageType> provider2, Provider<String> provider3) {
        return new StorageModule_ProvidesStorageFactory(storageModule, provider, provider2, provider3);
    }

    public static Storage providesStorage(StorageModule storageModule, Context context, StorageType storageType, String str) {
        return (Storage) Preconditions.checkNotNullFromProvides(storageModule.providesStorage(context, storageType, str));
    }
}
