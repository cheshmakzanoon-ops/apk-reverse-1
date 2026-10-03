package zendesk.conversationkit.android;

import java.io.File;
import java.util.List;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.model.ActivityEvent;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.MessageActionSize;
import zendesk.conversationkit.android.model.ProactiveMessageStatus;
import zendesk.conversationkit.android.model.User;

@Metadata(m17d1 = {"\u0000j\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0018\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b6\u0018\u00002\u00020\u0001:\u0017\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0017\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-./0¨\u00061"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent;", "", "()V", "ActivityEventReceived", "ConnectionStatusChanged", "ConversationAddedFailure", "ConversationAddedSuccess", "ConversationRemovedFailure", "ConversationRemovedSuccess", "ConversationUpdated", "ConversationUpdatedFailure", "LoadMoreMessages", "LogoutUserCompleted", "MessageReceived", "MessageUpdated", "OpenFileAttachment", "OpenWebViewMessageReceived", "PersistedUserReceived", "PostbackFailure", "PostbackSuccess", "ProactiveMessageStatusChanged", "PushTokenPrepared", "PushTokenUpdateResult", "SendMessageFailed", "UserAccessRevoked", "UserUpdated", "Lzendesk/conversationkit/android/ConversationKitEvent$ActivityEventReceived;", "Lzendesk/conversationkit/android/ConversationKitEvent$ConnectionStatusChanged;", "Lzendesk/conversationkit/android/ConversationKitEvent$ConversationAddedFailure;", "Lzendesk/conversationkit/android/ConversationKitEvent$ConversationAddedSuccess;", "Lzendesk/conversationkit/android/ConversationKitEvent$ConversationRemovedFailure;", "Lzendesk/conversationkit/android/ConversationKitEvent$ConversationRemovedSuccess;", "Lzendesk/conversationkit/android/ConversationKitEvent$ConversationUpdated;", "Lzendesk/conversationkit/android/ConversationKitEvent$ConversationUpdatedFailure;", "Lzendesk/conversationkit/android/ConversationKitEvent$LoadMoreMessages;", "Lzendesk/conversationkit/android/ConversationKitEvent$LogoutUserCompleted;", "Lzendesk/conversationkit/android/ConversationKitEvent$MessageReceived;", "Lzendesk/conversationkit/android/ConversationKitEvent$MessageUpdated;", "Lzendesk/conversationkit/android/ConversationKitEvent$OpenFileAttachment;", "Lzendesk/conversationkit/android/ConversationKitEvent$OpenWebViewMessageReceived;", "Lzendesk/conversationkit/android/ConversationKitEvent$PersistedUserReceived;", "Lzendesk/conversationkit/android/ConversationKitEvent$PostbackFailure;", "Lzendesk/conversationkit/android/ConversationKitEvent$PostbackSuccess;", "Lzendesk/conversationkit/android/ConversationKitEvent$ProactiveMessageStatusChanged;", "Lzendesk/conversationkit/android/ConversationKitEvent$PushTokenPrepared;", "Lzendesk/conversationkit/android/ConversationKitEvent$PushTokenUpdateResult;", "Lzendesk/conversationkit/android/ConversationKitEvent$SendMessageFailed;", "Lzendesk/conversationkit/android/ConversationKitEvent$UserAccessRevoked;", "Lzendesk/conversationkit/android/ConversationKitEvent$UserUpdated;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class ConversationKitEvent {
    public ConversationKitEvent(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private ConversationKitEvent() {
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ConnectionStatusChanged;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "(Lzendesk/conversationkit/android/ConnectionStatus;)V", "getConnectionStatus", "()Lzendesk/conversationkit/android/ConnectionStatus;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConnectionStatusChanged extends ConversationKitEvent {
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

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$UserAccessRevoked;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "cause", "", "(Ljava/lang/Throwable;)V", "getCause", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UserAccessRevoked extends ConversationKitEvent {
        private final Throwable cause;

        public static UserAccessRevoked copy$default(UserAccessRevoked userAccessRevoked, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = userAccessRevoked.cause;
            }
            return userAccessRevoked.copy(th);
        }

        public final Throwable getCause() {
            return this.cause;
        }

        public final UserAccessRevoked copy(Throwable cause) {
            Intrinsics.checkNotNullParameter(cause, "cause");
            return new UserAccessRevoked(cause);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UserAccessRevoked) && Intrinsics.areEqual(this.cause, ((UserAccessRevoked) other).cause);
        }

        public int hashCode() {
            return this.cause.hashCode();
        }

        public String toString() {
            return "UserAccessRevoked(cause=" + this.cause + ')';
        }

        public UserAccessRevoked(Throwable cause) {
            super(null);
            Intrinsics.checkNotNullParameter(cause, "cause");
            this.cause = cause;
        }

        public final Throwable getCause() {
            return this.cause;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$UserUpdated;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "user", "Lzendesk/conversationkit/android/model/User;", "(Lzendesk/conversationkit/android/model/User;)V", "getUser", "()Lzendesk/conversationkit/android/model/User;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UserUpdated extends ConversationKitEvent {
        private final User user;

        public static UserUpdated copy$default(UserUpdated userUpdated, User user, int i, Object obj) {
            if ((i & 1) != 0) {
                user = userUpdated.user;
            }
            return userUpdated.copy(user);
        }

        public final User getUser() {
            return this.user;
        }

        public final UserUpdated copy(User user) {
            Intrinsics.checkNotNullParameter(user, "user");
            return new UserUpdated(user);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UserUpdated) && Intrinsics.areEqual(this.user, ((UserUpdated) other).user);
        }

        public int hashCode() {
            return this.user.hashCode();
        }

        public String toString() {
            return "UserUpdated(user=" + this.user + ')';
        }

        public UserUpdated(User user) {
            super(null);
            Intrinsics.checkNotNullParameter(user, "user");
            this.user = user;
        }

        public final User getUser() {
            return this.user;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$LogoutUserCompleted;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LogoutUserCompleted extends ConversationKitEvent {
        private final ConversationKitResult<Unit> result;

        public static LogoutUserCompleted copy$default(LogoutUserCompleted logoutUserCompleted, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = logoutUserCompleted.result;
            }
            return logoutUserCompleted.copy(conversationKitResult);
        }

        public final ConversationKitResult<Unit> component1() {
            return this.result;
        }

        public final LogoutUserCompleted copy(ConversationKitResult<Unit> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new LogoutUserCompleted(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof LogoutUserCompleted) && Intrinsics.areEqual(this.result, ((LogoutUserCompleted) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "LogoutUserCompleted(result=" + this.result + ')';
        }

        public LogoutUserCompleted(ConversationKitResult<Unit> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }

        public final ConversationKitResult<Unit> getResult() {
            return this.result;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$MessageReceived;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "message", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MessageReceived extends ConversationKitEvent {
        private final String conversationId;
        private final Message message;

        public static MessageReceived copy$default(MessageReceived messageReceived, Message message, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                message = messageReceived.message;
            }
            if ((i & 2) != 0) {
                str = messageReceived.conversationId;
            }
            return messageReceived.copy(message, str);
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final MessageReceived copy(Message message, String conversationId) {
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new MessageReceived(message, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessageReceived)) {
                return false;
            }
            MessageReceived messageReceived = (MessageReceived) other;
            return Intrinsics.areEqual(this.message, messageReceived.message) && Intrinsics.areEqual(this.conversationId, messageReceived.conversationId);
        }

        public int hashCode() {
            return (this.message.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "MessageReceived(message=" + this.message + ", conversationId=" + this.conversationId + ')';
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public MessageReceived(Message message, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.message = message;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$SendMessageFailed;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "cause", "", "(Ljava/lang/Throwable;)V", "getCause", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendMessageFailed extends ConversationKitEvent {
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

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0003¢\u0006\u0002\u0010\u0007J\t\u0010\r\u001a\u00020\u0003HÆ\u0003J\t\u0010\u000e\u001a\u00020\u0005HÆ\u0003J\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J'\u0010\u0010\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0011\u001a\u00020\u00122\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014HÖ\u0003J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J\t\u0010\u0017\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\t¨\u0006\u0018"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$OpenWebViewMessageReceived;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "url", "", "size", "Lzendesk/conversationkit/android/model/MessageActionSize;", "conversationId", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/MessageActionSize;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getSize", "()Lzendesk/conversationkit/android/model/MessageActionSize;", "getUrl", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class OpenWebViewMessageReceived extends ConversationKitEvent {
        private final String conversationId;
        private final MessageActionSize size;
        private final String url;

        public static OpenWebViewMessageReceived copy$default(OpenWebViewMessageReceived openWebViewMessageReceived, String str, MessageActionSize messageActionSize, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = openWebViewMessageReceived.url;
            }
            if ((i & 2) != 0) {
                messageActionSize = openWebViewMessageReceived.size;
            }
            if ((i & 4) != 0) {
                str2 = openWebViewMessageReceived.conversationId;
            }
            return openWebViewMessageReceived.copy(str, messageActionSize, str2);
        }

        public final String getUrl() {
            return this.url;
        }

        public final MessageActionSize getSize() {
            return this.size;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final OpenWebViewMessageReceived copy(String url, MessageActionSize size, String conversationId) {
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new OpenWebViewMessageReceived(url, size, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof OpenWebViewMessageReceived)) {
                return false;
            }
            OpenWebViewMessageReceived openWebViewMessageReceived = (OpenWebViewMessageReceived) other;
            return Intrinsics.areEqual(this.url, openWebViewMessageReceived.url) && this.size == openWebViewMessageReceived.size && Intrinsics.areEqual(this.conversationId, openWebViewMessageReceived.conversationId);
        }

        public int hashCode() {
            return (((this.url.hashCode() * 31) + this.size.hashCode()) * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "OpenWebViewMessageReceived(url=" + this.url + ", size=" + this.size + ", conversationId=" + this.conversationId + ')';
        }

        public final String getUrl() {
            return this.url;
        }

        public final MessageActionSize getSize() {
            return this.size;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public OpenWebViewMessageReceived(String url, MessageActionSize size, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.url = url;
            this.size = size;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001b\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0006HÆ\u0003J#\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0006HÖ\u0001R\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$LoadMoreMessages;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "listOfMessages", "", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "(Ljava/util/List;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getListOfMessages", "()Ljava/util/List;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadMoreMessages extends ConversationKitEvent {
        private final String conversationId;
        private final List<Message> listOfMessages;

        public static LoadMoreMessages copy$default(LoadMoreMessages loadMoreMessages, List list, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                list = loadMoreMessages.listOfMessages;
            }
            if ((i & 2) != 0) {
                str = loadMoreMessages.conversationId;
            }
            return loadMoreMessages.copy(list, str);
        }

        public final List<Message> component1() {
            return this.listOfMessages;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final LoadMoreMessages copy(List<Message> listOfMessages, String conversationId) {
            Intrinsics.checkNotNullParameter(listOfMessages, "listOfMessages");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new LoadMoreMessages(listOfMessages, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LoadMoreMessages)) {
                return false;
            }
            LoadMoreMessages loadMoreMessages = (LoadMoreMessages) other;
            return Intrinsics.areEqual(this.listOfMessages, loadMoreMessages.listOfMessages) && Intrinsics.areEqual(this.conversationId, loadMoreMessages.conversationId);
        }

        public int hashCode() {
            return (this.listOfMessages.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "LoadMoreMessages(listOfMessages=" + this.listOfMessages + ", conversationId=" + this.conversationId + ')';
        }

        public final List<Message> getListOfMessages() {
            return this.listOfMessages;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public LoadMoreMessages(List<Message> listOfMessages, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(listOfMessages, "listOfMessages");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.listOfMessages = listOfMessages;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$MessageUpdated;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "message", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MessageUpdated extends ConversationKitEvent {
        private final String conversationId;
        private final Message message;

        public static MessageUpdated copy$default(MessageUpdated messageUpdated, Message message, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                message = messageUpdated.message;
            }
            if ((i & 2) != 0) {
                str = messageUpdated.conversationId;
            }
            return messageUpdated.copy(message, str);
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final MessageUpdated copy(Message message, String conversationId) {
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new MessageUpdated(message, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessageUpdated)) {
                return false;
            }
            MessageUpdated messageUpdated = (MessageUpdated) other;
            return Intrinsics.areEqual(this.message, messageUpdated.message) && Intrinsics.areEqual(this.conversationId, messageUpdated.conversationId);
        }

        public int hashCode() {
            return (this.message.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "MessageUpdated(message=" + this.message + ", conversationId=" + this.conversationId + ')';
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public MessageUpdated(Message message, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.message = message;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ConversationUpdated;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/model/Conversation;)V", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationUpdated extends ConversationKitEvent {
        private final Conversation conversation;

        public static ConversationUpdated copy$default(ConversationUpdated conversationUpdated, Conversation conversation, int i, Object obj) {
            if ((i & 1) != 0) {
                conversation = conversationUpdated.conversation;
            }
            return conversationUpdated.copy(conversation);
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final ConversationUpdated copy(Conversation conversation) {
            Intrinsics.checkNotNullParameter(conversation, "conversation");
            return new ConversationUpdated(conversation);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationUpdated) && Intrinsics.areEqual(this.conversation, ((ConversationUpdated) other).conversation);
        }

        public int hashCode() {
            return this.conversation.hashCode();
        }

        public String toString() {
            return "ConversationUpdated(conversation=" + this.conversation + ')';
        }

        public ConversationUpdated(Conversation conversation) {
            super(null);
            Intrinsics.checkNotNullParameter(conversation, "conversation");
            this.conversation = conversation;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ConversationUpdatedFailure;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "cause", "", "(Ljava/lang/Throwable;)V", "getCause", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationUpdatedFailure extends ConversationKitEvent {
        private final Throwable cause;

        public static ConversationUpdatedFailure copy$default(ConversationUpdatedFailure conversationUpdatedFailure, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = conversationUpdatedFailure.cause;
            }
            return conversationUpdatedFailure.copy(th);
        }

        public final Throwable getCause() {
            return this.cause;
        }

        public final ConversationUpdatedFailure copy(Throwable cause) {
            Intrinsics.checkNotNullParameter(cause, "cause");
            return new ConversationUpdatedFailure(cause);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationUpdatedFailure) && Intrinsics.areEqual(this.cause, ((ConversationUpdatedFailure) other).cause);
        }

        public int hashCode() {
            return this.cause.hashCode();
        }

        public String toString() {
            return "ConversationUpdatedFailure(cause=" + this.cause + ')';
        }

        public ConversationUpdatedFailure(Throwable cause) {
            super(null);
            Intrinsics.checkNotNullParameter(cause, "cause");
            this.cause = cause;
        }

        public final Throwable getCause() {
            return this.cause;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$PushTokenPrepared;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "pushNotificationToken", "", "(Ljava/lang/String;)V", "getPushNotificationToken", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PushTokenPrepared extends ConversationKitEvent {
        private final String pushNotificationToken;

        public static PushTokenPrepared copy$default(PushTokenPrepared pushTokenPrepared, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = pushTokenPrepared.pushNotificationToken;
            }
            return pushTokenPrepared.copy(str);
        }

        public final String getPushNotificationToken() {
            return this.pushNotificationToken;
        }

        public final PushTokenPrepared copy(String pushNotificationToken) {
            Intrinsics.checkNotNullParameter(pushNotificationToken, "pushNotificationToken");
            return new PushTokenPrepared(pushNotificationToken);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof PushTokenPrepared) && Intrinsics.areEqual(this.pushNotificationToken, ((PushTokenPrepared) other).pushNotificationToken);
        }

        public int hashCode() {
            return this.pushNotificationToken.hashCode();
        }

        public String toString() {
            return "PushTokenPrepared(pushNotificationToken=" + this.pushNotificationToken + ')';
        }

        public PushTokenPrepared(String pushNotificationToken) {
            super(null);
            Intrinsics.checkNotNullParameter(pushNotificationToken, "pushNotificationToken");
            this.pushNotificationToken = pushNotificationToken;
        }

        public final String getPushNotificationToken() {
            return this.pushNotificationToken;
        }
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001b\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0006HÆ\u0003J#\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0006HÖ\u0001R\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$PushTokenUpdateResult;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "", "pushNotificationToken", "", "(Lzendesk/conversationkit/android/ConversationKitResult;Ljava/lang/String;)V", "getPushNotificationToken", "()Ljava/lang/String;", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PushTokenUpdateResult extends ConversationKitEvent {
        private final String pushNotificationToken;
        private final ConversationKitResult<Unit> result;

        public static PushTokenUpdateResult copy$default(PushTokenUpdateResult pushTokenUpdateResult, ConversationKitResult conversationKitResult, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = pushTokenUpdateResult.result;
            }
            if ((i & 2) != 0) {
                str = pushTokenUpdateResult.pushNotificationToken;
            }
            return pushTokenUpdateResult.copy(conversationKitResult, str);
        }

        public final ConversationKitResult<Unit> component1() {
            return this.result;
        }

        public final String getPushNotificationToken() {
            return this.pushNotificationToken;
        }

        public final PushTokenUpdateResult copy(ConversationKitResult<Unit> result, String pushNotificationToken) {
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(pushNotificationToken, "pushNotificationToken");
            return new PushTokenUpdateResult(result, pushNotificationToken);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof PushTokenUpdateResult)) {
                return false;
            }
            PushTokenUpdateResult pushTokenUpdateResult = (PushTokenUpdateResult) other;
            return Intrinsics.areEqual(this.result, pushTokenUpdateResult.result) && Intrinsics.areEqual(this.pushNotificationToken, pushTokenUpdateResult.pushNotificationToken);
        }

        public int hashCode() {
            return (this.result.hashCode() * 31) + this.pushNotificationToken.hashCode();
        }

        public String toString() {
            return "PushTokenUpdateResult(result=" + this.result + ", pushNotificationToken=" + this.pushNotificationToken + ')';
        }

        public final ConversationKitResult<Unit> getResult() {
            return this.result;
        }

        public final String getPushNotificationToken() {
            return this.pushNotificationToken;
        }

        public PushTokenUpdateResult(ConversationKitResult<Unit> result, String pushNotificationToken) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(pushNotificationToken, "pushNotificationToken");
            this.result = result;
            this.pushNotificationToken = pushNotificationToken;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ActivityEventReceived;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "activityEvent", "Lzendesk/conversationkit/android/model/ActivityEvent;", "(Lzendesk/conversationkit/android/model/ActivityEvent;)V", "getActivityEvent", "()Lzendesk/conversationkit/android/model/ActivityEvent;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ActivityEventReceived extends ConversationKitEvent {
        private final ActivityEvent activityEvent;

        public static ActivityEventReceived copy$default(ActivityEventReceived activityEventReceived, ActivityEvent activityEvent, int i, Object obj) {
            if ((i & 1) != 0) {
                activityEvent = activityEventReceived.activityEvent;
            }
            return activityEventReceived.copy(activityEvent);
        }

        public final ActivityEvent getActivityEvent() {
            return this.activityEvent;
        }

        public final ActivityEventReceived copy(ActivityEvent activityEvent) {
            Intrinsics.checkNotNullParameter(activityEvent, "activityEvent");
            return new ActivityEventReceived(activityEvent);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ActivityEventReceived) && Intrinsics.areEqual(this.activityEvent, ((ActivityEventReceived) other).activityEvent);
        }

        public int hashCode() {
            return this.activityEvent.hashCode();
        }

        public String toString() {
            return "ActivityEventReceived(activityEvent=" + this.activityEvent + ')';
        }

        public final ActivityEvent getActivityEvent() {
            return this.activityEvent;
        }

        public ActivityEventReceived(ActivityEvent activityEvent) {
            super(null);
            Intrinsics.checkNotNullParameter(activityEvent, "activityEvent");
            this.activityEvent = activityEvent;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$PersistedUserReceived;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "user", "Lzendesk/conversationkit/android/model/User;", "(Lzendesk/conversationkit/android/model/User;)V", "getUser", "()Lzendesk/conversationkit/android/model/User;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PersistedUserReceived extends ConversationKitEvent {
        private final User user;

        public static PersistedUserReceived copy$default(PersistedUserReceived persistedUserReceived, User user, int i, Object obj) {
            if ((i & 1) != 0) {
                user = persistedUserReceived.user;
            }
            return persistedUserReceived.copy(user);
        }

        public final User getUser() {
            return this.user;
        }

        public final PersistedUserReceived copy(User user) {
            Intrinsics.checkNotNullParameter(user, "user");
            return new PersistedUserReceived(user);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof PersistedUserReceived) && Intrinsics.areEqual(this.user, ((PersistedUserReceived) other).user);
        }

        public int hashCode() {
            return this.user.hashCode();
        }

        public String toString() {
            return "PersistedUserReceived(user=" + this.user + ')';
        }

        public final User getUser() {
            return this.user;
        }

        public PersistedUserReceived(User user) {
            super(null);
            Intrinsics.checkNotNullParameter(user, "user");
            this.user = user;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ProactiveMessageStatusChanged;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "status", "Lzendesk/conversationkit/android/model/ProactiveMessageStatus;", "(Lzendesk/conversationkit/android/model/ProactiveMessageStatus;)V", "getStatus", "()Lzendesk/conversationkit/android/model/ProactiveMessageStatus;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ProactiveMessageStatusChanged extends ConversationKitEvent {
        private final ProactiveMessageStatus status;

        public static ProactiveMessageStatusChanged copy$default(ProactiveMessageStatusChanged proactiveMessageStatusChanged, ProactiveMessageStatus proactiveMessageStatus, int i, Object obj) {
            if ((i & 1) != 0) {
                proactiveMessageStatus = proactiveMessageStatusChanged.status;
            }
            return proactiveMessageStatusChanged.copy(proactiveMessageStatus);
        }

        public final ProactiveMessageStatus getStatus() {
            return this.status;
        }

        public final ProactiveMessageStatusChanged copy(ProactiveMessageStatus status) {
            Intrinsics.checkNotNullParameter(status, "status");
            return new ProactiveMessageStatusChanged(status);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ProactiveMessageStatusChanged) && Intrinsics.areEqual(this.status, ((ProactiveMessageStatusChanged) other).status);
        }

        public int hashCode() {
            return this.status.hashCode();
        }

        public String toString() {
            return "ProactiveMessageStatusChanged(status=" + this.status + ')';
        }

        public final ProactiveMessageStatus getStatus() {
            return this.status;
        }

        public ProactiveMessageStatusChanged(ProactiveMessageStatus status) {
            super(null);
            Intrinsics.checkNotNullParameter(status, "status");
            this.status = status;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ConversationAddedSuccess;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/model/Conversation;)V", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationAddedSuccess extends ConversationKitEvent {
        private final Conversation conversation;

        public static ConversationAddedSuccess copy$default(ConversationAddedSuccess conversationAddedSuccess, Conversation conversation, int i, Object obj) {
            if ((i & 1) != 0) {
                conversation = conversationAddedSuccess.conversation;
            }
            return conversationAddedSuccess.copy(conversation);
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final ConversationAddedSuccess copy(Conversation conversation) {
            Intrinsics.checkNotNullParameter(conversation, "conversation");
            return new ConversationAddedSuccess(conversation);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationAddedSuccess) && Intrinsics.areEqual(this.conversation, ((ConversationAddedSuccess) other).conversation);
        }

        public int hashCode() {
            return this.conversation.hashCode();
        }

        public String toString() {
            return "ConversationAddedSuccess(conversation=" + this.conversation + ')';
        }

        public ConversationAddedSuccess(Conversation conversation) {
            super(null);
            Intrinsics.checkNotNullParameter(conversation, "conversation");
            this.conversation = conversation;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ConversationAddedFailure;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "cause", "", "(Ljava/lang/Throwable;)V", "getCause", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationAddedFailure extends ConversationKitEvent {
        private final Throwable cause;

        public static ConversationAddedFailure copy$default(ConversationAddedFailure conversationAddedFailure, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = conversationAddedFailure.cause;
            }
            return conversationAddedFailure.copy(th);
        }

        public final Throwable getCause() {
            return this.cause;
        }

        public final ConversationAddedFailure copy(Throwable cause) {
            Intrinsics.checkNotNullParameter(cause, "cause");
            return new ConversationAddedFailure(cause);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationAddedFailure) && Intrinsics.areEqual(this.cause, ((ConversationAddedFailure) other).cause);
        }

        public int hashCode() {
            return this.cause.hashCode();
        }

        public String toString() {
            return "ConversationAddedFailure(cause=" + this.cause + ')';
        }

        public ConversationAddedFailure(Throwable cause) {
            super(null);
            Intrinsics.checkNotNullParameter(cause, "cause");
            this.cause = cause;
        }

        public final Throwable getCause() {
            return this.cause;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ConversationRemovedSuccess;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationRemovedSuccess extends ConversationKitEvent {
        private final String conversationId;

        public static ConversationRemovedSuccess copy$default(ConversationRemovedSuccess conversationRemovedSuccess, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = conversationRemovedSuccess.conversationId;
            }
            return conversationRemovedSuccess.copy(str);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final ConversationRemovedSuccess copy(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new ConversationRemovedSuccess(conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationRemovedSuccess) && Intrinsics.areEqual(this.conversationId, ((ConversationRemovedSuccess) other).conversationId);
        }

        public int hashCode() {
            return this.conversationId.hashCode();
        }

        public String toString() {
            return "ConversationRemovedSuccess(conversationId=" + this.conversationId + ')';
        }

        public ConversationRemovedSuccess(String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$ConversationRemovedFailure;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "cause", "", "(Ljava/lang/Throwable;)V", "getCause", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationRemovedFailure extends ConversationKitEvent {
        private final Throwable cause;

        public static ConversationRemovedFailure copy$default(ConversationRemovedFailure conversationRemovedFailure, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = conversationRemovedFailure.cause;
            }
            return conversationRemovedFailure.copy(th);
        }

        public final Throwable getCause() {
            return this.cause;
        }

        public final ConversationRemovedFailure copy(Throwable cause) {
            Intrinsics.checkNotNullParameter(cause, "cause");
            return new ConversationRemovedFailure(cause);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationRemovedFailure) && Intrinsics.areEqual(this.cause, ((ConversationRemovedFailure) other).cause);
        }

        public int hashCode() {
            return this.cause.hashCode();
        }

        public String toString() {
            return "ConversationRemovedFailure(cause=" + this.cause + ')';
        }

        public ConversationRemovedFailure(Throwable cause) {
            super(null);
            Intrinsics.checkNotNullParameter(cause, "cause");
            this.cause = cause;
        }

        public final Throwable getCause() {
            return this.cause;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$PostbackFailure;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "cause", "", "(Ljava/lang/Throwable;)V", "getCause", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PostbackFailure extends ConversationKitEvent {
        private final Throwable cause;

        public static PostbackFailure copy$default(PostbackFailure postbackFailure, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = postbackFailure.cause;
            }
            return postbackFailure.copy(th);
        }

        public final Throwable getCause() {
            return this.cause;
        }

        public final PostbackFailure copy(Throwable cause) {
            Intrinsics.checkNotNullParameter(cause, "cause");
            return new PostbackFailure(cause);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof PostbackFailure) && Intrinsics.areEqual(this.cause, ((PostbackFailure) other).cause);
        }

        public int hashCode() {
            return this.cause.hashCode();
        }

        public String toString() {
            return "PostbackFailure(cause=" + this.cause + ')';
        }

        public PostbackFailure(Throwable cause) {
            super(null);
            Intrinsics.checkNotNullParameter(cause, "cause");
            this.cause = cause;
        }

        public final Throwable getCause() {
            return this.cause;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$PostbackSuccess;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "actionId", "", "(Ljava/lang/String;)V", "getActionId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PostbackSuccess extends ConversationKitEvent {
        private final String actionId;

        public static PostbackSuccess copy$default(PostbackSuccess postbackSuccess, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = postbackSuccess.actionId;
            }
            return postbackSuccess.copy(str);
        }

        public final String getActionId() {
            return this.actionId;
        }

        public final PostbackSuccess copy(String actionId) {
            Intrinsics.checkNotNullParameter(actionId, "actionId");
            return new PostbackSuccess(actionId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof PostbackSuccess) && Intrinsics.areEqual(this.actionId, ((PostbackSuccess) other).actionId);
        }

        public int hashCode() {
            return this.actionId.hashCode();
        }

        public String toString() {
            return "PostbackSuccess(actionId=" + this.actionId + ')';
        }

        public PostbackSuccess(String actionId) {
            super(null);
            Intrinsics.checkNotNullParameter(actionId, "actionId");
            this.actionId = actionId;
        }

        public final String getActionId() {
            return this.actionId;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitEvent$OpenFileAttachment;", "Lzendesk/conversationkit/android/ConversationKitEvent;", "file", "Ljava/io/File;", "conversationId", "", "(Ljava/io/File;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getFile", "()Ljava/io/File;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class OpenFileAttachment extends ConversationKitEvent {
        private final String conversationId;
        private final File file;

        public static OpenFileAttachment copy$default(OpenFileAttachment openFileAttachment, File file, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                file = openFileAttachment.file;
            }
            if ((i & 2) != 0) {
                str = openFileAttachment.conversationId;
            }
            return openFileAttachment.copy(file, str);
        }

        public final File getFile() {
            return this.file;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final OpenFileAttachment copy(File file, String conversationId) {
            Intrinsics.checkNotNullParameter(file, "file");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new OpenFileAttachment(file, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof OpenFileAttachment)) {
                return false;
            }
            OpenFileAttachment openFileAttachment = (OpenFileAttachment) other;
            return Intrinsics.areEqual(this.file, openFileAttachment.file) && Intrinsics.areEqual(this.conversationId, openFileAttachment.conversationId);
        }

        public int hashCode() {
            return (this.file.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "OpenFileAttachment(file=" + this.file + ", conversationId=" + this.conversationId + ')';
        }

        public final File getFile() {
            return this.file;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public OpenFileAttachment(File file, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(file, "file");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.file = file;
            this.conversationId = conversationId;
        }
    }
}
