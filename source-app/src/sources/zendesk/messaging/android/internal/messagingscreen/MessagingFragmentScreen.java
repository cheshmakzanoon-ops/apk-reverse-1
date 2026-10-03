package zendesk.messaging.android.internal.messagingscreen;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0004\u0002\u0003\u0004\u0005\u0082\u0001\u0004\u0006\u0007\b\t¨\u0006\n"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "", "ConversationFragmentScreen", "ConversationListFragmentScreen", "FailedResolvedFragmentScreen", "MainAppScreen", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$ConversationFragmentScreen;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$ConversationListFragmentScreen;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$FailedResolvedFragmentScreen;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$MainAppScreen;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface MessagingFragmentScreen {

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\b\n\u0002\b\u000b\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0002\b\u0003\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u0003\u0012\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\u0002\u0010\u0006J\u000b\u0010\f\u001a\u0004\u0018\u00010\u0003HÆ\u0003J\u0010\u0010\r\u001a\u0004\u0018\u00010\u0005HÆ\u0003¢\u0006\u0002\u0010\nJ&\u0010\u000e\u001a\u00020\u00002\n\b\u0002\u0010\u0002\u001a\u0004\u0018\u00010\u00032\n\b\u0002\u0010\u0004\u001a\u0004\u0018\u00010\u0005HÆ\u0001¢\u0006\u0002\u0010\u000fJ\u0013\u0010\u0010\u001a\u00020\u00112\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013HÖ\u0003J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001J\t\u0010\u0015\u001a\u00020\u0003HÖ\u0001R\u0013\u0010\u0002\u001a\u0004\u0018\u00010\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0015\u0010\u0004\u001a\u0004\u0018\u00010\u0005¢\u0006\n\n\u0002\u0010\u000b\u001a\u0004\b\t\u0010\n¨\u0006\u0016"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$ConversationFragmentScreen;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "conversationId", "", "proactiveId", "", "(Ljava/lang/String;Ljava/lang/Integer;)V", "getConversationId", "()Ljava/lang/String;", "getProactiveId", "()Ljava/lang/Integer;", "Ljava/lang/Integer;", "component1", "component2", "copy", "(Ljava/lang/String;Ljava/lang/Integer;)Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$ConversationFragmentScreen;", "equals", "", "other", "", "hashCode", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationFragmentScreen implements MessagingFragmentScreen {
        private final String conversationId;
        private final Integer proactiveId;

        public ConversationFragmentScreen() {
            this(null, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0);
        }

        public static ConversationFragmentScreen copy$default(ConversationFragmentScreen conversationFragmentScreen, String str, Integer num, int i, Object obj) {
            if ((i & 1) != 0) {
                str = conversationFragmentScreen.conversationId;
            }
            if ((i & 2) != 0) {
                num = conversationFragmentScreen.proactiveId;
            }
            return conversationFragmentScreen.copy(str, num);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Integer getProactiveId() {
            return this.proactiveId;
        }

        public final ConversationFragmentScreen copy(String conversationId, Integer proactiveId) {
            return new ConversationFragmentScreen(conversationId, proactiveId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ConversationFragmentScreen)) {
                return false;
            }
            ConversationFragmentScreen conversationFragmentScreen = (ConversationFragmentScreen) other;
            return Intrinsics.areEqual(this.conversationId, conversationFragmentScreen.conversationId) && Intrinsics.areEqual(this.proactiveId, conversationFragmentScreen.proactiveId);
        }

        public int hashCode() {
            String str = this.conversationId;
            int iHashCode = (str == null ? 0 : str.hashCode()) * 31;
            Integer num = this.proactiveId;
            return iHashCode + (num != null ? num.hashCode() : 0);
        }

        public String toString() {
            return "ConversationFragmentScreen(conversationId=" + this.conversationId + ", proactiveId=" + this.proactiveId + ')';
        }

        public ConversationFragmentScreen(String str, Integer num) {
            this.conversationId = str;
            this.proactiveId = num;
        }

        public ConversationFragmentScreen(String str, Integer num, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this((i & 1) != 0 ? null : str, (i & 2) != 0 ? null : num);
        }

        public final String getConversationId() {
            return this.conversationId;
        }

        public final Integer getProactiveId() {
            return this.proactiveId;
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$ConversationListFragmentScreen;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationListFragmentScreen implements MessagingFragmentScreen {
        public static final ConversationListFragmentScreen INSTANCE = new ConversationListFragmentScreen();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof ConversationListFragmentScreen)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return -1444307617;
        }

        public String toString() {
            return "ConversationListFragmentScreen";
        }

        private ConversationListFragmentScreen() {
        }
    }

    @Metadata(m17d1 = {"\u0000*\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0010HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0011"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$FailedResolvedFragmentScreen;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "error", "", "(Ljava/lang/Throwable;)V", "getError", "()Ljava/lang/Throwable;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class FailedResolvedFragmentScreen implements MessagingFragmentScreen {
        private final Throwable error;

        public static FailedResolvedFragmentScreen copy$default(FailedResolvedFragmentScreen failedResolvedFragmentScreen, Throwable th, int i, Object obj) {
            if ((i & 1) != 0) {
                th = failedResolvedFragmentScreen.error;
            }
            return failedResolvedFragmentScreen.copy(th);
        }

        public final Throwable getError() {
            return this.error;
        }

        public final FailedResolvedFragmentScreen copy(Throwable error) {
            Intrinsics.checkNotNullParameter(error, "error");
            return new FailedResolvedFragmentScreen(error);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            return (other instanceof FailedResolvedFragmentScreen) && Intrinsics.areEqual(this.error, ((FailedResolvedFragmentScreen) other).error);
        }

        public int hashCode() {
            return this.error.hashCode();
        }

        public String toString() {
            return "FailedResolvedFragmentScreen(error=" + this.error + ')';
        }

        public FailedResolvedFragmentScreen(Throwable error) {
            Intrinsics.checkNotNullParameter(error, "error");
            this.error = error;
        }

        public final Throwable getError() {
            return this.error;
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen$MainAppScreen;", "Lzendesk/messaging/android/internal/messagingscreen/MessagingFragmentScreen;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class MainAppScreen implements MessagingFragmentScreen {
        public static final MainAppScreen INSTANCE = new MainAppScreen();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof MainAppScreen)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return 198102930;
        }

        public String toString() {
            return "MainAppScreen";
        }

        private MainAppScreen() {
        }
    }
}
