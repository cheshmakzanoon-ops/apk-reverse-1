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

@Metadata(m17d1 = {"\u0000l\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b!\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 H2\u00020\u0001:\u0002GHB\u009e\u0001\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0007\u0012\u0019\u0010\u000b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\r\u0018\u00010\f\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0007\u0012\u000e\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012\u0012\b\u0010\u0014\u001a\u0004\u0018\u00010\u0015\u0012\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017\u0012\b\u0010\u0018\u001a\u0004\u0018\u00010\u0019¢\u0006\u0002\u0010\u001aB\u009a\u0001\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u0007\u0012\u001b\b\u0002\u0010\u000b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\r\u0018\u00010\f\u0012\b\b\u0002\u0010\u000e\u001a\u00020\u000f\u0012\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u0007\u0012\u0010\b\u0002\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012\u0012\n\b\u0002\u0010\u0014\u001a\u0004\u0018\u00010\u0015\u0012\n\b\u0002\u0010\u0016\u001a\u0004\u0018\u00010\u0017¢\u0006\u0002\u0010\u001bJ\t\u0010.\u001a\u00020\u0005HÆ\u0003J\u000b\u0010/\u001a\u0004\u0018\u00010\u0015HÆ\u0003J\u000b\u00100\u001a\u0004\u0018\u00010\u0017HÆ\u0003J\u000b\u00101\u001a\u0004\u0018\u00010\u0007HÆ\u0003J\u000b\u00102\u001a\u0004\u0018\u00010\u0007HÆ\u0003J\u000b\u00103\u001a\u0004\u0018\u00010\u0007HÆ\u0003J\u000b\u00104\u001a\u0004\u0018\u00010\u0007HÆ\u0003J\u001c\u00105\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\r\u0018\u00010\fHÆ\u0003J\t\u00106\u001a\u00020\u000fHÆ\u0003J\u000b\u00107\u001a\u0004\u0018\u00010\u0007HÆ\u0003J\u0011\u00108\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012HÆ\u0003J \u0001\u00109\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00072\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u00072\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00072\u001b\b\u0002\u0010\u000b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\r\u0018\u00010\f2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00072\u0010\b\u0002\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u00122\n\b\u0002\u0010\u0014\u001a\u0004\u0018\u00010\u00152\n\b\u0002\u0010\u0016\u001a\u0004\u0018\u00010\u0017HÆ\u0001J\u0013\u0010:\u001a\u00020;2\b\u0010<\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010=\u001a\u00020\u0003HÖ\u0001J\t\u0010>\u001a\u00020\u0007HÖ\u0001J&\u0010?\u001a\u00020@2\u0006\u0010A\u001a\u00020\u00002\u0006\u0010B\u001a\u00020C2\u0006\u0010D\u001a\u00020EHÁ\u0001¢\u0006\u0002\bFR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0013\u0010\u0016\u001a\u0004\u0018\u00010\u0017¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0013\u0010\n\u001a\u0004\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b \u0010!R\u0013\u0010\b\u001a\u0004\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010!R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u0019\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0013\u0018\u00010\u0012¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&R\u0013\u0010\u0014\u001a\u0004\u0018\u00010\u0015¢\u0006\b\n\u0000\u001a\u0004\b'\u0010(R$\u0010\u000b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\r\u0018\u00010\f¢\u0006\b\n\u0000\u001a\u0004\b)\u0010*R\u0013\u0010\u0010\u001a\u0004\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b+\u0010!R\u0013\u0010\t\u001a\u0004\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b,\u0010!R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b-\u0010!¨\u0006I"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/AppUserRequestDto;", "", "seen1", "", "client", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "userId", "", "givenName", "surname", "email", "properties", "", "Lkotlinx/serialization/Contextual;", "intent", "Lzendesk/conversationkit/android/internal/rest/model/Intent;", "signedCampaignData", "messages", "", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "postback", "Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;", "conversation", "Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Lzendesk/conversationkit/android/internal/rest/model/Intent;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/Map;Lzendesk/conversationkit/android/internal/rest/model/Intent;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;)V", "getClient", "()Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "getConversation", "()Lzendesk/conversationkit/android/internal/rest/model/CreateConversationRequestDto;", "getEmail", "()Ljava/lang/String;", "getGivenName", "getIntent", "()Lzendesk/conversationkit/android/internal/rest/model/Intent;", "getMessages", "()Ljava/util/List;", "getPostback", "()Lzendesk/conversationkit/android/internal/rest/model/PostbackDto;", "getProperties", "()Ljava/util/Map;", "getSignedCampaignData", "getSurname", "getUserId", "component1", "component10", "component11", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class AppUserRequestDto {
    private final ClientDto client;
    private final CreateConversationRequestDto conversation;
    private final String email;
    private final String givenName;
    private final Intent intent;
    private final List<MessageDto> messages;
    private final PostbackDto postback;
    private final Map<String, Object> properties;
    private final String signedCampaignData;
    private final String surname;
    private final String userId;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), Intent.INSTANCE.serializer(), null, new ArrayListSerializer(MessageDto$$serializer.INSTANCE), null, null};

    public final ClientDto getClient() {
        return this.client;
    }

    public final PostbackDto getPostback() {
        return this.postback;
    }

    public final CreateConversationRequestDto getConversation() {
        return this.conversation;
    }

    public final String getUserId() {
        return this.userId;
    }

    public final String getGivenName() {
        return this.givenName;
    }

    public final String getSurname() {
        return this.surname;
    }

    public final String getEmail() {
        return this.email;
    }

    public final Map<String, Object> component6() {
        return this.properties;
    }

    public final Intent getIntent() {
        return this.intent;
    }

    public final String getSignedCampaignData() {
        return this.signedCampaignData;
    }

    public final List<MessageDto> component9() {
        return this.messages;
    }

    public final AppUserRequestDto copy(ClientDto client, String userId, String givenName, String surname, String email, Map<String, ? extends Object> properties, Intent intent, String signedCampaignData, List<MessageDto> messages, PostbackDto postback, CreateConversationRequestDto conversation) {
        Intrinsics.checkNotNullParameter(client, "client");
        Intrinsics.checkNotNullParameter(intent, "intent");
        return new AppUserRequestDto(client, userId, givenName, surname, email, properties, intent, signedCampaignData, messages, postback, conversation);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AppUserRequestDto)) {
            return false;
        }
        AppUserRequestDto appUserRequestDto = (AppUserRequestDto) other;
        return Intrinsics.areEqual(this.client, appUserRequestDto.client) && Intrinsics.areEqual(this.userId, appUserRequestDto.userId) && Intrinsics.areEqual(this.givenName, appUserRequestDto.givenName) && Intrinsics.areEqual(this.surname, appUserRequestDto.surname) && Intrinsics.areEqual(this.email, appUserRequestDto.email) && Intrinsics.areEqual(this.properties, appUserRequestDto.properties) && this.intent == appUserRequestDto.intent && Intrinsics.areEqual(this.signedCampaignData, appUserRequestDto.signedCampaignData) && Intrinsics.areEqual(this.messages, appUserRequestDto.messages) && Intrinsics.areEqual(this.postback, appUserRequestDto.postback) && Intrinsics.areEqual(this.conversation, appUserRequestDto.conversation);
    }

    public int hashCode() {
        int iHashCode = this.client.hashCode() * 31;
        String str = this.userId;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.givenName;
        int iHashCode3 = (iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.surname;
        int iHashCode4 = (iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.email;
        int iHashCode5 = (iHashCode4 + (str4 == null ? 0 : str4.hashCode())) * 31;
        Map<String, Object> map = this.properties;
        int iHashCode6 = (((iHashCode5 + (map == null ? 0 : map.hashCode())) * 31) + this.intent.hashCode()) * 31;
        String str5 = this.signedCampaignData;
        int iHashCode7 = (iHashCode6 + (str5 == null ? 0 : str5.hashCode())) * 31;
        List<MessageDto> list = this.messages;
        int iHashCode8 = (iHashCode7 + (list == null ? 0 : list.hashCode())) * 31;
        PostbackDto postbackDto = this.postback;
        int iHashCode9 = (iHashCode8 + (postbackDto == null ? 0 : postbackDto.hashCode())) * 31;
        CreateConversationRequestDto createConversationRequestDto = this.conversation;
        return iHashCode9 + (createConversationRequestDto != null ? createConversationRequestDto.hashCode() : 0);
    }

    public String toString() {
        return "AppUserRequestDto(client=" + this.client + ", userId=" + this.userId + ", givenName=" + this.givenName + ", surname=" + this.surname + ", email=" + this.email + ", properties=" + this.properties + ", intent=" + this.intent + ", signedCampaignData=" + this.signedCampaignData + ", messages=" + this.messages + ", postback=" + this.postback + ", conversation=" + this.conversation + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/AppUserRequestDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/AppUserRequestDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<AppUserRequestDto> serializer() {
            return AppUserRequestDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public AppUserRequestDto(int i, ClientDto clientDto, String str, String str2, String str3, String str4, Map map, Intent intent, String str5, List list, PostbackDto postbackDto, CreateConversationRequestDto createConversationRequestDto, SerializationConstructorMarker serializationConstructorMarker) {
        if (1 != (i & 1)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1, AppUserRequestDto$$serializer.INSTANCE.getDescriptor());
        }
        this.client = clientDto;
        if ((i & 2) == 0) {
            this.userId = null;
        } else {
            this.userId = str;
        }
        if ((i & 4) == 0) {
            this.givenName = null;
        } else {
            this.givenName = str2;
        }
        if ((i & 8) == 0) {
            this.surname = null;
        } else {
            this.surname = str3;
        }
        if ((i & 16) == 0) {
            this.email = null;
        } else {
            this.email = str4;
        }
        if ((i & 32) == 0) {
            this.properties = null;
        } else {
            this.properties = map;
        }
        if ((i & 64) == 0) {
            this.intent = Intent.CONVERSATION_START;
        } else {
            this.intent = intent;
        }
        if ((i & 128) == 0) {
            this.signedCampaignData = null;
        } else {
            this.signedCampaignData = str5;
        }
        if ((i & 256) == 0) {
            this.messages = null;
        } else {
            this.messages = list;
        }
        if ((i & 512) == 0) {
            this.postback = null;
        } else {
            this.postback = postbackDto;
        }
        if ((i & 1024) == 0) {
            this.conversation = null;
        } else {
            this.conversation = createConversationRequestDto;
        }
    }

    public AppUserRequestDto(ClientDto client, String str, String str2, String str3, String str4, Map<String, ? extends Object> map, Intent intent, String str5, List<MessageDto> list, PostbackDto postbackDto, CreateConversationRequestDto createConversationRequestDto) {
        Intrinsics.checkNotNullParameter(client, "client");
        Intrinsics.checkNotNullParameter(intent, "intent");
        this.client = client;
        this.userId = str;
        this.givenName = str2;
        this.surname = str3;
        this.email = str4;
        this.properties = map;
        this.intent = intent;
        this.signedCampaignData = str5;
        this.messages = list;
        this.postback = postbackDto;
        this.conversation = createConversationRequestDto;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(AppUserRequestDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeSerializableElement(serialDesc, 0, ClientDto$$serializer.INSTANCE, self.client);
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.userId != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.userId);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.givenName != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.givenName);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 3) || self.surname != null) {
            output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.surname);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 4) || self.email != null) {
            output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.email);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 5) || self.properties != null) {
            output.encodeNullableSerializableElement(serialDesc, 5, kSerializerArr[5], self.properties);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 6) || self.intent != Intent.CONVERSATION_START) {
            output.encodeSerializableElement(serialDesc, 6, kSerializerArr[6], self.intent);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 7) || self.signedCampaignData != null) {
            output.encodeNullableSerializableElement(serialDesc, 7, StringSerializer.INSTANCE, self.signedCampaignData);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 8) || self.messages != null) {
            output.encodeNullableSerializableElement(serialDesc, 8, kSerializerArr[8], self.messages);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 9) || self.postback != null) {
            output.encodeNullableSerializableElement(serialDesc, 9, PostbackDto$$serializer.INSTANCE, self.postback);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 10) && self.conversation == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 10, CreateConversationRequestDto$$serializer.INSTANCE, self.conversation);
    }

    public final ClientDto getClient() {
        return this.client;
    }

    public final String getUserId() {
        return this.userId;
    }

    public final String getGivenName() {
        return this.givenName;
    }

    public final String getSurname() {
        return this.surname;
    }

    public final String getEmail() {
        return this.email;
    }

    public final Map<String, Object> getProperties() {
        return this.properties;
    }

    public AppUserRequestDto(ClientDto clientDto, String str, String str2, String str3, String str4, Map map, Intent intent, String str5, List list, PostbackDto postbackDto, CreateConversationRequestDto createConversationRequestDto, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(clientDto, (i & 2) != 0 ? null : str, (i & 4) != 0 ? null : str2, (i & 8) != 0 ? null : str3, (i & 16) != 0 ? null : str4, (i & 32) != 0 ? null : map, (i & 64) != 0 ? Intent.CONVERSATION_START : intent, (i & 128) != 0 ? null : str5, (i & 256) != 0 ? null : list, (i & 512) != 0 ? null : postbackDto, (i & 1024) == 0 ? createConversationRequestDto : null);
    }

    public final Intent getIntent() {
        return this.intent;
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

    public final CreateConversationRequestDto getConversation() {
        return this.conversation;
    }
}
