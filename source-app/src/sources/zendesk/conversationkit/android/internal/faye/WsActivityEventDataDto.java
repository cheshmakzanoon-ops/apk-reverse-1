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
import kotlinx.serialization.internal.DoubleSerializer;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0017\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 42\u00020\u0001:\u000234BU\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\b\u0010\t\u001a\u0004\u0018\u00010\n\u0012\b\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\b\u0010\r\u001a\u0004\u0018\u00010\f\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u000f¢\u0006\u0002\u0010\u0010BM\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b\u0012\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n\u0012\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\f\u0012\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\f¢\u0006\u0002\u0010\u0011J\u000b\u0010\u001e\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010\u001f\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u0010\u0010 \u001a\u0004\u0018\u00010\bHÆ\u0003¢\u0006\u0002\u0010\u0015J\u000b\u0010!\u001a\u0004\u0018\u00010\nHÆ\u0003J\u0010\u0010\"\u001a\u0004\u0018\u00010\fHÆ\u0003¢\u0006\u0002\u0010\u0018J\u0010\u0010#\u001a\u0004\u0018\u00010\fHÆ\u0003¢\u0006\u0002\u0010\u0018JV\u0010$\u001a\u00020\u00002\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\b2\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\n2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\f2\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\fHÆ\u0001¢\u0006\u0002\u0010%J\u0013\u0010&\u001a\u00020'2\b\u0010(\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010)\u001a\u00020\u0003HÖ\u0001J\t\u0010*\u001a\u00020\u0005HÖ\u0001J&\u0010+\u001a\u00020,2\u0006\u0010-\u001a\u00020\u00002\u0006\u0010.\u001a\u00020/2\u0006\u00100\u001a\u000201HÁ\u0001¢\u0006\u0002\b2R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u0015\u0010\u0007\u001a\u0004\u0018\u00010\b¢\u0006\n\n\u0002\u0010\u0016\u001a\u0004\b\u0014\u0010\u0015R\u0015\u0010\r\u001a\u0004\u0018\u00010\f¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\u0017\u0010\u0018R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0013R\u0015\u0010\u000b\u001a\u0004\u0018\u00010\f¢\u0006\n\n\u0002\u0010\u0019\u001a\u0004\b\u001b\u0010\u0018R\u0013\u0010\t\u001a\u0004\u0018\u00010\n¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001d¨\u00065"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto;", "", "seen1", "", "name", "", "avatarUrl", "lastRead", "", "responseTime", "Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;", "queuePosition", "", "lowestQueuePosition", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/Double;Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;Ljava/lang/Long;Ljava/lang/Long;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Double;Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;Ljava/lang/Long;Ljava/lang/Long;)V", "getAvatarUrl", "()Ljava/lang/String;", "getLastRead", "()Ljava/lang/Double;", "Ljava/lang/Double;", "getLowestQueuePosition", "()Ljava/lang/Long;", "Ljava/lang/Long;", "getName", "getQueuePosition", "getResponseTime", "()Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;", "component1", "component2", "component3", "component4", "component5", "component6", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Double;Lzendesk/conversationkit/android/internal/faye/WsResponseTimeDto;Ljava/lang/Long;Ljava/lang/Long;)Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto;", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class WsActivityEventDataDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String avatarUrl;
    private final Double lastRead;
    private final Long lowestQueuePosition;
    private final String name;
    private final Long queuePosition;
    private final WsResponseTimeDto responseTime;

    public WsActivityEventDataDto() {
        this((String) null, (String) null, (Double) null, (WsResponseTimeDto) null, (Long) null, (Long) null, 63, (DefaultConstructorMarker) null);
    }

    public static WsActivityEventDataDto copy$default(WsActivityEventDataDto wsActivityEventDataDto, String str, String str2, Double d, WsResponseTimeDto wsResponseTimeDto, Long l, Long l2, int i, Object obj) {
        if ((i & 1) != 0) {
            str = wsActivityEventDataDto.name;
        }
        if ((i & 2) != 0) {
            str2 = wsActivityEventDataDto.avatarUrl;
        }
        String str3 = str2;
        if ((i & 4) != 0) {
            d = wsActivityEventDataDto.lastRead;
        }
        Double d2 = d;
        if ((i & 8) != 0) {
            wsResponseTimeDto = wsActivityEventDataDto.responseTime;
        }
        WsResponseTimeDto wsResponseTimeDto2 = wsResponseTimeDto;
        if ((i & 16) != 0) {
            l = wsActivityEventDataDto.queuePosition;
        }
        Long l3 = l;
        if ((i & 32) != 0) {
            l2 = wsActivityEventDataDto.lowestQueuePosition;
        }
        return wsActivityEventDataDto.copy(str, str3, d2, wsResponseTimeDto2, l3, l2);
    }

    public final String getName() {
        return this.name;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }

    public final Double getLastRead() {
        return this.lastRead;
    }

    public final WsResponseTimeDto getResponseTime() {
        return this.responseTime;
    }

    public final Long getQueuePosition() {
        return this.queuePosition;
    }

    public final Long getLowestQueuePosition() {
        return this.lowestQueuePosition;
    }

    public final WsActivityEventDataDto copy(String name, String avatarUrl, Double lastRead, WsResponseTimeDto responseTime, Long queuePosition, Long lowestQueuePosition) {
        return new WsActivityEventDataDto(name, avatarUrl, lastRead, responseTime, queuePosition, lowestQueuePosition);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WsActivityEventDataDto)) {
            return false;
        }
        WsActivityEventDataDto wsActivityEventDataDto = (WsActivityEventDataDto) other;
        return Intrinsics.areEqual(this.name, wsActivityEventDataDto.name) && Intrinsics.areEqual(this.avatarUrl, wsActivityEventDataDto.avatarUrl) && Intrinsics.areEqual((Object) this.lastRead, (Object) wsActivityEventDataDto.lastRead) && Intrinsics.areEqual(this.responseTime, wsActivityEventDataDto.responseTime) && Intrinsics.areEqual(this.queuePosition, wsActivityEventDataDto.queuePosition) && Intrinsics.areEqual(this.lowestQueuePosition, wsActivityEventDataDto.lowestQueuePosition);
    }

    public int hashCode() {
        String str = this.name;
        int iHashCode = (str == null ? 0 : str.hashCode()) * 31;
        String str2 = this.avatarUrl;
        int iHashCode2 = (iHashCode + (str2 == null ? 0 : str2.hashCode())) * 31;
        Double d = this.lastRead;
        int iHashCode3 = (iHashCode2 + (d == null ? 0 : d.hashCode())) * 31;
        WsResponseTimeDto wsResponseTimeDto = this.responseTime;
        int iHashCode4 = (iHashCode3 + (wsResponseTimeDto == null ? 0 : wsResponseTimeDto.hashCode())) * 31;
        Long l = this.queuePosition;
        int iHashCode5 = (iHashCode4 + (l == null ? 0 : l.hashCode())) * 31;
        Long l2 = this.lowestQueuePosition;
        return iHashCode5 + (l2 != null ? l2.hashCode() : 0);
    }

    public String toString() {
        return "WsActivityEventDataDto(name=" + this.name + ", avatarUrl=" + this.avatarUrl + ", lastRead=" + this.lastRead + ", responseTime=" + this.responseTime + ", queuePosition=" + this.queuePosition + ", lowestQueuePosition=" + this.lowestQueuePosition + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/faye/WsActivityEventDataDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<WsActivityEventDataDto> serializer() {
            return WsActivityEventDataDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public WsActivityEventDataDto(int i, String str, String str2, Double d, WsResponseTimeDto wsResponseTimeDto, Long l, Long l2, SerializationConstructorMarker serializationConstructorMarker) {
        if ((i & 1) == 0) {
            this.name = null;
        } else {
            this.name = str;
        }
        if ((i & 2) == 0) {
            this.avatarUrl = null;
        } else {
            this.avatarUrl = str2;
        }
        if ((i & 4) == 0) {
            this.lastRead = null;
        } else {
            this.lastRead = d;
        }
        if ((i & 8) == 0) {
            this.responseTime = null;
        } else {
            this.responseTime = wsResponseTimeDto;
        }
        if ((i & 16) == 0) {
            this.queuePosition = null;
        } else {
            this.queuePosition = l;
        }
        if ((i & 32) == 0) {
            this.lowestQueuePosition = null;
        } else {
            this.lowestQueuePosition = l2;
        }
    }

    public WsActivityEventDataDto(String str, String str2, Double d, WsResponseTimeDto wsResponseTimeDto, Long l, Long l2) {
        this.name = str;
        this.avatarUrl = str2;
        this.lastRead = d;
        this.responseTime = wsResponseTimeDto;
        this.queuePosition = l;
        this.lowestQueuePosition = l2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(WsActivityEventDataDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        if (output.shouldEncodeElementDefault(serialDesc, 0) || self.name != null) {
            output.encodeNullableSerializableElement(serialDesc, 0, StringSerializer.INSTANCE, self.name);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 1) || self.avatarUrl != null) {
            output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.avatarUrl);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 2) || self.lastRead != null) {
            output.encodeNullableSerializableElement(serialDesc, 2, DoubleSerializer.INSTANCE, self.lastRead);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 3) || self.responseTime != null) {
            output.encodeNullableSerializableElement(serialDesc, 3, WsResponseTimeDto$$serializer.INSTANCE, self.responseTime);
        }
        if (output.shouldEncodeElementDefault(serialDesc, 4) || self.queuePosition != null) {
            output.encodeNullableSerializableElement(serialDesc, 4, LongSerializer.INSTANCE, self.queuePosition);
        }
        if (!output.shouldEncodeElementDefault(serialDesc, 5) && self.lowestQueuePosition == null) {
            return;
        }
        output.encodeNullableSerializableElement(serialDesc, 5, LongSerializer.INSTANCE, self.lowestQueuePosition);
    }

    public WsActivityEventDataDto(String str, String str2, Double d, WsResponseTimeDto wsResponseTimeDto, Long l, Long l2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this((i & 1) != 0 ? null : str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : d, (i & 8) != 0 ? null : wsResponseTimeDto, (i & 16) != 0 ? null : l, (i & 32) != 0 ? null : l2);
    }

    public final String getName() {
        return this.name;
    }

    public final String getAvatarUrl() {
        return this.avatarUrl;
    }

    public final Double getLastRead() {
        return this.lastRead;
    }

    public final WsResponseTimeDto getResponseTime() {
        return this.responseTime;
    }

    public final Long getQueuePosition() {
        return this.queuePosition;
    }

    public final Long getLowestQueuePosition() {
        return this.lowestQueuePosition;
    }
}
