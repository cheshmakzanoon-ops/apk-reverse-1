package zendesk.messaging.android.internal.conversationslistscreen.p022di;

import android.content.Context;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.storage.android.Storage;
import zendesk.storage.android.StorageType;

public final class C1498x46816fb6 implements Factory<Storage> {
    private final Provider<Context> contextProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final ConversationsListLocalStorageModule module;
    private final Provider<StorageType> storageTypeProvider;

    public C1498x46816fb6(ConversationsListLocalStorageModule conversationsListLocalStorageModule, Provider<Context> provider, Provider<StorageType> provider2, Provider<MessagingSettings> provider3) {
        this.module = conversationsListLocalStorageModule;
        this.contextProvider = provider;
        this.storageTypeProvider = provider2;
        this.messagingSettingsProvider = provider3;
    }

    @Override
    public Storage get() {
        return providesConversationsListStorage(this.module, this.contextProvider.get(), this.storageTypeProvider.get(), this.messagingSettingsProvider.get());
    }

    public static C1498x46816fb6 create(ConversationsListLocalStorageModule conversationsListLocalStorageModule, Provider<Context> provider, Provider<StorageType> provider2, Provider<MessagingSettings> provider3) {
        return new C1498x46816fb6(conversationsListLocalStorageModule, provider, provider2, provider3);
    }

    public static Storage providesConversationsListStorage(ConversationsListLocalStorageModule conversationsListLocalStorageModule, Context context, StorageType storageType, MessagingSettings messagingSettings) {
        return (Storage) Preconditions.checkNotNullFromProvides(conversationsListLocalStorageModule.providesConversationsListStorage(context, storageType, messagingSettings));
    }
}
