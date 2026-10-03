package zendesk.messaging.android.internal.messagingscreen;

import dagger.MembersInjector;
import javax.inject.Named;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.android.messaging.model.UserColors;
import zendesk.messaging.android.internal.p023di.MessagingComponentKt;

public final class MessagingActivity_MembersInjector implements MembersInjector<MessagingActivity> {
    private final Provider<MessagingNavigator> messagingNavigatorProvider;
    private final Provider<MessagingScreenViewModelFactory> messagingScreenViewModelFactoryProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final Provider<UserColors> userDarkColorsProvider;
    private final Provider<UserColors> userLightColorsProvider;

    public MessagingActivity_MembersInjector(Provider<MessagingSettings> provider, Provider<UserColors> provider2, Provider<UserColors> provider3, Provider<MessagingScreenViewModelFactory> provider4, Provider<MessagingNavigator> provider5) {
        this.messagingSettingsProvider = provider;
        this.userDarkColorsProvider = provider2;
        this.userLightColorsProvider = provider3;
        this.messagingScreenViewModelFactoryProvider = provider4;
        this.messagingNavigatorProvider = provider5;
    }

    public static MembersInjector<MessagingActivity> create(Provider<MessagingSettings> provider, Provider<UserColors> provider2, Provider<UserColors> provider3, Provider<MessagingScreenViewModelFactory> provider4, Provider<MessagingNavigator> provider5) {
        return new MessagingActivity_MembersInjector(provider, provider2, provider3, provider4, provider5);
    }

    @Override
    public void injectMembers(MessagingActivity messagingActivity) {
        injectMessagingSettings(messagingActivity, this.messagingSettingsProvider.get());
        injectUserDarkColors(messagingActivity, this.userDarkColorsProvider.get());
        injectUserLightColors(messagingActivity, this.userLightColorsProvider.get());
        injectMessagingScreenViewModelFactory(messagingActivity, this.messagingScreenViewModelFactoryProvider.get());
        injectMessagingNavigator(messagingActivity, this.messagingNavigatorProvider.get());
    }

    public static void injectMessagingSettings(MessagingActivity messagingActivity, MessagingSettings messagingSettings) {
        messagingActivity.messagingSettings = messagingSettings;
    }

    @Named(MessagingComponentKt.USER_DARK_COLORS)
    public static void injectUserDarkColors(MessagingActivity messagingActivity, UserColors userColors) {
        messagingActivity.userDarkColors = userColors;
    }

    @Named(MessagingComponentKt.USER_LIGHT_COLORS)
    public static void injectUserLightColors(MessagingActivity messagingActivity, UserColors userColors) {
        messagingActivity.userLightColors = userColors;
    }

    public static void injectMessagingScreenViewModelFactory(MessagingActivity messagingActivity, MessagingScreenViewModelFactory messagingScreenViewModelFactory) {
        messagingActivity.messagingScreenViewModelFactory = messagingScreenViewModelFactory;
    }

    public static void injectMessagingNavigator(MessagingActivity messagingActivity, MessagingNavigator messagingNavigator) {
        messagingActivity.messagingNavigator = messagingNavigator;
    }
}
