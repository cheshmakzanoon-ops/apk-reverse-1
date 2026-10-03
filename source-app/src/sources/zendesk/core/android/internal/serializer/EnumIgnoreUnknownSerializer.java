package zendesk.core.android.internal.serializer;

import java.lang.Enum;
import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.collections.MapsKt;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlin.ranges.RangesKt;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.descriptors.PrimitiveKind;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.descriptors.SerialDescriptorsKt;
import kotlinx.serialization.encoding.Decoder;
import kotlinx.serialization.encoding.Encoder;
import zendesk.core.android.internal.InternalZendeskApi;

@InternalZendeskApi
@Metadata(m17d1 = {"\u0000B\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0010\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\b'\u0018\u0000*\u000e\b\u0000\u0010\u0001*\b\u0012\u0004\u0012\u0002H\u00010\u00022\b\u0012\u0004\u0012\u0002H\u00010\u0003B\u001d\u0012\u000e\u0010\u0004\u001a\n\u0012\u0006\b\u0001\u0012\u00028\u00000\u0005\u0012\u0006\u0010\u0006\u001a\u00028\u0000¢\u0006\u0002\u0010\u0007J\u0015\u0010\u0014\u001a\u00028\u00002\u0006\u0010\u0015\u001a\u00020\u0016H\u0016¢\u0006\u0002\u0010\u0017J\u001d\u0010\u0018\u001a\u00020\u00192\u0006\u0010\u001a\u001a\u00020\u001b2\u0006\u0010\u001c\u001a\u00028\u0000H\u0016¢\u0006\u0002\u0010\u001dR\u0010\u0010\u0006\u001a\u00028\u0000X\u0082\u0004¢\u0006\u0004\n\u0002\u0010\bR\u0014\u0010\t\u001a\u00020\nX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u001a\u0010\r\u001a\u000e\u0012\u0004\u0012\u00028\u0000\u0012\u0004\u0012\u00020\u000f0\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u001a\u0010\u0010\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00028\u00000\u000eX\u0082\u0004¢\u0006\u0002\n\u0000R\u001e\u0010\u0011\u001a\u00020\u000f*\b\u0012\u0004\u0012\u00028\u00000\u00028BX\u0082\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013¨\u0006\u001e"}, m18d2 = {"Lzendesk/core/android/internal/serializer/EnumIgnoreUnknownSerializer;", "T", "", "Lkotlinx/serialization/KSerializer;", "values", "", "defaultValue", "([Ljava/lang/Enum;Ljava/lang/Enum;)V", "Ljava/lang/Enum;", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "lookup", "", "", "reverseLookup", "serialName", "getSerialName", "(Ljava/lang/Enum;)Ljava/lang/String;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "(Lkotlinx/serialization/encoding/Decoder;)Ljava/lang/Enum;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "(Lkotlinx/serialization/encoding/Encoder;Ljava/lang/Enum;)V", "zendesk.core_core-utilities"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class EnumIgnoreUnknownSerializer<T extends Enum<T>> implements KSerializer<T> {
    private final T defaultValue;
    private final SerialDescriptor descriptor;
    private final Map<T, String> lookup;
    private final Map<String, T> reverseLookup;

    public EnumIgnoreUnknownSerializer(T[] values, T defaultValue) {
        Intrinsics.checkNotNullParameter(values, "values");
        Intrinsics.checkNotNullParameter(defaultValue, "defaultValue");
        this.defaultValue = defaultValue;
        String qualifiedName = Reflection.getOrCreateKotlinClass(ArraysKt.first(values).getClass()).getQualifiedName();
        Intrinsics.checkNotNull(qualifiedName);
        this.descriptor = SerialDescriptorsKt.PrimitiveSerialDescriptor(qualifiedName, PrimitiveKind.STRING.INSTANCE);
        LinkedHashMap linkedHashMap = new LinkedHashMap(RangesKt.coerceAtLeast(MapsKt.mapCapacity(values.length), 16));
        for (T t : values) {
            linkedHashMap.put(t, getSerialName(t));
        }
        this.lookup = linkedHashMap;
        LinkedHashMap linkedHashMap2 = new LinkedHashMap(RangesKt.coerceAtLeast(MapsKt.mapCapacity(values.length), 16));
        for (T t2 : values) {
            linkedHashMap2.put(getSerialName(t2), t2);
        }
        this.reverseLookup = linkedHashMap2;
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return this.descriptor;
    }

    private final String getSerialName(Enum<T> r3) {
        String strValue;
        SerialName serialName = (SerialName) r3.getClass().getField(r3.name()).getAnnotation(SerialName.class);
        return (serialName == null || (strValue = serialName.value()) == null) ? r3.name() : strValue;
    }

    @Override
    public void serialize(Encoder encoder, T value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        encoder.encodeString((String) MapsKt.getValue(this.lookup, value));
    }

    @Override
    public T deserialize(Decoder decoder) {
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        T t = this.reverseLookup.get(decoder.decodeString());
        return t == null ? this.defaultValue : t;
    }
}
