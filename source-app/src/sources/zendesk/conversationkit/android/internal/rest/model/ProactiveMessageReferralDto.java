package zendesk.conversationkit.android.internal.rest.model;

import java.util.List;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 12\u00020\u0001:\u000201BQ\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u000e\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010¢\u0006\u0002\u0010\u0011BA\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\b\b\u0002\u0010\r\u001a\u00020\u000e¢\u0006\u0002\u0010\u0012J\u000b\u0010\u001d\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u0011\u0010\u001e\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007HÆ\u0003J\u000b\u0010\u001f\u001a\u0004\u0018\u00010\nHÆ\u0003J\t\u0010 \u001a\u00020\fHÆ\u0003J\t\u0010!\u001a\u00020\u000eHÆ\u0003JG\u0010\"\u001a\u00020\u00002\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u00072\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\b\b\u0002\u0010\r\u001a\u00020\u000eHÆ\u0001J\u0013\u0010#\u001a\u00020$2\b\u0010%\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010&\u001a\u00020\u0003HÖ\u0001J\t\u0010'\u001a\u00020\u0005HÖ\u0001J&\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020\u00002\u0006\u0010+\u001a\u00020,2\u0006\u0010-\u001a\u00020.HÁ\u0001¢\u0006\u0002\b/R\u0011\u0010\u000b\u001a\u00020\f¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\r\u001a\u00020\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0019\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0013\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001c¨\u00062"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto;", "", "seen1", "", "signedCampaignData", "", "messages", "", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "postback", "Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;", "author", "Lzendesk/conversationkit/android/internal/rest/model/AuthorDto;", "intent", "Lzendesk/conversationkit/android/internal/rest/model/Intent;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;Lzendesk/conversationkit/android/internal/rest/model/AuthorDto;Lzendesk/conversationkit/android/internal/rest/model/Intent;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;Lzendesk/conversationkit/android/internal/rest/model/AuthorDto;Lzendesk/conversationkit/android/internal/rest/model/Intent;)V", "getAuthor", "()Lzendesk/conversationkit/android/internal/rest/model/AuthorDto;", "getIntent", "()Lzendesk/conversationkit/android/internal/rest/model/Intent;", "getMessages", "()Ljava/util/List;", "getPostback", "()Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;", "getSignedCampaignData", "()Ljava/lang/String;", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ProactiveMessageReferralDto {
    private final AuthorDto author;
    private final Intent intent;
    private final List<MessageDto> messages;
    private final PostbackDto postback;
    private final String signedCampaignData;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, new ArrayListSerializer(MessageDto$$serializer.INSTANCE), null, null, Intent.INSTANCE.serializer()};

    public static ProactiveMessageReferralDto copy$default(ProactiveMessageReferralDto proactiveMessageReferralDto, String str, List list, PostbackDto postbackDto, AuthorDto authorDto, Intent intent, int i, Object obj) {
        if ((i & 1) != 0) {
            str = proactiveMessageReferralDto.signedCampaignData;
        }
        if ((i & 2) != 0) {
            list = proactiveMessageReferralDto.messages;
        }
        List list2 = list;
        if ((i & 4) != 0) {
            postbackDto = proactiveMessageReferralDto.postback;
        }
        PostbackDto postbackDto2 = postbackDto;
        if ((i & 8) != 0) {
            authorDto = proactiveMessageReferralDto.author;
        }
        AuthorDto authorDto2 = authorDto;
        if ((i & 16) != 0) {
            intent = proactiveMessageReferralDto.intent;
        }
        return proactiveMessageReferralDto.copy(str, list2, postbackDto2, authorDto2, intent);
    }

    public final String getSignedCampaignData() {
        return this.signedCampaignData;
    }

    public final List<MessageDto> component2() {
        return this.messages;
    }

    public final PostbackDto getPostback() {
        return this.postback;
    }

    public final AuthorDto getAuthor() {
        return this.author;
    }

    public final Intent getIntent() {
        return this.intent;
    }

    public final ProactiveMessageReferralDto copy(String signedCampaignData, List<MessageDto> messages, PostbackDto postback, AuthorDto author, Intent intent) {
        Intrinsics.checkNotNullParameter(author, "author");
        Intrinsics.checkNotNullParameter(intent, "intent");
        return new ProactiveMessageReferralDto(signedCampaignData, messages, postback, author, intent);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ProactiveMessageReferralDto)) {
            return false;
        }
        ProactiveMessageReferralDto proactiveMessageReferralDto = (ProactiveMessageReferralDto) other;
        return Intrinsics.areEqual(this.signedCampaignData, proactiveMessageReferralDto.signedCampaignData) && Intrinsics.areEqual(this.messages, proactiveMessageReferralDto.messages) && Intrinsics.areEqual(this.postback, proactiveMessageReferralDto.postback) && Intrinsics.areEqual(this.author, proactiveMessageReferralDto.author) && this.intent == proactiveMessageReferralDto.intent;
    }

    public int hashCode() {
        String str = this.signedCampaignData;
        int iHashCode = (str == null ? 0 : str.hashCode()) * 31;
        List<MessageDto> list = this.messages;
        int iHashCode2 = (iHashCode + (list == null ? 0 : list.hashCode())) * 31;
        PostbackDto postbackDto = this.postback;
        return ((((iHashCode2 + (postbackDto != null ? postbackDto.hashCode() : 0)) * 31) + this.author.hashCode()) * 31) + this.intent.hashCode();
    }

    public String toString() {
        return "ProactiveMessageReferralDto(signedCampaignData=" + this.signedCampaignData + ", messages=" + this.messages + ", postback=" + this.postback + ", author=" + this.author + ", intent=" + this.intent + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ProactiveMessageReferralDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ProactiveMessageReferralDto> serializer() {
            return ProactiveMessageReferralDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ProactiveMessageReferralDto(int i, String str, List list, PostbackDto postbackDto, AuthorDto authorDto, Intent intent, SerializationConstructorMarker serializationConstructorMarker) {
        if (8 != (i & 8)) {
            PluginExceptionsKt.throwMissingFieldException(i, 8, ProactiveMessageReferralDto$$serializer.INSTANCE.getDescriptor());
        }
        if ((i & 1) == 0) {
            this.signedCampaignData = null;
        } else {
            this.signedCampaignData = str;
        }
        if ((i & 2) == 0) {
            this.messages = null;
        } else {
            this.messages = list;
        }
        if ((i & 4) == 0) {
            this.postback = null;
        } else {
            this.postback = postbackDto;
        }
        this.author = authorDto;
        if ((i & 16) == 0) {
            this.intent = Intent.PROACTIVE;
        } else {
            this.intent = intent;
        }
    }

    public ProactiveMessageReferralDto(String str, List<MessageDto> list, PostbackDto postbackDto, AuthorDto author, Intent intent) {
        Intrinsics.checkNotNullParameter(author, "author");
        Intrinsics.checkNotNullParameter(intent, "intent");
        this.signedCampaignData = str;
        this.messages = list;
        this.postback = postbackDto;
        this.author = author;
        this.intent = intent;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(ProactiveMessageReferralDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        if (output.shouldEncodeElementDefault(serialDesc, 0) || self.signedCampaignData != null) {
            output.encodeNullableSerializableElement(serialDesc, 0, StringSerializer.INSTANCE, self.signedCampaignData);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.messages != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, kSerializerArr[1], self.messages);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.postback != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, PostbackDto$$serializer.INSTANCE, self.postback);
        }
        output.encodeSerializableElement(serialDesc, 3, AuthorDto$$serializer.INSTANCE, self.author);
        if (!output.shouldEncodeElementDefault(serialDesc, 4) && self.intent == Intent.PROACTIVE) {
            return;
        }
        output.encodeSerializableElement(serialDesc, 4, kSerializerArr[4], self.intent);
    }

    public final String getSignedCampaignData() {
        return this.signedCampaignData;
    }

    public final List<MessageDto> getMessages() {
        return this.messages;
    }

    public final PostbackDto getPostback() {
        return this.postback;
    }

    public final AuthorDto getAuthor() {
        return this.author;
    }

    public ProactiveMessageReferralDto(String str, List list, PostbackDto postbackDto, AuthorDto authorDto, Intent intent, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : str, (i & 2) != 0 ? null : list, (i & 4) != 0 ? null : postbackDto, authorDto, (i & 16) != 0 ? Intent.PROACTIVE : intent);
    }

    public final Intent getIntent() {
        return this.intent;
    }
}
