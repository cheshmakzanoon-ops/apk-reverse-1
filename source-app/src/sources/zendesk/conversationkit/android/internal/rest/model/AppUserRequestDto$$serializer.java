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

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/AppUserRequestDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/AppUserRequestDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class AppUserRequestDto$$serializer implements GeneratedSerializer<AppUserRequestDto> {
    public static final AppUserRequestDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        AppUserRequestDto$$serializer appUserRequestDto$$serializer = new AppUserRequestDto$$serializer();
        INSTANCE = appUserRequestDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.AppUserRequestDto", appUserRequestDto$$serializer, 11);
        pluginGeneratedSerialDescriptor.addElement("client", false);
        pluginGeneratedSerialDescriptor.addElement("userId", true);
        pluginGeneratedSerialDescriptor.addElement("givenName", true);
        pluginGeneratedSerialDescriptor.addElement("surname", true);
        pluginGeneratedSerialDescriptor.addElement("email", true);
        pluginGeneratedSerialDescriptor.addElement("properties", true);
        pluginGeneratedSerialDescriptor.addElement("intent", true);
        pluginGeneratedSerialDescriptor.addElement("signedCampaignData", true);
        pluginGeneratedSerialDescriptor.addElement("messages", true);
        pluginGeneratedSerialDescriptor.addElement("postback", true);
        pluginGeneratedSerialDescriptor.addElement("conversation", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private AppUserRequestDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = AppUserRequestDto.$childSerializers;
        return new KSerializer[]{ClientDto$$serializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[5]), kSerializerArr[6], BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[8]), BuiltinSerializersKt.getNullable(PostbackDto$$serializer.INSTANCE), BuiltinSerializersKt.getNullable(CreateConversationRequestDto$$serializer.INSTANCE)};
    }

    @Override
    public AppUserRequestDto deserialize(Decoder decoder) {
        List list;
        PostbackDto postbackDto;
        CreateConversationRequestDto createConversationRequestDto;
        int i;
        Map map;
        String str;
        String str2;
        String str3;
        String str4;
        Intent intent;
        String str5;
        ClientDto clientDto;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = AppUserRequestDto.$childSerializers;
        ClientDto clientDto2 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            ClientDto clientDto3 = (ClientDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, ClientDto$$serializer.INSTANCE, null);
            String str6 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, null);
            str4 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, null);
            String str7 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            String str8 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, null);
            Map map2 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, kSerializerArr[5], null);
            Intent intent2 = (Intent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 6, kSerializerArr[6], null);
            String str9 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, StringSerializer.INSTANCE, null);
            List list2 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, kSerializerArr[8], null);
            PostbackDto postbackDto2 = (PostbackDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, PostbackDto$$serializer.INSTANCE, null);
            list = list2;
            createConversationRequestDto = (CreateConversationRequestDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, CreateConversationRequestDto$$serializer.INSTANCE, null);
            postbackDto = postbackDto2;
            str2 = str9;
            i = 2047;
            map = map2;
            str5 = str8;
            str = str6;
            intent = intent2;
            str3 = str7;
            clientDto = clientDto3;
        } else {
            boolean z = true;
            int i2 = 0;
            CreateConversationRequestDto createConversationRequestDto2 = null;
            List list3 = null;
            String str10 = null;
            Map map3 = null;
            String str11 = null;
            String str12 = null;
            Intent intent3 = null;
            PostbackDto postbackDto3 = null;
            String str13 = null;
            String str14 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        clientDto2 = clientDto2;
                        break;
                    case 0:
                        i2 |= 1;
                        clientDto2 = (ClientDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, ClientDto$$serializer.INSTANCE, clientDto2);
                        createConversationRequestDto2 = createConversationRequestDto2;
                        break;
                    case 1:
                        str14 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, str14);
                        i2 |= 2;
                        createConversationRequestDto2 = createConversationRequestDto2;
                        clientDto2 = clientDto2;
                        break;
                    case 2:
                        str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, str13);
                        i2 |= 4;
                        createConversationRequestDto2 = createConversationRequestDto2;
                        clientDto2 = clientDto2;
                        break;
                    case 3:
                        str11 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, str11);
                        i2 |= 8;
                        createConversationRequestDto2 = createConversationRequestDto2;
                        clientDto2 = clientDto2;
                        break;
                    case 4:
                        str10 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, str10);
                        i2 |= 16;
                        createConversationRequestDto2 = createConversationRequestDto2;
                        clientDto2 = clientDto2;
                        break;
                    case 5:
                        map3 = (Map) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, kSerializerArr[5], map3);
                        i2 |= 32;
                        createConversationRequestDto2 = createConversationRequestDto2;
                        clientDto2 = clientDto2;
                        break;
                    case 6:
                        intent3 = (Intent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 6, kSerializerArr[6], intent3);
                        i2 |= 64;
                        createConversationRequestDto2 = createConversationRequestDto2;
                        clientDto2 = clientDto2;
                        break;
                    case 7:
                        str12 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, StringSerializer.INSTANCE, str12);
                        i2 |= 128;
                        createConversationRequestDto2 = createConversationRequestDto2;
                        clientDto2 = clientDto2;
                        break;
                    case 8:
                        clientDto2 = clientDto2;
                        list3 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, kSerializerArr[8], list3);
                        i2 |= 256;
                        clientDto2 = clientDto2;
                        break;
                    case 9:
                        clientDto2 = clientDto2;
                        postbackDto3 = (PostbackDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, PostbackDto$$serializer.INSTANCE, postbackDto3);
                        i2 |= 512;
                        clientDto2 = clientDto2;
                        break;
                    case 10:
                        createConversationRequestDto2 = (CreateConversationRequestDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, CreateConversationRequestDto$$serializer.INSTANCE, createConversationRequestDto2);
                        i2 |= 1024;
                        clientDto2 = clientDto2;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            ClientDto clientDto4 = clientDto2;
            list = list3;
            postbackDto = postbackDto3;
            createConversationRequestDto = createConversationRequestDto2;
            i = i2;
            map = map3;
            str = str14;
            str2 = str12;
            str3 = str11;
            str4 = str13;
            intent = intent3;
            str5 = str10;
            clientDto = clientDto4;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new AppUserRequestDto(i, clientDto, str, str4, str3, str5, map, intent, str2, list, postbackDto, createConversationRequestDto, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, AppUserRequestDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        AppUserRequestDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
