package zendesk.conversationkit.android.model;

import java.util.concurrent.TimeUnit;
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
import kotlinx.serialization.internal.BooleanSerializer;
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/model/RealtimeSettings.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/model/RealtimeSettings;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class RealtimeSettings$$serializer implements GeneratedSerializer<RealtimeSettings> {
    public static final RealtimeSettings$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        RealtimeSettings$$serializer realtimeSettings$$serializer = new RealtimeSettings$$serializer();
        INSTANCE = realtimeSettings$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.model.RealtimeSettings", realtimeSettings$$serializer, 8);
        pluginGeneratedSerialDescriptor.addElement("enabled", false);
        pluginGeneratedSerialDescriptor.addElement("baseUrl", false);
        pluginGeneratedSerialDescriptor.addElement("retryInterval", false);
        pluginGeneratedSerialDescriptor.addElement("maxConnectionAttempts", false);
        pluginGeneratedSerialDescriptor.addElement("connectionDelay", false);
        pluginGeneratedSerialDescriptor.addElement("timeUnit", true);
        pluginGeneratedSerialDescriptor.addElement("appId", false);
        pluginGeneratedSerialDescriptor.addElement("userId", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private RealtimeSettings$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{BooleanSerializer.INSTANCE, StringSerializer.INSTANCE, LongSerializer.INSTANCE, IntSerializer.INSTANCE, LongSerializer.INSTANCE, RealtimeSettings.$childSerializers[5], StringSerializer.INSTANCE, StringSerializer.INSTANCE};
    }

    @Override
    public RealtimeSettings deserialize(Decoder decoder) {
        String str;
        String strDecodeStringElement;
        int i;
        int i2;
        boolean z;
        String str2;
        long j;
        TimeUnit timeUnit;
        long j2;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = RealtimeSettings.$childSerializers;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            boolean zDecodeBooleanElement = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 0);
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            long jDecodeLongElement = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 2);
            int iDecodeIntElement = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 3);
            long jDecodeLongElement2 = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 4);
            TimeUnit timeUnit2 = (TimeUnit) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 5, kSerializerArr[5], null);
            String strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 6);
            timeUnit = timeUnit2;
            strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 7);
            str = strDecodeStringElement3;
            i = iDecodeIntElement;
            j2 = jDecodeLongElement2;
            i2 = 255;
            j = jDecodeLongElement;
            z = zDecodeBooleanElement;
            str2 = strDecodeStringElement2;
        } else {
            long jDecodeLongElement3 = 0;
            boolean z2 = true;
            boolean zDecodeBooleanElement2 = false;
            int i3 = 0;
            String strDecodeStringElement4 = null;
            String strDecodeStringElement5 = null;
            String strDecodeStringElement6 = null;
            long jDecodeLongElement4 = 0;
            TimeUnit timeUnit3 = null;
            int iDecodeIntElement2 = 0;
            while (z2) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z2 = false;
                        break;
                    case 0:
                        i3 |= 1;
                        zDecodeBooleanElement2 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 0);
                        continue;
                    case 1:
                        strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        i3 |= 2;
                        continue;
                    case 2:
                        jDecodeLongElement4 = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 2);
                        i3 |= 4;
                        break;
                    case 3:
                        iDecodeIntElement2 = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 3);
                        i3 |= 8;
                        break;
                    case 4:
                        jDecodeLongElement3 = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 4);
                        i3 |= 16;
                        break;
                    case 5:
                        timeUnit3 = (TimeUnit) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 5, kSerializerArr[5], timeUnit3);
                        i3 |= 32;
                        break;
                    case 6:
                        strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 6);
                        i3 |= 64;
                        break;
                    case 7:
                        strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 7);
                        i3 |= 128;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            str = strDecodeStringElement5;
            strDecodeStringElement = strDecodeStringElement6;
            i = iDecodeIntElement2;
            i2 = i3;
            long j3 = jDecodeLongElement3;
            z = zDecodeBooleanElement2;
            str2 = strDecodeStringElement4;
            j = jDecodeLongElement4;
            timeUnit = timeUnit3;
            j2 = j3;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new RealtimeSettings(i2, z, str2, j, i, j2, timeUnit, str, strDecodeStringElement, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, RealtimeSettings value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        RealtimeSettings.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
