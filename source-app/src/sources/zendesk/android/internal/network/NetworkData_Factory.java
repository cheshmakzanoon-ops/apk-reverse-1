package zendesk.android.internal.network;

import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.android.internal.p013di.ZendeskComponentConfig;

public final class NetworkData_Factory implements Factory<NetworkData> {
    private final Provider<ZendeskComponentConfig> configProvider;

    public NetworkData_Factory(Provider<ZendeskComponentConfig> provider) {
        this.configProvider = provider;
    }

    @Override
    public NetworkData get() {
        return newInstance(this.configProvider.get());
    }

    public static NetworkData_Factory create(Provider<ZendeskComponentConfig> provider) {
        return new NetworkData_Factory(provider);
    }

    public static NetworkData newInstance(ZendeskComponentConfig zendeskComponentConfig) {
        return new NetworkData(zendeskComponentConfig);
    }
}
