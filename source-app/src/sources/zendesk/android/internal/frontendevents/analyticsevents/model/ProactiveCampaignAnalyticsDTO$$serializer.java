package zendesk.android.internal.frontendevents.analyticsevents.model;

import cz.msebera.android.httpclient.cookie.ClientCookie;
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

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/android/internal/frontendevents/analyticsevents/model/ProactiveCampaignAnalyticsDTO;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class ProactiveCampaignAnalyticsDTO$$serializer implements GeneratedSerializer<ProactiveCampaignAnalyticsDTO> {
    public static final ProactiveCampaignAnalyticsDTO$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        ProactiveCampaignAnalyticsDTO$$serializer proactiveCampaignAnalyticsDTO$$serializer = new ProactiveCampaignAnalyticsDTO$$serializer();
        INSTANCE = proactiveCampaignAnalyticsDTO$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.android.internal.frontendevents.analyticsevents.model.ProactiveCampaignAnalyticsDTO", proactiveCampaignAnalyticsDTO$$serializer, 5);
        pluginGeneratedSerialDescriptor.addElement("campaignId", false);
        pluginGeneratedSerialDescriptor.addElement("action", false);
        pluginGeneratedSerialDescriptor.addElement("timestamp", false);
        pluginGeneratedSerialDescriptor.addElement(ClientCookie.VERSION_ATTR, false);
        pluginGeneratedSerialDescriptor.addElement("visitorId", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private ProactiveCampaignAnalyticsDTO$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{StringSerializer.INSTANCE, ProactiveCampaignAnalyticsDTO.$childSerializers[1], StringSerializer.INSTANCE, IntSerializer.INSTANCE, StringSerializer.INSTANCE};
    }

    @Override
    public ProactiveCampaignAnalyticsDTO deserialize(Decoder decoder) {
        int iDecodeIntElement;
        int i;
        String str;
        ProactiveCampaignAnalyticsAction proactiveCampaignAnalyticsAction;
        String str2;
        String strDecodeStringElement;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = ProactiveCampaignAnalyticsDTO.$childSerializers;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            ProactiveCampaignAnalyticsAction proactiveCampaignAnalyticsAction2 = (ProactiveCampaignAnalyticsAction) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, kSerializerArr[1], null);
            String strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
            proactiveCampaignAnalyticsAction = proactiveCampaignAnalyticsAction2;
            str = strDecodeStringElement2;
            iDecodeIntElement = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 3);
            strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
            str2 = strDecodeStringElement3;
            i = 31;
        } else {
            boolean z = true;
            int iDecodeIntElement2 = 0;
            String strDecodeStringElement4 = null;
            ProactiveCampaignAnalyticsAction proactiveCampaignAnalyticsAction3 = null;
            String strDecodeStringElement5 = null;
            String strDecodeStringElement6 = null;
            int i2 = 0;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                if (iDecodeElementIndex == -1) {
                    z = false;
                } else if (iDecodeElementIndex == 0) {
                    strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                    i2 |= 1;
                } else if (iDecodeElementIndex == 1) {
                    proactiveCampaignAnalyticsAction3 = (ProactiveCampaignAnalyticsAction) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 1, kSerializerArr[1], proactiveCampaignAnalyticsAction3);
                    i2 |= 2;
                } else if (iDecodeElementIndex == 2) {
                    strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
                    i2 |= 4;
                } else if (iDecodeElementIndex == 3) {
                    iDecodeIntElement2 = compositeDecoderBeginStructure.decodeIntElement(descriptor2, 3);
                    i2 |= 8;
                } else {
                    if (iDecodeElementIndex != 4) {
                        throw new UnknownFieldException(iDecodeElementIndex);
                    }
                    strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
                    i2 |= 16;
                }
            }
            iDecodeIntElement = iDecodeIntElement2;
            i = i2;
            str = strDecodeStringElement4;
            proactiveCampaignAnalyticsAction = proactiveCampaignAnalyticsAction3;
            str2 = strDecodeStringElement5;
            strDecodeStringElement = strDecodeStringElement6;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new ProactiveCampaignAnalyticsDTO(i, str, proactiveCampaignAnalyticsAction, str2, iDecodeIntElement, strDecodeStringElement, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, ProactiveCampaignAnalyticsDTO value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        ProactiveCampaignAnalyticsDTO.write$Self$zendesk_zendesk_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
