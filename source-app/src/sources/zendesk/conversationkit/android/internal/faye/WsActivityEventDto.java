package zendesk.conversationkit.android.internal.faye;

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
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000e\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 '2\u00020\u0001:\u0002&'BA\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB)\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\b\u001a\u00020\t¢\u0006\u0002\u0010\rJ\t\u0010\u0014\u001a\u00020\u0005HÆ\u0003J\t\u0010\u0015\u001a\u00020\u0005HÆ\u0003J\u000b\u0010\u0016\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010\u0017\u001a\u00020\tHÆ\u0003J3\u0010\u0018\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\b\u001a\u00020\tHÆ\u0001J\u0013\u0010\u0019\u001a\u00020\u001a2\b\u0010\u001b\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u001c\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001d\u001a\u00020\u0005HÖ\u0001J&\u0010\u001e\u001a\u00020\u001f2\u0006\u0010 \u001a\u00020\u00002\u0006\u0010!\u001a\u00020\"2\u0006\u0010#\u001a\u00020$HÁ\u0001¢\u0006\u0002\b%R\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u000fR\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000f¨\u0006("}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;", "", "seen1", "", "role", "", "type", "appUserId", Bayeux.KEY_DATA, "Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto;)V", "getAppUserId", "()Ljava/lang/String;", "getData", "()Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto;", "getRole", "getType", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class WsActivityEventDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String appUserId;
    private final WsActivityEventDataDto data;
    private final String role;
    private final String type;

    public static WsActivityEventDto copy$default(WsActivityEventDto wsActivityEventDto, String str, String str2, String str3, WsActivityEventDataDto wsActivityEventDataDto, int i, Object obj) {
        if ((i & 1) != 0) {
            str = wsActivityEventDto.role;
        }
        if ((i & 2) != 0) {
            str2 = wsActivityEventDto.type;
        }
        if ((i & 4) != 0) {
            str3 = wsActivityEventDto.appUserId;
        }
        if ((i & 8) != 0) {
            wsActivityEventDataDto = wsActivityEventDto.data;
        }
        return wsActivityEventDto.copy(str, str2, str3, wsActivityEventDataDto);
    }

    public final String getRole() {
        return this.role;
    }

    public final String getType() {
        return this.type;
    }

    public final String getAppUserId() {
        return this.appUserId;
    }

    public final WsActivityEventDataDto getData() {
        return this.data;
    }

    public final WsActivityEventDto copy(String role, String type, String appUserId, WsActivityEventDataDto data) {
        Intrinsics.checkNotNullParameter(role, "role");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(data, "data");
        return new WsActivityEventDto(role, type, appUserId, data);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WsActivityEventDto)) {
            return false;
        }
        WsActivityEventDto wsActivityEventDto = (WsActivityEventDto) other;
        return Intrinsics.areEqual(this.role, wsActivityEventDto.role) && Intrinsics.areEqual(this.type, wsActivityEventDto.type) && Intrinsics.areEqual(this.appUserId, wsActivityEventDto.appUserId) && Intrinsics.areEqual(this.data, wsActivityEventDto.data);
    }

    public int hashCode() {
        int iHashCode = ((this.role.hashCode() * 31) + this.type.hashCode()) * 31;
        String str = this.appUserId;
        return ((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + this.data.hashCode();
    }

    public String toString() {
        return "WsActivityEventDto(role=" + this.role + ", type=" + this.type + ", appUserId=" + this.appUserId + ", data=" + this.data + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/faye/WsActivityEventDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<WsActivityEventDto> serializer() {
            return WsActivityEventDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public WsActivityEventDto(int i, String str, String str2, String str3, WsActivityEventDataDto wsActivityEventDataDto, SerializationConstructorMarker serializationConstructorMarker) {
        if (11 != (i & 11)) {
            PluginExceptionsKt.throwMissingFieldException(i, 11, WsActivityEventDto$$serializer.INSTANCE.getDescriptor());
        }
        this.role = str;
        this.type = str2;
        if ((i & 4) == 0) {
            this.appUserId = null;
        } else {
            this.appUserId = str3;
        }
        this.data = wsActivityEventDataDto;
    }

    public WsActivityEventDto(String role, String type, String str, WsActivityEventDataDto data) {
        Intrinsics.checkNotNullParameter(role, "role");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(data, "data");
        this.role = role;
        this.type = type;
        this.appUserId = str;
        this.data = data;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(WsActivityEventDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.role);
        output.encodeStringElement(serialDesc, 1, self.type);
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.appUserId != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.appUserId);
        }
        output.encodeSerializableElement(serialDesc, 3, WsActivityEventDataDto$$serializer.INSTANCE, self.data);
    }

    public WsActivityEventDto(String str, String str2, String str3, WsActivityEventDataDto wsActivityEventDataDto, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, (i & 4) != 0 ? null : str3, wsActivityEventDataDto);
    }

    public final String getRole() {
        return this.role;
    }

    public final String getType() {
        return this.type;
    }

    public final String getAppUserId() {
        return this.appUserId;
    }

    public final WsActivityEventDataDto getData() {
        return this.data;
    }
}
