package zendesk.messaging.android.internal.messagingscreen;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0002\u0002\u0003\u0082\u0001\u0002\u0004\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction;", "", "LaunchConversationScreenFromNotification", "ResolveScreen", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction$LaunchConversationScreenFromNotification;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction$ResolveScreen;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface MessagingScreenAction {

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction$ResolveScreen;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ResolveScreen implements MessagingScreenAction {
        public static final ResolveScreen INSTANCE = new ResolveScreen();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ResolveScreen)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return -1566430916;
        }

        public String toString() {
            return "ResolveScreen";
        }

        private ResolveScreen() {
        }
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006J\u000b\u0010\f\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u0010\u0010\r\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\nJ&\u0010\u000e\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005HÆ\u0001¢\u0006\u0002\u0010\u000fJ\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0015\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\t\u0010\n¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction$LaunchConversationScreenFromNotification;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction;", "conversationId", "", "proactiveId", "", "(Ljava/lang/String;Ljava/lang/Integer;)V", "getConversationId", "()Ljava/lang/String;", "getProactiveId", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "component1", "component2", "copy", "(Ljava/lang/String;Ljava/lang/Integer;)Lzendesk/messaging/android/internal/messagingscreen/MessagingScreenAction$LaunchConversationScreenFromNotification;", "equals", "", "other", "", "hashCode", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LaunchConversationScreenFromNotification implements MessagingScreenAction {
        private final String conversationId;
        private final Integer proactiveId;

        public LaunchConversationScreenFromNotification() {
            this(null, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0);
        }

        public static LaunchConversationScreenFromNotification copy$default(LaunchConversationScreenFromNotification launchConversationScreenFromNotification, String str, Integer num, int i, Object obj) {
            if ((i & 1) != 0) {
                str = launchConversationScreenFromNotification.conversationId;
            }
            if ((i & 2) != 0) {
                num = launchConversationScreenFromNotification.proactiveId;
            }
            return launchConversationScreenFromNotification.copy(str, num);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Integer getProactiveId() {
            return this.proactiveId;
        }

        public final LaunchConversationScreenFromNotification copy(String conversationId, Integer proactiveId) {
            return new LaunchConversationScreenFromNotification(conversationId, proactiveId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LaunchConversationScreenFromNotification)) {
                return false;
            }
            LaunchConversationScreenFromNotification launchConversationScreenFromNotification = (LaunchConversationScreenFromNotification) other;
            return Intrinsics.areEqual(this.conversationId, launchConversationScreenFromNotification.conversationId) && Intrinsics.areEqual(this.proactiveId, launchConversationScreenFromNotification.proactiveId);
        }

        public int hashCode() {
            String str = this.conversationId;
            int iHashCode = (str == null ? 0 : str.hashCode()) * 31;
            Integer num = this.proactiveId;
            return iHashCode + (num != null ? num.hashCode() : 0);
        }

        public String toString() {
            return "LaunchConversationScreenFromNotification(conversationId=" + this.conversationId + ", proactiveId=" + this.proactiveId + ')';
        }

        public LaunchConversationScreenFromNotification(String str, Integer num) {
            this.conversationId = str;
            this.proactiveId = num;
        }

        public LaunchConversationScreenFromNotification(String str, Integer num, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? null : str, (i & 2) != 0 ? null : num);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Integer getProactiveId() {
            return this.proactiveId;
        }
    }
}
