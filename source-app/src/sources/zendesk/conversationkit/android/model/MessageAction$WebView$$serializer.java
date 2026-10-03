package zendesk.conversationkit.android.model;

import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.UnknownFieldException;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeDecoder;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.encoding.Decoder;
import kotlinx.serialization.encoding.Encoder;
import kotlinx.serialization.internal.BooleanSerializer;
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/model/MessageAction.WebView.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$WebView;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class MessageAction$WebView$$serializer implements GeneratedSerializer<MessageAction.WebView> {
    public static final MessageAction$WebView$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        MessageAction$WebView$$serializer messageAction$WebView$$serializer = new MessageAction$WebView$$serializer();
        INSTANCE = messageAction$WebView$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("webview", messageAction$WebView$$serializer, 9);
        pluginGeneratedSerialDescriptor.addElement("messageActionType", false);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("metadata", true);
        pluginGeneratedSerialDescriptor.addElement("text", false);
        pluginGeneratedSerialDescriptor.addElement("uri", false);
        pluginGeneratedSerialDescriptor.addElement("fallback", false);
        pluginGeneratedSerialDescriptor.addElement("default", false);
        pluginGeneratedSerialDescriptor.addElement("openOnReceive", false);
        pluginGeneratedSerialDescriptor.addElement("size", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private MessageAction$WebView$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = MessageAction.WebView.$childSerializers;
        return new KSerializer[]{kSerializerArr[0], StringSerializer.INSTANCE, kSerializerArr[2], StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, BooleanSerializer.INSTANCE, BooleanSerializer.INSTANCE, kSerializerArr[8]};
    }

    @Override
    public MessageAction.WebView deserialize(Decoder decoder) {
        boolean z;
        MessageActionSize messageActionSize;
        Map map;
        int i;
        String str;
        String str2;
        String str3;
        String str4;
        boolean z2;
        MessageActionType messageActionType;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = MessageAction.WebView.$childSerializers;
        int i2 = 7;
        int i3 = 6;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            MessageActionType messageActionType2 = (MessageActionType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], null);
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            Map map2 = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, kSerializerArr[2], null);
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
            String strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
            String strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 5);
            boolean zDecodeBooleanElement = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 6);
            boolean zDecodeBooleanElement2 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 7);
            messageActionSize = (MessageActionSize) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 8, kSerializerArr[8], null);
            messageActionType = messageActionType2;
            z = zDecodeBooleanElement2;
            z2 = zDecodeBooleanElement;
            str4 = strDecodeStringElement4;
            str2 = strDecodeStringElement2;
            str3 = strDecodeStringElement3;
            i = 511;
            map = map2;
            str = strDecodeStringElement;
        } else {
            boolean z3 = true;
            boolean zDecodeBooleanElement3 = false;
            int i4 = 0;
            MessageActionSize messageActionSize2 = null;
            MessageActionType messageActionType3 = null;
            String strDecodeStringElement5 = null;
            String strDecodeStringElement6 = null;
            String strDecodeStringElement7 = null;
            String strDecodeStringElement8 = null;
            Map map3 = null;
            boolean zDecodeBooleanElement4 = false;
            while (z3) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z3 = false;
                        i2 = 7;
                        break;
                    case 0:
                        messageActionType3 = (MessageActionType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], messageActionType3);
                        i4 |= 1;
                        i2 = 7;
                        i3 = 6;
                        break;
                    case 1:
                        strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        i4 |= 2;
                        i2 = 7;
                        break;
                    case 2:
                        map3 = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, kSerializerArr[2], map3);
                        i4 |= 4;
                        i2 = 7;
                        break;
                    case 3:
                        strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
                        i4 |= 8;
                        break;
                    case 4:
                        strDecodeStringElement7 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
                        i4 |= 16;
                        break;
                    case 5:
                        strDecodeStringElement8 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 5);
                        i4 |= 32;
                        break;
                    case 6:
                        zDecodeBooleanElement4 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, i3);
                        i4 |= 64;
                        break;
                    case 7:
                        zDecodeBooleanElement3 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, i2);
                        i4 |= 128;
                        break;
                    case 8:
                        messageActionSize2 = (MessageActionSize) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 8, kSerializerArr[8], messageActionSize2);
                        i4 |= 256;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            z = zDecodeBooleanElement3;
            messageActionSize = messageActionSize2;
            MessageActionType messageActionType4 = messageActionType3;
            map = map3;
            i = i4;
            str = strDecodeStringElement5;
            str2 = strDecodeStringElement6;
            str3 = strDecodeStringElement7;
            str4 = strDecodeStringElement8;
            z2 = zDecodeBooleanElement4;
            messageActionType = messageActionType4;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new MessageAction.WebView(i, messageActionType, str, map, str2, str3, str4, z2, z, messageActionSize, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, MessageAction.WebView value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        MessageAction.WebView.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
