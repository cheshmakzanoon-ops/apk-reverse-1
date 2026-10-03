package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
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
import kotlinx.serialization.internal.DoubleSerializer;
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/model/Message.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/model/Message;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class Message$$serializer implements GeneratedSerializer<Message> {
    public static final Message$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        Message$$serializer message$$serializer = new Message$$serializer();
        INSTANCE = message$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.model.Message", message$$serializer, 11);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("author", false);
        pluginGeneratedSerialDescriptor.addElement("status", false);
        pluginGeneratedSerialDescriptor.addElement("created", false);
        pluginGeneratedSerialDescriptor.addElement("received", false);
        pluginGeneratedSerialDescriptor.addElement("beforeTimestamp", false);
        pluginGeneratedSerialDescriptor.addElement("content", false);
        pluginGeneratedSerialDescriptor.addElement("metadata", false);
        pluginGeneratedSerialDescriptor.addElement("sourceId", false);
        pluginGeneratedSerialDescriptor.addElement("localId", false);
        pluginGeneratedSerialDescriptor.addElement("payload", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private Message$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = Message.$childSerializers;
        return new KSerializer[]{StringSerializer.INSTANCE, Author$$serializer.INSTANCE, kSerializerArr[2], BuiltinSerializersKt.getNullable(kSerializerArr[3]), kSerializerArr[4], DoubleSerializer.INSTANCE, kSerializerArr[6], BuiltinSerializersKt.getNullable(kSerializerArr[7]), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE)};
    }

    @Override
    public Message deserialize(Decoder decoder) {
        Map map;
        String str;
        String str2;
        MessageContent messageContent;
        Author author;
        String str3;
        int i;
        LocalDateTime localDateTime;
        String str4;
        double d;
        LocalDateTime localDateTime2;
        MessageStatus messageStatus;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = Message.$childSerializers;
        int i2 = 10;
        int i3 = 9;
        String strDecodeStringElement = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            Author author2 = (Author) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, Author$$serializer.INSTANCE, null);
            messageStatus = (MessageStatus) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, kSerializerArr[2], null);
            LocalDateTime localDateTime3 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, kSerializerArr[3], null);
            LocalDateTime localDateTime4 = (LocalDateTime) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], null);
            double dDecodeDoubleElement = compositeDecoderBeginStructure.decodeDoubleElement(descriptor2, 5);
            MessageContent messageContent2 = (MessageContent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 6, kSerializerArr[6], null);
            Map map2 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, kSerializerArr[7], null);
            String str5 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, StringSerializer.INSTANCE, null);
            String strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 9);
            map = map2;
            str = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, null);
            str3 = strDecodeStringElement3;
            str2 = str5;
            i = 2047;
            localDateTime = localDateTime4;
            author = author2;
            d = dDecodeDoubleElement;
            messageContent = messageContent2;
            localDateTime2 = localDateTime3;
            str4 = strDecodeStringElement2;
        } else {
            boolean z = true;
            int i4 = 0;
            Map map3 = null;
            String str6 = null;
            String str7 = null;
            LocalDateTime localDateTime5 = null;
            MessageContent messageContent3 = null;
            LocalDateTime localDateTime6 = null;
            MessageStatus messageStatus2 = null;
            Author author3 = null;
            String strDecodeStringElement4 = null;
            double dDecodeDoubleElement2 = 0.0d;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        i3 = 9;
                        break;
                    case 0:
                        strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i4 |= 1;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 1:
                        author3 = (Author) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, Author$$serializer.INSTANCE, author3);
                        i4 |= 2;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 2:
                        messageStatus2 = (MessageStatus) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, kSerializerArr[2], messageStatus2);
                        i4 |= 4;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 3:
                        localDateTime6 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, kSerializerArr[3], localDateTime6);
                        i4 |= 8;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 4:
                        localDateTime5 = (LocalDateTime) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], localDateTime5);
                        i4 |= 16;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 5:
                        dDecodeDoubleElement2 = compositeDecoderBeginStructure.decodeDoubleElement(descriptor2, 5);
                        i4 |= 32;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 6:
                        messageContent3 = (MessageContent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 6, kSerializerArr[6], messageContent3);
                        i4 |= 64;
                        i2 = 10;
                        i3 = 9;
                        break;
                    case 7:
                        map3 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, kSerializerArr[7], map3);
                        i4 |= 128;
                        i2 = 10;
                        break;
                    case 8:
                        str7 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, StringSerializer.INSTANCE, str7);
                        i4 |= 256;
                        i2 = 10;
                        break;
                    case 9:
                        strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, i3);
                        i4 |= 512;
                        break;
                    case 10:
                        str6 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i2, StringSerializer.INSTANCE, str6);
                        i4 |= 1024;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            map = map3;
            str = str6;
            str2 = str7;
            messageContent = messageContent3;
            author = author3;
            str3 = strDecodeStringElement4;
            i = i4;
            localDateTime = localDateTime5;
            str4 = strDecodeStringElement;
            d = dDecodeDoubleElement2;
            MessageStatus messageStatus3 = messageStatus2;
            localDateTime2 = localDateTime6;
            messageStatus = messageStatus3;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new Message(i, str4, author, messageStatus, localDateTime2, localDateTime, d, messageContent, map, str2, str3, str, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, Message value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        Message.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
