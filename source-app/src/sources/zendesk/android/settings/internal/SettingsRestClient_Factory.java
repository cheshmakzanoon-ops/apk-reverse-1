package zendesk.android.settings.internal;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.serialization.json.Json;
import zendesk.android.internal.p013di.ZendeskComponentConfig;

public final class SettingsRestClient_Factory implements Factory<SettingsRestClient> {
    private final Provider<Json> jsonProvider;
    private final Provider<SettingsApi> settingsApiProvider;
    private final Provider<ZendeskComponentConfig> zendeskComponentConfigProvider;

    public SettingsRestClient_Factory(Provider<SettingsApi> provider, Provider<Json> provider2, Provider<ZendeskComponentConfig> provider3) {
        this.settingsApiProvider = provider;
        this.jsonProvider = provider2;
        this.zendeskComponentConfigProvider = provider3;
    }

    @Override
    public SettingsRestClient get() {
        return newInstance(this.settingsApiProvider.get(), this.jsonProvider.get(), this.zendeskComponentConfigProvider.get());
    }

    public static SettingsRestClient_Factory create(Provider<SettingsApi> provider, Provider<Json> provider2, Provider<ZendeskComponentConfig> provider3) {
        return new SettingsRestClient_Factory(provider, provider2, provider3);
    }

    public static SettingsRestClient newInstance(SettingsApi settingsApi, Json json, ZendeskComponentConfig zendeskComponentConfig) {
        return new SettingsRestClient(settingsApi, json, zendeskComponentConfig);
    }
}
