package zendesk.android.internal.p013di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import zendesk.android.messaging.model.MessagingSettings;

public final class ZendeskInitializedModule_ProvidesSettingsFactory implements Factory<MessagingSettings> {
    private final ZendeskInitializedModule module;

    public ZendeskInitializedModule_ProvidesSettingsFactory(ZendeskInitializedModule zendeskInitializedModule) {
        this.module = zendeskInitializedModule;
    }

    @Override
    public MessagingSettings get() {
        return providesSettings(this.module);
    }

    public static ZendeskInitializedModule_ProvidesSettingsFactory create(ZendeskInitializedModule zendeskInitializedModule) {
        return new ZendeskInitializedModule_ProvidesSettingsFactory(zendeskInitializedModule);
    }

    public static MessagingSettings providesSettings(ZendeskInitializedModule zendeskInitializedModule) {
        return (MessagingSettings) Preconditions.checkNotNullFromProvides(zendeskInitializedModule.getSettings());
    }
}
