package zendesk.conversationkit.android.model;

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
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/model/User.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/model/User;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class User$$serializer implements GeneratedSerializer<User> {
    public static final User$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        User$$serializer user$$serializer = new User$$serializer();
        INSTANCE = user$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.model.User", user$$serializer, 13);
        pluginGeneratedSerialDescriptor.addElement("id", false);
        pluginGeneratedSerialDescriptor.addElement("externalId", false);
        pluginGeneratedSerialDescriptor.addElement("givenName", false);
        pluginGeneratedSerialDescriptor.addElement("surname", false);
        pluginGeneratedSerialDescriptor.addElement("email", false);
        pluginGeneratedSerialDescriptor.addElement("locale", false);
        pluginGeneratedSerialDescriptor.addElement("signedUpAt", false);
        pluginGeneratedSerialDescriptor.addElement("conversations", false);
        pluginGeneratedSerialDescriptor.addElement("realtimeSettings", false);
        pluginGeneratedSerialDescriptor.addElement("typingSettings", false);
        pluginGeneratedSerialDescriptor.addElement("sessionToken", true);
        pluginGeneratedSerialDescriptor.addElement("jwt", true);
        pluginGeneratedSerialDescriptor.addElement("hasMore", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private User$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        return new KSerializer[]{StringSerializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), User.$childSerializers[7], RealtimeSettings$$serializer.INSTANCE, TypingSettings$$serializer.INSTANCE, BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BooleanSerializer.INSTANCE};
    }

    @Override
    public User deserialize(Decoder decoder) {
        String str;
        String str2;
        TypingSettings typingSettings;
        String str3;
        RealtimeSettings realtimeSettings;
        boolean zDecodeBooleanElement;
        int i;
        String str4;
        String str5;
        String str6;
        String str7;
        String str8;
        List list;
        String str9;
        int i2;
        int i3;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = User.$childSerializers;
        String strDecodeStringElement = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String strDecodeStringElement2 = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
            String str10 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, null);
            String str11 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, null);
            String str12 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, null);
            str7 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, null);
            String str13 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, null);
            String str14 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, null);
            List list2 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 7, kSerializerArr[7], null);
            RealtimeSettings realtimeSettings2 = (RealtimeSettings) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 8, RealtimeSettings$$serializer.INSTANCE, null);
            TypingSettings typingSettings2 = (TypingSettings) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 9, TypingSettings$$serializer.INSTANCE, null);
            String str15 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, null);
            str = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, null);
            str2 = str15;
            typingSettings = typingSettings2;
            realtimeSettings = realtimeSettings2;
            zDecodeBooleanElement = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, 12);
            i = 8191;
            list = list2;
            str4 = str14;
            str3 = str12;
            str8 = str11;
            str9 = strDecodeStringElement2;
            str5 = str13;
            str6 = str10;
        } else {
            int i4 = 12;
            boolean zDecodeBooleanElement2 = false;
            int i5 = 0;
            String str16 = null;
            String str17 = null;
            String str18 = null;
            List list3 = null;
            String str19 = null;
            String str20 = null;
            TypingSettings typingSettings3 = null;
            String str21 = null;
            String str22 = null;
            RealtimeSettings realtimeSettings3 = null;
            boolean z = true;
            String str23 = null;
            while (z) {
                strDecodeStringElement = strDecodeStringElement;
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                switch (iDecodeElementIndex) {
                    case -1:
                        z = false;
                        kSerializerArr = kSerializerArr;
                        str16 = str16;
                        i4 = 12;
                        break;
                    case 0:
                        str16 = str16;
                        kSerializerArr = kSerializerArr;
                        i4 = 12;
                        i5 |= 1;
                        strDecodeStringElement = compositeDecoderBeginStructure.decodeStringElement(descriptor2, 0);
                        break;
                    case 1:
                        str16 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, StringSerializer.INSTANCE, str16);
                        i5 |= 2;
                        kSerializerArr = kSerializerArr;
                        i4 = 12;
                        break;
                    case 2:
                        str23 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, StringSerializer.INSTANCE, str23);
                        i2 = i5 | 4;
                        strDecodeStringElement = strDecodeStringElement;
                        i4 = 12;
                        i5 = i2;
                        str16 = str16;
                        break;
                    case 3:
                        str22 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 3, StringSerializer.INSTANCE, str22);
                        i2 = i5 | 8;
                        strDecodeStringElement = strDecodeStringElement;
                        i4 = 12;
                        i5 = i2;
                        str16 = str16;
                        break;
                    case 4:
                        str20 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 4, StringSerializer.INSTANCE, str20);
                        i2 = i5 | 16;
                        strDecodeStringElement = strDecodeStringElement;
                        i4 = 12;
                        i5 = i2;
                        str16 = str16;
                        break;
                    case 5:
                        str21 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 5, StringSerializer.INSTANCE, str21);
                        i2 = i5 | 32;
                        strDecodeStringElement = strDecodeStringElement;
                        i4 = 12;
                        i5 = i2;
                        str16 = str16;
                        break;
                    case 6:
                        str19 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 6, StringSerializer.INSTANCE, str19);
                        i2 = i5 | 64;
                        strDecodeStringElement = strDecodeStringElement;
                        i4 = 12;
                        i5 = i2;
                        str16 = str16;
                        break;
                    case 7:
                        list3 = (List) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 7, kSerializerArr[7], list3);
                        i2 = i5 | 128;
                        strDecodeStringElement = strDecodeStringElement;
                        i4 = 12;
                        i5 = i2;
                        str16 = str16;
                        break;
                    case 8:
                        realtimeSettings3 = (RealtimeSettings) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 8, RealtimeSettings$$serializer.INSTANCE, realtimeSettings3);
                        i3 = i5 | 256;
                        str16 = str16;
                        i5 = i3;
                        i4 = 12;
                        break;
                    case 9:
                        typingSettings3 = (TypingSettings) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 9, TypingSettings$$serializer.INSTANCE, typingSettings3);
                        i3 = i5 | 512;
                        str16 = str16;
                        i5 = i3;
                        i4 = 12;
                        break;
                    case 10:
                        str18 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 10, StringSerializer.INSTANCE, str18);
                        i3 = i5 | 1024;
                        str16 = str16;
                        i5 = i3;
                        i4 = 12;
                        break;
                    case 11:
                        str17 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 11, StringSerializer.INSTANCE, str17);
                        i3 = i5 | 2048;
                        str16 = str16;
                        i5 = i3;
                        i4 = 12;
                        break;
                    case net.aihelp.data.model.rpa.msg.base.Message.TYPE_USER_VIDEO:
                        zDecodeBooleanElement2 = compositeDecoderBeginStructure.decodeBooleanElement(descriptor2, i4);
                        i5 |= 4096;
                        strDecodeStringElement = strDecodeStringElement;
                        break;
                    default:
                        throw new UnknownFieldException(iDecodeElementIndex);
                }
            }
            str = str17;
            str2 = str18;
            typingSettings = typingSettings3;
            str3 = str22;
            realtimeSettings = realtimeSettings3;
            zDecodeBooleanElement = zDecodeBooleanElement2;
            i = i5;
            str4 = str19;
            str5 = str21;
            str6 = str16;
            str7 = str20;
            str8 = str23;
            list = list3;
            str9 = strDecodeStringElement;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new User(i, str9, str6, str8, str3, str7, str5, str4, list, realtimeSettings, typingSettings, str2, str, zDecodeBooleanElement, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, User value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        User.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
