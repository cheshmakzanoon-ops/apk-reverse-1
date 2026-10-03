package zendesk.messaging.android.internal.conversationscreen.cache;

import dagger.internal.Factory;
import javax.inject.Provider;
import kotlinx.serialization.json.Json;

public final class MessagingStorageSerializer_Factory implements Factory<MessagingStorageSerializer> {
    private final Provider<Json> jsonProvider;

    public MessagingStorageSerializer_Factory(Provider<Json> provider) {
        this.jsonProvider = provider;
    }

    @Override
    public MessagingStorageSerializer get() {
        return newInstance(this.jsonProvider.get());
    }

    public static MessagingStorageSerializer_Factory create(Provider<Json> provider) {
        return new MessagingStorageSerializer_Factory(provider);
    }

    public static MessagingStorageSerializer newInstance(Json json) {
        return new MessagingStorageSerializer(json);
    }
}
