package zendesk.messaging.android.internal.conversationscreen.p020di;

import android.os.Bundle;
import androidx.appcompat.app.AppCompatActivity;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import kotlinx.coroutines.CoroutineScope;
import zendesk.android.messaging.model.MessagingSettings;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;
import zendesk.messaging.android.internal.ConversationTitleProvider;
import zendesk.messaging.android.internal.NewMessagesDividerHandler;
import zendesk.messaging.android.internal.UploadFileResourceProvider;
import zendesk.messaging.android.internal.conversationscreen.ConversationScreenRepository;
import zendesk.messaging.android.internal.conversationscreen.ConversationScreenViewModelFactory;
import zendesk.messaging.android.internal.conversationscreen.MessageLogEntryMapper;

public final class C1419xb55511cb implements Factory<ConversationScreenViewModelFactory> {
    private final Provider<AppCompatActivity> activityProvider;
    private final Provider<ConversationKit> conversationKitProvider;
    private final Provider<ConversationScreenRepository> conversationScreenRepositoryProvider;
    private final Provider<ConversationTitleProvider> conversationTitleProvider;
    private final Provider<Bundle> defaultArgsProvider;
    private final Provider<FeatureFlagManager> featureFlagManagerProvider;
    private final Provider<MessageLogEntryMapper> messageLogEntryMapperProvider;
    private final Provider<MessagingSettings> messagingSettingsProvider;
    private final ConversationScreenModule module;
    private final Provider<NewMessagesDividerHandler> newMessagesDividerHandlerProvider;
    private final Provider<SavedStateRegistryOwner> savedStateRegistryOwnerProvider;
    private final Provider<CoroutineScope> sdkCoroutineScopeProvider;
    private final Provider<UploadFileResourceProvider> uploadFileResourceProvider;

    public C1419xb55511cb(ConversationScreenModule conversationScreenModule, Provider<MessagingSettings> provider, Provider<MessageLogEntryMapper> provider2, Provider<NewMessagesDividerHandler> provider3, Provider<AppCompatActivity> provider4, Provider<SavedStateRegistryOwner> provider5, Provider<Bundle> provider6, Provider<CoroutineScope> provider7, Provider<UploadFileResourceProvider> provider8, Provider<ConversationScreenRepository> provider9, Provider<ConversationTitleProvider> provider10, Provider<FeatureFlagManager> provider11, Provider<ConversationKit> provider12) {
        this.module = conversationScreenModule;
        this.messagingSettingsProvider = provider;
        this.messageLogEntryMapperProvider = provider2;
        this.newMessagesDividerHandlerProvider = provider3;
        this.activityProvider = provider4;
        this.savedStateRegistryOwnerProvider = provider5;
        this.defaultArgsProvider = provider6;
        this.sdkCoroutineScopeProvider = provider7;
        this.uploadFileResourceProvider = provider8;
        this.conversationScreenRepositoryProvider = provider9;
        this.conversationTitleProvider = provider10;
        this.featureFlagManagerProvider = provider11;
        this.conversationKitProvider = provider12;
    }

    @Override
    public ConversationScreenViewModelFactory get() {
        return providesConversationViewModelFactory(this.module, this.messagingSettingsProvider.get(), this.messageLogEntryMapperProvider.get(), this.newMessagesDividerHandlerProvider.get(), this.activityProvider.get(), this.savedStateRegistryOwnerProvider.get(), this.defaultArgsProvider.get(), this.sdkCoroutineScopeProvider.get(), this.uploadFileResourceProvider.get(), this.conversationScreenRepositoryProvider.get(), this.conversationTitleProvider.get(), this.featureFlagManagerProvider.get(), this.conversationKitProvider.get());
    }

    public static C1419xb55511cb create(ConversationScreenModule conversationScreenModule, Provider<MessagingSettings> provider, Provider<MessageLogEntryMapper> provider2, Provider<NewMessagesDividerHandler> provider3, Provider<AppCompatActivity> provider4, Provider<SavedStateRegistryOwner> provider5, Provider<Bundle> provider6, Provider<CoroutineScope> provider7, Provider<UploadFileResourceProvider> provider8, Provider<ConversationScreenRepository> provider9, Provider<ConversationTitleProvider> provider10, Provider<FeatureFlagManager> provider11, Provider<ConversationKit> provider12) {
        return new C1419xb55511cb(conversationScreenModule, provider, provider2, provider3, provider4, provider5, provider6, provider7, provider8, provider9, provider10, provider11, provider12);
    }

    public static ConversationScreenViewModelFactory providesConversationViewModelFactory(ConversationScreenModule conversationScreenModule, MessagingSettings messagingSettings, MessageLogEntryMapper messageLogEntryMapper, NewMessagesDividerHandler newMessagesDividerHandler, AppCompatActivity appCompatActivity, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle, CoroutineScope coroutineScope, UploadFileResourceProvider uploadFileResourceProvider, ConversationScreenRepository conversationScreenRepository, ConversationTitleProvider conversationTitleProvider, FeatureFlagManager featureFlagManager, ConversationKit conversationKit) {
        return (ConversationScreenViewModelFactory) Preconditions.checkNotNullFromProvides(conversationScreenModule.providesConversationViewModelFactory(messagingSettings, messageLogEntryMapper, newMessagesDividerHandler, appCompatActivity, savedStateRegistryOwner, bundle, coroutineScope, uploadFileResourceProvider, conversationScreenRepository, conversationTitleProvider, featureFlagManager, conversationKit));
    }
}
