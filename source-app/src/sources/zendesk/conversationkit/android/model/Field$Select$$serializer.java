package zendesk.conversationkit.android.model;

import java.util.List;
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
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/model/Field.Select.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/model/Field$Select;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class Field$Select$$serializer implements GeneratedSerializer<Field.Select> {
    public static final Field$Select$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        Field$Select$$serializer field$Select$$serializer = new Field$Select$$serializer();
        INSTANCE = field$Select$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("select", field$Select$$serializer, 8);
        pluginGeneratedSerialDescriptor.addElement("fieldType", false);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("name", false);
        pluginGeneratedSerialDescriptor.addElement("label", false);
        pluginGeneratedSerialDescriptor.addElement("placeholder", false);
        pluginGeneratedSerialDescriptor.addElement("options", false);
        pluginGeneratedSerialDescriptor.addElement("selectSize", false);
        pluginGeneratedSerialDescriptor.addElement("select", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private Field$Select$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = Field.Select.$childSerializers;
        return new KSerializer[]{kSerializerArr[0], StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, kSerializerArr[5], IntSerializer.INSTANCE, kSerializerArr[7]};
    }

    @Override
    public Field.Select deserialize(Decoder decoder) {
        int i;
        String str;
        List list;
        String str2;
        String str3;
        List list2;
        FieldType fieldType;
        String str4;
        int i2;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = Field.Select.$childSerializers;
        int i3 = 6;
        int i4 = 3;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            FieldType fieldType2 = (FieldType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], null);
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
            String strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
            String strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
            List list3 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 5, kSerializerArr[5], null);
            int iDecodeIntElement = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 6);
            list2 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 7, kSerializerArr[7], null);
            i2 = iDecodeIntElement;
            str4 = strDecodeStringElement3;
            str3 = strDecodeStringElement4;
            str = strDecodeStringElement2;
            list = list3;
            str2 = strDecodeStringElement;
            fieldType = fieldType2;
            i = 255;
        } else {
            boolean z = true;
            int iDecodeIntElement2 = 0;
            List list4 = null;
            FieldType fieldType3 = null;
            String strDecodeStringElement5 = null;
            String strDecodeStringElement6 = null;
            String strDecodeStringElement7 = null;
            String strDecodeStringElement8 = null;
            List list5 = null;
            int i5 = 0;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        i3 = 6;
                        continue;
                    case 0:
                        fieldType3 = (FieldType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], fieldType3);
                        i5 |= 1;
                        i3 = 6;
                        i4 = 3;
                        continue;
                    case 1:
                        i5 |= 2;
                        strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        continue;
                    case 2:
                        strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
                        i5 |= 4;
                        continue;
                    case 3:
                        strDecodeStringElement7 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, i4);
                        i5 |= 8;
                        break;
                    case 4:
                        strDecodeStringElement8 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
                        i5 |= 16;
                        break;
                    case 5:
                        list5 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 5, kSerializerArr[5], list5);
                        i5 |= 32;
                        break;
                    case 6:
                        iDecodeIntElement2 = compositeDecoderBeginStructure.decodeIntElement(descriptor2, i3);
                        i5 |= 64;
                        break;
                    case 7:
                        list4 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 7, kSerializerArr[7], list4);
                        i5 |= 128;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            i = i5;
            str = strDecodeStringElement6;
            list = list5;
            str2 = strDecodeStringElement5;
            str3 = strDecodeStringElement8;
            list2 = list4;
            fieldType = fieldType3;
            str4 = strDecodeStringElement7;
            i2 = iDecodeIntElement2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new Field.Select(i, fieldType, str2, str, str4, str3, list, i2, list2, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, Field.Select value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        Field.Select.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
