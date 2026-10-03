package zendesk.android.events;

import java.util.List;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0007\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b6\u0018\u00002\u00020\u0001:\u0006\u0003\u0004\u0005\u0006\u0007\bB\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0006\t\n\u000b\f\r\u000e¨\u0006\u000f"}, m18d2 = {"Lzendesk/android/events/ZendeskEvent;", "", "()V", "AuthenticationFailed", "ConnectionStatusChanged", "ConversationAdded", "FieldValidationFailed", "SendMessageFailed", "UnreadMessageCountChanged", "Lzendesk/android/events/ZendeskEvent$AuthenticationFailed;", "Lzendesk/android/events/ZendeskEvent$ConnectionStatusChanged;", "Lzendesk/android/events/ZendeskEvent$ConversationAdded;", "Lzendesk/android/events/ZendeskEvent$FieldValidationFailed;", "Lzendesk/android/events/ZendeskEvent$SendMessageFailed;", "Lzendesk/android/events/ZendeskEvent$UnreadMessageCountChanged;", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ZendeskEvent {
    public ZendeskEvent(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private ZendeskEvent() {
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/android/events/ZendeskEvent$UnreadMessageCountChanged;", "Lzendesk/android/events/ZendeskEvent;", "currentUnreadCount", "", "(I)V", "getCurrentUnreadCount", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UnreadMessageCountChanged extends ZendeskEvent {
        private final int currentUnreadCount;

        public static UnreadMessageCountChanged copy$default(UnreadMessageCountChanged unreadMessageCountChanged, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = unreadMessageCountChanged.currentUnreadCount;
            }
            return unreadMessageCountChanged.copy(i);
        }

        public final int getCurrentUnreadCount() {
            return this.currentUnreadCount;
        }

        public final UnreadMessageCountChanged copy(int currentUnreadCount) {
            return new UnreadMessageCountChanged(currentUnreadCount);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UnreadMessageCountChanged) && this.currentUnreadCount == ((UnreadMessageCountChanged) other).currentUnreadCount;
        }

        public int hashCode() {
            return this.currentUnreadCount;
        }

        public String toString() {
            return "UnreadMessageCountChanged(currentUnreadCount=" + this.currentUnreadCount + ')';
        }

        public final int getCurrentUnreadCount() {
            return this.currentUnreadCount;
        }

        public UnreadMessageCountChanged(int i) {
            super(null);
            this.currentUnreadCount = i;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/android/events/ZendeskEvent$AuthenticationFailed;", "Lzendesk/android/events/ZendeskEvent;", "error", "", "(Ljava/lang/Throwable;)V", "getError", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AuthenticationFailed extends ZendeskEvent {
        private final Throwable error;

        public static AuthenticationFailed copy$default(AuthenticationFailed authenticationFailed, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = authenticationFailed.error;
            }
            return authenticationFailed.copy(th);
        }

        public final Throwable getError() {
            return this.error;
        }

        public final AuthenticationFailed copy(Throwable error) {
            Intrinsics.checkNotNullParameter(error, "error");
            return new AuthenticationFailed(error);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AuthenticationFailed) && Intrinsics.areEqual(this.error, ((AuthenticationFailed) other).error);
        }

        public int hashCode() {
            return this.error.hashCode();
        }

        public String toString() {
            return "AuthenticationFailed(error=" + this.error + ')';
        }

        public AuthenticationFailed(Throwable error) {
            super(null);
            Intrinsics.checkNotNullParameter(error, "error");
            this.error = error;
        }

        public final Throwable getError() {
            return this.error;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/android/events/ZendeskEvent$FieldValidationFailed;", "Lzendesk/android/events/ZendeskEvent;", "errors", "", "", "(Ljava/util/List;)V", "getErrors", "()Ljava/util/List;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FieldValidationFailed extends ZendeskEvent {
        private final List<Throwable> errors;

        public static FieldValidationFailed copy$default(FieldValidationFailed fieldValidationFailed, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                list = fieldValidationFailed.errors;
            }
            return fieldValidationFailed.copy(list);
        }

        public final List<Throwable> component1() {
            return this.errors;
        }

        public final FieldValidationFailed copy(List<? extends Throwable> errors) {
            Intrinsics.checkNotNullParameter(errors, "errors");
            return new FieldValidationFailed(errors);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof FieldValidationFailed) && Intrinsics.areEqual(this.errors, ((FieldValidationFailed) other).errors);
        }

        public int hashCode() {
            return this.errors.hashCode();
        }

        public String toString() {
            return "FieldValidationFailed(errors=" + this.errors + ')';
        }

        public FieldValidationFailed(List<? extends Throwable> errors) {
            super(null);
            Intrinsics.checkNotNullParameter(errors, "errors");
            this.errors = errors;
        }

        public final List<Throwable> getErrors() {
            return this.errors;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/android/events/ZendeskEvent$ConnectionStatusChanged;", "Lzendesk/android/events/ZendeskEvent;", "connectionStatus", "Lzendesk/android/events/ConnectionStatus;", "(Lzendesk/android/events/ConnectionStatus;)V", "getConnectionStatus", "()Lzendesk/android/events/ConnectionStatus;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConnectionStatusChanged extends ZendeskEvent {
        private final ConnectionStatus connectionStatus;

        public static ConnectionStatusChanged copy$default(ConnectionStatusChanged connectionStatusChanged, ConnectionStatus connectionStatus, int i, Object obj) {
            if ((i & 1) != 0) {
                connectionStatus = connectionStatusChanged.connectionStatus;
            }
            return connectionStatusChanged.copy(connectionStatus);
        }

        public final ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }

        public final ConnectionStatusChanged copy(ConnectionStatus connectionStatus) {
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            return new ConnectionStatusChanged(connectionStatus);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConnectionStatusChanged) && this.connectionStatus == ((ConnectionStatusChanged) other).connectionStatus;
        }

        public int hashCode() {
            return this.connectionStatus.hashCode();
        }

        public String toString() {
            return "ConnectionStatusChanged(connectionStatus=" + this.connectionStatus + ')';
        }

        public final ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }

        public ConnectionStatusChanged(ConnectionStatus connectionStatus) {
            super(null);
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            this.connectionStatus = connectionStatus;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/android/events/ZendeskEvent$SendMessageFailed;", "Lzendesk/android/events/ZendeskEvent;", "cause", "", "(Ljava/lang/Throwable;)V", "getCause", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendMessageFailed extends ZendeskEvent {
        private final Throwable cause;

        public static SendMessageFailed copy$default(SendMessageFailed sendMessageFailed, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = sendMessageFailed.cause;
            }
            return sendMessageFailed.copy(th);
        }

        public final Throwable getCause() {
            return this.cause;
        }

        public final SendMessageFailed copy(Throwable cause) {
            Intrinsics.checkNotNullParameter(cause, "cause");
            return new SendMessageFailed(cause);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof SendMessageFailed) && Intrinsics.areEqual(this.cause, ((SendMessageFailed) other).cause);
        }

        public int hashCode() {
            return this.cause.hashCode();
        }

        public String toString() {
            return "SendMessageFailed(cause=" + this.cause + ')';
        }

        public SendMessageFailed(Throwable cause) {
            super(null);
            Intrinsics.checkNotNullParameter(cause, "cause");
            this.cause = cause;
        }

        public final Throwable getCause() {
            return this.cause;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/android/events/ZendeskEvent$ConversationAdded;", "Lzendesk/android/events/ZendeskEvent;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationAdded extends ZendeskEvent {
        private final String conversationId;

        public static ConversationAdded copy$default(ConversationAdded conversationAdded, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = conversationAdded.conversationId;
            }
            return conversationAdded.copy(str);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final ConversationAdded copy(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new ConversationAdded(conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationAdded) && Intrinsics.areEqual(this.conversationId, ((ConversationAdded) other).conversationId);
        }

        public int hashCode() {
            return this.conversationId.hashCode();
        }

        public String toString() {
            return "ConversationAdded(conversationId=" + this.conversationId + ')';
        }

        public ConversationAdded(String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }
}
