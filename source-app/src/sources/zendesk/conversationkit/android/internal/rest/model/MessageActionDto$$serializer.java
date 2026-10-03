package zendesk.conversationkit.android.internal.rest.model;

import java.util.Map;
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
import kotlinx.serialization.internal.BooleanSerializer;
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.StringSerializer;
import net.aihelp.data.model.rpa.msg.base.Message;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/MessageActionDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/MessageActionDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class MessageActionDto$$serializer implements GeneratedSerializer<MessageActionDto> {
    public static final MessageActionDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        MessageActionDto$$serializer messageActionDto$$serializer = new MessageActionDto$$serializer();
        INSTANCE = messageActionDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.MessageActionDto", messageActionDto$$serializer, 14);
        pluginGeneratedSerialDescriptor.addElement("_id", false);
        pluginGeneratedSerialDescriptor.addElement("type", false);
        pluginGeneratedSerialDescriptor.addElement("text", false);
        pluginGeneratedSerialDescriptor.addElement("uri", false);
        pluginGeneratedSerialDescriptor.addElement("default", false);
        pluginGeneratedSerialDescriptor.addElement("iconUrl", false);
        pluginGeneratedSerialDescriptor.addElement("fallback", false);
        pluginGeneratedSerialDescriptor.addElement("payload", false);
        pluginGeneratedSerialDescriptor.addElement("metadata", false);
        pluginGeneratedSerialDescriptor.addElement("amount", false);
        pluginGeneratedSerialDescriptor.addElement("currency", false);
        pluginGeneratedSerialDescriptor.addElement("state", false);
        pluginGeneratedSerialDescriptor.addElement("openOnReceive", false);
        pluginGeneratedSerialDescriptor.addElement("size", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private MessageActionDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{StringSerializer.INSTANCE, StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(MessageActionDto.$childSerializers[8]), BuiltinSerializersKt.getNullable(LongSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE)};
    }

    @Override
    public MessageActionDto deserialize(Decoder decoder) {
        Boolean bool;
        Long l;
        Map map;
        String str;
        String str2;
        int i;
        String str3;
        String str4;
        String str5;
        String str6;
        String str7;
        String str8;
        String str9;
        Boolean bool2;
        String str10;
        String str11;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = MessageActionDto.$childSerializers;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            String str12 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, null);
            String str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            Boolean bool3 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, BooleanSerializer.INSTANCE, null);
            String str14 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, null);
            String str15 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, null);
            String str16 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, StringSerializer.INSTANCE, null);
            Map map2 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, kSerializerArr[8], null);
            Long l2 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, LongSerializer.INSTANCE, null);
            String str17 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, null);
            String str18 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, null);
            bool = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 12, BooleanSerializer.INSTANCE, null);
            str8 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 13, StringSerializer.INSTANCE, null);
            str5 = str17;
            str6 = str16;
            str3 = str18;
            str = strDecodeStringElement2;
            i = 16383;
            str10 = str15;
            str2 = str12;
            map = map2;
            l = l2;
            str4 = strDecodeStringElement;
            str9 = str14;
            str7 = str13;
            bool2 = bool3;
        } else {
            boolean z = true;
            String str19 = null;
            Boolean bool4 = null;
            String str20 = null;
            Long l3 = null;
            Map map3 = null;
            String str21 = null;
            String str22 = null;
            String str23 = null;
            Boolean bool5 = null;
            String str24 = null;
            String strDecodeStringElement3 = null;
            String strDecodeStringElement4 = null;
            String str25 = null;
            int i2 = 0;
            String str26 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        str11 = str19;
                        z = false;
                        str19 = str11;
                        str26 = str26;
                        kSerializerArr = kSerializerArr;
                        break;
                    case 0:
                        str11 = str19;
                        strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i2 |= 1;
                        str19 = str11;
                        str26 = str26;
                        kSerializerArr = kSerializerArr;
                        break;
                    case 1:
                        str11 = str19;
                        strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        i2 |= 2;
                        str19 = str11;
                        str26 = str26;
                        kSerializerArr = kSerializerArr;
                        break;
                    case 2:
                        str11 = str19;
                        str25 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, str25);
                        i2 |= 4;
                        str19 = str11;
                        str26 = str26;
                        kSerializerArr = kSerializerArr;
                        break;
                    case 3:
                        kSerializerArr = kSerializerArr;
                        str26 = str26;
                        str19 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, str19);
                        i2 |= 8;
                        str26 = str26;
                        kSerializerArr = kSerializerArr;
                        break;
                    case 4:
                        bool5 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, BooleanSerializer.INSTANCE, bool5);
                        i2 |= 16;
                        kSerializerArr = kSerializerArr;
                        str19 = str19;
                        break;
                    case 5:
                        str22 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, str22);
                        i2 |= 32;
                        kSerializerArr = kSerializerArr;
                        str19 = str19;
                        break;
                    case 6:
                        str23 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, str23);
                        i2 |= 64;
                        kSerializerArr = kSerializerArr;
                        str19 = str19;
                        break;
                    case 7:
                        str21 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, StringSerializer.INSTANCE, str21);
                        i2 |= 128;
                        kSerializerArr = kSerializerArr;
                        str19 = str19;
                        break;
                    case 8:
                        str19 = str19;
                        map3 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, kSerializerArr[8], map3);
                        i2 |= 256;
                        str19 = str19;
                        break;
                    case 9:
                        str19 = str19;
                        l3 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, LongSerializer.INSTANCE, l3);
                        i2 |= 512;
                        str19 = str19;
                        break;
                    case 10:
                        str19 = str19;
                        str24 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, str24);
                        i2 |= 1024;
                        str19 = str19;
                        break;
                    case 11:
                        str19 = str19;
                        str20 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, str20);
                        i2 |= 2048;
                        str19 = str19;
                        break;
                    case Message.TYPE_USER_VIDEO:
                        str19 = str19;
                        bool4 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 12, BooleanSerializer.INSTANCE, bool4);
                        i2 |= 4096;
                        str19 = str19;
                        break;
                    case 13:
                        str26 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 13, StringSerializer.INSTANCE, str26);
                        i2 |= 8192;
                        str19 = str19;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            bool = bool4;
            l = l3;
            map = map3;
            str = strDecodeStringElement4;
            str2 = str25;
            i = i2;
            str3 = str20;
            str4 = strDecodeStringElement3;
            str5 = str24;
            str6 = str21;
            str7 = str19;
            str8 = str26;
            String str27 = str23;
            str9 = str22;
            bool2 = bool5;
            str10 = str27;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new MessageActionDto(i, str4, str, str2, str7, bool2, str9, str10, str6, map, l, str5, str3, bool, str8, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, MessageActionDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        MessageActionDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
