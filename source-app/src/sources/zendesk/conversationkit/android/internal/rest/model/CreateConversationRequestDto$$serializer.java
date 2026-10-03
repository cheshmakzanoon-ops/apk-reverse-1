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
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import zendesk.conversationkit.android.model.ConversationType;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class CreateConversationRequestDto$$serializer implements GeneratedSerializer<CreateConversationRequestDto> {
    public static final CreateConversationRequestDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        CreateConversationRequestDto$$serializer createConversationRequestDto$$serializer = new CreateConversationRequestDto$$serializer();
        INSTANCE = createConversationRequestDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.CreateConversationRequestDto", createConversationRequestDto$$serializer, 7);
        pluginGeneratedSerialDescriptor.addElement("type", false);
        pluginGeneratedSerialDescriptor.addElement("intent", false);
        pluginGeneratedSerialDescriptor.addElement("client", false);
        pluginGeneratedSerialDescriptor.addElement("signedCampaignData", true);
        pluginGeneratedSerialDescriptor.addElement("messages", true);
        pluginGeneratedSerialDescriptor.addElement("postback", true);
        pluginGeneratedSerialDescriptor.addElement("metadata", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private CreateConversationRequestDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = CreateConversationRequestDto.$childSerializers;
        return new KSerializer[]{kSerializerArr[0], kSerializerArr[1], ClientDto$$serializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[4]), BuiltinSerializersKt.getNullable(PostbackDto$$serializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[6])};
    }

    @Override
    public CreateConversationRequestDto deserialize(Decoder decoder) {
        int i;
        Map map;
        ConversationType conversationType;
        ClientDto clientDto;
        List list;
        PostbackDto postbackDto;
        Intent intent;
        String str;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = CreateConversationRequestDto.$childSerializers;
        int i2 = 5;
        int i3 = 3;
        ConversationType conversationType2 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            ConversationType conversationType3 = (ConversationType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], null);
            Intent intent2 = (Intent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, kSerializerArr[1], null);
            ClientDto clientDto2 = (ClientDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, ClientDto$$serializer.INSTANCE, null);
            String str2 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            List list2 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, kSerializerArr[4], null);
            PostbackDto postbackDto2 = (PostbackDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, PostbackDto$$serializer.INSTANCE, null);
            map = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, kSerializerArr[6], null);
            postbackDto = postbackDto2;
            str = str2;
            clientDto = clientDto2;
            list = list2;
            intent = intent2;
            conversationType = conversationType3;
            i = 127;
        } else {
            boolean z = true;
            int i4 = 0;
            Map map2 = null;
            PostbackDto postbackDto3 = null;
            Intent intent3 = null;
            ClientDto clientDto3 = null;
            String str3 = null;
            List list3 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        i2 = 5;
                        break;
                    case 0:
                        conversationType2 = (ConversationType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], conversationType2);
                        i4 |= 1;
                        i2 = 5;
                        i3 = 3;
                        break;
                    case 1:
                        intent3 = (Intent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, kSerializerArr[1], intent3);
                        i4 |= 2;
                        i2 = 5;
                        break;
                    case 2:
                        clientDto3 = (ClientDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, ClientDto$$serializer.INSTANCE, clientDto3);
                        i4 |= 4;
                        i2 = 5;
                        break;
                    case 3:
                        str3 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i3, StringSerializer.INSTANCE, str3);
                        i4 |= 8;
                        break;
                    case 4:
                        list3 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, kSerializerArr[4], list3);
                        i4 |= 16;
                        break;
                    case 5:
                        postbackDto3 = (PostbackDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i2, PostbackDto$$serializer.INSTANCE, postbackDto3);
                        i4 |= 32;
                        break;
                    case 6:
                        map2 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, kSerializerArr[6], map2);
                        i4 |= 64;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            i = i4;
            List list4 = list3;
            map = map2;
            conversationType = conversationType2;
            clientDto = clientDto3;
            list = list4;
            String str4 = str3;
            postbackDto = postbackDto3;
            intent = intent3;
            str = str4;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new CreateConversationRequestDto(i, conversationType, intent, clientDto, str, list, postbackDto, map, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, CreateConversationRequestDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        CreateConversationRequestDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
