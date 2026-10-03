package zendesk.guidekit.android.internal.p018di.module;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import okhttp3.logging.HttpLoggingInterceptor;

public final class NetworkModule_ProvidesHttpLoggingInterceptorFactory implements Factory<HttpLoggingInterceptor> {
    private final NetworkModule module;

    public NetworkModule_ProvidesHttpLoggingInterceptorFactory(NetworkModule networkModule) {
        this.module = networkModule;
    }

    @Override
    public HttpLoggingInterceptor get() {
        return providesHttpLoggingInterceptor(this.module);
    }

    public static NetworkModule_ProvidesHttpLoggingInterceptorFactory create(NetworkModule networkModule) {
        return new NetworkModule_ProvidesHttpLoggingInterceptorFactory(networkModule);
    }

    public static HttpLoggingInterceptor providesHttpLoggingInterceptor(NetworkModule networkModule) {
        return (HttpLoggingInterceptor) Preconditions.checkNotNullFromProvides(networkModule.providesHttpLoggingInterceptor());
    }
}
