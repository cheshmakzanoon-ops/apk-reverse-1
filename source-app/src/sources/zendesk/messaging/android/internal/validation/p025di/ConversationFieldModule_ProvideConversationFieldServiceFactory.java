package zendesk.messaging.android.internal.validation.p025di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import retrofit2.Retrofit;
import zendesk.messaging.android.internal.validation.ConversationFieldService;

public final class ConversationFieldModule_ProvideConversationFieldServiceFactory implements Factory<ConversationFieldService> {
    private final ConversationFieldModule module;
    private final Provider<Retrofit> retrofitProvider;

    public ConversationFieldModule_ProvideConversationFieldServiceFactory(ConversationFieldModule conversationFieldModule, Provider<Retrofit> provider) {
        this.module = conversationFieldModule;
        this.retrofitProvider = provider;
    }

    @Override
    public ConversationFieldService get() {
        return provideConversationFieldService(this.module, this.retrofitProvider.get());
    }

    public static ConversationFieldModule_ProvideConversationFieldServiceFactory create(ConversationFieldModule conversationFieldModule, Provider<Retrofit> provider) {
        return new ConversationFieldModule_ProvideConversationFieldServiceFactory(conversationFieldModule, provider);
    }

    public static ConversationFieldService provideConversationFieldService(ConversationFieldModule conversationFieldModule, Retrofit retrofit) {
        return (ConversationFieldService) Preconditions.checkNotNullFromProvides(conversationFieldModule.provideConversationFieldService(retrofit));
    }
}
