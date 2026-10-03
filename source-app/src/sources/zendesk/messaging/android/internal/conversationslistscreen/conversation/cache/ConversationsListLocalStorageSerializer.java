package zendesk.messaging.android.internal.conversationslistscreen.conversation.cache;

import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerializersKt;
import kotlinx.serialization.json.Json;
import zendesk.faye.internal.Bayeux;
import zendesk.storage.android.Serializer;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J+\u0010\u0005\u001a\u0004\u0018\u0001H\u0006\"\u0004\b\u0000\u0010\u00062\u0006\u0010\u0007\u001a\u00020\b2\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\u00060\nH\u0016¢\u0006\u0002\u0010\u000bJ)\u0010\f\u001a\u00020\b\"\u0004\b\u0000\u0010\u00062\u0006\u0010\r\u001a\u0002H\u00062\f\u0010\t\u001a\b\u0012\u0004\u0012\u0002H\u00060\nH\u0016¢\u0006\u0002\u0010\u000eJ&\u0010\u000f\u001a\b\u0012\u0004\u0012\u0002H\u00060\u0010\"\u0004\b\u0000\u0010\u0006*\b\u0012\u0004\u0012\u0002H\u00060\n2\u0006\u0010\u0002\u001a\u00020\u0003H\u0002R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/conversation/cache/ConversationsListLocalStorageSerializer;", "Lzendesk/storage/android/Serializer;", "json", "Lkotlinx/serialization/json/Json;", "(Lkotlinx/serialization/json/Json;)V", "deserialize", "T", "source", "", "type", "Ljava/lang/Class;", "(Ljava/lang/String;Ljava/lang/Class;)Ljava/lang/Object;", "serialize", Bayeux.KEY_DATA, "(Ljava/lang/Object;Ljava/lang/Class;)Ljava/lang/String;", "serializer", "Lkotlinx/serialization/KSerializer;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationsListLocalStorageSerializer implements Serializer {
    private final Json json;

    @Inject
    public ConversationsListLocalStorageSerializer(Json json) {
        Intrinsics.checkNotNullParameter(json, "json");
        this.json = json;
    }

    @Override
    public <T> T deserialize(String source, Class<T> type) {
        Intrinsics.checkNotNullParameter(source, "source");
        Intrinsics.checkNotNullParameter(type, "type");
        try {
            Json json = this.json;
            return (T) json.decodeFromString(serializer(type, json), source);
        } catch (Exception unused) {
            return null;
        }
    }

    @Override
    public <T> String serialize(T data, Class<T> type) {
        Intrinsics.checkNotNullParameter(type, "type");
        Json json = this.json;
        return json.encodeToString(serializer(type, json), data);
    }

    private final <T> KSerializer<T> serializer(Class<T> cls, Json json) {
        KSerializer<T> kSerializer = (KSerializer<T>) SerializersKt.serializer(json.getSerializersModule(), cls);
        Intrinsics.checkNotNull(kSerializer, "null cannot be cast to non-null type kotlinx.serialization.KSerializer<T of zendesk.messaging.android.internal.conversationslistscreen.conversation.cache.ConversationsListLocalStorageSerializer.serializer>");
        return kSerializer;
    }
}
