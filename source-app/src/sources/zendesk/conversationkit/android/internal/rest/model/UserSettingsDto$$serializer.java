package zendesk.conversationkit.android.internal.rest.model;

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
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/UserSettingsDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class UserSettingsDto$$serializer implements GeneratedSerializer<UserSettingsDto> {
    public static final UserSettingsDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        UserSettingsDto$$serializer userSettingsDto$$serializer = new UserSettingsDto$$serializer();
        INSTANCE = userSettingsDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.UserSettingsDto", userSettingsDto$$serializer, 2);
        pluginGeneratedSerialDescriptor.addElement("realtime", false);
        pluginGeneratedSerialDescriptor.addElement("typing", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private UserSettingsDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{RealtimeSettingsDto$$serializer.INSTANCE, TypingSettingsDto$$serializer.INSTANCE};
    }

    @Override
    public UserSettingsDto deserialize(Decoder decoder) {
        RealtimeSettingsDto realtimeSettingsDto;
        TypingSettingsDto typingSettingsDto;
        int i;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        SerializationConstructorMarker serializationConstructorMarker = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            realtimeSettingsDto = (RealtimeSettingsDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, RealtimeSettingsDto$$serializer.INSTANCE, null);
            typingSettingsDto = (TypingSettingsDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, TypingSettingsDto$$serializer.INSTANCE, null);
            i = 3;
        } else {
            boolean z = true;
            int i2 = 0;
            realtimeSettingsDto = null;
            TypingSettingsDto typingSettingsDto2 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                if (iDecodeElementIndex == -1) {
                    z = false;
                } else if (iDecodeElementIndex == 0) {
                    realtimeSettingsDto = (RealtimeSettingsDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, RealtimeSettingsDto$$serializer.INSTANCE, realtimeSettingsDto);
                    i2 |= 1;
                } else {
                    if (iDecodeElementIndex != 1) {
                        throw new UnknownFieldException(iDecodeElementIndex);
                    }
                    typingSettingsDto2 = (TypingSettingsDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, TypingSettingsDto$$serializer.INSTANCE, typingSettingsDto2);
                    i2 |= 2;
                }
            }
            typingSettingsDto = typingSettingsDto2;
            i = i2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new UserSettingsDto(i, realtimeSettingsDto, typingSettingsDto, serializationConstructorMarker);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, UserSettingsDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        UserSettingsDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
