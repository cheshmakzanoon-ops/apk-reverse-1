package zendesk.conversationkit.android.model;

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
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/model/MessageAction.Reply.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class MessageAction$Reply$$serializer implements GeneratedSerializer<MessageAction.Reply> {
    public static final MessageAction$Reply$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        MessageAction$Reply$$serializer messageAction$Reply$$serializer = new MessageAction$Reply$$serializer();
        INSTANCE = messageAction$Reply$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("reply", messageAction$Reply$$serializer, 6);
        pluginGeneratedSerialDescriptor.addElement("messageActionType", false);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("metadata", true);
        pluginGeneratedSerialDescriptor.addElement("text", false);
        pluginGeneratedSerialDescriptor.addElement("iconUrl", false);
        pluginGeneratedSerialDescriptor.addElement("payload", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private MessageAction$Reply$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = MessageAction.Reply.$childSerializers;
        return new KSerializer[]{kSerializerArr[0], StringSerializer.INSTANCE, kSerializerArr[2], StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), StringSerializer.INSTANCE};
    }

    @Override
    public MessageAction.Reply deserialize(Decoder decoder) {
        String str;
        String strDecodeStringElement;
        Map map;
        String str2;
        MessageActionType messageActionType;
        String str3;
        int i;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = MessageAction.Reply.$childSerializers;
        int i2 = 5;
        MessageActionType messageActionType2 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            MessageActionType messageActionType3 = (MessageActionType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], null);
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            Map map2 = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, kSerializerArr[2], null);
            String strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
            String str4 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, null);
            map = map2;
            messageActionType = messageActionType3;
            strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 5);
            str2 = strDecodeStringElement3;
            str = str4;
            i = 63;
            str3 = strDecodeStringElement2;
        } else {
            boolean z = true;
            int i3 = 0;
            String strDecodeStringElement4 = null;
            Map map3 = null;
            String strDecodeStringElement5 = null;
            String str5 = null;
            String strDecodeStringElement6 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        continue;
                    case 0:
                        messageActionType2 = (MessageActionType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], messageActionType2);
                        i3 |= 1;
                        i2 = 5;
                        continue;
                    case 1:
                        strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        i3 |= 2;
                        break;
                    case 2:
                        map3 = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, kSerializerArr[2], map3);
                        i3 |= 4;
                        break;
                    case 3:
                        strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
                        i3 |= 8;
                        break;
                    case 4:
                        str5 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, str5);
                        i3 |= 16;
                        break;
                    case 5:
                        strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, i2);
                        i3 |= 32;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            str = str5;
            strDecodeStringElement = strDecodeStringElement6;
            map = map3;
            str2 = strDecodeStringElement5;
            messageActionType = messageActionType2;
            str3 = strDecodeStringElement4;
            i = i3;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new MessageAction.Reply(i, messageActionType, str3, map, str2, str, strDecodeStringElement, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, MessageAction.Reply value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        MessageAction.Reply.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
