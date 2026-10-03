package zendesk.messaging.android.internal;

import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\u001a\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u0003\u0003\u0004\u0005B\u0007\b\u0004¢\u0006\u0002\u0010\u0002\u0082\u0001\u0003\u0006\u0007\b¨\u0006\t"}, m18d2 = {"Lzendesk/messaging/android/internal/VisibleScreen;", "", "()V", "ConversationListScreen", "ConversationScreen", "ImageViewerScreen", "Lzendesk/messaging/android/internal/VisibleScreen$ConversationListScreen;", "Lzendesk/messaging/android/internal/VisibleScreen$ConversationScreen;", "Lzendesk/messaging/android/internal/VisibleScreen$ImageViewerScreen;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class VisibleScreen {
    public VisibleScreen(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    private VisibleScreen() {
    }

    @Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0006\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\t\u0010\u0007\u001a\u00020\u0003HÆ\u0003J\u0013\u0010\b\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\t\u001a\u00020\n2\b\u0010\u000b\u001a\u0004\u0018\u00010\fHÖ\u0003J\t\u0010\r\u001a\u00020\u000eHÖ\u0001J\t\u0010\u000f\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0005\u0010\u0006¨\u0006\u0010"}, m18d2 = {"Lzendesk/messaging/android/internal/VisibleScreen$ConversationScreen;", "Lzendesk/messaging/android/internal/VisibleScreen;", "conversationId", "", "(Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "component1", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationScreen extends VisibleScreen {
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
            super(null);
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.conversationId = conversationId;
        }

        public final String getConversationId() {
            return this.conversationId;
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/VisibleScreen$ConversationListScreen;", "Lzendesk/messaging/android/internal/VisibleScreen;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ConversationListScreen extends VisibleScreen {
        public static final ConversationListScreen INSTANCE = new ConversationListScreen();

        private ConversationListScreen() {
            super(null);
        }
    }

    @Metadata(m17d1 = {"\u0000\f\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\bÆ\u0002\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002¨\u0006\u0003"}, m18d2 = {"Lzendesk/messaging/android/internal/VisibleScreen$ImageViewerScreen;", "Lzendesk/messaging/android/internal/VisibleScreen;", "()V", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class ImageViewerScreen extends VisibleScreen {
        public static final ImageViewerScreen INSTANCE = new ImageViewerScreen();

        private ImageViewerScreen() {
            super(null);
        }
    }
}
