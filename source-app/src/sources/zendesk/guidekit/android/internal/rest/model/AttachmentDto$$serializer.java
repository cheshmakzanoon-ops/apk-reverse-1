package zendesk.guidekit.android.internal.rest.model;

import j$.time.LocalDateTime;
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
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/guidekit/android/internal/rest/model/AttachmentDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/guidekit/android/internal/rest/model/AttachmentDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class AttachmentDto$$serializer implements GeneratedSerializer<AttachmentDto> {
    public static final AttachmentDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        AttachmentDto$$serializer attachmentDto$$serializer = new AttachmentDto$$serializer();
        INSTANCE = attachmentDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.guidekit.android.internal.rest.model.AttachmentDto", attachmentDto$$serializer, 12);
        pluginGeneratedSerialDescriptor.addElement("article_id", false);
        pluginGeneratedSerialDescriptor.addElement("content_type", true);
        pluginGeneratedSerialDescriptor.addElement("content_url", true);
        pluginGeneratedSerialDescriptor.addElement("created_at", true);
        pluginGeneratedSerialDescriptor.addElement("display_file_name", true);
        pluginGeneratedSerialDescriptor.addElement("file_name", true);
        pluginGeneratedSerialDescriptor.addElement("relative_path", true);
        pluginGeneratedSerialDescriptor.addElement("updated_at", true);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("inline", true);
        pluginGeneratedSerialDescriptor.addElement("size", true);
        pluginGeneratedSerialDescriptor.addElement("url", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private AttachmentDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer[] kSerializerArr = AttachmentDto.$childSerializers;
        return new KSerializer[]{LongSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[3]), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[7]), LongSerializer.INSTANCE, BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), BuiltinSerializersKt.getNullable(LongSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE)};
    }

    @Override
    public AttachmentDto deserialize(Decoder decoder) {
        Boolean bool;
        LocalDateTime localDateTime;
        String str;
        Long l;
        LocalDateTime localDateTime2;
        long j;
        long jDecodeLongElement;
        int i;
        String str2;
        String str3;
        String str4;
        String str5;
        String str6;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = AttachmentDto.$childSerializers;
        String str7 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            long jDecodeLongElement2 = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 0);
            String str8 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, null);
            str4 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, null);
            LocalDateTime localDateTime3 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, kSerializerArr[3], null);
            String str9 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, null);
            String str10 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, null);
            String str11 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, null);
            LocalDateTime localDateTime4 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, kSerializerArr[7], null);
            jDecodeLongElement = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 8);
            Boolean bool2 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, BooleanSerializer.INSTANCE, null);
            Long l2 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, LongSerializer.INSTANCE, null);
            str = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, null);
            l = l2;
            bool = bool2;
            str2 = str10;
            localDateTime2 = localDateTime3;
            str3 = str9;
            str6 = str8;
            localDateTime = localDateTime4;
            str5 = str11;
            i = 4095;
            j = jDecodeLongElement2;
        } else {
            int i2 = 11;
            Boolean bool3 = null;
            LocalDateTime localDateTime5 = null;
            String str12 = null;
            String str13 = null;
            String str14 = null;
            Long l3 = null;
            String str15 = null;
            boolean z = true;
            int i3 = 0;
            long jDecodeLongElement3 = 0;
            long jDecodeLongElement4 = 0;
            LocalDateTime localDateTime6 = null;
            String str16 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        i2 = 11;
                        break;
                    case 0:
                        jDecodeLongElement3 = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 0);
                        i3 |= 1;
                        kSerializerArr = kSerializerArr;
                        i2 = 11;
                        break;
                    case 1:
                        str7 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, str7);
                        i3 |= 2;
                        kSerializerArr = kSerializerArr;
                        i2 = 11;
                        break;
                    case 2:
                        str16 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, str16);
                        i3 |= 4;
                        kSerializerArr = kSerializerArr;
                        i2 = 11;
                        break;
                    case 3:
                        localDateTime6 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, kSerializerArr[3], localDateTime6);
                        i3 |= 8;
                        i2 = 11;
                        break;
                    case 4:
                        str14 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, str14);
                        i3 |= 16;
                        i2 = 11;
                        break;
                    case 5:
                        str15 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, str15);
                        i3 |= 32;
                        i2 = 11;
                        break;
                    case 6:
                        str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, str13);
                        i3 |= 64;
                        i2 = 11;
                        break;
                    case 7:
                        localDateTime5 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, kSerializerArr[7], localDateTime5);
                        i3 |= 128;
                        i2 = 11;
                        break;
                    case 8:
                        jDecodeLongElement4 = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 8);
                        i3 |= 256;
                        i2 = 11;
                        break;
                    case 9:
                        bool3 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, BooleanSerializer.INSTANCE, bool3);
                        i3 |= 512;
                        i2 = 11;
                        break;
                    case 10:
                        l3 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, LongSerializer.INSTANCE, l3);
                        i3 |= 1024;
                        i2 = 11;
                        break;
                    case 11:
                        str12 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, i2, StringSerializer.INSTANCE, str12);
                        i3 |= 2048;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            bool = bool3;
            localDateTime = localDateTime5;
            str = str12;
            l = l3;
            localDateTime2 = localDateTime6;
            j = jDecodeLongElement3;
            jDecodeLongElement = jDecodeLongElement4;
            i = i3;
            str2 = str15;
            str3 = str14;
            str4 = str16;
            str5 = str13;
            str6 = str7;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new AttachmentDto(i, j, str6, str4, localDateTime2, str3, str2, str5, localDateTime, jDecodeLongElement, bool, l, str, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, AttachmentDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        AttachmentDto.write$Self$zendesk_guidekit_guidekit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
