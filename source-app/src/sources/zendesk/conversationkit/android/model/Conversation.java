package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
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
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.DoubleSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000v\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010 \n\u0000\n\u0002\b\u0002\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\bF\b\u0087\b\u0018\u0000 o2\u00020\u0001:\u0002poBÆ\u0001\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0002\u0012\u0006\u0010\b\u001a\u00020\u0007\u0012\u0006\u0010\n\u001a\u00020\t\u0012\f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00020\u000b\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\r\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0011\u0012\f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00110\u000b\u0012\f\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00140\u000b\u0012\u0006\u0010\u0016\u001a\u00020\t\u0012\u0006\u0010\u0018\u001a\u00020\u0017\u0012\u0019\u0010\u001b\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u001a\u0018\u00010\u0019\u0012\b\b\u0002\u0010\u001d\u001a\u00020\u001c\u0012\b\u0010\u001e\u001a\u0004\u0018\u00010\r¢\u0006\u0004\b\u001f\u0010 Bè\u0001\b\u0011\u0012\u0006\u0010\"\u001a\u00020!\u0012\b\u0010\u0003\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\b\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\n\u001a\u00020\t\u0012\u000e\u0010\f\u001a\n\u0012\u0004\u0012\u00020\u0002\u0018\u00010\u000b\u0012\n\b\u0001\u0010\u000e\u001a\u0004\u0018\u00010\r\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u000f\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0011\u0012\u000e\u0010\u0013\u001a\n\u0012\u0004\u0012\u00020\u0011\u0018\u00010\u000b\u0012\u000e\u0010\u0015\u001a\n\u0012\u0004\u0012\u00020\u0014\u0018\u00010\u000b\u0012\u0006\u0010\u0016\u001a\u00020\t\u0012\b\u0010\u0018\u001a\u0004\u0018\u00010\u0017\u0012\u0019\u0010\u001b\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u001a\u0018\u00010\u0019\u0012\b\u0010\u001d\u001a\u0004\u0018\u00010\u001c\u0012\n\b\u0001\u0010\u001e\u001a\u0004\u0018\u00010\r\u0012\b\u0010$\u001a\u0004\u0018\u00010#¢\u0006\u0004\b\u001f\u0010%J(\u0010.\u001a\u00020+2\u0006\u0010&\u001a\u00020\u00002\u0006\u0010(\u001a\u00020'2\u0006\u0010*\u001a\u00020)HÁ\u0001¢\u0006\u0004\b,\u0010-J\u0010\u0010/\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b/\u00100J\u0012\u00101\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b1\u00100J\u0012\u00102\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b2\u00100J\u0012\u00103\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b3\u00100J\u0010\u00104\u001a\u00020\u0007HÆ\u0003¢\u0006\u0004\b4\u00105J\u0010\u00106\u001a\u00020\tHÆ\u0003¢\u0006\u0004\b6\u00107J\u0016\u00108\u001a\b\u0012\u0004\u0012\u00020\u00020\u000bHÆ\u0003¢\u0006\u0004\b8\u00109J\u0012\u0010:\u001a\u0004\u0018\u00010\rHÆ\u0003¢\u0006\u0004\b:\u0010;J\u0012\u0010<\u001a\u0004\u0018\u00010\u000fHÆ\u0003¢\u0006\u0004\b<\u0010=J\u0012\u0010>\u001a\u0004\u0018\u00010\u0011HÆ\u0003¢\u0006\u0004\b>\u0010?J\u0016\u0010@\u001a\b\u0012\u0004\u0012\u00020\u00110\u000bHÆ\u0003¢\u0006\u0004\b@\u00109J\u0016\u0010A\u001a\b\u0012\u0004\u0012\u00020\u00140\u000bHÆ\u0003¢\u0006\u0004\bA\u00109J\u0010\u0010B\u001a\u00020\tHÆ\u0003¢\u0006\u0004\bB\u00107J\u0010\u0010C\u001a\u00020\u0017HÆ\u0003¢\u0006\u0004\bC\u0010DJ#\u0010E\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u001a\u0018\u00010\u0019HÆ\u0003¢\u0006\u0004\bE\u0010FJ\u0010\u0010G\u001a\u00020\u001cHÆ\u0003¢\u0006\u0004\bG\u0010HJ\u0012\u0010I\u001a\u0004\u0018\u00010\rHÆ\u0003¢\u0006\u0004\bI\u0010;Jí\u0001\u0010J\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00022\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00022\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00022\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00022\b\b\u0002\u0010\b\u001a\u00020\u00072\b\b\u0002\u0010\n\u001a\u00020\t2\u000e\b\u0002\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00020\u000b2\n\b\u0002\u0010\u000e\u001a\u0004\u0018\u00010\r2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u000f2\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00112\u000e\b\u0002\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00110\u000b2\u000e\b\u0002\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00140\u000b2\b\b\u0002\u0010\u0016\u001a\u00020\t2\b\b\u0002\u0010\u0018\u001a\u00020\u00172\u001b\b\u0002\u0010\u001b\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u001a\u0018\u00010\u00192\b\b\u0002\u0010\u001d\u001a\u00020\u001c2\n\b\u0002\u0010\u001e\u001a\u0004\u0018\u00010\rHÆ\u0001¢\u0006\u0004\bJ\u0010KJ\u0010\u0010L\u001a\u00020\u0002HÖ\u0001¢\u0006\u0004\bL\u00100J\u0010\u0010M\u001a\u00020!HÖ\u0001¢\u0006\u0004\bM\u0010NJ\u001a\u0010P\u001a\u00020\t2\b\u0010O\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\bP\u0010QR\u0017\u0010\u0003\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0003\u0010R\u001a\u0004\bS\u00100R\u0019\u0010\u0004\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u0004\u0010R\u001a\u0004\bT\u00100R\u0019\u0010\u0005\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u0005\u0010R\u001a\u0004\bU\u00100R\u0019\u0010\u0006\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u0006\u0010R\u001a\u0004\bV\u00100R\u0017\u0010\b\u001a\u00020\u00078\u0006¢\u0006\f\n\u0004\b\b\u0010W\u001a\u0004\bX\u00105R\u0017\u0010\n\u001a\u00020\t8\u0006¢\u0006\f\n\u0004\b\n\u0010Y\u001a\u0004\b\n\u00107R\u001d\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00020\u000b8\u0006¢\u0006\f\n\u0004\b\f\u0010Z\u001a\u0004\b[\u00109R\"\u0010\u000e\u001a\u0004\u0018\u00010\r8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u000e\u0010\\\u0012\u0004\b^\u0010_\u001a\u0004\b]\u0010;R\u0019\u0010\u0010\u001a\u0004\u0018\u00010\u000f8\u0006¢\u0006\f\n\u0004\b\u0010\u0010`\u001a\u0004\ba\u0010=R\u0019\u0010\u0012\u001a\u0004\u0018\u00010\u00118\u0006¢\u0006\f\n\u0004\b\u0012\u0010b\u001a\u0004\bc\u0010?R\u001d\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00110\u000b8\u0006¢\u0006\f\n\u0004\b\u0013\u0010Z\u001a\u0004\bd\u00109R\u001d\u0010\u0015\u001a\b\u0012\u0004\u0012\u00020\u00140\u000b8\u0006¢\u0006\f\n\u0004\b\u0015\u0010Z\u001a\u0004\be\u00109R\u0017\u0010\u0016\u001a\u00020\t8\u0006¢\u0006\f\n\u0004\b\u0016\u0010Y\u001a\u0004\bf\u00107R\u0017\u0010\u0018\u001a\u00020\u00178\u0006¢\u0006\f\n\u0004\b\u0018\u0010g\u001a\u0004\bh\u0010DR*\u0010\u001b\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u001a\u0018\u00010\u00198\u0006¢\u0006\f\n\u0004\b\u001b\u0010i\u001a\u0004\bj\u0010FR\u0017\u0010\u001d\u001a\u00020\u001c8\u0006¢\u0006\f\n\u0004\b\u001d\u0010k\u001a\u0004\bl\u0010HR\"\u0010\u001e\u001a\u0004\u0018\u00010\r8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\u001e\u0010\\\u0012\u0004\bn\u0010_\u001a\u0004\bm\u0010;¨\u0006q"}, m18d2 = {"Lzendesk/conversationkit/android/model/Conversation;", "", "", "id", "displayName", "description", "iconUrl", "Lzendesk/conversationkit/android/model/ConversationType;", "type", "", "isDefault", "", "business", "j$/time/LocalDateTime", "businessLastRead", "", "lastUpdatedAt", "Lzendesk/conversationkit/android/model/Participant;", "myself", "participants", "Lzendesk/conversationkit/android/model/Message;", "messages", "hasPrevious", "Lzendesk/conversationkit/android/model/ConversationStatus;", "status", "", "Lkotlinx/serialization/Contextual;", "metadata", "Lzendesk/conversationkit/android/model/ConversationRoutingStatus;", "routingStatus", "createdAt", "<init>", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/model/ConversationType;ZLjava/util/List;Lj$/time/LocalDateTime;Ljava/lang/Double;Lzendesk/conversationkit/android/model/Participant;Ljava/util/List;Ljava/util/List;ZLzendesk/conversationkit/android/model/ConversationStatus;Ljava/util/Map;Lzendesk/conversationkit/android/model/ConversationRoutingStatus;Lj$/time/LocalDateTime;)V", "", "seen1", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "serializationConstructorMarker", "(ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/model/ConversationType;ZLjava/util/List;Lj$/time/LocalDateTime;Ljava/lang/Double;Lzendesk/conversationkit/android/model/Participant;Ljava/util/List;Ljava/util/List;ZLzendesk/conversationkit/android/model/ConversationStatus;Ljava/util/Map;Lzendesk/conversationkit/android/model/ConversationRoutingStatus;Lj$/time/LocalDateTime;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "self", "Lkotlinx/serialization/encoding/CompositeEncoder;", "output", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "serialDesc", "", "write$Self$zendesk_conversationkit_conversationkit_android", "(Lzendesk/conversationkit/android/model/Conversation;Lkotlinx/serialization/encoding/CompositeEncoder;Lkotlinx/serialization/descriptors/SerialDescriptor;)V", "write$Self", "component1", "()Ljava/lang/String;", "component2", "component3", "component4", "component5", "()Lzendesk/conversationkit/android/model/ConversationType;", "component6", "()Z", "component7", "()Ljava/util/List;", "component8", "()Lj$/time/LocalDateTime;", "component9", "()Ljava/lang/Double;", "component10", "()Lzendesk/conversationkit/android/model/Participant;", "component11", "component12", "component13", "component14", "()Lzendesk/conversationkit/android/model/ConversationStatus;", "component15", "()Ljava/util/Map;", "component16", "()Lzendesk/conversationkit/android/model/ConversationRoutingStatus;", "component17", "copy", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/conversationkit/android/model/ConversationType;ZLjava/util/List;Lj$/time/LocalDateTime;Ljava/lang/Double;Lzendesk/conversationkit/android/model/Participant;Ljava/util/List;Ljava/util/List;ZLzendesk/conversationkit/android/model/ConversationStatus;Ljava/util/Map;Lzendesk/conversationkit/android/model/ConversationRoutingStatus;Lj$/time/LocalDateTime;)Lzendesk/conversationkit/android/model/Conversation;", "toString", "hashCode", "()I", "other", "equals", "(Ljava/lang/Object;)Z", "Ljava/lang/String;", "getId", "getDisplayName", "getDescription", "getIconUrl", "Lzendesk/conversationkit/android/model/ConversationType;", "getType", "Z", "Ljava/util/List;", "getBusiness", "Lj$/time/LocalDateTime;", "getBusinessLastRead", "getBusinessLastRead$annotations", "()V", "Ljava/lang/Double;", "getLastUpdatedAt", "Lzendesk/conversationkit/android/model/Participant;", "getMyself", "getParticipants", "getMessages", "getHasPrevious", "Lzendesk/conversationkit/android/model/ConversationStatus;", "getStatus", "Ljava/util/Map;", "getMetadata", "Lzendesk/conversationkit/android/model/ConversationRoutingStatus;", "getRoutingStatus", "getCreatedAt", "getCreatedAt$annotations", "Companion", "$serializer", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class Conversation {
    private final List<String> business;
    private final LocalDateTime businessLastRead;
    private final LocalDateTime createdAt;
    private final String description;
    private final String displayName;
    private final boolean hasPrevious;
    private final String iconUrl;
    private final String id;
    private final boolean isDefault;
    private final Double lastUpdatedAt;
    private final List<Message> messages;
    private final Map<String, Object> metadata;
    private final Participant myself;
    private final List<Participant> participants;
    private final ConversationRoutingStatus routingStatus;
    private final ConversationStatus status;
    private final ConversationType type;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, null, null, ConversationType.INSTANCE.serializer(), null, new ArrayListSerializer(StringSerializer.INSTANCE), new ContextualSerializer(Reflection.getOrCreateKotlinClass(LocalDateTime.class), null, new KSerializer[0]), null, null, new ArrayListSerializer(Participant$$serializer.INSTANCE), new ArrayListSerializer(Message$$serializer.INSTANCE), null, ConversationStatus.INSTANCE.serializer(), new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, new ContextualSerializer(Reflection.getOrCreateKotlinClass(LocalDateTime.class), null, new KSerializer[0])};

    public static void getBusinessLastRead$annotations() {
    }

    public static void getCreatedAt$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final Participant getMyself() {
        return this.myself;
    }

    public final List<Participant> component11() {
        return this.participants;
    }

    public final List<Message> component12() {
        return this.messages;
    }

    public final boolean getHasPrevious() {
        return this.hasPrevious;
    }

    public final ConversationStatus getStatus() {
        return this.status;
    }

    public final Map<String, Object> component15() {
        return this.metadata;
    }

    public final ConversationRoutingStatus getRoutingStatus() {
        return this.routingStatus;
    }

    public final LocalDateTime getCreatedAt() {
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

    public final ConversationType getType() {
        return this.type;
    }

    public final boolean getIsDefault() {
        return this.isDefault;
    }

    public final List<String> component7() {
        return this.business;
    }

    public final LocalDateTime getBusinessLastRead() {
        return this.businessLastRead;
    }

    public final Double getLastUpdatedAt() {
        return this.lastUpdatedAt;
    }

    public final Conversation copy(String id, String displayName, String description, String iconUrl, ConversationType type, boolean isDefault, List<String> business, LocalDateTime businessLastRead, Double lastUpdatedAt, Participant myself, List<Participant> participants, List<Message> messages, boolean hasPrevious, ConversationStatus status, Map<String, ? extends Object> metadata, ConversationRoutingStatus routingStatus, LocalDateTime createdAt) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(business, "business");
        Intrinsics.checkNotNullParameter(participants, "participants");
        Intrinsics.checkNotNullParameter(messages, "messages");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(routingStatus, "routingStatus");
        return new Conversation(id, displayName, description, iconUrl, type, isDefault, business, businessLastRead, lastUpdatedAt, myself, participants, messages, hasPrevious, status, metadata, routingStatus, createdAt);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof Conversation)) {
            return false;
        }
        Conversation conversation = (Conversation) other;
        return Intrinsics.areEqual(this.id, conversation.id) && Intrinsics.areEqual(this.displayName, conversation.displayName) && Intrinsics.areEqual(this.description, conversation.description) && Intrinsics.areEqual(this.iconUrl, conversation.iconUrl) && this.type == conversation.type && this.isDefault == conversation.isDefault && Intrinsics.areEqual(this.business, conversation.business) && Intrinsics.areEqual(this.businessLastRead, conversation.businessLastRead) && Intrinsics.areEqual((Object) this.lastUpdatedAt, (Object) conversation.lastUpdatedAt) && Intrinsics.areEqual(this.myself, conversation.myself) && Intrinsics.areEqual(this.participants, conversation.participants) && Intrinsics.areEqual(this.messages, conversation.messages) && this.hasPrevious == conversation.hasPrevious && this.status == conversation.status && Intrinsics.areEqual(this.metadata, conversation.metadata) && this.routingStatus == conversation.routingStatus && Intrinsics.areEqual(this.createdAt, conversation.createdAt);
    }

    public int hashCode() {
        int iHashCode = this.id.hashCode() * 31;
        String str = this.displayName;
        int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
        String str2 = this.description;
        int iHashCode3 = (iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31;
        String str3 = this.iconUrl;
        int iHashCode4 = (((((((iHashCode3 + (str3 == null ? 0 : str3.hashCode())) * 31) + this.type.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isDefault)) * 31) + this.business.hashCode()) * 31;
        LocalDateTime localDateTime = this.businessLastRead;
        int iHashCode5 = (iHashCode4 + (localDateTime == null ? 0 : localDateTime.hashCode())) * 31;
        Double d = this.lastUpdatedAt;
        int iHashCode6 = (iHashCode5 + (d == null ? 0 : d.hashCode())) * 31;
        Participant participant = this.myself;
        int iHashCode7 = (((((((((iHashCode6 + (participant == null ? 0 : participant.hashCode())) * 31) + this.participants.hashCode()) * 31) + this.messages.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.hasPrevious)) * 31) + this.status.hashCode()) * 31;
        Map<String, Object> map = this.metadata;
        int iHashCode8 = (((iHashCode7 + (map == null ? 0 : map.hashCode())) * 31) + this.routingStatus.hashCode()) * 31;
        LocalDateTime localDateTime2 = this.createdAt;
        return iHashCode8 + (localDateTime2 != null ? localDateTime2.hashCode() : 0);
    }

    public String toString() {
        return "Conversation(id=" + this.id + ", displayName=" + this.displayName + ", description=" + this.description + ", iconUrl=" + this.iconUrl + ", type=" + this.type + ", isDefault=" + this.isDefault + ", business=" + this.business + ", businessLastRead=" + this.businessLastRead + ", lastUpdatedAt=" + this.lastUpdatedAt + ", myself=" + this.myself + ", participants=" + this.participants + ", messages=" + this.messages + ", hasPrevious=" + this.hasPrevious + ", status=" + this.status + ", metadata=" + this.metadata + ", routingStatus=" + this.routingStatus + ", createdAt=" + this.createdAt + ')';
    }

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/Conversation$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/Conversation;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final KSerializer<Conversation> serializer() {
            return Conversation$$serializer.INSTANCE;
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public Conversation(int i, String str, String str2, String str3, String str4, ConversationType conversationType, boolean z, List list, LocalDateTime localDateTime, Double d, Participant participant, List list2, List list3, boolean z2, ConversationStatus conversationStatus, Map map, ConversationRoutingStatus conversationRoutingStatus, LocalDateTime localDateTime2, SerializationConstructorMarker serializationConstructorMarker) {
        if (98303 != (i & 98303)) {
            PluginExceptionsKt.throwMissingFieldException(i, 98303, Conversation$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.displayName = str2;
        this.description = str3;
        this.iconUrl = str4;
        this.type = conversationType;
        this.isDefault = z;
        this.business = list;
        this.businessLastRead = localDateTime;
        this.lastUpdatedAt = d;
        this.myself = participant;
        this.participants = list2;
        this.messages = list3;
        this.hasPrevious = z2;
        this.status = conversationStatus;
        this.metadata = map;
        this.routingStatus = (i & 32768) == 0 ? ConversationRoutingStatus.UNKNOWN : conversationRoutingStatus;
        this.createdAt = localDateTime2;
    }

    public Conversation(String id, String str, String str2, String str3, ConversationType type, boolean z, List<String> business, LocalDateTime localDateTime, Double d, Participant participant, List<Participant> participants, List<Message> messages, boolean z2, ConversationStatus status, Map<String, ? extends Object> map, ConversationRoutingStatus routingStatus, LocalDateTime localDateTime2) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(type, "type");
        Intrinsics.checkNotNullParameter(business, "business");
        Intrinsics.checkNotNullParameter(participants, "participants");
        Intrinsics.checkNotNullParameter(messages, "messages");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(routingStatus, "routingStatus");
        this.id = id;
        this.displayName = str;
        this.description = str2;
        this.iconUrl = str3;
        this.type = type;
        this.isDefault = z;
        this.business = business;
        this.businessLastRead = localDateTime;
        this.lastUpdatedAt = d;
        this.myself = participant;
        this.participants = participants;
        this.messages = messages;
        this.hasPrevious = z2;
        this.status = status;
        this.metadata = map;
        this.routingStatus = routingStatus;
        this.createdAt = localDateTime2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(Conversation self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeNullableSerializableElement(serialDesc, 1, StringSerializer.INSTANCE, self.displayName);
        output.encodeNullableSerializableElement(serialDesc, 2, StringSerializer.INSTANCE, self.description);
        output.encodeNullableSerializableElement(serialDesc, 3, StringSerializer.INSTANCE, self.iconUrl);
        output.encodeSerializableElement(serialDesc, 4, kSerializerArr[4], self.type);
        output.encodeBooleanElement(serialDesc, 5, self.isDefault);
        output.encodeSerializableElement(serialDesc, 6, kSerializerArr[6], self.business);
        output.encodeNullableSerializableElement(serialDesc, 7, kSerializerArr[7], self.businessLastRead);
        output.encodeNullableSerializableElement(serialDesc, 8, DoubleSerializer.INSTANCE, self.lastUpdatedAt);
        output.encodeNullableSerializableElement(serialDesc, 9, Participant$$serializer.INSTANCE, self.myself);
        output.encodeSerializableElement(serialDesc, 10, kSerializerArr[10], self.participants);
        output.encodeSerializableElement(serialDesc, 11, kSerializerArr[11], self.messages);
        output.encodeBooleanElement(serialDesc, 12, self.hasPrevious);
        output.encodeSerializableElement(serialDesc, 13, kSerializerArr[13], self.status);
        output.encodeNullableSerializableElement(serialDesc, 14, kSerializerArr[14], self.metadata);
        if (output.shouldEncodeElementDefault(serialDesc, 15) || self.routingStatus != ConversationRoutingStatus.UNKNOWN) {
            output.encodeSerializableElement(serialDesc, 15, ConversationRoutingStatus.ConversationRoutingStatusSerializer.INSTANCE, self.routingStatus);
        }
        output.encodeNullableSerializableElement(serialDesc, 16, kSerializerArr[16], self.createdAt);
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

    public final ConversationType getType() {
        return this.type;
    }

    public final boolean isDefault() {
        return this.isDefault;
    }

    public final List<String> getBusiness() {
        return this.business;
    }

    public final LocalDateTime getBusinessLastRead() {
        return this.businessLastRead;
    }

    public final Double getLastUpdatedAt() {
        return this.lastUpdatedAt;
    }

    public final Participant getMyself() {
        return this.myself;
    }

    public final List<Participant> getParticipants() {
        return this.participants;
    }

    public final List<Message> getMessages() {
        return this.messages;
    }

    public final boolean getHasPrevious() {
        return this.hasPrevious;
    }

    public final ConversationStatus getStatus() {
        return this.status;
    }

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }

    public Conversation(String str, String str2, String str3, String str4, ConversationType conversationType, boolean z, List list, LocalDateTime localDateTime, Double d, Participant participant, List list2, List list3, boolean z2, ConversationStatus conversationStatus, Map map, ConversationRoutingStatus conversationRoutingStatus, LocalDateTime localDateTime2, int i, DefaultConstructorMarker defaultConstructorMarker) {
        this(str, str2, str3, str4, conversationType, z, list, localDateTime, d, participant, list2, list3, z2, conversationStatus, map, (i & 32768) != 0 ? ConversationRoutingStatus.UNKNOWN : conversationRoutingStatus, localDateTime2);
    }

    public final ConversationRoutingStatus getRoutingStatus() {
        return this.routingStatus;
    }

    public final LocalDateTime getCreatedAt() {
        return this.createdAt;
    }
}
