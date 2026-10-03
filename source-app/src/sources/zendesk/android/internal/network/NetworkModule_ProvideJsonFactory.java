package zendesk.android.internal.network;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import kotlinx.serialization.json.Json;

public final class NetworkModule_ProvideJsonFactory implements Factory<Json> {
    private final NetworkModule module;

    public NetworkModule_ProvideJsonFactory(NetworkModule networkModule) {
        this.module = networkModule;
    }

    @Override
    public Json get() {
        return provideJson(this.module);
    }

    public static NetworkModule_ProvideJsonFactory create(NetworkModule networkModule) {
        return new NetworkModule_ProvideJsonFactory(networkModule);
    }

    public static Json provideJson(NetworkModule networkModule) {
        return (Json) Preconditions.checkNotNullFromProvides(networkModule.provideJson());
    }
}
