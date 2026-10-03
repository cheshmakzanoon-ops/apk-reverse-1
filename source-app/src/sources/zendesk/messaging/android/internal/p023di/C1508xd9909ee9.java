package zendesk.messaging.android.internal.p023di;

import android.os.Bundle;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.messaging.android.internal.MessagingEntryPointHandler;
import zendesk.messaging.android.internal.messagingscreen.MessagingScreenViewModelFactory;

public final class C1508xd9909ee9 implements Factory<MessagingScreenViewModelFactory> {
    private final Provider<Bundle> defaultArgsProvider;
    private final Provider<MessagingEntryPointHandler> messagingEntryPointHandlerProvider;
    private final MessagingScreenModule module;
    private final Provider<SavedStateRegistryOwner> savedStateRegistryOwnerProvider;

    public C1508xd9909ee9(MessagingScreenModule messagingScreenModule, Provider<MessagingEntryPointHandler> provider, Provider<SavedStateRegistryOwner> provider2, Provider<Bundle> provider3) {
        this.module = messagingScreenModule;
        this.messagingEntryPointHandlerProvider = provider;
        this.savedStateRegistryOwnerProvider = provider2;
        this.defaultArgsProvider = provider3;
    }

    @Override
    public MessagingScreenViewModelFactory get() {
        return providesMessagingScreenViewModelFactory(this.module, this.messagingEntryPointHandlerProvider.get(), this.savedStateRegistryOwnerProvider.get(), this.defaultArgsProvider.get());
    }

    public static C1508xd9909ee9 create(MessagingScreenModule messagingScreenModule, Provider<MessagingEntryPointHandler> provider, Provider<SavedStateRegistryOwner> provider2, Provider<Bundle> provider3) {
        return new C1508xd9909ee9(messagingScreenModule, provider, provider2, provider3);
    }

    public static MessagingScreenViewModelFactory providesMessagingScreenViewModelFactory(MessagingScreenModule messagingScreenModule, MessagingEntryPointHandler messagingEntryPointHandler, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
        return (MessagingScreenViewModelFactory) Preconditions.checkNotNullFromProvides(messagingScreenModule.providesMessagingScreenViewModelFactory(messagingEntryPointHandler, savedStateRegistryOwner, bundle));
    }
}
