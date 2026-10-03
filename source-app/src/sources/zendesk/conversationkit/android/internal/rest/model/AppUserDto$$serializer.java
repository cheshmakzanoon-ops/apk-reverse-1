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

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/AppUserDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class AppUserDto$$serializer implements GeneratedSerializer<AppUserDto> {
    public static final AppUserDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        AppUserDto$$serializer appUserDto$$serializer = new AppUserDto$$serializer();
        INSTANCE = appUserDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.AppUserDto", appUserDto$$serializer, 10);
        pluginGeneratedSerialDescriptor.addElement("_id", false);
        pluginGeneratedSerialDescriptor.addElement("userId", false);
        pluginGeneratedSerialDescriptor.addElement("givenName", false);
        pluginGeneratedSerialDescriptor.addElement("surname", false);
        pluginGeneratedSerialDescriptor.addElement("email", false);
        pluginGeneratedSerialDescriptor.addElement("locale", false);
        pluginGeneratedSerialDescriptor.addElement("signedUpAt", false);
        pluginGeneratedSerialDescriptor.addElement("clients", false);
        pluginGeneratedSerialDescriptor.addElement("pendingClients", false);
        pluginGeneratedSerialDescriptor.addElement("properties", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private AppUserDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = AppUserDto.$childSerializers;
        return new KSerializer[]{StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), kSerializerArr[7], kSerializerArr[8], kSerializerArr[9]};
    }

    @Override
    public AppUserDto deserialize(Decoder decoder) {
        String str;
        List list;
        List list2;
        String str2;
        String str3;
        String str4;
        Map map;
        String str5;
        String str6;
        int i;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = AppUserDto.$childSerializers;
        int i2 = 9;
        String strDecodeStringElement = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            String str7 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, null);
            String str8 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, null);
            String str9 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            String str10 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, null);
            String str11 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, null);
            String str12 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, null);
            List list3 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 7, kSerializerArr[7], null);
            List list4 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 8, kSerializerArr[8], null);
            map = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 9, kSerializerArr[9], null);
            strDecodeStringElement = strDecodeStringElement2;
            str3 = str12;
            str2 = str11;
            str5 = str9;
            str4 = str10;
            str6 = str8;
            i = 1023;
            list2 = list3;
            list = list4;
            str = str7;
        } else {
            boolean z = true;
            int i3 = 0;
            List list5 = null;
            List list6 = null;
            String str13 = null;
            String str14 = null;
            String str15 = null;
            Map map2 = null;
            String str16 = null;
            String str17 = null;
            str = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        break;
                    case 0:
                        strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i3 |= 1;
                        i2 = 9;
                        break;
                    case 1:
                        str = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, str);
                        i3 |= 2;
                        i2 = 9;
                        break;
                    case 2:
                        str17 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, str17);
                        i3 |= 4;
                        i2 = 9;
                        break;
                    case 3:
                        str16 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, str16);
                        i3 |= 8;
                        i2 = 9;
                        break;
                    case 4:
                        str15 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, str15);
                        i3 |= 16;
                        i2 = 9;
                        break;
                    case 5:
                        str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, str13);
                        i3 |= 32;
                        i2 = 9;
                        break;
                    case 6:
                        str14 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, str14);
                        i3 |= 64;
                        i2 = 9;
                        break;
                    case 7:
                        list6 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 7, kSerializerArr[7], list6);
                        i3 |= 128;
                        i2 = 9;
                        break;
                    case 8:
                        list5 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 8, kSerializerArr[8], list5);
                        i3 |= 256;
                        i2 = 9;
                        break;
                    case 9:
                        map2 = (Map) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, i2, kSerializerArr[i2], map2);
                        i3 |= 512;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            list = list5;
            list2 = list6;
            str2 = str13;
            str3 = str14;
            str4 = str15;
            map = map2;
            str5 = str16;
            str6 = str17;
            i = i3;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new AppUserDto(i, strDecodeStringElement, str, str6, str5, str4, str2, str3, list2, list, map, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, AppUserDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        AppUserDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
