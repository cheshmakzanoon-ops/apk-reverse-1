package zendesk.android.settings.internal.model;

import cz.msebera.android.httpclient.util.LangUtils;
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
import kotlinx.serialization.internal.StringSerializer;
import net.aihelp.data.model.rpa.msg.base.Message;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/android/settings/internal/model/ColorThemeDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/android/settings/internal/model/ColorThemeDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class ColorThemeDto$$serializer implements GeneratedSerializer<ColorThemeDto> {
    public static final ColorThemeDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        ColorThemeDto$$serializer colorThemeDto$$serializer = new ColorThemeDto$$serializer();
        INSTANCE = colorThemeDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.android.settings.internal.model.ColorThemeDto", colorThemeDto$$serializer, 19);
        pluginGeneratedSerialDescriptor.addElement("primary_color", false);
        pluginGeneratedSerialDescriptor.addElement("on_primary_color", false);
        pluginGeneratedSerialDescriptor.addElement("message_color", false);
        pluginGeneratedSerialDescriptor.addElement("on_message_color", false);
        pluginGeneratedSerialDescriptor.addElement("action_color", false);
        pluginGeneratedSerialDescriptor.addElement("on_action_color", false);
        pluginGeneratedSerialDescriptor.addElement("inbound_message_color", false);
        pluginGeneratedSerialDescriptor.addElement("system_message_color", false);
        pluginGeneratedSerialDescriptor.addElement("background_color", false);
        pluginGeneratedSerialDescriptor.addElement("on_background_color", false);
        pluginGeneratedSerialDescriptor.addElement("elevated_color", false);
        pluginGeneratedSerialDescriptor.addElement("notify_color", false);
        pluginGeneratedSerialDescriptor.addElement("success_color", false);
        pluginGeneratedSerialDescriptor.addElement("danger_color", false);
        pluginGeneratedSerialDescriptor.addElement("on_danger_color", false);
        pluginGeneratedSerialDescriptor.addElement("disabled_color", false);
        pluginGeneratedSerialDescriptor.addElement("icon_color", false);
        pluginGeneratedSerialDescriptor.addElement("action_background_color", false);
        pluginGeneratedSerialDescriptor.addElement("on_action_background_color", false);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private ColorThemeDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE, StringSerializer.INSTANCE};
    }

    @Override
    public ColorThemeDto deserialize(Decoder decoder) {
        int i;
        String str;
        String str2;
        String str3;
        String str4;
        String str5;
        String str6;
        String strDecodeStringElement;
        String str7;
        String str8;
        String str9;
        String str10;
        String str11;
        String str12;
        String strDecodeStringElement2;
        String strDecodeStringElement3;
        String str13;
        String str14;
        String str15;
        String str16;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        int i2 = 4;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement4 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            String strDecodeStringElement5 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
            String strDecodeStringElement6 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
            String strDecodeStringElement7 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
            String strDecodeStringElement8 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 4);
            strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 5);
            String strDecodeStringElement9 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 6);
            String strDecodeStringElement10 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 7);
            String strDecodeStringElement11 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 8);
            String strDecodeStringElement12 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 9);
            String strDecodeStringElement13 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 10);
            String strDecodeStringElement14 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 11);
            String strDecodeStringElement15 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 12);
            String strDecodeStringElement16 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 13);
            String strDecodeStringElement17 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 14);
            String strDecodeStringElement18 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 15);
            String strDecodeStringElement19 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 16);
            strDecodeStringElement3 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 17);
            strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 18);
            str16 = strDecodeStringElement16;
            str13 = strDecodeStringElement19;
            str14 = strDecodeStringElement18;
            str15 = strDecodeStringElement17;
            str3 = strDecodeStringElement11;
            str9 = strDecodeStringElement13;
            str10 = strDecodeStringElement12;
            str12 = strDecodeStringElement9;
            str2 = strDecodeStringElement8;
            str4 = strDecodeStringElement6;
            str5 = strDecodeStringElement5;
            str7 = strDecodeStringElement15;
            i = 524287;
            str8 = strDecodeStringElement14;
            str = strDecodeStringElement4;
            str11 = strDecodeStringElement10;
            str6 = strDecodeStringElement7;
        } else {
            int i3 = 0;
            int i4 = 18;
            String strDecodeStringElement20 = null;
            boolean z = true;
            String strDecodeStringElement21 = null;
            String strDecodeStringElement22 = null;
            String strDecodeStringElement23 = null;
            String strDecodeStringElement24 = null;
            String strDecodeStringElement25 = null;
            String strDecodeStringElement26 = null;
            String strDecodeStringElement27 = null;
            String strDecodeStringElement28 = null;
            String strDecodeStringElement29 = null;
            String strDecodeStringElement30 = null;
            String strDecodeStringElement31 = null;
            String strDecodeStringElement32 = null;
            String strDecodeStringElement33 = null;
            String strDecodeStringElement34 = null;
            String strDecodeStringElement35 = null;
            String strDecodeStringElement36 = null;
            String strDecodeStringElement37 = null;
            String strDecodeStringElement38 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        i2 = 4;
                        i4 = 18;
                        break;
                    case 0:
                        strDecodeStringElement20 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        i3 |= 1;
                        i2 = 4;
                        i4 = 18;
                        break;
                    case 1:
                        strDecodeStringElement28 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 1);
                        i3 |= 2;
                        i2 = 4;
                        i4 = 18;
                        break;
                    case 2:
                        strDecodeStringElement27 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 2);
                        i3 |= 4;
                        i4 = 18;
                        break;
                    case 3:
                        strDecodeStringElement29 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 3);
                        i3 |= 8;
                        i4 = 18;
                        break;
                    case 4:
                        strDecodeStringElement25 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, i2);
                        i3 |= 16;
                        i4 = 18;
                        break;
                    case 5:
                        strDecodeStringElement37 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 5);
                        i3 |= 32;
                        i4 = 18;
                        break;
                    case 6:
                        strDecodeStringElement36 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 6);
                        i3 |= 64;
                        i4 = 18;
                        break;
                    case 7:
                        strDecodeStringElement35 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 7);
                        i3 |= 128;
                        i4 = 18;
                        break;
                    case 8:
                        strDecodeStringElement26 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 8);
                        i3 |= 256;
                        i4 = 18;
                        break;
                    case 9:
                        strDecodeStringElement34 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 9);
                        i3 |= 512;
                        i4 = 18;
                        break;
                    case 10:
                        strDecodeStringElement33 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 10);
                        i3 |= 1024;
                        i4 = 18;
                        break;
                    case 11:
                        strDecodeStringElement32 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 11);
                        i3 |= 2048;
                        i4 = 18;
                        break;
                    case Message.TYPE_USER_VIDEO:
                        strDecodeStringElement31 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 12);
                        i3 |= 4096;
                        i4 = 18;
                        break;
                    case 13:
                        strDecodeStringElement38 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 13);
                        i3 |= 8192;
                        i4 = 18;
                        break;
                    case Message.TYPE_USER_FILE:
                        strDecodeStringElement21 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 14);
                        i3 |= 16384;
                        i4 = 18;
                        break;
                    case WebSocketProtocol.B0_MASK_OPCODE:
                        strDecodeStringElement22 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 15);
                        i3 |= 32768;
                        i4 = 18;
                        break;
                    case 16:
                        strDecodeStringElement23 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 16);
                        i3 |= 65536;
                        i4 = 18;
                        break;
                    case LangUtils.HASH_SEED:
                        strDecodeStringElement24 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 17);
                        i3 |= 131072;
                        break;
                    case 18:
                        strDecodeStringElement30 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, i4);
                        i3 |= 262144;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            i = i3;
            str = strDecodeStringElement20;
            str2 = strDecodeStringElement25;
            str3 = strDecodeStringElement26;
            str4 = strDecodeStringElement27;
            str5 = strDecodeStringElement28;
            str6 = strDecodeStringElement29;
            strDecodeStringElement = strDecodeStringElement30;
            str7 = strDecodeStringElement31;
            str8 = strDecodeStringElement32;
            str9 = strDecodeStringElement33;
            str10 = strDecodeStringElement34;
            str11 = strDecodeStringElement35;
            str12 = strDecodeStringElement36;
            strDecodeStringElement2 = strDecodeStringElement37;
            strDecodeStringElement3 = strDecodeStringElement24;
            str13 = strDecodeStringElement23;
            str14 = strDecodeStringElement22;
            str15 = strDecodeStringElement21;
            str16 = strDecodeStringElement38;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new ColorThemeDto(i, str, str5, str4, str6, str2, strDecodeStringElement2, str12, str11, str3, str10, str9, str8, str7, str16, str15, str14, str13, strDecodeStringElement3, strDecodeStringElement, null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, ColorThemeDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        ColorThemeDto.write$Self$zendesk_zendesk_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
