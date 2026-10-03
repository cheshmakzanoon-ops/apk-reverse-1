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
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000\\\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 22\u00020\u0001:\u000212B]\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\u0014\u0010\r\u001a\u0010\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f\u0018\u00010\u000e\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0012B?\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000e¢\u0006\u0002\u0010\u0013J\t\u0010\u001e\u001a\u00020\u0005HÆ\u0003J\u000f\u0010\u001f\u001a\b\u0012\u0004\u0012\u00020\b0\u0007HÆ\u0003J\t\u0010 \u001a\u00020\nHÆ\u0003J\t\u0010!\u001a\u00020\fHÆ\u0003J\u0015\u0010\"\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000eHÆ\u0003JM\u0010#\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\u0014\b\u0002\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000eHÆ\u0001J\u0013\u0010$\u001a\u00020%2\b\u0010&\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010'\u001a\u00020\u0003HÖ\u0001J\t\u0010(\u001a\u00020\u000fHÖ\u0001J&\u0010)\u001a\u00020*2\u0006\u0010+\u001a\u00020\u00002\u0006\u0010,\u001a\u00020-2\u0006\u0010.\u001a\u00020/HÁ\u0001¢\u0006\u0002\b0R\u0011\u0010\u000b\u001a\u00020\f¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u001d\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0017\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001d¨\u00063"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ConversationsResponseDto;", "", "seen1", "", "settings", "Lzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;", "conversations", "", "Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "conversationsPagination", "Lzendesk/conversationkit/android/internal/rest/model/ConversationsPaginationDto;", "appUser", "Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "appUsers", "", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/ConversationsPaginationDto;Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/ConversationsPaginationDto;Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;Ljava/util/Map;)V", "getAppUser", "()Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "getAppUsers", "()Ljava/util/Map;", "getConversations", "()Ljava/util/List;", "getConversationsPagination", "()Lzendesk/conversationkit/android/internal/rest/model/ConversationsPaginationDto;", "getSettings", "()Lzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ConversationsResponseDto {
    private final AppUserDto appUser;
    private final Map<String, AppUserDto> appUsers;
    private final List<ConversationDto> conversations;
    private final ConversationsPaginationDto conversationsPagination;
    private final UserSettingsDto settings;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, new ArrayListSerializer(ConversationDto$$serializer.INSTANCE), null, null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, AppUserDto$$serializer.INSTANCE)};

    public static ConversationsResponseDto copy$default(ConversationsResponseDto conversationsResponseDto, UserSettingsDto userSettingsDto, List list, ConversationsPaginationDto conversationsPaginationDto, AppUserDto appUserDto, Map map, int i, Object obj) {
        if ((i & 1) != 0) {
            userSettingsDto = conversationsResponseDto.settings;
        }
        if ((i & 2) != 0) {
            list = conversationsResponseDto.conversations;
        }
        List list2 = list;
        if ((i & 4) != 0) {
            conversationsPaginationDto = conversationsResponseDto.conversationsPagination;
        }
        ConversationsPaginationDto conversationsPaginationDto2 = conversationsPaginationDto;
        if ((i & 8) != 0) {
            appUserDto = conversationsResponseDto.appUser;
        }
        AppUserDto appUserDto2 = appUserDto;
        if ((i & 16) != 0) {
            map = conversationsResponseDto.appUsers;
        }
        return conversationsResponseDto.copy(userSettingsDto, list2, conversationsPaginationDto2, appUserDto2, map);
    }

    public final UserSettingsDto getSettings() {
        return this.settings;
    }

    public final List<ConversationDto> component2() {
        return this.conversations;
    }

    public final ConversationsPaginationDto getConversationsPagination() {
        return this.conversationsPagination;
    }

    public final AppUserDto getAppUser() {
        return this.appUser;
    }

    public final Map<String, AppUserDto> component5() {
        return this.appUsers;
    }

    public final ConversationsResponseDto copy(UserSettingsDto settings, List<ConversationDto> conversations, ConversationsPaginationDto conversationsPagination, AppUserDto appUser, Map<String, AppUserDto> appUsers) {
        Intrinsics.checkNotNullParameter(settings, "settings");
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(conversationsPagination, "conversationsPagination");
        Intrinsics.checkNotNullParameter(appUser, "appUser");
        Intrinsics.checkNotNullParameter(appUsers, "appUsers");
        return new ConversationsResponseDto(settings, conversations, conversationsPagination, appUser, appUsers);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationsResponseDto)) {
            return false;
        }
        ConversationsResponseDto conversationsResponseDto = (ConversationsResponseDto) other;
        return Intrinsics.areEqual(this.settings, conversationsResponseDto.settings) && Intrinsics.areEqual(this.conversations, conversationsResponseDto.conversations) && Intrinsics.areEqual(this.conversationsPagination, conversationsResponseDto.conversationsPagination) && Intrinsics.areEqual(this.appUser, conversationsResponseDto.appUser) && Intrinsics.areEqual(this.appUsers, conversationsResponseDto.appUsers);
    }

    public int hashCode() {
        return (((((((this.settings.hashCode() * 31) + this.conversations.hashCode()) * 31) + this.conversationsPagination.hashCode()) * 31) + this.appUser.hashCode()) * 31) + this.appUsers.hashCode();
    }

    public String toString() {
        return "ConversationsResponseDto(settings=" + this.settings + ", conversations=" + this.conversations + ", conversationsPagination=" + this.conversationsPagination + ", appUser=" + this.appUser + ", appUsers=" + this.appUsers + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ConversationsResponseDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ConversationsResponseDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ConversationsResponseDto> serializer() {
            return ConversationsResponseDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ConversationsResponseDto(int i, UserSettingsDto userSettingsDto, List list, ConversationsPaginationDto conversationsPaginationDto, AppUserDto appUserDto, Map map, SerializationConstructorMarker serializationConstructorMarker) {
        if (31 != (i & 31)) {
            PluginExceptionsKt.throwMissingFieldException(i, 31, ConversationsResponseDto$$serializer.INSTANCE.getDescriptor());
        }
        this.settings = userSettingsDto;
        this.conversations = list;
        this.conversationsPagination = conversationsPaginationDto;
        this.appUser = appUserDto;
        this.appUsers = map;
    }

    public ConversationsResponseDto(UserSettingsDto settings, List<ConversationDto> conversations, ConversationsPaginationDto conversationsPagination, AppUserDto appUser, Map<String, AppUserDto> appUsers) {
        Intrinsics.checkNotNullParameter(settings, "settings");
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(conversationsPagination, "conversationsPagination");
        Intrinsics.checkNotNullParameter(appUser, "appUser");
        Intrinsics.checkNotNullParameter(appUsers, "appUsers");
        this.settings = settings;
        this.conversations = conversations;
        this.conversationsPagination = conversationsPagination;
        this.appUser = appUser;
        this.appUsers = appUsers;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(ConversationsResponseDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeSerializableElement(serialDesc, 0, UserSettingsDto$$serializer.INSTANCE, self.settings);
        output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.conversations);
        output.encodeSerializableElement(serialDesc, 2, ConversationsPaginationDto$$serializer.INSTANCE, self.conversationsPagination);
        output.encodeSerializableElement(serialDesc, 3, AppUserDto$$serializer.INSTANCE, self.appUser);
        output.encodeSerializableElement(serialDesc, 4, kSerializerArr[4], self.appUsers);
    }

    public final UserSettingsDto getSettings() {
        return this.settings;
    }

    public final List<ConversationDto> getConversations() {
        return this.conversations;
    }

    public final ConversationsPaginationDto getConversationsPagination() {
        return this.conversationsPagination;
    }

    public final AppUserDto getAppUser() {
        return this.appUser;
    }

    public final Map<String, AppUserDto> getAppUsers() {
        return this.appUsers;
    }
}
