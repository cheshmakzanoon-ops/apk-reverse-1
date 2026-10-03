package zendesk.messaging.android.internal.conversationscreen.guidearticleviewer;

import dagger.MembersInjector;
import javax.inject.Named;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.guidekit.android.GuideKit;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

public final class GuideArticleViewerBottomSheetFragment_MembersInjector implements MembersInjector<GuideArticleViewerBottomSheetFragment> {
    private final Provider<String> baseUrlProvider;
    private final Provider<GuideArticleViewerViewModelFactory> guideArticleViewerViewModelFactoryProvider;
    private final Provider<GuideKit> guideKitProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final Provider<UserColors> userDarkColorsProvider;
    private final Provider<UserColors> userLightColorsProvider;

    public GuideArticleViewerBottomSheetFragment_MembersInjector(Provider<GuideKit> provider, Provider<GuideArticleViewerViewModelFactory> provider2, Provider<UserColors> provider3, Provider<UserColors> provider4, Provider<String> provider5, Provider<MessagingSettings> provider6) {
        this.guideKitProvider = provider;
        this.guideArticleViewerViewModelFactoryProvider = provider2;
        this.userDarkColorsProvider = provider3;
        this.userLightColorsProvider = provider4;
        this.baseUrlProvider = provider5;
        this.messagingSettingsProvider = provider6;
    }

    public static MembersInjector<GuideArticleViewerBottomSheetFragment> create(Provider<GuideKit> provider, Provider<GuideArticleViewerViewModelFactory> provider2, Provider<UserColors> provider3, Provider<UserColors> provider4, Provider<String> provider5, Provider<MessagingSettings> provider6) {
        return new GuideArticleViewerBottomSheetFragment_MembersInjector(provider, provider2, provider3, provider4, provider5, provider6);
    }

    @Override
    public void injectMembers(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment) {
        injectGuideKit(guideArticleViewerBottomSheetFragment, this.guideKitProvider.get());
        injectGuideArticleViewerViewModelFactory(guideArticleViewerBottomSheetFragment, this.guideArticleViewerViewModelFactoryProvider.get());
        injectUserDarkColors(guideArticleViewerBottomSheetFragment, this.userDarkColorsProvider.get());
        injectUserLightColors(guideArticleViewerBottomSheetFragment, this.userLightColorsProvider.get());
        injectBaseUrl(guideArticleViewerBottomSheetFragment, this.baseUrlProvider.get());
        injectMessagingSettings(guideArticleViewerBottomSheetFragment, this.messagingSettingsProvider.get());
    }

    public static void injectGuideKit(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, GuideKit guideKit) {
        guideArticleViewerBottomSheetFragment.guideKit = guideKit;
    }

    public static void injectGuideArticleViewerViewModelFactory(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, GuideArticleViewerViewModelFactory guideArticleViewerViewModelFactory) {
        guideArticleViewerBottomSheetFragment.guideArticleViewerViewModelFactory = guideArticleViewerViewModelFactory;
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void injectUserDarkColors(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, UserColors userColors) {
        guideArticleViewerBottomSheetFragment.userDarkColors = userColors;
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void injectUserLightColors(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, UserColors userColors) {
        guideArticleViewerBottomSheetFragment.userLightColors = userColors;
    }

    @Named("baseUrl")
    public static void injectBaseUrl(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, String str) {
        guideArticleViewerBottomSheetFragment.baseUrl = str;
    }

    public static void injectMessagingSettings(GuideArticleViewerBottomSheetFragment guideArticleViewerBottomSheetFragment, MessagingSettings messagingSettings) {
        guideArticleViewerBottomSheetFragment.messagingSettings = messagingSettings;
    }
}
