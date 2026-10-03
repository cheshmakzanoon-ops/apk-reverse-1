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
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import zendesk.conversationkit.android.internal.rest.model.MessageDto;
import zendesk.conversationkit.android.internal.rest.model.MessageDto$$serializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/faye/WsFayeMessageDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/faye/WsFayeMessageDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class WsFayeMessageDto$$serializer implements GeneratedSerializer<WsFayeMessageDto> {
    public static final WsFayeMessageDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        WsFayeMessageDto$$serializer wsFayeMessageDto$$serializer = new WsFayeMessageDto$$serializer();
        INSTANCE = wsFayeMessageDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.faye.WsFayeMessageDto", wsFayeMessageDto$$serializer, 4);
        pluginGeneratedSerialDescriptor.addElement("type", false);
        pluginGeneratedSerialDescriptor.addElement("conversation", false);
        pluginGeneratedSerialDescriptor.addElement("message", true);
        pluginGeneratedSerialDescriptor.addElement("activity", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private WsFayeMessageDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{StringSerializer.INSTANCE, WsConversationDto$$serializer.INSTANCE, BuiltinSerializersKt.getNullable(MessageDto$$serializer.INSTANCE), BuiltinSerializersKt.getNullable(WsActivityEventDto$$serializer.INSTANCE)};
    }

    @Override
    public WsFayeMessageDto deserialize(Decoder decoder) {
        int i;
        String str;
        WsConversationDto wsConversationDto;
        MessageDto messageDto;
        WsActivityEventDto wsActivityEventDto;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        String strDecodeStringElement = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            WsConversationDto wsConversationDto2 = (WsConversationDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, WsConversationDto$$serializer.INSTANCE, null);
            MessageDto messageDto2 = (MessageDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, MessageDto$$serializer.INSTANCE, null);
            str = strDecodeStringElement2;
            wsActivityEventDto = (WsActivityEventDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, WsActivityEventDto$$serializer.INSTANCE, null);
            messageDto = messageDto2;
            wsConversationDto = wsConversationDto2;
            i = 15;
        } else {
            boolean z = true;
            int i2 = 0;
            WsConversationDto wsConversationDto3 = null;
            MessageDto messageDto3 = null;
            WsActivityEventDto wsActivityEventDto2 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                if (iDecodeElementIndex == -1) {
                    z = false;
                } else if (iDecodeElementIndex == 0) {
                    strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                    i2 |= 1;
                } else if (iDecodeElementIndex == 1) {
                    wsConversationDto3 = (WsConversationDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, WsConversationDto$$serializer.INSTANCE, wsConversationDto3);
                    i2 |= 2;
                } else if (iDecodeElementIndex == 2) {
                    messageDto3 = (MessageDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, MessageDto$$serializer.INSTANCE, messageDto3);
                    i2 |= 4;
                } else {
                    if (iDecodeElementIndex != 3) {
                        throw new UnknownFieldException(iDecodeElementIndex);
                    }
                    wsActivityEventDto2 = (WsActivityEventDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, WsActivityEventDto$$serializer.INSTANCE, wsActivityEventDto2);
                    i2 |= 8;
                }
            }
            i = i2;
            str = strDecodeStringElement;
            wsConversationDto = wsConversationDto3;
            messageDto = messageDto3;
            wsActivityEventDto = wsActivityEventDto2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new WsFayeMessageDto(i, str, wsConversationDto, messageDto, wsActivityEventDto, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, WsFayeMessageDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        WsFayeMessageDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
