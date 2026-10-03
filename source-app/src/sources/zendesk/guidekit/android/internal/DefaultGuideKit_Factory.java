package zendesk.guidekit.android.internal;

import dagger.internal.Factory;
import javax.inject.Provider;
import zendesk.guidekit.android.internal.data.GuideKitRepository;

public final class DefaultGuideKit_Factory implements Factory<DefaultGuideKit> {
    private final Provider<GuideKitRepository> guideKitRepositoryProvider;

    public DefaultGuideKit_Factory(Provider<GuideKitRepository> provider) {
        this.guideKitRepositoryProvider = provider;
    }

    @Override
    public DefaultGuideKit get() {
        return newInstance(this.guideKitRepositoryProvider.get());
    }

    public static DefaultGuideKit_Factory create(Provider<GuideKitRepository> provider) {
        return new DefaultGuideKit_Factory(provider);
    }

    public static DefaultGuideKit newInstance(GuideKitRepository guideKitRepository) {
        return new DefaultGuideKit(guideKitRepository);
    }
}
