package zendesk.messaging.android.internal.conversationscreen.conversationextension;

import dagger.MembersInjector;
import javax.inject.Named;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

public final class ConversationExtensionBottomSheetFragment_MembersInjector implements MembersInjector<ConversationExtensionBottomSheetFragment> {
    private final Provider<ConversationExtensionViewModelFactory> conversationExtensionViewModelFactoryProvider;
    private final Provider<FeatureFlagManager> featureFlagManagerProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final Provider<UserColors> userDarkColorsProvider;
    private final Provider<UserColors> userLightColorsProvider;

    public ConversationExtensionBottomSheetFragment_MembersInjector(Provider<ConversationExtensionViewModelFactory> provider, Provider<UserColors> provider2, Provider<UserColors> provider3, Provider<MessagingSettings> provider4, Provider<FeatureFlagManager> provider5) {
        this.conversationExtensionViewModelFactoryProvider = provider;
        this.userDarkColorsProvider = provider2;
        this.userLightColorsProvider = provider3;
        this.messagingSettingsProvider = provider4;
        this.featureFlagManagerProvider = provider5;
    }

    public static MembersInjector<ConversationExtensionBottomSheetFragment> create(Provider<ConversationExtensionViewModelFactory> provider, Provider<UserColors> provider2, Provider<UserColors> provider3, Provider<MessagingSettings> provider4, Provider<FeatureFlagManager> provider5) {
        return new ConversationExtensionBottomSheetFragment_MembersInjector(provider, provider2, provider3, provider4, provider5);
    }

    @Override
    public void injectMembers(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment) {
        injectConversationExtensionViewModelFactory(conversationExtensionBottomSheetFragment, this.conversationExtensionViewModelFactoryProvider.get());
        injectUserDarkColors(conversationExtensionBottomSheetFragment, this.userDarkColorsProvider.get());
        injectUserLightColors(conversationExtensionBottomSheetFragment, this.userLightColorsProvider.get());
        injectMessagingSettings(conversationExtensionBottomSheetFragment, this.messagingSettingsProvider.get());
        injectFeatureFlagManager(conversationExtensionBottomSheetFragment, this.featureFlagManagerProvider.get());
    }

    public static void injectConversationExtensionViewModelFactory(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, ConversationExtensionViewModelFactory conversationExtensionViewModelFactory) {
        conversationExtensionBottomSheetFragment.conversationExtensionViewModelFactory = conversationExtensionViewModelFactory;
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void injectUserDarkColors(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, UserColors userColors) {
        conversationExtensionBottomSheetFragment.userDarkColors = userColors;
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void injectUserLightColors(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, UserColors userColors) {
        conversationExtensionBottomSheetFragment.userLightColors = userColors;
    }

    public static void injectMessagingSettings(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, MessagingSettings messagingSettings) {
        conversationExtensionBottomSheetFragment.messagingSettings = messagingSettings;
    }

    public static void injectFeatureFlagManager(ConversationExtensionBottomSheetFragment conversationExtensionBottomSheetFragment, FeatureFlagManager featureFlagManager) {
        conversationExtensionBottomSheetFragment.featureFlagManager = featureFlagManager;
    }
}
