package zendesk.messaging.android.internal.conversationscreen;

import dagger.MembersInjector;
import javax.inject.Named;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

public final class ImageViewerActivity_MembersInjector implements MembersInjector<ImageViewerActivity> {
    private final Provider<ConversationScreenViewModelFactory> conversationScreenViewModelFactoryProvider;
    private final Provider<FeatureFlagManager> featureFlagManagerProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final Provider<UserColors> userDarkColorsProvider;
    private final Provider<UserColors> userLightColorsProvider;

    public ImageViewerActivity_MembersInjector(Provider<ConversationScreenViewModelFactory> provider, Provider<MessagingSettings> provider2, Provider<UserColors> provider3, Provider<UserColors> provider4, Provider<FeatureFlagManager> provider5) {
        this.conversationScreenViewModelFactoryProvider = provider;
        this.messagingSettingsProvider = provider2;
        this.userDarkColorsProvider = provider3;
        this.userLightColorsProvider = provider4;
        this.featureFlagManagerProvider = provider5;
    }

    public static MembersInjector<ImageViewerActivity> create(Provider<ConversationScreenViewModelFactory> provider, Provider<MessagingSettings> provider2, Provider<UserColors> provider3, Provider<UserColors> provider4, Provider<FeatureFlagManager> provider5) {
        return new ImageViewerActivity_MembersInjector(provider, provider2, provider3, provider4, provider5);
    }

    @Override
    public void injectMembers(ImageViewerActivity imageViewerActivity) {
        injectConversationScreenViewModelFactory(imageViewerActivity, this.conversationScreenViewModelFactoryProvider.get());
        injectMessagingSettings(imageViewerActivity, this.messagingSettingsProvider.get());
        injectUserDarkColors(imageViewerActivity, this.userDarkColorsProvider.get());
        injectUserLightColors(imageViewerActivity, this.userLightColorsProvider.get());
        injectFeatureFlagManager(imageViewerActivity, this.featureFlagManagerProvider.get());
    }

    public static void injectConversationScreenViewModelFactory(ImageViewerActivity imageViewerActivity, ConversationScreenViewModelFactory conversationScreenViewModelFactory) {
        imageViewerActivity.conversationScreenViewModelFactory = conversationScreenViewModelFactory;
    }

    public static void injectMessagingSettings(ImageViewerActivity imageViewerActivity, MessagingSettings messagingSettings) {
        imageViewerActivity.messagingSettings = messagingSettings;
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void injectUserDarkColors(ImageViewerActivity imageViewerActivity, UserColors userColors) {
        imageViewerActivity.userDarkColors = userColors;
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void injectUserLightColors(ImageViewerActivity imageViewerActivity, UserColors userColors) {
        imageViewerActivity.userLightColors = userColors;
    }

    public static void injectFeatureFlagManager(ImageViewerActivity imageViewerActivity, FeatureFlagManager featureFlagManager) {
        imageViewerActivity.featureFlagManager = featureFlagManager;
    }
}
