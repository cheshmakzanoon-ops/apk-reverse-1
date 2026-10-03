package zendesk.android.internal.network;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import kotlinx.serialization.json.Json;
import retrofit2.Converter;

public final class NetworkModule_ProvideKotlinSerializationFactory implements Factory<Converter.Factory> {
    private final Provider<Json> jsonProvider;
    private final NetworkModule module;

    public NetworkModule_ProvideKotlinSerializationFactory(NetworkModule networkModule, Provider<Json> provider) {
        this.module = networkModule;
        this.jsonProvider = provider;
    }

    @Override
    public Converter.Factory get() {
        return provideKotlinSerialization(this.module, this.jsonProvider.get());
    }

    public static NetworkModule_ProvideKotlinSerializationFactory create(NetworkModule networkModule, Provider<Json> provider) {
        return new NetworkModule_ProvideKotlinSerializationFactory(networkModule, provider);
    }

    public static Converter.Factory provideKotlinSerialization(NetworkModule networkModule, Json json) {
        return (Converter.Factory) Preconditions.checkNotNullFromProvides(networkModule.provideKotlinSerialization(json));
    }
}
