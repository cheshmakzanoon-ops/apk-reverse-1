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

@Metadata(m17d1 = {"\u0000^\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 62\u00020\u0001:\u000256Bg\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\u0006\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\u0014\u0010\r\u001a\u0010\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f\u0018\u00010\u000e\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012¢\u0006\u0002\u0010\u0013BI\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\f\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007\u0012\u0006\u0010\t\u001a\u00020\n\u0012\u0006\u0010\u000b\u001a\u00020\f\u0012\u0012\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000e\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u000f¢\u0006\u0002\u0010\u0014J\t\u0010!\u001a\u00020\u0005HÆ\u0003J\u000f\u0010\"\u001a\b\u0012\u0004\u0012\u00020\b0\u0007HÆ\u0003J\t\u0010#\u001a\u00020\nHÆ\u0003J\t\u0010$\u001a\u00020\fHÆ\u0003J\u0015\u0010%\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000eHÆ\u0003J\u000b\u0010&\u001a\u0004\u0018\u00010\u000fHÆ\u0003JY\u0010'\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u000e\b\u0002\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\b\b\u0002\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\f2\u0014\b\u0002\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000e2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u000fHÆ\u0001J\u0013\u0010(\u001a\u00020)2\b\u0010*\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010+\u001a\u00020\u0003HÖ\u0001J\t\u0010,\u001a\u00020\u000fHÖ\u0001J&\u0010-\u001a\u00020.2\u0006\u0010/\u001a\u00020\u00002\u0006\u00100\u001a\u0002012\u0006\u00102\u001a\u000203HÁ\u0001¢\u0006\u0002\b4R\u0011\u0010\u000b\u001a\u00020\f¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u001d\u0010\r\u001a\u000e\u0012\u0004\u0012\u00020\u000f\u0012\u0004\u0012\u00020\f0\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0017\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0011\u0010\t\u001a\u00020\n¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0013\u0010\u0010\u001a\u0004\u0018\u00010\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 ¨\u00067"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/AppUserResponseDto;", "", "seen1", "", "settings", "Lzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;", "conversations", "", "Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "conversationsPagination", "Lzendesk/conversationkit/android/internal/rest/model/ConversationsPaginationDto;", "appUser", "Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "appUsers", "", "", "sessionToken", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/ConversationsPaginationDto;Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;Ljava/util/Map;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;Ljava/util/List;Lzendesk/conversationkit/android/internal/rest/model/ConversationsPaginationDto;Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;Ljava/util/Map;Ljava/lang/String;)V", "getAppUser", "()Lzendesk/conversationkit/android/internal/rest/model/AppUserDto;", "getAppUsers", "()Ljava/util/Map;", "getConversations", "()Ljava/util/List;", "getConversationsPagination", "()Lzendesk/conversationkit/android/internal/rest/model/ConversationsPaginationDto;", "getSessionToken", "()Ljava/lang/String;", "getSettings", "()Lzendesk/conversationkit/android/internal/rest/model/UserSettingsDto;", "component1", "component2", "component3", "component4", "component5", "component6", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class AppUserResponseDto {
    private final AppUserDto appUser;
    private final Map<String, AppUserDto> appUsers;
    private final List<ConversationDto> conversations;
    private final ConversationsPaginationDto conversationsPagination;
    private final String sessionToken;
    private final UserSettingsDto settings;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, new ArrayListSerializer(ConversationDto$$serializer.INSTANCE), null, null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, AppUserDto$$serializer.INSTANCE), null};

    public static AppUserResponseDto copy$default(AppUserResponseDto appUserResponseDto, UserSettingsDto userSettingsDto, List list, ConversationsPaginationDto conversationsPaginationDto, AppUserDto appUserDto, Map map, String str, int i, Object obj) {
        if ((i & 1) != 0) {
            userSettingsDto = appUserResponseDto.settings;
        }
        if ((i & 2) != 0) {
            list = appUserResponseDto.conversations;
        }
        List list2 = list;
        if ((i & 4) != 0) {
            conversationsPaginationDto = appUserResponseDto.conversationsPagination;
        }
        ConversationsPaginationDto conversationsPaginationDto2 = conversationsPaginationDto;
        if ((i & 8) != 0) {
            appUserDto = appUserResponseDto.appUser;
        }
        AppUserDto appUserDto2 = appUserDto;
        if ((i & 16) != 0) {
            map = appUserResponseDto.appUsers;
        }
        Map map2 = map;
        if ((i & 32) != 0) {
            str = appUserResponseDto.sessionToken;
        }
        return appUserResponseDto.copy(userSettingsDto, list2, conversationsPaginationDto2, appUserDto2, map2, str);
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

    public final String getSessionToken() {
        return this.sessionToken;
    }

    public final AppUserResponseDto copy(UserSettingsDto settings, List<ConversationDto> conversations, ConversationsPaginationDto conversationsPagination, AppUserDto appUser, Map<String, AppUserDto> appUsers, String sessionToken) {
        Intrinsics.checkNotNullParameter(settings, "settings");
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(conversationsPagination, "conversationsPagination");
        Intrinsics.checkNotNullParameter(appUser, "appUser");
        Intrinsics.checkNotNullParameter(appUsers, "appUsers");
        return new AppUserResponseDto(settings, conversations, conversationsPagination, appUser, appUsers, sessionToken);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AppUserResponseDto)) {
            return false;
        }
        AppUserResponseDto appUserResponseDto = (AppUserResponseDto) other;
        return Intrinsics.areEqual(this.settings, appUserResponseDto.settings) && Intrinsics.areEqual(this.conversations, appUserResponseDto.conversations) && Intrinsics.areEqual(this.conversationsPagination, appUserResponseDto.conversationsPagination) && Intrinsics.areEqual(this.appUser, appUserResponseDto.appUser) && Intrinsics.areEqual(this.appUsers, appUserResponseDto.appUsers) && Intrinsics.areEqual(this.sessionToken, appUserResponseDto.sessionToken);
    }

    public int hashCode() {
        int iHashCode = ((((((((this.settings.hashCode() * 31) + this.conversations.hashCode()) * 31) + this.conversationsPagination.hashCode()) * 31) + this.appUser.hashCode()) * 31) + this.appUsers.hashCode()) * 31;
        String str = this.sessionToken;
        return iHashCode + (str == null ? 0 : str.hashCode());
    }

    public String toString() {
        return "AppUserResponseDto(settings=" + this.settings + ", conversations=" + this.conversations + ", conversationsPagination=" + this.conversationsPagination + ", appUser=" + this.appUser + ", appUsers=" + this.appUsers + ", sessionToken=" + this.sessionToken + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/AppUserResponseDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/AppUserResponseDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<AppUserResponseDto> serializer() {
            return AppUserResponseDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public AppUserResponseDto(int i, UserSettingsDto userSettingsDto, List list, ConversationsPaginationDto conversationsPaginationDto, AppUserDto appUserDto, Map map, String str, SerializationConstructorMarker serializationConstructorMarker) {
        if (63 != (i & 63)) {
            PluginExceptionsKt.throwMissingFieldException(i, 63, AppUserResponseDto$$serializer.INSTANCE.getDescriptor());
        }
        this.settings = userSettingsDto;
        this.conversations = list;
        this.conversationsPagination = conversationsPaginationDto;
        this.appUser = appUserDto;
        this.appUsers = map;
        this.sessionToken = str;
    }

    public AppUserResponseDto(UserSettingsDto settings, List<ConversationDto> conversations, ConversationsPaginationDto conversationsPagination, AppUserDto appUser, Map<String, AppUserDto> appUsers, String str) {
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
        this.sessionToken = str;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(AppUserResponseDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeSerializableElement(serialDesc, 0, UserSettingsDto$$serializer.INSTANCE, self.settings);
        output.encodeSerializableElement(serialDesc, 1, kSerializerArr[1], self.conversations);
        output.encodeSerializableElement(serialDesc, 2, ConversationsPaginationDto$$serializer.INSTANCE, self.conversationsPagination);
        output.encodeSerializableElement(serialDesc, 3, AppUserDto$$serializer.INSTANCE, self.appUser);
        output.encodeSerializableElement(serialDesc, 4, kSerializerArr[4], self.appUsers);
        output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.sessionToken);
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

    public final String getSessionToken() {
        return this.sessionToken;
    }
}
