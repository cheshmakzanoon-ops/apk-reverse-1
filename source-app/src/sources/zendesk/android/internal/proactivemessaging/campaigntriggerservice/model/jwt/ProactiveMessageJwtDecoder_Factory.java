package zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.serialization.json.Json;

public final class ProactiveMessageJwtDecoder_Factory implements Factory<ProactiveMessageJwtDecoder> {
    private final Provider<Json> jsonProvider;

    public ProactiveMessageJwtDecoder_Factory(Provider<Json> provider) {
        this.jsonProvider = provider;
    }

    @Override
    public ProactiveMessageJwtDecoder get() {
        return newInstance(this.jsonProvider.get());
    }

    public static ProactiveMessageJwtDecoder_Factory create(Provider<Json> provider) {
        return new ProactiveMessageJwtDecoder_Factory(provider);
    }

    public static ProactiveMessageJwtDecoder newInstance(Json json) {
        return new ProactiveMessageJwtDecoder(json);
    }
}
