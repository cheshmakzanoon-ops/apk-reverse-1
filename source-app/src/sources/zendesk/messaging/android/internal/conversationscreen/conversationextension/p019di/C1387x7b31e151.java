package zendesk.messaging.android.internal.conversationscreen.conversationextension.p019di;

import android.os.Bundle;
import androidx.savedstate.SavedStateRegistryOwner;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.messaging.android.internal.conversationscreen.conversationextension.ConversationExtensionViewModelFactory;

public final class C1387x7b31e151 implements Factory<ConversationExtensionViewModelFactory> {
    private final Provider<Bundle> defaultArgsProvider;
    private final ConversationExtensionModule module;
    private final Provider<SavedStateRegistryOwner> savedStateRegistryOwnerProvider;

    public C1387x7b31e151(ConversationExtensionModule conversationExtensionModule, Provider<SavedStateRegistryOwner> provider, Provider<Bundle> provider2) {
        this.module = conversationExtensionModule;
        this.savedStateRegistryOwnerProvider = provider;
        this.defaultArgsProvider = provider2;
    }

    @Override
    public ConversationExtensionViewModelFactory get() {
        return providesConversationExtensionViewModelFactory(this.module, this.savedStateRegistryOwnerProvider.get(), this.defaultArgsProvider.get());
    }

    public static C1387x7b31e151 create(ConversationExtensionModule conversationExtensionModule, Provider<SavedStateRegistryOwner> provider, Provider<Bundle> provider2) {
        return new C1387x7b31e151(conversationExtensionModule, provider, provider2);
    }

    public static ConversationExtensionViewModelFactory providesConversationExtensionViewModelFactory(ConversationExtensionModule conversationExtensionModule, SavedStateRegistryOwner savedStateRegistryOwner, Bundle bundle) {
        return (ConversationExtensionViewModelFactory) Preconditions.checkNotNullFromProvides(conversationExtensionModule.providesConversationExtensionViewModelFactory(savedStateRegistryOwner, bundle));
    }
}
