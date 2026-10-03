package zendesk.conversationkit.android.internal.rest.model;

import java.util.List;
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
import kotlinx.serialization.internal.DoubleSerializer;
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import net.aihelp.data.model.rpa.msg.base.Message;
import zendesk.conversationkit.android.model.ConversationRoutingStatus;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/ConversationDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class ConversationDto$$serializer implements GeneratedSerializer<ConversationDto> {
    public static final ConversationDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        ConversationDto$$serializer conversationDto$$serializer = new ConversationDto$$serializer();
        INSTANCE = conversationDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.ConversationDto", conversationDto$$serializer, 15);
        pluginGeneratedSerialDescriptor.addElement("_id", false);
        pluginGeneratedSerialDescriptor.addElement("displayName", false);
        pluginGeneratedSerialDescriptor.addElement("description", false);
        pluginGeneratedSerialDescriptor.addElement("iconUrl", false);
        pluginGeneratedSerialDescriptor.addElement("type", false);
        pluginGeneratedSerialDescriptor.addElement("isDefault", false);
        pluginGeneratedSerialDescriptor.addElement("appMakers", false);
        pluginGeneratedSerialDescriptor.addElement("appMakerLastRead", false);
        pluginGeneratedSerialDescriptor.addElement("lastUpdatedAt", false);
        pluginGeneratedSerialDescriptor.addElement("participants", false);
        pluginGeneratedSerialDescriptor.addElement("messages", false);
        pluginGeneratedSerialDescriptor.addElement("status", false);
        pluginGeneratedSerialDescriptor.addElement("metadata", false);
        pluginGeneratedSerialDescriptor.addElement("routingStatus", true);
        pluginGeneratedSerialDescriptor.addElement("createdAt", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private ConversationDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer[] kSerializerArr = ConversationDto.$childSerializers;
        return new KSerializer[]{StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), StringSerializer.INSTANCE, BooleanSerializer.INSTANCE, BuiltinSerializersKt.getNullable(kSerializerArr[6]), BuiltinSerializersKt.getNullable(DoubleSerializer.INSTANCE), BuiltinSerializersKt.getNullable(DoubleSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[9]), BuiltinSerializersKt.getNullable(kSerializerArr[10]), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[12]), ConversationRoutingStatus.ConversationRoutingStatusSerializer.INSTANCE, BuiltinSerializersKt.getNullable(DoubleSerializer.INSTANCE)};
    }

    @Override
    public ConversationDto deserialize(Decoder decoder) {
        List list;
        String str;
        String str2;
        List list2;
        Double d;
        List list3;
        String str3;
        Double d2;
        String str4;
        ConversationRoutingStatus conversationRoutingStatus;
        Map map;
        String str5;
        String str6;
        boolean z;
        Double d3;
        int i;
        int i2;
        int i3;
        int i4;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = ConversationDto.$childSerializers;
        Double d4 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            String str7 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, null);
            String str8 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, null);
            String str9 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
            boolean zDecodeBooleanElement = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 5);
            List list4 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, kSerializerArr[6], null);
            Double d5 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, DoubleSerializer.INSTANCE, null);
            Double d6 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, DoubleSerializer.INSTANCE, null);
            List list5 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, kSerializerArr[9], null);
            List list6 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, kSerializerArr[10], null);
            String str10 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, null);
            Map map2 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 12, kSerializerArr[12], null);
            conversationRoutingStatus = (ConversationRoutingStatus) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 13, ConversationRoutingStatus.ConversationRoutingStatusSerializer.INSTANCE, null);
            str3 = str10;
            list3 = list4;
            d3 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 14, DoubleSerializer.INSTANCE, null);
            d2 = d5;
            z = zDecodeBooleanElement;
            d = d6;
            str5 = strDecodeStringElement2;
            str = str8;
            i = 32767;
            list2 = list6;
            list = list5;
            map = map2;
            str6 = strDecodeStringElement;
            str2 = str7;
            str4 = str9;
        } else {
            boolean zDecodeBooleanElement2 = false;
            int i5 = 0;
            boolean z2 = true;
            String str11 = null;
            List list7 = null;
            String str12 = null;
            List list8 = null;
            Double d7 = null;
            List list9 = null;
            String str13 = null;
            Double d8 = null;
            String str14 = null;
            ConversationRoutingStatus conversationRoutingStatus2 = null;
            Map map3 = null;
            String strDecodeStringElement3 = null;
            String strDecodeStringElement4 = null;
            while (z2) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        i3 = i5;
                        kSerializerArr = kSerializerArr;
                        z2 = false;
                        i5 = i3;
                        break;
                    case 0:
                        strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i3 = i5 | 1;
                        kSerializerArr = kSerializerArr;
                        i5 = i3;
                        break;
                    case 1:
                        int i6 = i5;
                        d4 = d4;
                        str11 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, str11);
                        i4 = i6 | 2;
                        kSerializerArr = kSerializerArr;
                        Double d9 = d4;
                        i5 = i4;
                        d4 = d9;
                        break;
                    case 2:
                        str12 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, str12);
                        i2 = i5 | 4;
                        d4 = d4;
                        i5 = i2;
                        str11 = str11;
                        break;
                    case 3:
                        str14 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, str14);
                        i2 = i5 | 8;
                        d4 = d4;
                        i5 = i2;
                        str11 = str11;
                        break;
                    case 4:
                        strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
                        i3 = i5 | 16;
                        i5 = i3;
                        break;
                    case 5:
                        zDecodeBooleanElement2 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 5);
                        i3 = i5 | 32;
                        i5 = i3;
                        break;
                    case 6:
                        list9 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, kSerializerArr[6], list9);
                        i2 = i5 | 64;
                        d4 = d4;
                        i5 = i2;
                        str11 = str11;
                        break;
                    case 7:
                        d8 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, DoubleSerializer.INSTANCE, d8);
                        i4 = i5 | 128;
                        str11 = str11;
                        Double d10 = d4;
                        i5 = i4;
                        d4 = d10;
                        break;
                    case 8:
                        d7 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, DoubleSerializer.INSTANCE, d7);
                        i4 = i5 | 256;
                        str11 = str11;
                        Double d11 = d4;
                        i5 = i4;
                        d4 = d11;
                        break;
                    case 9:
                        list7 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, kSerializerArr[9], list7);
                        i4 = i5 | 512;
                        str11 = str11;
                        Double d12 = d4;
                        i5 = i4;
                        d4 = d12;
                        break;
                    case 10:
                        list8 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, kSerializerArr[10], list8);
                        i2 = i5 | 1024;
                        d4 = d4;
                        i5 = i2;
                        str11 = str11;
                        break;
                    case 11:
                        str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, str13);
                        i4 = i5 | 2048;
                        str11 = str11;
                        Double d13 = d4;
                        i5 = i4;
                        d4 = d13;
                        break;
                    case Message.TYPE_USER_VIDEO:
                        map3 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 12, kSerializerArr[12], map3);
                        i4 = i5 | 4096;
                        str11 = str11;
                        Double d14 = d4;
                        i5 = i4;
                        d4 = d14;
                        break;
                    case 13:
                        conversationRoutingStatus2 = (ConversationRoutingStatus) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 13, ConversationRoutingStatus.ConversationRoutingStatusSerializer.INSTANCE, conversationRoutingStatus2);
                        i2 = i5 | 8192;
                        d4 = d4;
                        i5 = i2;
                        str11 = str11;
                        break;
                    case Message.TYPE_USER_FILE:
                        str11 = str11;
                        d4 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 14, DoubleSerializer.INSTANCE, d4);
                        i5 |= 16384;
                        str11 = str11;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            list = list7;
            str = str12;
            str2 = str11;
            list2 = list8;
            d = d7;
            list3 = list9;
            str3 = str13;
            d2 = d8;
            str4 = str14;
            conversationRoutingStatus = conversationRoutingStatus2;
            map = map3;
            str5 = strDecodeStringElement3;
            str6 = strDecodeStringElement4;
            z = zDecodeBooleanElement2;
            d3 = d4;
            i = i5;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new ConversationDto(i, str6, str2, str, str4, str5, z, list3, d2, d, list, list2, str3, map, conversationRoutingStatus, d3, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, ConversationDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        ConversationDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
