package zendesk.conversationkit.android.model;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b6\u0018\u00002\u00020\u0001:\u0005\u0003\u0004\u0005\u0006\u0007B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0005\b\t\n\u000b\f¨\u0006\r"}, m18d2 = {"Lzendesk/conversationkit/android/model/ProactiveMessageStatus;", "", "()V", "ConversationHasBeenRepliedTo", "NotificationCannotBeDisplayed", "NotificationHasBeenClicked", "NotificationHasBeenDisplayed", "NotificationWillDisplay", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus$ConversationHasBeenRepliedTo;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus$NotificationCannotBeDisplayed;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus$NotificationHasBeenClicked;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus$NotificationHasBeenDisplayed;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus$NotificationWillDisplay;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ProactiveMessageStatus {
    public ProactiveMessageStatus(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private ProactiveMessageStatus() {
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/model/ProactiveMessageStatus$NotificationWillDisplay;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus;", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/model/ProactiveMessage;)V", "getProactiveMessage", "()Lzendesk/conversationkit/android/model/ProactiveMessage;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NotificationWillDisplay extends ProactiveMessageStatus {
        private final ProactiveMessage proactiveMessage;

        public static NotificationWillDisplay copy$default(NotificationWillDisplay notificationWillDisplay, ProactiveMessage proactiveMessage, int i, Object obj) {
            if ((i & 1) != 0) {
                proactiveMessage = notificationWillDisplay.proactiveMessage;
            }
            return notificationWillDisplay.copy(proactiveMessage);
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public final NotificationWillDisplay copy(ProactiveMessage proactiveMessage) {
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            return new NotificationWillDisplay(proactiveMessage);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof NotificationWillDisplay) && Intrinsics.areEqual(this.proactiveMessage, ((NotificationWillDisplay) other).proactiveMessage);
        }

        public int hashCode() {
            return this.proactiveMessage.hashCode();
        }

        public String toString() {
            return "NotificationWillDisplay(proactiveMessage=" + this.proactiveMessage + ')';
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public NotificationWillDisplay(ProactiveMessage proactiveMessage) {
            super(null);
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            this.proactiveMessage = proactiveMessage;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/model/ProactiveMessageStatus$NotificationHasBeenDisplayed;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus;", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/model/ProactiveMessage;)V", "getProactiveMessage", "()Lzendesk/conversationkit/android/model/ProactiveMessage;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NotificationHasBeenDisplayed extends ProactiveMessageStatus {
        private final ProactiveMessage proactiveMessage;

        public static NotificationHasBeenDisplayed copy$default(NotificationHasBeenDisplayed notificationHasBeenDisplayed, ProactiveMessage proactiveMessage, int i, Object obj) {
            if ((i & 1) != 0) {
                proactiveMessage = notificationHasBeenDisplayed.proactiveMessage;
            }
            return notificationHasBeenDisplayed.copy(proactiveMessage);
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public final NotificationHasBeenDisplayed copy(ProactiveMessage proactiveMessage) {
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            return new NotificationHasBeenDisplayed(proactiveMessage);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof NotificationHasBeenDisplayed) && Intrinsics.areEqual(this.proactiveMessage, ((NotificationHasBeenDisplayed) other).proactiveMessage);
        }

        public int hashCode() {
            return this.proactiveMessage.hashCode();
        }

        public String toString() {
            return "NotificationHasBeenDisplayed(proactiveMessage=" + this.proactiveMessage + ')';
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public NotificationHasBeenDisplayed(ProactiveMessage proactiveMessage) {
            super(null);
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            this.proactiveMessage = proactiveMessage;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/model/ProactiveMessageStatus$NotificationHasBeenClicked;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus;", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/model/ProactiveMessage;)V", "getProactiveMessage", "()Lzendesk/conversationkit/android/model/ProactiveMessage;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NotificationHasBeenClicked extends ProactiveMessageStatus {
        private final ProactiveMessage proactiveMessage;

        public static NotificationHasBeenClicked copy$default(NotificationHasBeenClicked notificationHasBeenClicked, ProactiveMessage proactiveMessage, int i, Object obj) {
            if ((i & 1) != 0) {
                proactiveMessage = notificationHasBeenClicked.proactiveMessage;
            }
            return notificationHasBeenClicked.copy(proactiveMessage);
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public final NotificationHasBeenClicked copy(ProactiveMessage proactiveMessage) {
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            return new NotificationHasBeenClicked(proactiveMessage);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof NotificationHasBeenClicked) && Intrinsics.areEqual(this.proactiveMessage, ((NotificationHasBeenClicked) other).proactiveMessage);
        }

        public int hashCode() {
            return this.proactiveMessage.hashCode();
        }

        public String toString() {
            return "NotificationHasBeenClicked(proactiveMessage=" + this.proactiveMessage + ')';
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public NotificationHasBeenClicked(ProactiveMessage proactiveMessage) {
            super(null);
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            this.proactiveMessage = proactiveMessage;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/model/ProactiveMessageStatus$ConversationHasBeenRepliedTo;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus;", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/model/ProactiveMessage;)V", "getProactiveMessage", "()Lzendesk/conversationkit/android/model/ProactiveMessage;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationHasBeenRepliedTo extends ProactiveMessageStatus {
        private final ProactiveMessage proactiveMessage;

        public static ConversationHasBeenRepliedTo copy$default(ConversationHasBeenRepliedTo conversationHasBeenRepliedTo, ProactiveMessage proactiveMessage, int i, Object obj) {
            if ((i & 1) != 0) {
                proactiveMessage = conversationHasBeenRepliedTo.proactiveMessage;
            }
            return conversationHasBeenRepliedTo.copy(proactiveMessage);
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public final ConversationHasBeenRepliedTo copy(ProactiveMessage proactiveMessage) {
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            return new ConversationHasBeenRepliedTo(proactiveMessage);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationHasBeenRepliedTo) && Intrinsics.areEqual(this.proactiveMessage, ((ConversationHasBeenRepliedTo) other).proactiveMessage);
        }

        public int hashCode() {
            return this.proactiveMessage.hashCode();
        }

        public String toString() {
            return "ConversationHasBeenRepliedTo(proactiveMessage=" + this.proactiveMessage + ')';
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public ConversationHasBeenRepliedTo(ProactiveMessage proactiveMessage) {
            super(null);
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            this.proactiveMessage = proactiveMessage;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/model/ProactiveMessageStatus$NotificationCannotBeDisplayed;", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus;", "reason", "", "(Ljava/lang/Throwable;)V", "getReason", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NotificationCannotBeDisplayed extends ProactiveMessageStatus {
        private final Throwable reason;

        public static NotificationCannotBeDisplayed copy$default(NotificationCannotBeDisplayed notificationCannotBeDisplayed, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = notificationCannotBeDisplayed.reason;
            }
            return notificationCannotBeDisplayed.copy(th);
        }

        public final Throwable getReason() {
            return this.reason;
        }

        public final NotificationCannotBeDisplayed copy(Throwable reason) {
            Intrinsics.checkNotNullParameter(reason, "reason");
            return new NotificationCannotBeDisplayed(reason);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof NotificationCannotBeDisplayed) && Intrinsics.areEqual(this.reason, ((NotificationCannotBeDisplayed) other).reason);
        }

        public int hashCode() {
            return this.reason.hashCode();
        }

        public String toString() {
            return "NotificationCannotBeDisplayed(reason=" + this.reason + ')';
        }

        public final Throwable getReason() {
            return this.reason;
        }

        public NotificationCannotBeDisplayed(Throwable reason) {
            super(null);
            Intrinsics.checkNotNullParameter(reason, "reason");
            this.reason = reason;
        }
    }
}
