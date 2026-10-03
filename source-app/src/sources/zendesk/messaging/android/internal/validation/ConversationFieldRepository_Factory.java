package zendesk.messaging.android.internal.validation;

import dagger.internal.Factory;
import javax.inject.Provider;

public final class ConversationFieldRepository_Factory implements Factory<ConversationFieldRepository> {
    private final Provider<ConversationFieldService> conversationFieldServiceProvider;

    public ConversationFieldRepository_Factory(Provider<ConversationFieldService> provider) {
        this.conversationFieldServiceProvider = provider;
    }

    @Override
    public ConversationFieldRepository get() {
        return newInstance(this.conversationFieldServiceProvider.get());
    }

    public static ConversationFieldRepository_Factory create(Provider<ConversationFieldService> provider) {
        return new ConversationFieldRepository_Factory(provider);
    }

    public static ConversationFieldRepository newInstance(ConversationFieldService conversationFieldService) {
        return new ConversationFieldRepository(conversationFieldService);
    }
}
