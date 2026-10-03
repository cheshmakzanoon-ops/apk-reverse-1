package zendesk.android.internal.proactivemessaging.model;

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
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/android/internal/proactivemessaging/model/Condition.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Condition;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class Condition$$serializer implements GeneratedSerializer<Condition> {
    public static final Condition$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        Condition$$serializer condition$$serializer = new Condition$$serializer();
        INSTANCE = condition$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.android.internal.proactivemessaging.model.Condition", condition$$serializer, 3);
        pluginGeneratedSerialDescriptor.addElement("type", false);
        pluginGeneratedSerialDescriptor.addElement("function", false);
        pluginGeneratedSerialDescriptor.addElement("args", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private Condition$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{ConditionType.ConditionTypeSerializer.INSTANCE, ConditionFunction.ConditionFunctionSerializer.INSTANCE, Condition.$childSerializers[2]};
    }

    @Override
    public Condition deserialize(Decoder decoder) {
        int i;
        ConditionType conditionType;
        ConditionFunction conditionFunction;
        List list;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = Condition.$childSerializers;
        ConditionType conditionType2 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            ConditionType conditionType3 = (ConditionType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, ConditionType.ConditionTypeSerializer.INSTANCE, null);
            ConditionFunction conditionFunction2 = (ConditionFunction) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, ConditionFunction.ConditionFunctionSerializer.INSTANCE, null);
            list = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, kSerializerArr[2], null);
            conditionType = conditionType3;
            i = 7;
            conditionFunction = conditionFunction2;
        } else {
            boolean z = true;
            int i2 = 0;
            ConditionFunction conditionFunction3 = null;
            List list2 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                if (iDecodeElementIndex == -1) {
                    z = false;
                } else if (iDecodeElementIndex == 0) {
                    conditionType2 = (ConditionType) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, ConditionType.ConditionTypeSerializer.INSTANCE, conditionType2);
                    i2 |= 1;
                } else if (iDecodeElementIndex == 1) {
                    conditionFunction3 = (ConditionFunction) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, ConditionFunction.ConditionFunctionSerializer.INSTANCE, conditionFunction3);
                    i2 |= 2;
                } else {
                    if (iDecodeElementIndex != 2) {
                        throw new UnknownFieldException(iDecodeElementIndex);
                    }
                    list2 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, kSerializerArr[2], list2);
                    i2 |= 4;
                }
            }
            i = i2;
            conditionType = conditionType2;
            conditionFunction = conditionFunction3;
            list = list2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new Condition(i, conditionType, conditionFunction, list, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, Condition value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        Condition.write$Self$zendesk_zendesk_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
