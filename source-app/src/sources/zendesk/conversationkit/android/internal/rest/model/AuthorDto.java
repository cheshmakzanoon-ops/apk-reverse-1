package zendesk.conversationkit.android.internal.rest.model;

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
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000F\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 '2\u00020\u0001:\u0002&'BA\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB)\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\rJ\t\u0010\u0014\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0016\u001a\u00020\bHÆ\u0003J\u000b\u0010\u0017\u001a\u0004\u0018\u00010\u0005HÆ\u0003J3\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\b\b\u0002\u0010\u0007\u001a\u00020\b2\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001c\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001d\u001a\u00020\u0005HÖ\u0001J&\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020\u00002\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020$HÁ\u0001¢\u0006\u0002\b%R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u000fR\u0013\u0010\t\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000f¨\u0006("}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/AuthorDto;", "", "seen1", "", "appUserId", "", "role", "client", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "sessionId", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/lang/String;)V", "getAppUserId", "()Ljava/lang/String;", "getClient", "()Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "getRole", "getSessionId", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class AuthorDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String appUserId;
    private final ClientDto client;
    private final String role;
    private final String sessionId;

    public static AuthorDto copy$default(AuthorDto authorDto, String str, String str2, ClientDto clientDto, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = authorDto.appUserId;
        }
        if ((i & 2) != 0) {
            str2 = authorDto.role;
        }
        if ((i & 4) != 0) {
            clientDto = authorDto.client;
        }
        if ((i & 8) != 0) {
            str3 = authorDto.sessionId;
        }
        return authorDto.copy(str, str2, clientDto, str3);
    }

    public final String getAppUserId() {
        return this.appUserId;
    }

    public final String getRole() {
        return this.role;
    }

    public final ClientDto getClient() {
        return this.client;
    }

    public final String getSessionId() {
        return this.sessionId;
    }

    public final AuthorDto copy(String appUserId, String role, ClientDto client, String sessionId) {
        Intrinsics.checkNotNullParameter(appUserId, "appUserId");
        Intrinsics.checkNotNullParameter(role, "role");
        Intrinsics.checkNotNullParameter(client, "client");
        return new AuthorDto(appUserId, role, client, sessionId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AuthorDto)) {
            return false;
        }
        AuthorDto authorDto = (AuthorDto) other;
        return Intrinsics.areEqual(this.appUserId, authorDto.appUserId) && Intrinsics.areEqual(this.role, authorDto.role) && Intrinsics.areEqual(this.client, authorDto.client) && Intrinsics.areEqual(this.sessionId, authorDto.sessionId);
    }

    public int hashCode() {
        int iHashCode = ((((this.appUserId.hashCode() * 31) + this.role.hashCode()) * 31) + this.client.hashCode()) * 31;
        String str = this.sessionId;
        return iHashCode + (str == null ? 0 : str.hashCode());
    }

    public String toString() {
        return "AuthorDto(appUserId=" + this.appUserId + ", role=" + this.role + ", client=" + this.client + ", sessionId=" + this.sessionId + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/AuthorDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/AuthorDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<AuthorDto> serializer() {
            return AuthorDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public AuthorDto(int i, String str, String str2, ClientDto clientDto, String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if (7 != (i & 7)) {
            PluginExceptionsKt.throwMissingFieldException(i, 7, AuthorDto$$serializer.INSTANCE.getDescriptor());
        }
        this.appUserId = str;
        this.role = str2;
        this.client = clientDto;
        if ((i & 8) == 0) {
            this.sessionId = null;
        } else {
            this.sessionId = str3;
        }
    }

    public AuthorDto(String appUserId, String role, ClientDto client, String str) {
        Intrinsics.checkNotNullParameter(appUserId, "appUserId");
        Intrinsics.checkNotNullParameter(role, "role");
        Intrinsics.checkNotNullParameter(client, "client");
        this.appUserId = appUserId;
        this.role = role;
        this.client = client;
        this.sessionId = str;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(AuthorDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.appUserId);
        output.encodeStringElement(serialDesc, 1, self.role);
        output.encodeSerializableElement(serialDesc, 2, ClientDto$$serializer.INSTANCE, self.client);
        if (!output.shouldEncodeElementDefault(serialDesc, 3) && self.sessionId == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.sessionId);
    }

    public AuthorDto(String str, String str2, ClientDto clientDto, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, clientDto, (i & 8) != 0 ? null : str3);
    }

    public final String getAppUserId() {
        return this.appUserId;
    }

    public final String getRole() {
        return this.role;
    }

    public final ClientDto getClient() {
        return this.client;
    }

    public final String getSessionId() {
        return this.sessionId;
    }
}
