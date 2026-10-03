package zendesk.messaging.android.internal.rest;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import okhttp3.OkHttpClient;

public final class NetworkModule_OkHttpClientFactory implements Factory<OkHttpClient> {
    private final Provider<HeaderFactory> headerFactoryProvider;
    private final NetworkModule module;

    public NetworkModule_OkHttpClientFactory(NetworkModule networkModule, Provider<HeaderFactory> provider) {
        this.module = networkModule;
        this.headerFactoryProvider = provider;
    }

    @Override
    public OkHttpClient get() {
        return okHttpClient(this.module, this.headerFactoryProvider.get());
    }

    public static NetworkModule_OkHttpClientFactory create(NetworkModule networkModule, Provider<HeaderFactory> provider) {
        return new NetworkModule_OkHttpClientFactory(networkModule, provider);
    }

    public static OkHttpClient okHttpClient(NetworkModule networkModule, HeaderFactory headerFactory) {
        return (OkHttpClient) Preconditions.checkNotNullFromProvides(networkModule.okHttpClient(headerFactory));
    }
}
