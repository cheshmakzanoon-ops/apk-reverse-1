package zendesk.android.settings.internal.model;

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
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/android/settings/internal/model/IntegrationDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/android/settings/internal/model/IntegrationDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class IntegrationDto$$serializer implements GeneratedSerializer<IntegrationDto> {
    public static final IntegrationDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        IntegrationDto$$serializer integrationDto$$serializer = new IntegrationDto$$serializer();
        INSTANCE = integrationDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.android.settings.internal.model.IntegrationDto", integrationDto$$serializer, 4);
        pluginGeneratedSerialDescriptor.addElement("_id", false);
        pluginGeneratedSerialDescriptor.addElement("canUserCreateMoreConversations", false);
        pluginGeneratedSerialDescriptor.addElement("canUserSeeConversationList", false);
        pluginGeneratedSerialDescriptor.addElement("waitConfig", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private IntegrationDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{StringSerializer.INSTANCE, BooleanSerializer.INSTANCE, BooleanSerializer.INSTANCE, BuiltinSerializersKt.getNullable(WaitConfigDto$$serializer.INSTANCE)};
    }

    @Override
    public IntegrationDto deserialize(Decoder decoder) {
        boolean z;
        boolean z2;
        int i;
        String str;
        WaitConfigDto waitConfigDto;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            boolean zDecodeBooleanElement = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 1);
            boolean zDecodeBooleanElement2 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 2);
            str = strDecodeStringElement;
            waitConfigDto = (WaitConfigDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, WaitConfigDto$$serializer.INSTANCE, null);
            z = zDecodeBooleanElement2;
            z2 = zDecodeBooleanElement;
            i = 15;
        } else {
            boolean z3 = true;
            boolean zDecodeBooleanElement3 = false;
            int i2 = 0;
            String strDecodeStringElement2 = null;
            WaitConfigDto waitConfigDto2 = null;
            boolean zDecodeBooleanElement4 = false;
            while (z3) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                if (iDecodeElementIndex == -1) {
                    z3 = false;
                } else if (iDecodeElementIndex == 0) {
                    strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                    i2 |= 1;
                } else if (iDecodeElementIndex == 1) {
                    zDecodeBooleanElement4 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 1);
                    i2 |= 2;
                } else if (iDecodeElementIndex == 2) {
                    zDecodeBooleanElement3 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 2);
                    i2 |= 4;
                } else {
                    if (iDecodeElementIndex != 3) {
                        throw new UnknownFieldException(iDecodeElementIndex);
                    }
                    waitConfigDto2 = (WaitConfigDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, WaitConfigDto$$serializer.INSTANCE, waitConfigDto2);
                    i2 |= 8;
                }
            }
            z = zDecodeBooleanElement3;
            z2 = zDecodeBooleanElement4;
            i = i2;
            str = strDecodeStringElement2;
            waitConfigDto = waitConfigDto2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new IntegrationDto(i, str, z2, z, waitConfigDto, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, IntegrationDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        IntegrationDto.write$Self$zendesk_zendesk_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
