package zendesk.messaging.android.internal.rest;

import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.core.p017ui.android.internal.local.LocaleProvider;

public final class HeaderFactory_Factory implements Factory<HeaderFactory> {
    private final Provider<LocaleProvider> localeProvider;

    public HeaderFactory_Factory(Provider<LocaleProvider> provider) {
        this.localeProvider = provider;
    }

    @Override
    public HeaderFactory get() {
        return newInstance(this.localeProvider.get());
    }

    public static HeaderFactory_Factory create(Provider<LocaleProvider> provider) {
        return new HeaderFactory_Factory(provider);
    }

    public static HeaderFactory newInstance(LocaleProvider localeProvider) {
        return new HeaderFactory(localeProvider);
    }
}
