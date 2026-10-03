package zendesk.guidekit.android.internal.rest.model;

import cz.msebera.android.httpclient.extras.Base64;
import cz.msebera.android.httpclient.util.LangUtils;
import j$.time.LocalDateTime;
import java.util.List;
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
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import net.aihelp.common.IntentValues;
import net.aihelp.data.model.rpa.msg.base.Message;
import okhttp3.internal.p011ws.WebSocketProtocol;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/guidekit/android/internal/rest/model/ArticleDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/guidekit/android/internal/rest/model/ArticleDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.guidekit_guidekit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class ArticleDto$$serializer implements GeneratedSerializer<ArticleDto> {
    public static final ArticleDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        ArticleDto$$serializer articleDto$$serializer = new ArticleDto$$serializer();
        INSTANCE = articleDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.guidekit.android.internal.rest.model.ArticleDto", articleDto$$serializer, 20);
        pluginGeneratedSerialDescriptor.addElement("author_id", true);
        pluginGeneratedSerialDescriptor.addElement("comments_disabled", true);
        pluginGeneratedSerialDescriptor.addElement("created_at", true);
        pluginGeneratedSerialDescriptor.addElement("html_url", true);
        pluginGeneratedSerialDescriptor.addElement("label_names", true);
        pluginGeneratedSerialDescriptor.addElement(IntentValues.SECTION_ID, true);
        pluginGeneratedSerialDescriptor.addElement("source_locale", true);
        pluginGeneratedSerialDescriptor.addElement("updated_at", true);
        pluginGeneratedSerialDescriptor.addElement("vote_count", true);
        pluginGeneratedSerialDescriptor.addElement("vote_sum", true);
        pluginGeneratedSerialDescriptor.addElement("body", true);
        pluginGeneratedSerialDescriptor.addElement("draft", true);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("locale", false);
        pluginGeneratedSerialDescriptor.addElement("name", true);
        pluginGeneratedSerialDescriptor.addElement("outdated", true);
        pluginGeneratedSerialDescriptor.addElement("position", true);
        pluginGeneratedSerialDescriptor.addElement("promoted", true);
        pluginGeneratedSerialDescriptor.addElement("title", true);
        pluginGeneratedSerialDescriptor.addElement("url", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private ArticleDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer[] kSerializerArr = ArticleDto.$childSerializers;
        return new KSerializer[]{BuiltinSerializersKt.getNullable(LongSerializer.INSTANCE), BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[2]), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[4]), BuiltinSerializersKt.getNullable(LongSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[7]), BuiltinSerializersKt.getNullable(IntSerializer.INSTANCE), BuiltinSerializersKt.getNullable(IntSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), LongSerializer.INSTANCE, StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), BuiltinSerializersKt.getNullable(IntSerializer.INSTANCE), BuiltinSerializersKt.getNullable(BooleanSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE)};
    }

    @Override
    public ArticleDto deserialize(Decoder decoder) {
        Integer num;
        String str;
        String str2;
        String str3;
        Boolean bool;
        Integer num2;
        Boolean bool2;
        String str4;
        String str5;
        long j;
        Long l;
        List list;
        Integer num3;
        Long l2;
        String str6;
        LocalDateTime localDateTime;
        String str7;
        Boolean bool3;
        LocalDateTime localDateTime2;
        Boolean bool4;
        int i;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = ArticleDto.$childSerializers;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            Long l3 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 0, LongSerializer.INSTANCE, null);
            Boolean bool5 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, BooleanSerializer.INSTANCE, null);
            LocalDateTime localDateTime3 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, kSerializerArr[2], null);
            String str8 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            List list2 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, kSerializerArr[4], null);
            Long l4 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, LongSerializer.INSTANCE, null);
            String str9 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, null);
            LocalDateTime localDateTime4 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, kSerializerArr[7], null);
            Integer num4 = (Integer) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, IntSerializer.INSTANCE, null);
            Integer num5 = (Integer) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, IntSerializer.INSTANCE, null);
            String str10 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, null);
            Boolean bool6 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, BooleanSerializer.INSTANCE, null);
            long jDecodeLongElement = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 12);
            String strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 13);
            String str11 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 14, StringSerializer.INSTANCE, null);
            Boolean bool7 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 15, BooleanSerializer.INSTANCE, null);
            Integer num6 = (Integer) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 16, IntSerializer.INSTANCE, null);
            Boolean bool8 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 17, BooleanSerializer.INSTANCE, null);
            str3 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 18, StringSerializer.INSTANCE, null);
            str2 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 19, StringSerializer.INSTANCE, null);
            str5 = strDecodeStringElement;
            bool = bool8;
            num2 = num6;
            bool2 = bool7;
            str4 = str11;
            j = jDecodeLongElement;
            localDateTime = localDateTime4;
            num3 = num5;
            list = list2;
            localDateTime2 = localDateTime3;
            str = str10;
            bool4 = bool6;
            str7 = str9;
            l2 = l4;
            l = l3;
            str6 = str8;
            num = num4;
            bool3 = bool5;
            i = 1048575;
        } else {
            boolean z = true;
            List list3 = null;
            Integer num7 = null;
            Integer num8 = null;
            Long l5 = null;
            String str12 = null;
            LocalDateTime localDateTime5 = null;
            Boolean bool9 = null;
            String str13 = null;
            LocalDateTime localDateTime6 = null;
            String str14 = null;
            Long l6 = null;
            String strDecodeStringElement2 = null;
            String str15 = null;
            Boolean bool10 = null;
            Integer num9 = null;
            Boolean bool11 = null;
            String str16 = null;
            Boolean bool12 = null;
            long jDecodeLongElement2 = 0;
            int i2 = 0;
            String str17 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        str17 = str17;
                        kSerializerArr = kSerializerArr;
                        break;
                    case 0:
                        l6 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 0, LongSerializer.INSTANCE, l6);
                        i2 |= 1;
                        kSerializerArr = kSerializerArr;
                        localDateTime5 = localDateTime5;
                        str17 = str17;
                        bool12 = bool12;
                        break;
                    case 1:
                        bool12 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, BooleanSerializer.INSTANCE, bool12);
                        i2 |= 2;
                        kSerializerArr = kSerializerArr;
                        localDateTime5 = localDateTime5;
                        str17 = str17;
                        break;
                    case 2:
                        localDateTime5 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, kSerializerArr[2], localDateTime5);
                        i2 |= 4;
                        str17 = str17;
                        break;
                    case 3:
                        str12 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, str12);
                        i2 |= 8;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 4:
                        list3 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, kSerializerArr[4], list3);
                        i2 |= 16;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 5:
                        l5 = (Long) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, LongSerializer.INSTANCE, l5);
                        i2 |= 32;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 6:
                        str14 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, str14);
                        i2 |= 64;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 7:
                        localDateTime6 = (LocalDateTime) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 7, kSerializerArr[7], localDateTime6);
                        i2 |= 128;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 8:
                        num7 = (Integer) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 8, IntSerializer.INSTANCE, num7);
                        i2 |= 256;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 9:
                        num8 = (Integer) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 9, IntSerializer.INSTANCE, num8);
                        i2 |= 512;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 10:
                        str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, str13);
                        i2 |= 1024;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 11:
                        localDateTime5 = localDateTime5;
                        bool9 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, BooleanSerializer.INSTANCE, bool9);
                        i2 |= 2048;
                        str17 = str17;
                        str15 = str15;
                        localDateTime5 = localDateTime5;
                        break;
                    case Message.TYPE_USER_VIDEO:
                        jDecodeLongElement2 = compositeDecoderBeginStructure.decodeLongElement(descriptor2, 12);
                        i2 |= 4096;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case 13:
                        strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 13);
                        i2 |= 8192;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case Message.TYPE_USER_FILE:
                        localDateTime5 = localDateTime5;
                        str15 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 14, StringSerializer.INSTANCE, str15);
                        i2 |= 16384;
                        str17 = str17;
                        bool10 = bool10;
                        localDateTime5 = localDateTime5;
                        break;
                    case WebSocketProtocol.B0_MASK_OPCODE:
                        localDateTime5 = localDateTime5;
                        bool10 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 15, BooleanSerializer.INSTANCE, bool10);
                        i2 |= 32768;
                        str17 = str17;
                        num9 = num9;
                        localDateTime5 = localDateTime5;
                        break;
                    case 16:
                        localDateTime5 = localDateTime5;
                        num9 = (Integer) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 16, IntSerializer.INSTANCE, num9);
                        i2 |= 65536;
                        str17 = str17;
                        bool11 = bool11;
                        localDateTime5 = localDateTime5;
                        break;
                    case LangUtils.HASH_SEED:
                        localDateTime5 = localDateTime5;
                        bool11 = (Boolean) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 17, BooleanSerializer.INSTANCE, bool11);
                        i2 |= 131072;
                        str17 = str17;
                        str16 = str16;
                        localDateTime5 = localDateTime5;
                        break;
                    case 18:
                        str16 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 18, StringSerializer.INSTANCE, str16);
                        i2 |= 262144;
                        str17 = str17;
                        localDateTime5 = localDateTime5;
                        break;
                    case Base64.Encoder.LINE_GROUPS:
                        str17 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 19, StringSerializer.INSTANCE, str17);
                        i2 |= 524288;
                        localDateTime5 = localDateTime5;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            num = num7;
            str = str13;
            str2 = str17;
            str3 = str16;
            bool = bool11;
            num2 = num9;
            bool2 = bool10;
            str4 = str15;
            str5 = strDecodeStringElement2;
            j = jDecodeLongElement2;
            l = l6;
            list = list3;
            num3 = num8;
            l2 = l5;
            str6 = str12;
            localDateTime = localDateTime6;
            str7 = str14;
            bool3 = bool12;
            localDateTime2 = localDateTime5;
            bool4 = bool9;
            i = i2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new ArticleDto(i, l, bool3, localDateTime2, str6, list, l2, str7, localDateTime, num, num3, str, bool4, j, str5, str4, bool2, num2, bool, str3, str2, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, ArticleDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        ArticleDto.write$Self$zendesk_guidekit_guidekit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
