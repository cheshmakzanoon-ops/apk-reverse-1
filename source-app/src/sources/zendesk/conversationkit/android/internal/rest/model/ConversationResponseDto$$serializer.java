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
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/ConversationResponseDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ConversationResponseDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class ConversationResponseDto$$serializer implements GeneratedSerializer<ConversationResponseDto> {
    public static final ConversationResponseDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        ConversationResponseDto$$serializer conversationResponseDto$$serializer = new ConversationResponseDto$$serializer();
        INSTANCE = conversationResponseDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.ConversationResponseDto", conversationResponseDto$$serializer, 5);
        pluginGeneratedSerialDescriptor.addElement("conversation", false);
        pluginGeneratedSerialDescriptor.addElement("messages", false);
        pluginGeneratedSerialDescriptor.addElement("hasPrevious", false);
        pluginGeneratedSerialDescriptor.addElement("appUser", false);
        pluginGeneratedSerialDescriptor.addElement("appUsers", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private ConversationResponseDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = ConversationResponseDto.$childSerializers;
        return new KSerializer[]{ConversationDto$$serializer.INSTANCE, BuiltinSerializersKt.getNullable(kSerializerArr[1]), BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), AppUserDto$$serializer.INSTANCE, kSerializerArr[4]};
    }

    @Override
    public ConversationResponseDto deserialize(Decoder decoder) {
        int i;
        ConversationDto conversationDto;
        List list;
        Boolean bool;
        AppUserDto appUserDto;
        Map map;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = ConversationResponseDto.$childSerializers;
        ConversationDto conversationDto2 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            ConversationDto conversationDto3 = (ConversationDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, ConversationDto$$serializer.INSTANCE, null);
            List list2 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, kSerializerArr[1], null);
            Boolean bool2 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, BooleanSerializer.INSTANCE, null);
            AppUserDto appUserDto2 = (AppUserDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 3, AppUserDto$$serializer.INSTANCE, null);
            map = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], null);
            conversationDto = conversationDto3;
            appUserDto = appUserDto2;
            bool = bool2;
            i = 31;
            list = list2;
        } else {
            boolean z = true;
            int i2 = 0;
            List list3 = null;
            Boolean bool3 = null;
            AppUserDto appUserDto3 = null;
            Map map2 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                if (iDecodeElementIndex == -1) {
                    z = false;
                } else if (iDecodeElementIndex == 0) {
                    conversationDto2 = (ConversationDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, ConversationDto$$serializer.INSTANCE, conversationDto2);
                    i2 |= 1;
                } else if (iDecodeElementIndex == 1) {
                    list3 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, kSerializerArr[1], list3);
                    i2 |= 2;
                } else if (iDecodeElementIndex == 2) {
                    bool3 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, BooleanSerializer.INSTANCE, bool3);
                    i2 |= 4;
                } else if (iDecodeElementIndex == 3) {
                    appUserDto3 = (AppUserDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 3, AppUserDto$$serializer.INSTANCE, appUserDto3);
                    i2 |= 8;
                } else {
                    if (iDecodeElementIndex != 4) {
                        throw new UnknownFieldException(iDecodeElementIndex);
                    }
                    map2 = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], map2);
                    i2 |= 16;
                }
            }
            i = i2;
            conversationDto = conversationDto2;
            list = list3;
            bool = bool3;
            appUserDto = appUserDto3;
            map = map2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new ConversationResponseDto(i, conversationDto, list, bool, appUserDto, map, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, ConversationResponseDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        ConversationResponseDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
