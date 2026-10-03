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
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/AppUserResponseDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/AppUserResponseDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class AppUserResponseDto$$serializer implements GeneratedSerializer<AppUserResponseDto> {
    public static final AppUserResponseDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        AppUserResponseDto$$serializer appUserResponseDto$$serializer = new AppUserResponseDto$$serializer();
        INSTANCE = appUserResponseDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.AppUserResponseDto", appUserResponseDto$$serializer, 6);
        pluginGeneratedSerialDescriptor.addElement("settings", false);
        pluginGeneratedSerialDescriptor.addElement("conversations", false);
        pluginGeneratedSerialDescriptor.addElement("conversationsPagination", false);
        pluginGeneratedSerialDescriptor.addElement("appUser", false);
        pluginGeneratedSerialDescriptor.addElement("appUsers", false);
        pluginGeneratedSerialDescriptor.addElement("sessionToken", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private AppUserResponseDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = AppUserResponseDto.$childSerializers;
        return new KSerializer[]{UserSettingsDto$$serializer.INSTANCE, kSerializerArr[1], ConversationsPaginationDto$$serializer.INSTANCE, AppUserDto$$serializer.INSTANCE, kSerializerArr[4], BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE)};
    }

    @Override
    public AppUserResponseDto deserialize(Decoder decoder) {
        Map map;
        String str;
        ConversationsPaginationDto conversationsPaginationDto;
        AppUserDto appUserDto;
        UserSettingsDto userSettingsDto;
        List list;
        int i;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = AppUserResponseDto.$childSerializers;
        int i2 = 5;
        UserSettingsDto userSettingsDto2 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            UserSettingsDto userSettingsDto3 = (UserSettingsDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, UserSettingsDto$$serializer.INSTANCE, null);
            List list2 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, kSerializerArr[1], null);
            ConversationsPaginationDto conversationsPaginationDto2 = (ConversationsPaginationDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, ConversationsPaginationDto$$serializer.INSTANCE, null);
            AppUserDto appUserDto2 = (AppUserDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 3, AppUserDto$$serializer.INSTANCE, null);
            map = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], null);
            userSettingsDto = userSettingsDto3;
            str = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, null);
            appUserDto = appUserDto2;
            conversationsPaginationDto = conversationsPaginationDto2;
            i = 63;
            list = list2;
        } else {
            boolean z = true;
            int i3 = 0;
            List list3 = null;
            ConversationsPaginationDto conversationsPaginationDto3 = null;
            AppUserDto appUserDto3 = null;
            Map map2 = null;
            String str2 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        i2 = 5;
                        break;
                    case 0:
                        userSettingsDto2 = (UserSettingsDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, UserSettingsDto$$serializer.INSTANCE, userSettingsDto2);
                        i3 |= 1;
                        i2 = 5;
                        break;
                    case 1:
                        list3 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, kSerializerArr[1], list3);
                        i3 |= 2;
                        break;
                    case 2:
                        conversationsPaginationDto3 = (ConversationsPaginationDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, ConversationsPaginationDto$$serializer.INSTANCE, conversationsPaginationDto3);
                        i3 |= 4;
                        break;
                    case 3:
                        appUserDto3 = (AppUserDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 3, AppUserDto$$serializer.INSTANCE, appUserDto3);
                        i3 |= 8;
                        break;
                    case 4:
                        map2 = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], map2);
                        i3 |= 16;
                        break;
                    case 5:
                        str2 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i2, StringSerializer.INSTANCE, str2);
                        i3 |= 32;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            map = map2;
            str = str2;
            conversationsPaginationDto = conversationsPaginationDto3;
            appUserDto = appUserDto3;
            userSettingsDto = userSettingsDto2;
            list = list3;
            i = i3;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new AppUserResponseDto(i, userSettingsDto, list, conversationsPaginationDto, appUserDto, map, str, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, AppUserResponseDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        AppUserResponseDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
