package zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt;

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

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/android/internal/proactivemessaging/campaigntriggerservice/model/jwt/ProactiveMessage.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/jwt/ProactiveMessage;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class ProactiveMessage$$serializer implements GeneratedSerializer<ProactiveMessage> {
    public static final ProactiveMessage$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        ProactiveMessage$$serializer proactiveMessage$$serializer = new ProactiveMessage$$serializer();
        INSTANCE = proactiveMessage$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt.ProactiveMessage", proactiveMessage$$serializer, 2);
        pluginGeneratedSerialDescriptor.addElement("author", false);
        pluginGeneratedSerialDescriptor.addElement("content", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private ProactiveMessage$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{ProactiveMessageAuthor$$serializer.INSTANCE, ProactiveMessageContent$$serializer.INSTANCE};
    }

    @Override
    public ProactiveMessage deserialize(Decoder decoder) {
        ProactiveMessageAuthor proactiveMessageAuthor;
        ProactiveMessageContent proactiveMessageContent;
        int i;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            proactiveMessageAuthor = (ProactiveMessageAuthor) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, ProactiveMessageAuthor$$serializer.INSTANCE, null);
            proactiveMessageContent = (ProactiveMessageContent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, ProactiveMessageContent$$serializer.INSTANCE, null);
            i = 3;
        } else {
            boolean z = true;
            int i2 = 0;
            proactiveMessageAuthor = null;
            ProactiveMessageContent proactiveMessageContent2 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                if (iDecodeElementIndex == -1) {
                    z = false;
                } else if (iDecodeElementIndex == 0) {
                    proactiveMessageAuthor = (ProactiveMessageAuthor) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 0, ProactiveMessageAuthor$$serializer.INSTANCE, proactiveMessageAuthor);
                    i2 |= 1;
                } else {
                    if (iDecodeElementIndex != 1) {
                        throw new UnknownFieldException(iDecodeElementIndex);
                    }
                    proactiveMessageContent2 = (ProactiveMessageContent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, ProactiveMessageContent$$serializer.INSTANCE, proactiveMessageContent2);
                    i2 |= 2;
                }
            }
            proactiveMessageContent = proactiveMessageContent2;
            i = i2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new ProactiveMessage(i, proactiveMessageAuthor, proactiveMessageContent, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, ProactiveMessage value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        ProactiveMessage.write$Self$zendesk_zendesk_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
