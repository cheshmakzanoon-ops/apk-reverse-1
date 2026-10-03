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

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\b\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0018\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 62\u00020\u0001:\u000256Bs\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u000e\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010¢\u0006\u0002\u0010\u0011Ba\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\b\u001a\u00020\u0005\u0012\u0006\u0010\t\u001a\u00020\u0005\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\u0002\u0010\u0012J\t\u0010\u001e\u001a\u00020\u0005HÆ\u0003J\u000b\u0010\u001f\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010 \u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010!\u001a\u00020\u0005HÆ\u0003J\t\u0010\"\u001a\u00020\u0005HÆ\u0003J\u000b\u0010#\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010$\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010%\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010&\u001a\u0004\u0018\u00010\u000eHÆ\u0003Jo\u0010'\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\b\u001a\u00020\u00052\b\b\u0002\u0010\t\u001a\u00020\u00052\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\f\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u000eHÆ\u0001J\u0013\u0010(\u001a\u00020)2\b\u0010*\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010+\u001a\u00020\u0003HÖ\u0001J\t\u0010,\u001a\u00020\u0005HÖ\u0001J&\u0010-\u001a\u00020.2\u0006\u0010/\u001a\u00020\u00002\u0006\u00100\u001a\u0002012\u0006\u00102\u001a\u000203HÁ\u0001¢\u0006\u0002\b4R\u0013\u0010\u000b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0013\u0010\f\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0014R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0014R\u0013\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0011\u0010\t\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0014R\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0014R\u0011\u0010\b\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0014R\u0013\u0010\n\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u0014R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u0014¨\u00067"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "", "seen1", "", "id", "", "status", "lastSeen", "platform", "integrationId", "pushNotificationToken", "appVersion", "displayName", "info", "Lzendesk/conversationkit/android/internal/rest/model/ClientInfoDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ClientInfoDto;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/rest/model/ClientInfoDto;)V", "getAppVersion", "()Ljava/lang/String;", "getDisplayName", "getId", "getInfo", "()Lzendesk/conversationkit/android/internal/rest/model/ClientInfoDto;", "getIntegrationId", "getLastSeen", "getPlatform", "getPushNotificationToken", "getStatus", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ClientDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String appVersion;
    private final String displayName;
    private final String id;
    private final ClientInfoDto info;
    private final String integrationId;
    private final String lastSeen;
    private final String platform;
    private final String pushNotificationToken;
    private final String status;

    public final String getId() {
        return this.id;
    }

    public final String getStatus() {
        return this.status;
    }

    public final String getLastSeen() {
        return this.lastSeen;
    }

    public final String getPlatform() {
        return this.platform;
    }

    public final String getIntegrationId() {
        return this.integrationId;
    }

    public final String getPushNotificationToken() {
        return this.pushNotificationToken;
    }

    public final String getAppVersion() {
        return this.appVersion;
    }

    public final String getDisplayName() {
        return this.displayName;
    }

    public final ClientInfoDto getInfo() {
        return this.info;
    }

    public final ClientDto copy(String id, String status, String lastSeen, String platform, String integrationId, String pushNotificationToken, String appVersion, String displayName, ClientInfoDto info) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(platform, "platform");
        Intrinsics.checkNotNullParameter(integrationId, "integrationId");
        return new ClientDto(id, status, lastSeen, platform, integrationId, pushNotificationToken, appVersion, displayName, info);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ClientDto)) {
            return false;
        }
        ClientDto clientDto = (ClientDto) other;
        return Intrinsics.areEqual(this.id, clientDto.id) && Intrinsics.areEqual(this.status, clientDto.status) && Intrinsics.areEqual(this.lastSeen, clientDto.lastSeen) && Intrinsics.areEqual(this.platform, clientDto.platform) && Intrinsics.areEqual(this.integrationId, clientDto.integrationId) && Intrinsics.areEqual(this.pushNotificationToken, clientDto.pushNotificationToken) && Intrinsics.areEqual(this.appVersion, clientDto.appVersion) && Intrinsics.areEqual(this.displayName, clientDto.displayName) && Intrinsics.areEqual(this.info, clientDto.info);
    }

    public int hashCode() {
        int iHashCode = this.id.hashCode() * 31;
        String str = this.status;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.lastSeen;
        int iHashCode3 = (((((iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31) + this.platform.hashCode()) * 31) + this.integrationId.hashCode()) * 31;
        String str3 = this.pushNotificationToken;
        int iHashCode4 = (iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31;
        String str4 = this.appVersion;
        int iHashCode5 = (iHashCode4 + (str4 == null ? 0 : str4.hashCode())) * 31;
        String str5 = this.displayName;
        int iHashCode6 = (iHashCode5 + (str5 == null ? 0 : str5.hashCode())) * 31;
        ClientInfoDto clientInfoDto = this.info;
        return iHashCode6 + (clientInfoDto != null ? clientInfoDto.hashCode() : 0);
    }

    public String toString() {
        return "ClientDto(id=" + this.id + ", status=" + this.status + ", lastSeen=" + this.lastSeen + ", platform=" + this.platform + ", integrationId=" + this.integrationId + ", pushNotificationToken=" + this.pushNotificationToken + ", appVersion=" + this.appVersion + ", displayName=" + this.displayName + ", info=" + this.info + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ClientDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ClientDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ClientDto> serializer() {
            return ClientDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ClientDto(int i, String str, String str2, String str3, String str4, String str5, String str6, String str7, String str8, ClientInfoDto clientInfoDto, SerializationConstructorMarker serializationConstructorMarker) {
        if (121 != (i & 121)) {
            PluginExceptionsKt.throwMissingFieldException(i, 121, ClientDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        if ((i & 2) == 0) {
            this.status = null;
        } else {
            this.status = str2;
        }
        if ((i & 4) == 0) {
            this.lastSeen = null;
        } else {
            this.lastSeen = str3;
        }
        this.platform = str4;
        this.integrationId = str5;
        this.pushNotificationToken = str6;
        this.appVersion = str7;
        if ((i & 128) == 0) {
            this.displayName = null;
        } else {
            this.displayName = str8;
        }
        if ((i & 256) == 0) {
            this.info = null;
        } else {
            this.info = clientInfoDto;
        }
    }

    public ClientDto(String id, String str, String str2, String platform, String integrationId, String str3, String str4, String str5, ClientInfoDto clientInfoDto) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(platform, "platform");
        Intrinsics.checkNotNullParameter(integrationId, "integrationId");
        this.id = id;
        this.status = str;
        this.lastSeen = str2;
        this.platform = platform;
        this.integrationId = integrationId;
        this.pushNotificationToken = str3;
        this.appVersion = str4;
        this.displayName = str5;
        this.info = clientInfoDto;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(ClientDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.id);
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.status != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.status);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.lastSeen != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.lastSeen);
        }
        output.encodeStringElement(serialDesc, 3, self.platform);
        output.encodeStringElement(serialDesc, 4, self.integrationId);
        output.encodeNullableSerializableElement(serialDesc, 5, StringSerializer.INSTANCE, self.pushNotificationToken);
        output.encodeNullableSerializableElement(serialDesc, 6, StringSerializer.INSTANCE, self.appVersion);
        if (output.shouldEncodeElementDefault(serialDesc, 7) || self.displayName != null) {
            output.encodeNullableSerializableElement(serialDesc, 7, StringSerializer.INSTANCE, self.displayName);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 8) && self.info == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 8, ClientInfoDto$$serializer.INSTANCE, self.info);
    }

    public ClientDto(String str, String str2, String str3, String str4, String str5, String str6, String str7, String str8, ClientInfoDto clientInfoDto, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : str3, str4, str5, str6, str7, (i & 128) != 0 ? null : str8, (i & 256) != 0 ? null : clientInfoDto);
    }

    public final String getId() {
        return this.id;
    }

    public final String getStatus() {
        return this.status;
    }

    public final String getLastSeen() {
        return this.lastSeen;
    }

    public final String getPlatform() {
        return this.platform;
    }

    public final String getIntegrationId() {
        return this.integrationId;
    }

    public final String getPushNotificationToken() {
        return this.pushNotificationToken;
    }

    public final String getAppVersion() {
        return this.appVersion;
    }

    public final String getDisplayName() {
        return this.displayName;
    }

    public final ClientInfoDto getInfo() {
        return this.info;
    }
}
