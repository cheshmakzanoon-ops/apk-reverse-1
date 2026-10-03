package zendesk.conversationkit.android.internal.rest.model;

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
import kotlinx.serialization.internal.GeneratedSerializer;
import kotlinx.serialization.internal.PluginGeneratedSerialDescriptor;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u00006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\bÇ\u0002\u0018\u00002\b\u0012\u0004\u0012\u00020\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0003J\u0018\u0010\b\u001a\f\u0012\b\u0012\u0006\u0012\u0002\b\u00030\n0\tHÖ\u0001¢\u0006\u0002\u0010\u000bJ\u0011\u0010\f\u001a\u00020\u00022\u0006\u0010\r\u001a\u00020\u000eHÖ\u0001J\u0019\u0010\u000f\u001a\u00020\u00102\u0006\u0010\u0011\u001a\u00020\u00122\u0006\u0010\u0013\u001a\u00020\u0002HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u00058VXÖ\u0005¢\u0006\u0006\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0014"}, m18d2 = {"zendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto.$serializer", "Lkotlinx/serialization/internal/GeneratedSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto;", "()V", "descriptor", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "getDescriptor", "()Lkotlinx/serialization/descriptors/SerialDescriptor;", "childSerializers", "", "Lkotlinx/serialization/KSerializer;", "()[Lkotlinx/serialization/KSerializer;", "deserialize", "decoder", "Lkotlinx/serialization/encoding/Decoder;", "serialize", "", "encoder", "Lkotlinx/serialization/encoding/Encoder;", "value", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
public final class ProactiveMessageReferralDto$$serializer implements GeneratedSerializer<ProactiveMessageReferralDto> {
    public static final ProactiveMessageReferralDto$$serializer INSTANCE;
    private static final PluginGeneratedSerialDescriptor descriptor;

    static {
        ProactiveMessageReferralDto$$serializer proactiveMessageReferralDto$$serializer = new ProactiveMessageReferralDto$$serializer();
        INSTANCE = proactiveMessageReferralDto$$serializer;
        PluginGeneratedSerialDescriptor pluginGeneratedSerialDescriptor = new PluginGeneratedSerialDescriptor("zendesk.conversationkit.android.internal.rest.model.ProactiveMessageReferralDto", proactiveMessageReferralDto$$serializer, 5);
        pluginGeneratedSerialDescriptor.addElement("signedCampaignData", true);
        pluginGeneratedSerialDescriptor.addElement("messages", true);
        pluginGeneratedSerialDescriptor.addElement("postback", true);
        pluginGeneratedSerialDescriptor.addElement("author", false);
        pluginGeneratedSerialDescriptor.addElement("intent", true);
        descriptor = pluginGeneratedSerialDescriptor;
    }

    private ProactiveMessageReferralDto$$serializer() {
    }

    @Override
    public KSerializer<?>[] childSerializers() {
        KSerializer<?>[] kSerializerArr = ProactiveMessageReferralDto.$childSerializers;
        return new KSerializer[]{BuiltinSerializersKt.getNullable(StringSerializer.INSTANCE), BuiltinSerializersKt.getNullable(kSerializerArr[1]), BuiltinSerializersKt.getNullable(PostbackDto$$serializer.INSTANCE), AuthorDto$$serializer.INSTANCE, kSerializerArr[4]};
    }

    @Override
    public ProactiveMessageReferralDto deserialize(Decoder decoder) {
        int i;
        String str;
        List list;
        PostbackDto postbackDto;
        AuthorDto authorDto;
        Intent intent;
        Intrinsics.checkNotNullParameter(decoder, "decoder");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeDecoder compositeDecoderBeginStructure = decoder.beginStructure(descriptor2);
        KSerializer[] kSerializerArr = ProactiveMessageReferralDto.$childSerializers;
        String str2 = null;
        if (compositeDecoderBeginStructure.decodeSequentially()) {
            String str3 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 0, StringSerializer.INSTANCE, null);
            List list2 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, kSerializerArr[1], null);
            PostbackDto postbackDto2 = (PostbackDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, PostbackDto$$serializer.INSTANCE, null);
            AuthorDto authorDto2 = (AuthorDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 3, AuthorDto$$serializer.INSTANCE, null);
            intent = (Intent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], null);
            str = str3;
            authorDto = authorDto2;
            postbackDto = postbackDto2;
            i = 31;
            list = list2;
        } else {
            boolean z = true;
            int i2 = 0;
            List list3 = null;
            PostbackDto postbackDto3 = null;
            AuthorDto authorDto3 = null;
            Intent intent2 = null;
            while (z) {
                int iDecodeElementIndex = compositeDecoderBeginStructure.decodeElementIndex(descriptor2);
                if (iDecodeElementIndex == -1) {
                    z = false;
                } else if (iDecodeElementIndex == 0) {
                    str2 = (String) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 0, StringSerializer.INSTANCE, str2);
                    i2 |= 1;
                } else if (iDecodeElementIndex == 1) {
                    list3 = (List) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 1, kSerializerArr[1], list3);
                    i2 |= 2;
                } else if (iDecodeElementIndex == 2) {
                    postbackDto3 = (PostbackDto) compositeDecoderBeginStructure.decodeNullableSerializableElement(descriptor2, 2, PostbackDto$$serializer.INSTANCE, postbackDto3);
                    i2 |= 4;
                } else if (iDecodeElementIndex == 3) {
                    authorDto3 = (AuthorDto) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 3, AuthorDto$$serializer.INSTANCE, authorDto3);
                    i2 |= 8;
                } else {
                    if (iDecodeElementIndex != 4) {
                        throw new UnknownFieldException(iDecodeElementIndex);
                    }
                    intent2 = (Intent) compositeDecoderBeginStructure.decodeSerializableElement(descriptor2, 4, kSerializerArr[4], intent2);
                    i2 |= 16;
                }
            }
            i = i2;
            str = str2;
            list = list3;
            postbackDto = postbackDto3;
            authorDto = authorDto3;
            intent = intent2;
        }
        compositeDecoderBeginStructure.endStructure(descriptor2);
        return new ProactiveMessageReferralDto(i, str, list, postbackDto, authorDto, intent, (SerializationConstructorMarker) null);
    }

    @Override
    public SerialDescriptor getDescriptor() {
        return descriptor;
    }

    @Override
    public void serialize(Encoder encoder, ProactiveMessageReferralDto value) {
        Intrinsics.checkNotNullParameter(encoder, "encoder");
        Intrinsics.checkNotNullParameter(value, "value");
        SerialDescriptor descriptor2 = getDescriptor();
        CompositeEncoder compositeEncoderBeginStructure = encoder.beginStructure(descriptor2);
        ProactiveMessageReferralDto.write$Self$zendesk_conversationkit_conversationkit_android(value, compositeEncoderBeginStructure, descriptor2);
        compositeEncoderBeginStructure.endStructure(descriptor2);
    }

    @Override
    public KSerializer<?>[] typeParametersSerializers() {
        return GeneratedSerializer.DefaultImpls.typeParametersSerializers(this);
    }
}
