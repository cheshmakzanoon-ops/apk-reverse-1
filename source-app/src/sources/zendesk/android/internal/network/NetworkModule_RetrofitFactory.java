package zendesk.android.internal.network;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import okhttp3.OkHttpClient;
import retrofit2.Converter;
import retrofit2.Retrofit;
import zendesk.android.internal.p013di.ZendeskComponentConfig;

public final class NetworkModule_RetrofitFactory implements Factory<Retrofit> {
    private final Provider<ZendeskComponentConfig> componentConfigProvider;
    private final Provider<Converter.Factory> converterFactoryProvider;
    private final NetworkModule module;
    private final Provider<OkHttpClient> okHttpClientProvider;

    public NetworkModule_RetrofitFactory(NetworkModule networkModule, Provider<ZendeskComponentConfig> provider, Provider<OkHttpClient> provider2, Provider<Converter.Factory> provider3) {
        this.module = networkModule;
        this.componentConfigProvider = provider;
        this.okHttpClientProvider = provider2;
        this.converterFactoryProvider = provider3;
    }

    @Override
    public Retrofit get() {
        return retrofit(this.module, this.componentConfigProvider.get(), this.okHttpClientProvider.get(), this.converterFactoryProvider.get());
    }

    public static NetworkModule_RetrofitFactory create(NetworkModule networkModule, Provider<ZendeskComponentConfig> provider, Provider<OkHttpClient> provider2, Provider<Converter.Factory> provider3) {
        return new NetworkModule_RetrofitFactory(networkModule, provider, provider2, provider3);
    }

    public static Retrofit retrofit(NetworkModule networkModule, ZendeskComponentConfig zendeskComponentConfig, OkHttpClient okHttpClient, Converter.Factory factory) {
        return (Retrofit) Preconditions.checkNotNullFromProvides(networkModule.retrofit(zendeskComponentConfig, okHttpClient, factory));
    }
}
