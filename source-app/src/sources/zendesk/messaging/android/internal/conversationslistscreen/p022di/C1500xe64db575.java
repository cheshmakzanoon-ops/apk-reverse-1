package zendesk.messaging.android.internal.conversationslistscreen.p022di;

import androidx.appcompat.app.AppCompatActivity;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.messaging.android.internal.conversationslistscreen.ConversationsListScreenViewModelFactory;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.ConversationsListRepository;

public final class C1500xe64db575 implements Factory<ConversationsListScreenViewModelFactory> {
    private final Provider<AppCompatActivity> activityProvider;
    private final Provider<ConversationKit> conversationKitProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final ConversationsListScreenModule module;
    private final Provider<ConversationsListRepository> repositoryProvider;

    public C1500xe64db575(ConversationsListScreenModule conversationsListScreenModule, Provider<MessagingSettings> provider, Provider<ConversationKit> provider2, Provider<AppCompatActivity> provider3, Provider<ConversationsListRepository> provider4) {
        this.module = conversationsListScreenModule;
        this.messagingSettingsProvider = provider;
        this.conversationKitProvider = provider2;
        this.activityProvider = provider3;
        this.repositoryProvider = provider4;
    }

    @Override
    public ConversationsListScreenViewModelFactory get() {
        return providesConversationsListScreenViewModel(this.module, this.messagingSettingsProvider.get(), this.conversationKitProvider.get(), this.activityProvider.get(), this.repositoryProvider.get());
    }

    public static C1500xe64db575 create(ConversationsListScreenModule conversationsListScreenModule, Provider<MessagingSettings> provider, Provider<ConversationKit> provider2, Provider<AppCompatActivity> provider3, Provider<ConversationsListRepository> provider4) {
        return new C1500xe64db575(conversationsListScreenModule, provider, provider2, provider3, provider4);
    }

    public static ConversationsListScreenViewModelFactory providesConversationsListScreenViewModel(ConversationsListScreenModule conversationsListScreenModule, MessagingSettings messagingSettings, ConversationKit conversationKit, AppCompatActivity appCompatActivity, ConversationsListRepository conversationsListRepository) {
        return (ConversationsListScreenViewModelFactory) Preconditions.checkNotNullFromProvides(conversationsListScreenModule.providesConversationsListScreenViewModel(messagingSettings, conversationKit, appCompatActivity, conversationsListRepository));
    }
}
