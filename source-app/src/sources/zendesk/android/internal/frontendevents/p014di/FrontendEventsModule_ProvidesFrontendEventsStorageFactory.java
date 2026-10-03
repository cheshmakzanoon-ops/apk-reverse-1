package zendesk.android.internal.frontendevents.p014di;

import android.content.Context;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.storage.android.Storage;

public final class FrontendEventsModule_ProvidesFrontendEventsStorageFactory implements Factory<Storage> {
    private final Provider<Context> contextProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final FrontendEventsModule module;

    public FrontendEventsModule_ProvidesFrontendEventsStorageFactory(FrontendEventsModule frontendEventsModule, Provider<Context> provider, Provider<MessagingSettings> provider2) {
        this.module = frontendEventsModule;
        this.contextProvider = provider;
        this.messagingSettingsProvider = provider2;
    }

    @Override
    public Storage get() {
        return providesFrontendEventsStorage(this.module, this.contextProvider.get(), this.messagingSettingsProvider.get());
    }

    public static FrontendEventsModule_ProvidesFrontendEventsStorageFactory create(FrontendEventsModule frontendEventsModule, Provider<Context> provider, Provider<MessagingSettings> provider2) {
        return new FrontendEventsModule_ProvidesFrontendEventsStorageFactory(frontendEventsModule, provider, provider2);
    }

    public static Storage providesFrontendEventsStorage(FrontendEventsModule frontendEventsModule, Context context, MessagingSettings messagingSettings) {
        return (Storage) Preconditions.checkNotNullFromProvides(frontendEventsModule.providesFrontendEventsStorage(context, messagingSettings));
    }
}
