package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di;

import android.os.Bundle;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.guidekit.android.GuideKit;
import zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.GuideArticleViewerViewModelFactory;

public final class C1434x2c061edf implements Factory<GuideArticleViewerViewModelFactory> {
    private final Provider<Bundle> defaultArgsProvider;
    private final Provider<GuideKit> guideKitProvider;
    private final GuideArticleViewerModule module;
    private final Provider<SavedStateRegistryOwner> savedStateRegistryOwnerProvider;

    public C1434x2c061edf(GuideArticleViewerModule guideArticleViewerModule, Provider<GuideKit> provider, Provider<SavedStateRegistryOwner> provider2, Provider<Bundle> provider3) {
        this.module = guideArticleViewerModule;
        this.guideKitProvider = provider;
        this.savedStateRegistryOwnerProvider = provider2;
        this.defaultArgsProvider = provider3;
    }

    @Override
    public GuideArticleViewerViewModelFactory get() {
        return providesGuideArticleViewerViewModelFactory(this.module, this.guideKitProvider.get(), this.savedStateRegistryOwnerProvider.get(), this.defaultArgsProvider.get());
    }

    public static C1434x2c061edf create(GuideArticleViewerModule guideArticleViewerModule, Provider<GuideKit> provider, Provider<SavedStateRegistryOwner> provider2, Provider<Bundle> provider3) {
        return new C1434x2c061edf(guideArticleViewerModule, provider, provider2, provider3);
    }

    public static GuideArticleViewerViewModelFactory providesGuideArticleViewerViewModelFactory(GuideArticleViewerModule guideArticleViewerModule, GuideKit guideKit, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
        return (GuideArticleViewerViewModelFactory) Preconditions.checkNotNullFromProvides(guideArticleViewerModule.providesGuideArticleViewerViewModelFactory(guideKit, savedStateRegistryOwner, bundle));
    }
}
