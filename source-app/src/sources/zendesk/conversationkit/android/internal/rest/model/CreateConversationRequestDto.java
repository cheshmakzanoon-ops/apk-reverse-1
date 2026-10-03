package zendesk.conversationkit.android.internal.rest.model;

import java.util.List;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlinx.serialization.ContextualSerializer;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import zendesk.conversationkit.android.model.ConversationType;

@Metadata(m17d1 = {"\u0000h\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0019\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 <2\u00020\u0001:\u0002;<Bv\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b\u0012\u000e\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\r\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010\u0012\u0019\u0010\u0011\u001a\u0015\u0012\u0004\u0012\u00020\u000b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0013\u0018\u00010\u0012\u0012\b\u0010\u0014\u001a\u0004\u0018\u00010\u0015¢\u0006\u0002\u0010\u0016Bd\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u000b\u0012\u0010\b\u0002\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\r\u0012\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u0010\u0012\u001b\b\u0002\u0010\u0011\u001a\u0015\u0012\u0004\u0012\u00020\u000b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0013\u0018\u00010\u0012¢\u0006\u0002\u0010\u0017J\t\u0010&\u001a\u00020\u0005HÆ\u0003J\t\u0010'\u001a\u00020\u0007HÆ\u0003J\t\u0010(\u001a\u00020\tHÆ\u0003J\u000b\u0010)\u001a\u0004\u0018\u00010\u000bHÆ\u0003J\u0011\u0010*\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\rHÆ\u0003J\u000b\u0010+\u001a\u0004\u0018\u00010\u0010HÆ\u0003J\u001c\u0010,\u001a\u0015\u0012\u0004\u0012\u00020\u000b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0013\u0018\u00010\u0012HÆ\u0003Jn\u0010-\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u000b2\u0010\b\u0002\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\r2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00102\u001b\b\u0002\u0010\u0011\u001a\u0015\u0012\u0004\u0012\u00020\u000b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0013\u0018\u00010\u0012HÆ\u0001J\u0013\u0010.\u001a\u00020/2\b\u00100\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u00101\u001a\u00020\u0003HÖ\u0001J\t\u00102\u001a\u00020\u000bHÖ\u0001J&\u00103\u001a\u0002042\u0006\u00105\u001a\u00020\u00002\u0006\u00106\u001a\u0002072\u0006\u00108\u001a\u000209HÁ\u0001¢\u0006\u0002\b:R\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u0019\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\r¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR$\u0010\u0011\u001a\u0015\u0012\u0004\u0012\u00020\u000b\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0013\u0018\u00010\u0012¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0013\u0010\u000f\u001a\u0004\u0018\u00010\u0010¢\u0006\b\n\u0000\u001a\u0004\b \u0010!R\u0013\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010#R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b$\u0010%¨\u0006="}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;", "", "seen1", "", "type", "Lzendesk/conversationkit/android/model/ConversationType;", "intent", "Lzendesk/conversationkit/android/internal/rest/model/Intent;", "client", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "signedCampaignData", "", "messages", "", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "postback", "Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;", "metadata", "", "Lkotlinx/serialization/Contextual;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/ConversationType;Lzendesk/conversationkit/android/internal/rest/model/Intent;Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/model/ConversationType;Lzendesk/conversationkit/android/internal/rest/model/Intent;Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;Ljava/util/Map;)V", "getClient", "()Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "getIntent", "()Lzendesk/conversationkit/android/internal/rest/model/Intent;", "getMessages", "()Ljava/util/List;", "getMetadata", "()Ljava/util/Map;", "getPostback", "()Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;", "getSignedCampaignData", "()Ljava/lang/String;", "getType", "()Lzendesk/conversationkit/android/model/ConversationType;", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class CreateConversationRequestDto {
    private final ClientDto client;
    private final Intent intent;
    private final List<MessageDto> messages;
    private final Map<String, Object> metadata;
    private final PostbackDto postback;
    private final String signedCampaignData;
    private final ConversationType type;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {ConversationType.INSTANCE.serializer(), Intent.INSTANCE.serializer(), null, null, new ArrayListSerializer(MessageDto$$serializer.INSTANCE), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0]))};

    public static CreateConversationRequestDto copy$default(CreateConversationRequestDto createConversationRequestDto, ConversationType conversationType, Intent intent, ClientDto clientDto, String str, List list, PostbackDto postbackDto, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            conversationType = createConversationRequestDto.type;
        }
        if ((i & 2) != 0) {
            intent = createConversationRequestDto.intent;
        }
        Intent intent2 = intent;
        if ((i & 4) != 0) {
            clientDto = createConversationRequestDto.client;
        }
        ClientDto clientDto2 = clientDto;
        if ((i & 8) != 0) {
            str = createConversationRequestDto.signedCampaignData;
        }
        String str2 = str;
        if ((i & 16) != 0) {
            list = createConversationRequestDto.messages;
        }
        List list2 = list;
        if ((i & 32) != 0) {
            postbackDto = createConversationRequestDto.postback;
        }
        PostbackDto postbackDto2 = postbackDto;
        if ((i & 64) != 0) {
            map = createConversationRequestDto.metadata;
        }
        return createConversationRequestDto.copy(conversationType, intent2, clientDto2, str2, list2, postbackDto2, map);
    }

    public final ConversationType getType() {
        return this.type;
    }

    public final Intent getIntent() {
        return this.intent;
    }

    public final ClientDto getClient() {
        return this.client;
    }

    public final String getSignedCampaignData() {
        return this.signedCampaignData;
    }

    public final List<MessageDto> component5() {
        return this.messages;
    }

    public final PostbackDto getPostback() {
        return this.postback;
    }

    public final Map<String, Object> component7() {
        return this.metadata;
    }

    public final CreateConversationRequestDto copy(ConversationType type, Intent intent, ClientDto client, String signedCampaignData, List<MessageDto> messages, PostbackDto postback, Map<String, ? extends Object> metadata) {
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(intent, "intent");
        Intrinsics.checkNotNullParameter(client, "client");
        return new CreateConversationRequestDto(type, intent, client, signedCampaignData, messages, postback, metadata);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof CreateConversationRequestDto)) {
            return false;
        }
        CreateConversationRequestDto createConversationRequestDto = (CreateConversationRequestDto) other;
        return this.type == createConversationRequestDto.type && this.intent == createConversationRequestDto.intent && Intrinsics.areEqual(this.client, createConversationRequestDto.client) && Intrinsics.areEqual(this.signedCampaignData, createConversationRequestDto.signedCampaignData) && Intrinsics.areEqual(this.messages, createConversationRequestDto.messages) && Intrinsics.areEqual(this.postback, createConversationRequestDto.postback) && Intrinsics.areEqual(this.metadata, createConversationRequestDto.metadata);
    }

    public int hashCode() {
        int iHashCode = ((((this.type.hashCode() * 31) + this.intent.hashCode()) * 31) + this.client.hashCode()) * 31;
        String str = this.signedCampaignData;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        List<MessageDto> list = this.messages;
        int iHashCode3 = (iHashCode2 + (list == null ? 0 : list.hashCode())) * 31;
        PostbackDto postbackDto = this.postback;
        int iHashCode4 = (iHashCode3 + (postbackDto == null ? 0 : postbackDto.hashCode())) * 31;
        Map<String, Object> map = this.metadata;
        return iHashCode4 + (map != null ? map.hashCode() : 0);
    }

    public String toString() {
        return "CreateConversationRequestDto(type=" + this.type + ", intent=" + this.intent + ", client=" + this.client + ", signedCampaignData=" + this.signedCampaignData + ", messages=" + this.messages + ", postback=" + this.postback + ", metadata=" + this.metadata + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<CreateConversationRequestDto> serializer() {
            return CreateConversationRequestDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public CreateConversationRequestDto(int i, ConversationType conversationType, Intent intent, ClientDto clientDto, String str, List list, PostbackDto postbackDto, Map map, SerializationConstructorMarker serializationConstructorMarker) {
        if (7 != (i & 7)) {
            PluginExceptionsKt.throwMissingFieldException(i, 7, CreateConversationRequestDto$$serializer.INSTANCE.getDescriptor());
        }
        this.type = conversationType;
        this.intent = intent;
        this.client = clientDto;
        if ((i & 8) == 0) {
            this.signedCampaignData = null;
        } else {
            this.signedCampaignData = str;
        }
        if ((i & 16) == 0) {
            this.messages = null;
        } else {
            this.messages = list;
        }
        if ((i & 32) == 0) {
            this.postback = null;
        } else {
            this.postback = postbackDto;
        }
        if ((i & 64) == 0) {
            this.metadata = null;
        } else {
            this.metadata = map;
        }
    }

    public CreateConversationRequestDto(ConversationType type, Intent intent, ClientDto client, String str, List<MessageDto> list, PostbackDto postbackDto, Map<String, ? extends Object> map) {
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(intent, "intent");
        Intrinsics.checkNotNullParameter(client, "client");
        this.type = type;
        this.intent = intent;
        this.client = client;
        this.signedCampaignData = str;
        this.messages = list;
        this.postback = postbackDto;
        this.metadata = map;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(CreateConversationRequestDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeSerializableElement(serialDesc, 0, kSerializerArr[0], self.type);
        output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.intent);
        output.encodeSerializableElement(serialDesc, 2, ClientDto$$serializer.INSTANCE, self.client);
        if (output.shouldEncodeElementDefault(serialDesc, 3) || self.signedCampaignData != null) {
            output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.signedCampaignData);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 4) || self.messages != null) {
            output.encodeNullableSerializableElement(serialDesc, 4, kSerializerArr[4], self.messages);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 5) || self.postback != null) {
            output.encodeNullableSerializableElement(serialDesc, 5, PostbackDto$$serializer.INSTANCE, self.postback);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 6) && self.metadata == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 6, kSerializerArr[6], self.metadata);
    }

    public CreateConversationRequestDto(ConversationType conversationType, Intent intent, ClientDto clientDto, String str, List list, PostbackDto postbackDto, Map map, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(conversationType, intent, clientDto, (i & 8) != 0 ? null : str, (i & 16) != 0 ? null : list, (i & 32) != 0 ? null : postbackDto, (i & 64) != 0 ? null : map);
    }

    public final ConversationType getType() {
        return this.type;
    }

    public final Intent getIntent() {
        return this.intent;
    }

    public final ClientDto getClient() {
        return this.client;
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

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }
}
