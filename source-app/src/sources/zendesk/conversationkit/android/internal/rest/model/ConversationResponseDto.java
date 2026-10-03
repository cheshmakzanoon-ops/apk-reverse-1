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
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.BooleanSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000T\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0019\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 32\u00020\u0001:\u000223B]\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\u0014\u0010\r\u001a\u0010\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f\u0018\u00010\u000e\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0012BC\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000e¢\u0006\u0002\u0010\u0013J\t\u0010\u001f\u001a\u00020\u0005HÆ\u0003J\u0011\u0010 \u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007HÆ\u0003J\u0010\u0010!\u001a\u0004\u0018\u00010\nHÆ\u0003¢\u0006\u0002\u0010\u001bJ\t\u0010\"\u001a\u00020\fHÆ\u0003J\u0015\u0010#\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000eHÆ\u0003JV\u0010$\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u0010\b\u0002\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u00072\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\u0014\b\u0002\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000eHÆ\u0001¢\u0006\u0002\u0010%J\u0013\u0010&\u001a\u00020\n2\b\u0010'\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010(\u001a\u00020\u0003HÖ\u0001J\t\u0010)\u001a\u00020\u000fHÖ\u0001J&\u0010*\u001a\u00020+2\u0006\u0010,\u001a\u00020\u00002\u0006\u0010-\u001a\u00020.2\u0006\u0010/\u001a\u000200HÁ\u0001¢\u0006\u0002\b1R\u0011\u0010\u000b\u001a\u00020\f¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u001d\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0015\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\n\n\u0002\u0010\u001c\u001a\u0004\b\u001a\u0010\u001bR\u0019\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001e¨\u00064"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ConversationResponseDto;", "", "seen1", "", "conversation", "Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "messages", "", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "hasPrevious", "", "appUser", "Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "appUsers", "", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/internal/rest/model/ConversationDto;Ljava/util/List;Ljava/lang/Boolean;Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;Ljava/util/List;Ljava/lang/Boolean;Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;Ljava/util/Map;)V", "getAppUser", "()Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "getAppUsers", "()Ljava/util/Map;", "getConversation", "()Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "getHasPrevious", "()Ljava/lang/Boolean;", "Ljava/lang/Boolean;", "getMessages", "()Ljava/util/List;", "component1", "component2", "component3", "component4", "component5", "copy", "(Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;Ljava/util/List;Ljava/lang/Boolean;Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;Ljava/util/Map;)Lzendesk/conversationkit/android/internal/rest/model/ConversationResponseDto;", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ConversationResponseDto {
    private final AppUserDto appUser;
    private final Map<String, AppUserDto> appUsers;
    private final ConversationDto conversation;
    private final Boolean hasPrevious;
    private final List<MessageDto> messages;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, new ArrayListSerializer(MessageDto$$serializer.INSTANCE), null, null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, AppUserDto$$serializer.INSTANCE)};

    public static ConversationResponseDto copy$default(ConversationResponseDto conversationResponseDto, ConversationDto conversationDto, List list, Boolean bool, AppUserDto appUserDto, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            conversationDto = conversationResponseDto.conversation;
        }
        if ((i & 2) != 0) {
            list = conversationResponseDto.messages;
        }
        List list2 = list;
        if ((i & 4) != 0) {
            bool = conversationResponseDto.hasPrevious;
        }
        Boolean bool2 = bool;
        if ((i & 8) != 0) {
            appUserDto = conversationResponseDto.appUser;
        }
        AppUserDto appUserDto2 = appUserDto;
        if ((i & 16) != 0) {
            map = conversationResponseDto.appUsers;
        }
        return conversationResponseDto.copy(conversationDto, list2, bool2, appUserDto2, map);
    }

    public final ConversationDto getConversation() {
        return this.conversation;
    }

    public final List<MessageDto> component2() {
        return this.messages;
    }

    public final Boolean getHasPrevious() {
        return this.hasPrevious;
    }

    public final AppUserDto getAppUser() {
        return this.appUser;
    }

    public final Map<String, AppUserDto> component5() {
        return this.appUsers;
    }

    public final ConversationResponseDto copy(ConversationDto conversation, List<MessageDto> messages, Boolean hasPrevious, AppUserDto appUser, Map<String, AppUserDto> appUsers) {
        Intrinsics.checkNotNullParameter(conversation, "conversation");
        Intrinsics.checkNotNullParameter(appUser, "appUser");
        Intrinsics.checkNotNullParameter(appUsers, "appUsers");
        return new ConversationResponseDto(conversation, messages, hasPrevious, appUser, appUsers);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationResponseDto)) {
            return false;
        }
        ConversationResponseDto conversationResponseDto = (ConversationResponseDto) other;
        return Intrinsics.areEqual(this.conversation, conversationResponseDto.conversation) && Intrinsics.areEqual(this.messages, conversationResponseDto.messages) && Intrinsics.areEqual(this.hasPrevious, conversationResponseDto.hasPrevious) && Intrinsics.areEqual(this.appUser, conversationResponseDto.appUser) && Intrinsics.areEqual(this.appUsers, conversationResponseDto.appUsers);
    }

    public int hashCode() {
        int iHashCode = this.conversation.hashCode() * 31;
        List<MessageDto> list = this.messages;
        int iHashCode2 = (iHashCode + (list == null ? 0 : list.hashCode())) * 31;
        Boolean bool = this.hasPrevious;
        return ((((iHashCode2 + (bool != null ? bool.hashCode() : 0)) * 31) + this.appUser.hashCode()) * 31) + this.appUsers.hashCode();
    }

    public String toString() {
        return "ConversationResponseDto(conversation=" + this.conversation + ", messages=" + this.messages + ", hasPrevious=" + this.hasPrevious + ", appUser=" + this.appUser + ", appUsers=" + this.appUsers + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ConversationResponseDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ConversationResponseDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ConversationResponseDto> serializer() {
            return ConversationResponseDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ConversationResponseDto(int i, ConversationDto conversationDto, List list, Boolean bool, AppUserDto appUserDto, Map map, SerializationConstructorMarker serializationConstructorMarker) {
        if (31 != (i & 31)) {
            PluginExceptionsKt.throwMissingFieldException(i, 31, ConversationResponseDto$$serializer.INSTANCE.getDescriptor());
        }
        this.conversation = conversationDto;
        this.messages = list;
        this.hasPrevious = bool;
        this.appUser = appUserDto;
        this.appUsers = map;
    }

    public ConversationResponseDto(ConversationDto conversation, List<MessageDto> list, Boolean bool, AppUserDto appUser, Map<String, AppUserDto> appUsers) {
        Intrinsics.checkNotNullParameter(conversation, "conversation");
        Intrinsics.checkNotNullParameter(appUser, "appUser");
        Intrinsics.checkNotNullParameter(appUsers, "appUsers");
        this.conversation = conversation;
        this.messages = list;
        this.hasPrevious = bool;
        this.appUser = appUser;
        this.appUsers = appUsers;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(ConversationResponseDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeSerializableElement(serialDesc, 0, ConversationDto$$serializer.INSTANCE, self.conversation);
        output.encodeNullableSerializableElement(serialDesc, 1, kSerializerArr[1], self.messages);
        output.encodeNullableSerializableElement(serialDesc, 2, BooleanSerializer.INSTANCE, self.hasPrevious);
        output.encodeSerializableElement(serialDesc, 3, AppUserDto$$serializer.INSTANCE, self.appUser);
        output.encodeSerializableElement(serialDesc, 4, kSerializerArr[4], self.appUsers);
    }

    public final ConversationDto getConversation() {
        return this.conversation;
    }

    public final List<MessageDto> getMessages() {
        return this.messages;
    }

    public final Boolean getHasPrevious() {
        return this.hasPrevious;
    }

    public final AppUserDto getAppUser() {
        return this.appUser;
    }

    public final Map<String, AppUserDto> getAppUsers() {
        return this.appUsers;
    }
}
