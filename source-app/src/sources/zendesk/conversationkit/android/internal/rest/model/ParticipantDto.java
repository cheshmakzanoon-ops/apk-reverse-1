package zendesk.conversationkit.android.internal.rest.model;

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
import kotlinx.serialization.internal.DoubleSerializer;
import kotlinx.serialization.internal.IntSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 -2\u00020\u0001:\u0002,-BC\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t\u0012\b\u0010\n\u001a\u0004\u0018\u00010\u000b¢\u0006\u0002\u0010\fB)\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0003\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\rJ\t\u0010\u0019\u001a\u00020\u0005HÆ\u0003J\t\u0010\u001a\u001a\u00020\u0005HÆ\u0003J\u0010\u0010\u001b\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\u0017J\u0010\u0010\u001c\u001a\u0004\u0018\u00010\tHÆ\u0003¢\u0006\u0002\u0010\u0014J:\u0010\u001d\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\tHÆ\u0001¢\u0006\u0002\u0010\u001eJ\u0013\u0010\u001f\u001a\u00020 2\b\u0010!\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\"\u001a\u00020\u0003HÖ\u0001J\t\u0010#\u001a\u00020\u0005HÖ\u0001J&\u0010$\u001a\u00020%2\u0006\u0010&\u001a\u00020\u00002\u0006\u0010'\u001a\u00020(2\u0006\u0010)\u001a\u00020*HÁ\u0001¢\u0006\u0002\b+R\u0011\u0010\u0006\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0010\u0010\u0011\u001a\u0004\b\u0012\u0010\u000fR\u0015\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\n\n\u0002\u0010\u0015\u001a\u0004\b\u0013\u0010\u0014R\u0015\u0010\u0007\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\u0018\u001a\u0004\b\u0016\u0010\u0017¨\u0006."}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ParticipantDto;", "", "seen1", "", "id", "", "appUserId", "unreadCount", "lastRead", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/Double;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/Double;)V", "getAppUserId", "()Ljava/lang/String;", "getId$annotations", "()V", "getId", "getLastRead", "()Ljava/lang/Double;", "Ljava/lang/Double;", "getUnreadCount", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "component1", "component2", "component3", "component4", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/Double;)Lzendesk/conversationkit/android/internal/rest/model/ParticipantDto;", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ParticipantDto {

    public static final Companion INSTANCE = new Companion(null);
    private final String appUserId;
    private final String id;
    private final Double lastRead;
    private final Integer unreadCount;

    public static ParticipantDto copy$default(ParticipantDto participantDto, String str, String str2, Integer num, Double d, int i, Object obj) {
        if ((i & 1) != 0) {
            str = participantDto.id;
        }
        if ((i & 2) != 0) {
            str2 = participantDto.appUserId;
        }
        if ((i & 4) != 0) {
            num = participantDto.unreadCount;
        }
        if ((i & 8) != 0) {
            d = participantDto.lastRead;
        }
        return participantDto.copy(str, str2, num, d);
    }

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final String getAppUserId() {
        return this.appUserId;
    }

    public final Integer getUnreadCount() {
        return this.unreadCount;
    }

    public final Double getLastRead() {
        return this.lastRead;
    }

    public final ParticipantDto copy(String id, String appUserId, Integer unreadCount, Double lastRead) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(appUserId, "appUserId");
        return new ParticipantDto(id, appUserId, unreadCount, lastRead);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ParticipantDto)) {
            return false;
        }
        ParticipantDto participantDto = (ParticipantDto) other;
        return Intrinsics.areEqual(this.id, participantDto.id) && Intrinsics.areEqual(this.appUserId, participantDto.appUserId) && Intrinsics.areEqual(this.unreadCount, participantDto.unreadCount) && Intrinsics.areEqual((Object) this.lastRead, (Object) participantDto.lastRead);
    }

    public int hashCode() {
        int iHashCode = ((this.id.hashCode() * 31) + this.appUserId.hashCode()) * 31;
        Integer num = this.unreadCount;
        int iHashCode2 = (iHashCode + (num == null ? 0 : num.hashCode())) * 31;
        Double d = this.lastRead;
        return iHashCode2 + (d != null ? d.hashCode() : 0);
    }

    public String toString() {
        return "ParticipantDto(id=" + this.id + ", appUserId=" + this.appUserId + ", unreadCount=" + this.unreadCount + ", lastRead=" + this.lastRead + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ParticipantDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ParticipantDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ParticipantDto> serializer() {
            return ParticipantDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ParticipantDto(int i, @SerialName("_id") String str, String str2, Integer num, Double d, SerializationConstructorMarker serializationConstructorMarker) {
        if (15 != (i & 15)) {
            PluginExceptionsKt.throwMissingFieldException(i, 15, ParticipantDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.appUserId = str2;
        this.unreadCount = num;
        this.lastRead = d;
    }

    public ParticipantDto(String id, String appUserId, Integer num, Double d) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(appUserId, "appUserId");
        this.id = id;
        this.appUserId = appUserId;
        this.unreadCount = num;
        this.lastRead = d;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(ParticipantDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeStringElement(serialDesc, 1, self.appUserId);
        output.encodeNullableSerializableElement(serialDesc, 2, IntSerializer.INSTANCE, self.unreadCount);
        output.encodeNullableSerializableElement(serialDesc, 3, DoubleSerializer.INSTANCE, self.lastRead);
    }

    public final String getId() {
        return this.id;
    }

    public final String getAppUserId() {
        return this.appUserId;
    }

    public final Integer getUnreadCount() {
        return this.unreadCount;
    }

    public final Double getLastRead() {
        return this.lastRead;
    }
}
