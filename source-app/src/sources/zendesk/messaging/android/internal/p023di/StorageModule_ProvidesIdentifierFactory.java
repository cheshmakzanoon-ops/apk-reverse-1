package zendesk.messaging.android.internal.p023di;

import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;

public final class StorageModule_ProvidesIdentifierFactory implements Factory<String> {
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final StorageModule module;

    public StorageModule_ProvidesIdentifierFactory(StorageModule storageModule, Provider<MessagingSettings> provider) {
        this.module = storageModule;
        this.messagingSettingsProvider = provider;
    }

    @Override
    public String get() {
        return providesIdentifier(this.module, this.messagingSettingsProvider.get());
    }

    public static StorageModule_ProvidesIdentifierFactory create(StorageModule storageModule, Provider<MessagingSettings> provider) {
        return new StorageModule_ProvidesIdentifierFactory(storageModule, provider);
    }

    public static String providesIdentifier(StorageModule storageModule, MessagingSettings messagingSettings) {
        return storageModule.providesIdentifier(messagingSettings);
    }
}
