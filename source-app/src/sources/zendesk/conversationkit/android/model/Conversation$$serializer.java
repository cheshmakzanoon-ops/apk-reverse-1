package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
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
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/model/Conversation.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/model/Conversation;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class Conversation$$serializer implements GeneratedSerializer<Conversation> {
    public static final Conversation$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        Conversation$$serializer conversation$$serializer = new Conversation$$serializer();
        INSTANCE = conversation$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.model.Conversation", conversation$$serializer, 17);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("displayName", false);
        pluginGeneratedSerialDescriptor.addElement("description", false);
        pluginGeneratedSerialDescriptor.addElement("iconUrl", false);
        pluginGeneratedSerialDescriptor.addElement("type", false);
        pluginGeneratedSerialDescriptor.addElement("isDefault", false);
        pluginGeneratedSerialDescriptor.addElement("business", false);
        pluginGeneratedSerialDescriptor.addElement("businessLastRead", false);
        pluginGeneratedSerialDescriptor.addElement("lastUpdatedAt", false);
        pluginGeneratedSerialDescriptor.addElement("myself", false);
        pluginGeneratedSerialDescriptor.addElement("participants", false);
        pluginGeneratedSerialDescriptor.addElement("messages", false);
        pluginGeneratedSerialDescriptor.addElement("hasPrevious", false);
        pluginGeneratedSerialDescriptor.addElement("status", false);
        pluginGeneratedSerialDescriptor.addElement("metadata", false);
        pluginGeneratedSerialDescriptor.addElement("routingStatus", true);
        pluginGeneratedSerialDescriptor.addElement("createdAt", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private Conversation$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = Conversation.$childSerializers;
        return new KSerializer[]{StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), kSerializerArr[4], BooleanSerializer.INSTANCE, kSerializerArr[6], BuiltinSerializersKt.getNullable(kSerializerArr[7]), BuiltinSerializersKt.getNullable(DoubleSerializer.INSTANCE), BuiltinSerializersKt.getNullable(Participant$$serializer.INSTANCE), kSerializerArr[10], kSerializerArr[11], BooleanSerializer.INSTANCE, kSerializerArr[13], BuiltinSerializersKt.getNullable(kSerializerArr[14]), ConversationRoutingStatus.ConversationRoutingStatusSerializer.INSTANCE, BuiltinSerializersKt.getNullable(kSerializerArr[16])};
    }

    @Override
    public Conversation deserialize(Decoder decoder) {
        Participant participant;
        int i;
        Map map;
        LocalDateTime localDateTime;
        boolean z;
        LocalDateTime localDateTime2;
        String str;
        List list;
        boolean z2;
        List list2;
        ConversationStatus conversationStatus;
        Double d;
        String str2;
        String str3;
        ConversationRoutingStatus conversationRoutingStatus;
        List list3;
        String str4;
        ConversationType conversationType;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = Conversation.$childSerializers;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            String str5 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, null);
            String str6 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, null);
            String str7 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            ConversationType conversationType2 = (ConversationType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], null);
            boolean zDecodeBooleanElement = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 5);
            List list4 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 6, kSerializerArr[6], null);
            LocalDateTime localDateTime3 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, kSerializerArr[7], null);
            Double d2 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, DoubleSerializer.INSTANCE, null);
            Participant participant2 = (Participant) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, Participant$$serializer.INSTANCE, null);
            List list5 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 10, kSerializerArr[10], null);
            List list6 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 11, kSerializerArr[11], null);
            boolean zDecodeBooleanElement2 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 12);
            ConversationStatus conversationStatus2 = (ConversationStatus) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 13, kSerializerArr[13], null);
            Map map2 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 14, kSerializerArr[14], null);
            ConversationRoutingStatus conversationRoutingStatus2 = (ConversationRoutingStatus) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 15, ConversationRoutingStatus.ConversationRoutingStatusSerializer.INSTANCE, null);
            i = 131071;
            localDateTime = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 16, kSerializerArr[16], null);
            localDateTime2 = localDateTime3;
            list2 = list6;
            conversationStatus = conversationStatus2;
            list = list4;
            map = map2;
            list3 = list5;
            d = d2;
            str4 = str7;
            str2 = str6;
            conversationType = conversationType2;
            z2 = zDecodeBooleanElement;
            str = str5;
            z = zDecodeBooleanElement2;
            participant = participant2;
            str3 = strDecodeStringElement;
            conversationRoutingStatus = conversationRoutingStatus2;
        } else {
            int i2 = 16;
            boolean zDecodeBooleanElement3 = false;
            boolean zDecodeBooleanElement4 = false;
            Double d3 = null;
            List list7 = null;
            LocalDateTime localDateTime4 = null;
            ConversationType conversationType3 = null;
            List list8 = null;
            String str8 = null;
            List list9 = null;
            ConversationStatus conversationStatus3 = null;
            participant = null;
            String strDecodeStringElement2 = null;
            Map map3 = null;
            ConversationRoutingStatus conversationRoutingStatus3 = null;
            LocalDateTime localDateTime5 = null;
            boolean z3 = true;
            String str9 = null;
            String str10 = null;
            i = 0;
            while (z3) {
                String str11 = str9;
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z3 = false;
                        str9 = str11;
                        kSerializerArr = kSerializerArr;
                        i2 = 16;
                        str10 = str10;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        list7 = list7;
                        break;
                    case 0:
                        strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i |= 1;
                        str9 = str11;
                        kSerializerArr = kSerializerArr;
                        i2 = 16;
                        str10 = str10;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        list7 = list7;
                        break;
                    case 1:
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        str9 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, str11);
                        i |= 2;
                        str10 = str10;
                        list7 = list7;
                        kSerializerArr = kSerializerArr;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 2:
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        i |= 4;
                        str10 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, str10);
                        list7 = list7;
                        str9 = str11;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 3:
                        str8 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, str8);
                        i |= 8;
                        list7 = list7;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 4:
                        conversationType3 = (ConversationType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], conversationType3);
                        i |= 16;
                        list7 = list7;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 5:
                        zDecodeBooleanElement3 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 5);
                        i |= 32;
                        list7 = list7;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 6:
                        list9 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 6, kSerializerArr[6], list9);
                        i |= 64;
                        list7 = list7;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 7:
                        localDateTime4 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, kSerializerArr[7], localDateTime4);
                        i |= 128;
                        list7 = list7;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 8:
                        d3 = (Double) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, DoubleSerializer.INSTANCE, d3);
                        i |= 256;
                        list7 = list7;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 9:
                        participant = (Participant) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, Participant$$serializer.INSTANCE, participant);
                        i |= 512;
                        list7 = list7;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 10:
                        str10 = str10;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        list8 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 10, kSerializerArr[10], list8);
                        i |= 1024;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 11:
                        str10 = str10;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        list7 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 11, kSerializerArr[11], list7);
                        i |= 2048;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case net.aihelp.data.model.rpa.msg.base.Message.TYPE_USER_VIDEO:
                        str10 = str10;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        zDecodeBooleanElement4 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 12);
                        i |= 4096;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case 13:
                        str10 = str10;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        conversationStatus3 = (ConversationStatus) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 13, kSerializerArr[13], conversationStatus3);
                        i |= 8192;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case net.aihelp.data.model.rpa.msg.base.Message.TYPE_USER_FILE:
                        str10 = str10;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        map3 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 14, kSerializerArr[14], map3);
                        i |= 16384;
                        str9 = str11;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = conversationRoutingStatus3;
                        break;
                    case WebSocketProtocol.B0_MASK_OPCODE:
                        i |= 32768;
                        localDateTime5 = localDateTime5;
                        str10 = str10;
                        i2 = 16;
                        conversationRoutingStatus3 = (ConversationRoutingStatus) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 15, ConversationRoutingStatus.ConversationRoutingStatusSerializer.INSTANCE, conversationRoutingStatus3);
                        str9 = str11;
                        break;
                    case 16:
                        localDateTime5 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i2, kSerializerArr[i2], localDateTime5);
                        i |= 65536;
                        str9 = str11;
                        str10 = str10;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            List list10 = list7;
            String str12 = str10;
            map = map3;
            localDateTime = localDateTime5;
            z = zDecodeBooleanElement4;
            localDateTime2 = localDateTime4;
            str = str9;
            list = list9;
            z2 = zDecodeBooleanElement3;
            list2 = list10;
            conversationStatus = conversationStatus3;
            d = d3;
            ConversationType conversationType4 = conversationType3;
            str2 = str12;
            str3 = strDecodeStringElement2;
            conversationRoutingStatus = conversationRoutingStatus3;
            list3 = list8;
            str4 = str8;
            conversationType = conversationType4;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new Conversation(i, str3, str, str2, str4, conversationType, z2, list, localDateTime2, d, participant, list3, list2, z, conversationStatus, map, conversationRoutingStatus, localDateTime, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, Conversation value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        Conversation.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
