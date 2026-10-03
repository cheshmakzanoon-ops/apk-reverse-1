package zendesk.conversationkit.android.internal.rest.user.model;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import zendesk.conversationkit.android.internal.rest.model.ClientDto;
import zendesk.conversationkit.android.internal.rest.model.ClientDto$$serializer;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0013\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 ,2\u00020\u0001:\u0002+,BI\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\n\b\u0001\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB-\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\rJ\t\u0010\u0019\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0007HÆ\u0003J\u000b\u0010\u001b\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010\u001c\u001a\u0004\u0018\u00010\u0005HÆ\u0003J5\u0010\u001d\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u001e\u001a\u00020\u001f2\b\u0010 \u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010!\u001a\u00020\u0003HÖ\u0001J\t\u0010\"\u001a\u00020\u0005HÖ\u0001J&\u0010#\u001a\u00020$2\u0006\u0010%\u001a\u00020\u00002\u0006\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020)HÁ\u0001¢\u0006\u0002\b*R\u001e\u0010\b\u001a\u0004\u0018\u00010\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u000e\u0010\u000f\u001a\u0004\b\u0010\u0010\u0011R\u001c\u0010\u0006\u001a\u00020\u00078\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0012\u0010\u000f\u001a\u0004\b\u0013\u0010\u0014R\u001e\u0010\t\u001a\u0004\u0018\u00010\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0015\u0010\u000f\u001a\u0004\b\u0016\u0010\u0011R\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0017\u0010\u000f\u001a\u0004\b\u0018\u0010\u0011¨\u0006-"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/user/model/LoginRequestBody;", "", "seen1", "", "userId", "", "client", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "appUserId", "sessionToken", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ClientDto;Ljava/lang/String;Ljava/lang/String;)V", "getAppUserId$annotations", "()V", "getAppUserId", "()Ljava/lang/String;", "getClient$annotations", "getClient", "()Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "getSessionToken$annotations", "getSessionToken", "getUserId$annotations", "getUserId", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class LoginRequestBody {

    public static final Companion INSTANCE = new Companion(null);
    private final String appUserId;
    private final ClientDto client;
    private final String sessionToken;
    private final String userId;

    public static LoginRequestBody copy$default(LoginRequestBody loginRequestBody, String str, ClientDto clientDto, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = loginRequestBody.userId;
        }
        if ((i & 2) != 0) {
            clientDto = loginRequestBody.client;
        }
        if ((i & 4) != 0) {
            str2 = loginRequestBody.appUserId;
        }
        if ((i & 8) != 0) {
            str3 = loginRequestBody.sessionToken;
        }
        return loginRequestBody.copy(str, clientDto, str2, str3);
    }

    @SerialName("appUserId")
    public static void getAppUserId$annotations() {
    }

    @SerialName("client")
    public static void getClient$annotations() {
    }

    @SerialName("sessionToken")
    public static void getSessionToken$annotations() {
    }

    @SerialName("userId")
    public static void getUserId$annotations() {
    }

    public final String getUserId() {
        return this.userId;
    }

    public final ClientDto getClient() {
        return this.client;
    }

    public final String getAppUserId() {
        return this.appUserId;
    }

    public final String getSessionToken() {
        return this.sessionToken;
    }

    public final LoginRequestBody copy(String userId, ClientDto client, String appUserId, String sessionToken) {
        Intrinsics.checkNotNullParameter(userId, "userId");
        Intrinsics.checkNotNullParameter(client, "client");
        return new LoginRequestBody(userId, client, appUserId, sessionToken);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof LoginRequestBody)) {
            return false;
        }
        LoginRequestBody loginRequestBody = (LoginRequestBody) other;
        return Intrinsics.areEqual(this.userId, loginRequestBody.userId) && Intrinsics.areEqual(this.client, loginRequestBody.client) && Intrinsics.areEqual(this.appUserId, loginRequestBody.appUserId) && Intrinsics.areEqual(this.sessionToken, loginRequestBody.sessionToken);
    }

    public int hashCode() {
        int iHashCode = ((this.userId.hashCode() * 31) + this.client.hashCode()) * 31;
        String str = this.appUserId;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.sessionToken;
        return iHashCode2 + (str2 != null ? str2.hashCode() : 0);
    }

    public String toString() {
        return "LoginRequestBody(userId=" + this.userId + ", client=" + this.client + ", appUserId=" + this.appUserId + ", sessionToken=" + this.sessionToken + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/user/model/LoginRequestBody$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/user/model/LoginRequestBody;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<LoginRequestBody> serializer() {
            return LoginRequestBody$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public LoginRequestBody(int i, @SerialName("userId") String str, @SerialName("client") ClientDto clientDto, @SerialName("appUserId") String str2, @SerialName("sessionToken") String str3, SerializationConstructorMarker serializationConstructorMarker) {
        if (3 != (i & 3)) {
            PluginExceptionsKt.throwMissingFieldException(i, 3, LoginRequestBody$$serializer.INSTANCE.getDescriptor());
        }
        this.userId = str;
        this.client = clientDto;
        if ((i & 4) == 0) {
            this.appUserId = null;
        } else {
            this.appUserId = str2;
        }
        if ((i & 8) == 0) {
            this.sessionToken = null;
        } else {
            this.sessionToken = str3;
        }
    }

    public LoginRequestBody(String userId, ClientDto client, String str, String str2) {
        Intrinsics.checkNotNullParameter(userId, "userId");
        Intrinsics.checkNotNullParameter(client, "client");
        this.userId = userId;
        this.client = client;
        this.appUserId = str;
        this.sessionToken = str2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(LoginRequestBody self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.userId);
        output.encodeSerializableElement(serialDesc, 1, ClientDto$$serializer.INSTANCE, self.client);
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.appUserId != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.appUserId);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 3) && self.sessionToken == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.sessionToken);
    }

    public LoginRequestBody(String str, ClientDto clientDto, String str2, String str3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, clientDto, (i & 4) != 0 ? null : str2, (i & 8) != 0 ? null : str3);
    }

    public final String getUserId() {
        return this.userId;
    }

    public final ClientDto getClient() {
        return this.client;
    }

    public final String getAppUserId() {
        return this.appUserId;
    }

    public final String getSessionToken() {
        return this.sessionToken;
    }
}
