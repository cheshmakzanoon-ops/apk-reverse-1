package zendesk.messaging.android.internal.conversationscreen;

import dagger.MembersInjector;
import javax.inject.Named;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.guidekit.android.GuideKit;
import zendesk.messaging.android.internal.messagingscreen.BackNavigationResolver;
import zendesk.messaging.android.internal.messagingscreen.MessagingNavigator;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

public final class ConversationFragment_MembersInjector implements MembersInjector<ConversationFragment> {
    private final Provider<BackNavigationResolver> backNavigationResolverProvider;
    private final Provider<ConversationScreenViewModelFactory> conversationScreenViewModelFactoryProvider;
    private final Provider<FeatureFlagManager> featureFlagManagerProvider;
    private final Provider<GuideKit> guideKitProvider;
    private final Provider<MessagingNavigator> messagingNavigatorProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final Provider<UserColors> userDarkColorsProvider;
    private final Provider<UserColors> userLightColorsProvider;

    public ConversationFragment_MembersInjector(Provider<ConversationScreenViewModelFactory> provider, Provider<MessagingSettings> provider2, Provider<UserColors> provider3, Provider<UserColors> provider4, Provider<GuideKit> provider5, Provider<MessagingNavigator> provider6, Provider<BackNavigationResolver> provider7, Provider<FeatureFlagManager> provider8) {
        this.conversationScreenViewModelFactoryProvider = provider;
        this.messagingSettingsProvider = provider2;
        this.userDarkColorsProvider = provider3;
        this.userLightColorsProvider = provider4;
        this.guideKitProvider = provider5;
        this.messagingNavigatorProvider = provider6;
        this.backNavigationResolverProvider = provider7;
        this.featureFlagManagerProvider = provider8;
    }

    public static MembersInjector<ConversationFragment> create(Provider<ConversationScreenViewModelFactory> provider, Provider<MessagingSettings> provider2, Provider<UserColors> provider3, Provider<UserColors> provider4, Provider<GuideKit> provider5, Provider<MessagingNavigator> provider6, Provider<BackNavigationResolver> provider7, Provider<FeatureFlagManager> provider8) {
        return new ConversationFragment_MembersInjector(provider, provider2, provider3, provider4, provider5, provider6, provider7, provider8);
    }

    @Override
    public void injectMembers(ConversationFragment conversationFragment) {
        injectConversationScreenViewModelFactory(conversationFragment, this.conversationScreenViewModelFactoryProvider.get());
        injectMessagingSettings(conversationFragment, this.messagingSettingsProvider.get());
        injectUserDarkColors(conversationFragment, this.userDarkColorsProvider.get());
        injectUserLightColors(conversationFragment, this.userLightColorsProvider.get());
        injectGuideKit(conversationFragment, this.guideKitProvider.get());
        injectMessagingNavigator(conversationFragment, this.messagingNavigatorProvider.get());
        injectBackNavigationResolver(conversationFragment, this.backNavigationResolverProvider.get());
        injectFeatureFlagManager(conversationFragment, this.featureFlagManagerProvider.get());
    }

    public static void injectConversationScreenViewModelFactory(ConversationFragment conversationFragment, ConversationScreenViewModelFactory conversationScreenViewModelFactory) {
        conversationFragment.conversationScreenViewModelFactory = conversationScreenViewModelFactory;
    }

    public static void injectMessagingSettings(ConversationFragment conversationFragment, MessagingSettings messagingSettings) {
        conversationFragment.messagingSettings = messagingSettings;
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void injectUserDarkColors(ConversationFragment conversationFragment, UserColors userColors) {
        conversationFragment.userDarkColors = userColors;
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void injectUserLightColors(ConversationFragment conversationFragment, UserColors userColors) {
        conversationFragment.userLightColors = userColors;
    }

    public static void injectGuideKit(ConversationFragment conversationFragment, GuideKit guideKit) {
        conversationFragment.guideKit = guideKit;
    }

    public static void injectMessagingNavigator(ConversationFragment conversationFragment, MessagingNavigator messagingNavigator) {
        conversationFragment.messagingNavigator = messagingNavigator;
    }

    public static void injectBackNavigationResolver(ConversationFragment conversationFragment, BackNavigationResolver backNavigationResolver) {
        conversationFragment.backNavigationResolver = backNavigationResolver;
    }

    public static void injectFeatureFlagManager(ConversationFragment conversationFragment, FeatureFlagManager featureFlagManager) {
        conversationFragment.featureFlagManager = featureFlagManager;
    }
}
