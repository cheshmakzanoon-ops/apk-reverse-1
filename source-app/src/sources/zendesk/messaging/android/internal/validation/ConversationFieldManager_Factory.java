package zendesk.messaging.android.internal.validation;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function2;
import zendesk.android.events.ZendeskEvent;
import zendesk.conversationkit.android.ConversationKit;
import zendesk.core.android.internal.app.FeatureFlagManager;

public final class ConversationFieldManager_Factory implements Factory<ConversationFieldManager> {
    private final Provider<ConversationFieldValidator> conversationFieldValidatorProvider;
    private final Provider<ConversationKit> conversationKitProvider;
    private final Provider<Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ?>> dispatchEventProvider;
    private final Provider<FeatureFlagManager> featureFlagManagerProvider;

    public ConversationFieldManager_Factory(Provider<ConversationFieldValidator> provider, Provider<ConversationKit> provider2, Provider<Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ?>> provider3, Provider<FeatureFlagManager> provider4) {
        this.conversationFieldValidatorProvider = provider;
        this.conversationKitProvider = provider2;
        this.dispatchEventProvider = provider3;
        this.featureFlagManagerProvider = provider4;
    }

    @Override
    public ConversationFieldManager get() {
        return newInstance(this.conversationFieldValidatorProvider.get(), this.conversationKitProvider.get(), this.dispatchEventProvider.get(), this.featureFlagManagerProvider.get());
    }

    public static ConversationFieldManager_Factory create(Provider<ConversationFieldValidator> provider, Provider<ConversationKit> provider2, Provider<Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ?>> provider3, Provider<FeatureFlagManager> provider4) {
        return new ConversationFieldManager_Factory(provider, provider2, provider3, provider4);
    }

    public static ConversationFieldManager newInstance(ConversationFieldValidator conversationFieldValidator, ConversationKit conversationKit, Function2<? super ZendeskEvent, ? super Continuation<? super Unit>, ?> function2, FeatureFlagManager featureFlagManager) {
        return new ConversationFieldManager(conversationFieldValidator, conversationKit, function2, featureFlagManager);
    }
}
