package zendesk.core.android.internal.serializer;

import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlin.jvm.internal.StringCompanionObject;
import kotlinx.serialization.ExperimentalSerializationApi;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerializationException;
import kotlinx.serialization.builtins.BuiltinSerializersKt;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.descriptors.SerialDescriptorsKt;
import kotlinx.serialization.encoding.Decoder;
import kotlinx.serialization.encoding.Encoder;
import kotlinx.serialization.json.JsonDecoder;
import zendesk.core.android.internal.InternalZendeskApi;

@InternalZendeskApi
@Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0010\u0010\b\u001a\u00020\u00022\u0006\u0010\t\u001a\u00020\nH\u0016J\u0018\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\u000e2\u0006\u0010\u000f\u001a\u00020\u0002H\u0016R\u0014\u0010\u0004\u001a\u00020\u0005X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0010"}, m18d2 = {"Lzendesk/core/android/internal/serializer/AnySerializer;", "Lkotlinx/serialization/KSerializer;", "", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.core_core-utilities"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@ExperimentalSerializationApi
public final class AnySerializer implements KSerializer<Object> {
    public static final AnySerializer INSTANCE = new AnySerializer();
    private static final SerialDescriptor descriptor = SerialDescriptorsKt.buildClassSerialDescriptor$default("Any", new SerialDescriptor[0], null, 4, null);

    private AnySerializer() {
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, Object value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        if (value instanceof Integer) {
            encoder.encodeInt(((Number) value).intValue());
            return;
        }
        if (value instanceof String) {
            encoder.encodeString((String) value);
            return;
        }
        if (value instanceof Boolean) {
            encoder.encodeBoolean(((Boolean) value).booleanValue());
            return;
        }
        if (value instanceof Double) {
            encoder.encodeDouble(((Number) value).doubleValue());
            return;
        }
        if (value instanceof Long) {
            encoder.encodeLong(((Number) value).longValue());
            return;
        }
        if (value instanceof List) {
            encoder.encodeSerializableValue(BuiltinSerializersKt.ListSerializer(this), (List) value);
        } else if (value instanceof Map) {
            encoder.encodeSerializableValue(BuiltinSerializersKt.MapSerializer(BuiltinSerializersKt.serializer(StringCompanionObject.INSTANCE), this), (Map) value);
        } else {
            throw new SerializationException("Unsupported type: " + Reflection.getOrCreateKotlinClass(value.getClass()));
        }
    }

    @Override
    public Object deserialize(Decoder decoder) {
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        JsonDecoder jsonDecoder = decoder instanceof JsonDecoder ? (JsonDecoder) decoder : null;
        if (jsonDecoder != null) {
            return AnySerializerKt.toKotlinType(jsonDecoder.decodeJsonElement());
        }
        throw new SerializationException("This class can be loaded only by Json");
    }
}
