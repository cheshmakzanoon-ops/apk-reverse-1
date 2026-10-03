package zendesk.guidekit.android.internal.p018di.module;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.guidekit.android.model.GuideKitSettings;

public final class GuideKitModule_ProvidesBaseUrlFactory implements Factory<String> {
    private final GuideKitModule module;
    private final Provider<GuideKitSettings> settingsProvider;

    public GuideKitModule_ProvidesBaseUrlFactory(GuideKitModule guideKitModule, Provider<GuideKitSettings> provider) {
        this.module = guideKitModule;
        this.settingsProvider = provider;
    }

    @Override
    public String get() {
        return providesBaseUrl(this.module, this.settingsProvider.get());
    }

    public static GuideKitModule_ProvidesBaseUrlFactory create(GuideKitModule guideKitModule, Provider<GuideKitSettings> provider) {
        return new GuideKitModule_ProvidesBaseUrlFactory(guideKitModule, provider);
    }

    public static String providesBaseUrl(GuideKitModule guideKitModule, GuideKitSettings guideKitSettings) {
        return (String) Preconditions.checkNotNullFromProvides(guideKitModule.providesBaseUrl(guideKitSettings));
    }
}
