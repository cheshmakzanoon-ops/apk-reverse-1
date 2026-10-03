package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer.p021di;

import android.content.Context;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.guidekit.android.GuideKit;

public final class GuideKitModule_ProvidesGuideKitFactory implements Factory<GuideKit> {
    private final Provider<String> baseUrlProvider;
    private final Provider<Context> contextProvider;
    private final Provider<CoroutineScope> coroutineScopeProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final GuideKitModule module;

    public GuideKitModule_ProvidesGuideKitFactory(GuideKitModule guideKitModule, Provider<Context> provider, Provider<String> provider2, Provider<MessagingSettings> provider3, Provider<CoroutineScope> provider4) {
        this.module = guideKitModule;
        this.contextProvider = provider;
        this.baseUrlProvider = provider2;
        this.messagingSettingsProvider = provider3;
        this.coroutineScopeProvider = provider4;
    }

    @Override
    public GuideKit get() {
        return providesGuideKit(this.module, this.contextProvider.get(), this.baseUrlProvider.get(), this.messagingSettingsProvider.get(), this.coroutineScopeProvider.get());
    }

    public static GuideKitModule_ProvidesGuideKitFactory create(GuideKitModule guideKitModule, Provider<Context> provider, Provider<String> provider2, Provider<MessagingSettings> provider3, Provider<CoroutineScope> provider4) {
        return new GuideKitModule_ProvidesGuideKitFactory(guideKitModule, provider, provider2, provider3, provider4);
    }

    public static GuideKit providesGuideKit(GuideKitModule guideKitModule, Context context, String str, MessagingSettings messagingSettings, CoroutineScope coroutineScope) {
        return (GuideKit) Preconditions.checkNotNullFromProvides(guideKitModule.providesGuideKit(context, str, messagingSettings, coroutineScope));
    }
}
