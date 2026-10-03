package zendesk.messaging.android.internal.conversationslistscreen.p022di;

import dagger.internal.Factory;
import dagger.internal.Preconditions;
import javax.inject.Provider;
import zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageSerializer;
import zendesk.storage.android.StorageType;

public final class C1499x2a018d1c implements Factory<StorageType> {
    private final Provider<ConversationsListLocalStorageSerializer> conversationsListLocalStorageSerializerProvider;
    private final ConversationsListLocalStorageModule module;

    public C1499x2a018d1c(ConversationsListLocalStorageModule conversationsListLocalStorageModule, Provider<ConversationsListLocalStorageSerializer> provider) {
        this.module = conversationsListLocalStorageModule;
        this.conversationsListLocalStorageSerializerProvider = provider;
    }

    @Override
    public StorageType get() {
        return providesConversationsListStorageType(this.module, this.conversationsListLocalStorageSerializerProvider.get());
    }

    public static C1499x2a018d1c create(ConversationsListLocalStorageModule conversationsListLocalStorageModule, Provider<ConversationsListLocalStorageSerializer> provider) {
        return new C1499x2a018d1c(conversationsListLocalStorageModule, provider);
    }

    public static StorageType providesConversationsListStorageType(ConversationsListLocalStorageModule conversationsListLocalStorageModule, ConversationsListLocalStorageSerializer conversationsListLocalStorageSerializer) {
        return (StorageType) Preconditions.checkNotNullFromProvides(conversationsListLocalStorageModule.providesConversationsListStorageType(conversationsListLocalStorageSerializer));
    }
}
