package zendesk.messaging.android.internal.conversationslistscreen;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0002\u0002\u0003\u0082\u0001\u0002\u0004\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenNavigationEvents;", "", "ConversationScreen", "NotificationPermissions", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenNavigationEvents$ConversationScreen;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenNavigationEvents$NotificationPermissions;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationsListScreenNavigationEvents {

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenNavigationEvents$ConversationScreen;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenNavigationEvents;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationScreen implements ConversationsListScreenNavigationEvents {
        private final String conversationId;

        public static ConversationScreen copy$default(ConversationScreen conversationScreen, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                str = conversationScreen.conversationId;
            }
            return conversationScreen.copy(str);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final ConversationScreen copy(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new ConversationScreen(conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof ConversationScreen) && Intrinsics.areEqual(this.conversationId, ((ConversationScreen) other).conversationId);
        }

        public int hashCode() {
            return this.conversationId.hashCode();
        }

        public String toString() {
            return "ConversationScreen(conversationId=" + this.conversationId + ')';
        }

        public ConversationScreen(String conversationId) {
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenNavigationEvents$NotificationPermissions;", "Lzendesk/messaging/android/internal/conversationslistscreen/ConversationsListScreenNavigationEvents;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class NotificationPermissions implements ConversationsListScreenNavigationEvents {
        public static final NotificationPermissions INSTANCE = new NotificationPermissions();

        private NotificationPermissions() {
        }
    }
}
