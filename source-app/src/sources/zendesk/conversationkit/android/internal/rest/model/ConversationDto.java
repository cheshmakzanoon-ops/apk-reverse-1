package zendesk.conversationkit.android.internal.rest.model;

import java.util.List;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlinx.serialization.ContextualSerializer;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.DoubleSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import zendesk.conversationkit.android.model.ConversationRoutingStatus;

@Metadata(m17d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010 \n\u0000\n\u0002\u0010\u0006\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b/\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0081\b\u0018\u0000 U2\u00020\u0001:\u0002TUBÒ\u0001\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\t\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u000e\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\r\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\u000e\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0012\u0018\u00010\r\u0012\u000e\u0010\u0013\u001a\n\u0012\u0004\u0012\u00020\u0014\u0018\u00010\r\u0012\b\u0010\u0015\u001a\u0004\u0018\u00010\u0005\u0012\u0019\u0010\u0016\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0018\u0018\u00010\u0017\u0012\b\u0010\u0019\u001a\u0004\u0018\u00010\u001a\u0012\b\u0010\u001b\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u001c\u001a\u0004\u0018\u00010\u001d¢\u0006\u0002\u0010\u001eB¸\u0001\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\t\u001a\u00020\u0005\u0012\u0006\u0010\n\u001a\u00020\u000b\u0012\u000e\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\r\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\u000e\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0012\u0018\u00010\r\u0012\u000e\u0010\u0013\u001a\n\u0012\u0004\u0012\u00020\u0014\u0018\u00010\r\u0012\b\u0010\u0015\u001a\u0004\u0018\u00010\u0005\u0012\u0019\u0010\u0016\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0018\u0018\u00010\u0017\u0012\b\b\u0002\u0010\u0019\u001a\u00020\u001a\u0012\b\u0010\u001b\u001a\u0004\u0018\u00010\u000f¢\u0006\u0002\u0010\u001fJ\t\u00107\u001a\u00020\u0005HÆ\u0003J\u0011\u00108\u001a\n\u0012\u0004\u0012\u00020\u0012\u0018\u00010\rHÆ\u0003J\u0011\u00109\u001a\n\u0012\u0004\u0012\u00020\u0014\u0018\u00010\rHÆ\u0003J\u000b\u0010:\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u001c\u0010;\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0018\u0018\u00010\u0017HÆ\u0003J\t\u0010<\u001a\u00020\u001aHÆ\u0003J\u0010\u0010=\u001a\u0004\u0018\u00010\u000fHÆ\u0003¢\u0006\u0002\u0010!J\u000b\u0010>\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010?\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u000b\u0010@\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010A\u001a\u00020\u0005HÆ\u0003J\t\u0010B\u001a\u00020\u000bHÆ\u0003J\u0011\u0010C\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\rHÆ\u0003J\u0010\u0010D\u001a\u0004\u0018\u00010\u000fHÆ\u0003¢\u0006\u0002\u0010!J\u0010\u0010E\u001a\u0004\u0018\u00010\u000fHÆ\u0003¢\u0006\u0002\u0010!JÝ\u0001\u0010F\u001a\u00020\u00002\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00052\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\t\u001a\u00020\u00052\b\b\u0002\u0010\n\u001a\u00020\u000b2\u0010\b\u0002\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\r2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\u000f2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u000f2\u0010\b\u0002\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0012\u0018\u00010\r2\u0010\b\u0002\u0010\u0013\u001a\n\u0012\u0004\u0012\u00020\u0014\u0018\u00010\r2\n\b\u0002\u0010\u0015\u001a\u0004\u0018\u00010\u00052\u001b\b\u0002\u0010\u0016\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0018\u0018\u00010\u00172\b\b\u0002\u0010\u0019\u001a\u00020\u001a2\n\b\u0002\u0010\u001b\u001a\u0004\u0018\u00010\u000fHÆ\u0001¢\u0006\u0002\u0010GJ\u0013\u0010H\u001a\u00020\u000b2\b\u0010I\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010J\u001a\u00020\u0003HÖ\u0001J\t\u0010K\u001a\u00020\u0005HÖ\u0001J&\u0010L\u001a\u00020M2\u0006\u0010N\u001a\u00020\u00002\u0006\u0010O\u001a\u00020P2\u0006\u0010Q\u001a\u00020RHÁ\u0001¢\u0006\u0002\bSR\u0015\u0010\u000e\u001a\u0004\u0018\u00010\u000f¢\u0006\n\n\u0002\u0010\"\u001a\u0004\b \u0010!R\u0019\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u0005\u0018\u00010\r¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u0015\u0010\u001b\u001a\u0004\u0018\u00010\u000f¢\u0006\n\n\u0002\u0010\"\u001a\u0004\b%\u0010!R\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b&\u0010'R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b(\u0010'R\u0013\u0010\b\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b)\u0010'R\u001c\u0010\u0004\u001a\u00020\u00058\u0006X\u0087\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b*\u0010+\u001a\u0004\b,\u0010'R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010-R\u0015\u0010\u0010\u001a\u0004\u0018\u00010\u000f¢\u0006\n\n\u0002\u0010\"\u001a\u0004\b.\u0010!R\u0019\u0010\u0013\u001a\n\u0012\u0004\u0012\u00020\u0014\u0018\u00010\r¢\u0006\b\n\u0000\u001a\u0004\b/\u0010$R$\u0010\u0016\u001a\u0015\u0012\u0004\u0012\u00020\u0005\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0018\u0018\u00010\u0017¢\u0006\b\n\u0000\u001a\u0004\b0\u00101R\u0019\u0010\u0011\u001a\n\u0012\u0004\u0012\u00020\u0012\u0018\u00010\r¢\u0006\b\n\u0000\u001a\u0004\b2\u0010$R\u0011\u0010\u0019\u001a\u00020\u001a¢\u0006\b\n\u0000\u001a\u0004\b3\u00104R\u0013\u0010\u0015\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b5\u0010'R\u0011\u0010\t\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b6\u0010'¨\u0006V"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "", "seen1", "", "id", "", "displayName", "description", "iconUrl", "type", "isDefault", "", "appMakers", "", "appMakerLastRead", "", "lastUpdatedAt", "participants", "Lzendesk/conversationkit/android/internal/rest/model/ParticipantDto;", "messages", "Lzendesk/conversationkit/android/internal/rest/model/MessageDto;", "status", "metadata", "", "Lkotlinx/serialization/Contextual;", "routingStatus", "Lzendesk/conversationkit/android/model/ConversationRoutingStatus;", "createdAt", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/util/List;Ljava/lang/Double;Ljava/lang/Double;Ljava/util/List;Ljava/util/List;Ljava/lang/String;Ljava/util/Map;Lzendesk/conversationkit/android/model/ConversationRoutingStatus;Ljava/lang/Double;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/util/List;Ljava/lang/Double;Ljava/lang/Double;Ljava/util/List;Ljava/util/List;Ljava/lang/String;Ljava/util/Map;Lzendesk/conversationkit/android/model/ConversationRoutingStatus;Ljava/lang/Double;)V", "getAppMakerLastRead", "()Ljava/lang/Double;", "Ljava/lang/Double;", "getAppMakers", "()Ljava/util/List;", "getCreatedAt", "getDescription", "()Ljava/lang/String;", "getDisplayName", "getIconUrl", "getId$annotations", "()V", "getId", "()Z", "getLastUpdatedAt", "getMessages", "getMetadata", "()Ljava/util/Map;", "getParticipants", "getRoutingStatus", "()Lzendesk/conversationkit/android/model/ConversationRoutingStatus;", "getStatus", "getType", "component1", "component10", "component11", "component12", "component13", "component14", "component15", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/util/List;Ljava/lang/Double;Ljava/lang/Double;Ljava/util/List;Ljava/util/List;Ljava/lang/String;Ljava/util/Map;Lzendesk/conversationkit/android/model/ConversationRoutingStatus;Ljava/lang/Double;)Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class ConversationDto {
    private final Double appMakerLastRead;
    private final List<String> appMakers;
    private final Double createdAt;
    private final String description;
    private final String displayName;
    private final String iconUrl;
    private final String id;
    private final boolean isDefault;
    private final Double lastUpdatedAt;
    private final List<MessageDto> messages;
    private final Map<String, Object> metadata;
    private final List<ParticipantDto> participants;
    private final ConversationRoutingStatus routingStatus;
    private final String status;
    private final String type;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, null, null, new ArrayListSerializer(StringSerializer.INSTANCE), null, null, new ArrayListSerializer(ParticipantDto$$serializer.INSTANCE), new ArrayListSerializer(MessageDto$$serializer.INSTANCE), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null};

    @SerialName("_id")
    public static void getId$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final List<ParticipantDto> component10() {
        return this.participants;
    }

    public final List<MessageDto> component11() {
        return this.messages;
    }

    public final String getStatus() {
        return this.status;
    }

    public final Map<String, Object> component13() {
        return this.metadata;
    }

    public final ConversationRoutingStatus getRoutingStatus() {
        return this.routingStatus;
    }

    public final Double getCreatedAt() {
        return this.createdAt;
    }

    public final String getDisplayName() {
        return this.displayName;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getIconUrl() {
        return this.iconUrl;
    }

    public final String getType() {
        return this.type;
    }

    public final boolean getIsDefault() {
        return this.isDefault;
    }

    public final List<String> component7() {
        return this.appMakers;
    }

    public final Double getAppMakerLastRead() {
        return this.appMakerLastRead;
    }

    public final Double getLastUpdatedAt() {
        return this.lastUpdatedAt;
    }

    public final ConversationDto copy(String id, String displayName, String description, String iconUrl, String type, boolean isDefault, List<String> appMakers, Double appMakerLastRead, Double lastUpdatedAt, List<ParticipantDto> participants, List<MessageDto> messages, String status, Map<String, ? extends Object> metadata, ConversationRoutingStatus routingStatus, Double createdAt) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(routingStatus, "routingStatus");
        return new ConversationDto(id, displayName, description, iconUrl, type, isDefault, appMakers, appMakerLastRead, lastUpdatedAt, participants, messages, status, metadata, routingStatus, createdAt);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof ConversationDto)) {
            return false;
        }
        ConversationDto conversationDto = (ConversationDto) other;
        return Intrinsics.areEqual(this.id, conversationDto.id) && Intrinsics.areEqual(this.displayName, conversationDto.displayName) && Intrinsics.areEqual(this.description, conversationDto.description) && Intrinsics.areEqual(this.iconUrl, conversationDto.iconUrl) && Intrinsics.areEqual(this.type, conversationDto.type) && this.isDefault == conversationDto.isDefault && Intrinsics.areEqual(this.appMakers, conversationDto.appMakers) && Intrinsics.areEqual((Object) this.appMakerLastRead, (Object) conversationDto.appMakerLastRead) && Intrinsics.areEqual((Object) this.lastUpdatedAt, (Object) conversationDto.lastUpdatedAt) && Intrinsics.areEqual(this.participants, conversationDto.participants) && Intrinsics.areEqual(this.messages, conversationDto.messages) && Intrinsics.areEqual(this.status, conversationDto.status) && Intrinsics.areEqual(this.metadata, conversationDto.metadata) && this.routingStatus == conversationDto.routingStatus && Intrinsics.areEqual((Object) this.createdAt, (Object) conversationDto.createdAt);
    }

    public int hashCode() {
        int iHashCode = this.id.hashCode() * 31;
        String str = this.displayName;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.description;
        int iHashCode3 = (iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.iconUrl;
        int iHashCode4 = (((((iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31) + this.type.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isDefault)) * 31;
        List<String> list = this.appMakers;
        int iHashCode5 = (iHashCode4 + (list == null ? 0 : list.hashCode())) * 31;
        Double d = this.appMakerLastRead;
        int iHashCode6 = (iHashCode5 + (d == null ? 0 : d.hashCode())) * 31;
        Double d2 = this.lastUpdatedAt;
        int iHashCode7 = (iHashCode6 + (d2 == null ? 0 : d2.hashCode())) * 31;
        List<ParticipantDto> list2 = this.participants;
        int iHashCode8 = (iHashCode7 + (list2 == null ? 0 : list2.hashCode())) * 31;
        List<MessageDto> list3 = this.messages;
        int iHashCode9 = (iHashCode8 + (list3 == null ? 0 : list3.hashCode())) * 31;
        String str4 = this.status;
        int iHashCode10 = (iHashCode9 + (str4 == null ? 0 : str4.hashCode())) * 31;
        Map<String, Object> map = this.metadata;
        int iHashCode11 = (((iHashCode10 + (map == null ? 0 : map.hashCode())) * 31) + this.routingStatus.hashCode()) * 31;
        Double d3 = this.createdAt;
        return iHashCode11 + (d3 != null ? d3.hashCode() : 0);
    }

    public String toString() {
        return "ConversationDto(id=" + this.id + ", displayName=" + this.displayName + ", description=" + this.description + ", iconUrl=" + this.iconUrl + ", type=" + this.type + ", isDefault=" + this.isDefault + ", appMakers=" + this.appMakers + ", appMakerLastRead=" + this.appMakerLastRead + ", lastUpdatedAt=" + this.lastUpdatedAt + ", participants=" + this.participants + ", messages=" + this.messages + ", status=" + this.status + ", metadata=" + this.metadata + ", routingStatus=" + this.routingStatus + ", createdAt=" + this.createdAt + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/rest/model/ConversationDto$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/rest/model/ConversationDto;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<ConversationDto> serializer() {
            return ConversationDto$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public ConversationDto(int i, @SerialName("_id") String str, String str2, String str3, String str4, String str5, boolean z, List list, Double d, Double d2, List list2, List list3, String str6, Map map, ConversationRoutingStatus conversationRoutingStatus, Double d3, SerializationConstructorMarker serializationConstructorMarker) {
        if (24575 != (i & 24575)) {
            PluginExceptionsKt.throwMissingFieldException(i, 24575, ConversationDto$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.displayName = str2;
        this.description = str3;
        this.iconUrl = str4;
        this.type = str5;
        this.isDefault = z;
        this.appMakers = list;
        this.appMakerLastRead = d;
        this.lastUpdatedAt = d2;
        this.participants = list2;
        this.messages = list3;
        this.status = str6;
        this.metadata = map;
        this.routingStatus = (i & 8192) == 0 ? ConversationRoutingStatus.UNKNOWN : conversationRoutingStatus;
        this.createdAt = d3;
    }

    public ConversationDto(String id, String str, String str2, String str3, String type, boolean z, List<String> list, Double d, Double d2, List<ParticipantDto> list2, List<MessageDto> list3, String str4, Map<String, ? extends Object> map, ConversationRoutingStatus routingStatus, Double d3) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(routingStatus, "routingStatus");
        this.id = id;
        this.displayName = str;
        this.description = str2;
        this.iconUrl = str3;
        this.type = type;
        this.isDefault = z;
        this.appMakers = list;
        this.appMakerLastRead = d;
        this.lastUpdatedAt = d2;
        this.participants = list2;
        this.messages = list3;
        this.status = str4;
        this.metadata = map;
        this.routingStatus = routingStatus;
        this.createdAt = d3;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(ConversationDto self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.displayName);
        output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.description);
        output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.iconUrl);
        output.encodeStringElement(serialDesc, 4, self.type);
        output.encodeBooleanElement(serialDesc, 5, self.isDefault);
        output.encodeNullableSerializableElement(serialDesc, 6, kSerializerArr[6], self.appMakers);
        output.encodeNullableSerializableElement(serialDesc, 7, DoubleSerializer.INSTANCE, self.appMakerLastRead);
        output.encodeNullableSerializableElement(serialDesc, 8, DoubleSerializer.INSTANCE, self.lastUpdatedAt);
        output.encodeNullableSerializableElement(serialDesc, 9, kSerializerArr[9], self.participants);
        output.encodeNullableSerializableElement(serialDesc, 10, kSerializerArr[10], self.messages);
        output.encodeNullableSerializableElement(serialDesc, 11, StringSerializer.INSTANCE, self.status);
        output.encodeNullableSerializableElement(serialDesc, 12, kSerializerArr[12], self.metadata);
        if (output.shouldEncodeElementDefault(serialDesc, 13) || self.routingStatus != ConversationRoutingStatus.UNKNOWN) {
            output.encodeSerializableElement(serialDesc, 13, ConversationRoutingStatus.ConversationRoutingStatusSerializer.INSTANCE, self.routingStatus);
        }
        output.encodeNullableSerializableElement(serialDesc, 14, DoubleSerializer.INSTANCE, self.createdAt);
    }

    public final String getId() {
        return this.id;
    }

    public final String getDisplayName() {
        return this.displayName;
    }

    public final String getDescription() {
        return this.description;
    }

    public final String getIconUrl() {
        return this.iconUrl;
    }

    public final String getType() {
        return this.type;
    }

    public final boolean isDefault() {
        return this.isDefault;
    }

    public final List<String> getAppMakers() {
        return this.appMakers;
    }

    public final Double getAppMakerLastRead() {
        return this.appMakerLastRead;
    }

    public final Double getLastUpdatedAt() {
        return this.lastUpdatedAt;
    }

    public final List<ParticipantDto> getParticipants() {
        return this.participants;
    }

    public final List<MessageDto> getMessages() {
        return this.messages;
    }

    public final String getStatus() {
        return this.status;
    }

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }

    public ConversationDto(String str, String str2, String str3, String str4, String str5, boolean z, List list, Double d, Double d2, List list2, List list3, String str6, Map map, ConversationRoutingStatus conversationRoutingStatus, Double d3, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, str3, str4, str5, z, list, d, d2, list2, list3, str6, map, (i & 8192) != 0 ? ConversationRoutingStatus.UNKNOWN : conversationRoutingStatus, d3);
    }

    public final ConversationRoutingStatus getRoutingStatus() {
        return this.routingStatus;
    }

    public final Double getCreatedAt() {
        return this.createdAt;
    }
}
