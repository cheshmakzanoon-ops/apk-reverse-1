package zendesk.guidekit.android.internal.p018di.module;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import okhttp3.OkHttpClient;
import retrofit2.Converter;
import retrofit2.Retrofit;

public final class NetworkModule_RetrofitFactory implements Factory<Retrofit> {
    private final Provider<String> baseUrlProvider;
    private final Provider<Converter.Factory> converterFactoryProvider;
    private final NetworkModule module;
    private final Provider<OkHttpClient> okHttpClientProvider;

    public NetworkModule_RetrofitFactory(NetworkModule networkModule, Provider<String> provider, Provider<OkHttpClient> provider2, Provider<Converter.Factory> provider3) {
        this.module = networkModule;
        this.baseUrlProvider = provider;
        this.okHttpClientProvider = provider2;
        this.converterFactoryProvider = provider3;
    }

    @Override
    public Retrofit get() {
        return retrofit(this.module, this.baseUrlProvider.get(), this.okHttpClientProvider.get(), this.converterFactoryProvider.get());
    }

    public static NetworkModule_RetrofitFactory create(NetworkModule networkModule, Provider<String> provider, Provider<OkHttpClient> provider2, Provider<Converter.Factory> provider3) {
        return new NetworkModule_RetrofitFactory(networkModule, provider, provider2, provider3);
    }

    public static Retrofit retrofit(NetworkModule networkModule, String str, OkHttpClient okHttpClient, Converter.Factory factory) {
        return (Retrofit) Preconditions.checkNotNullFromProvides(networkModule.retrofit(str, okHttpClient, factory));
    }
}
