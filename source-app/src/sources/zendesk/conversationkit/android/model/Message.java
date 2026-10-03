package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.collections.MapsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlin.text.StringsKt;
import kotlinx.serialization.ContextualSerializer;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;
import zendesk.core.android.internal.DateKtxKt;

@Metadata(m17d1 = {"\u0000p\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\b\u0003\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\b+\n\u0002\u0018\u0002\n\u0002\b\b\b\u0087\b\u0018\u0000 _2\u00020\u0001:\u0002`_Bz\b\u0000\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\b\u0010\t\u001a\u0004\u0018\u00010\b\u0012\u0006\u0010\n\u001a\u00020\b\u0012\u0006\u0010\f\u001a\u00020\u000b\u0012\u0006\u0010\u000e\u001a\u00020\r\u0012\u0019\u0010\u0011\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0010\u0018\u00010\u000f\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0002\u0012\u0006\u0010\u0013\u001a\u00020\u0002\u0012\b\u0010\u0014\u001a\u0004\u0018\u00010\u0002¢\u0006\u0004\b\u0015\u0010\u0016B\u009c\u0001\b\u0011\u0012\u0006\u0010\u0018\u001a\u00020\u0017\u0012\b\u0010\u0003\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0004\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0006\u0012\n\b\u0001\u0010\t\u001a\u0004\u0018\u00010\b\u0012\n\b\u0001\u0010\n\u001a\u0004\u0018\u00010\b\u0012\u0006\u0010\f\u001a\u00020\u000b\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\r\u0012\u0019\u0010\u0011\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0010\u0018\u00010\u000f\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0013\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u0014\u001a\u0004\u0018\u00010\u0002\u0012\b\u0010\u001a\u001a\u0004\u0018\u00010\u0019¢\u0006\u0004\b\u0015\u0010\u001bJ(\u0010$\u001a\u00020!2\u0006\u0010\u001c\u001a\u00020\u00002\u0006\u0010\u001e\u001a\u00020\u001d2\u0006\u0010 \u001a\u00020\u001fHÁ\u0001¢\u0006\u0004\b\"\u0010#J\u001a\u0010'\u001a\u00020&2\b\u0010%\u001a\u0004\u0018\u00010\u0001H\u0096\u0002¢\u0006\u0004\b'\u0010(J\u000f\u0010)\u001a\u00020\u0017H\u0016¢\u0006\u0004\b)\u0010*J\u000f\u0010+\u001a\u00020\u0002H\u0016¢\u0006\u0004\b+\u0010,J\u0017\u0010/\u001a\u00020&2\b\u0010.\u001a\u0004\u0018\u00010-¢\u0006\u0004\b/\u00100J\u0010\u00101\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b1\u0010,J\u0010\u00102\u001a\u00020\u0004HÆ\u0003¢\u0006\u0004\b2\u00103J\u0010\u00104\u001a\u00020\u0006HÆ\u0003¢\u0006\u0004\b4\u00105J\u0012\u00106\u001a\u0004\u0018\u00010\bHÆ\u0003¢\u0006\u0004\b6\u00107J\u0010\u00108\u001a\u00020\bHÆ\u0003¢\u0006\u0004\b8\u00107J\u0010\u00109\u001a\u00020\u000bHÆ\u0003¢\u0006\u0004\b9\u0010:J\u0010\u0010;\u001a\u00020\rHÆ\u0003¢\u0006\u0004\b;\u0010<J#\u0010=\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0010\u0018\u00010\u000fHÆ\u0003¢\u0006\u0004\b=\u0010>J\u0012\u0010?\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b?\u0010,J\u0010\u0010@\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b@\u0010,J\u0012\u0010A\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\bA\u0010,J\u0097\u0001\u0010B\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00022\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\u00062\n\b\u0002\u0010\t\u001a\u0004\u0018\u00010\b2\b\b\u0002\u0010\n\u001a\u00020\b2\b\b\u0002\u0010\f\u001a\u00020\u000b2\b\b\u0002\u0010\u000e\u001a\u00020\r2\u001b\b\u0002\u0010\u0011\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0010\u0018\u00010\u000f2\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u00022\b\b\u0002\u0010\u0013\u001a\u00020\u00022\n\b\u0002\u0010\u0014\u001a\u0004\u0018\u00010\u0002HÆ\u0001¢\u0006\u0004\bB\u0010CR\u0017\u0010\u0003\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0003\u0010D\u001a\u0004\bE\u0010,R\u0017\u0010\u0005\u001a\u00020\u00048\u0006¢\u0006\f\n\u0004\b\u0005\u0010F\u001a\u0004\bG\u00103R\u0017\u0010\u0007\u001a\u00020\u00068\u0006¢\u0006\f\n\u0004\b\u0007\u0010H\u001a\u0004\bI\u00105R\"\u0010\t\u001a\u0004\u0018\u00010\b8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\t\u0010J\u0012\u0004\bL\u0010M\u001a\u0004\bK\u00107R \u0010\n\u001a\u00020\b8\u0006X\u0087\u0004¢\u0006\u0012\n\u0004\b\n\u0010J\u0012\u0004\bO\u0010M\u001a\u0004\bN\u00107R\u0017\u0010\f\u001a\u00020\u000b8\u0006¢\u0006\f\n\u0004\b\f\u0010P\u001a\u0004\bQ\u0010:R\u0017\u0010\u000e\u001a\u00020\r8\u0006¢\u0006\f\n\u0004\b\u000e\u0010R\u001a\u0004\bS\u0010<R*\u0010\u0011\u001a\u0015\u0012\u0004\u0012\u00020\u0002\u0012\t\u0012\u00070\u0001¢\u0006\u0002\b\u0010\u0018\u00010\u000f8\u0006¢\u0006\f\n\u0004\b\u0011\u0010T\u001a\u0004\bU\u0010>R\u0019\u0010\u0012\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u0012\u0010D\u001a\u0004\bV\u0010,R\u0017\u0010\u0013\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0013\u0010D\u001a\u0004\bW\u0010,R\u0019\u0010\u0014\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u0014\u0010D\u001a\u0004\bX\u0010,R\u0014\u0010\\\u001a\u00020Y8@X\u0080\u0004¢\u0006\u0006\u001a\u0004\bZ\u0010[R\u0011\u0010^\u001a\u00020\b8F¢\u0006\u0006\u001a\u0004\b]\u00107¨\u0006a"}, m18d2 = {"Lzendesk/conversationkit/android/model/Message;", "", "", "id", "Lzendesk/conversationkit/android/model/Author;", "author", "Lzendesk/conversationkit/android/model/MessageStatus;", "status", "j$/time/LocalDateTime", "created", "received", "", "beforeTimestamp", "Lzendesk/conversationkit/android/model/MessageContent;", "content", "", "Lkotlinx/serialization/Contextual;", "metadata", "sourceId", "localId", "payload", "<init>", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Author;Lzendesk/conversationkit/android/model/MessageStatus;Lj$/time/LocalDateTime;Lj$/time/LocalDateTime;DLzendesk/conversationkit/android/model/MessageContent;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "", "seen1", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "serializationConstructorMarker", "(ILjava/lang/String;Lzendesk/conversationkit/android/model/Author;Lzendesk/conversationkit/android/model/MessageStatus;Lj$/time/LocalDateTime;Lj$/time/LocalDateTime;DLzendesk/conversationkit/android/model/MessageContent;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "self", "Lkotlinx/serialization/encoding/CompositeEncoder;", "output", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "serialDesc", "", "write$Self$zendesk_conversationkit_conversationkit_android", "(Lzendesk/conversationkit/android/model/Message;Lkotlinx/serialization/encoding/CompositeEncoder;Lkotlinx/serialization/descriptors/SerialDescriptor;)V", "write$Self", "other", "", "equals", "(Ljava/lang/Object;)Z", "hashCode", "()I", "toString", "()Ljava/lang/String;", "Lzendesk/conversationkit/android/model/Participant;", "participant", "isAuthoredBy", "(Lzendesk/conversationkit/android/model/Participant;)Z", "component1", "component2", "()Lzendesk/conversationkit/android/model/Author;", "component3", "()Lzendesk/conversationkit/android/model/MessageStatus;", "component4", "()Lj$/time/LocalDateTime;", "component5", "component6", "()D", "component7", "()Lzendesk/conversationkit/android/model/MessageContent;", "component8", "()Ljava/util/Map;", "component9", "component10", "component11", "copy", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Author;Lzendesk/conversationkit/android/model/MessageStatus;Lj$/time/LocalDateTime;Lj$/time/LocalDateTime;DLzendesk/conversationkit/android/model/MessageContent;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Lzendesk/conversationkit/android/model/Message;", "Ljava/lang/String;", "getId", "Lzendesk/conversationkit/android/model/Author;", "getAuthor", "Lzendesk/conversationkit/android/model/MessageStatus;", "getStatus", "Lj$/time/LocalDateTime;", "getCreated", "getCreated$annotations", "()V", "getReceived", "getReceived$annotations", "D", "getBeforeTimestamp", "Lzendesk/conversationkit/android/model/MessageContent;", "getContent", "Ljava/util/Map;", "getMetadata", "getSourceId", "getLocalId", "getPayload", "Lzendesk/conversationkit/android/model/EssentialMessageData;", "getEssentialMessageData$zendesk_conversationkit_conversationkit_android", "()Lzendesk/conversationkit/android/model/EssentialMessageData;", "essentialMessageData", "getTimestamp", "timestamp", "Companion", "$serializer", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public final class Message {
    private final Author author;
    private final double beforeTimestamp;
    private final MessageContent content;
    private final LocalDateTime created;
    private final String id;
    private final String localId;
    private final Map<String, Object> metadata;
    private final String payload;
    private final LocalDateTime received;
    private final String sourceId;
    private final MessageStatus status;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {null, null, MessageStatus.INSTANCE.serializer(), new ContextualSerializer(Reflection.getOrCreateKotlinClass(LocalDateTime.class), null, new KSerializer[0]), new ContextualSerializer(Reflection.getOrCreateKotlinClass(LocalDateTime.class), null, new KSerializer[0]), null, MessageContent.INSTANCE.serializer(), new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null, null};

    @JvmStatic
    public static final Message create(MessageContent messageContent) {
        return INSTANCE.create(messageContent);
    }

    @JvmStatic
    public static final Message create(MessageContent messageContent, LocalDateTime localDateTime) {
        return INSTANCE.create(messageContent, localDateTime);
    }

    @JvmStatic
    public static final Message create(MessageContent messageContent, LocalDateTime localDateTime, Map<String, ? extends Object> map) {
        return INSTANCE.create(messageContent, localDateTime, map);
    }

    @JvmStatic
    public static final Message create(MessageContent messageContent, LocalDateTime localDateTime, Map<String, ? extends Object> map, String str) {
        return INSTANCE.create(messageContent, localDateTime, map, str);
    }

    public static void getCreated$annotations() {
    }

    public static void getReceived$annotations() {
    }

    public final String getId() {
        return this.id;
    }

    public final String getLocalId() {
        return this.localId;
    }

    public final String getPayload() {
        return this.payload;
    }

    public final Author getAuthor() {
        return this.author;
    }

    public final MessageStatus getStatus() {
        return this.status;
    }

    public final LocalDateTime getCreated() {
        return this.created;
    }

    public final LocalDateTime getReceived() {
        return this.received;
    }

    public final double getBeforeTimestamp() {
        return this.beforeTimestamp;
    }

    public final MessageContent getContent() {
        return this.content;
    }

    public final Map<String, Object> component8() {
        return this.metadata;
    }

    public final String getSourceId() {
        return this.sourceId;
    }

    public final Message copy(String id, Author author, MessageStatus status, LocalDateTime created, LocalDateTime received, double beforeTimestamp, MessageContent content, Map<String, ? extends Object> metadata, String sourceId, String localId, String payload) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(author, "author");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(received, "received");
        Intrinsics.checkNotNullParameter(content, "content");
        Intrinsics.checkNotNullParameter(localId, "localId");
        return new Message(id, author, status, created, received, beforeTimestamp, content, metadata, sourceId, localId, payload);
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public Message(int i, String str, Author author, MessageStatus messageStatus, LocalDateTime localDateTime, LocalDateTime localDateTime2, double d, MessageContent messageContent, Map map, String str2, String str3, String str4, SerializationConstructorMarker serializationConstructorMarker) {
        if (2047 != (i & 2047)) {
            PluginExceptionsKt.throwMissingFieldException(i, 2047, Message$$serializer.INSTANCE.getDescriptor());
        }
        this.id = str;
        this.author = author;
        this.status = messageStatus;
        this.created = localDateTime;
        this.received = localDateTime2;
        this.beforeTimestamp = d;
        this.content = messageContent;
        this.metadata = map;
        this.sourceId = str2;
        this.localId = str3;
        this.payload = str4;
    }

    public Message(String id, Author author, MessageStatus status, LocalDateTime localDateTime, LocalDateTime received, double d, MessageContent content, Map<String, ? extends Object> map, String str, String localId, String str2) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(author, "author");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(received, "received");
        Intrinsics.checkNotNullParameter(content, "content");
        Intrinsics.checkNotNullParameter(localId, "localId");
        this.id = id;
        this.author = author;
        this.status = status;
        this.created = localDateTime;
        this.received = received;
        this.beforeTimestamp = d;
        this.content = content;
        this.metadata = map;
        this.sourceId = str;
        this.localId = localId;
        this.payload = str2;
    }

    @JvmStatic
    public static final void write$Self$zendesk_conversationkit_conversationkit_android(Message self, CompositeEncoder output, SerialDescriptor serialDesc) {
        KSerializer<Object>[] kSerializerArr = $childSerializers;
        output.encodeStringElement(serialDesc, 0, self.id);
        output.encodeSerializableElement(serialDesc, 1, Author$$serializer.INSTANCE, self.author);
        output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.status);
        output.encodeNullableSerializableElement(serialDesc, 3, kSerializerArr[3], self.created);
        output.encodeSerializableElement(serialDesc, 4, kSerializerArr[4], self.received);
        output.encodeDoubleElement(serialDesc, 5, self.beforeTimestamp);
        output.encodeSerializableElement(serialDesc, 6, kSerializerArr[6], self.content);
        output.encodeNullableSerializableElement(serialDesc, 7, kSerializerArr[7], self.metadata);
        output.encodeNullableSerializableElement(serialDesc, 8, StringSerializer.INSTANCE, self.sourceId);
        output.encodeStringElement(serialDesc, 9, self.localId);
        output.encodeNullableSerializableElement(serialDesc, 10, StringSerializer.INSTANCE, self.payload);
    }

    public final String getId() {
        return this.id;
    }

    public final Author getAuthor() {
        return this.author;
    }

    public final MessageStatus getStatus() {
        return this.status;
    }

    public final LocalDateTime getCreated() {
        return this.created;
    }

    public final LocalDateTime getReceived() {
        return this.received;
    }

    public final double getBeforeTimestamp() {
        return this.beforeTimestamp;
    }

    public final MessageContent getContent() {
        return this.content;
    }

    public final Map<String, Object> getMetadata() {
        return this.metadata;
    }

    public final String getSourceId() {
        return this.sourceId;
    }

    public final String getLocalId() {
        return this.localId;
    }

    public final String getPayload() {
        return this.payload;
    }

    public final EssentialMessageData m213xa9780149() {
        return new EssentialMessageData(this);
    }

    public final LocalDateTime getTimestamp() {
        LocalDateTime localDateTime = this.created;
        return localDateTime == null ? this.received : localDateTime;
    }

    public boolean equals(Object other) {
        return (other instanceof Message) && Intrinsics.areEqual(m213xa9780149(), ((Message) other).m213xa9780149());
    }

    public int hashCode() {
        return m213xa9780149().hashCode();
    }

    public String toString() {
        return StringsKt.replaceFirst$default(m213xa9780149().toString(), "EssentialMessageData", "Message", false, 4, (Object) null);
    }

    public final boolean isAuthoredBy(Participant participant) {
        return Intrinsics.areEqual(this.author.getUserId(), participant != null ? participant.getUserId() : null);
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\b\u0002\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0086\u0003\u0018\u00002\u00020\u0001B\t\b\u0002¢\u0006\u0004\b\u0002\u0010\u0003JC\u0010\r\u001a\u00020\f2\u0006\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\u00062\u0014\b\u0002\u0010\n\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\u00010\b2\n\b\u0002\u0010\u000b\u001a\u0004\u0018\u00010\tH\u0007¢\u0006\u0004\b\r\u0010\u000eJ\u0016\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\f0\u000fHÆ\u0001¢\u0006\u0004\b\u0010\u0010\u0011¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/model/Message$Companion;", "", "<init>", "()V", "Lzendesk/conversationkit/android/model/MessageContent;", "content", "j$/time/LocalDateTime", "createdTime", "", "", "metadata", "payload", "Lzendesk/conversationkit/android/model/Message;", "create", "(Lzendesk/conversationkit/android/model/MessageContent;Lj$/time/LocalDateTime;Ljava/util/Map;Ljava/lang/String;)Lzendesk/conversationkit/android/model/Message;", "Lkotlinx/serialization/KSerializer;", "serializer", "()Lkotlinx/serialization/KSerializer;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        @JvmStatic
        public final Message create(MessageContent content) {
            Intrinsics.checkNotNullParameter(content, "content");
            return create$default(this, content, null, null, null, 14, null);
        }

        @JvmStatic
        public final Message create(MessageContent content, LocalDateTime createdTime) {
            Intrinsics.checkNotNullParameter(content, "content");
            Intrinsics.checkNotNullParameter(createdTime, "createdTime");
            return create$default(this, content, createdTime, null, null, 12, null);
        }

        @JvmStatic
        public final Message create(MessageContent content, LocalDateTime createdTime, Map<String, ? extends Object> metadata) {
            Intrinsics.checkNotNullParameter(content, "content");
            Intrinsics.checkNotNullParameter(createdTime, "createdTime");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            return create$default(this, content, createdTime, metadata, null, 8, null);
        }

        private Companion() {
        }

        public final KSerializer<Message> serializer() {
            return Message$$serializer.INSTANCE;
        }

        public static Message create$default(Companion companion, MessageContent messageContent, LocalDateTime localDateTime, Map map, String str, int i, Object obj) {
            if ((i & 2) != 0) {
                localDateTime = LocalDateTime.now();
                Intrinsics.checkNotNullExpressionValue(localDateTime, "now(...)");
            }
            if ((i & 4) != 0) {
                map = MapsKt.emptyMap();
            }
            if ((i & 8) != 0) {
                str = null;
            }
            return companion.create(messageContent, localDateTime, map, str);
        }

        @JvmStatic
        public final Message create(MessageContent content, LocalDateTime createdTime, Map<String, ? extends Object> metadata, String payload) {
            Intrinsics.checkNotNullParameter(content, "content");
            Intrinsics.checkNotNullParameter(createdTime, "createdTime");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            String string = UUID.randomUUID().toString();
            Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
            return new Message(string, new Author((String) null, (AuthorType) null, (List) null, (String) null, (String) null, 31, (DefaultConstructorMarker) null), new MessageStatus.Pending(null, 1, 0 == true ? 1 : 0), createdTime, createdTime, TimeUnit.MILLISECONDS.toSeconds(DateKtxKt.toTimestamp$default(createdTime, null, 1, null)), content, metadata, null, string, payload);
        }
    }
}
