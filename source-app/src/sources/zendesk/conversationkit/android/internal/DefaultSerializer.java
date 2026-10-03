package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.json.Json;
import zendesk.faye.internal.Bayeux;
import zendesk.storage.android.Serializer;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J+\u0010\u0005\u001a\u0004\u0018\u0001H\u0006\"\u0004\b\u0000\u0010\u00062\u0006\u0010\u0007\u001a\u00020\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\u00060\nH\u0016¢\u0006\u0002\u0010\u000bJ)\u0010\f\u001a\u00020\b\"\u0004\b\u0000\u0010\u00062\u0006\u0010\r\u001a\u0002H\u00062\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\u00060\nH\u0016¢\u0006\u0002\u0010\u000eR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u000f"}, m18d2 = {"Lzendesk/conversationkit/android/internal/DefaultSerializer;", "Lzendesk/storage/android/Serializer;", "json", "Lkotlinx/serialization/json/Json;", "(Lkotlinx/serialization/json/Json;)V", "deserialize", "T", "source", "", "type", "Ljava/lang/Class;", "(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;", "serialize", Bayeux.KEY_DATA, "(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/String;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultSerializer implements Serializer {
    private final Json json;

    public DefaultSerializer(Json json) {
        Intrinsics.checkNotNullParameter(json, "json");
        this.json = json;
    }

    @Override
    public <T> T deserialize(String source, Class<T> type) {
        Intrinsics.checkNotNullParameter(source, "source");
        Intrinsics.checkNotNullParameter(type, "type");
        try {
            Json json = this.json;
            return (T) json.decodeFromString(StorageFactoryKt.serializer(type, json), source);
        } catch (Exception unused) {
            return null;
        }
    }

    @Override
    public <T> String serialize(T data, Class<T> type) {
        Intrinsics.checkNotNullParameter(type, "type");
        Json json = this.json;
        return json.encodeToString(StorageFactoryKt.serializer(type, json), data);
    }
}
