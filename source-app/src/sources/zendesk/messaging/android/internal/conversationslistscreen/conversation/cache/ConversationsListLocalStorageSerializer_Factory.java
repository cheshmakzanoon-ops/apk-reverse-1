package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.serialization.json.Json;

public final class ConversationsListLocalStorageSerializer_Factory implements Factory<ConversationsListLocalStorageSerializer> {
    private final Provider<Json> jsonProvider;

    public ConversationsListLocalStorageSerializer_Factory(Provider<Json> provider) {
        this.jsonProvider = provider;
    }

    @Override
    public ConversationsListLocalStorageSerializer get() {
        return newInstance(this.jsonProvider.get());
    }

    public static ConversationsListLocalStorageSerializer_Factory create(Provider<Json> provider) {
        return new ConversationsListLocalStorageSerializer_Factory(provider);
    }

    public static ConversationsListLocalStorageSerializer newInstance(Json json) {
        return new ConversationsListLocalStorageSerializer(json);
    }
}
