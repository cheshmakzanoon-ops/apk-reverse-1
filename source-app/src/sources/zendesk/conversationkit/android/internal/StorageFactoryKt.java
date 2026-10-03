package zendesk.conversationkit.android.internal;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerializersKt;
import kotlinx.serialization.json.Json;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a&\u0010\u0000\u001a\b\u0012\u0004\u0012\u0002H\u00020\u0001\"\u0004\b\u0000\u0010\u0002*\b\u0012\u0004\u0012\u0002H\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u0005H\u0000¨\u0006\u0006"}, m18d2 = {"serializer", "Lkotlinx/serialization/KSerializer;", "T", "Ljava/lang/Class;", "json", "Lkotlinx/serialization/json/Json;", "zendesk.conversationkit_conversationkit-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class StorageFactoryKt {
    public static final <T> KSerializer<T> serializer(Class<T> cls, Json json) {
        Intrinsics.checkNotNullParameter(cls, "<this>");
        Intrinsics.checkNotNullParameter(json, "json");
        KSerializer<T> kSerializer = (KSerializer<T>) SerializersKt.serializer(json.getSerializersModule(), cls);
        Intrinsics.checkNotNull(kSerializer, "null cannot be cast to non-null type kotlinx.serialization.KSerializer<T of zendesk.conversationkit.android.internal.StorageFactoryKt.serializer>");
        return kSerializer;
    }
}
