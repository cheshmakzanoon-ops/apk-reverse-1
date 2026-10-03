package kotlinx.serialization.json.internal;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Ref;
import kotlin.jvm.internal.Reflection;
import kotlinx.serialization.SerializationStrategy;
import kotlinx.serialization.descriptors.PrimitiveKind;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.descriptors.SerialKind;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonElement;

@Metadata(m17d1 = {"\u0000*\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u000b\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a*\u0010\u0007\u001a\u0002H\b\"\n\b\u0000\u0010\b\u0018\u0001*\u00020\t2\u0006\u0010\n\u001a\u00020\t2\u0006\u0010\u000b\u001a\u00020\u0004H\u0080\b¢\u0006\u0002\u0010\f\u001a1\u0010\r\u001a\u00020\t\"\u0004\b\u0000\u0010\b2\u0006\u0010\u000e\u001a\u00020\u000f2\u0006\u0010\n\u001a\u0002H\b2\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u0002H\b0\u0011H\u0007¢\u0006\u0002\u0010\u0012\"\u000e\u0010\u0000\u001a\u00020\u0001X\u0080T¢\u0006\u0002\n\u0000\"\u0018\u0010\u0002\u001a\u00020\u0003*\u00020\u00048BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0013"}, m18d2 = {"PRIMITIVE_TAG", "", "requiresTopLevelTag", "", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getRequiresTopLevelTag", "(Lkotlinx/serialization/descriptors/SerialDescriptor;)Z", "cast", "T", "Lkotlinx/serialization/json/JsonElement;", "value", "descriptor", "(Lkotlinx/serialization/json/JsonElement;Lkotlinx/serialization/descriptors/SerialDescriptor;)Lkotlinx/serialization/json/JsonElement;", "writeJson", "json", "Lkotlinx/serialization/json/Json;", "serializer", "Lkotlinx/serialization/SerializationStrategy;", "(Lkotlinx/serialization/json/Json;Ljava/lang/Object;Lkotlinx/serialization/SerializationStrategy;)Lkotlinx/serialization/json/JsonElement;", "kotlinx-serialization-json"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class TreeJsonEncoderKt {
    public static final String PRIMITIVE_TAG = "primitive";

    @JsonFriendModuleApi
    public static final <T> JsonElement writeJson(Json json, T t, SerializationStrategy<? super T> serializer) {
        Intrinsics.checkNotNullParameter(json, "json");
        Intrinsics.checkNotNullParameter(serializer, "serializer");
        final Ref.ObjectRef objectRef = new Ref.ObjectRef();
        new JsonTreeEncoder(json, new Function1<JsonElement, Unit>() {
            {
                super(1);
            }

            @Override
            public Unit invoke(JsonElement jsonElement) {
                invoke2(jsonElement);
                return Unit.INSTANCE;
            }

            public final void invoke2(JsonElement it) {
                Intrinsics.checkNotNullParameter(it, "it");
                objectRef.element = it;
            }
        }).encodeSerializableValue(serializer, t);
        if (objectRef.element != null) {
            return (JsonElement) objectRef.element;
        }
        Intrinsics.throwUninitializedPropertyAccessException("result");
        return null;
    }

    public static final boolean getRequiresTopLevelTag(SerialDescriptor serialDescriptor) {
        return (serialDescriptor.getKind() instanceof PrimitiveKind) || serialDescriptor.getKind() == SerialKind.ENUM.INSTANCE;
    }

    public static final <T extends JsonElement> T cast(JsonElement value, SerialDescriptor descriptor) {
        Intrinsics.checkNotNullParameter(value, "value");
        Intrinsics.checkNotNullParameter(descriptor, "descriptor");
        Intrinsics.reifiedOperationMarker(3, "T");
        if (value instanceof JsonElement) {
            return value;
        }
        StringBuilder sb = new StringBuilder("Expected ");
        Intrinsics.reifiedOperationMarker(4, "T");
        sb.append(Reflection.getOrCreateKotlinClass(JsonElement.class));
        sb.append(" as the serialized body of ");
        sb.append(descriptor.getSerialName());
        sb.append(", but had ");
        sb.append(Reflection.getOrCreateKotlinClass(value.getClass()));
        throw JsonExceptionsKt.JsonDecodingException(-1, sb.toString());
    }
}
