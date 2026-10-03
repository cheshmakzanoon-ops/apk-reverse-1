package zendesk.guidekit.android.internal.p018di.module;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import java.io.File;
import javax.inject.Provider;
import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import zendesk.okhttp.HeaderInterceptor;

public final class NetworkModule_ProvidesOkHttpClientFactory implements Factory<OkHttpClient> {
    private final Provider<File> cacheDirProvider;
    private final Provider<HeaderInterceptor> headerInterceptorProvider;
    private final Provider<HttpLoggingInterceptor> loggingInterceptorProvider;
    private final NetworkModule module;

    public NetworkModule_ProvidesOkHttpClientFactory(NetworkModule networkModule, Provider<HttpLoggingInterceptor> provider, Provider<HeaderInterceptor> provider2, Provider<File> provider3) {
        this.module = networkModule;
        this.loggingInterceptorProvider = provider;
        this.headerInterceptorProvider = provider2;
        this.cacheDirProvider = provider3;
    }

    @Override
    public OkHttpClient get() {
        return providesOkHttpClient(this.module, this.loggingInterceptorProvider.get(), this.headerInterceptorProvider.get(), this.cacheDirProvider.get());
    }

    public static NetworkModule_ProvidesOkHttpClientFactory create(NetworkModule networkModule, Provider<HttpLoggingInterceptor> provider, Provider<HeaderInterceptor> provider2, Provider<File> provider3) {
        return new NetworkModule_ProvidesOkHttpClientFactory(networkModule, provider, provider2, provider3);
    }

    public static OkHttpClient providesOkHttpClient(NetworkModule networkModule, HttpLoggingInterceptor httpLoggingInterceptor, HeaderInterceptor headerInterceptor, File file) {
        return (OkHttpClient) Preconditions.checkNotNullFromProvides(networkModule.providesOkHttpClient(httpLoggingInterceptor, headerInterceptor, file));
    }
}
