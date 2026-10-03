package zendesk.conversationkit.android.internal.faye;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.UnknownFieldException;
import kotlinx.serialization.builtins.BuiltinSerializersKt;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeDecoder;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.encoding.Decoder;
import kotlinx.serialization.encoding.Encoder;
import kotlinx.serialization.internal.DoubleSerializer;
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/faye/WsActivityEventDataDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class WsActivityEventDataDto$$serializer implements GeneratedSerializer<WsActivityEventDataDto> {
    public static final WsActivityEventDataDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        WsActivityEventDataDto$$serializer wsActivityEventDataDto$$serializer = new WsActivityEventDataDto$$serializer();
        INSTANCE = wsActivityEventDataDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.faye.WsActivityEventDataDto", wsActivityEventDataDto$$serializer, 6);
        pluginGeneratedSerialDescriptor.addElement("name", true);
        pluginGeneratedSerialDescriptor.addElement("avatarUrl", true);
        pluginGeneratedSerialDescriptor.addElement("lastRead", true);
        pluginGeneratedSerialDescriptor.addElement("responseTime", true);
        pluginGeneratedSerialDescriptor.addElement("queuePosition", true);
        pluginGeneratedSerialDescriptor.addElement("lowestQueuePosition", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private WsActivityEventDataDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(DoubleSerializer.INSTANCE), BuiltinSerializersKt.getNullable(WsResponseTimeDto$$serializer.INSTANCE), BuiltinSerializersKt.getNullable(LongSerializer.INSTANCE), BuiltinSerializersKt.getNullable(LongSerializer.INSTANCE)};
    }

    @Override
    public WsActivityEventDataDto deserialize(Decoder decoder) {
        Long l;
        Long l2;
        Double d;
        WsResponseTimeDto wsResponseTimeDto;
        String str;
        String str2;
        int i;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        int i2 = 5;
        String str3 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String str4 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 0, StringSerializer.INSTANCE, null);
            String str5 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, null);
            Double d2 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, DoubleSerializer.INSTANCE, null);
            WsResponseTimeDto wsResponseTimeDto2 = (WsResponseTimeDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, WsResponseTimeDto$$serializer.INSTANCE, null);
            Long l3 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, LongSerializer.INSTANCE, null);
            str = str4;
            l2 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, LongSerializer.INSTANCE, null);
            wsResponseTimeDto = wsResponseTimeDto2;
            l = l3;
            d = d2;
            str2 = str5;
            i = 63;
        } else {
            boolean z = true;
            int i3 = 0;
            String str6 = null;
            Double d3 = null;
            WsResponseTimeDto wsResponseTimeDto3 = null;
            Long l4 = null;
            Long l5 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        i2 = 5;
                        break;
                    case 0:
                        str3 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 0, StringSerializer.INSTANCE, str3);
                        i3 |= 1;
                        i2 = 5;
                        break;
                    case 1:
                        str6 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, str6);
                        i3 |= 2;
                        break;
                    case 2:
                        d3 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, DoubleSerializer.INSTANCE, d3);
                        i3 |= 4;
                        break;
                    case 3:
                        wsResponseTimeDto3 = (WsResponseTimeDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, WsResponseTimeDto$$serializer.INSTANCE, wsResponseTimeDto3);
                        i3 |= 8;
                        break;
                    case 4:
                        l4 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, LongSerializer.INSTANCE, l4);
                        i3 |= 16;
                        break;
                    case 5:
                        l5 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i2, LongSerializer.INSTANCE, l5);
                        i3 |= 32;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            l = l4;
            l2 = l5;
            d = d3;
            wsResponseTimeDto = wsResponseTimeDto3;
            str = str3;
            str2 = str6;
            i = i3;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new WsActivityEventDataDto(i, str, str2, d, wsResponseTimeDto, l, l2, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, WsActivityEventDataDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        WsActivityEventDataDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
