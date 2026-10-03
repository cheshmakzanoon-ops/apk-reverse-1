package zendesk.conversationkit.android.internal.rest.model;

import cz.msebera.android.httpclient.conn.params.ConnManagerParams;
import cz.msebera.android.httpclient.extras.Base64;
import cz.msebera.android.httpclient.util.LangUtils;
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
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.StringSerializer;
import net.aihelp.data.model.p005cs.ConversationMsg;
import net.aihelp.data.model.rpa.msg.base.Message;
import okhttp3.internal.http2.Http2Connection;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/MessageDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class MessageDto$$serializer implements GeneratedSerializer<MessageDto> {
    public static final MessageDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        MessageDto$$serializer messageDto$$serializer = new MessageDto$$serializer();
        INSTANCE = messageDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.MessageDto", messageDto$$serializer, 26);
        pluginGeneratedSerialDescriptor.addElement("_id", false);
        pluginGeneratedSerialDescriptor.addElement("authorId", false);
        pluginGeneratedSerialDescriptor.addElement("role", false);
        pluginGeneratedSerialDescriptor.addElement("subroles", false);
        pluginGeneratedSerialDescriptor.addElement("name", false);
        pluginGeneratedSerialDescriptor.addElement("avatarUrl", false);
        pluginGeneratedSerialDescriptor.addElement("received", false);
        pluginGeneratedSerialDescriptor.addElement("type", false);
        pluginGeneratedSerialDescriptor.addElement("text", false);
        pluginGeneratedSerialDescriptor.addElement("textFallback", false);
        pluginGeneratedSerialDescriptor.addElement("altText", false);
        pluginGeneratedSerialDescriptor.addElement("payload", false);
        pluginGeneratedSerialDescriptor.addElement("metadata", false);
        pluginGeneratedSerialDescriptor.addElement("mediaUrl", false);
        pluginGeneratedSerialDescriptor.addElement("mediaType", false);
        pluginGeneratedSerialDescriptor.addElement("mediaSize", false);
        pluginGeneratedSerialDescriptor.addElement("coordinates", false);
        pluginGeneratedSerialDescriptor.addElement("location", false);
        pluginGeneratedSerialDescriptor.addElement("actions", false);
        pluginGeneratedSerialDescriptor.addElement("items", false);
        pluginGeneratedSerialDescriptor.addElement("displaySettings", false);
        pluginGeneratedSerialDescriptor.addElement("blockChatInput", false);
        pluginGeneratedSerialDescriptor.addElement("fields", false);
        pluginGeneratedSerialDescriptor.addElement("quotedMessageId", false);
        pluginGeneratedSerialDescriptor.addElement("source", false);
        pluginGeneratedSerialDescriptor.addElement("attachmentId", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private MessageDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer[] kSerializerArr = MessageDto.$childSerializers;
        return new KSerializer[]{StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(kSerializerArr[3]), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), DoubleSerializer.INSTANCE, StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[12]), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(LongSerializer.INSTANCE), BuiltinSerializersKt.getNullable(CoordinatesDto$$serializer.INSTANCE), BuiltinSerializersKt.getNullable(LocationDto$$serializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[18]), BuiltinSerializersKt.getNullable(kSerializerArr[19]), BuiltinSerializersKt.getNullable(DisplaySettingsDto$$serializer.INSTANCE), BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[22]), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(MessageSourceDto$$serializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE)};
    }

    @Override
    public MessageDto deserialize(Decoder decoder) {
        List list;
        DisplaySettingsDto displaySettingsDto;
        Boolean bool;
        Long l;
        String str;
        String str2;
        String str3;
        String str4;
        String str5;
        String str6;
        String str7;
        LocationDto locationDto;
        double d;
        List list2;
        MessageSourceDto messageSourceDto;
        String str8;
        List list3;
        List list4;
        CoordinatesDto coordinatesDto;
        String str9;
        String str10;
        String str11;
        int i;
        String str12;
        String str13;
        String str14;
        Map map;
        int i2;
        int i3;
        int i4;
        String str15;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = MessageDto.$childSerializers;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            String strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
            List list5 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, kSerializerArr[3], null);
            String str16 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, null);
            String str17 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, null);
            double dDecodeDoubleElement = compositeDecoderBeginStructure.decodeDoubleElement(descriptor2, 6);
            String strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 7);
            String str18 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, StringSerializer.INSTANCE, null);
            String str19 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, StringSerializer.INSTANCE, null);
            String str20 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, null);
            String str21 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, null);
            Map map2 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 12, kSerializerArr[12], null);
            String str22 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 13, StringSerializer.INSTANCE, null);
            String str23 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 14, StringSerializer.INSTANCE, null);
            Long l2 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 15, LongSerializer.INSTANCE, null);
            CoordinatesDto coordinatesDto2 = (CoordinatesDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 16, CoordinatesDto$$serializer.INSTANCE, null);
            LocationDto locationDto2 = (LocationDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 17, LocationDto$$serializer.INSTANCE, null);
            List list6 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 18, kSerializerArr[18], null);
            List list7 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 19, kSerializerArr[19], null);
            DisplaySettingsDto displaySettingsDto2 = (DisplaySettingsDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 20, DisplaySettingsDto$$serializer.INSTANCE, null);
            Boolean bool2 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 21, BooleanSerializer.INSTANCE, null);
            List list8 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 22, kSerializerArr[22], null);
            String str24 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 23, StringSerializer.INSTANCE, null);
            MessageSourceDto messageSourceDto2 = (MessageSourceDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 24, MessageSourceDto$$serializer.INSTANCE, null);
            locationDto = locationDto2;
            str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 25, StringSerializer.INSTANCE, null);
            bool = bool2;
            str14 = strDecodeStringElement3;
            coordinatesDto = coordinatesDto2;
            list3 = list8;
            list4 = list7;
            list2 = list6;
            d = dDecodeDoubleElement;
            displaySettingsDto = displaySettingsDto2;
            str8 = str24;
            messageSourceDto = messageSourceDto2;
            list = list5;
            str4 = str17;
            str12 = str21;
            l = l2;
            str = str23;
            str2 = str22;
            map = map2;
            str10 = strDecodeStringElement;
            str11 = str16;
            str9 = strDecodeStringElement2;
            str7 = str20;
            str6 = str19;
            str3 = strDecodeStringElement4;
            str5 = str18;
            i = 67108863;
        } else {
            boolean z = true;
            CoordinatesDto coordinatesDto3 = null;
            Boolean bool3 = null;
            DisplaySettingsDto displaySettingsDto3 = null;
            List list9 = null;
            Long l3 = null;
            String str25 = null;
            MessageSourceDto messageSourceDto3 = null;
            String str26 = null;
            List list10 = null;
            List list11 = null;
            String str27 = null;
            String strDecodeStringElement5 = null;
            String strDecodeStringElement6 = null;
            List list12 = null;
            String str28 = null;
            String str29 = null;
            String str30 = null;
            String str31 = null;
            String str32 = null;
            String str33 = null;
            Map map3 = null;
            String str34 = null;
            double dDecodeDoubleElement2 = 0.0d;
            String strDecodeStringElement7 = null;
            String strDecodeStringElement8 = null;
            int i5 = 0;
            LocationDto locationDto3 = null;
            while (z) {
                String str35 = str25;
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        kSerializerArr = kSerializerArr;
                        locationDto3 = locationDto3;
                        break;
                    case 0:
                        strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i5 |= 1;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        kSerializerArr = kSerializerArr;
                        locationDto3 = locationDto3;
                        break;
                    case 1:
                        strDecodeStringElement7 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        i5 |= 2;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        kSerializerArr = kSerializerArr;
                        locationDto3 = locationDto3;
                        break;
                    case 2:
                        strDecodeStringElement8 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
                        i5 |= 4;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        kSerializerArr = kSerializerArr;
                        locationDto3 = locationDto3;
                        break;
                    case 3:
                        list12 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, kSerializerArr[3], list12);
                        i5 |= 8;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        kSerializerArr = kSerializerArr;
                        locationDto3 = locationDto3;
                        break;
                    case 4:
                        locationDto3 = locationDto3;
                        str28 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, str28);
                        i5 |= 16;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        str29 = str29;
                        locationDto3 = locationDto3;
                        break;
                    case 5:
                        locationDto3 = locationDto3;
                        str29 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, str29);
                        i5 |= 32;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        str30 = str30;
                        locationDto3 = locationDto3;
                        break;
                    case 6:
                        dDecodeDoubleElement2 = compositeDecoderBeginStructure.decodeDoubleElement(descriptor2, 6);
                        i5 |= 64;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        locationDto3 = locationDto3;
                        break;
                    case 7:
                        strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 7);
                        i5 |= 128;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        locationDto3 = locationDto3;
                        break;
                    case 8:
                        locationDto3 = locationDto3;
                        str30 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, StringSerializer.INSTANCE, str30);
                        i5 |= 256;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        str31 = str31;
                        locationDto3 = locationDto3;
                        break;
                    case 9:
                        locationDto3 = locationDto3;
                        str31 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, StringSerializer.INSTANCE, str31);
                        i5 |= 512;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        str32 = str32;
                        locationDto3 = locationDto3;
                        break;
                    case 10:
                        str32 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, str32);
                        i5 |= 1024;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        locationDto3 = locationDto3;
                        break;
                    case 11:
                        str33 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, str33);
                        i5 |= 2048;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str35;
                        str34 = str34;
                        break;
                    case Message.TYPE_USER_VIDEO:
                        str15 = str35;
                        map3 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 12, kSerializerArr[12], map3);
                        i5 |= 4096;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str15;
                        break;
                    case 13:
                        str15 = str35;
                        str34 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 13, StringSerializer.INSTANCE, str34);
                        i5 |= 8192;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        str25 = str15;
                        break;
                    case Message.TYPE_USER_FILE:
                        i5 |= 16384;
                        str25 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 14, StringSerializer.INSTANCE, str35);
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        l3 = l3;
                        break;
                    case WebSocketProtocol.B0_MASK_OPCODE:
                        l3 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 15, LongSerializer.INSTANCE, l3);
                        i5 |= 32768;
                        coordinatesDto3 = coordinatesDto3;
                        bool3 = bool3;
                        str25 = str35;
                        break;
                    case 16:
                        coordinatesDto3 = (CoordinatesDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 16, CoordinatesDto$$serializer.INSTANCE, coordinatesDto3);
                        i2 = 65536;
                        i5 |= i2;
                        bool3 = bool3;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case LangUtils.HASH_SEED:
                        locationDto3 = (LocationDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 17, LocationDto$$serializer.INSTANCE, locationDto3);
                        i2 = 131072;
                        i5 |= i2;
                        bool3 = bool3;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case 18:
                        list9 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 18, kSerializerArr[18], list9);
                        i3 = 262144;
                        i5 |= i3;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case Base64.Encoder.LINE_GROUPS:
                        list11 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 19, kSerializerArr[19], list11);
                        i4 = 524288;
                        i5 |= i4;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case ConnManagerParams.DEFAULT_MAX_TOTAL_CONNECTIONS:
                        displaySettingsDto3 = (DisplaySettingsDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 20, DisplaySettingsDto$$serializer.INSTANCE, displaySettingsDto3);
                        i3 = 1048576;
                        i5 |= i3;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case ConversationMsg.TYPE_USER_TEXT:
                        bool3 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 21, BooleanSerializer.INSTANCE, bool3);
                        i3 = 2097152;
                        i5 |= i3;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case 22:
                        list10 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 22, kSerializerArr[22], list10);
                        i4 = 4194304;
                        i5 |= i4;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case 23:
                        str26 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 23, StringSerializer.INSTANCE, str26);
                        i3 = 8388608;
                        i5 |= i3;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case 24:
                        messageSourceDto3 = (MessageSourceDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 24, MessageSourceDto$$serializer.INSTANCE, messageSourceDto3);
                        i3 = Http2Connection.OKHTTP_CLIENT_WINDOW_SIZE;
                        i5 |= i3;
                        str25 = str35;
                        l3 = l3;
                        break;
                    case 25:
                        str27 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 25, StringSerializer.INSTANCE, str27);
                        i3 = 33554432;
                        i5 |= i3;
                        str25 = str35;
                        l3 = l3;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            list = list12;
            displaySettingsDto = displaySettingsDto3;
            bool = bool3;
            l = l3;
            str = str25;
            str2 = str34;
            str3 = strDecodeStringElement5;
            str4 = str29;
            str5 = str30;
            str6 = str31;
            str7 = str32;
            locationDto = locationDto3;
            d = dDecodeDoubleElement2;
            list2 = list9;
            messageSourceDto = messageSourceDto3;
            str8 = str26;
            list3 = list10;
            list4 = list11;
            coordinatesDto = coordinatesDto3;
            str9 = strDecodeStringElement7;
            str10 = strDecodeStringElement6;
            str11 = str28;
            i = i5;
            str12 = str33;
            str13 = str27;
            str14 = strDecodeStringElement8;
            map = map3;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new MessageDto(i, str10, str9, str14, list, str11, str4, d, str3, str5, str6, str7, str12, map, str2, str, l, coordinatesDto, locationDto, list2, list4, displaySettingsDto, bool, list3, str8, messageSourceDto, str13, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, MessageDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        MessageDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
