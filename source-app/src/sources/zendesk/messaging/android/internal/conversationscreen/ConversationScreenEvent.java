package zendesk.messaging.android.internal.conversationscreen;

import java.io.File;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.core.p017ui.android.internal.model.MessageActionSize;

@Metadata(m17d1 = {"\u0000\u001e\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\bp\u0018\u00002\u00020\u0001:\u0004\u0002\u0003\u0004\u0005\u0082\u0001\u0004\u0006\u0007\b\t¨\u0006\n"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;", "", "LaunchConversationExtension", "OpenFileAttachment", "StartPolling", "StopPolling", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$LaunchConversationExtension;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$OpenFileAttachment;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$StartPolling;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$StopPolling;", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface ConversationScreenEvent {

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\u0006\u0010\u0006\u001a\u00020\u0003¢\u0006\u0002\u0010\u0007J\t\u0010\r\u001a\u00020\u0003HÆ\u0003J\t\u0010\u000e\u001a\u00020\u0005HÆ\u0003J\t\u0010\u000f\u001a\u00020\u0003HÆ\u0003J'\u0010\u0010\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00052\b\b\u0002\u0010\u0006\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u0011\u001a\u00020\u00122\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014HÖ\u0003J\t\u0010\u0015\u001a\u00020\u0016HÖ\u0001J\t\u0010\u0017\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0006\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\b\u0010\tR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\u000bR\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\f\u0010\t¨\u0006\u0018"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$LaunchConversationExtension;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;", "url", "", "size", "Lzendesk/core/ui/android/internal/model/MessageActionSize;", "conversationId", "(Ljava/lang/String;Lzendesk/core/ui/android/internal/model/MessageActionSize;Ljava/lang/String;)V", "getConversationId", "()Ljava/lang/String;", "getSize", "()Lzendesk/core/ui/android/internal/model/MessageActionSize;", "getUrl", "component1", "component2", "component3", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class LaunchConversationExtension implements ConversationScreenEvent {
        private final String conversationId;
        private final MessageActionSize size;
        private final String url;

        public static LaunchConversationExtension copy$default(LaunchConversationExtension launchConversationExtension, String str, MessageActionSize messageActionSize, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = launchConversationExtension.url;
            }
            if ((i & 2) != 0) {
                messageActionSize = launchConversationExtension.size;
            }
            if ((i & 4) != 0) {
                str2 = launchConversationExtension.conversationId;
            }
            return launchConversationExtension.copy(str, messageActionSize, str2);
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

        public final LaunchConversationExtension copy(String url, MessageActionSize size, String conversationId) {
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            return new LaunchConversationExtension(url, size, conversationId);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LaunchConversationExtension)) {
                return false;
            }
            LaunchConversationExtension launchConversationExtension = (LaunchConversationExtension) other;
            return Intrinsics.areEqual(this.url, launchConversationExtension.url) && this.size == launchConversationExtension.size && Intrinsics.areEqual(this.conversationId, launchConversationExtension.conversationId);
        }

        public int hashCode() {
            return (((this.url.hashCode() * 31) + this.size.hashCode()) * 31) + this.conversationId.hashCode();
        }

        public String toString() {
            return "LaunchConversationExtension(url=" + this.url + ", size=" + this.size + ", conversationId=" + this.conversationId + ')';
        }

        public LaunchConversationExtension(String url, MessageActionSize size, String conversationId) {
            Intrinsics.checkNotNullParameter(url, "url");
            Intrinsics.checkNotNullParameter(size, "size");
            Intrinsics.checkNotNullParameter(conversationId, "conversationId");
            this.url = url;
            this.size = size;
            this.conversationId = conversationId;
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
    }

    @Metadata(m17d1 = {"\u0000,\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\t\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0002\b\u0002\b\u0086\b\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0005HÆ\u0003J\u001d\u0010\r\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u0005HÆ\u0001J\u0013\u0010\u000e\u001a\u00020\u000f2\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0005HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\n¨\u0006\u0015"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$OpenFileAttachment;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;", "file", "Ljava/io/File;", "mimeType", "", "(Ljava/io/File;Ljava/lang/String;)V", "getFile", "()Ljava/io/File;", "getMimeType", "()Ljava/lang/String;", "component1", "component2", "copy", "equals", "", "other", "", "hashCode", "", "toString", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class OpenFileAttachment implements ConversationScreenEvent {
        private final File file;
        private final String mimeType;

        public static OpenFileAttachment copy$default(OpenFileAttachment openFileAttachment, File file, String str, int i, Object obj) {
            if ((i & 1) != 0) {
                file = openFileAttachment.file;
            }
            if ((i & 2) != 0) {
                str = openFileAttachment.mimeType;
            }
            return openFileAttachment.copy(file, str);
        }

        public final File getFile() {
            return this.file;
        }

        public final String getMimeType() {
            return this.mimeType;
        }

        public final OpenFileAttachment copy(File file, String mimeType) {
            Intrinsics.checkNotNullParameter(file, "file");
            Intrinsics.checkNotNullParameter(mimeType, "mimeType");
            return new OpenFileAttachment(file, mimeType);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof OpenFileAttachment)) {
                return false;
            }
            OpenFileAttachment openFileAttachment = (OpenFileAttachment) other;
            return Intrinsics.areEqual(this.file, openFileAttachment.file) && Intrinsics.areEqual(this.mimeType, openFileAttachment.mimeType);
        }

        public int hashCode() {
            return (this.file.hashCode() * 31) + this.mimeType.hashCode();
        }

        public String toString() {
            return "OpenFileAttachment(file=" + this.file + ", mimeType=" + this.mimeType + ')';
        }

        public OpenFileAttachment(File file, String mimeType) {
            Intrinsics.checkNotNullParameter(file, "file");
            Intrinsics.checkNotNullParameter(mimeType, "mimeType");
            this.file = file;
            this.mimeType = mimeType;
        }

        public final File getFile() {
            return this.file;
        }

        public final String getMimeType() {
            return this.mimeType;
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$StartPolling;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class StartPolling implements ConversationScreenEvent {
        public static final StartPolling INSTANCE = new StartPolling();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof StartPolling)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return -342571091;
        }

        public String toString() {
            return "StartPolling";
        }

        private StartPolling() {
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\bÆ\n\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0013\u0010\u0003\u001a\u00020\u00042\b\u0010\u0005\u001a\u0004\u0018\u00010\u0006HÖ\u0003J\t\u0010\u0007\u001a\u00020\bHÖ\u0001J\t\u0010\t\u001a\u00020\nHÖ\u0001¨\u0006\u000b"}, m18d2 = {"Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent$StopPolling;", "Lzendesk/messaging/android/internal/conversationscreen/ConversationScreenEvent;", "()V", "equals", "", "other", "", "hashCode", "", "toString", "", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class StopPolling implements ConversationScreenEvent {
        public static final StopPolling INSTANCE = new StopPolling();

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof StopPolling)) {
                return false;
            }
            return true;
        }

        public int hashCode() {
            return 2064221493;
        }

        public String toString() {
            return "StopPolling";
        }

        private StopPolling() {
        }
    }
}
