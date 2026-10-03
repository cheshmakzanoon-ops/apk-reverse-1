package zendesk.android.internal.proactivemessaging.model;

import cz.msebera.android.httpclient.cookie.ClientCookie;
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

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/android/internal/proactivemessaging/model/Campaign.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/android/internal/proactivemessaging/model/Campaign;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class Campaign$$serializer implements GeneratedSerializer<Campaign> {
    public static final Campaign$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        Campaign$$serializer campaign$$serializer = new Campaign$$serializer();
        INSTANCE = campaign$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.android.internal.proactivemessaging.model.Campaign", campaign$$serializer, 7);
        pluginGeneratedSerialDescriptor.addElement("campaign_id", false);
        pluginGeneratedSerialDescriptor.addElement("integration", false);
        pluginGeneratedSerialDescriptor.addElement("when", false);
        pluginGeneratedSerialDescriptor.addElement("schedule", false);
        pluginGeneratedSerialDescriptor.addElement("status", false);
        pluginGeneratedSerialDescriptor.addElement("paths", false);
        pluginGeneratedSerialDescriptor.addElement(ClientCookie.VERSION_ATTR, false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private Campaign$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{StringSerializer.INSTANCE, Integration$$serializer.INSTANCE, Trigger$$serializer.INSTANCE, Schedule$$serializer.INSTANCE, Status.StatusSerializer.INSTANCE, Campaign.$childSerializers[5], IntSerializer.INSTANCE};
    }

    @Override
    public Campaign deserialize(Decoder decoder) {
        int iDecodeIntElement;
        List list;
        int i;
        Integration integration;
        Schedule schedule;
        Status status;
        String str;
        Trigger trigger;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = Campaign.$childSerializers;
        int i2 = 6;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            Integration integration2 = (Integration) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, Integration$$serializer.INSTANCE, null);
            Trigger trigger2 = (Trigger) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, Trigger$$serializer.INSTANCE, null);
            Schedule schedule2 = (Schedule) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 3, Schedule$$serializer.INSTANCE, null);
            Status status2 = (Status) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, Status.StatusSerializer.INSTANCE, null);
            list = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 5, kSerializerArr[5], null);
            str = strDecodeStringElement;
            iDecodeIntElement = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 6);
            schedule = schedule2;
            status = status2;
            trigger = trigger2;
            integration = integration2;
            i = 127;
        } else {
            boolean z = true;
            int iDecodeIntElement2 = 0;
            List list2 = null;
            String strDecodeStringElement2 = null;
            Integration integration3 = null;
            Trigger trigger3 = null;
            Schedule schedule3 = null;
            Status status3 = null;
            int i3 = 0;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        break;
                    case 0:
                        strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i3 |= 1;
                        i2 = 6;
                        break;
                    case 1:
                        integration3 = (Integration) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, Integration$$serializer.INSTANCE, integration3);
                        i3 |= 2;
                        i2 = 6;
                        break;
                    case 2:
                        trigger3 = (Trigger) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 2, Trigger$$serializer.INSTANCE, trigger3);
                        i3 |= 4;
                        i2 = 6;
                        break;
                    case 3:
                        schedule3 = (Schedule) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 3, Schedule$$serializer.INSTANCE, schedule3);
                        i3 |= 8;
                        break;
                    case 4:
                        status3 = (Status) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, Status.StatusSerializer.INSTANCE, status3);
                        i3 |= 16;
                        break;
                    case 5:
                        list2 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 5, kSerializerArr[5], list2);
                        i3 |= 32;
                        break;
                    case 6:
                        iDecodeIntElement2 = compositeDecoderBeginStructure.decodeIntElement(descriptor2, i2);
                        i3 |= 64;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            iDecodeIntElement = iDecodeIntElement2;
            Schedule schedule4 = schedule3;
            list = list2;
            i = i3;
            integration = integration3;
            schedule = schedule4;
            Trigger trigger4 = trigger3;
            status = status3;
            str = strDecodeStringElement2;
            trigger = trigger4;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new Campaign(i, str, integration, trigger, schedule, status, list, iDecodeIntElement, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, Campaign value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        Campaign.write$Self$zendesk_zendesk_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
