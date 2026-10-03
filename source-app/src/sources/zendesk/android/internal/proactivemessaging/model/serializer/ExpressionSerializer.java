package zendesk.android.internal.proactivemessaging.model.serializer;

import android.util.Log;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerializationException;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.descriptors.SerialDescriptorsKt;
import kotlinx.serialization.encoding.Decoder;
import kotlinx.serialization.encoding.Encoder;
import kotlinx.serialization.json.JsonDecoder;
import kotlinx.serialization.json.JsonElement;
import kotlinx.serialization.json.JsonElementKt;
import kotlinx.serialization.json.JsonObject;
import kotlinx.serialization.json.JsonPrimitive;
import zendesk.android.internal.proactivemessaging.model.Expression;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÀ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0010\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eH\u0016J\u0018\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002H\u0016R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0006\u001a\u00020\u0005X\u0082T¢\u0006\u0002\n\u0000R\u000e\u0010\u0007\u001a\u00020\u0005X\u0082T¢\u0006\u0002\n\u0000R\u0014\u0010\b\u001a\u00020\tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0014"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/model/serializer/ExpressionSerializer;", "Lkotlinx/serialization/KSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Expression;", "()V", "EXPECTED_JSON_DECODER_FAILURE", "", "LOG_TAG", "UNEXPECTED_JSON_ELEMENT_FAILURE", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ExpressionSerializer implements KSerializer<Expression> {
    private static final String EXPECTED_JSON_DECODER_FAILURE = "Expected a JsonDecoder";
    private static final String LOG_TAG = "ExpressionSerializer";
    private static final String UNEXPECTED_JSON_ELEMENT_FAILURE = "Unexpected JSON element: ";
    public static final ExpressionSerializer INSTANCE = new ExpressionSerializer();
    private static final SerialDescriptor descriptor = SerialDescriptorsKt.buildClassSerialDescriptor$default("Expression", new SerialDescriptor[0], null, 4, null);

    private ExpressionSerializer() {
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, Expression value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        if (value instanceof Expression.ExpressionClass) {
            encoder.encodeSerializableValue(Expression.ExpressionClass.INSTANCE.serializer(), value);
        } else if (value instanceof Expression.BoolValue) {
            encoder.encodeBoolean(((Expression.BoolValue) value).getValue());
        }
    }

    @Override
    public Expression deserialize(Decoder decoder) {
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        JsonDecoder jsonDecoder = decoder instanceof JsonDecoder ? (JsonDecoder) decoder : null;
        if (jsonDecoder == null) {
            Log.e(LOG_TAG, EXPECTED_JSON_DECODER_FAILURE);
            throw new SerializationException(EXPECTED_JSON_DECODER_FAILURE);
        }
        JsonElement jsonElementDecodeJsonElement = jsonDecoder.decodeJsonElement();
        if (jsonElementDecodeJsonElement instanceof JsonObject) {
            return (Expression) jsonDecoder.getJson().decodeFromJsonElement(Expression.ExpressionClass.INSTANCE.serializer(), jsonElementDecodeJsonElement);
        }
        if (!(jsonElementDecodeJsonElement instanceof JsonPrimitive)) {
            throw new SerializationException(UNEXPECTED_JSON_ELEMENT_FAILURE + jsonElementDecodeJsonElement);
        }
        JsonPrimitive jsonPrimitive = (JsonPrimitive) jsonElementDecodeJsonElement;
        if (JsonElementKt.getBooleanOrNull(jsonPrimitive) != null) {
            return new Expression.BoolValue(Intrinsics.areEqual((Object) JsonElementKt.getBooleanOrNull(jsonPrimitive), (Object) true));
        }
        throw new SerializationException(UNEXPECTED_JSON_ELEMENT_FAILURE + jsonElementDecodeJsonElement);
    }
}
