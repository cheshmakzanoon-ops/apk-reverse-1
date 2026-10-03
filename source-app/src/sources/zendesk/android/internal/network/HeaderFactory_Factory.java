package zendesk.android.internal.network;

import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.android.internal.p013di.ZendeskComponentConfig;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;

public final class HeaderFactory_Factory implements Factory<HeaderFactory> {
    private final Provider<ZendeskComponentConfig> componentConfigProvider;
    private final Provider<LocaleProvider> localeProvider;
    private final Provider<NetworkData> networkDataProvider;

    public HeaderFactory_Factory(Provider<ZendeskComponentConfig> provider, Provider<NetworkData> provider2, Provider<LocaleProvider> provider3) {
        this.componentConfigProvider = provider;
        this.networkDataProvider = provider2;
        this.localeProvider = provider3;
    }

    @Override
    public HeaderFactory get() {
        return newInstance(this.componentConfigProvider.get(), this.networkDataProvider.get(), this.localeProvider.get());
    }

    public static HeaderFactory_Factory create(Provider<ZendeskComponentConfig> provider, Provider<NetworkData> provider2, Provider<LocaleProvider> provider3) {
        return new HeaderFactory_Factory(provider, provider2, provider3);
    }

    public static HeaderFactory newInstance(ZendeskComponentConfig zendeskComponentConfig, NetworkData networkData, LocaleProvider localeProvider) {
        return new HeaderFactory(zendeskComponentConfig, networkData, localeProvider);
    }
}
