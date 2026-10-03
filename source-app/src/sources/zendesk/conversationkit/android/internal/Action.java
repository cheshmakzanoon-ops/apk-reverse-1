package zendesk.conversationkit.android.internal;

import androidx.compose.animation.core.ComplexDouble$;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.model.ActivityData;
import zendesk.conversationkit.android.model.ActivityEvent;
import zendesk.conversationkit.android.model.ConversationStatus;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.UserMerge;
import zendesk.conversationkit.android.model.VisitType;
import zendesk.conversationkit.android.model.attachments.DownloadAttachmentStatus;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000º\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:+\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&'()*+,-B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001+./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWX¨\u0006Y"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action;", "", "()V", "ActivityEventReceived", "AddConversationFields", "AddConversationTags", "AddProactiveMessage", "CheckForPersistedUser", "ClearConversationFields", "ClearConversationTags", "ClearProactiveMessage", "ConversationAdded", "ConversationRemoved", "ConversationUpdate", "CreateConversation", "CreateUser", "DownloadAttachmentAction", "GetConversation", "GetConversations", "GetProactiveMessage", "GetVisitType", "GetWaitTimeForConversation", "LoadMoreMessages", "LoginUser", "LogoutUser", "MessageReceived", "NetworkConnectionStatusUpdate", "PauseRealtimeConnection", "PersistedUserRetrieve", "PrepareMessage", "PreparePushToken", "ProactiveMessageReferral", "PushCacheIntegrationId", "RealtimeConnectionStatusUpdate", "RefreshConversation", "RefreshUser", "SendActivityData", "SendMessage", "SendPostbackAction", "SetVisitType", "StartRealtimeConnection", "UpdateAppUserLocale", "UpdateConversationMetadata", "UpdateDownloadStatusAction", "UpdatePushToken", "UserMergeReceived", "Lzendesk/conversationkit/android/internal/Action$ActivityEventReceived;", "Lzendesk/conversationkit/android/internal/Action$AddConversationFields;", "Lzendesk/conversationkit/android/internal/Action$AddConversationTags;", "Lzendesk/conversationkit/android/internal/Action$AddProactiveMessage;", "Lzendesk/conversationkit/android/internal/Action$CheckForPersistedUser;", "Lzendesk/conversationkit/android/internal/Action$ClearConversationFields;", "Lzendesk/conversationkit/android/internal/Action$ClearConversationTags;", "Lzendesk/conversationkit/android/internal/Action$ClearProactiveMessage;", "Lzendesk/conversationkit/android/internal/Action$ConversationAdded;", "Lzendesk/conversationkit/android/internal/Action$ConversationRemoved;", "Lzendesk/conversationkit/android/internal/Action$ConversationUpdate;", "Lzendesk/conversationkit/android/internal/Action$CreateConversation;", "Lzendesk/conversationkit/android/internal/Action$CreateUser;", "Lzendesk/conversationkit/android/internal/Action$DownloadAttachmentAction;", "Lzendesk/conversationkit/android/internal/Action$GetConversation;", "Lzendesk/conversationkit/android/internal/Action$GetConversations;", "Lzendesk/conversationkit/android/internal/Action$GetProactiveMessage;", "Lzendesk/conversationkit/android/internal/Action$GetVisitType;", "Lzendesk/conversationkit/android/internal/Action$GetWaitTimeForConversation;", "Lzendesk/conversationkit/android/internal/Action$LoadMoreMessages;", "Lzendesk/conversationkit/android/internal/Action$LoginUser;", "Lzendesk/conversationkit/android/internal/Action$LogoutUser;", "Lzendesk/conversationkit/android/internal/Action$MessageReceived;", "Lzendesk/conversationkit/android/internal/Action$NetworkConnectionStatusUpdate;", "Lzendesk/conversationkit/android/internal/Action$PauseRealtimeConnection;", "Lzendesk/conversationkit/android/internal/Action$PersistedUserRetrieve;", "Lzendesk/conversationkit/android/internal/Action$PrepareMessage;", "Lzendesk/conversationkit/android/internal/Action$PreparePushToken;", "Lzendesk/conversationkit/android/internal/Action$ProactiveMessageReferral;", "Lzendesk/conversationkit/android/internal/Action$PushCacheIntegrationId;", "Lzendesk/conversationkit/android/internal/Action$RealtimeConnectionStatusUpdate;", "Lzendesk/conversationkit/android/internal/Action$RefreshConversation;", "Lzendesk/conversationkit/android/internal/Action$RefreshUser;", "Lzendesk/conversationkit/android/internal/Action$SendActivityData;", "Lzendesk/conversationkit/android/internal/Action$SendMessage;", "Lzendesk/conversationkit/android/internal/Action$SendPostbackAction;", "Lzendesk/conversationkit/android/internal/Action$SetVisitType;", "Lzendesk/conversationkit/android/internal/Action$StartRealtimeConnection;", "Lzendesk/conversationkit/android/internal/Action$UpdateAppUserLocale;", "Lzendesk/conversationkit/android/internal/Action$UpdateConversationMetadata;", "Lzendesk/conversationkit/android/internal/Action$UpdateDownloadStatusAction;", "Lzendesk/conversationkit/android/internal/Action$UpdatePushToken;", "Lzendesk/conversationkit/android/internal/Action$UserMergeReceived;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class Action {
    public Action(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private Action() {
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$RealtimeConnectionStatusUpdate;", "Lzendesk/conversationkit/android/internal/Action;", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "(Lzendesk/conversationkit/android/ConnectionStatus;)V", "getConnectionStatus", "()Lzendesk/conversationkit/android/ConnectionStatus;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RealtimeConnectionStatusUpdate extends Action {
        private final ConnectionStatus connectionStatus;

        public static RealtimeConnectionStatusUpdate copy$default(RealtimeConnectionStatusUpdate realtimeConnectionStatusUpdate, ConnectionStatus connectionStatus, int i, Object obj) {
            if ((i & 1) != 0) {
                connectionStatus = realtimeConnectionStatusUpdate.connectionStatus;
            }
            return realtimeConnectionStatusUpdate.copy(connectionStatus);
        }

        public final ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }

        public final RealtimeConnectionStatusUpdate copy(ConnectionStatus connectionStatus) {
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            return new RealtimeConnectionStatusUpdate(connectionStatus);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof RealtimeConnectionStatusUpdate) && this.connectionStatus == ((RealtimeConnectionStatusUpdate) other).connectionStatus;
        }

        public int hashCode() {
            return this.connectionStatus.hashCode();
        }

        public String toString() {
            return "RealtimeConnectionStatusUpdate(connectionStatus=" + this.connectionStatus + ')';
        }

        public RealtimeConnectionStatusUpdate(ConnectionStatus connectionStatus) {
            super(null);
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            this.connectionStatus = connectionStatus;
        }

        public final ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$MessageReceived;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "message", "Lzendesk/conversationkit/android/model/Message;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;)V", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MessageReceived extends Action {
        private final String conversationId;
        private final Message message;

        public static MessageReceived copy$default(MessageReceived messageReceived, String str, Message message, int i, Object obj) {
            if ((i & 1) != 0) {
                str = messageReceived.conversationId;
            }
            if ((i & 2) != 0) {
                message = messageReceived.message;
            }
            return messageReceived.copy(str, message);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final MessageReceived copy(String conversationId, Message message) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(message, "message");
            return new MessageReceived(conversationId, message);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessageReceived)) {
                return false;
            }
            MessageReceived messageReceived = (MessageReceived) other;
            return Intrinsics.areEqual(this.conversationId, messageReceived.conversationId) && Intrinsics.areEqual(this.message, messageReceived.message);
        }

        public int hashCode() {
            return (this.conversationId.hashCode() * 31) + this.message.hashCode();
        }

        public String toString() {
            return "MessageReceived(conversationId=" + this.conversationId + ", message=" + this.message + ')';
        }

        public MessageReceived(String conversationId, Message message) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(message, "message");
            this.conversationId = conversationId;
            this.message = message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Message getMessage() {
            return this.message;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\u0006\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$LoadMoreMessages;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "beforeTimestamp", "", "(Ljava/lang/String;D)V", "getBeforeTimestamp", "()D", "getConversationId", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadMoreMessages extends Action {
        private final double beforeTimestamp;
        private final String conversationId;

        public static LoadMoreMessages copy$default(LoadMoreMessages loadMoreMessages, String str, double d, int i, Object obj) {
            if ((i & 1) != 0) {
                str = loadMoreMessages.conversationId;
            }
            if ((i & 2) != 0) {
                d = loadMoreMessages.beforeTimestamp;
            }
            return loadMoreMessages.copy(str, d);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final double getBeforeTimestamp() {
            return this.beforeTimestamp;
        }

        public final LoadMoreMessages copy(String conversationId, double beforeTimestamp) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new LoadMoreMessages(conversationId, beforeTimestamp);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LoadMoreMessages)) {
                return false;
            }
            LoadMoreMessages loadMoreMessages = (LoadMoreMessages) other;
            return Intrinsics.areEqual(this.conversationId, loadMoreMessages.conversationId) && Double.compare(this.beforeTimestamp, loadMoreMessages.beforeTimestamp) == 0;
        }

        public int hashCode() {
            return (this.conversationId.hashCode() * 31) + ComplexDouble$.ExternalSyntheticBackport0.m(this.beforeTimestamp);
        }

        public String toString() {
            return "LoadMoreMessages(conversationId=" + this.conversationId + ", beforeTimestamp=" + this.beforeTimestamp + ')';
        }

        public LoadMoreMessages(String conversationId, double d) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
            this.beforeTimestamp = d;
        }

        public final double getBeforeTimestamp() {
            return this.beforeTimestamp;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$NetworkConnectionStatusUpdate;", "Lzendesk/conversationkit/android/internal/Action;", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "(Lzendesk/conversationkit/android/ConnectionStatus;)V", "getConnectionStatus", "()Lzendesk/conversationkit/android/ConnectionStatus;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NetworkConnectionStatusUpdate extends Action {
        private final ConnectionStatus connectionStatus;

        public static NetworkConnectionStatusUpdate copy$default(NetworkConnectionStatusUpdate networkConnectionStatusUpdate, ConnectionStatus connectionStatus, int i, Object obj) {
            if ((i & 1) != 0) {
                connectionStatus = networkConnectionStatusUpdate.connectionStatus;
            }
            return networkConnectionStatusUpdate.copy(connectionStatus);
        }

        public final ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }

        public final NetworkConnectionStatusUpdate copy(ConnectionStatus connectionStatus) {
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            return new NetworkConnectionStatusUpdate(connectionStatus);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof NetworkConnectionStatusUpdate) && this.connectionStatus == ((NetworkConnectionStatusUpdate) other).connectionStatus;
        }

        public int hashCode() {
            return this.connectionStatus.hashCode();
        }

        public String toString() {
            return "NetworkConnectionStatusUpdate(connectionStatus=" + this.connectionStatus + ')';
        }

        public NetworkConnectionStatusUpdate(ConnectionStatus connectionStatus) {
            super(null);
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            this.connectionStatus = connectionStatus;
        }

        public final ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\b\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0011\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010\b\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\u0006J\u001a\u0010\t\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010\nJ\u0013\u0010\u000b\u001a\u00020\f2\b\u0010\r\u001a\u0004\u0018\u00010\u000eHÖ\u0003J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0015\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$CreateUser;", "Lzendesk/conversationkit/android/internal/Action;", "proactiveMessageId", "", "(Ljava/lang/Integer;)V", "getProactiveMessageId", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "component1", "copy", "(Ljava/lang/Integer;)Lzendesk/conversationkit/android/internal/Action$CreateUser;", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CreateUser extends Action {
        private final Integer proactiveMessageId;

        public CreateUser() {
            this(null, 1, 0 == true ? 1 : 0);
        }

        public static CreateUser copy$default(CreateUser createUser, Integer num, int i, Object obj) {
            if ((i & 1) != 0) {
                num = createUser.proactiveMessageId;
            }
            return createUser.copy(num);
        }

        public final Integer getProactiveMessageId() {
            return this.proactiveMessageId;
        }

        public final CreateUser copy(Integer proactiveMessageId) {
            return new CreateUser(proactiveMessageId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof CreateUser) && Intrinsics.areEqual(this.proactiveMessageId, ((CreateUser) other).proactiveMessageId);
        }

        public int hashCode() {
            Integer num = this.proactiveMessageId;
            if (num == null) {
                return 0;
            }
            return num.hashCode();
        }

        public String toString() {
            return "CreateUser(proactiveMessageId=" + this.proactiveMessageId + ')';
        }

        public CreateUser(Integer num) {
            super(null);
            this.proactiveMessageId = num;
        }

        public CreateUser(Integer num, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? null : num);
        }

        public final Integer getProactiveMessageId() {
            return this.proactiveMessageId;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$CheckForPersistedUser;", "Lzendesk/conversationkit/android/internal/Action;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CheckForPersistedUser extends Action {
        public static final CheckForPersistedUser INSTANCE = new CheckForPersistedUser();

        private CheckForPersistedUser() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$StartRealtimeConnection;", "Lzendesk/conversationkit/android/internal/Action;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class StartRealtimeConnection extends Action {
        public static final StartRealtimeConnection INSTANCE = new StartRealtimeConnection();

        private StartRealtimeConnection() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$PauseRealtimeConnection;", "Lzendesk/conversationkit/android/internal/Action;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PauseRealtimeConnection extends Action {
        public static final PauseRealtimeConnection INSTANCE = new PauseRealtimeConnection();

        private PauseRealtimeConnection() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$RefreshUser;", "Lzendesk/conversationkit/android/internal/Action;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RefreshUser extends Action {
        public static final RefreshUser INSTANCE = new RefreshUser();

        private RefreshUser() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$LoginUser;", "Lzendesk/conversationkit/android/internal/Action;", "jwt", "", "(Ljava/lang/String;)V", "getJwt", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoginUser extends Action {
        private final String jwt;

        public static LoginUser copy$default(LoginUser loginUser, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = loginUser.jwt;
            }
            return loginUser.copy(str);
        }

        public final String getJwt() {
            return this.jwt;
        }

        public final LoginUser copy(String jwt) {
            Intrinsics.checkNotNullParameter(jwt, "jwt");
            return new LoginUser(jwt);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof LoginUser) && Intrinsics.areEqual(this.jwt, ((LoginUser) other).jwt);
        }

        public int hashCode() {
            return this.jwt.hashCode();
        }

        public String toString() {
            return "LoginUser(jwt=" + this.jwt + ')';
        }

        public LoginUser(String jwt) {
            super(null);
            Intrinsics.checkNotNullParameter(jwt, "jwt");
            this.jwt = jwt;
        }

        public final String getJwt() {
            return this.jwt;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$LogoutUser;", "Lzendesk/conversationkit/android/internal/Action;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LogoutUser extends Action {
        public static final LogoutUser INSTANCE = new LogoutUser();

        private LogoutUser() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\b\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0011\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010\b\u001a\u0004\u0018\u00010\u0003HÆ\u0003¢\u0006\u0002\u0010\u0006J\u001a\u0010\t\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003HÆ\u0001¢\u0006\u0002\u0010\nJ\u0013\u0010\u000b\u001a\u00020\f2\b\u0010\r\u001a\u0004\u0018\u00010\u000eHÖ\u0003J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0015\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\n\n\u0002\u0010\u0007\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$CreateConversation;", "Lzendesk/conversationkit/android/internal/Action;", "proactiveMessageId", "", "(Ljava/lang/Integer;)V", "getProactiveMessageId", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "component1", "copy", "(Ljava/lang/Integer;)Lzendesk/conversationkit/android/internal/Action$CreateConversation;", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CreateConversation extends Action {
        private final Integer proactiveMessageId;

        public CreateConversation() {
            this(null, 1, 0 == true ? 1 : 0);
        }

        public static CreateConversation copy$default(CreateConversation createConversation, Integer num, int i, Object obj) {
            if ((i & 1) != 0) {
                num = createConversation.proactiveMessageId;
            }
            return createConversation.copy(num);
        }

        public final Integer getProactiveMessageId() {
            return this.proactiveMessageId;
        }

        public final CreateConversation copy(Integer proactiveMessageId) {
            return new CreateConversation(proactiveMessageId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof CreateConversation) && Intrinsics.areEqual(this.proactiveMessageId, ((CreateConversation) other).proactiveMessageId);
        }

        public int hashCode() {
            Integer num = this.proactiveMessageId;
            if (num == null) {
                return 0;
            }
            return num.hashCode();
        }

        public String toString() {
            return "CreateConversation(proactiveMessageId=" + this.proactiveMessageId + ')';
        }

        public CreateConversation(Integer num) {
            super(null);
            this.proactiveMessageId = num;
        }

        public CreateConversation(Integer num, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? null : num);
        }

        public final Integer getProactiveMessageId() {
            return this.proactiveMessageId;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$GetConversation;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetConversation extends Action {
        private final String conversationId;

        public static GetConversation copy$default(GetConversation getConversation, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = getConversation.conversationId;
            }
            return getConversation.copy(str);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final GetConversation copy(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new GetConversation(conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof GetConversation) && Intrinsics.areEqual(this.conversationId, ((GetConversation) other).conversationId);
        }

        public int hashCode() {
            return this.conversationId.hashCode();
        }

        public String toString() {
            return "GetConversation(conversationId=" + this.conversationId + ')';
        }

        public GetConversation(String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0000\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B#\u0012\u0014\u0010\u0002\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0004¢\u0006\u0002\u0010\u0007J\u0017\u0010\f\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0004HÆ\u0003J+\u0010\u000e\u001a\u00020\u00002\u0016\b\u0002\u0010\u0002\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u0004HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0005HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0004HÖ\u0001R\u0011\u0010\u0006\u001a\u00020\u0004¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u001f\u0010\u0002\u001a\u0010\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u0005\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$UpdateConversationMetadata;", "Lzendesk/conversationkit/android/internal/Action;", "metadata", "", "", "", "conversationId", "(Ljava/util/Map;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getMetadata", "()Ljava/util/Map;", "component1", "component2", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UpdateConversationMetadata extends Action {
        private final String conversationId;
        private final Map<String, Object> metadata;

        public static UpdateConversationMetadata copy$default(UpdateConversationMetadata updateConversationMetadata, Map map, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                map = updateConversationMetadata.metadata;
            }
            if ((i & 2) != 0) {
                str = updateConversationMetadata.conversationId;
            }
            return updateConversationMetadata.copy(map, str);
        }

        public final Map<String, Object> component1() {
            return this.metadata;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final UpdateConversationMetadata copy(Map<String, ? extends Object> metadata, String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new UpdateConversationMetadata(metadata, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof UpdateConversationMetadata)) {
                return false;
            }
            UpdateConversationMetadata updateConversationMetadata = (UpdateConversationMetadata) other;
            return Intrinsics.areEqual(this.metadata, updateConversationMetadata.metadata) && Intrinsics.areEqual(this.conversationId, updateConversationMetadata.conversationId);
        }

        public int hashCode() {
            Map<String, Object> map = this.metadata;
            return ((map == null ? 0 : map.hashCode()) * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "UpdateConversationMetadata(metadata=" + this.metadata + ", conversationId=" + this.conversationId + ')';
        }

        public UpdateConversationMetadata(Map<String, ? extends Object> map, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.metadata = map;
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Map<String, Object> getMetadata() {
            return this.metadata;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$RefreshConversation;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RefreshConversation extends Action {
        private final String conversationId;

        public static RefreshConversation copy$default(RefreshConversation refreshConversation, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = refreshConversation.conversationId;
            }
            return refreshConversation.copy(str);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final RefreshConversation copy(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new RefreshConversation(conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof RefreshConversation) && Intrinsics.areEqual(this.conversationId, ((RefreshConversation) other).conversationId);
        }

        public int hashCode() {
            return this.conversationId.hashCode();
        }

        public String toString() {
            return "RefreshConversation(conversationId=" + this.conversationId + ')';
        }

        public RefreshConversation(String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$PrepareMessage;", "Lzendesk/conversationkit/android/internal/Action;", "message", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PrepareMessage extends Action {
        private final String conversationId;
        private final Message message;

        public static PrepareMessage copy$default(PrepareMessage prepareMessage, Message message, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                message = prepareMessage.message;
            }
            if ((i & 2) != 0) {
                str = prepareMessage.conversationId;
            }
            return prepareMessage.copy(message, str);
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final PrepareMessage copy(Message message, String conversationId) {
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new PrepareMessage(message, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof PrepareMessage)) {
                return false;
            }
            PrepareMessage prepareMessage = (PrepareMessage) other;
            return Intrinsics.areEqual(this.message, prepareMessage.message) && Intrinsics.areEqual(this.conversationId, prepareMessage.conversationId);
        }

        public int hashCode() {
            return (this.message.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "PrepareMessage(message=" + this.message + ", conversationId=" + this.conversationId + ')';
        }

        public PrepareMessage(Message message, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.message = message;
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Message getMessage() {
            return this.message;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$SendMessage;", "Lzendesk/conversationkit/android/internal/Action;", "message", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendMessage extends Action {
        private final String conversationId;
        private final Message message;

        public static SendMessage copy$default(SendMessage sendMessage, Message message, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                message = sendMessage.message;
            }
            if ((i & 2) != 0) {
                str = sendMessage.conversationId;
            }
            return sendMessage.copy(message, str);
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final SendMessage copy(Message message, String conversationId) {
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new SendMessage(message, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SendMessage)) {
                return false;
            }
            SendMessage sendMessage = (SendMessage) other;
            return Intrinsics.areEqual(this.message, sendMessage.message) && Intrinsics.areEqual(this.conversationId, sendMessage.conversationId);
        }

        public int hashCode() {
            return (this.message.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "SendMessage(message=" + this.message + ", conversationId=" + this.conversationId + ')';
        }

        public SendMessage(Message message, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.message = message;
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Message getMessage() {
            return this.message;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$PreparePushToken;", "Lzendesk/conversationkit/android/internal/Action;", "pushToken", "", "(Ljava/lang/String;)V", "getPushToken", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PreparePushToken extends Action {
        private final String pushToken;

        public static PreparePushToken copy$default(PreparePushToken preparePushToken, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = preparePushToken.pushToken;
            }
            return preparePushToken.copy(str);
        }

        public final String getPushToken() {
            return this.pushToken;
        }

        public final PreparePushToken copy(String pushToken) {
            Intrinsics.checkNotNullParameter(pushToken, "pushToken");
            return new PreparePushToken(pushToken);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof PreparePushToken) && Intrinsics.areEqual(this.pushToken, ((PreparePushToken) other).pushToken);
        }

        public int hashCode() {
            return this.pushToken.hashCode();
        }

        public String toString() {
            return "PreparePushToken(pushToken=" + this.pushToken + ')';
        }

        public PreparePushToken(String pushToken) {
            super(null);
            Intrinsics.checkNotNullParameter(pushToken, "pushToken");
            this.pushToken = pushToken;
        }

        public final String getPushToken() {
            return this.pushToken;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$PushCacheIntegrationId;", "Lzendesk/conversationkit/android/internal/Action;", "integrationId", "", "(Ljava/lang/String;)V", "getIntegrationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PushCacheIntegrationId extends Action {
        private final String integrationId;

        public static PushCacheIntegrationId copy$default(PushCacheIntegrationId pushCacheIntegrationId, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = pushCacheIntegrationId.integrationId;
            }
            return pushCacheIntegrationId.copy(str);
        }

        public final String getIntegrationId() {
            return this.integrationId;
        }

        public final PushCacheIntegrationId copy(String integrationId) {
            Intrinsics.checkNotNullParameter(integrationId, "integrationId");
            return new PushCacheIntegrationId(integrationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof PushCacheIntegrationId) && Intrinsics.areEqual(this.integrationId, ((PushCacheIntegrationId) other).integrationId);
        }

        public int hashCode() {
            return this.integrationId.hashCode();
        }

        public String toString() {
            return "PushCacheIntegrationId(integrationId=" + this.integrationId + ')';
        }

        public PushCacheIntegrationId(String integrationId) {
            super(null);
            Intrinsics.checkNotNullParameter(integrationId, "integrationId");
            this.integrationId = integrationId;
        }

        public final String getIntegrationId() {
            return this.integrationId;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$UpdatePushToken;", "Lzendesk/conversationkit/android/internal/Action;", "pushToken", "", "(Ljava/lang/String;)V", "getPushToken", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UpdatePushToken extends Action {
        private final String pushToken;

        public static UpdatePushToken copy$default(UpdatePushToken updatePushToken, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = updatePushToken.pushToken;
            }
            return updatePushToken.copy(str);
        }

        public final String getPushToken() {
            return this.pushToken;
        }

        public final UpdatePushToken copy(String pushToken) {
            Intrinsics.checkNotNullParameter(pushToken, "pushToken");
            return new UpdatePushToken(pushToken);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UpdatePushToken) && Intrinsics.areEqual(this.pushToken, ((UpdatePushToken) other).pushToken);
        }

        public int hashCode() {
            return this.pushToken.hashCode();
        }

        public String toString() {
            return "UpdatePushToken(pushToken=" + this.pushToken + ')';
        }

        public UpdatePushToken(String pushToken) {
            super(null);
            Intrinsics.checkNotNullParameter(pushToken, "pushToken");
            this.pushToken = pushToken;
        }

        public final String getPushToken() {
            return this.pushToken;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$SendActivityData;", "Lzendesk/conversationkit/android/internal/Action;", "activityData", "Lzendesk/conversationkit/android/model/ActivityData;", "conversationId", "", "(Lzendesk/conversationkit/android/model/ActivityData;Ljava/lang/String;)V", "getActivityData", "()Lzendesk/conversationkit/android/model/ActivityData;", "getConversationId", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendActivityData extends Action {
        private final ActivityData activityData;
        private final String conversationId;

        public static SendActivityData copy$default(SendActivityData sendActivityData, ActivityData activityData, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                activityData = sendActivityData.activityData;
            }
            if ((i & 2) != 0) {
                str = sendActivityData.conversationId;
            }
            return sendActivityData.copy(activityData, str);
        }

        public final ActivityData getActivityData() {
            return this.activityData;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final SendActivityData copy(ActivityData activityData, String conversationId) {
            Intrinsics.checkNotNullParameter(activityData, "activityData");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new SendActivityData(activityData, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SendActivityData)) {
                return false;
            }
            SendActivityData sendActivityData = (SendActivityData) other;
            return this.activityData == sendActivityData.activityData && Intrinsics.areEqual(this.conversationId, sendActivityData.conversationId);
        }

        public int hashCode() {
            return (this.activityData.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "SendActivityData(activityData=" + this.activityData + ", conversationId=" + this.conversationId + ')';
        }

        public final ActivityData getActivityData() {
            return this.activityData;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public SendActivityData(ActivityData activityData, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(activityData, "activityData");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.activityData = activityData;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$ActivityEventReceived;", "Lzendesk/conversationkit/android/internal/Action;", "activityEvent", "Lzendesk/conversationkit/android/model/ActivityEvent;", "(Lzendesk/conversationkit/android/model/ActivityEvent;)V", "getActivityEvent", "()Lzendesk/conversationkit/android/model/ActivityEvent;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ActivityEventReceived extends Action {
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

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$UpdateAppUserLocale;", "Lzendesk/conversationkit/android/internal/Action;", "deviceLocale", "", "(Ljava/lang/String;)V", "getDeviceLocale", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UpdateAppUserLocale extends Action {
        private final String deviceLocale;

        public static UpdateAppUserLocale copy$default(UpdateAppUserLocale updateAppUserLocale, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = updateAppUserLocale.deviceLocale;
            }
            return updateAppUserLocale.copy(str);
        }

        public final String getDeviceLocale() {
            return this.deviceLocale;
        }

        public final UpdateAppUserLocale copy(String deviceLocale) {
            Intrinsics.checkNotNullParameter(deviceLocale, "deviceLocale");
            return new UpdateAppUserLocale(deviceLocale);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UpdateAppUserLocale) && Intrinsics.areEqual(this.deviceLocale, ((UpdateAppUserLocale) other).deviceLocale);
        }

        public int hashCode() {
            return this.deviceLocale.hashCode();
        }

        public String toString() {
            return "UpdateAppUserLocale(deviceLocale=" + this.deviceLocale + ')';
        }

        public UpdateAppUserLocale(String deviceLocale) {
            super(null);
            Intrinsics.checkNotNullParameter(deviceLocale, "deviceLocale");
            this.deviceLocale = deviceLocale;
        }

        public final String getDeviceLocale() {
            return this.deviceLocale;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$PersistedUserRetrieve;", "Lzendesk/conversationkit/android/internal/Action;", "user", "Lzendesk/conversationkit/android/model/User;", "(Lzendesk/conversationkit/android/model/User;)V", "getUser", "()Lzendesk/conversationkit/android/model/User;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PersistedUserRetrieve extends Action {
        private final User user;

        public static PersistedUserRetrieve copy$default(PersistedUserRetrieve persistedUserRetrieve, User user, int i, Object obj) {
            if ((i & 1) != 0) {
                user = persistedUserRetrieve.user;
            }
            return persistedUserRetrieve.copy(user);
        }

        public final User getUser() {
            return this.user;
        }

        public final PersistedUserRetrieve copy(User user) {
            Intrinsics.checkNotNullParameter(user, "user");
            return new PersistedUserRetrieve(user);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof PersistedUserRetrieve) && Intrinsics.areEqual(this.user, ((PersistedUserRetrieve) other).user);
        }

        public int hashCode() {
            return this.user.hashCode();
        }

        public String toString() {
            return "PersistedUserRetrieve(user=" + this.user + ')';
        }

        public PersistedUserRetrieve(User user) {
            super(null);
            Intrinsics.checkNotNullParameter(user, "user");
            this.user = user;
        }

        public final User getUser() {
            return this.user;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$ConversationAdded;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationAdded extends Action {
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

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$ConversationRemoved;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationRemoved extends Action {
        private final String conversationId;

        public static ConversationRemoved copy$default(ConversationRemoved conversationRemoved, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = conversationRemoved.conversationId;
            }
            return conversationRemoved.copy(str);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final ConversationRemoved copy(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new ConversationRemoved(conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationRemoved) && Intrinsics.areEqual(this.conversationId, ((ConversationRemoved) other).conversationId);
        }

        public int hashCode() {
            return this.conversationId.hashCode();
        }

        public String toString() {
            return "ConversationRemoved(conversationId=" + this.conversationId + ')';
        }

        public ConversationRemoved(String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B+\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0014\u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007¢\u0006\u0002\u0010\tJ\t\u0010\u0010\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0011\u001a\u00020\u0005HÆ\u0003J\u0017\u0010\u0012\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007HÆ\u0003J5\u0010\u0013\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\u0016\b\u0002\u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007HÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\bHÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J\t\u0010\u0019\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u001f\u0010\u0006\u001a\u0010\u0012\u0004\u0012\u00020\u0003\u0012\u0004\u0012\u00020\b\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u001a"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$ConversationUpdate;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "status", "Lzendesk/conversationkit/android/model/ConversationStatus;", "metadata", "", "", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/ConversationStatus;Ljava/util/Map;)V", "getConversationId", "()Ljava/lang/String;", "getMetadata", "()Ljava/util/Map;", "getStatus", "()Lzendesk/conversationkit/android/model/ConversationStatus;", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationUpdate extends Action {
        private final String conversationId;
        private final Map<String, Object> metadata;
        private final ConversationStatus status;

        public static ConversationUpdate copy$default(ConversationUpdate conversationUpdate, String str, ConversationStatus conversationStatus, Map map, int i, Object obj) {
            if ((i & 1) != 0) {
                str = conversationUpdate.conversationId;
            }
            if ((i & 2) != 0) {
                conversationStatus = conversationUpdate.status;
            }
            if ((i & 4) != 0) {
                map = conversationUpdate.metadata;
            }
            return conversationUpdate.copy(str, conversationStatus, map);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final ConversationStatus getStatus() {
            return this.status;
        }

        public final Map<String, Object> component3() {
            return this.metadata;
        }

        public final ConversationUpdate copy(String conversationId, ConversationStatus status, Map<String, ? extends Object> metadata) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(status, "status");
            return new ConversationUpdate(conversationId, status, metadata);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ConversationUpdate)) {
                return false;
            }
            ConversationUpdate conversationUpdate = (ConversationUpdate) other;
            return Intrinsics.areEqual(this.conversationId, conversationUpdate.conversationId) && this.status == conversationUpdate.status && Intrinsics.areEqual(this.metadata, conversationUpdate.metadata);
        }

        public int hashCode() {
            int iHashCode = ((this.conversationId.hashCode() * 31) + this.status.hashCode()) * 31;
            Map<String, Object> map = this.metadata;
            return iHashCode + (map == null ? 0 : map.hashCode());
        }

        public String toString() {
            return "ConversationUpdate(conversationId=" + this.conversationId + ", status=" + this.status + ", metadata=" + this.metadata + ')';
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final ConversationStatus getStatus() {
            return this.status;
        }

        public final Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public ConversationUpdate(String conversationId, ConversationStatus status, Map<String, ? extends Object> map) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(status, "status");
            this.conversationId = conversationId;
            this.status = status;
            this.metadata = map;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u00052\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010HÖ\u0003J\t\u0010\u0011\u001a\u00020\u0003HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0014"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$GetConversations;", "Lzendesk/conversationkit/android/internal/Action;", "offset", "", "fromCache", "", "(IZ)V", "getFromCache", "()Z", "getOffset", "()I", "component1", "component2", "copy", "equals", "other", "", "hashCode", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetConversations extends Action {
        private final boolean fromCache;
        private final int offset;

        public static GetConversations copy$default(GetConversations getConversations, int i, boolean z, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = getConversations.offset;
            }
            if ((i2 & 2) != 0) {
                z = getConversations.fromCache;
            }
            return getConversations.copy(i, z);
        }

        public final int getOffset() {
            return this.offset;
        }

        public final boolean getFromCache() {
            return this.fromCache;
        }

        public final GetConversations copy(int offset, boolean fromCache) {
            return new GetConversations(offset, fromCache);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof GetConversations)) {
                return false;
            }
            GetConversations getConversations = (GetConversations) other;
            return this.offset == getConversations.offset && this.fromCache == getConversations.fromCache;
        }

        public int hashCode() {
            return (this.offset * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.fromCache);
        }

        public String toString() {
            return "GetConversations(offset=" + this.offset + ", fromCache=" + this.fromCache + ')';
        }

        public final int getOffset() {
            return this.offset;
        }

        public final boolean getFromCache() {
            return this.fromCache;
        }

        public GetConversations(int i, boolean z) {
            super(null);
            this.offset = i;
            this.fromCache = z;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$GetVisitType;", "Lzendesk/conversationkit/android/internal/Action;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetVisitType extends Action {
        public static final GetVisitType INSTANCE = new GetVisitType();

        private GetVisitType() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$SetVisitType;", "Lzendesk/conversationkit/android/internal/Action;", "visitType", "Lzendesk/conversationkit/android/model/VisitType;", "(Lzendesk/conversationkit/android/model/VisitType;)V", "getVisitType", "()Lzendesk/conversationkit/android/model/VisitType;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SetVisitType extends Action {
        private final VisitType visitType;

        public static SetVisitType copy$default(SetVisitType setVisitType, VisitType visitType, int i, Object obj) {
            if ((i & 1) != 0) {
                visitType = setVisitType.visitType;
            }
            return setVisitType.copy(visitType);
        }

        public final VisitType getVisitType() {
            return this.visitType;
        }

        public final SetVisitType copy(VisitType visitType) {
            Intrinsics.checkNotNullParameter(visitType, "visitType");
            return new SetVisitType(visitType);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof SetVisitType) && this.visitType == ((SetVisitType) other).visitType;
        }

        public int hashCode() {
            return this.visitType.hashCode();
        }

        public String toString() {
            return "SetVisitType(visitType=" + this.visitType + ')';
        }

        public SetVisitType(VisitType visitType) {
            super(null);
            Intrinsics.checkNotNullParameter(visitType, "visitType");
            this.visitType = visitType;
        }

        public final VisitType getVisitType() {
            return this.visitType;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$AddProactiveMessage;", "Lzendesk/conversationkit/android/internal/Action;", "proactiveMessage", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/model/ProactiveMessage;)V", "getProactiveMessage", "()Lzendesk/conversationkit/android/model/ProactiveMessage;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AddProactiveMessage extends Action {
        private final ProactiveMessage proactiveMessage;

        public static AddProactiveMessage copy$default(AddProactiveMessage addProactiveMessage, ProactiveMessage proactiveMessage, int i, Object obj) {
            if ((i & 1) != 0) {
                proactiveMessage = addProactiveMessage.proactiveMessage;
            }
            return addProactiveMessage.copy(proactiveMessage);
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }

        public final AddProactiveMessage copy(ProactiveMessage proactiveMessage) {
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            return new AddProactiveMessage(proactiveMessage);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AddProactiveMessage) && Intrinsics.areEqual(this.proactiveMessage, ((AddProactiveMessage) other).proactiveMessage);
        }

        public int hashCode() {
            return this.proactiveMessage.hashCode();
        }

        public String toString() {
            return "AddProactiveMessage(proactiveMessage=" + this.proactiveMessage + ')';
        }

        public AddProactiveMessage(ProactiveMessage proactiveMessage) {
            super(null);
            Intrinsics.checkNotNullParameter(proactiveMessage, "proactiveMessage");
            this.proactiveMessage = proactiveMessage;
        }

        public final ProactiveMessage getProactiveMessage() {
            return this.proactiveMessage;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$GetProactiveMessage;", "Lzendesk/conversationkit/android/internal/Action;", "proactiveMessageId", "", "(I)V", "getProactiveMessageId", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetProactiveMessage extends Action {
        private final int proactiveMessageId;

        public static GetProactiveMessage copy$default(GetProactiveMessage getProactiveMessage, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = getProactiveMessage.proactiveMessageId;
            }
            return getProactiveMessage.copy(i);
        }

        public final int getProactiveMessageId() {
            return this.proactiveMessageId;
        }

        public final GetProactiveMessage copy(int proactiveMessageId) {
            return new GetProactiveMessage(proactiveMessageId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof GetProactiveMessage) && this.proactiveMessageId == ((GetProactiveMessage) other).proactiveMessageId;
        }

        public int hashCode() {
            return this.proactiveMessageId;
        }

        public String toString() {
            return "GetProactiveMessage(proactiveMessageId=" + this.proactiveMessageId + ')';
        }

        public GetProactiveMessage(int i) {
            super(null);
            this.proactiveMessageId = i;
        }

        public final int getProactiveMessageId() {
            return this.proactiveMessageId;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u0003HÖ\u0001J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$ClearProactiveMessage;", "Lzendesk/conversationkit/android/internal/Action;", "proactiveMessageId", "", "(I)V", "getProactiveMessageId", "()I", "component1", "copy", "equals", "", "other", "", "hashCode", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ClearProactiveMessage extends Action {
        private final int proactiveMessageId;

        public static ClearProactiveMessage copy$default(ClearProactiveMessage clearProactiveMessage, int i, int i2, Object obj) {
            if ((i2 & 1) != 0) {
                i = clearProactiveMessage.proactiveMessageId;
            }
            return clearProactiveMessage.copy(i);
        }

        public final int getProactiveMessageId() {
            return this.proactiveMessageId;
        }

        public final ClearProactiveMessage copy(int proactiveMessageId) {
            return new ClearProactiveMessage(proactiveMessageId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ClearProactiveMessage) && this.proactiveMessageId == ((ClearProactiveMessage) other).proactiveMessageId;
        }

        public int hashCode() {
            return this.proactiveMessageId;
        }

        public String toString() {
            return "ClearProactiveMessage(proactiveMessageId=" + this.proactiveMessageId + ')';
        }

        public ClearProactiveMessage(int i) {
            super(null);
            this.proactiveMessageId = i;
        }

        public final int getProactiveMessageId() {
            return this.proactiveMessageId;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B\u0019\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\u0010\u0010\r\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\nJ$\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005HÆ\u0001¢\u0006\u0002\u0010\u000fJ\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0015\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\t\u0010\n¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$ProactiveMessageReferral;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "proactiveMessageId", "", "(Ljava/lang/String;Ljava/lang/Integer;)V", "getConversationId", "()Ljava/lang/String;", "getProactiveMessageId", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "component1", "component2", "copy", "(Ljava/lang/String;Ljava/lang/Integer;)Lzendesk/conversationkit/android/internal/Action$ProactiveMessageReferral;", "equals", "", "other", "", "hashCode", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ProactiveMessageReferral extends Action {
        private final String conversationId;
        private final Integer proactiveMessageId;

        public static ProactiveMessageReferral copy$default(ProactiveMessageReferral proactiveMessageReferral, String str, Integer num, int i, Object obj) {
            if ((i & 1) != 0) {
                str = proactiveMessageReferral.conversationId;
            }
            if ((i & 2) != 0) {
                num = proactiveMessageReferral.proactiveMessageId;
            }
            return proactiveMessageReferral.copy(str, num);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Integer getProactiveMessageId() {
            return this.proactiveMessageId;
        }

        public final ProactiveMessageReferral copy(String conversationId, Integer proactiveMessageId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new ProactiveMessageReferral(conversationId, proactiveMessageId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ProactiveMessageReferral)) {
                return false;
            }
            ProactiveMessageReferral proactiveMessageReferral = (ProactiveMessageReferral) other;
            return Intrinsics.areEqual(this.conversationId, proactiveMessageReferral.conversationId) && Intrinsics.areEqual(this.proactiveMessageId, proactiveMessageReferral.proactiveMessageId);
        }

        public int hashCode() {
            int iHashCode = this.conversationId.hashCode() * 31;
            Integer num = this.proactiveMessageId;
            return iHashCode + (num == null ? 0 : num.hashCode());
        }

        public String toString() {
            return "ProactiveMessageReferral(conversationId=" + this.conversationId + ", proactiveMessageId=" + this.proactiveMessageId + ')';
        }

        public ProactiveMessageReferral(String str, Integer num, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? null : num);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Integer getProactiveMessageId() {
            return this.proactiveMessageId;
        }

        public ProactiveMessageReferral(String conversationId, Integer num) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
            this.proactiveMessageId = num;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$UserMergeReceived;", "Lzendesk/conversationkit/android/internal/Action;", Bayeux.KEY_DATA, "Lzendesk/conversationkit/android/model/UserMerge;", "(Lzendesk/conversationkit/android/model/UserMerge;)V", "getData", "()Lzendesk/conversationkit/android/model/UserMerge;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UserMergeReceived extends Action {
        private final UserMerge data;

        public static UserMergeReceived copy$default(UserMergeReceived userMergeReceived, UserMerge userMerge, int i, Object obj) {
            if ((i & 1) != 0) {
                userMerge = userMergeReceived.data;
            }
            return userMergeReceived.copy(userMerge);
        }

        public final UserMerge getData() {
            return this.data;
        }

        public final UserMergeReceived copy(UserMerge data) {
            Intrinsics.checkNotNullParameter(data, "data");
            return new UserMergeReceived(data);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UserMergeReceived) && Intrinsics.areEqual(this.data, ((UserMergeReceived) other).data);
        }

        public int hashCode() {
            return this.data.hashCode();
        }

        public String toString() {
            return "UserMergeReceived(data=" + this.data + ')';
        }

        public UserMergeReceived(UserMerge data) {
            super(null);
            Intrinsics.checkNotNullParameter(data, "data");
            this.data = data;
        }

        public final UserMerge getData() {
            return this.data;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0000\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0019\u0012\u0012\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003¢\u0006\u0002\u0010\u0006J\u0015\u0010\t\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003HÆ\u0003J\u001f\u0010\n\u001a\u00020\u00002\u0014\b\u0002\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003HÆ\u0001J\u0013\u0010\u000b\u001a\u00020\f2\b\u0010\r\u001a\u0004\u0018\u00010\u0005HÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0004HÖ\u0001R\u001d\u0010\u0002\u001a\u000e\u0012\u0004\u0012\u00020\u0004\u0012\u0004\u0012\u00020\u00050\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\b¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$AddConversationFields;", "Lzendesk/conversationkit/android/internal/Action;", "fields", "", "", "", "(Ljava/util/Map;)V", "getFields", "()Ljava/util/Map;", "component1", "copy", "equals", "", "other", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AddConversationFields extends Action {
        private final Map<String, Object> fields;

        public static AddConversationFields copy$default(AddConversationFields addConversationFields, Map map, int i, Object obj) {
            if ((i & 1) != 0) {
                map = addConversationFields.fields;
            }
            return addConversationFields.copy(map);
        }

        public final Map<String, Object> component1() {
            return this.fields;
        }

        public final AddConversationFields copy(Map<String, ? extends Object> fields) {
            Intrinsics.checkNotNullParameter(fields, "fields");
            return new AddConversationFields(fields);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AddConversationFields) && Intrinsics.areEqual(this.fields, ((AddConversationFields) other).fields);
        }

        public int hashCode() {
            return this.fields.hashCode();
        }

        public String toString() {
            return "AddConversationFields(fields=" + this.fields + ')';
        }

        public AddConversationFields(Map<String, ? extends Object> fields) {
            super(null);
            Intrinsics.checkNotNullParameter(fields, "fields");
            this.fields = fields;
        }

        public final Map<String, Object> getFields() {
            return this.fields;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0004HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$AddConversationTags;", "Lzendesk/conversationkit/android/internal/Action;", "tags", "", "", "(Ljava/util/List;)V", "getTags", "()Ljava/util/List;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AddConversationTags extends Action {
        private final List<String> tags;

        public static AddConversationTags copy$default(AddConversationTags addConversationTags, List list, int i, Object obj) {
            if ((i & 1) != 0) {
                list = addConversationTags.tags;
            }
            return addConversationTags.copy(list);
        }

        public final List<String> component1() {
            return this.tags;
        }

        public final AddConversationTags copy(List<String> tags) {
            Intrinsics.checkNotNullParameter(tags, "tags");
            return new AddConversationTags(tags);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AddConversationTags) && Intrinsics.areEqual(this.tags, ((AddConversationTags) other).tags);
        }

        public int hashCode() {
            return this.tags.hashCode();
        }

        public String toString() {
            return "AddConversationTags(tags=" + this.tags + ')';
        }

        public AddConversationTags(List<String> tags) {
            super(null);
            Intrinsics.checkNotNullParameter(tags, "tags");
            this.tags = tags;
        }

        public final List<String> getTags() {
            return this.tags;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$ClearConversationFields;", "Lzendesk/conversationkit/android/internal/Action;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ClearConversationFields extends Action {
        public static final ClearConversationFields INSTANCE = new ClearConversationFields();

        private ClearConversationFields() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$ClearConversationTags;", "Lzendesk/conversationkit/android/internal/Action;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ClearConversationTags extends Action {
        public static final ClearConversationTags INSTANCE = new ClearConversationTags();

        private ClearConversationTags() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003¢\u0006\u0002\u0010\u0005J\t\u0010\t\u001a\u00020\u0003HÆ\u0003J\t\u0010\n\u001a\u00020\u0003HÆ\u0003J\u001d\u0010\u000b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fHÖ\u0003J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001J\t\u0010\u0012\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\u0007¨\u0006\u0013"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$SendPostbackAction;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "actionId", "(Ljava/lang/String;Ljava/lang/String;)V", "getActionId", "()Ljava/lang/String;", "getConversationId", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendPostbackAction extends Action {
        private final String actionId;
        private final String conversationId;

        public static SendPostbackAction copy$default(SendPostbackAction sendPostbackAction, String str, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = sendPostbackAction.conversationId;
            }
            if ((i & 2) != 0) {
                str2 = sendPostbackAction.actionId;
            }
            return sendPostbackAction.copy(str, str2);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final String getActionId() {
            return this.actionId;
        }

        public final SendPostbackAction copy(String conversationId, String actionId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(actionId, "actionId");
            return new SendPostbackAction(conversationId, actionId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SendPostbackAction)) {
                return false;
            }
            SendPostbackAction sendPostbackAction = (SendPostbackAction) other;
            return Intrinsics.areEqual(this.conversationId, sendPostbackAction.conversationId) && Intrinsics.areEqual(this.actionId, sendPostbackAction.actionId);
        }

        public int hashCode() {
            return (this.conversationId.hashCode() * 31) + this.actionId.hashCode();
        }

        public String toString() {
            return "SendPostbackAction(conversationId=" + this.conversationId + ", actionId=" + this.actionId + ')';
        }

        public SendPostbackAction(String conversationId, String actionId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(actionId, "actionId");
            this.conversationId = conversationId;
            this.actionId = actionId;
        }

        public final String getActionId() {
            return this.actionId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$DownloadAttachmentAction;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "message", "Lzendesk/conversationkit/android/model/Message;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;)V", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class DownloadAttachmentAction extends Action {
        private final String conversationId;
        private final Message message;

        public static DownloadAttachmentAction copy$default(DownloadAttachmentAction downloadAttachmentAction, String str, Message message, int i, Object obj) {
            if ((i & 1) != 0) {
                str = downloadAttachmentAction.conversationId;
            }
            if ((i & 2) != 0) {
                message = downloadAttachmentAction.message;
            }
            return downloadAttachmentAction.copy(str, message);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final DownloadAttachmentAction copy(String conversationId, Message message) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(message, "message");
            return new DownloadAttachmentAction(conversationId, message);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof DownloadAttachmentAction)) {
                return false;
            }
            DownloadAttachmentAction downloadAttachmentAction = (DownloadAttachmentAction) other;
            return Intrinsics.areEqual(this.conversationId, downloadAttachmentAction.conversationId) && Intrinsics.areEqual(this.message, downloadAttachmentAction.message);
        }

        public int hashCode() {
            return (this.conversationId.hashCode() * 31) + this.message.hashCode();
        }

        public String toString() {
            return "DownloadAttachmentAction(conversationId=" + this.conversationId + ", message=" + this.message + ')';
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Message getMessage() {
            return this.message;
        }

        public DownloadAttachmentAction(String conversationId, Message message) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(message, "message");
            this.conversationId = conversationId;
            this.message = message;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$UpdateDownloadStatusAction;", "Lzendesk/conversationkit/android/internal/Action;", "status", "Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus;", "(Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus;)V", "getStatus", "()Lzendesk/conversationkit/android/model/attachments/DownloadAttachmentStatus;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UpdateDownloadStatusAction extends Action {
        private final DownloadAttachmentStatus status;

        public static UpdateDownloadStatusAction copy$default(UpdateDownloadStatusAction updateDownloadStatusAction, DownloadAttachmentStatus downloadAttachmentStatus, int i, Object obj) {
            if ((i & 1) != 0) {
                downloadAttachmentStatus = updateDownloadStatusAction.status;
            }
            return updateDownloadStatusAction.copy(downloadAttachmentStatus);
        }

        public final DownloadAttachmentStatus getStatus() {
            return this.status;
        }

        public final UpdateDownloadStatusAction copy(DownloadAttachmentStatus status) {
            Intrinsics.checkNotNullParameter(status, "status");
            return new UpdateDownloadStatusAction(status);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UpdateDownloadStatusAction) && Intrinsics.areEqual(this.status, ((UpdateDownloadStatusAction) other).status);
        }

        public int hashCode() {
            return this.status.hashCode();
        }

        public String toString() {
            return "UpdateDownloadStatusAction(status=" + this.status + ')';
        }

        public UpdateDownloadStatusAction(DownloadAttachmentStatus status) {
            super(null);
            Intrinsics.checkNotNullParameter(status, "status");
            this.status = status;
        }

        public final DownloadAttachmentStatus getStatus() {
            return this.status;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Action$GetWaitTimeForConversation;", "Lzendesk/conversationkit/android/internal/Action;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetWaitTimeForConversation extends Action {
        private final String conversationId;

        public static GetWaitTimeForConversation copy$default(GetWaitTimeForConversation getWaitTimeForConversation, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = getWaitTimeForConversation.conversationId;
            }
            return getWaitTimeForConversation.copy(str);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final GetWaitTimeForConversation copy(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new GetWaitTimeForConversation(conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof GetWaitTimeForConversation) && Intrinsics.areEqual(this.conversationId, ((GetWaitTimeForConversation) other).conversationId);
        }

        public int hashCode() {
            return this.conversationId.hashCode();
        }

        public String toString() {
            return "GetWaitTimeForConversation(conversationId=" + this.conversationId + ')';
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public GetWaitTimeForConversation(String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }
    }
}
