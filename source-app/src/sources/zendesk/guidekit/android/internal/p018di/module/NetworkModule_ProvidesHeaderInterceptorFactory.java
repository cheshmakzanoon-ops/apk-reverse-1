package zendesk.guidekit.android.internal.p018di.module;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;
import zendesk.okhttp.HeaderInterceptor;

public final class NetworkModule_ProvidesHeaderInterceptorFactory implements Factory<HeaderInterceptor> {
    private final Provider<LocaleProvider> localeProvider;
    private final NetworkModule module;

    public NetworkModule_ProvidesHeaderInterceptorFactory(NetworkModule networkModule, Provider<LocaleProvider> provider) {
        this.module = networkModule;
        this.localeProvider = provider;
    }

    @Override
    public HeaderInterceptor get() {
        return providesHeaderInterceptor(this.module, this.localeProvider.get());
    }

    public static NetworkModule_ProvidesHeaderInterceptorFactory create(NetworkModule networkModule, Provider<LocaleProvider> provider) {
        return new NetworkModule_ProvidesHeaderInterceptorFactory(networkModule, provider);
    }

    public static HeaderInterceptor providesHeaderInterceptor(NetworkModule networkModule, LocaleProvider localeProvider) {
        return (HeaderInterceptor) Preconditions.checkNotNullFromProvides(networkModule.providesHeaderInterceptor(localeProvider));
    }
}
