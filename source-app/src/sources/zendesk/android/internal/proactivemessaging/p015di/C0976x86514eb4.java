package zendesk.android.internal.proactivemessaging.p015di;

import android.content.Context;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.storage.android.Storage;

public final class C0976x86514eb4 implements Factory<Storage> {
    private final Provider<Context> contextProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final ProactiveMessagingModule module;

    public C0976x86514eb4(ProactiveMessagingModule proactiveMessagingModule, Provider<Context> provider, Provider<MessagingSettings> provider2) {
        this.module = proactiveMessagingModule;
        this.contextProvider = provider;
        this.messagingSettingsProvider = provider2;
    }

    @Override
    public Storage get() {
        return providesProactiveMessagingStorage(this.module, this.contextProvider.get(), this.messagingSettingsProvider.get());
    }

    public static C0976x86514eb4 create(ProactiveMessagingModule proactiveMessagingModule, Provider<Context> provider, Provider<MessagingSettings> provider2) {
        return new C0976x86514eb4(proactiveMessagingModule, provider, provider2);
    }

    public static Storage providesProactiveMessagingStorage(ProactiveMessagingModule proactiveMessagingModule, Context context, MessagingSettings messagingSettings) {
        return (Storage) Preconditions.checkNotNullFromProvides(proactiveMessagingModule.providesProactiveMessagingStorage(context, messagingSettings));
    }
}
