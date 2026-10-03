package zendesk.messaging.android.internal.validation;

import dagger.internal.Factory;
import javax.inject.Provider;

public final class ConversationFieldValidator_Factory implements Factory<ConversationFieldValidator> {
    private final Provider<ConversationFieldRepository> conversationFieldRepositoryProvider;
    private final Provider<ValidationRules> rulesProvider;

    public ConversationFieldValidator_Factory(Provider<ValidationRules> provider, Provider<ConversationFieldRepository> provider2) {
        this.rulesProvider = provider;
        this.conversationFieldRepositoryProvider = provider2;
    }

    @Override
    public ConversationFieldValidator get() {
        return newInstance(this.rulesProvider.get(), this.conversationFieldRepositoryProvider.get());
    }

    public static ConversationFieldValidator_Factory create(Provider<ValidationRules> provider, Provider<ConversationFieldRepository> provider2) {
        return new ConversationFieldValidator_Factory(provider, provider2);
    }

    public static ConversationFieldValidator newInstance(ValidationRules validationRules, ConversationFieldRepository conversationFieldRepository) {
        return new ConversationFieldValidator(validationRules, conversationFieldRepository);
    }
}
