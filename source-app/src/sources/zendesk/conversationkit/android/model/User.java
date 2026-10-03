package zendesk.conversationkit.android.model;

import java.util.List;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.UByte$$ExternalSyntheticBackport0;
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

@Metadata(m17d1 = {"\u0000\\\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b'\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 L2\u00020\u0001:\u0002KLB\u009f\u0001\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\u000e\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\r\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010\u0012\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012\u0012\b\u0010\u0013\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0014\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0015\u001a\u00020\u0016\u0012\b\u0010\u0017\u001a\u0004\u0018\u00010\u0018¢\u0006\u0002\u0010\u0019B\u008b\u0001\b\u0000\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r\u0012\u0006\u0010\u000f\u001a\u00020\u0010\u0012\u0006\u0010\u0011\u001a\u00020\u0012\u0012\n\b\u0002\u0010\u0013\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0014\u001a\u0004\u0018\u00010\u0005\u0012\b\b\u0002\u0010\u0015\u001a\u00020\u0016¢\u0006\u0002\u0010\u001aJ\t\u0010-\u001a\u00020\u0005HÆ\u0003J\t\u0010.\u001a\u00020\u0012HÆ\u0003J\u0010\u0010/\u001a\u0004\u0018\u00010\u0005HÀ\u0003¢\u0006\u0002\b0J\u0010\u00101\u001a\u0004\u0018\u00010\u0005HÀ\u0003¢\u0006\u0002\b2J\t\u00103\u001a\u00020\u0016HÆ\u0003J\u000b\u00104\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u00105\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u00106\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u00107\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u00108\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u00109\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000f\u0010:\u001a\b\u0012\u0004\u0012\u00020\u000e0\rHÆ\u0003J\t\u0010;\u001a\u00020\u0010HÆ\u0003J¡\u0001\u0010<\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u00052\u000e\b\u0002\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r2\b\b\u0002\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\u0011\u001a\u00020\u00122\n\b\u0002\u0010\u0013\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0014\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0015\u001a\u00020\u0016HÆ\u0001J\u0013\u0010=\u001a\u00020\u00162\b\u0010>\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\u0006\u0010?\u001a\u00020@J\t\u0010A\u001a\u00020\u0003HÖ\u0001J\t\u0010B\u001a\u00020\u0005HÖ\u0001J&\u0010C\u001a\u00020D2\u0006\u0010E\u001a\u00020\u00002\u0006\u0010F\u001a\u00020G2\u0006\u0010H\u001a\u00020IHÁ\u0001¢\u0006\u0002\bJR\u0017\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u000e0\r¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0013\u0010\t\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u001eR\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u001eR\u0011\u0010\u0015\u001a\u00020\u0016¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b#\u0010\u001eR\u0016\u0010\u0014\u001a\u0004\u0018\u00010\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b$\u0010\u001eR\u0013\u0010\n\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b%\u0010\u001eR\u0011\u0010\u000f\u001a\u00020\u0010¢\u0006\b\n\u0000\u001a\u0004\b&\u0010'R\u0016\u0010\u0013\u001a\u0004\u0018\u00010\u0005X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b(\u0010\u001eR\u0013\u0010\u000b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b)\u0010\u001eR\u0013\u0010\b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b*\u0010\u001eR\u0011\u0010\u0011\u001a\u00020\u0012¢\u0006\b\n\u0000\u001a\u0004\b+\u0010,¨\u0006M"}, m18d2 = {"Lzendesk/conversationkit/android/model/User;", "", "seen1", "", "id", "", "externalId", "givenName", "surname", "email", "locale", "signedUpAt", "conversations", "", "Lzendesk/conversationkit/android/model/Conversation;", "realtimeSettings", "Lzendesk/conversationkit/android/model/RealtimeSettings;", "typingSettings", "Lzendesk/conversationkit/android/model/TypingSettings;", "sessionToken", "jwt", "hasMore", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/model/RealtimeSettings;Lzendesk/conversationkit/android/model/TypingSettings;Ljava/lang/String;Ljava/lang/String;ZLkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/util/List;Lzendesk/conversationkit/android/model/RealtimeSettings;Lzendesk/conversationkit/android/model/TypingSettings;Ljava/lang/String;Ljava/lang/String;Z)V", "getConversations", "()Ljava/util/List;", "getEmail", "()Ljava/lang/String;", "getExternalId", "getGivenName", "getHasMore", "()Z", "getId", "getJwt$zendesk_conversationkit_conversationkit_android", "getLocale", "getRealtimeSettings", "()Lzendesk/conversationkit/android/model/RealtimeSettings;", "getSessionToken$zendesk_conversationkit_conversationkit_android", "getSignedUpAt", "getSurname", "getTypingSettings", "()Lzendesk/conversationkit/android/model/TypingSettings;", "component1", "component10", "component11", "component11$zendesk_conversationkit_conversationkit_android", "component12", "component12$zendesk_conversationkit_conversationkit_android", "component13", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "other", "getAuthenticationType", "Lzendesk/conversationkit/android/model/AuthenticationType;", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class User {
    private final List<Conversation> conversations;
    private final String email;
    private final String externalId;
    private final String givenName;
    private final boolean hasMore;
    private final String id;
    private final String jwt;
    private final String locale;
    private final RealtimeSettings realtimeSettings;
    private final String sessionToken;
    private final String signedUpAt;
    private final String surname;
    private final TypingSettings typingSettings;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, null, null, null, new ArrayListSerializer(Conversation$$serializer.INSTANCE), null, null, null, null, null};

    public final String getId() {
        return this.id;
    }

    public final TypingSettings getTypingSettings() {
        return this.typingSettings;
    }

    public final String getSessionToken() {
        return this.sessionToken;
    }

    public final String getJwt() {
        return this.jwt;
    }

    public final boolean getHasMore() {
        return this.hasMore;
    }

    public final String getExternalId() {
        return this.externalId;
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

    public final String getLocale() {
        return this.locale;
    }

    public final String getSignedUpAt() {
        return this.signedUpAt;
    }

    public final List<Conversation> component8() {
        return this.conversations;
    }

    public final RealtimeSettings getRealtimeSettings() {
        return this.realtimeSettings;
    }

    public final User copy(String id, String externalId, String givenName, String surname, String email, String locale, String signedUpAt, List<Conversation> conversations, RealtimeSettings realtimeSettings, TypingSettings typingSettings, String sessionToken, String jwt, boolean hasMore) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(realtimeSettings, "realtimeSettings");
        Intrinsics.checkNotNullParameter(typingSettings, "typingSettings");
        return new User(id, externalId, givenName, surname, email, locale, signedUpAt, conversations, realtimeSettings, typingSettings, sessionToken, jwt, hasMore);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof User)) {
            return false;
        }
        User user = (User) other;
        return Intrinsics.areEqual(this.id, user.id) && Intrinsics.areEqual(this.externalId, user.externalId) && Intrinsics.areEqual(this.givenName, user.givenName) && Intrinsics.areEqual(this.surname, user.surname) && Intrinsics.areEqual(this.email, user.email) && Intrinsics.areEqual(this.locale, user.locale) && Intrinsics.areEqual(this.signedUpAt, user.signedUpAt) && Intrinsics.areEqual(this.conversations, user.conversations) && Intrinsics.areEqual(this.realtimeSettings, user.realtimeSettings) && Intrinsics.areEqual(this.typingSettings, user.typingSettings) && Intrinsics.areEqual(this.sessionToken, user.sessionToken) && Intrinsics.areEqual(this.jwt, user.jwt) && this.hasMore == user.hasMore;
    }

    public int hashCode() {
        int iHashCode = this.id.hashCode() * 31;
        String str = this.externalId;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.givenName;
        int iHashCode3 = (iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.surname;
        int iHashCode4 = (iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.email;
        int iHashCode5 = (iHashCode4 + (str4 == null ? 0 : str4.hashCode())) * 31;
        String str5 = this.locale;
        int iHashCode6 = (iHashCode5 + (str5 == null ? 0 : str5.hashCode())) * 31;
        String str6 = this.signedUpAt;
        int iHashCode7 = (((((((iHashCode6 + (str6 == null ? 0 : str6.hashCode())) * 31) + this.conversations.hashCode()) * 31) + this.realtimeSettings.hashCode()) * 31) + this.typingSettings.hashCode()) * 31;
        String str7 = this.sessionToken;
        int iHashCode8 = (iHashCode7 + (str7 == null ? 0 : str7.hashCode())) * 31;
        String str8 = this.jwt;
        return ((iHashCode8 + (str8 != null ? str8.hashCode() : 0)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.hasMore);
    }

    public String toString() {
        return "User(id=" + this.id + ", externalId=" + this.externalId + ", givenName=" + this.givenName + ", surname=" + this.surname + ", email=" + this.email + ", locale=" + this.locale + ", signedUpAt=" + this.signedUpAt + ", conversations=" + this.conversations + ", realtimeSettings=" + this.realtimeSettings + ", typingSettings=" + this.typingSettings + ", sessionToken=" + this.sessionToken + ", jwt=" + this.jwt + ", hasMore=" + this.hasMore + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/User$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/User;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<User> serializer() {
            return User$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public User(int i, String str, String str2, String str3, String str4, String str5, String str6, String str7, List list, RealtimeSettings realtimeSettings, TypingSettings typingSettings, String str8, String str9, boolean z, SerializationConstructorMarker serializationConstructorMarker) {
        if (1023 != (i & 1023)) {
            PluginExceptionsKt.throwMissingFieldException(i, 1023, User$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.externalId = str2;
        this.givenName = str3;
        this.surname = str4;
        this.email = str5;
        this.locale = str6;
        this.signedUpAt = str7;
        this.conversations = list;
        this.realtimeSettings = realtimeSettings;
        this.typingSettings = typingSettings;
        if ((i & 1024) == 0) {
            this.sessionToken = null;
        } else {
            this.sessionToken = str8;
        }
        if ((i & 2048) == 0) {
            this.jwt = null;
        } else {
            this.jwt = str9;
        }
        this.hasMore = (i & 4096) == 0 ? false : z;
    }

    public User(String id, String str, String str2, String str3, String str4, String str5, String str6, List<Conversation> conversations, RealtimeSettings realtimeSettings, TypingSettings typingSettings, String str7, String str8, boolean z) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(conversations, "conversations");
        Intrinsics.checkNotNullParameter(realtimeSettings, "realtimeSettings");
        Intrinsics.checkNotNullParameter(typingSettings, "typingSettings");
        this.id = id;
        this.externalId = str;
        this.givenName = str2;
        this.surname = str3;
        this.email = str4;
        this.locale = str5;
        this.signedUpAt = str6;
        this.conversations = conversations;
        this.realtimeSettings = realtimeSettings;
        this.typingSettings = typingSettings;
        this.sessionToken = str7;
        this.jwt = str8;
        this.hasMore = z;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(User self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.externalId);
        output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.givenName);
        output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.surname);
        output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.email);
        output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.locale);
        output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.signedUpAt);
        output.encodeSerializableElement(serialDesc, 7, kSerializerArr[7], self.conversations);
        output.encodeSerializableElement(serialDesc, 8, RealtimeSettings$$serializer.INSTANCE, self.realtimeSettings);
        output.encodeSerializableElement(serialDesc, 9, TypingSettings$$serializer.INSTANCE, self.typingSettings);
        if (output.shouldEncodeElementDefault(serialDesc, 10) || self.sessionToken != null) {
            output.encodeNullableSerializableElement(serialDesc, 10, StringSerializer.INSTANCE, self.sessionToken);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 11) || self.jwt != null) {
            output.encodeNullableSerializableElement(serialDesc, 11, StringSerializer.INSTANCE, self.jwt);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 12) || self.hasMore) {
            output.encodeBooleanElement(serialDesc, 12, self.hasMore);
        }
    }

    public User(String str, String str2, String str3, String str4, String str5, String str6, String str7, List list, RealtimeSettings realtimeSettings, TypingSettings typingSettings, String str8, String str9, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, str3, str4, str5, str6, str7, list, realtimeSettings, typingSettings, (i & 1024) != 0 ? null : str8, (i & 2048) != 0 ? null : str9, (i & 4096) != 0 ? false : z);
    }

    public final String getId() {
        return this.id;
    }

    public final String getExternalId() {
        return this.externalId;
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

    public final String getLocale() {
        return this.locale;
    }

    public final String getSignedUpAt() {
        return this.signedUpAt;
    }

    public final List<Conversation> getConversations() {
        return this.conversations;
    }

    public final RealtimeSettings getRealtimeSettings() {
        return this.realtimeSettings;
    }

    public final TypingSettings getTypingSettings() {
        return this.typingSettings;
    }

    public final String getSessionToken$zendesk_conversationkit_conversationkit_android() {
        return this.sessionToken;
    }

    public final String getJwt$zendesk_conversationkit_conversationkit_android() {
        return this.jwt;
    }

    public final boolean getHasMore() {
        return this.hasMore;
    }

    public final AuthenticationType getAuthenticationType() {
        if (this.jwt != null) {
            return new AuthenticationType.Jwt(this.jwt);
        }
        return this.sessionToken != null ? new AuthenticationType.SessionToken(this.sessionToken) : AuthenticationType.Unauthenticated.INSTANCE;
    }
}
