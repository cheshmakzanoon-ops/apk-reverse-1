package zendesk.conversationkit.android.model;

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

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/model/Field.Text.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/model/Field$Text;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class Field$Text$$serializer implements GeneratedSerializer<Field.Text> {
    public static final Field$Text$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        Field$Text$$serializer field$Text$$serializer = new Field$Text$$serializer();
        INSTANCE = field$Text$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("text", field$Text$$serializer, 8);
        pluginGeneratedSerialDescriptor.addElement("fieldType", false);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("name", false);
        pluginGeneratedSerialDescriptor.addElement("label", false);
        pluginGeneratedSerialDescriptor.addElement("placeholder", false);
        pluginGeneratedSerialDescriptor.addElement("minSize", false);
        pluginGeneratedSerialDescriptor.addElement("maxSize", false);
        pluginGeneratedSerialDescriptor.addElement("text", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private Field$Text$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{Field.Text.$childSerializers[0], StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, IntSerializer.INSTANCE, IntSerializer.INSTANCE, StringSerializer.INSTANCE};
    }

    @Override
    public Field.Text deserialize(Decoder decoder) {
        int i;
        FieldType fieldType;
        String strDecodeStringElement;
        String strDecodeStringElement2;
        String strDecodeStringElement3;
        String strDecodeStringElement4;
        int i2;
        String strDecodeStringElement5;
        int i3;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = Field.Text.$childSerializers;
        int i4 = 7;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            FieldType fieldType2 = (FieldType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], null);
            String strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            String strDecodeStringElement7 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
            String strDecodeStringElement8 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
            String strDecodeStringElement9 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
            int iDecodeIntElement = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 5);
            int iDecodeIntElement2 = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 6);
            fieldType = fieldType2;
            strDecodeStringElement = strDecodeStringElement6;
            strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 7);
            i2 = iDecodeIntElement2;
            i3 = iDecodeIntElement;
            strDecodeStringElement3 = strDecodeStringElement8;
            strDecodeStringElement4 = strDecodeStringElement9;
            strDecodeStringElement2 = strDecodeStringElement7;
            i = 255;
        } else {
            boolean z = true;
            int iDecodeIntElement3 = 0;
            i = 0;
            fieldType = null;
            strDecodeStringElement = null;
            strDecodeStringElement2 = null;
            strDecodeStringElement3 = null;
            strDecodeStringElement4 = null;
            String strDecodeStringElement10 = null;
            int iDecodeIntElement4 = 0;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        continue;
                    case 0:
                        fieldType = (FieldType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, kSerializerArr[0], fieldType);
                        i |= 1;
                        i4 = 7;
                        continue;
                    case 1:
                        strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        i |= 2;
                        break;
                    case 2:
                        strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
                        i |= 4;
                        break;
                    case 3:
                        strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
                        i |= 8;
                        break;
                    case 4:
                        strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
                        i |= 16;
                        break;
                    case 5:
                        iDecodeIntElement4 = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 5);
                        i |= 32;
                        break;
                    case 6:
                        iDecodeIntElement3 = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 6);
                        i |= 64;
                        break;
                    case 7:
                        strDecodeStringElement10 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, i4);
                        i |= 128;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            i2 = iDecodeIntElement3;
            strDecodeStringElement5 = strDecodeStringElement10;
            i3 = iDecodeIntElement4;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new Field.Text(i, fieldType, strDecodeStringElement, strDecodeStringElement2, strDecodeStringElement3, strDecodeStringElement4, i3, i2, strDecodeStringElement5, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, Field.Text value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        Field.Text.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
