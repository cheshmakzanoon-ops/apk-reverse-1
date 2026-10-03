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
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/android/settings/internal/model/SettingsDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/android/settings/internal/model/SettingsDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class SettingsDto$$serializer implements GeneratedSerializer<SettingsDto> {
    public static final SettingsDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        SettingsDto$$serializer settingsDto$$serializer = new SettingsDto$$serializer();
        INSTANCE = settingsDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.android.settings.internal.model.SettingsDto", settingsDto$$serializer, 7);
        pluginGeneratedSerialDescriptor.addElement("identifier", false);
        pluginGeneratedSerialDescriptor.addElement("light_theme", false);
        pluginGeneratedSerialDescriptor.addElement("dark_theme", false);
        pluginGeneratedSerialDescriptor.addElement("show_zendesk_logo", true);
        pluginGeneratedSerialDescriptor.addElement("attachments_enabled", false);
        pluginGeneratedSerialDescriptor.addElement("native_messaging", false);
        pluginGeneratedSerialDescriptor.addElement("sunco_config", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private SettingsDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), ColorThemeDto$$serializer.INSTANCE, ColorThemeDto$$serializer.INSTANCE, BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), BooleanSerializer.INSTANCE, NativeMessagingDto$$serializer.INSTANCE, BuiltinSerializersKt.getNullable(SunCoConfigDto$$serializer.INSTANCE)};
    }

    @Override
    public SettingsDto deserialize(Decoder decoder) {
        String str;
        ColorThemeDto colorThemeDto;
        ColorThemeDto colorThemeDto2;
        Boolean bool;
        int i;
        SunCoConfigDto sunCoConfigDto;
        NativeMessagingDto nativeMessagingDto;
        boolean z;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        int i2 = 6;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String str2 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 0, StringSerializer.INSTANCE, null);
            ColorThemeDto colorThemeDto3 = (ColorThemeDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, ColorThemeDto$$serializer.INSTANCE, null);
            ColorThemeDto colorThemeDto4 = (ColorThemeDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, ColorThemeDto$$serializer.INSTANCE, null);
            Boolean bool2 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, BooleanSerializer.INSTANCE, null);
            boolean zDecodeBooleanElement = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 4);
            NativeMessagingDto nativeMessagingDto2 = (NativeMessagingDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 5, NativeMessagingDto$$serializer.INSTANCE, null);
            str = str2;
            sunCoConfigDto = (SunCoConfigDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, SunCoConfigDto$$serializer.INSTANCE, null);
            nativeMessagingDto = nativeMessagingDto2;
            bool = bool2;
            z = zDecodeBooleanElement;
            colorThemeDto2 = colorThemeDto4;
            colorThemeDto = colorThemeDto3;
            i = 127;
        } else {
            boolean z2 = true;
            boolean zDecodeBooleanElement2 = false;
            str = null;
            colorThemeDto = null;
            colorThemeDto2 = null;
            bool = null;
            NativeMessagingDto nativeMessagingDto3 = null;
            SunCoConfigDto sunCoConfigDto2 = null;
            i = 0;
            while (z2) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z2 = false;
                        i2 = 6;
                        break;
                    case 0:
                        str = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 0, StringSerializer.INSTANCE, str);
                        i |= 1;
                        i2 = 6;
                        break;
                    case 1:
                        colorThemeDto = (ColorThemeDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, ColorThemeDto$$serializer.INSTANCE, colorThemeDto);
                        i |= 2;
                        i2 = 6;
                        break;
                    case 2:
                        colorThemeDto2 = (ColorThemeDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, ColorThemeDto$$serializer.INSTANCE, colorThemeDto2);
                        i |= 4;
                        break;
                    case 3:
                        bool = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, BooleanSerializer.INSTANCE, bool);
                        i |= 8;
                        break;
                    case 4:
                        zDecodeBooleanElement2 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 4);
                        i |= 16;
                        break;
                    case 5:
                        nativeMessagingDto3 = (NativeMessagingDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 5, NativeMessagingDto$$serializer.INSTANCE, nativeMessagingDto3);
                        i |= 32;
                        break;
                    case 6:
                        sunCoConfigDto2 = (SunCoConfigDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i2, SunCoConfigDto$$serializer.INSTANCE, sunCoConfigDto2);
                        i |= 64;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            sunCoConfigDto = sunCoConfigDto2;
            nativeMessagingDto = nativeMessagingDto3;
            z = zDecodeBooleanElement2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new SettingsDto(i, str, colorThemeDto, colorThemeDto2, bool, z, nativeMessagingDto, sunCoConfigDto, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, SettingsDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        SettingsDto.write$Self$zendesk_zendesk_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
