package zendesk.messaging.android.internal.conversationslistscreen;

import dagger.MembersInjector;
import javax.inject.Named;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.messaging.android.internal.messagingscreen.MessagingNavigator;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

public final class ConversationListFragment_MembersInjector implements MembersInjector<ConversationListFragment> {
    private final Provider<ConversationsListScreenViewModelFactory> conversationsListScreenViewModelFactoryProvider;
    private final Provider<FeatureFlagManager> featureFlagManagerProvider;
    private final Provider<MessagingNavigator> messagingNavigatorProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final Provider<UserColors> userDarkColorsProvider;
    private final Provider<UserColors> userLightColorsProvider;

    public ConversationListFragment_MembersInjector(Provider<ConversationsListScreenViewModelFactory> provider, Provider<MessagingSettings> provider2, Provider<UserColors> provider3, Provider<UserColors> provider4, Provider<FeatureFlagManager> provider5, Provider<MessagingNavigator> provider6) {
        this.conversationsListScreenViewModelFactoryProvider = provider;
        this.messagingSettingsProvider = provider2;
        this.userDarkColorsProvider = provider3;
        this.userLightColorsProvider = provider4;
        this.featureFlagManagerProvider = provider5;
        this.messagingNavigatorProvider = provider6;
    }

    public static MembersInjector<ConversationListFragment> create(Provider<ConversationsListScreenViewModelFactory> provider, Provider<MessagingSettings> provider2, Provider<UserColors> provider3, Provider<UserColors> provider4, Provider<FeatureFlagManager> provider5, Provider<MessagingNavigator> provider6) {
        return new ConversationListFragment_MembersInjector(provider, provider2, provider3, provider4, provider5, provider6);
    }

    @Override
    public void injectMembers(ConversationListFragment conversationListFragment) {
        injectConversationsListScreenViewModelFactory(conversationListFragment, this.conversationsListScreenViewModelFactoryProvider.get());
        injectMessagingSettings(conversationListFragment, this.messagingSettingsProvider.get());
        injectUserDarkColors(conversationListFragment, this.userDarkColorsProvider.get());
        injectUserLightColors(conversationListFragment, this.userLightColorsProvider.get());
        injectFeatureFlagManager(conversationListFragment, this.featureFlagManagerProvider.get());
        injectMessagingNavigator(conversationListFragment, this.messagingNavigatorProvider.get());
    }

    public static void injectConversationsListScreenViewModelFactory(ConversationListFragment conversationListFragment, ConversationsListScreenViewModelFactory conversationsListScreenViewModelFactory) {
        conversationListFragment.conversationsListScreenViewModelFactory = conversationsListScreenViewModelFactory;
    }

    public static void injectMessagingSettings(ConversationListFragment conversationListFragment, MessagingSettings messagingSettings) {
        conversationListFragment.messagingSettings = messagingSettings;
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void injectUserDarkColors(ConversationListFragment conversationListFragment, UserColors userColors) {
        conversationListFragment.userDarkColors = userColors;
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void injectUserLightColors(ConversationListFragment conversationListFragment, UserColors userColors) {
        conversationListFragment.userLightColors = userColors;
    }

    public static void injectFeatureFlagManager(ConversationListFragment conversationListFragment, FeatureFlagManager featureFlagManager) {
        conversationListFragment.featureFlagManager = featureFlagManager;
    }

    public static void injectMessagingNavigator(ConversationListFragment conversationListFragment, MessagingNavigator messagingNavigator) {
        conversationListFragment.messagingNavigator = messagingNavigator;
    }
}
