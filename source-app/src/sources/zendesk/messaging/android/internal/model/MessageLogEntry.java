package zendesk.messaging.android.internal.model;

import java.util.List;
import java.util.UUID;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageAction;
import zendesk.conversationkit.android.model.MessageStatus;
import zendesk.core.p017ui.android.internal.model.MessageDirection;
import zendesk.core.p017ui.android.internal.model.MessagePosition;
import zendesk.core.p017ui.android.internal.model.MessageShape;

@Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u000e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u000b\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011B\u000f\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006\u0082\u0001\u000b\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c¨\u0006\u001d"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry;", "", "id", "", "(Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "CarouselContainer", "FileMessageContainer", "FormMessageContainer", "ImageMessageContainer", "LoadMore", "MessageContainer", "MessagesDivider", "QuickReply", "TextMessageContainer", "TimestampDivider", "TypingIndicatorContainer", "Lzendesk/messaging/android/internal/model/MessageLogEntry$CarouselContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FileMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$ImageMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$LoadMore;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$MessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$MessagesDivider;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$QuickReply;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TextMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TimestampDivider;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TypingIndicatorContainer;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class MessageLogEntry {
    private final String id;

    public MessageLogEntry(String str, DefaultConstructorMarker defaultConstructorMarker) {
        this(str);
    }

    private MessageLogEntry(String str) {
        this.id = str;
    }

    public String getId() {
        return this.id;
    }

    @Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001Bg\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\b\b\u0002\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\u0002\u0010\u0014J\t\u0010'\u001a\u00020\u0003HÆ\u0003J\u000b\u0010(\u001a\u0004\u0018\u00010\u0013HÆ\u0003J\u000b\u0010)\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010*\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010+\u001a\u00020\u0007HÆ\u0003J\t\u0010,\u001a\u00020\tHÆ\u0003J\t\u0010-\u001a\u00020\u000bHÆ\u0003J\t\u0010.\u001a\u00020\rHÆ\u0003J\t\u0010/\u001a\u00020\u000fHÆ\u0003J\t\u00100\u001a\u00020\u0011HÆ\u0003Js\u00101\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÆ\u0001J\u0013\u00102\u001a\u0002032\b\u00104\u001a\u0004\u0018\u000105HÖ\u0003J\t\u00106\u001a\u000207HÖ\u0001J\t\u00108\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0016R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u0011\u0010\u0010\u001a\u00020\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0013\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&¨\u00069"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$MessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "label", "avatarUrl", "direction", "Lzendesk/core/ui/android/internal/model/MessageDirection;", "position", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "shape", "Lzendesk/core/ui/android/internal/model/MessageShape;", "size", "Lzendesk/messaging/android/internal/model/MessageSize;", "status", "Lzendesk/conversationkit/android/model/MessageStatus;", "message", "Lzendesk/conversationkit/android/model/Message;", "receipt", "Lzendesk/messaging/android/internal/model/MessageReceipt;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/core/ui/android/internal/model/MessageDirection;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/core/ui/android/internal/model/MessageShape;Lzendesk/messaging/android/internal/model/MessageSize;Lzendesk/conversationkit/android/model/MessageStatus;Lzendesk/conversationkit/android/model/Message;Lzendesk/messaging/android/internal/model/MessageReceipt;)V", "getAvatarUrl", "()Ljava/lang/String;", "getDirection", "()Lzendesk/core/ui/android/internal/model/MessageDirection;", "getId", "getLabel", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "getPosition", "()Lzendesk/core/ui/android/internal/model/MessagePosition;", "getReceipt", "()Lzendesk/messaging/android/internal/model/MessageReceipt;", "getShape", "()Lzendesk/core/ui/android/internal/model/MessageShape;", "getSize", "()Lzendesk/messaging/android/internal/model/MessageSize;", "getStatus", "()Lzendesk/conversationkit/android/model/MessageStatus;", "component1", "component10", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MessageContainer extends MessageLogEntry {
        private final String avatarUrl;
        private final MessageDirection direction;
        private final String id;
        private final String label;
        private final Message message;
        private final MessagePosition position;
        private final MessageReceipt receipt;
        private final MessageShape shape;
        private final MessageSize size;
        private final MessageStatus status;

        public final String getId() {
            return this.id;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageContainer copy(String id, String label, String avatarUrl, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt receipt) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            return new MessageContainer(id, label, avatarUrl, direction, position, shape, size, status, message, receipt);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessageContainer)) {
                return false;
            }
            MessageContainer messageContainer = (MessageContainer) other;
            return Intrinsics.areEqual(this.id, messageContainer.id) && Intrinsics.areEqual(this.label, messageContainer.label) && Intrinsics.areEqual(this.avatarUrl, messageContainer.avatarUrl) && this.direction == messageContainer.direction && this.position == messageContainer.position && this.shape == messageContainer.shape && this.size == messageContainer.size && Intrinsics.areEqual(this.status, messageContainer.status) && Intrinsics.areEqual(this.message, messageContainer.message) && Intrinsics.areEqual(this.receipt, messageContainer.receipt);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.label;
            int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.avatarUrl;
            int iHashCode3 = (((((((((((((iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31) + this.direction.hashCode()) * 31) + this.position.hashCode()) * 31) + this.shape.hashCode()) * 31) + this.size.hashCode()) * 31) + this.status.hashCode()) * 31) + this.message.hashCode()) * 31;
            MessageReceipt messageReceipt = this.receipt;
            return iHashCode3 + (messageReceipt != null ? messageReceipt.hashCode() : 0);
        }

        public String toString() {
            return "MessageContainer(id=" + this.id + ", label=" + this.label + ", avatarUrl=" + this.avatarUrl + ", direction=" + this.direction + ", position=" + this.position + ", shape=" + this.shape + ", size=" + this.size + ", status=" + this.status + ", message=" + this.message + ", receipt=" + this.receipt + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public MessageContainer(String str, String str2, String str3, MessageDirection messageDirection, MessagePosition messagePosition, MessageShape messageShape, MessageSize messageSize, MessageStatus messageStatus, Message message, MessageReceipt messageReceipt, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : str3, messageDirection, (i & 16) != 0 ? MessagePosition.STANDALONE : messagePosition, (i & 32) != 0 ? MessageShape.STANDALONE : messageShape, (i & 64) != 0 ? MessageSize.NORMAL : messageSize, messageStatus, message, (i & 512) != 0 ? null : messageReceipt);
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public MessageContainer(String id, String str, String str2, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt messageReceipt) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            this.id = id;
            this.label = str;
            this.avatarUrl = str2;
            this.direction = direction;
            this.position = position;
            this.shape = shape;
            this.size = size;
            this.status = status;
            this.message = message;
            this.receipt = messageReceipt;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$TypingIndicatorContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "avatarUrl", "(Ljava/lang/String;Ljava/lang/String;)V", "getAvatarUrl", "()Ljava/lang/String;", "getId", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class TypingIndicatorContainer extends MessageLogEntry {
        private final String avatarUrl;
        private final String id;

        public static TypingIndicatorContainer copy$default(TypingIndicatorContainer typingIndicatorContainer, String str, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = typingIndicatorContainer.id;
            }
            if ((i & 2) != 0) {
                str2 = typingIndicatorContainer.avatarUrl;
            }
            return typingIndicatorContainer.copy(str, str2);
        }

        public final String getId() {
            return this.id;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final TypingIndicatorContainer copy(String id, String avatarUrl) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(avatarUrl, "avatarUrl");
            return new TypingIndicatorContainer(id, avatarUrl);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof TypingIndicatorContainer)) {
                return false;
            }
            TypingIndicatorContainer typingIndicatorContainer = (TypingIndicatorContainer) other;
            return Intrinsics.areEqual(this.id, typingIndicatorContainer.id) && Intrinsics.areEqual(this.avatarUrl, typingIndicatorContainer.avatarUrl);
        }

        public int hashCode() {
            return (this.id.hashCode() * 31) + this.avatarUrl.hashCode();
        }

        public String toString() {
            return "TypingIndicatorContainer(id=" + this.id + ", avatarUrl=" + this.avatarUrl + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public TypingIndicatorContainer(String id, String avatarUrl) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(avatarUrl, "avatarUrl");
            this.id = id;
            this.avatarUrl = avatarUrl;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\r\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0006HÆ\u0003J'\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0016HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J\t\u0010\u0019\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\tR\u001a\u0010\u0005\u001a\u00020\u0006X\u0086\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000b\u0010\f\"\u0004\b\r\u0010\u000e¨\u0006\u001a"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$MessagesDivider;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "text", "type", "Lzendesk/messaging/android/internal/model/MessageLogType;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/messaging/android/internal/model/MessageLogType;)V", "getId", "()Ljava/lang/String;", "getText", "getType", "()Lzendesk/messaging/android/internal/model/MessageLogType;", "setType", "(Lzendesk/messaging/android/internal/model/MessageLogType;)V", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MessagesDivider extends MessageLogEntry {
        private final String id;
        private final String text;
        private MessageLogType type;

        public static MessagesDivider copy$default(MessagesDivider messagesDivider, String str, String str2, MessageLogType messageLogType, int i, Object obj) {
            if ((i & 1) != 0) {
                str = messagesDivider.id;
            }
            if ((i & 2) != 0) {
                str2 = messagesDivider.text;
            }
            if ((i & 4) != 0) {
                messageLogType = messagesDivider.type;
            }
            return messagesDivider.copy(str, str2, messageLogType);
        }

        public final String getId() {
            return this.id;
        }

        public final String getText() {
            return this.text;
        }

        public final MessageLogType getType() {
            return this.type;
        }

        public final MessagesDivider copy(String id, String text, MessageLogType type) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(type, "type");
            return new MessagesDivider(id, text, type);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessagesDivider)) {
                return false;
            }
            MessagesDivider messagesDivider = (MessagesDivider) other;
            return Intrinsics.areEqual(this.id, messagesDivider.id) && Intrinsics.areEqual(this.text, messagesDivider.text) && this.type == messagesDivider.type;
        }

        public int hashCode() {
            return (((this.id.hashCode() * 31) + this.text.hashCode()) * 31) + this.type.hashCode();
        }

        public String toString() {
            return "MessagesDivider(id=" + this.id + ", text=" + this.text + ", type=" + this.type + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getText() {
            return this.text;
        }

        public final MessageLogType getType() {
            return this.type;
        }

        public final void setType(MessageLogType messageLogType) {
            Intrinsics.checkNotNullParameter(messageLogType, "<set-?>");
            this.type = messageLogType;
        }

        public MessagesDivider(String id, String text, MessageLogType type) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(type, "type");
            this.id = id;
            this.text = text;
            this.type = type;
        }
    }

    @Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b6\u0018\u00002\u00020\u0001:\u0002\t\nB\u0017\b\u0004\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\u0004\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007\u0082\u0001\u0002\u000b\f¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$TimestampDivider;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "timestamp", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getTimestamp", "MessageDayDivider", "MessageTimeDivider", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TimestampDivider$MessageDayDivider;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TimestampDivider$MessageTimeDivider;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static abstract class TimestampDivider extends MessageLogEntry {
        private final String id;
        private final String timestamp;

        public TimestampDivider(String str, String str2, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, str2);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public String getTimestamp() {
            return this.timestamp;
        }

        private TimestampDivider(String str, String str2) {
            super(str, null);
            this.id = str;
            this.timestamp = str2;
        }

        @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\u0004\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$TimestampDivider$MessageTimeDivider;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TimestampDivider;", "id", "", "timestamp", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getTimestamp", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class MessageTimeDivider extends TimestampDivider {
            private final String id;
            private final String timestamp;

            public static MessageTimeDivider copy$default(MessageTimeDivider messageTimeDivider, String str, String str2, int i, Object obj) {
                if ((i & 1) != 0) {
                    str = messageTimeDivider.id;
                }
                if ((i & 2) != 0) {
                    str2 = messageTimeDivider.timestamp;
                }
                return messageTimeDivider.copy(str, str2);
            }

            public final String getId() {
                return this.id;
            }

            public final String getTimestamp() {
                return this.timestamp;
            }

            public final MessageTimeDivider copy(String id, String timestamp) {
                Intrinsics.checkNotNullParameter(id, "id");
                Intrinsics.checkNotNullParameter(timestamp, "timestamp");
                return new MessageTimeDivider(id, timestamp);
            }

            public boolean equals(Object other) {
                if (this == other) {
                    return true;
                }
                if (!(other instanceof MessageTimeDivider)) {
                    return false;
                }
                MessageTimeDivider messageTimeDivider = (MessageTimeDivider) other;
                return Intrinsics.areEqual(this.id, messageTimeDivider.id) && Intrinsics.areEqual(this.timestamp, messageTimeDivider.timestamp);
            }

            public int hashCode() {
                return (this.id.hashCode() * 31) + this.timestamp.hashCode();
            }

            public String toString() {
                return "MessageTimeDivider(id=" + this.id + ", timestamp=" + this.timestamp + ')';
            }

            @Override
            public String getId() {
                return this.id;
            }

            @Override
            public String getTimestamp() {
                return this.timestamp;
            }

            public MessageTimeDivider(String id, String timestamp) {
                super(id, timestamp, null);
                Intrinsics.checkNotNullParameter(id, "id");
                Intrinsics.checkNotNullParameter(timestamp, "timestamp");
                this.id = id;
                this.timestamp = timestamp;
            }
        }

        @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0014\u0010\u0004\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$TimestampDivider$MessageDayDivider;", "Lzendesk/messaging/android/internal/model/MessageLogEntry$TimestampDivider;", "id", "", "timestamp", "(Ljava/lang/String;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getTimestamp", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class MessageDayDivider extends TimestampDivider {
            private final String id;
            private final String timestamp;

            public static MessageDayDivider copy$default(MessageDayDivider messageDayDivider, String str, String str2, int i, Object obj) {
                if ((i & 1) != 0) {
                    str = messageDayDivider.id;
                }
                if ((i & 2) != 0) {
                    str2 = messageDayDivider.timestamp;
                }
                return messageDayDivider.copy(str, str2);
            }

            public final String getId() {
                return this.id;
            }

            public final String getTimestamp() {
                return this.timestamp;
            }

            public final MessageDayDivider copy(String id, String timestamp) {
                Intrinsics.checkNotNullParameter(id, "id");
                Intrinsics.checkNotNullParameter(timestamp, "timestamp");
                return new MessageDayDivider(id, timestamp);
            }

            public boolean equals(Object other) {
                if (this == other) {
                    return true;
                }
                if (!(other instanceof MessageDayDivider)) {
                    return false;
                }
                MessageDayDivider messageDayDivider = (MessageDayDivider) other;
                return Intrinsics.areEqual(this.id, messageDayDivider.id) && Intrinsics.areEqual(this.timestamp, messageDayDivider.timestamp);
            }

            public int hashCode() {
                return (this.id.hashCode() * 31) + this.timestamp.hashCode();
            }

            public String toString() {
                return "MessageDayDivider(id=" + this.id + ", timestamp=" + this.timestamp + ')';
            }

            @Override
            public String getId() {
                return this.id;
            }

            @Override
            public String getTimestamp() {
                return this.timestamp;
            }

            public MessageDayDivider(String id, String timestamp) {
                super(id, timestamp, null);
                Intrinsics.checkNotNullParameter(id, "id");
                Intrinsics.checkNotNullParameter(timestamp, "timestamp");
                this.id = id;
                this.timestamp = timestamp;
            }
        }
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001b\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\u0002\u0010\u0007J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\u000f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005HÆ\u0003J#\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\u000e\b\u0002\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0017\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$QuickReply;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "replies", "", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "(Ljava/lang/String;Ljava/util/List;)V", "getId", "()Ljava/lang/String;", "getReplies", "()Ljava/util/List;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class QuickReply extends MessageLogEntry {
        private final String id;
        private final List<MessageAction.Reply> replies;

        public static QuickReply copy$default(QuickReply quickReply, String str, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                str = quickReply.id;
            }
            if ((i & 2) != 0) {
                list = quickReply.replies;
            }
            return quickReply.copy(str, list);
        }

        public final String getId() {
            return this.id;
        }

        public final List<MessageAction.Reply> component2() {
            return this.replies;
        }

        public final QuickReply copy(String id, List<MessageAction.Reply> replies) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(replies, "replies");
            return new QuickReply(id, replies);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof QuickReply)) {
                return false;
            }
            QuickReply quickReply = (QuickReply) other;
            return Intrinsics.areEqual(this.id, quickReply.id) && Intrinsics.areEqual(this.replies, quickReply.replies);
        }

        public int hashCode() {
            return (this.id.hashCode() * 31) + this.replies.hashCode();
        }

        public String toString() {
            return "QuickReply(id=" + this.id + ", replies=" + this.replies + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final List<MessageAction.Reply> getReplies() {
            return this.replies;
        }

        public QuickReply(String id, List<MessageAction.Reply> replies) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(replies, "replies");
            this.id = id;
            this.replies = replies;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B#\u0012\b\b\u0002\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\t\u0010\r\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\u000e\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010\u000f\u001a\u00020\u0006HÆ\u0003J)\u0010\u0010\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u0011\u001a\u00020\u00122\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014HÖ\u0003J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J\t\u0010\u0017\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\tR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\f¨\u0006\u0018"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$LoadMore;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "failedRetryText", "status", "Lzendesk/messaging/android/internal/model/LoadMoreStatus;", "(Ljava/lang/String;Ljava/lang/String;Lzendesk/messaging/android/internal/model/LoadMoreStatus;)V", "getFailedRetryText", "()Ljava/lang/String;", "getId", "getStatus", "()Lzendesk/messaging/android/internal/model/LoadMoreStatus;", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadMore extends MessageLogEntry {
        private final String failedRetryText;
        private final String id;
        private final LoadMoreStatus status;

        public static LoadMore copy$default(LoadMore loadMore, String str, String str2, LoadMoreStatus loadMoreStatus, int i, Object obj) {
            if ((i & 1) != 0) {
                str = loadMore.id;
            }
            if ((i & 2) != 0) {
                str2 = loadMore.failedRetryText;
            }
            if ((i & 4) != 0) {
                loadMoreStatus = loadMore.status;
            }
            return loadMore.copy(str, str2, loadMoreStatus);
        }

        public final String getId() {
            return this.id;
        }

        public final String getFailedRetryText() {
            return this.failedRetryText;
        }

        public final LoadMoreStatus getStatus() {
            return this.status;
        }

        public final LoadMore copy(String id, String failedRetryText, LoadMoreStatus status) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(status, "status");
            return new LoadMore(id, failedRetryText, status);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LoadMore)) {
                return false;
            }
            LoadMore loadMore = (LoadMore) other;
            return Intrinsics.areEqual(this.id, loadMore.id) && Intrinsics.areEqual(this.failedRetryText, loadMore.failedRetryText) && this.status == loadMore.status;
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.failedRetryText;
            return ((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + this.status.hashCode();
        }

        public String toString() {
            return "LoadMore(id=" + this.id + ", failedRetryText=" + this.failedRetryText + ", status=" + this.status + ')';
        }

        public LoadMore(String str, String str2, LoadMoreStatus loadMoreStatus, int i, DefaultConstructorMarker defaultConstructorMarker) {
            if ((i & 1) != 0) {
                str = UUID.randomUUID().toString();
                Intrinsics.checkNotNullExpressionValue(str, "toString(...)");
            }
            this(str, (i & 2) != 0 ? null : str2, loadMoreStatus);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getFailedRetryText() {
            return this.failedRetryText;
        }

        public final LoadMoreStatus getStatus() {
            return this.status;
        }

        public LoadMore(String id, String str, LoadMoreStatus status) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(status, "status");
            this.id = id;
            this.failedRetryText = str;
            this.status = status;
        }
    }

    @Metadata(m17d1 = {"\u0000L\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001Bi\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\u0006\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u0011\u0012\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0013J\t\u0010%\u001a\u00020\u0003HÆ\u0003J\u000b\u0010&\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010'\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010(\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010)\u001a\u00020\u0007HÆ\u0003J\t\u0010*\u001a\u00020\tHÆ\u0003J\t\u0010+\u001a\u00020\u000bHÆ\u0003J\t\u0010,\u001a\u00020\rHÆ\u0003J\t\u0010-\u001a\u00020\u000fHÆ\u0003J\u000b\u0010.\u001a\u0004\u0018\u00010\u0011HÆ\u0003Ju\u0010/\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\n\b\u0002\u0010\u0010\u001a\u0004\u0018\u00010\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0003HÆ\u0001J\u0013\u00100\u001a\u0002012\b\u00102\u001a\u0004\u0018\u000103HÖ\u0003J\t\u00104\u001a\u000205HÖ\u0001J\t\u00106\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0012\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0015R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0015R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0015R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0013\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$¨\u00067"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$ImageMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "label", "avatarUrl", "direction", "Lzendesk/core/ui/android/internal/model/MessageDirection;", "position", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "shape", "Lzendesk/core/ui/android/internal/model/MessageShape;", "status", "Lzendesk/conversationkit/android/model/MessageStatus;", "message", "Lzendesk/conversationkit/android/model/Message;", "receipt", "Lzendesk/messaging/android/internal/model/MessageReceipt;", "authorizationToken", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/core/ui/android/internal/model/MessageDirection;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/core/ui/android/internal/model/MessageShape;Lzendesk/conversationkit/android/model/MessageStatus;Lzendesk/conversationkit/android/model/Message;Lzendesk/messaging/android/internal/model/MessageReceipt;Ljava/lang/String;)V", "getAuthorizationToken", "()Ljava/lang/String;", "getAvatarUrl", "getDirection", "()Lzendesk/core/ui/android/internal/model/MessageDirection;", "getId", "getLabel", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "getPosition", "()Lzendesk/core/ui/android/internal/model/MessagePosition;", "getReceipt", "()Lzendesk/messaging/android/internal/model/MessageReceipt;", "getShape", "()Lzendesk/core/ui/android/internal/model/MessageShape;", "getStatus", "()Lzendesk/conversationkit/android/model/MessageStatus;", "component1", "component10", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ImageMessageContainer extends MessageLogEntry {
        private final String authorizationToken;
        private final String avatarUrl;
        private final MessageDirection direction;
        private final String id;
        private final String label;
        private final Message message;
        private final MessagePosition position;
        private final MessageReceipt receipt;
        private final MessageShape shape;
        private final MessageStatus status;

        public final String getId() {
            return this.id;
        }

        public final String getAuthorizationToken() {
            return this.authorizationToken;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public final ImageMessageContainer copy(String id, String label, String avatarUrl, MessageDirection direction, MessagePosition position, MessageShape shape, MessageStatus status, Message message, MessageReceipt receipt, String authorizationToken) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            return new ImageMessageContainer(id, label, avatarUrl, direction, position, shape, status, message, receipt, authorizationToken);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ImageMessageContainer)) {
                return false;
            }
            ImageMessageContainer imageMessageContainer = (ImageMessageContainer) other;
            return Intrinsics.areEqual(this.id, imageMessageContainer.id) && Intrinsics.areEqual(this.label, imageMessageContainer.label) && Intrinsics.areEqual(this.avatarUrl, imageMessageContainer.avatarUrl) && this.direction == imageMessageContainer.direction && this.position == imageMessageContainer.position && this.shape == imageMessageContainer.shape && Intrinsics.areEqual(this.status, imageMessageContainer.status) && Intrinsics.areEqual(this.message, imageMessageContainer.message) && Intrinsics.areEqual(this.receipt, imageMessageContainer.receipt) && Intrinsics.areEqual(this.authorizationToken, imageMessageContainer.authorizationToken);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.label;
            int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.avatarUrl;
            int iHashCode3 = (((((((((((iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31) + this.direction.hashCode()) * 31) + this.position.hashCode()) * 31) + this.shape.hashCode()) * 31) + this.status.hashCode()) * 31) + this.message.hashCode()) * 31;
            MessageReceipt messageReceipt = this.receipt;
            int iHashCode4 = (iHashCode3 + (messageReceipt == null ? 0 : messageReceipt.hashCode())) * 31;
            String str3 = this.authorizationToken;
            return iHashCode4 + (str3 != null ? str3.hashCode() : 0);
        }

        public String toString() {
            return "ImageMessageContainer(id=" + this.id + ", label=" + this.label + ", avatarUrl=" + this.avatarUrl + ", direction=" + this.direction + ", position=" + this.position + ", shape=" + this.shape + ", status=" + this.status + ", message=" + this.message + ", receipt=" + this.receipt + ", authorizationToken=" + this.authorizationToken + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public ImageMessageContainer(String str, String str2, String str3, MessageDirection messageDirection, MessagePosition messagePosition, MessageShape messageShape, MessageStatus messageStatus, Message message, MessageReceipt messageReceipt, String str4, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : str3, messageDirection, (i & 16) != 0 ? MessagePosition.STANDALONE : messagePosition, (i & 32) != 0 ? MessageShape.STANDALONE : messageShape, messageStatus, message, (i & 256) != 0 ? null : messageReceipt, (i & 512) != 0 ? null : str4);
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public final String getAuthorizationToken() {
            return this.authorizationToken;
        }

        public ImageMessageContainer(String id, String str, String str2, MessageDirection direction, MessagePosition position, MessageShape shape, MessageStatus status, Message message, MessageReceipt messageReceipt, String str3) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            this.id = id;
            this.label = str;
            this.avatarUrl = str2;
            this.direction = direction;
            this.position = position;
            this.shape = shape;
            this.status = status;
            this.message = message;
            this.receipt = messageReceipt;
            this.authorizationToken = str3;
        }
    }

    @Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001Bg\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\b\b\u0002\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\u0002\u0010\u0014J\t\u0010'\u001a\u00020\u0003HÆ\u0003J\u000b\u0010(\u001a\u0004\u0018\u00010\u0013HÆ\u0003J\u000b\u0010)\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010*\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010+\u001a\u00020\u0007HÆ\u0003J\t\u0010,\u001a\u00020\tHÆ\u0003J\t\u0010-\u001a\u00020\u000bHÆ\u0003J\t\u0010.\u001a\u00020\rHÆ\u0003J\t\u0010/\u001a\u00020\u000fHÆ\u0003J\t\u00100\u001a\u00020\u0011HÆ\u0003Js\u00101\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÆ\u0001J\u0013\u00102\u001a\u0002032\b\u00104\u001a\u0004\u0018\u000105HÖ\u0003J\t\u00106\u001a\u000207HÖ\u0001J\t\u00108\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0016R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u0011\u0010\u0010\u001a\u00020\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0013\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&¨\u00069"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$FileMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "label", "avatarUrl", "direction", "Lzendesk/core/ui/android/internal/model/MessageDirection;", "position", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "shape", "Lzendesk/core/ui/android/internal/model/MessageShape;", "size", "Lzendesk/messaging/android/internal/model/MessageSize;", "status", "Lzendesk/conversationkit/android/model/MessageStatus;", "message", "Lzendesk/conversationkit/android/model/Message;", "receipt", "Lzendesk/messaging/android/internal/model/MessageReceipt;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/core/ui/android/internal/model/MessageDirection;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/core/ui/android/internal/model/MessageShape;Lzendesk/messaging/android/internal/model/MessageSize;Lzendesk/conversationkit/android/model/MessageStatus;Lzendesk/conversationkit/android/model/Message;Lzendesk/messaging/android/internal/model/MessageReceipt;)V", "getAvatarUrl", "()Ljava/lang/String;", "getDirection", "()Lzendesk/core/ui/android/internal/model/MessageDirection;", "getId", "getLabel", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "getPosition", "()Lzendesk/core/ui/android/internal/model/MessagePosition;", "getReceipt", "()Lzendesk/messaging/android/internal/model/MessageReceipt;", "getShape", "()Lzendesk/core/ui/android/internal/model/MessageShape;", "getSize", "()Lzendesk/messaging/android/internal/model/MessageSize;", "getStatus", "()Lzendesk/conversationkit/android/model/MessageStatus;", "component1", "component10", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FileMessageContainer extends MessageLogEntry {
        private final String avatarUrl;
        private final MessageDirection direction;
        private final String id;
        private final String label;
        private final Message message;
        private final MessagePosition position;
        private final MessageReceipt receipt;
        private final MessageShape shape;
        private final MessageSize size;
        private final MessageStatus status;

        public final String getId() {
            return this.id;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final FileMessageContainer copy(String id, String label, String avatarUrl, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt receipt) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            return new FileMessageContainer(id, label, avatarUrl, direction, position, shape, size, status, message, receipt);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof FileMessageContainer)) {
                return false;
            }
            FileMessageContainer fileMessageContainer = (FileMessageContainer) other;
            return Intrinsics.areEqual(this.id, fileMessageContainer.id) && Intrinsics.areEqual(this.label, fileMessageContainer.label) && Intrinsics.areEqual(this.avatarUrl, fileMessageContainer.avatarUrl) && this.direction == fileMessageContainer.direction && this.position == fileMessageContainer.position && this.shape == fileMessageContainer.shape && this.size == fileMessageContainer.size && Intrinsics.areEqual(this.status, fileMessageContainer.status) && Intrinsics.areEqual(this.message, fileMessageContainer.message) && Intrinsics.areEqual(this.receipt, fileMessageContainer.receipt);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.label;
            int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.avatarUrl;
            int iHashCode3 = (((((((((((((iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31) + this.direction.hashCode()) * 31) + this.position.hashCode()) * 31) + this.shape.hashCode()) * 31) + this.size.hashCode()) * 31) + this.status.hashCode()) * 31) + this.message.hashCode()) * 31;
            MessageReceipt messageReceipt = this.receipt;
            return iHashCode3 + (messageReceipt != null ? messageReceipt.hashCode() : 0);
        }

        public String toString() {
            return "FileMessageContainer(id=" + this.id + ", label=" + this.label + ", avatarUrl=" + this.avatarUrl + ", direction=" + this.direction + ", position=" + this.position + ", shape=" + this.shape + ", size=" + this.size + ", status=" + this.status + ", message=" + this.message + ", receipt=" + this.receipt + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public FileMessageContainer(String str, String str2, String str3, MessageDirection messageDirection, MessagePosition messagePosition, MessageShape messageShape, MessageSize messageSize, MessageStatus messageStatus, Message message, MessageReceipt messageReceipt, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : str3, messageDirection, (i & 16) != 0 ? MessagePosition.STANDALONE : messagePosition, (i & 32) != 0 ? MessageShape.STANDALONE : messageShape, (i & 64) != 0 ? MessageSize.NORMAL : messageSize, messageStatus, message, (i & 512) != 0 ? null : messageReceipt);
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public FileMessageContainer(String id, String str, String str2, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt messageReceipt) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            this.id = id;
            this.label = str;
            this.avatarUrl = str2;
            this.direction = direction;
            this.position = position;
            this.shape = shape;
            this.size = size;
            this.status = status;
            this.message = message;
            this.receipt = messageReceipt;
        }
    }

    @Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0080\b\u0018\u00002\u00020\u0001Bg\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\b\b\u0002\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\u0002\u0010\u0014J\t\u0010'\u001a\u00020\u0003HÆ\u0003J\u000b\u0010(\u001a\u0004\u0018\u00010\u0013HÆ\u0003J\u000b\u0010)\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010*\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010+\u001a\u00020\u0007HÆ\u0003J\t\u0010,\u001a\u00020\tHÆ\u0003J\t\u0010-\u001a\u00020\u000bHÆ\u0003J\t\u0010.\u001a\u00020\rHÆ\u0003J\t\u0010/\u001a\u00020\u000fHÆ\u0003J\t\u00100\u001a\u00020\u0011HÆ\u0003Js\u00101\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÆ\u0001J\u0013\u00102\u001a\u0002032\b\u00104\u001a\u0004\u0018\u000105HÖ\u0003J\t\u00106\u001a\u000207HÖ\u0001J\t\u00108\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0016R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u0011\u0010\u0010\u001a\u00020\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0013\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&¨\u00069"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$TextMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "label", "avatarUrl", "direction", "Lzendesk/core/ui/android/internal/model/MessageDirection;", "position", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "shape", "Lzendesk/core/ui/android/internal/model/MessageShape;", "size", "Lzendesk/messaging/android/internal/model/MessageSize;", "status", "Lzendesk/conversationkit/android/model/MessageStatus;", "message", "Lzendesk/conversationkit/android/model/Message;", "receipt", "Lzendesk/messaging/android/internal/model/MessageReceipt;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/core/ui/android/internal/model/MessageDirection;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/core/ui/android/internal/model/MessageShape;Lzendesk/messaging/android/internal/model/MessageSize;Lzendesk/conversationkit/android/model/MessageStatus;Lzendesk/conversationkit/android/model/Message;Lzendesk/messaging/android/internal/model/MessageReceipt;)V", "getAvatarUrl", "()Ljava/lang/String;", "getDirection", "()Lzendesk/core/ui/android/internal/model/MessageDirection;", "getId", "getLabel", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "getPosition", "()Lzendesk/core/ui/android/internal/model/MessagePosition;", "getReceipt", "()Lzendesk/messaging/android/internal/model/MessageReceipt;", "getShape", "()Lzendesk/core/ui/android/internal/model/MessageShape;", "getSize", "()Lzendesk/messaging/android/internal/model/MessageSize;", "getStatus", "()Lzendesk/conversationkit/android/model/MessageStatus;", "component1", "component10", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class TextMessageContainer extends MessageLogEntry {
        private final String avatarUrl;
        private final MessageDirection direction;
        private final String id;
        private final String label;
        private final Message message;
        private final MessagePosition position;
        private final MessageReceipt receipt;
        private final MessageShape shape;
        private final MessageSize size;
        private final MessageStatus status;

        public final String getId() {
            return this.id;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final TextMessageContainer copy(String id, String label, String avatarUrl, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt receipt) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            return new TextMessageContainer(id, label, avatarUrl, direction, position, shape, size, status, message, receipt);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof TextMessageContainer)) {
                return false;
            }
            TextMessageContainer textMessageContainer = (TextMessageContainer) other;
            return Intrinsics.areEqual(this.id, textMessageContainer.id) && Intrinsics.areEqual(this.label, textMessageContainer.label) && Intrinsics.areEqual(this.avatarUrl, textMessageContainer.avatarUrl) && this.direction == textMessageContainer.direction && this.position == textMessageContainer.position && this.shape == textMessageContainer.shape && this.size == textMessageContainer.size && Intrinsics.areEqual(this.status, textMessageContainer.status) && Intrinsics.areEqual(this.message, textMessageContainer.message) && Intrinsics.areEqual(this.receipt, textMessageContainer.receipt);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.label;
            int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.avatarUrl;
            int iHashCode3 = (((((((((((((iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31) + this.direction.hashCode()) * 31) + this.position.hashCode()) * 31) + this.shape.hashCode()) * 31) + this.size.hashCode()) * 31) + this.status.hashCode()) * 31) + this.message.hashCode()) * 31;
            MessageReceipt messageReceipt = this.receipt;
            return iHashCode3 + (messageReceipt != null ? messageReceipt.hashCode() : 0);
        }

        public String toString() {
            return "TextMessageContainer(id=" + this.id + ", label=" + this.label + ", avatarUrl=" + this.avatarUrl + ", direction=" + this.direction + ", position=" + this.position + ", shape=" + this.shape + ", size=" + this.size + ", status=" + this.status + ", message=" + this.message + ", receipt=" + this.receipt + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public TextMessageContainer(String str, String str2, String str3, MessageDirection messageDirection, MessagePosition messagePosition, MessageShape messageShape, MessageSize messageSize, MessageStatus messageStatus, Message message, MessageReceipt messageReceipt, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : str3, messageDirection, (i & 16) != 0 ? MessagePosition.STANDALONE : messagePosition, (i & 32) != 0 ? MessageShape.STANDALONE : messageShape, (i & 64) != 0 ? MessageSize.NORMAL : messageSize, messageStatus, message, (i & 512) != 0 ? null : messageReceipt);
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public TextMessageContainer(String id, String str, String str2, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt messageReceipt) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            this.id = id;
            this.label = str;
            this.avatarUrl = str2;
            this.direction = direction;
            this.position = position;
            this.shape = shape;
            this.size = size;
            this.status = status;
            this.message = message;
            this.receipt = messageReceipt;
        }
    }

    @Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001Bg\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\b\b\u0002\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\u0002\u0010\u0014J\t\u0010'\u001a\u00020\u0003HÆ\u0003J\u000b\u0010(\u001a\u0004\u0018\u00010\u0013HÆ\u0003J\u000b\u0010)\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010*\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010+\u001a\u00020\u0007HÆ\u0003J\t\u0010,\u001a\u00020\tHÆ\u0003J\t\u0010-\u001a\u00020\u000bHÆ\u0003J\t\u0010.\u001a\u00020\rHÆ\u0003J\t\u0010/\u001a\u00020\u000fHÆ\u0003J\t\u00100\u001a\u00020\u0011HÆ\u0003Js\u00101\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÆ\u0001J\u0013\u00102\u001a\u0002032\b\u00104\u001a\u0004\u0018\u000105HÖ\u0003J\t\u00106\u001a\u000207HÖ\u0001J\t\u00108\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0016R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u0011\u0010\u0010\u001a\u00020\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0013\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&¨\u00069"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$FormMessageContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "label", "avatarUrl", "direction", "Lzendesk/core/ui/android/internal/model/MessageDirection;", "position", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "shape", "Lzendesk/core/ui/android/internal/model/MessageShape;", "size", "Lzendesk/messaging/android/internal/model/MessageSize;", "status", "Lzendesk/conversationkit/android/model/MessageStatus;", "message", "Lzendesk/conversationkit/android/model/Message;", "receipt", "Lzendesk/messaging/android/internal/model/MessageReceipt;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/core/ui/android/internal/model/MessageDirection;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/core/ui/android/internal/model/MessageShape;Lzendesk/messaging/android/internal/model/MessageSize;Lzendesk/conversationkit/android/model/MessageStatus;Lzendesk/conversationkit/android/model/Message;Lzendesk/messaging/android/internal/model/MessageReceipt;)V", "getAvatarUrl", "()Ljava/lang/String;", "getDirection", "()Lzendesk/core/ui/android/internal/model/MessageDirection;", "getId", "getLabel", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "getPosition", "()Lzendesk/core/ui/android/internal/model/MessagePosition;", "getReceipt", "()Lzendesk/messaging/android/internal/model/MessageReceipt;", "getShape", "()Lzendesk/core/ui/android/internal/model/MessageShape;", "getSize", "()Lzendesk/messaging/android/internal/model/MessageSize;", "getStatus", "()Lzendesk/conversationkit/android/model/MessageStatus;", "component1", "component10", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FormMessageContainer extends MessageLogEntry {
        private final String avatarUrl;
        private final MessageDirection direction;
        private final String id;
        private final String label;
        private final Message message;
        private final MessagePosition position;
        private final MessageReceipt receipt;
        private final MessageShape shape;
        private final MessageSize size;
        private final MessageStatus status;

        public final String getId() {
            return this.id;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final FormMessageContainer copy(String id, String label, String avatarUrl, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt receipt) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            return new FormMessageContainer(id, label, avatarUrl, direction, position, shape, size, status, message, receipt);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof FormMessageContainer)) {
                return false;
            }
            FormMessageContainer formMessageContainer = (FormMessageContainer) other;
            return Intrinsics.areEqual(this.id, formMessageContainer.id) && Intrinsics.areEqual(this.label, formMessageContainer.label) && Intrinsics.areEqual(this.avatarUrl, formMessageContainer.avatarUrl) && this.direction == formMessageContainer.direction && this.position == formMessageContainer.position && this.shape == formMessageContainer.shape && this.size == formMessageContainer.size && Intrinsics.areEqual(this.status, formMessageContainer.status) && Intrinsics.areEqual(this.message, formMessageContainer.message) && Intrinsics.areEqual(this.receipt, formMessageContainer.receipt);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.label;
            int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.avatarUrl;
            int iHashCode3 = (((((((((((((iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31) + this.direction.hashCode()) * 31) + this.position.hashCode()) * 31) + this.shape.hashCode()) * 31) + this.size.hashCode()) * 31) + this.status.hashCode()) * 31) + this.message.hashCode()) * 31;
            MessageReceipt messageReceipt = this.receipt;
            return iHashCode3 + (messageReceipt != null ? messageReceipt.hashCode() : 0);
        }

        public String toString() {
            return "FormMessageContainer(id=" + this.id + ", label=" + this.label + ", avatarUrl=" + this.avatarUrl + ", direction=" + this.direction + ", position=" + this.position + ", shape=" + this.shape + ", size=" + this.size + ", status=" + this.status + ", message=" + this.message + ", receipt=" + this.receipt + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public FormMessageContainer(String str, String str2, String str3, MessageDirection messageDirection, MessagePosition messagePosition, MessageShape messageShape, MessageSize messageSize, MessageStatus messageStatus, Message message, MessageReceipt messageReceipt, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : str3, messageDirection, (i & 16) != 0 ? MessagePosition.STANDALONE : messagePosition, (i & 32) != 0 ? MessageShape.STANDALONE : messageShape, (i & 64) != 0 ? MessageSize.NORMAL : messageSize, messageStatus, message, (i & 512) != 0 ? null : messageReceipt);
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public FormMessageContainer(String id, String str, String str2, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt messageReceipt) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            this.id = id;
            this.label = str;
            this.avatarUrl = str2;
            this.direction = direction;
            this.position = position;
            this.shape = shape;
            this.size = size;
            this.status = status;
            this.message = message;
            this.receipt = messageReceipt;
        }
    }

    @Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001Bg\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\b\b\u0002\u0010\b\u001a\u00020\t\u0012\b\b\u0002\u0010\n\u001a\u00020\u000b\u0012\b\b\u0002\u0010\f\u001a\u00020\r\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0011\u0012\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\u0002\u0010\u0014J\t\u0010'\u001a\u00020\u0003HÆ\u0003J\u000b\u0010(\u001a\u0004\u0018\u00010\u0013HÆ\u0003J\u000b\u0010)\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000b\u0010*\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\t\u0010+\u001a\u00020\u0007HÆ\u0003J\t\u0010,\u001a\u00020\tHÆ\u0003J\t\u0010-\u001a\u00020\u000bHÆ\u0003J\t\u0010.\u001a\u00020\rHÆ\u0003J\t\u0010/\u001a\u00020\u000fHÆ\u0003J\t\u00100\u001a\u00020\u0011HÆ\u0003Js\u00101\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\b\b\u0002\u0010\n\u001a\u00020\u000b2\b\b\u0002\u0010\f\u001a\u00020\r2\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00112\n\b\u0002\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÆ\u0001J\u0013\u00102\u001a\u0002032\b\u00104\u001a\u0004\u0018\u000105HÖ\u0003J\t\u00106\u001a\u000207HÖ\u0001J\t\u00108\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0014\u0010\u0002\u001a\u00020\u0003X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0016R\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0016R\u0011\u0010\u0010\u001a\u00020\u0011¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001cR\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0013\u0010\u0012\u001a\u0004\u0018\u00010\u0013¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010 R\u0011\u0010\n\u001a\u00020\u000b¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\"R\u0011\u0010\f\u001a\u00020\r¢\u0006\b\n\u0000\u001a\u0004\b#\u0010$R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b%\u0010&¨\u00069"}, m18d2 = {"Lzendesk/messaging/android/internal/model/MessageLogEntry$CarouselContainer;", "Lzendesk/messaging/android/internal/model/MessageLogEntry;", "id", "", "label", "avatarUrl", "direction", "Lzendesk/core/ui/android/internal/model/MessageDirection;", "position", "Lzendesk/core/ui/android/internal/model/MessagePosition;", "shape", "Lzendesk/core/ui/android/internal/model/MessageShape;", "size", "Lzendesk/messaging/android/internal/model/MessageSize;", "status", "Lzendesk/conversationkit/android/model/MessageStatus;", "message", "Lzendesk/conversationkit/android/model/Message;", "receipt", "Lzendesk/messaging/android/internal/model/MessageReceipt;", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lzendesk/core/ui/android/internal/model/MessageDirection;Lzendesk/core/ui/android/internal/model/MessagePosition;Lzendesk/core/ui/android/internal/model/MessageShape;Lzendesk/messaging/android/internal/model/MessageSize;Lzendesk/conversationkit/android/model/MessageStatus;Lzendesk/conversationkit/android/model/Message;Lzendesk/messaging/android/internal/model/MessageReceipt;)V", "getAvatarUrl", "()Ljava/lang/String;", "getDirection", "()Lzendesk/core/ui/android/internal/model/MessageDirection;", "getId", "getLabel", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "getPosition", "()Lzendesk/core/ui/android/internal/model/MessagePosition;", "getReceipt", "()Lzendesk/messaging/android/internal/model/MessageReceipt;", "getShape", "()Lzendesk/core/ui/android/internal/model/MessageShape;", "getSize", "()Lzendesk/messaging/android/internal/model/MessageSize;", "getStatus", "()Lzendesk/conversationkit/android/model/MessageStatus;", "component1", "component10", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "component9", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CarouselContainer extends MessageLogEntry {
        private final String avatarUrl;
        private final MessageDirection direction;
        private final String id;
        private final String label;
        private final Message message;
        private final MessagePosition position;
        private final MessageReceipt receipt;
        private final MessageShape shape;
        private final MessageSize size;
        private final MessageStatus status;

        public final String getId() {
            return this.id;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final CarouselContainer copy(String id, String label, String avatarUrl, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt receipt) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            return new CarouselContainer(id, label, avatarUrl, direction, position, shape, size, status, message, receipt);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof CarouselContainer)) {
                return false;
            }
            CarouselContainer carouselContainer = (CarouselContainer) other;
            return Intrinsics.areEqual(this.id, carouselContainer.id) && Intrinsics.areEqual(this.label, carouselContainer.label) && Intrinsics.areEqual(this.avatarUrl, carouselContainer.avatarUrl) && this.direction == carouselContainer.direction && this.position == carouselContainer.position && this.shape == carouselContainer.shape && this.size == carouselContainer.size && Intrinsics.areEqual(this.status, carouselContainer.status) && Intrinsics.areEqual(this.message, carouselContainer.message) && Intrinsics.areEqual(this.receipt, carouselContainer.receipt);
        }

        public int hashCode() {
            int iHashCode = this.id.hashCode() * 31;
            String str = this.label;
            int iHashCode2 = (iHashCode + (str == null ? 0 : str.hashCode())) * 31;
            String str2 = this.avatarUrl;
            int iHashCode3 = (((((((((((((iHashCode2 + (str2 == null ? 0 : str2.hashCode())) * 31) + this.direction.hashCode()) * 31) + this.position.hashCode()) * 31) + this.shape.hashCode()) * 31) + this.size.hashCode()) * 31) + this.status.hashCode()) * 31) + this.message.hashCode()) * 31;
            MessageReceipt messageReceipt = this.receipt;
            return iHashCode3 + (messageReceipt != null ? messageReceipt.hashCode() : 0);
        }

        public String toString() {
            return "CarouselContainer(id=" + this.id + ", label=" + this.label + ", avatarUrl=" + this.avatarUrl + ", direction=" + this.direction + ", position=" + this.position + ", shape=" + this.shape + ", size=" + this.size + ", status=" + this.status + ", message=" + this.message + ", receipt=" + this.receipt + ')';
        }

        @Override
        public String getId() {
            return this.id;
        }

        public final String getLabel() {
            return this.label;
        }

        public final String getAvatarUrl() {
            return this.avatarUrl;
        }

        public final MessageDirection getDirection() {
            return this.direction;
        }

        public CarouselContainer(String str, String str2, String str3, MessageDirection messageDirection, MessagePosition messagePosition, MessageShape messageShape, MessageSize messageSize, MessageStatus messageStatus, Message message, MessageReceipt messageReceipt, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : str2, (i & 4) != 0 ? null : str3, messageDirection, (i & 16) != 0 ? MessagePosition.STANDALONE : messagePosition, (i & 32) != 0 ? MessageShape.STANDALONE : messageShape, (i & 64) != 0 ? MessageSize.NORMAL : messageSize, messageStatus, message, (i & 512) != 0 ? null : messageReceipt);
        }

        public final MessagePosition getPosition() {
            return this.position;
        }

        public final MessageShape getShape() {
            return this.shape;
        }

        public final MessageSize getSize() {
            return this.size;
        }

        public final MessageStatus getStatus() {
            return this.status;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageReceipt getReceipt() {
            return this.receipt;
        }

        public CarouselContainer(String id, String str, String str2, MessageDirection direction, MessagePosition position, MessageShape shape, MessageSize size, MessageStatus status, Message message, MessageReceipt messageReceipt) {
            super(id, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(direction, "direction");
            Intrinsics.checkNotNullParameter(position, "position");
            Intrinsics.checkNotNullParameter(shape, "shape");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(status, "status");
            Intrinsics.checkNotNullParameter(message, "message");
            this.id = id;
            this.label = str;
            this.avatarUrl = str2;
            this.direction = direction;
            this.position = position;
            this.shape = shape;
            this.size = size;
            this.status = status;
            this.message = message;
            this.receipt = messageReceipt;
        }
    }
}
