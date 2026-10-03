package zendesk.messaging.android.push.internal;

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
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/messaging/android/push/internal/MessagePayload.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/messaging/android/push/internal/MessagePayload;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class MessagePayload$$serializer implements GeneratedSerializer<MessagePayload> {
    public static final MessagePayload$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        MessagePayload$$serializer messagePayload$$serializer = new MessagePayload$$serializer();
        INSTANCE = messagePayload$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.messaging.android.push.internal.MessagePayload", messagePayload$$serializer, 11);
        pluginGeneratedSerialDescriptor.addElement("_id", false);
        pluginGeneratedSerialDescriptor.addElement("authorId", false);
        pluginGeneratedSerialDescriptor.addElement("role", false);
        pluginGeneratedSerialDescriptor.addElement("name", false);
        pluginGeneratedSerialDescriptor.addElement("avatarUrl", false);
        pluginGeneratedSerialDescriptor.addElement("received", false);
        pluginGeneratedSerialDescriptor.addElement("type", false);
        pluginGeneratedSerialDescriptor.addElement("text", false);
        pluginGeneratedSerialDescriptor.addElement("mediaUrl", false);
        pluginGeneratedSerialDescriptor.addElement("mediaType", false);
        pluginGeneratedSerialDescriptor.addElement("mediaSize", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private MessagePayload$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), DoubleSerializer.INSTANCE, StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(LongSerializer.INSTANCE)};
    }

    @Override
    public MessagePayload deserialize(Decoder decoder) {
        Long l;
        String str;
        String str2;
        String str3;
        String str4;
        String strDecodeStringElement;
        String str5;
        double d;
        String str6;
        int i;
        String str7;
        String str8;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        int i2 = 10;
        int i3 = 9;
        String strDecodeStringElement2 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            String strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
            String str9 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            String str10 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, null);
            double dDecodeDoubleElement = compositeDecoderBeginStructure.decodeDoubleElement(descriptor2, 5);
            String strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 6);
            String str11 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, StringSerializer.INSTANCE, null);
            String str12 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, StringSerializer.INSTANCE, null);
            String str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, StringSerializer.INSTANCE, null);
            l = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, LongSerializer.INSTANCE, null);
            str = str13;
            str2 = str11;
            str6 = str12;
            str7 = str10;
            str4 = strDecodeStringElement4;
            d = dDecodeDoubleElement;
            str5 = strDecodeStringElement5;
            str8 = str9;
            i = 2047;
            str3 = strDecodeStringElement3;
        } else {
            boolean z = true;
            int i4 = 0;
            Long l2 = null;
            String str14 = null;
            String str15 = null;
            String str16 = null;
            String str17 = null;
            String str18 = null;
            String strDecodeStringElement6 = null;
            double dDecodeDoubleElement2 = 0.0d;
            String strDecodeStringElement7 = null;
            String strDecodeStringElement8 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        i2 = 10;
                        break;
                    case 0:
                        i4 |= 1;
                        strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 1:
                        i4 |= 2;
                        strDecodeStringElement7 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 2:
                        strDecodeStringElement8 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
                        i4 |= 4;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 3:
                        str18 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, str18);
                        i4 |= 8;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 4:
                        str17 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, str17);
                        i4 |= 16;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 5:
                        dDecodeDoubleElement2 = compositeDecoderBeginStructure.decodeDoubleElement(descriptor2, 5);
                        i4 |= 32;
                        i2 = 10;
                        break;
                    case 6:
                        strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 6);
                        i4 |= 64;
                        break;
                    case 7:
                        str16 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, StringSerializer.INSTANCE, str16);
                        i4 |= 128;
                        break;
                    case 8:
                        str14 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, StringSerializer.INSTANCE, str14);
                        i4 |= 256;
                        break;
                    case 9:
                        str15 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i3, StringSerializer.INSTANCE, str15);
                        i4 |= 512;
                        break;
                    case 10:
                        l2 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i2, LongSerializer.INSTANCE, l2);
                        i4 |= 1024;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            l = l2;
            str = str15;
            str2 = str16;
            str3 = strDecodeStringElement2;
            str4 = strDecodeStringElement7;
            strDecodeStringElement = strDecodeStringElement8;
            str5 = strDecodeStringElement6;
            d = dDecodeDoubleElement2;
            str6 = str14;
            i = i4;
            String str19 = str18;
            str7 = str17;
            str8 = str19;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new MessagePayload(i, str3, str4, strDecodeStringElement, str8, str7, d, str5, str2, str6, str, l, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, MessagePayload value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        MessagePayload.write$Self$zendesk_messaging_messaging_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
