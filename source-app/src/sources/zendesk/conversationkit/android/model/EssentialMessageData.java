package zendesk.conversationkit.android.model;

import j$.time.LocalDateTime;
import java.util.Map;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000D\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010\b\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0002\b\u0012\b\u0080\b\u0018\u00002\u00020\u0001Ba\u0012\u0006\u0010\u0003\u001a\u00020\u0002\u0012\u0006\u0010\u0005\u001a\u00020\u0004\u0012\u0006\u0010\u0007\u001a\u00020\u0006\u0012\u0006\u0010\t\u001a\u00020\b\u0012\b\u0010\n\u001a\u0004\u0018\u00010\b\u0012\u0006\u0010\f\u001a\u00020\u000b\u0012\u0014\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0001\u0018\u00010\r\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0002\u0012\u0006\u0010\u0010\u001a\u00020\u0002¢\u0006\u0004\b\u0011\u0010\u0012B\u0011\b\u0016\u0012\u0006\u0010\u0014\u001a\u00020\u0013¢\u0006\u0004\b\u0011\u0010\u0015J\u0010\u0010\u0016\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b\u0016\u0010\u0017J\u0010\u0010\u0018\u001a\u00020\u0004HÆ\u0003¢\u0006\u0004\b\u0018\u0010\u0019J\u0010\u0010\u001a\u001a\u00020\u0006HÆ\u0003¢\u0006\u0004\b\u001a\u0010\u001bJ\u0010\u0010\u001c\u001a\u00020\bHÆ\u0003¢\u0006\u0004\b\u001c\u0010\u001dJ\u0012\u0010\u001e\u001a\u0004\u0018\u00010\bHÆ\u0003¢\u0006\u0004\b\u001e\u0010\u001dJ\u0010\u0010\u001f\u001a\u00020\u000bHÆ\u0003¢\u0006\u0004\b\u001f\u0010 J\u001e\u0010!\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0001\u0018\u00010\rHÆ\u0003¢\u0006\u0004\b!\u0010\"J\u0012\u0010#\u001a\u0004\u0018\u00010\u0002HÆ\u0003¢\u0006\u0004\b#\u0010\u0017J\u0010\u0010$\u001a\u00020\u0002HÆ\u0003¢\u0006\u0004\b$\u0010\u0017J|\u0010%\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u00022\b\b\u0002\u0010\u0005\u001a\u00020\u00042\b\b\u0002\u0010\u0007\u001a\u00020\u00062\b\b\u0002\u0010\t\u001a\u00020\b2\n\b\u0002\u0010\n\u001a\u0004\u0018\u00010\b2\b\b\u0002\u0010\f\u001a\u00020\u000b2\u0016\b\u0002\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0001\u0018\u00010\r2\n\b\u0002\u0010\u000f\u001a\u0004\u0018\u00010\u00022\b\b\u0002\u0010\u0010\u001a\u00020\u0002HÆ\u0001¢\u0006\u0004\b%\u0010&J\u0010\u0010'\u001a\u00020\u0002HÖ\u0001¢\u0006\u0004\b'\u0010\u0017J\u0010\u0010)\u001a\u00020(HÖ\u0001¢\u0006\u0004\b)\u0010*J\u001a\u0010-\u001a\u00020,2\b\u0010+\u001a\u0004\u0018\u00010\u0001HÖ\u0003¢\u0006\u0004\b-\u0010.R\u0017\u0010\u0003\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0003\u0010/\u001a\u0004\b0\u0010\u0017R\u0017\u0010\u0005\u001a\u00020\u00048\u0006¢\u0006\f\n\u0004\b\u0005\u00101\u001a\u0004\b2\u0010\u0019R\u0017\u0010\u0007\u001a\u00020\u00068\u0006¢\u0006\f\n\u0004\b\u0007\u00103\u001a\u0004\b4\u0010\u001bR\u0017\u0010\t\u001a\u00020\b8\u0006¢\u0006\f\n\u0004\b\t\u00105\u001a\u0004\b6\u0010\u001dR\u0019\u0010\n\u001a\u0004\u0018\u00010\b8\u0006¢\u0006\f\n\u0004\b\n\u00105\u001a\u0004\b7\u0010\u001dR\u0017\u0010\f\u001a\u00020\u000b8\u0006¢\u0006\f\n\u0004\b\f\u00108\u001a\u0004\b9\u0010 R%\u0010\u000e\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0001\u0018\u00010\r8\u0006¢\u0006\f\n\u0004\b\u000e\u0010:\u001a\u0004\b;\u0010\"R\u0019\u0010\u000f\u001a\u0004\u0018\u00010\u00028\u0006¢\u0006\f\n\u0004\b\u000f\u0010/\u001a\u0004\b<\u0010\u0017R\u0017\u0010\u0010\u001a\u00020\u00028\u0006¢\u0006\f\n\u0004\b\u0010\u0010/\u001a\u0004\b=\u0010\u0017¨\u0006>"}, m18d2 = {"Lzendesk/conversationkit/android/model/EssentialMessageData;", "", "", "id", "Lzendesk/conversationkit/android/model/Author;", "author", "Lzendesk/conversationkit/android/model/MessageStatus;", "status", "j$/time/LocalDateTime", "received", "created", "Lzendesk/conversationkit/android/model/MessageContent;", "content", "", "metadata", "sourceId", "localId", "<init>", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Author;Lzendesk/conversationkit/android/model/MessageStatus;Lj$/time/LocalDateTime;Lj$/time/LocalDateTime;Lzendesk/conversationkit/android/model/MessageContent;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)V", "Lzendesk/conversationkit/android/model/Message;", "message", "(Lzendesk/conversationkit/android/model/Message;)V", "component1", "()Ljava/lang/String;", "component2", "()Lzendesk/conversationkit/android/model/Author;", "component3", "()Lzendesk/conversationkit/android/model/MessageStatus;", "component4", "()Lj$/time/LocalDateTime;", "component5", "component6", "()Lzendesk/conversationkit/android/model/MessageContent;", "component7", "()Ljava/util/Map;", "component8", "component9", "copy", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Author;Lzendesk/conversationkit/android/model/MessageStatus;Lj$/time/LocalDateTime;Lj$/time/LocalDateTime;Lzendesk/conversationkit/android/model/MessageContent;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;)Lzendesk/conversationkit/android/model/EssentialMessageData;", "toString", "", "hashCode", "()I", "other", "", "equals", "(Ljava/lang/Object;)Z", "Ljava/lang/String;", "getId", "Lzendesk/conversationkit/android/model/Author;", "getAuthor", "Lzendesk/conversationkit/android/model/MessageStatus;", "getStatus", "Lj$/time/LocalDateTime;", "getReceived", "getCreated", "Lzendesk/conversationkit/android/model/MessageContent;", "getContent", "Ljava/util/Map;", "getMetadata", "getSourceId", "getLocalId", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class EssentialMessageData {
    private final Author author;
    private final MessageContent content;
    private final LocalDateTime created;
    private final String id;
    private final String localId;
    private final Map<String, Object> metadata;
    private final LocalDateTime received;
    private final String sourceId;
    private final MessageStatus status;

    public final String getId() {
        return this.id;
    }

    public final Author getAuthor() {
        return this.author;
    }

    public final MessageStatus getStatus() {
        return this.status;
    }

    public final LocalDateTime getReceived() {
        return this.received;
    }

    public final LocalDateTime getCreated() {
        return this.created;
    }

    public final MessageContent getContent() {
        return this.content;
    }

    public final Map<String, Object> component7() {
        return this.metadata;
    }

    public final String getSourceId() {
        return this.sourceId;
    }

    public final String getLocalId() {
        return this.localId;
    }

    public final EssentialMessageData copy(String id, Author author, MessageStatus status, LocalDateTime received, LocalDateTime created, MessageContent content, Map<String, ? extends Object> metadata, String sourceId, String localId) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(author, "author");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(received, "received");
        Intrinsics.checkNotNullParameter(content, "content");
        Intrinsics.checkNotNullParameter(localId, "localId");
        return new EssentialMessageData(id, author, status, received, created, content, metadata, sourceId, localId);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof EssentialMessageData)) {
            return false;
        }
        EssentialMessageData essentialMessageData = (EssentialMessageData) other;
        return Intrinsics.areEqual(this.id, essentialMessageData.id) && Intrinsics.areEqual(this.author, essentialMessageData.author) && Intrinsics.areEqual(this.status, essentialMessageData.status) && Intrinsics.areEqual(this.received, essentialMessageData.received) && Intrinsics.areEqual(this.created, essentialMessageData.created) && Intrinsics.areEqual(this.content, essentialMessageData.content) && Intrinsics.areEqual(this.metadata, essentialMessageData.metadata) && Intrinsics.areEqual(this.sourceId, essentialMessageData.sourceId) && Intrinsics.areEqual(this.localId, essentialMessageData.localId);
    }

    public int hashCode() {
        int iHashCode = ((((((this.id.hashCode() * 31) + this.author.hashCode()) * 31) + this.status.hashCode()) * 31) + this.received.hashCode()) * 31;
        LocalDateTime localDateTime = this.created;
        int iHashCode2 = (((iHashCode + (localDateTime == null ? 0 : localDateTime.hashCode())) * 31) + this.content.hashCode()) * 31;
        Map<String, Object> map = this.metadata;
        int iHashCode3 = (iHashCode2 + (map == null ? 0 : map.hashCode())) * 31;
        String str = this.sourceId;
        return ((iHashCode3 + (str != null ? str.hashCode() : 0)) * 31) + this.localId.hashCode();
    }

    public String toString() {
        return "EssentialMessageData(id=" + this.id + ", author=" + this.author + ", status=" + this.status + ", received=" + this.received + ", created=" + this.created + ", content=" + this.content + ", metadata=" + this.metadata + ", sourceId=" + this.sourceId + ", localId=" + this.localId + ')';
    }

    public EssentialMessageData(String id, Author author, MessageStatus status, LocalDateTime received, LocalDateTime localDateTime, MessageContent content, Map<String, ? extends Object> map, String str, String localId) {
        Intrinsics.checkNotNullParameter(id, "id");
        Intrinsics.checkNotNullParameter(author, "author");
        Intrinsics.checkNotNullParameter(status, "status");
        Intrinsics.checkNotNullParameter(received, "received");
        Intrinsics.checkNotNullParameter(content, "content");
        Intrinsics.checkNotNullParameter(localId, "localId");
        this.id = id;
        this.author = author;
        this.status = status;
        this.received = received;
        this.created = localDateTime;
        this.content = content;
        this.metadata = map;
        this.sourceId = str;
        this.localId = localId;
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

    public final LocalDateTime getReceived() {
        return this.received;
    }

    public final LocalDateTime getCreated() {
        return this.created;
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

    public EssentialMessageData(Message message) {
        this(message.getId(), message.getAuthor(), message.getStatus(), message.getReceived(), message.getCreated(), message.getContent(), message.getMetadata(), message.getSourceId(), message.getLocalId());
        Intrinsics.checkNotNullParameter(message, "message");
    }
}
