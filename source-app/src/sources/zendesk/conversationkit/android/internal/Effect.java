package zendesk.conversationkit.android.internal;

import androidx.compose.animation.core.ComplexDouble$;
import java.io.File;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.Unit;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.ConversationKitResult;
import zendesk.conversationkit.android.model.ActivityEvent;
import zendesk.conversationkit.android.model.Conversation;
import zendesk.conversationkit.android.model.ConversationsPagination;
import zendesk.conversationkit.android.model.Message;
import zendesk.conversationkit.android.model.ProactiveMessage;
import zendesk.conversationkit.android.model.User;
import zendesk.conversationkit.android.model.VisitType;
import zendesk.conversationkit.android.model.WaitTimeData;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000\u009a\u0001\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b%\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:$\u0003\u0004\u0005\u0006\u0007\b\t\n\u000b\f\r\u000e\u000f\u0010\u0011\u0012\u0013\u0014\u0015\u0016\u0017\u0018\u0019\u001a\u001b\u001c\u001d\u001e\u001f !\"#$%&B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001#'()*+,-./0123456789:;<=>?@ABCDEFGHI¨\u0006J"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect;", "", "()V", "ActivityEventReceived", "AlreadyLoggedInResult", "AttachmentDownloadStarted", "CheckForPersistedUserResult", "ConnectionChanged", "ConversationAddedResult", "ConversationRemovedResult", "ConversationUpdatedResult", "CreateConversationResult", "CreateUserResult", "FetchWaitTimeResult", "GetConversationResult", "GetConversationsResult", "GetProactiveMessage", "GetVisitType", "IncorrectAccessLevel", "IntegrationIdCached", "LoadMoreMessages", "LoginUserResult", "LogoutUserResult", "MessagePrepared", "MessageReceived", "NetworkConnectionChanged", "None", "OpenAttachmentFromFile", "PersistedUserReceived", "ProactiveMessageReferral", "PushTokenPrepared", "PushTokenUpdateResult", "ReAuthenticateUser", "RealtimeConnectionChanged", "RefreshConversationResult", "RefreshUserResult", "SendMessageResult", "SendPostbackResult", "UserAccessRevoked", "Lzendesk/conversationkit/android/internal/Effect$ActivityEventReceived;", "Lzendesk/conversationkit/android/internal/Effect$AlreadyLoggedInResult;", "Lzendesk/conversationkit/android/internal/Effect$AttachmentDownloadStarted;", "Lzendesk/conversationkit/android/internal/Effect$CheckForPersistedUserResult;", "Lzendesk/conversationkit/android/internal/Effect$ConversationAddedResult;", "Lzendesk/conversationkit/android/internal/Effect$ConversationRemovedResult;", "Lzendesk/conversationkit/android/internal/Effect$ConversationUpdatedResult;", "Lzendesk/conversationkit/android/internal/Effect$CreateConversationResult;", "Lzendesk/conversationkit/android/internal/Effect$CreateUserResult;", "Lzendesk/conversationkit/android/internal/Effect$FetchWaitTimeResult;", "Lzendesk/conversationkit/android/internal/Effect$GetConversationResult;", "Lzendesk/conversationkit/android/internal/Effect$GetConversationsResult;", "Lzendesk/conversationkit/android/internal/Effect$GetProactiveMessage;", "Lzendesk/conversationkit/android/internal/Effect$GetVisitType;", "Lzendesk/conversationkit/android/internal/Effect$IncorrectAccessLevel;", "Lzendesk/conversationkit/android/internal/Effect$IntegrationIdCached;", "Lzendesk/conversationkit/android/internal/Effect$LoadMoreMessages;", "Lzendesk/conversationkit/android/internal/Effect$LoginUserResult;", "Lzendesk/conversationkit/android/internal/Effect$LogoutUserResult;", "Lzendesk/conversationkit/android/internal/Effect$MessagePrepared;", "Lzendesk/conversationkit/android/internal/Effect$MessageReceived;", "Lzendesk/conversationkit/android/internal/Effect$NetworkConnectionChanged;", "Lzendesk/conversationkit/android/internal/Effect$None;", "Lzendesk/conversationkit/android/internal/Effect$OpenAttachmentFromFile;", "Lzendesk/conversationkit/android/internal/Effect$PersistedUserReceived;", "Lzendesk/conversationkit/android/internal/Effect$ProactiveMessageReferral;", "Lzendesk/conversationkit/android/internal/Effect$PushTokenPrepared;", "Lzendesk/conversationkit/android/internal/Effect$PushTokenUpdateResult;", "Lzendesk/conversationkit/android/internal/Effect$ReAuthenticateUser;", "Lzendesk/conversationkit/android/internal/Effect$RealtimeConnectionChanged;", "Lzendesk/conversationkit/android/internal/Effect$RefreshConversationResult;", "Lzendesk/conversationkit/android/internal/Effect$RefreshUserResult;", "Lzendesk/conversationkit/android/internal/Effect$SendMessageResult;", "Lzendesk/conversationkit/android/internal/Effect$SendPostbackResult;", "Lzendesk/conversationkit/android/internal/Effect$UserAccessRevoked;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class Effect {

    @Metadata(m17d1 = {"\u0000\u0012\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\bf\u0018\u00002\u00020\u0001R\u0012\u0010\u0002\u001a\u00020\u0003X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0004\u0010\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$ConnectionChanged;", "", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "getConnectionStatus", "()Lzendesk/conversationkit/android/ConnectionStatus;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public interface ConnectionChanged {
        ConnectionStatus getConnectionStatus();
    }

    public Effect(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private Effect() {
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$None;", "Lzendesk/conversationkit/android/internal/Effect;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class None extends Effect {
        public static final None INSTANCE = new None();

        private None() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$IncorrectAccessLevel;", "Lzendesk/conversationkit/android/internal/Effect;", "()V", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class IncorrectAccessLevel extends Effect {
        public static final IncorrectAccessLevel INSTANCE = new IncorrectAccessLevel();

        private IncorrectAccessLevel() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\u0004HÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$UserAccessRevoked;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class UserAccessRevoked extends Effect {
        private final ConversationKitResult<Object> result;

        public static UserAccessRevoked copy$default(UserAccessRevoked userAccessRevoked, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = userAccessRevoked.result;
            }
            return userAccessRevoked.copy(conversationKitResult);
        }

        public final ConversationKitResult<Object> component1() {
            return this.result;
        }

        public final UserAccessRevoked copy(ConversationKitResult<? extends Object> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new UserAccessRevoked(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof UserAccessRevoked) && Intrinsics.areEqual(this.result, ((UserAccessRevoked) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "UserAccessRevoked(result=" + this.result + ')';
        }

        public final ConversationKitResult<Object> getResult() {
            return this.result;
        }

        public UserAccessRevoked(ConversationKitResult<? extends Object> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\t\u0010\b\u001a\u00020\u0004HÆ\u0003J\u0013\u0010\t\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u0004HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0014\u0010\u0003\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$NetworkConnectionChanged;", "Lzendesk/conversationkit/android/internal/Effect;", "Lzendesk/conversationkit/android/internal/Effect$ConnectionChanged;", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "(Lzendesk/conversationkit/android/ConnectionStatus;)V", "getConnectionStatus", "()Lzendesk/conversationkit/android/ConnectionStatus;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NetworkConnectionChanged extends Effect implements ConnectionChanged {
        private final ConnectionStatus connectionStatus;

        public static NetworkConnectionChanged copy$default(NetworkConnectionChanged networkConnectionChanged, ConnectionStatus connectionStatus, int i, Object obj) {
            if ((i & 1) != 0) {
                connectionStatus = networkConnectionChanged.connectionStatus;
            }
            return networkConnectionChanged.copy(connectionStatus);
        }

        public final ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }

        public final NetworkConnectionChanged copy(ConnectionStatus connectionStatus) {
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            return new NetworkConnectionChanged(connectionStatus);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof NetworkConnectionChanged) && this.connectionStatus == ((NetworkConnectionChanged) other).connectionStatus;
        }

        public int hashCode() {
            return this.connectionStatus.hashCode();
        }

        public String toString() {
            return "NetworkConnectionChanged(connectionStatus=" + this.connectionStatus + ')';
        }

        @Override
        public ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }

        public NetworkConnectionChanged(ConnectionStatus connectionStatus) {
            super(null);
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            this.connectionStatus = connectionStatus;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u00012\u00020\u0002B\r\u0012\u0006\u0010\u0003\u001a\u00020\u0004¢\u0006\u0002\u0010\u0005J\t\u0010\b\u001a\u00020\u0004HÆ\u0003J\u0013\u0010\t\u001a\u00020\u00002\b\b\u0002\u0010\u0003\u001a\u00020\u0004HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0014\u0010\u0003\u001a\u00020\u0004X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$RealtimeConnectionChanged;", "Lzendesk/conversationkit/android/internal/Effect;", "Lzendesk/conversationkit/android/internal/Effect$ConnectionChanged;", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "(Lzendesk/conversationkit/android/ConnectionStatus;)V", "getConnectionStatus", "()Lzendesk/conversationkit/android/ConnectionStatus;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RealtimeConnectionChanged extends Effect implements ConnectionChanged {
        private final ConnectionStatus connectionStatus;

        public static RealtimeConnectionChanged copy$default(RealtimeConnectionChanged realtimeConnectionChanged, ConnectionStatus connectionStatus, int i, Object obj) {
            if ((i & 1) != 0) {
                connectionStatus = realtimeConnectionChanged.connectionStatus;
            }
            return realtimeConnectionChanged.copy(connectionStatus);
        }

        public final ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }

        public final RealtimeConnectionChanged copy(ConnectionStatus connectionStatus) {
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            return new RealtimeConnectionChanged(connectionStatus);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof RealtimeConnectionChanged) && this.connectionStatus == ((RealtimeConnectionChanged) other).connectionStatus;
        }

        public int hashCode() {
            return this.connectionStatus.hashCode();
        }

        public String toString() {
            return "RealtimeConnectionChanged(connectionStatus=" + this.connectionStatus + ')';
        }

        @Override
        public ConnectionStatus getConnectionStatus() {
            return this.connectionStatus;
        }

        public RealtimeConnectionChanged(ConnectionStatus connectionStatus) {
            super(null);
            Intrinsics.checkNotNullParameter(connectionStatus, "connectionStatus");
            this.connectionStatus = connectionStatus;
        }
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001f\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u000b\u0010\r\u001a\u0004\u0018\u00010\u0006HÆ\u0003J%\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0006HÖ\u0001R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$CreateUserResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/User;", "pendingPushToken", "", "(Lzendesk/conversationkit/android/ConversationKitResult;Ljava/lang/String;)V", "getPendingPushToken", "()Ljava/lang/String;", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CreateUserResult extends Effect {
        private final String pendingPushToken;
        private final ConversationKitResult<User> result;

        public static CreateUserResult copy$default(CreateUserResult createUserResult, ConversationKitResult conversationKitResult, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = createUserResult.result;
            }
            if ((i & 2) != 0) {
                str = createUserResult.pendingPushToken;
            }
            return createUserResult.copy(conversationKitResult, str);
        }

        public final ConversationKitResult<User> component1() {
            return this.result;
        }

        public final String getPendingPushToken() {
            return this.pendingPushToken;
        }

        public final CreateUserResult copy(ConversationKitResult<User> result, String pendingPushToken) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new CreateUserResult(result, pendingPushToken);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof CreateUserResult)) {
                return false;
            }
            CreateUserResult createUserResult = (CreateUserResult) other;
            return Intrinsics.areEqual(this.result, createUserResult.result) && Intrinsics.areEqual(this.pendingPushToken, createUserResult.pendingPushToken);
        }

        public int hashCode() {
            int iHashCode = this.result.hashCode() * 31;
            String str = this.pendingPushToken;
            return iHashCode + (str == null ? 0 : str.hashCode());
        }

        public String toString() {
            return "CreateUserResult(result=" + this.result + ", pendingPushToken=" + this.pendingPushToken + ')';
        }

        public CreateUserResult(ConversationKitResult conversationKitResult, String str, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(conversationKitResult, (i & 2) != 0 ? null : str);
        }

        public final ConversationKitResult<User> getResult() {
            return this.result;
        }

        public final String getPendingPushToken() {
            return this.pendingPushToken;
        }

        public CreateUserResult(ConversationKitResult<User> result, String str) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
            this.pendingPushToken = str;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$LoginUserResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/User;", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoginUserResult extends Effect {
        private final ConversationKitResult<User> result;

        public static LoginUserResult copy$default(LoginUserResult loginUserResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = loginUserResult.result;
            }
            return loginUserResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<User> component1() {
            return this.result;
        }

        public final LoginUserResult copy(ConversationKitResult<User> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new LoginUserResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof LoginUserResult) && Intrinsics.areEqual(this.result, ((LoginUserResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "LoginUserResult(result=" + this.result + ')';
        }

        public final ConversationKitResult<User> getResult() {
            return this.result;
        }

        public LoginUserResult(ConversationKitResult<User> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$AlreadyLoggedInResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/User;", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AlreadyLoggedInResult extends Effect {
        private final ConversationKitResult<User> result;

        public static AlreadyLoggedInResult copy$default(AlreadyLoggedInResult alreadyLoggedInResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = alreadyLoggedInResult.result;
            }
            return alreadyLoggedInResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<User> component1() {
            return this.result;
        }

        public final AlreadyLoggedInResult copy(ConversationKitResult<User> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new AlreadyLoggedInResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AlreadyLoggedInResult) && Intrinsics.areEqual(this.result, ((AlreadyLoggedInResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "AlreadyLoggedInResult(result=" + this.result + ')';
        }

        public AlreadyLoggedInResult(ConversationKitResult<User> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }

        public final ConversationKitResult<User> getResult() {
            return this.result;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\u0004HÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$LogoutUserResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LogoutUserResult extends Effect {
        private final ConversationKitResult<Object> result;

        public static LogoutUserResult copy$default(LogoutUserResult logoutUserResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = logoutUserResult.result;
            }
            return logoutUserResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<Object> component1() {
            return this.result;
        }

        public final LogoutUserResult copy(ConversationKitResult<? extends Object> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new LogoutUserResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof LogoutUserResult) && Intrinsics.areEqual(this.result, ((LogoutUserResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "LogoutUserResult(result=" + this.result + ')';
        }

        public final ConversationKitResult<Object> getResult() {
            return this.result;
        }

        public LogoutUserResult(ConversationKitResult<? extends Object> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }
    }

    @Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B%\u0012\b\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\f\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005\u0012\u0006\u0010\u0007\u001a\u00020\b¢\u0006\u0002\u0010\tJ\u000b\u0010\u0010\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u000f\u0010\u0011\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005HÆ\u0003J\t\u0010\u0012\u001a\u00020\bHÆ\u0003J/\u0010\u0013\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\u000e\b\u0002\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u00052\b\b\u0002\u0010\u0007\u001a\u00020\bHÆ\u0001J\u0013\u0010\u0014\u001a\u00020\u00152\b\u0010\u0016\u001a\u0004\u0018\u00010\u0017HÖ\u0003J\t\u0010\u0018\u001a\u00020\u0019HÖ\u0001J\t\u0010\u001a\u001a\u00020\bHÖ\u0001R\u0011\u0010\u0007\u001a\u00020\b¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0017\u0010\u0004\u001a\b\u0012\u0004\u0012\u00020\u00060\u0005¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\rR\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000f¨\u0006\u001b"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$CheckForPersistedUserResult;", "Lzendesk/conversationkit/android/internal/Effect;", "user", "Lzendesk/conversationkit/android/model/User;", "result", "Lzendesk/conversationkit/android/ConversationKitResult$Success;", "", Bayeux.KEY_CLIENT_ID, "", "(Lzendesk/conversationkit/android/model/User;Lzendesk/conversationkit/android/ConversationKitResult$Success;Ljava/lang/String;)V", "getClientId", "()Ljava/lang/String;", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult$Success;", "getUser", "()Lzendesk/conversationkit/android/model/User;", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CheckForPersistedUserResult extends Effect {
        private final String clientId;
        private final ConversationKitResult.Success<Unit> result;
        private final User user;

        public static CheckForPersistedUserResult copy$default(CheckForPersistedUserResult checkForPersistedUserResult, User user, ConversationKitResult.Success success, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                user = checkForPersistedUserResult.user;
            }
            if ((i & 2) != 0) {
                success = checkForPersistedUserResult.result;
            }
            if ((i & 4) != 0) {
                str = checkForPersistedUserResult.clientId;
            }
            return checkForPersistedUserResult.copy(user, success, str);
        }

        public final User getUser() {
            return this.user;
        }

        public final ConversationKitResult.Success<Unit> component2() {
            return this.result;
        }

        public final String getClientId() {
            return this.clientId;
        }

        public final CheckForPersistedUserResult copy(User user, ConversationKitResult.Success<Unit> result, String clientId) {
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(clientId, "clientId");
            return new CheckForPersistedUserResult(user, result, clientId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof CheckForPersistedUserResult)) {
                return false;
            }
            CheckForPersistedUserResult checkForPersistedUserResult = (CheckForPersistedUserResult) other;
            return Intrinsics.areEqual(this.user, checkForPersistedUserResult.user) && Intrinsics.areEqual(this.result, checkForPersistedUserResult.result) && Intrinsics.areEqual(this.clientId, checkForPersistedUserResult.clientId);
        }

        public int hashCode() {
            User user = this.user;
            return ((((user == null ? 0 : user.hashCode()) * 31) + this.result.hashCode()) * 31) + this.clientId.hashCode();
        }

        public String toString() {
            return "CheckForPersistedUserResult(user=" + this.user + ", result=" + this.result + ", clientId=" + this.clientId + ')';
        }

        public final User getUser() {
            return this.user;
        }

        public final ConversationKitResult.Success<Unit> getResult() {
            return this.result;
        }

        public final String getClientId() {
            return this.clientId;
        }

        public CheckForPersistedUserResult(User user, ConversationKitResult.Success<Unit> result, String clientId) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(clientId, "clientId");
            this.user = user;
            this.result = result;
            this.clientId = clientId;
        }
    }

    @Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u001f\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u000b\u0010\r\u001a\u0004\u0018\u00010\u0006HÆ\u0003J%\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001R\u0013\u0010\u0005\u001a\u0004\u0018\u00010\u0006¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0017"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$RefreshUserResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/User;", "persistedConversation", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/ConversationKitResult;Lzendesk/conversationkit/android/model/Conversation;)V", "getPersistedConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RefreshUserResult extends Effect {
        private final Conversation persistedConversation;
        private final ConversationKitResult<User> result;

        public static RefreshUserResult copy$default(RefreshUserResult refreshUserResult, ConversationKitResult conversationKitResult, Conversation conversation, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = refreshUserResult.result;
            }
            if ((i & 2) != 0) {
                conversation = refreshUserResult.persistedConversation;
            }
            return refreshUserResult.copy(conversationKitResult, conversation);
        }

        public final ConversationKitResult<User> component1() {
            return this.result;
        }

        public final Conversation getPersistedConversation() {
            return this.persistedConversation;
        }

        public final RefreshUserResult copy(ConversationKitResult<User> result, Conversation persistedConversation) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new RefreshUserResult(result, persistedConversation);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof RefreshUserResult)) {
                return false;
            }
            RefreshUserResult refreshUserResult = (RefreshUserResult) other;
            return Intrinsics.areEqual(this.result, refreshUserResult.result) && Intrinsics.areEqual(this.persistedConversation, refreshUserResult.persistedConversation);
        }

        public int hashCode() {
            int iHashCode = this.result.hashCode() * 31;
            Conversation conversation = this.persistedConversation;
            return iHashCode + (conversation == null ? 0 : conversation.hashCode());
        }

        public String toString() {
            return "RefreshUserResult(result=" + this.result + ", persistedConversation=" + this.persistedConversation + ')';
        }

        public RefreshUserResult(ConversationKitResult conversationKitResult, Conversation conversation, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(conversationKitResult, (i & 2) != 0 ? null : conversation);
        }

        public final ConversationKitResult<User> getResult() {
            return this.result;
        }

        public final Conversation getPersistedConversation() {
            return this.persistedConversation;
        }

        public RefreshUserResult(ConversationKitResult<User> result, Conversation conversation) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
            this.persistedConversation = conversation;
        }
    }

    @Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u001b\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0006HÆ\u0003J#\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0017"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$CreateConversationResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "user", "Lzendesk/conversationkit/android/model/User;", "(Lzendesk/conversationkit/android/ConversationKitResult;Lzendesk/conversationkit/android/model/User;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "getUser", "()Lzendesk/conversationkit/android/model/User;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class CreateConversationResult extends Effect {
        private final ConversationKitResult<Conversation> result;
        private final User user;

        public static CreateConversationResult copy$default(CreateConversationResult createConversationResult, ConversationKitResult conversationKitResult, User user, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = createConversationResult.result;
            }
            if ((i & 2) != 0) {
                user = createConversationResult.user;
            }
            return createConversationResult.copy(conversationKitResult, user);
        }

        public final ConversationKitResult<Conversation> component1() {
            return this.result;
        }

        public final User getUser() {
            return this.user;
        }

        public final CreateConversationResult copy(ConversationKitResult<Conversation> result, User user) {
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(user, "user");
            return new CreateConversationResult(result, user);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof CreateConversationResult)) {
                return false;
            }
            CreateConversationResult createConversationResult = (CreateConversationResult) other;
            return Intrinsics.areEqual(this.result, createConversationResult.result) && Intrinsics.areEqual(this.user, createConversationResult.user);
        }

        public int hashCode() {
            return (this.result.hashCode() * 31) + this.user.hashCode();
        }

        public String toString() {
            return "CreateConversationResult(result=" + this.result + ", user=" + this.user + ')';
        }

        public final ConversationKitResult<Conversation> getResult() {
            return this.result;
        }

        public final User getUser() {
            return this.user;
        }

        public CreateConversationResult(ConversationKitResult<Conversation> result, User user) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(user, "user");
            this.result = result;
            this.user = user;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u001b\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0006HÆ\u0003J#\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00062\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0015HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$GetConversationResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "shouldRefresh", "", "(Lzendesk/conversationkit/android/ConversationKitResult;Z)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "getShouldRefresh", "()Z", "component1", "component2", "copy", "equals", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetConversationResult extends Effect {
        private final ConversationKitResult<Conversation> result;
        private final boolean shouldRefresh;

        public static GetConversationResult copy$default(GetConversationResult getConversationResult, ConversationKitResult conversationKitResult, boolean z, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = getConversationResult.result;
            }
            if ((i & 2) != 0) {
                z = getConversationResult.shouldRefresh;
            }
            return getConversationResult.copy(conversationKitResult, z);
        }

        public final ConversationKitResult<Conversation> component1() {
            return this.result;
        }

        public final boolean getShouldRefresh() {
            return this.shouldRefresh;
        }

        public final GetConversationResult copy(ConversationKitResult<Conversation> result, boolean shouldRefresh) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new GetConversationResult(result, shouldRefresh);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof GetConversationResult)) {
                return false;
            }
            GetConversationResult getConversationResult = (GetConversationResult) other;
            return Intrinsics.areEqual(this.result, getConversationResult.result) && this.shouldRefresh == getConversationResult.shouldRefresh;
        }

        public int hashCode() {
            return (this.result.hashCode() * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldRefresh);
        }

        public String toString() {
            return "GetConversationResult(result=" + this.result + ", shouldRefresh=" + this.shouldRefresh + ')';
        }

        public final ConversationKitResult<Conversation> getResult() {
            return this.result;
        }

        public final boolean getShouldRefresh() {
            return this.shouldRefresh;
        }

        public GetConversationResult(ConversationKitResult<Conversation> result, boolean z) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
            this.shouldRefresh = z;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\n\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u001b\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0006HÆ\u0003J#\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00062\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0015HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$ProactiveMessageReferral;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "shouldRefresh", "", "(Lzendesk/conversationkit/android/ConversationKitResult;Z)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "getShouldRefresh", "()Z", "component1", "component2", "copy", "equals", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ProactiveMessageReferral extends Effect {
        private final ConversationKitResult<Conversation> result;
        private final boolean shouldRefresh;

        public static ProactiveMessageReferral copy$default(ProactiveMessageReferral proactiveMessageReferral, ConversationKitResult conversationKitResult, boolean z, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = proactiveMessageReferral.result;
            }
            if ((i & 2) != 0) {
                z = proactiveMessageReferral.shouldRefresh;
            }
            return proactiveMessageReferral.copy(conversationKitResult, z);
        }

        public final ConversationKitResult<Conversation> component1() {
            return this.result;
        }

        public final boolean getShouldRefresh() {
            return this.shouldRefresh;
        }

        public final ProactiveMessageReferral copy(ConversationKitResult<Conversation> result, boolean shouldRefresh) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new ProactiveMessageReferral(result, shouldRefresh);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ProactiveMessageReferral)) {
                return false;
            }
            ProactiveMessageReferral proactiveMessageReferral = (ProactiveMessageReferral) other;
            return Intrinsics.areEqual(this.result, proactiveMessageReferral.result) && this.shouldRefresh == proactiveMessageReferral.shouldRefresh;
        }

        public int hashCode() {
            return (this.result.hashCode() * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldRefresh);
        }

        public String toString() {
            return "ProactiveMessageReferral(result=" + this.result + ", shouldRefresh=" + this.shouldRefresh + ')';
        }

        public final ConversationKitResult<Conversation> getResult() {
            return this.result;
        }

        public final boolean getShouldRefresh() {
            return this.shouldRefresh;
        }

        public ProactiveMessageReferral(ConversationKitResult<Conversation> result, boolean z) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
            this.shouldRefresh = z;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$RefreshConversationResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class RefreshConversationResult extends Effect {
        private final ConversationKitResult<Conversation> result;

        public static RefreshConversationResult copy$default(RefreshConversationResult refreshConversationResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = refreshConversationResult.result;
            }
            return refreshConversationResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<Conversation> component1() {
            return this.result;
        }

        public final RefreshConversationResult copy(ConversationKitResult<Conversation> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new RefreshConversationResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof RefreshConversationResult) && Intrinsics.areEqual(this.result, ((RefreshConversationResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "RefreshConversationResult(result=" + this.result + ')';
        }

        public final ConversationKitResult<Conversation> getResult() {
            return this.result;
        }

        public RefreshConversationResult(ConversationKitResult<Conversation> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }
    }

    @Metadata(m17d1 = {"\u00002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001f\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bJ\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0010\u001a\u00020\u0005HÆ\u0003J\u000b\u0010\u0011\u001a\u0004\u0018\u00010\u0007HÆ\u0003J)\u0010\u0012\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u0007HÆ\u0001J\u0013\u0010\u0013\u001a\u00020\u00142\b\u0010\u0015\u001a\u0004\u0018\u00010\u0016HÖ\u0003J\t\u0010\u0017\u001a\u00020\u0018HÖ\u0001J\t\u0010\u0019\u001a\u00020\u0005HÖ\u0001R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\nR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000e¨\u0006\u001a"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$MessageReceived;", "Lzendesk/conversationkit/android/internal/Effect;", "message", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Lzendesk/conversationkit/android/model/Conversation;)V", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MessageReceived extends Effect {
        private final Conversation conversation;
        private final String conversationId;
        private final Message message;

        public static MessageReceived copy$default(MessageReceived messageReceived, Message message, String str, Conversation conversation, int i, Object obj) {
            if ((i & 1) != 0) {
                message = messageReceived.message;
            }
            if ((i & 2) != 0) {
                str = messageReceived.conversationId;
            }
            if ((i & 4) != 0) {
                conversation = messageReceived.conversation;
            }
            return messageReceived.copy(message, str, conversation);
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final MessageReceived copy(Message message, String conversationId, Conversation conversation) {
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new MessageReceived(message, conversationId, conversation);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessageReceived)) {
                return false;
            }
            MessageReceived messageReceived = (MessageReceived) other;
            return Intrinsics.areEqual(this.message, messageReceived.message) && Intrinsics.areEqual(this.conversationId, messageReceived.conversationId) && Intrinsics.areEqual(this.conversation, messageReceived.conversation);
        }

        public int hashCode() {
            int iHashCode = ((this.message.hashCode() * 31) + this.conversationId.hashCode()) * 31;
            Conversation conversation = this.conversation;
            return iHashCode + (conversation == null ? 0 : conversation.hashCode());
        }

        public String toString() {
            return "MessageReceived(message=" + this.message + ", conversationId=" + this.conversationId + ", conversation=" + this.conversation + ')';
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public MessageReceived(Message message, String conversationId, Conversation conversation) {
            super(null);
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.message = message;
            this.conversationId = conversationId;
            this.conversation = conversation;
        }
    }

    @Metadata(m17d1 = {"\u0000@\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0006\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010 \n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B3\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0012\u0010\b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000b0\n0\t¢\u0006\u0002\u0010\fJ\t\u0010\u0015\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\u0016\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\t\u0010\u0017\u001a\u00020\u0007HÆ\u0003J\u0015\u0010\u0018\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000b0\n0\tHÆ\u0003J?\u0010\u0019\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0014\b\u0002\u0010\b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000b0\n0\tHÆ\u0001J\u0013\u0010\u001a\u001a\u00020\u001b2\b\u0010\u001c\u001a\u0004\u0018\u00010\u001dHÖ\u0003J\t\u0010\u001e\u001a\u00020\u001fHÖ\u0001J\t\u0010 \u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0006\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R\u001d\u0010\b\u001a\u000e\u0012\n\u0012\b\u0012\u0004\u0012\u00020\u000b0\n0\t¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014¨\u0006!"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$LoadMoreMessages;", "Lzendesk/conversationkit/android/internal/Effect;", "conversationId", "", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "beforeTimestamp", "", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "", "Lzendesk/conversationkit/android/model/Message;", "(Ljava/lang/String;Lzendesk/conversationkit/android/model/Conversation;DLzendesk/conversationkit/android/ConversationKitResult;)V", "getBeforeTimestamp", "()D", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "getConversationId", "()Ljava/lang/String;", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LoadMoreMessages extends Effect {
        private final double beforeTimestamp;
        private final Conversation conversation;
        private final String conversationId;
        private final ConversationKitResult<List<Message>> result;

        public static LoadMoreMessages copy$default(LoadMoreMessages loadMoreMessages, String str, Conversation conversation, double d, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                str = loadMoreMessages.conversationId;
            }
            if ((i & 2) != 0) {
                conversation = loadMoreMessages.conversation;
            }
            Conversation conversation2 = conversation;
            if ((i & 4) != 0) {
                d = loadMoreMessages.beforeTimestamp;
            }
            double d2 = d;
            if ((i & 8) != 0) {
                conversationKitResult = loadMoreMessages.result;
            }
            return loadMoreMessages.copy(str, conversation2, d2, conversationKitResult);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final double getBeforeTimestamp() {
            return this.beforeTimestamp;
        }

        public final ConversationKitResult<List<Message>> component4() {
            return this.result;
        }

        public final LoadMoreMessages copy(String conversationId, Conversation conversation, double beforeTimestamp, ConversationKitResult<? extends List<Message>> result) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(result, "result");
            return new LoadMoreMessages(conversationId, conversation, beforeTimestamp, result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LoadMoreMessages)) {
                return false;
            }
            LoadMoreMessages loadMoreMessages = (LoadMoreMessages) other;
            return Intrinsics.areEqual(this.conversationId, loadMoreMessages.conversationId) && Intrinsics.areEqual(this.conversation, loadMoreMessages.conversation) && Double.compare(this.beforeTimestamp, loadMoreMessages.beforeTimestamp) == 0 && Intrinsics.areEqual(this.result, loadMoreMessages.result);
        }

        public int hashCode() {
            int iHashCode = this.conversationId.hashCode() * 31;
            Conversation conversation = this.conversation;
            return ((((iHashCode + (conversation == null ? 0 : conversation.hashCode())) * 31) + ComplexDouble$.ExternalSyntheticBackport0.m(this.beforeTimestamp)) * 31) + this.result.hashCode();
        }

        public String toString() {
            return "LoadMoreMessages(conversationId=" + this.conversationId + ", conversation=" + this.conversation + ", beforeTimestamp=" + this.beforeTimestamp + ", result=" + this.result + ')';
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final double getBeforeTimestamp() {
            return this.beforeTimestamp;
        }

        public final ConversationKitResult<List<Message>> getResult() {
            return this.result;
        }

        public LoadMoreMessages(String conversationId, Conversation conversation, double d, ConversationKitResult<? extends List<Message>> result) {
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            Intrinsics.checkNotNullParameter(result, "result");
            this.conversationId = conversationId;
            this.conversation = conversation;
            this.beforeTimestamp = d;
            this.result = result;
        }
    }

    @Metadata(m17d1 = {"\u00006\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\b\u0014\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B=\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\b\u001a\u00020\t\u0012\u0014\u0010\n\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\f\u0018\u00010\u000b¢\u0006\u0002\u0010\rJ\t\u0010\u0018\u001a\u00020\u0003HÆ\u0003J\t\u0010\u0019\u001a\u00020\u0005HÆ\u0003J\u000b\u0010\u001a\u001a\u0004\u0018\u00010\u0007HÆ\u0003J\t\u0010\u001b\u001a\u00020\tHÆ\u0003J\u0017\u0010\u001c\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\f\u0018\u00010\u000bHÆ\u0003JK\u0010\u001d\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\n\b\u0002\u0010\u0006\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\b\u001a\u00020\t2\u0016\b\u0002\u0010\n\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\f\u0018\u00010\u000bHÆ\u0001J\u0013\u0010\u001e\u001a\u00020\t2\b\u0010\u001f\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010 \u001a\u00020!HÖ\u0001J\t\u0010\"\u001a\u00020\u0005HÖ\u0001R\u0013\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013R\u001f\u0010\n\u001a\u0010\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\f\u0018\u00010\u000b¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\b\u001a\u00020\t¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017¨\u0006#"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$MessagePrepared;", "Lzendesk/conversationkit/android/internal/Effect;", "message", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "shouldUpdateConversation", "", "metadata", "", "", "(Lzendesk/conversationkit/android/model/Message;Ljava/lang/String;Lzendesk/conversationkit/android/model/Conversation;ZLjava/util/Map;)V", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "getMetadata", "()Ljava/util/Map;", "getShouldUpdateConversation", "()Z", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "other", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MessagePrepared extends Effect {
        private final Conversation conversation;
        private final String conversationId;
        private final Message message;
        private final Map<String, Object> metadata;
        private final boolean shouldUpdateConversation;

        public static MessagePrepared copy$default(MessagePrepared messagePrepared, Message message, String str, Conversation conversation, boolean z, Map map, int i, Object obj) {
            if ((i & 1) != 0) {
                message = messagePrepared.message;
            }
            if ((i & 2) != 0) {
                str = messagePrepared.conversationId;
            }
            String str2 = str;
            if ((i & 4) != 0) {
                conversation = messagePrepared.conversation;
            }
            Conversation conversation2 = conversation;
            if ((i & 8) != 0) {
                z = messagePrepared.shouldUpdateConversation;
            }
            boolean z2 = z;
            if ((i & 16) != 0) {
                map = messagePrepared.metadata;
            }
            return messagePrepared.copy(message, str2, conversation2, z2, map);
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final boolean getShouldUpdateConversation() {
            return this.shouldUpdateConversation;
        }

        public final Map<String, Object> component5() {
            return this.metadata;
        }

        public final MessagePrepared copy(Message message, String conversationId, Conversation conversation, boolean shouldUpdateConversation, Map<String, ? extends Object> metadata) {
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new MessagePrepared(message, conversationId, conversation, shouldUpdateConversation, metadata);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MessagePrepared)) {
                return false;
            }
            MessagePrepared messagePrepared = (MessagePrepared) other;
            return Intrinsics.areEqual(this.message, messagePrepared.message) && Intrinsics.areEqual(this.conversationId, messagePrepared.conversationId) && Intrinsics.areEqual(this.conversation, messagePrepared.conversation) && this.shouldUpdateConversation == messagePrepared.shouldUpdateConversation && Intrinsics.areEqual(this.metadata, messagePrepared.metadata);
        }

        public int hashCode() {
            int iHashCode = ((this.message.hashCode() * 31) + this.conversationId.hashCode()) * 31;
            Conversation conversation = this.conversation;
            int iHashCode2 = (((iHashCode + (conversation == null ? 0 : conversation.hashCode())) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.shouldUpdateConversation)) * 31;
            Map<String, Object> map = this.metadata;
            return iHashCode2 + (map != null ? map.hashCode() : 0);
        }

        public String toString() {
            return "MessagePrepared(message=" + this.message + ", conversationId=" + this.conversationId + ", conversation=" + this.conversation + ", shouldUpdateConversation=" + this.shouldUpdateConversation + ", metadata=" + this.metadata + ')';
        }

        public final Message getMessage() {
            return this.message;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final boolean getShouldUpdateConversation() {
            return this.shouldUpdateConversation;
        }

        public final Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public MessagePrepared(Message message, String conversationId, Conversation conversation, boolean z, Map<String, ? extends Object> map) {
            super(null);
            Intrinsics.checkNotNullParameter(message, "message");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.message = message;
            this.conversationId = conversationId;
            this.conversation = conversation;
            this.shouldUpdateConversation = z;
            this.metadata = map;
        }
    }

    @Metadata(m17d1 = {"\u00008\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u000f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B/\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006\u0012\b\u0010\u0007\u001a\u0004\u0018\u00010\u0004\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nJ\u000f\u0010\u0013\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\u0014\u001a\u00020\u0006HÆ\u0003J\u000b\u0010\u0015\u001a\u0004\u0018\u00010\u0004HÆ\u0003J\u000b\u0010\u0016\u001a\u0004\u0018\u00010\tHÆ\u0003J;\u0010\u0017\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u00062\n\b\u0002\u0010\u0007\u001a\u0004\u0018\u00010\u00042\n\b\u0002\u0010\b\u001a\u0004\u0018\u00010\tHÆ\u0001J\u0013\u0010\u0018\u001a\u00020\u00192\b\u0010\u001a\u001a\u0004\u0018\u00010\u001bHÖ\u0003J\t\u0010\u001c\u001a\u00020\u001dHÖ\u0001J\t\u0010\u001e\u001a\u00020\u0006HÖ\u0001R\u0013\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\b\n\u0000\u001a\u0004\b\u000b\u0010\fR\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0013\u0010\u0007\u001a\u0004\u0018\u00010\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u0010R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012¨\u0006\u001f"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$SendMessageResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Message;", "conversationId", "", "message", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/ConversationKitResult;Ljava/lang/String;Lzendesk/conversationkit/android/model/Message;Lzendesk/conversationkit/android/model/Conversation;)V", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "getConversationId", "()Ljava/lang/String;", "getMessage", "()Lzendesk/conversationkit/android/model/Message;", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "component2", "component3", "component4", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendMessageResult extends Effect {
        private final Conversation conversation;
        private final String conversationId;
        private final Message message;
        private final ConversationKitResult<Message> result;

        public static SendMessageResult copy$default(SendMessageResult sendMessageResult, ConversationKitResult conversationKitResult, String str, Message message, Conversation conversation, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = sendMessageResult.result;
            }
            if ((i & 2) != 0) {
                str = sendMessageResult.conversationId;
            }
            if ((i & 4) != 0) {
                message = sendMessageResult.message;
            }
            if ((i & 8) != 0) {
                conversation = sendMessageResult.conversation;
            }
            return sendMessageResult.copy(conversationKitResult, str, message, conversation);
        }

        public final ConversationKitResult<Message> component1() {
            return this.result;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final SendMessageResult copy(ConversationKitResult<Message> result, String conversationId, Message message, Conversation conversation) {
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new SendMessageResult(result, conversationId, message, conversation);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof SendMessageResult)) {
                return false;
            }
            SendMessageResult sendMessageResult = (SendMessageResult) other;
            return Intrinsics.areEqual(this.result, sendMessageResult.result) && Intrinsics.areEqual(this.conversationId, sendMessageResult.conversationId) && Intrinsics.areEqual(this.message, sendMessageResult.message) && Intrinsics.areEqual(this.conversation, sendMessageResult.conversation);
        }

        public int hashCode() {
            int iHashCode = ((this.result.hashCode() * 31) + this.conversationId.hashCode()) * 31;
            Message message = this.message;
            int iHashCode2 = (iHashCode + (message == null ? 0 : message.hashCode())) * 31;
            Conversation conversation = this.conversation;
            return iHashCode2 + (conversation != null ? conversation.hashCode() : 0);
        }

        public String toString() {
            return "SendMessageResult(result=" + this.result + ", conversationId=" + this.conversationId + ", message=" + this.message + ", conversation=" + this.conversation + ')';
        }

        public final ConversationKitResult<Message> getResult() {
            return this.result;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Message getMessage() {
            return this.message;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public SendMessageResult(ConversationKitResult<Message> result, String conversationId, Message message, Conversation conversation) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.result = result;
            this.conversationId = conversationId;
            this.message = message;
            this.conversation = conversation;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$PushTokenPrepared;", "Lzendesk/conversationkit/android/internal/Effect;", "pushToken", "", "(Ljava/lang/String;)V", "getPushToken", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PushTokenPrepared extends Effect {
        private final String pushToken;

        public static PushTokenPrepared copy$default(PushTokenPrepared pushTokenPrepared, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = pushTokenPrepared.pushToken;
            }
            return pushTokenPrepared.copy(str);
        }

        public final String getPushToken() {
            return this.pushToken;
        }

        public final PushTokenPrepared copy(String pushToken) {
            Intrinsics.checkNotNullParameter(pushToken, "pushToken");
            return new PushTokenPrepared(pushToken);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof PushTokenPrepared) && Intrinsics.areEqual(this.pushToken, ((PushTokenPrepared) other).pushToken);
        }

        public int hashCode() {
            return this.pushToken.hashCode();
        }

        public String toString() {
            return "PushTokenPrepared(pushToken=" + this.pushToken + ')';
        }

        public final String getPushToken() {
            return this.pushToken;
        }

        public PushTokenPrepared(String pushToken) {
            super(null);
            Intrinsics.checkNotNullParameter(pushToken, "pushToken");
            this.pushToken = pushToken;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$IntegrationIdCached;", "Lzendesk/conversationkit/android/internal/Effect;", "integrationId", "", "(Ljava/lang/String;)V", "getIntegrationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class IntegrationIdCached extends Effect {
        private final String integrationId;

        public static IntegrationIdCached copy$default(IntegrationIdCached integrationIdCached, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = integrationIdCached.integrationId;
            }
            return integrationIdCached.copy(str);
        }

        public final String getIntegrationId() {
            return this.integrationId;
        }

        public final IntegrationIdCached copy(String integrationId) {
            Intrinsics.checkNotNullParameter(integrationId, "integrationId");
            return new IntegrationIdCached(integrationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof IntegrationIdCached) && Intrinsics.areEqual(this.integrationId, ((IntegrationIdCached) other).integrationId);
        }

        public int hashCode() {
            return this.integrationId.hashCode();
        }

        public String toString() {
            return "IntegrationIdCached(integrationId=" + this.integrationId + ')';
        }

        public final String getIntegrationId() {
            return this.integrationId;
        }

        public IntegrationIdCached(String integrationId) {
            super(null);
            Intrinsics.checkNotNullParameter(integrationId, "integrationId");
            this.integrationId = integrationId;
        }
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001b\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0006¢\u0006\u0002\u0010\u0007J\u000f\u0010\f\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0006HÆ\u0003J#\u0010\u000e\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0006HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012HÖ\u0003J\t\u0010\u0013\u001a\u00020\u0014HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0006HÖ\u0001R\u0011\u0010\u0005\u001a\u00020\u0006¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000b¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$PushTokenUpdateResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "", "pushToken", "", "(Lzendesk/conversationkit/android/ConversationKitResult;Ljava/lang/String;)V", "getPushToken", "()Ljava/lang/String;", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PushTokenUpdateResult extends Effect {
        private final String pushToken;
        private final ConversationKitResult<Unit> result;

        public static PushTokenUpdateResult copy$default(PushTokenUpdateResult pushTokenUpdateResult, ConversationKitResult conversationKitResult, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = pushTokenUpdateResult.result;
            }
            if ((i & 2) != 0) {
                str = pushTokenUpdateResult.pushToken;
            }
            return pushTokenUpdateResult.copy(conversationKitResult, str);
        }

        public final ConversationKitResult<Unit> component1() {
            return this.result;
        }

        public final String getPushToken() {
            return this.pushToken;
        }

        public final PushTokenUpdateResult copy(ConversationKitResult<Unit> result, String pushToken) {
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(pushToken, "pushToken");
            return new PushTokenUpdateResult(result, pushToken);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof PushTokenUpdateResult)) {
                return false;
            }
            PushTokenUpdateResult pushTokenUpdateResult = (PushTokenUpdateResult) other;
            return Intrinsics.areEqual(this.result, pushTokenUpdateResult.result) && Intrinsics.areEqual(this.pushToken, pushTokenUpdateResult.pushToken);
        }

        public int hashCode() {
            return (this.result.hashCode() * 31) + this.pushToken.hashCode();
        }

        public String toString() {
            return "PushTokenUpdateResult(result=" + this.result + ", pushToken=" + this.pushToken + ')';
        }

        public final ConversationKitResult<Unit> getResult() {
            return this.result;
        }

        public final String getPushToken() {
            return this.pushToken;
        }

        public PushTokenUpdateResult(ConversationKitResult<Unit> result, String pushToken) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            Intrinsics.checkNotNullParameter(pushToken, "pushToken");
            this.result = result;
            this.pushToken = pushToken;
        }
    }

    @Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\u000b\u0010\f\u001a\u0004\u0018\u00010\u0005HÆ\u0003J\u001f\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0015HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0013\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$ActivityEventReceived;", "Lzendesk/conversationkit/android/internal/Effect;", "activityEvent", "Lzendesk/conversationkit/android/model/ActivityEvent;", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/model/ActivityEvent;Lzendesk/conversationkit/android/model/Conversation;)V", "getActivityEvent", "()Lzendesk/conversationkit/android/model/ActivityEvent;", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ActivityEventReceived extends Effect {
        private final ActivityEvent activityEvent;
        private final Conversation conversation;

        public static ActivityEventReceived copy$default(ActivityEventReceived activityEventReceived, ActivityEvent activityEvent, Conversation conversation, int i, Object obj) {
            if ((i & 1) != 0) {
                activityEvent = activityEventReceived.activityEvent;
            }
            if ((i & 2) != 0) {
                conversation = activityEventReceived.conversation;
            }
            return activityEventReceived.copy(activityEvent, conversation);
        }

        public final ActivityEvent getActivityEvent() {
            return this.activityEvent;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final ActivityEventReceived copy(ActivityEvent activityEvent, Conversation conversation) {
            Intrinsics.checkNotNullParameter(activityEvent, "activityEvent");
            return new ActivityEventReceived(activityEvent, conversation);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ActivityEventReceived)) {
                return false;
            }
            ActivityEventReceived activityEventReceived = (ActivityEventReceived) other;
            return Intrinsics.areEqual(this.activityEvent, activityEventReceived.activityEvent) && Intrinsics.areEqual(this.conversation, activityEventReceived.conversation);
        }

        public int hashCode() {
            int iHashCode = this.activityEvent.hashCode() * 31;
            Conversation conversation = this.conversation;
            return iHashCode + (conversation == null ? 0 : conversation.hashCode());
        }

        public String toString() {
            return "ActivityEventReceived(activityEvent=" + this.activityEvent + ", conversation=" + this.conversation + ')';
        }

        public final ActivityEvent getActivityEvent() {
            return this.activityEvent;
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public ActivityEventReceived(ActivityEvent activityEvent, Conversation conversation) {
            super(null);
            Intrinsics.checkNotNullParameter(activityEvent, "activityEvent");
            this.activityEvent = activityEvent;
            this.conversation = conversation;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$PersistedUserReceived;", "Lzendesk/conversationkit/android/internal/Effect;", "user", "Lzendesk/conversationkit/android/model/User;", "(Lzendesk/conversationkit/android/model/User;)V", "getUser", "()Lzendesk/conversationkit/android/model/User;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class PersistedUserReceived extends Effect {
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

        public PersistedUserReceived(User user) {
            super(null);
            Intrinsics.checkNotNullParameter(user, "user");
            this.user = user;
        }

        public final User getUser() {
            return this.user;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$GetVisitType;", "Lzendesk/conversationkit/android/internal/Effect;", "visitType", "Lzendesk/conversationkit/android/model/VisitType;", "(Lzendesk/conversationkit/android/model/VisitType;)V", "getVisitType", "()Lzendesk/conversationkit/android/model/VisitType;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetVisitType extends Effect {
        private final VisitType visitType;

        public static GetVisitType copy$default(GetVisitType getVisitType, VisitType visitType, int i, Object obj) {
            if ((i & 1) != 0) {
                visitType = getVisitType.visitType;
            }
            return getVisitType.copy(visitType);
        }

        public final VisitType getVisitType() {
            return this.visitType;
        }

        public final GetVisitType copy(VisitType visitType) {
            Intrinsics.checkNotNullParameter(visitType, "visitType");
            return new GetVisitType(visitType);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof GetVisitType) && this.visitType == ((GetVisitType) other).visitType;
        }

        public int hashCode() {
            return this.visitType.hashCode();
        }

        public String toString() {
            return "GetVisitType(visitType=" + this.visitType + ')';
        }

        public GetVisitType(VisitType visitType) {
            super(null);
            Intrinsics.checkNotNullParameter(visitType, "visitType");
            this.visitType = visitType;
        }

        public final VisitType getVisitType() {
            return this.visitType;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$GetProactiveMessage;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/ProactiveMessage;", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetProactiveMessage extends Effect {
        private final ConversationKitResult<ProactiveMessage> result;

        public static GetProactiveMessage copy$default(GetProactiveMessage getProactiveMessage, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = getProactiveMessage.result;
            }
            return getProactiveMessage.copy(conversationKitResult);
        }

        public final ConversationKitResult<ProactiveMessage> component1() {
            return this.result;
        }

        public final GetProactiveMessage copy(ConversationKitResult<ProactiveMessage> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new GetProactiveMessage(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof GetProactiveMessage) && Intrinsics.areEqual(this.result, ((GetProactiveMessage) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "GetProactiveMessage(result=" + this.result + ')';
        }

        public final ConversationKitResult<ProactiveMessage> getResult() {
            return this.result;
        }

        public GetProactiveMessage(ConversationKitResult<ProactiveMessage> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$ReAuthenticateUser;", "Lzendesk/conversationkit/android/internal/Effect;", "jwt", "", "(Ljava/lang/String;)V", "getJwt", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ReAuthenticateUser extends Effect {
        private final String jwt;

        public static ReAuthenticateUser copy$default(ReAuthenticateUser reAuthenticateUser, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = reAuthenticateUser.jwt;
            }
            return reAuthenticateUser.copy(str);
        }

        public final String getJwt() {
            return this.jwt;
        }

        public final ReAuthenticateUser copy(String jwt) {
            Intrinsics.checkNotNullParameter(jwt, "jwt");
            return new ReAuthenticateUser(jwt);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ReAuthenticateUser) && Intrinsics.areEqual(this.jwt, ((ReAuthenticateUser) other).jwt);
        }

        public int hashCode() {
            return this.jwt.hashCode();
        }

        public String toString() {
            return "ReAuthenticateUser(jwt=" + this.jwt + ')';
        }

        public ReAuthenticateUser(String jwt) {
            super(null);
            Intrinsics.checkNotNullParameter(jwt, "jwt");
            this.jwt = jwt;
        }

        public final String getJwt() {
            return this.jwt;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$ConversationAddedResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationAddedResult extends Effect {
        private final ConversationKitResult<Conversation> result;

        public static ConversationAddedResult copy$default(ConversationAddedResult conversationAddedResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = conversationAddedResult.result;
            }
            return conversationAddedResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<Conversation> component1() {
            return this.result;
        }

        public final ConversationAddedResult copy(ConversationKitResult<Conversation> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new ConversationAddedResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationAddedResult) && Intrinsics.areEqual(this.result, ((ConversationAddedResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "ConversationAddedResult(result=" + this.result + ')';
        }

        public ConversationAddedResult(ConversationKitResult<Conversation> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }

        public final ConversationKitResult<Conversation> getResult() {
            return this.result;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0004HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$ConversationRemovedResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationRemovedResult extends Effect {
        private final ConversationKitResult<String> result;

        public static ConversationRemovedResult copy$default(ConversationRemovedResult conversationRemovedResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = conversationRemovedResult.result;
            }
            return conversationRemovedResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<String> component1() {
            return this.result;
        }

        public final ConversationRemovedResult copy(ConversationKitResult<String> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new ConversationRemovedResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationRemovedResult) && Intrinsics.areEqual(this.result, ((ConversationRemovedResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "ConversationRemovedResult(result=" + this.result + ')';
        }

        public ConversationRemovedResult(ConversationKitResult<String> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }

        public final ConversationKitResult<String> getResult() {
            return this.result;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$ConversationUpdatedResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationUpdatedResult extends Effect {
        private final ConversationKitResult<Conversation> result;

        public static ConversationUpdatedResult copy$default(ConversationUpdatedResult conversationUpdatedResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = conversationUpdatedResult.result;
            }
            return conversationUpdatedResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<Conversation> component1() {
            return this.result;
        }

        public final ConversationUpdatedResult copy(ConversationKitResult<Conversation> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new ConversationUpdatedResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationUpdatedResult) && Intrinsics.areEqual(this.result, ((ConversationUpdatedResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "ConversationUpdatedResult(result=" + this.result + ')';
        }

        public ConversationUpdatedResult(ConversationKitResult<Conversation> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }

        public final ConversationKitResult<Conversation> getResult() {
            return this.result;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$GetConversationsResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/ConversationsPagination;", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class GetConversationsResult extends Effect {
        private final ConversationKitResult<ConversationsPagination> result;

        public static GetConversationsResult copy$default(GetConversationsResult getConversationsResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = getConversationsResult.result;
            }
            return getConversationsResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<ConversationsPagination> component1() {
            return this.result;
        }

        public final GetConversationsResult copy(ConversationKitResult<ConversationsPagination> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new GetConversationsResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof GetConversationsResult) && Intrinsics.areEqual(this.result, ((GetConversationsResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "GetConversationsResult(result=" + this.result + ')';
        }

        public final ConversationKitResult<ConversationsPagination> getResult() {
            return this.result;
        }

        public GetConversationsResult(ConversationKitResult<ConversationsPagination> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0004HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$SendPostbackResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class SendPostbackResult extends Effect {
        private final ConversationKitResult<String> result;

        public static SendPostbackResult copy$default(SendPostbackResult sendPostbackResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = sendPostbackResult.result;
            }
            return sendPostbackResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<String> component1() {
            return this.result;
        }

        public final SendPostbackResult copy(ConversationKitResult<String> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new SendPostbackResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof SendPostbackResult) && Intrinsics.areEqual(this.result, ((SendPostbackResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "SendPostbackResult(result=" + this.result + ')';
        }

        public final ConversationKitResult<String> getResult() {
            return this.result;
        }

        public SendPostbackResult(ConversationKitResult<String> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$AttachmentDownloadStarted;", "Lzendesk/conversationkit/android/internal/Effect;", "conversation", "Lzendesk/conversationkit/android/model/Conversation;", "(Lzendesk/conversationkit/android/model/Conversation;)V", "getConversation", "()Lzendesk/conversationkit/android/model/Conversation;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class AttachmentDownloadStarted extends Effect {
        private final Conversation conversation;

        public static AttachmentDownloadStarted copy$default(AttachmentDownloadStarted attachmentDownloadStarted, Conversation conversation, int i, Object obj) {
            if ((i & 1) != 0) {
                conversation = attachmentDownloadStarted.conversation;
            }
            return attachmentDownloadStarted.copy(conversation);
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public final AttachmentDownloadStarted copy(Conversation conversation) {
            Intrinsics.checkNotNullParameter(conversation, "conversation");
            return new AttachmentDownloadStarted(conversation);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof AttachmentDownloadStarted) && Intrinsics.areEqual(this.conversation, ((AttachmentDownloadStarted) other).conversation);
        }

        public int hashCode() {
            return this.conversation.hashCode();
        }

        public String toString() {
            return "AttachmentDownloadStarted(conversation=" + this.conversation + ')';
        }

        public final Conversation getConversation() {
            return this.conversation;
        }

        public AttachmentDownloadStarted(Conversation conversation) {
            super(null);
            Intrinsics.checkNotNullParameter(conversation, "conversation");
            this.conversation = conversation;
        }
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$OpenAttachmentFromFile;", "Lzendesk/conversationkit/android/internal/Effect;", "file", "Ljava/io/File;", "conversationId", "", "(Ljava/io/File;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getFile", "()Ljava/io/File;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class OpenAttachmentFromFile extends Effect {
        private final String conversationId;
        private final File file;

        public static OpenAttachmentFromFile copy$default(OpenAttachmentFromFile openAttachmentFromFile, File file, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                file = openAttachmentFromFile.file;
            }
            if ((i & 2) != 0) {
                str = openAttachmentFromFile.conversationId;
            }
            return openAttachmentFromFile.copy(file, str);
        }

        public final File getFile() {
            return this.file;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final OpenAttachmentFromFile copy(File file, String conversationId) {
            Intrinsics.checkNotNullParameter(file, "file");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new OpenAttachmentFromFile(file, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof OpenAttachmentFromFile)) {
                return false;
            }
            OpenAttachmentFromFile openAttachmentFromFile = (OpenAttachmentFromFile) other;
            return Intrinsics.areEqual(this.file, openAttachmentFromFile.file) && Intrinsics.areEqual(this.conversationId, openAttachmentFromFile.conversationId);
        }

        public int hashCode() {
            return (this.file.hashCode() * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "OpenAttachmentFromFile(file=" + this.file + ", conversationId=" + this.conversationId + ')';
        }

        public final File getFile() {
            return this.file;
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public OpenAttachmentFromFile(File file, String conversationId) {
            super(null);
            Intrinsics.checkNotNullParameter(file, "file");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.file = file;
            this.conversationId = conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000.\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\u0013\u0012\f\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\u0002\u0010\u0005J\u000f\u0010\b\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0003J\u0019\u0010\t\u001a\u00020\u00002\u000e\b\u0002\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003HÆ\u0001J\u0013\u0010\n\u001a\u00020\u000b2\b\u0010\f\u001a\u0004\u0018\u00010\rHÖ\u0003J\t\u0010\u000e\u001a\u00020\u000fHÖ\u0001J\t\u0010\u0010\u001a\u00020\u0011HÖ\u0001R\u0017\u0010\u0002\u001a\b\u0012\u0004\u0012\u00020\u00040\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0006\u0010\u0007¨\u0006\u0012"}, m18d2 = {"Lzendesk/conversationkit/android/internal/Effect$FetchWaitTimeResult;", "Lzendesk/conversationkit/android/internal/Effect;", "result", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/model/WaitTimeData;", "(Lzendesk/conversationkit/android/ConversationKitResult;)V", "getResult", "()Lzendesk/conversationkit/android/ConversationKitResult;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FetchWaitTimeResult extends Effect {
        private final ConversationKitResult<WaitTimeData> result;

        public static FetchWaitTimeResult copy$default(FetchWaitTimeResult fetchWaitTimeResult, ConversationKitResult conversationKitResult, int i, Object obj) {
            if ((i & 1) != 0) {
                conversationKitResult = fetchWaitTimeResult.result;
            }
            return fetchWaitTimeResult.copy(conversationKitResult);
        }

        public final ConversationKitResult<WaitTimeData> component1() {
            return this.result;
        }

        public final FetchWaitTimeResult copy(ConversationKitResult<WaitTimeData> result) {
            Intrinsics.checkNotNullParameter(result, "result");
            return new FetchWaitTimeResult(result);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof FetchWaitTimeResult) && Intrinsics.areEqual(this.result, ((FetchWaitTimeResult) other).result);
        }

        public int hashCode() {
            return this.result.hashCode();
        }

        public String toString() {
            return "FetchWaitTimeResult(result=" + this.result + ')';
        }

        public final ConversationKitResult<WaitTimeData> getResult() {
            return this.result;
        }

        public FetchWaitTimeResult(ConversationKitResult<WaitTimeData> result) {
            super(null);
            Intrinsics.checkNotNullParameter(result, "result");
            this.result = result;
        }
    }
}
